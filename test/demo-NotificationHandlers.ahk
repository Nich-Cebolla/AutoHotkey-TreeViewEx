
; https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/ImageList.ahk
#include <ImageList>

#include <Tracer>

; g_TracerGroup := TracerGroup(TracerOptions({
;     LogFile: {
;         Dir: A_Temp '\TreeViewEx'
;       , Name: 'log'
;       , Ext: 'json'
;     }
;   , Log: {
;         ToJson: true
;       , MaxFiles: 20
;       , MaxSize: 5000
;     }
; }), true)
; t := g_TracerGroup()


#include ..\src\TreeViewEx.ahk

f2::Demo.SendEditLabel()
f3::Demo.SendEndEditLabel(true)
f4::Demo.SendEndEditLabel(false)

Demo()

class Demo {
    static Call() {
        ; This is our example object that we are using to construct the nodes
        this.List := [
            {
                Name: 'obj1'
              , Children: [
                    { Name: 'obj1-1', Children: [ 'obj1-1-1' ] }
                  , { Name: 'obj1-2', Children: [ 'obj1-2-1' ] }
                  , { Name: 'obj1-3', Children: [ { Name: 'obj1-3-1', Children: [
                        'obj1-3-1-1', 'obj1-3-1-2', 'obj1-3-1-3', { Name: 'obj1-3-1-4', Children: [ 'obj1-3-1-4-1' ] }
                    ] } ] }
                ]
            }
          , ValueWithoutNameProp([ ValueWithoutNameProp(), { Name: 'obj2-2', Children: [ ] } ])
        ]

        ; Create Gui
        g := this.g := Gui('+Resize')

        ; Add TreeViewEx
        tv := this.tv := TreeViewEx(
            g.Hwnd
          , {
                Width: 600
              , Rows: 20
              , Style: TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT | TVS_SHOWSELALWAYS | WS_CHILD | WS_CLIPSIBLINGS | WS_VISIBLE | TVS_EDITLABELS
              , ExStyle: TVS_EX_DOUBLEBUFFER | WS_EX_COMPOSITED
            }
        )

        ; Set the node constructor
        tv.SetNodeConstructor(DemoTreeViewExNode)

        ; Set handlers
        tv.OnNotify(TVN_BEGINLABELEDITW, TreeViewEx_HandlerBeginLabelEdit_Node_Ptr)
        tv.OnNotify(TVN_DELETEITEMW, TreeViewEx_HandlerDeleteItem_Node_Ptr)
        tv.OnNotify(TVN_GETDISPINFOW, TreeViewEx_HandlerGetDispInfo_Node_Ptr)
        tv.OnNotify(TVN_ENDLABELEDITW, TreeViewEx_HandlerEndLabelEdit_Node_Ptr)
        ; tv.OnNotify(TVN_GETINFOTIPW, TreeViewEx_HandlerGetInfoTip_Node_Ptr)
        tv.OnNotify(TVN_ITEMCHANGEDW, TreeViewEx_HandlerItemChanged_Node_Ptr)
        tv.OnNotify(TVN_ITEMCHANGINGW, TreeViewEx_HandlerItemChanging_Node_Ptr)
        tv.OnNotify(TVN_ITEMEXPANDEDW, TreeViewEx_HandlerItemExpanded_Node_Ptr)
        tv.OnNotify(TVN_ITEMEXPANDINGW, TreeViewEx_HandlerItemExpanding_Node_Ptr)
        tv.OnNotify(TVN_SETDISPINFOW, TreeViewEx_HandlerSetDispInfo_Node_Ptr)

        ; This block handles getting the paths to the various example icon files used for testing
        ; This example currently only uses one size of file, but I've included the other sizes here
        ; because I intend to extend this example to include swapping out the files when the DPI changes
        paths := this.paths := Map('20', [], '25', [], '30', [], '35', [], '40', [])
        loop Files 'icons\*.ico' {
            if RegExMatch(A_LoopFileName, '^\d+', &match) {
                paths.Get(match[0]).Push(A_LoopFileFullPath)
            }
        }

        ; Set image list
        listPath := this.paths.Get('20')
        imgList := this.ImageList := ImageList(listPath)
        ; tv.SetImageList(TVSIL_NORMAL, imgList.Handle)
        ; tv.SetImageList(TVSIL_STATE, imgList.Handle)
        ; Add root items
        struct := DemoTreeViewExNode.Prototype.InsertStruct
        for obj in this.List {
            tv.AddNode(struct, obj)
        }

        g.Show('x20 w600 y20 h600')
        ; add other controls
        tv.GetPos(&x, &y, &w, &h)
        g.Add('Button', 'section x' x ' y' (y + h + 10) ' vBtnDisposeTreeView', 'DisposeTreeView').OnEvent('Click', HClickButtonDisposeTreeView)
        g.Add('Button', 'ys vBtnDisposeWindowSubclass', 'DisposeWindowSubclass').OnEvent('Click', HClickButtonDisposeWindowSubclass)
        g.Add('Button', 'ys vBtnSendSetDispInfo', 'SendSetDispInfo').OnEvent('Click', (*) => Demo.SendSetDispInfo())
        g.Add('Button', 'ys vBtnExit', 'Exit').OnEvent('Click', (*) => ExitApp())
        ; Show Gui
        WinRedraw(g.Hwnd)

        return

        HClickButtonGetText(Ctrl, *) {
            g := Ctrl.Gui
            tv := g['Tv']
            struct := TvItem()
            struct.mask := TVIF_HANDLE | TVIF_TEXT
            for handle, parent in tv.EnumChildrenRecursive() {
                struct.hItem := handle
                SendMessage(TVM_GETITEMW, 0, struct.Ptr, tv.Hwnd)
                OutputDebug('Tick: ' A_TickCount ', Func: ' 'Button GetText: ' struct.pszText '`n')
            }
        }
        HClickButtonDisposeTreeView(Ctrl, *) {
            Demo.tv.Dispose()
        }
        HClickButtonDisposeWindowSubclass(*) {
            TreeViewExWindowSubclassManager.Collection.Get(Demo.g.Hwnd).Dispose()
        }
    }
    static SendEditLabel() {
        this.tv.EditSelectedLabel()
    }
    static SendEndEditLabel(value) {
        this.tv.EndEditLabel(value)
    }
    static SendSetDispInfo() {
        struct := TvDispInfoEx()
        struct.mask := TVIF_TEXT
        struct.code := TVN_SETDISPINFOW
        struct.idFrom := 0
        struct.hwndFrom := this.tv.Hwnd
        struct.cchTextMax := 260
        for k, node in Demo.Tv.Collection {
            if not node.Value is ValueWithoutNameProp {
                _node := node
                break
            }
        }
        struct.lParam := ObjPtr(_node)
        struct.pszText := 'TEST'
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : pszText == ' struct.pszText '`n')
        _windowSubclass := TreeViewExWindowSubclassManager.Collection.Get(this.g.Hwnd).WindowSubclass
        TreeViewEx_SubclassProc(
            this.g.Hwnd
          , WM_NOTIFY
          , 0
          , struct.Buffer.Ptr
          , _windowSubclass.uIdSubclass
          , _windowSubclass.dwRefData
        )
    }
}

class DemoTreeViewExNode extends TreeViewExNode {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.__ShowTooltip := ShowTooltip({ Mode: 'A' })
        proto.StateFlags := Map(
            'TVIS_BOLD', TVIS_BOLD, 'TVIS_CUT', TVIS_CUT
          , 'TVIS_DROPHILITED', TVIS_DROPHILITED, 'TVIS_EXPANDED', TVIS_EXPANDED
          , 'TVIS_EXPANDEDONCE', TVIS_EXPANDEDONCE, 'TVIS_EXPANDPARTIAL', TVIS_EXPANDPARTIAL
          , 'TVIS_SELECTED', TVIS_SELECTED, 'TVIS_OVERLAYMASK', TVIS_OVERLAYMASK
          , 'TVIS_STATEIMAGEMASK', TVIS_STATEIMAGEMASK, 'TVIS_USERMASK', TVIS_USERMASK
        )
        proto.__TooltipNumber := ''
        struct := proto.InsertStruct := TvInsertStruct()
        ; struct.iImage := struct.iSelectedImage := I_IMAGECALLBACK
        struct.pszText := LPSTR_TEXTCALLBACKW
        struct.cChildren := I_CHILDRENCALLBACK
        struct.cchTextMax := 0
        ; struct.mask := TVIF_CHILDREN | TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_TEXT | TVIF_PARAM
        struct.mask := TVIF_CHILDREN | TVIF_TEXT | TVIF_PARAM
        struct.hParent := 0
        struct.hInsertAfter := TVI_LAST
    }
    __New(Handle, Value) {
        this.Handle := Handle
        this.Value := Value
        if IsObject(Value) {
            this.ImageGroup := 1
            this.SelectedImageGroup := 1
        } else {
            this.ImageGroup := 2
            this.SelectedImageGroup := 2
        }
    }
    OnBeginLabelEdit(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        ; This will just display a tooltip by the item.
        rc := this.GetRect()
        rc.ToScreen(this.HwndTv, true)
        this.__TooltipNumber := this.ShowTooltip('Editing item for ' this.OnGetInfoName(Struct), { End: 0, X: rc.R + 3, Y: rc.T })
    }
    OnDeleteItem(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        ObjRelease(Struct.lParam_old)
    }
    OnEndLabelEdit(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        ; Get coordinates to display tooltip
        rc := this.GetRect()
        rc.ToScreen(this.HwndTv, true)
        if this.__TooltipNumber {
            ToolTip(, , , this.__TooltipNumber)
            this.__TooltipNumber := ''
        }
        if IsObject(this.Value) {
            ; If the object has a property "Name", update the value
            if HasProp(this.Value, 'Name') {
                this.Value.Name := Struct.pszText
            ; If no property "Name", reject the change.
            } else {
                this.ShowTooltip('Unable to set the item`'s label.', { X: rc.R + 3, Y: rc.T })
                return 0
            }
        } else {
            ; Update the value
            this.Value := Struct.pszText
        }
        this.ShowTooltip('Updated the item to: ' Struct.pszText, { X: rc.R + 3, Y: rc.T })
        WinRedraw(this.HwndTv)
        return 1
    }
    OnGetInfoChildren(Struct) {
        ; OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        if IsObject(this.Value) && HasProp(this.Value, 'Children') && this.Value.Children is Array && this.Value.Children.Length {
            return 1
        } else {
            return 0
        }
    }
    OnGetInfoImage(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        switch this.ImageGroup, 0 {
            case 1: return 1
            case 2: return 3
        }
    }
    OnGetInfoName(Struct) {
        ; OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        if IsObject(this.Value) {
            if HasProp(this.Value, 'Name') {
                if IsNumber(this.Value.Name) {
                    return String(this.Value.Name)
                } else {
                    return '"' this.Value.Name '"'
                }
            } else {
                return '{ ' Type(this.Value) ' }'
            }
        } else if IsNumber(this.Value) {
            return String(this.Value)
        } else {
            return '"' this.Value '"'
        }
    }
    OnGetInfoSelectedImage(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        switch this.ImageGroup, 0 {
            case 1: return 2
            case 2: return 4
        }
    }
    OnGetInfoTip(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        text := 'Tooltip for ' this.OnGetInfoName(Struct)
        Struct.pszText := text
        Struct.cchTextMax := StrPut(text, TVEX_DEFAULT_ENCODING)
    }
    OnItemChanged(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        new := Struct.uStateNew
        old := Struct.uStateOld
        for name, flag in this.StateFlags {
            if (new & flag) != (old & flag) {
                OutputDebug('Tick: ' A_TickCount ', Func: ' name ' changed.`n')
            }
        }
        return 0
    }
    OnItemChanging(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        new := Struct.uStateNew
        old := Struct.uStateOld
        for name, flag in this.StateFlags {
            if (new & flag) != (old & flag) {
                OutputDebug('Tick: ' A_TickCount ', Func: ' name ' changed.`n')
            }
        }
        return 0
    }
    OnItemExpanded(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        ; Get coordinates to display tooltip
        rc := this.GetRect()
        rc.ToScreen(this.HwndTv, true)
        switch Struct.action {
            case TVE_COLLAPSE, TVE_COLLAPSERESET:
                this.ShowTooltip('Collapsed item ' this.OnGetInfoName(Struct), { X: rc.R + 3, Y: rc.T })
            case TVE_EXPAND:
                this.ShowTooltip('Expanded item ' this.OnGetInfoName(Struct), { X: rc.R + 3, Y: rc.T })
            ; I'm not sure how to handle `TVE_EXPANDEDPARTIAL`.
            case TVE_EXPANDPARTIAL: throw Error('Invalid operation.', -1)
        }
    }
    OnItemExpanding(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        if Struct.action == TVE_TOGGLE {
            if this.IsExpanded {
                Value := TVE_COLLAPSE
            } else {
                Value := TVE_EXPAND
            }
        }
        ctrl := this.Ctrl
        switch Struct.action {
            case TVE_COLLAPSE, TVE_COLLAPSERESET:
                ; We'll delete all children to keep memory low
                ; If a child node is currently selected, we have to un-select it
                ctrl.Select(0)
                for child in ctrl.EnumChildren(this.Handle) {
                    ctrl.DeleteItem(child)
                }
                _struct := TvItem()
                _struct.mask := TVIF_HANDLE | TVIF_STATE
                _struct.hItem := this.Handle
                _struct.state := 0
                _struct.stateMask := TVIS_EXPANDED
                this.Ctrl.SetItem(_struct)
            case TVE_EXPAND:
                ; Add items
                struct := this.InsertStruct
                struct.hParent := this.Handle
                for child in this.Value.Children {
                    ctrl.AddNode(struct, child)
                }
            ; I'm not sure how to handle `TVE_EXPANDEDPARTIAL`.
            case TVE_EXPANDPARTIAL: throw Error('Invalid operation.', -1)
        }
    }
    OnSetInfoImage(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
    }
    OnSetInfoName(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        if IsObject(this.Value) {
            ; If the object has a property "Name", update the value
            if HasProp(this.Value, 'Name') {
                this.Value.Name := Struct.pszText
            ; In our example, this is an invalid operation so we throw an error.
            ; If we define our code correctly, this should never occur.
            } else {
                throw Error('Invalid operation.', -1)
            }
        } else {
            ; Update the value
            this.Value := Struct.pszText
        }
    }
    OnSetInfoSelectedImage(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
    }
    ; OnSingleExpand(Struct) {
    ;     TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    ; }
    ShowTooltip(Str, Options?) {
        return this.__ShowTooltip.Call(Str, Options ?? unset)
    }
    __Delete() {
        OutputDebug('Deleted`n')
    }
}

class ValueWithoutNameProp {
    __New(Children := '') {
        this.Children := Children
    }
}

/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/ShowTooltip.ahk
    Author: Nich-Cebolla
    License: MIT
*/

class ShowTooltip {
    /**
     * By default, `ShowTooltip.Numbers` is an array with integers 1-20, and is used to track which
     * tooltip id numbers are available and which are in use. If tooltips are created from multiple
     * sources, then the list is invalid because it may not know about every existing tooltip. To
     * overcome this, `ShowTooltip.Numbers` can be set with an array that is shared by other objects,
     * sharing the pool of available id numbers.
     *
     * All instances of `ShowTooltip` will inherently draw from the same array, and so calling
     * `ShowTooltip.SetNumbersList` is unnecessary if the objects handling tooltip creation are all
     * `ShowTooltip` objects.
     */
    static SetNumbersList(List) {
        this.Numbers := List
    }
    static DefaultOptions := {
        Duration: 2000
      , X: 0
      , Y: 0
      , Mode: 'Mouse' ; Mouse / Absolute (M/A)
    }
    static Numbers := [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

    /**
     * @param {Object} [DefaultOptions] - An object with zero or more options as property : value pairs.
     * These options are used when a corresponding option is not passed to {@link ShowTooltip.Prototype.Call}.
     * @param {Integer} [DefaultOptions.Duration = 2000] - The duration in milliseconds for which the
     * tooltip displayed. A value of 0 causes the tooltip to b e dislpayed indefinitely until
     * {@link ShowTooltip.Prototype.End} is called with the tooltip number. Negative and positive
     * values are treated the same.
     * @param {Integer} [DefaultOptions.X = 0] - If `DefaultOptions.Mode == "Mouse"` (or "M"), a number
     * of pixels to add to the X-coordinate. If `DefaultOptions.Mode == "Absolute"` (or "A"), the
     * X-coordinate relative to the screen.
     * @param {Integer} [DefaultOptions.Y = 0] - If `DefaultOptions.Mode == "Mouse"` (or "M"), a number
     * of pixels to add to the Y-coordinate. If `DefaultOptions.Mode == "Absolute"` (or "A"), the
     * Y-coordinate relative to the screen.
     * @param {String} [DefaultOptions.Mode = "Mouse"] - One of the following:
     * - "Mouse" or "M" - The tooltip is displayed near the mouse cursor.
     * - "Absolute" or "A" - The tooltip is displayed at the screen coordinates indicated by the
     * options.
     */
    __New(DefaultOptions?) {
        if IsSet(DefaultOptions) {
            o := this.DefaultOptions := {}
            d := ShowTooltip.DefaultOptions
            for p in d.OwnProps()  {
                o.%p% := HasProp(DefaultOptions, p) ? DefaultOptions.%p% : d.%p%
            }
        } else {
            this.DefaultOptions := ShowTooltip.DefaultOptions.Clone()
        }
    }
    /**
     * @param {String} Str - The string to display.
     *
     * @param {Object} [Options] - An object with zero or more options as property : value pairs.
     * If a value is absent, the corresponding value from `ShowTooltipObj.DefaultOptions` is used.
     * @param {Integer} [Options.Duration] - The duration in milliseconds for which the
     * tooltip displayed. A value of 0 causes the tooltip to b e dislpayed indefinitely until
     * {@link ShowTooltip.Prototype.End} is called with the tooltip number. Negative and positive
     * values are treated the same.
     * @param {Integer} [Options.X] - If `Options.Mode == "Mouse"` (or "M"), a number
     * of pixels to add to the X-coordinate. If `Options.Mode == "Absolute"` (or "A"), the
     * X-coordinate relative to the screen.
     * @param {Integer} [Options.Y] - If `Options.Mode == "Mouse"` (or "M"), a number
     * of piYels to add to the Y-coordinate. If `Options.Mode == "Absolute"` (or "A"), the
     * Y-coordinate relative to the screen.
     * @param {String} [Options.Mode] - One of the following:
     * - "Mouse" or "M" - The tooltip is displayed near the mouse cursor.
     * - "Absolute" or "A" - The tooltip is displayed at the screen coordinates indicated by the
     * options.
     *
     * @returns {Integer} - The tooltip number used for the tooltip. If the duration is 0, pass
     * the number to {@link ShowTooltip.Prototype.End} to end the tooltip. Otherwise, you do not need
     * to save the tooltip number, but the tooltip number can be used to target the tooltip when calling
     * `ToolTip`.
     */
    Call(Str, Options?) {
        if ShowTooltip.Numbers.Length {
            n := ShowTooltip.Numbers.Pop()
        } else {
            throw Error('The maximum number of concurrent tooltips (20) has been reached.', -1)
        }
        if IsSet(Options) {
            Get := _Get1
        } else {
            Get := _Get2
        }
        T := CoordMode('Tooltip', 'Screen')
        switch SubStr(Get('Mode'), 1, 1), 0 {
            case 'M':
                M := CoordMode('Mouse', 'Screen')
                MouseGetPos(&X, &Y)
                ToolTip(Str, X + Get('X'), Y + Get('Y'), n)
                CoordMode('Mouse', M)
            case 'A':
                ToolTip(Str, Get('X'), Get('Y'), n)
        }
        CoordMode('Tooltip', T)
        duration := -Abs(Get('Duration'))
        if duration {
            SetTimer(ObjBindMethod(this, 'End', n), duration)
        }

        return n

        _Get1(prop) {
            return HasProp(Options, prop) ? Options.%prop% : this.DefaultOptions.%prop%
        }
        _Get2(prop) {
            return this.DefaultOptions.%prop%
        }
    }
    End(n) {
        ToolTip(,,,n)
        ShowTooltip.Numbers.Push(n)
    }
    /**
     * @param {Object} [DefaultOptions] - An object with zero or more options as property : value pairs.
     * These options are used when a corresponding option is not passed to {@link ShowTooltip.Prototype.Call}.
     * The existing default options are overwritten with the new object.
     */
    SetDefaultOptions(DefaultOptions) {
        this.DefaultOptions := DefaultOptions
    }
}
