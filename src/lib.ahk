/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

/**
 * {@link https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nc-commctrl-subclassproc}
 *
 * The {@link TreeViewEx} class is completely custom-built; it does not inherit from `Gui.TreeView`
 * nor `Gui.Control`. Consequently, {@link TreeViewEx} instances are unable to be used with
 * `Gui.Control.Prototype.OnCommand`, `Gui.Control.Prototype.OnNotify`, and `Gui.Control.Prototype.OnEvent`.
 *
 * To monitor, intercept, and handle system commands, notifications, and window messages,
 * this library uses {@link https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-setwindowsubclass SetWindowSubclass},
 * facilitated by the {@link TreeViewEx_WindowSubclass} class.
 * {@link TreeViewEx_ParentSubclassProc} is the function that is called for messages sent to the
 * {@link TreeViewEx} object's parent window, i.e. the gui.
 *
 * {@link TreeViewEx_ParentSubclassProc} expects that {@link TreeViewEx_ParentSubclassProc~uIdSubclass}
 * is the hwnd to a {@link TreeViewEx} control, and that {@link TreeViewEx_ParentSubclassProc~dwRefData}
 * is the ptr to the {@link TreeViewEx_Subclass} object set to property
 * {@link TreeViewEx#ParentSubclass}. This is done automatically when
 * {@link TreeViewEx.Prototype.OnCommand}, {@link TreeViewEx.Prototype.OnNotify},
 * or {@link TreeViewEx.Prototype.OnMessage} is called.
 *
 * {@link TreeViewEx_Subclass} allows for any single code to have multiple callbacks. The callbacks
 * are called one at a time, and if any of the callbacks return a nonzero value, that halts processing
 * and {@link TreeViewEx_ParentSubclassProc} returns that value instead of calling `DefSubclassProc`.
 * If all callbacks return zero or an empty string, `DefSubclassProc` is called.
 *
 * @param {Integer} HwndSubclass - The handle to the subclassed window (the handle passed to `SetWindowSubclass`).
 * This is expected to be the handle to the gui window to which the {@link TreeViewEx} control was added.
 *
 * @param {Integer} uMsg - The message being passed.
 *
 * @param {Integer} wParam - Additional message information. The contents of this parameter depend
 * on the value of uMsg.
 *
 * @param {Integer} lParam - Additional message information. The contents of this parameter depend on the value of uMsg.
 *
 * @param {Integer} uIdSubclass - The subclass ID. This is expected to be the hwnd to a {@link TreeViewEx}
 * control.
 *
 * @param {Integer} dwRefData - The reference data provided to the SetWindowSubclass function. This
 * is expected to be the ptr to the {@link TreeViewEx_Subclass} object set to property
 * {@link TreeViewEx#ParentSubclass}.
 */
TreeViewEx_ParentSubclassProc(HwndSubclass, uMsg, wParam, lParam, uIdSubclass, dwRefData) {
    Critical('Off')
    subclass := ObjFromPtrAddRef(dwRefData)
    switch uMsg {
        case WM_COMMAND:
            ; In this case, we don't need the control ID (low word wParam value). The control ID
            ; has the advantage of being defined by the application and consistent across sessions,
            ; whereas the hwnd changes every time the control is created.
            ; For example, if I create a custom dialogue with an OK button, I would assign the same
            ; ID to the button every time it is created. Then, in my window procedure, I can target
            ; the button using that ID. In the case of this function and the TreeViewEx library,
            ; control IDs are not used (unless defined by the caller) and the "OnCommand" logic
            ; targets the control using the parent hwnd (HwndSubclass) and control hwnd
            ; (uIdSubclass).
            if subclass.flag_Command {
                if collectionCallback := subclass.CommandGet((wParam >> 16) & 0xFFFF) {
                    tvex := TreeViewEx.Get(uIdSubclass)
                    for cb in collectionCallback {
                        if result := cb(tvex) {
                            return result
                        }
                    }
                }
            }
        case WM_NOTIFY:
            if subclass.flag_Notify {
                hdr := TvNmHdr.FromPtr(lParam)
                if collectionCallback := subclass.NotifyGet(hdr.code_int) {
                    struct := hdr.Cast()
                    tvex := TreeViewEx.Get(uIdSubclass)
                    for cb in collectionCallback {
                        if result := cb(tvex, struct) {
                            return result
                        }
                    }
                }
            }
        default:
            if subclass.flag_Message {
                if collectionCallback := subclass.MessageGet(uMsg) {
                    tvex := TreeViewEx.Get(uIdSubclass)
                    for cb in collectionCallback {
                        if result := cb(tvex, wParam, lParam, uMsg, HwndSubclass) {
                            return result
                        }
                    }
                }
            }
    }
    return DllCall(
        g_comctl32_DefSubclassProc
      , 'ptr', HwndSubclass
      , 'uint', uMsg
      , 'uptr', wParam
      , 'ptr', lParam
      , 'ptr'
    )
}

/**
 * Destroys the TreeViewEx object when the control window is destroyed.
 */
TreeViewEx_ControlSubclassProc(HwndSubclass, uMsg, wParam, lParam, uIdSubclass, dwRefData) {
    Critical('Off')
    if uMsg == WM_NCDESTROY {
        TreeViewEx.Get(HwndSubclass).Dispose()
    }
    return DllCall(
        g_comctl32_DefSubclassProc
      , 'ptr', HwndSubclass
      , 'uint', uMsg
      , 'uptr', wParam
      , 'ptr', lParam
      , 'ptr'
    )
}

/**
 * Returns the TreeViewEx object using the hwnd set to property "HwndControl". This function is
 * used in the body of {@link TreeViewEx.Prototype.SetNodeConstructor}. This is analagous
 * to the native `GuiCtrlFromHwnd`.
 */
TreeViewEx_GetTreeViewExCtrl(self) {
    return TreeViewEx.Get(self.HwndCtrl)
}

/**
 * Destroys the TreeViewEx object when the script is exiting. This is necessary to avoid errors
 * from {@link TreeViewEx_ParentSubclassProc}.
 */
TreeViewEx_CallbackOnExit(Hwnd, *) {
    TreeViewEx.Get(Hwnd).Dispose()
}

/**
 * Displays the context menu.
 */
TreeViewEx_HandlerContextMenu(tvex, wParam, lParam, *) {
    MouseGetPos(&mx, &my)
    x := lParam & 0xFFFF
    y := (lParam >> 16) & 0xFFFF
    ; If the context menu was activated by a keyboard button instead of right-click
    if x = -1 && y = -1 {
        handle := tvex.GetSelected()
        rc := tvex.GetItemRect(handle)
        x := rc.L
        y := rc.T
        IsRightClick := 0
    ; If the context menu was activated by right-click
    } else {
        pt := Point(X, Y)
        pt.ToClient(tvex.Hwnd, true)
        if hitTestInfo := tvex.HitTest(pt.X, pt.Y) {
            handle := hitTestInfo.hItem
        } else {
            handle := 0
        }
        IsRightClick := 1
        x := pt.X
        y := pt.Y
    }
    tvex.ContextMenu.Call(tvex, Handle, IsRightClick, X, Y)
}

/**
 * Returns a COLORREF integer.
 *
 * @param {Integer} [r = 0] - The red value.
 * @param {Integer} [g = 0] - The green value.
 * @param {Integer} [b = 0] - The blue value.
 * @returns {Integer}
 */
TreeViewEx_RGB(r := 0, g := 0, b := 0) {
    return (r & 0xFF) | ((g & 0xFF) << 8) | ((b & 0xFF) << 16)
}

/**
 * Parses a COLORREF integer.
 *
 * @param {Integer} colorref - The COLORREF integer.
 * @param {VarRef} [OutR] - A variable that will receive the red value.
 * @param {VarRef} [OutG] - A variable that will receive the green value.
 * @param {VarRef} [OutB] - A variable that will receive the blue value.
 */
TreeViewEx_ParseColorRef(colorref, &OutR?, &OutG?, &OutB?) {
    OutR := colorref & 0xFF
    OutG := (colorref >> 8) & 0xFF
    OutB := (colorref >> 16) & 0xFF
}

/**
 * Calls a callback when the edit control from an edit label action is destroyed. See
 * {@link TreeViewEx_LabelEditDestroyNotification.Prototype.__New}.
 */
TreeViewEx_LabelEditSubclassProc(HwndSubclass, uMsg, wParam, lParam, uIdSubclass, dwRefData) {
    Critical('Off')
    if uMsg == WM_NCDESTROY {
        TreeViewEx_LabelEditDestroyNotification.Process(HwndSubclass)
    }
    return DllCall(
        g_comctl32_DefSubclassProc
      , 'ptr', HwndSubclass
      , 'uint', uMsg
      , 'uptr', wParam
      , 'ptr', lParam
      , 'ptr'
    )
}

/**
 * Deselects any selected items when the mouse is not on-top of an item.
 */
TreeViewEx_OnClick(tvex, *) {
    if hitTestInfo := tvex.HitTest() {
        if !hitTestInfo.hItem {
            tvex.Select(0)
        }
    }
}

/**
 * A {@link Container} CallbackValue function for the property "Hwnd".
 */
TreeViewEx_CallbackValue_Hwnd(value) {
    return value.Hwnd
}

/**
 * A {@link Container} CallbackValue function for the property "Handle".
 */
TreeViewEx_CallbackValue_Handle(value) {
    return value.Handle
}

/**
 * A {@link Container} CallbackValue function for the property "Code".
 */
TreeViewEx_CallbackValue_Code(value) {
    return value.Code
}
