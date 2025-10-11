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
 * is expected to be the ptr tothe {@link TreeViewEx_Subclass} object set to property
 * {@link TreeViewEx#ParentSubclass}.
 */
TreeViewEx_ParentSubclassProc(HwndSubclass, uMsg, wParam, lParam, uIdSubclass, dwRefData) {
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
            ; (lParam / uIdSubclass).
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
        g_proc_comctl32_DefSubclassProc
      , 'ptr', HwndSubclass
      , 'uint', uMsg
      , 'ptr', wParam
      , 'ptr', lParam
      , 'ptr'
    )
}

TreeViewEx_ControlSubclassProc(HwndSubclass, uMsg, wParam, lParam, uIdSubclass, dwRefData) {
    if uMsg == WM_NCDESTROY {
        TreeViewEx.Get(HwndSubclass).Dispose()
    }
    return DllCall(
        'comctl32\DefSubclassProc'
      , 'ptr', HwndSubclass
      , 'uint', uMsg
      , 'ptr', wParam
      , 'ptr', lParam
      , 'ptr'
    )
}


TreeViewEx_HandlerGetDispInfo(Ctrl, _tvDispInfoEx) {
    if _tvDispInfoEx.mask & TVIF_TEXT {
        Ctrl.__HandlerNameGet.Call(Ctrl, _tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_IMAGE {
        Ctrl.__HandlerImageGet.Call(Ctrl, _tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_SELECTEDIMAGE {
        Ctrl.__HandlerSelectedImageGet.Call(Ctrl, _tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_CHILDREN {
        Ctrl.__HandlerChildrenGet.Call(Ctrl, _tvDispInfoEx)
    }
}
TreeViewEx_HandlerKeyDown(Ctrl, _tvKeyDown) {
    return Ctrl.__HandlerKeyDown.Call(_tvKeyDown)
}
TreeViewEx_HandlerSelChanged(Ctrl, _nmTreeView) {
    return Ctrl.__HandlerSelChanged.Call(_nmTreeView)
}
TreeViewEx_HandlerSelChanging(Ctrl, _nmTreeView) {
    return Ctrl.__HandlerSelChanging.Call(_nmTreeView)
}
TreeViewEx_HandlerSetDispInfo(Ctrl, _tvDispInfoEx) {
    if _tvDispInfoEx.mask & TVIF_TEXT {
        Ctrl.__HandlerNameSet.Call(Ctrl, _tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_IMAGE {
        Ctrl.__HandlerImageSet.Call(Ctrl, _tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_SELECTEDIMAGE {
        Ctrl.__HandlerSelectedImageSet.Call(Ctrl, _tvDispInfoEx)
    }
}
TreeViewEx_GetTreeViewExCtrl(self) {
    return TreeViewEx.Get(self.HwndCtrl)
}
TreeViewEx_GetCtrl(self) {
    return GuiCtrlFromHwnd(self.HwndCtrl)
}
TreeViewEx_CallbackOnExit(Hwnd, *) {
    TreeViewEx.Get(Hwnd).Dispose()
}
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

TreeViewEx_RGB(r := 0, g := 0, b := 0) {
    return (r & 0xFF) | ((g & 0xFF) << 8) | ((b & 0xFF) << 16)
}
TreeViewEx_ParseColorRef(colorref, &OutR?, &OutG?, &OutB?) {
    OutR := colorref & 0xFF
    OutG := (colorref >> 8) & 0xFF
    OutB := (colorref >> 16) & 0xFF
}

TreeViewEx_LabelEditSubclassProc(HwndSubclass, uMsg, wParam, lParam, uIdSubclass, dwRefData) {
    if uMsg == WM_NCDESTROY {
        TreeViewEx_LabelEditDestroyNotification.Process(HwndSubclass)
    }
    return DllCall(
        'comctl32\DefSubclassProc'
      , 'ptr', HwndSubclass
      , 'uint', uMsg
      , 'ptr', wParam
      , 'ptr', lParam
      , 'ptr'
    )
}
