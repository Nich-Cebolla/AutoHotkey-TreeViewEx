
#SingleInstance force

#include ..\src\VENV.ahk

!esc::ExitApp()

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
        tvex := this.tvex := TreeViewEx(
            g
          , {
                Width: 550
              , Rows: 20
              , Style: TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT | TVS_SHOWSELALWAYS | WS_CHILD
                    | WS_CLIPSIBLINGS | WS_VISIBLE | TVS_EDITLABELS | WS_BORDER
            }
        )

        ; Set the node constructor
        tvex.SetNodeConstructor(DemoTreeViewEx_Node)

        ; Set handlers
        tvex.OnNotify(TVN_BEGINLABELEDITW, TreeViewEx_HandlerBeginLabelEdit_Node_Ptr)
        tvex.OnNotify(TVN_DELETEITEMW, TreeViewEx_HandlerDeleteItem_Node_Ptr)
        tvex.OnNotify(TVN_GETDISPINFOW, TreeViewEx_HandlerGetDispInfo_Node_Ptr)
        tvex.OnNotify(TVN_ENDLABELEDITW, TreeViewEx_HandlerEndLabelEdit_Node_Ptr)
        ; tvex.OnNotify(TVN_GETINFOTIPW, TreeViewEx_HandlerGetInfoTip_Node_Ptr)
        tvex.OnNotify(TVN_ITEMCHANGEDW, TreeViewEx_HandlerItemChanged_Node_Ptr)
        tvex.OnNotify(TVN_ITEMCHANGINGW, TreeViewEx_HandlerItemChanging_Node_Ptr)
        tvex.OnNotify(TVN_ITEMEXPANDEDW, TreeViewEx_HandlerItemExpanded_Node_Ptr)
        tvex.OnNotify(TVN_ITEMEXPANDINGW, TreeViewEx_HandlerItemExpanding_Node_Ptr)
        tvex.OnNotify(TVN_SETDISPINFOW, TreeViewEx_HandlerSetDispInfo_Node_Ptr)

        ; This block handles getting the paths to the various example icon files used for testing
        ; The image file list code needs more work, not working correctly at the moment
        ; paths := this.paths := Map('20', [], '25', [], '30', [], '35', [], '40', [])
        ; loop Files 'icons\*.ico' {
        ;     if RegExMatch(A_LoopFileName, '^\d+', &match) {
        ;         paths.Get(match[0]).Push(A_LoopFileFullPath)
        ;     }
        ; }

        ; Set image list
        ; listPath := this.paths.Get('20')
        ; imgList := this.ImageList := ImageList(listPath)
        ; tvex.SetImageList(TVSIL_NORMAL, imgList.Handle)
        ; tvex.SetImageList(TVSIL_STATE, imgList.Handle)

        ; Add the root nodes. Our TVN_GETDISPINFO handler tells the system that the nodes have children
        ; so the tree-view control displays the + symbol next to the node even though the child nodes
        ; don't actually exist yet. Our TVN_ITEMEXPANDING handler adds the nodes when the
        ; user clicks the +. This is to conserve some resources and also to have more control over
        ; the tree-view's behavior.
        struct := DemoTreeViewEx_Node.Prototype.InsertStruct
        for obj in this.List {
            tvex.AddNode(struct, obj)
        }

        tvex.GetPos(&x, &y, &w, &h)
        g.Add('Button', 'section x' x ' y' (y + h + 10) ' vBtnExit', 'Exit').OnEvent('Click', _Exit)
        g.Show('x20 w600 y20 h600')

        return

        _Exit(*) {
            ExitApp()
        }
    }
}

class DemoTreeViewEx_Node extends TreeViewEx_Node {
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
        proto.__TooltipNumber := proto.Handle := ''
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
    __New(Value) {
        this.Value := Value
        if IsObject(Value) {
            this.ImageGroup := 1
        } else {
            this.ImageGroup := 2
        }
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc '; Node: ' this.Handle '`n')
    }
    OnBeginLabelEdit(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        ; This will just display a tooltip by the item.
        rc := this.GetRect()
        rc.ToScreen(this.HwndCtrl, true)
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
        rc.ToScreen(this.HwndCtrl, true)
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
        WinRedraw(this.HwndCtrl)
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
            case 2: return 2
        }
    }
    OnGetInfoName(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
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
            case 1: return 3
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
                OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc '; Flag name: ' name ' changed.`n')
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
        rc.ToScreen(this.HwndCtrl, true)
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
        } else {
            Value := Struct.action
        }
        ctrl := this.Ctrl
        switch Value {
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





/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/ImageList.ahk
    Author: Nich-Cebolla
    License: MIT
*/

class ImageList extends ImageStack {
    static __New() {
        global GDIPBITMAP_DEFAULT_ENCODING
        this.DeleteProp('__New')
        if !IsSet(ILC_COLOR32) {
            this.__SetConstants()
        }
        this.LibToken := 0
        this.__InitializeProcedureVars()
        this.LoadLibrary()
        proto := this.Prototype
        protoImageStack := ImageStack.Prototype
        for prop in ['AddFromBitmap', 'AddFromPath', 'AddListFromBitmap', 'AddListFromPath'] {
            proto.DefineProp('__' prop, protoImageStack.GetOwnPropDesc(prop))
        }
        proto.Handle := 0
    }
    static LoadLibrary() {
        if !this.LibToken {
            this.LibToken := LibraryManager(Map(
                'comctl32'
              , [
                    'ImageList_Create'
                  , 'ImageList_Destroy'
                ;   , 'ImageList_GetImageCount'
                ;   , 'ImageList_SetImageCount'
                  , 'ImageList_Add'
                ;   , 'ImageList_ReplaceIcon'
                ;   , 'ImageList_SetBkColor'
                ;   , 'ImageList_GetBkColor'
                ;   , 'ImageList_SetOverlayImage'
                ;   , 'ImageList_Draw'
                ;   , 'ImageList_Replace'
                ;   , 'ImageList_AddMasked'
                ;   , 'ImageList_DrawEx'
                ;   , 'ImageList_DrawIndirect'
                  , 'ImageList_Remove'
                ;   , 'ImageList_GetIcon'
                ;   , 'ImageList_LoadImageA'
                ;   , 'ImageList_LoadImageW'
                ;   , 'ImageList_Copy'
                ;   , 'ImageList_BeginDrag'
                ;   , 'ImageList_EndDrag'
                ;   , 'ImageList_DragEnter'
                ;   , 'ImageList_DragLeave'
                ;   , 'ImageList_DragMove'
                ;   , 'ImageList_SetDragCursorImage'
                ;   , 'ImageList_DragShowNolock'
                ;   , 'ImageList_Read'
                ;   , 'ImageList_Write'
                ;   , 'ImageList_ReadEx'
                ;   , 'ImageList_WriteEx'
                ;   , 'ImageList_Merge'
                ;   , 'ImageList_Duplicate'
                ]
            ))
        }
    }
    static FreeLibrary() {
        this.LibToken.Free()
        this.LibToken := 0
    }
    static __InitializeProcedureVars() {
        global g_proc_comctl32_ImageList_Create
        , g_proc_comctl32_ImageList_Destroy
        ; , g_proc_comctl32_ImageList_GetImageCount
        ; , g_proc_comctl32_ImageList_SetImageCount
        , g_proc_comctl32_ImageList_Add
        ; , g_proc_comctl32_ImageList_ReplaceIcon
        ; , g_proc_comctl32_ImageList_SetBkColor
        ; , g_proc_comctl32_ImageList_GetBkColor
        ; , g_proc_comctl32_ImageList_SetOverlayImage
        ; , g_proc_comctl32_ImageList_Draw
        ; , g_proc_comctl32_ImageList_Replace
        ; , g_proc_comctl32_ImageList_AddMasked
        ; , g_proc_comctl32_ImageList_DrawEx
        ; , g_proc_comctl32_ImageList_DrawIndirect
        , g_proc_comctl32_ImageList_Remove
        ; , g_proc_comctl32_ImageList_GetIcon
        ; , g_proc_comctl32_ImageList_LoadImageA
        ; , g_proc_comctl32_ImageList_LoadImageW
        ; , g_proc_comctl32_ImageList_Copy
        ; , g_proc_comctl32_ImageList_BeginDrag
        ; , g_proc_comctl32_ImageList_EndDrag
        ; , g_proc_comctl32_ImageList_DragEnter
        ; , g_proc_comctl32_ImageList_DragLeave
        ; , g_proc_comctl32_ImageList_DragMove
        ; , g_proc_comctl32_ImageList_SetDragCursorImage
        ; , g_proc_comctl32_ImageList_DragShowNolock
        ; , g_proc_comctl32_ImageList_Read
        ; , g_proc_comctl32_ImageList_Write
        ; , g_proc_comctl32_ImageList_ReadEx
        ; , g_proc_comctl32_ImageList_WriteEx
        ; , g_proc_comctl32_ImageList_Merge
        ; , g_proc_comctl32_ImageList_Duplicate
        if !IsSet(g_proc_comctl32_ImageList_Create) {
            g_proc_comctl32_ImageList_Create := 0
        }
        if !IsSet(g_proc_comctl32_ImageList_Destroy) {
            g_proc_comctl32_ImageList_Destroy := 0
        }
        ; if !IsSet(g_proc_comctl32_ImageList_GetImageCount) {
        ;     g_proc_comctl32_ImageList_GetImageCount := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_SetImageCount) {
        ;     g_proc_comctl32_ImageList_SetImageCount := 0
        ; }
        if !IsSet(g_proc_comctl32_ImageList_Add) {
            g_proc_comctl32_ImageList_Add := 0
        }
        ; if !IsSet(g_proc_comctl32_ImageList_ReplaceIcon) {
        ;     g_proc_comctl32_ImageList_ReplaceIcon := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_SetBkColor) {
        ;     g_proc_comctl32_ImageList_SetBkColor := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_GetBkColor) {
        ;     g_proc_comctl32_ImageList_GetBkColor := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_SetOverlayImage) {
        ;     g_proc_comctl32_ImageList_SetOverlayImage := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_Draw) {
        ;     g_proc_comctl32_ImageList_Draw := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_Replace) {
        ;     g_proc_comctl32_ImageList_Replace := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_AddMasked) {
        ;     g_proc_comctl32_ImageList_AddMasked := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_DrawEx) {
        ;     g_proc_comctl32_ImageList_DrawEx := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_DrawIndirect) {
        ;     g_proc_comctl32_ImageList_DrawIndirect := 0
        ; }
        if !IsSet(g_proc_comctl32_ImageList_Remove) {
            g_proc_comctl32_ImageList_Remove := 0
        }
        ; if !IsSet(g_proc_comctl32_ImageList_GetIcon) {
        ;     g_proc_comctl32_ImageList_GetIcon := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_LoadImageA) {
        ;     g_proc_comctl32_ImageList_LoadImageA := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_LoadImageW) {
        ;     g_proc_comctl32_ImageList_LoadImageW := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_Copy) {
        ;     g_proc_comctl32_ImageList_Copy := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_BeginDrag) {
        ;     g_proc_comctl32_ImageList_BeginDrag := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_EndDrag) {
        ;     g_proc_comctl32_ImageList_EndDrag := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_DragEnter) {
        ;     g_proc_comctl32_ImageList_DragEnter := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_DragLeave) {
        ;     g_proc_comctl32_ImageList_DragLeave := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_DragMove) {
        ;     g_proc_comctl32_ImageList_DragMove := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_SetDragCursorImage) {
        ;     g_proc_comctl32_ImageList_SetDragCursorImage := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_DragShowNolock) {
        ;     g_proc_comctl32_ImageList_DragShowNolock := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_Read) {
        ;     g_proc_comctl32_ImageList_Read := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_Write) {
        ;     g_proc_comctl32_ImageList_Write := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_ReadEx) {
        ;     g_proc_comctl32_ImageList_ReadEx := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_WriteEx) {
        ;     g_proc_comctl32_ImageList_WriteEx := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_Merge) {
        ;     g_proc_comctl32_ImageList_Merge := 0
        ; }
        ; if !IsSet(g_proc_comctl32_ImageList_Duplicate) {
        ;     g_proc_comctl32_ImageList_Duplicate := 0
        ; }

    }
    static __SetConstants() {
        global
        ILC_MASK              := 0x00000001  ; Use a mask. The image list contains two bitmaps, one of
                                             ; which is a monochrome bitmap used as a mask. If this
                                             ; value is not included, the image list contains only one
                                             ; bitmap.
        ILC_COLOR             := 0x00000000  ; Use the default behavior if none of the other
                                             ; ILC_COLORx flags is specified. Typically, the default
                                             ; is ILC_COLOR4, but for older display drivers, the
                                             ; default is ILC_COLORDDB.
        ILC_COLORDDB          := 0x000000FE  ; Use a device-dependent bitmap.
        ILC_COLOR4            := 0x00000004  ; Use a 4-bit (16-color) device-independent bitmap (DIB)
                                             ; section as the bitmap for the image list.
        ILC_COLOR8            := 0x00000008  ; Use an 8-bit DIB section. The colors used for the color
                                             ; table are the same colors as the halftone palette.
        ILC_COLOR16           := 0x00000010  ; Use a 16-bit (32/64k-color) DIB section.
        ILC_COLOR24           := 0x00000018  ; Use a 24-bit DIB section.
        ILC_COLOR32           := 0x00000020  ; Use a 32-bit DIB section.
        ; ILC_PALETTE           := 0x00000800  ; Not implemented.
        ILC_MIRROR            := 0x00002000  ; Mirror the icons contained, if the process is mirrored.
        ILC_PERITEMMIRROR     := 0x00008000  ; Causes the mirroring code to mirror each item when
                                             ; inserting a set of images, versus the whole strip.
        ILC_ORIGINALSIZE      := 0x00010000  ; Windows Vista and later. Imagelist should accept
                                             ; smaller than set images and apply original size based
                                             ; on image added.
        ; ILC_HIGHQUALITYSCALE  := 0x00020000  ; Windows Vista and later. Reserved.
    }
    /**
     * @param {String[]|Integer[]} List - An array of values to use to construct the {@link GdipBitmap}
     * objects. The type of values in the array depend on the value of parameter `ItemType`.
     *
     * @param {Integer} [ItemType = 1] - One of the following:
     * - 1: The values in `List` are file paths as string.
     * - 2: The values in `List` are pointers to bitmap objects as integers.
     *
     * @param {Object} [Options] - An object with zero or more options as property : value pairs.
     * @param {Integer} [Options.Background = 0xFFFFFFFF] - A COLORREF value to pass to
     * {@link GdipBitmap.Prototype.GetHBitmap} which calls `GdipCreateHBITMAPFromBitmap`.
     * @param {Integer} [Options.Flags = ILC_COLOR32] - One or more of the image list creation
     * flags. See {@link ImageList.__SetConstants} or
     * {@link https://learn.microsoft.com/en-us/windows/desktop/Controls/ilc-constants}.
     * @param {Integer} [Options.GrowCount = 1] - The number of images by which the image list can
     * grow when the system needs to make room for new images. This parameter represents the number
     * of new images that the resized image list can contain.
     *
     */
    __New(List, ItemType := 1, Options?) {
        options := ImageList.Options(Options ?? unset)
        this.Background := options.Background
        switch ItemType, 0 {
            case 1: this.__AddListFromPath(List)
            case 2: this.__AddListFromBitmap(List)
        }
        this.Handle := DllCall(
            g_proc_comctl32_ImageList_Create
          , 'int', this[1].Width
          , 'int', this[1].Height
          , 'uint', options.Flags
          , 'int', this.Length
          , 'int', options.GrowCount
          , 'ptr'
        )
        hbmMask := options.hbmMask
        switch ItemType, 0 {
            case 1:
                for img in this {
                    hBitmap := img.GetHBitmap(this.Background)
                    result := DllCall(g_proc_comctl32_ImageList_Add, 'ptr', this.Handle, 'ptr', hBitmap, 'ptr', hbmMask, 'int')
                    if result == -1 {
                        throw Error('Failed to load image.', -1, 'path: ' img.Path)
                    }
                    img.DeleteBitmap()
                    img.DeleteHBitmap()
                }
            case 2:
                for img in this {
                    hBitmap := img.GetHBitmap(this.Background)
                    result := DllCall(g_proc_comctl32_ImageList_Add, 'ptr', this.Handle, 'ptr', hBitmap, 'ptr', hbmMask, 'int')
                    if result == -1 {
                        throw Error('Failed to load image.', -1, 'pBitmap: ' img.pBitmap)
                    }
                    img.DeleteHBitmap()
                }
        }
    }
    AddFromBitmap(pBitmap, hbmMask := 0, Background?) {
        img := this.__AddFromBitmap(pBitmap)
        hBitmap := img.GetHBitmap(Background ?? this.Background)
        result := DllCall(g_proc_comctl32_ImageList_Add, 'ptr', this.Handle, 'ptr', hBitmap, 'ptr', hbmMask, 'int')
        if result == -1 {
            this.Pop()
        }
        img.DeleteHBitmap()
        return result
    }
    AddListFromBitmap(List, hbmMask := 0, Background?, FailureAction := 1) {
        for pBitmap in List {
            result := this.AddFromBitmap(pBitmap, hbmMask, Background ?? unset)
            if result == -1 {
                switch FailureAction, 0 {
                    case 1: throw Error('Failed to add image to image list.', -1, 'pBitmap: ' pBitmap)
                    case 2: return -1
                    case 3: continue
                    default: throw ValueError('Invalid ``FailureAction``.', -1, FailureAction)
                }
            }
        }
    }
    AddListFromPath(List, hbmMask := 0, Background?, FailureAction := 1) {
        for path in List {
            result := this.AddFromPath(path, hbmMask, Background ?? unset)
            if result == -1 {
                switch FailureAction, 0 {
                    case 1: throw Error('Failed to add image to image list.', -1, 'path: ' path)
                    case 2: return -1
                    case 3: continue
                    default: throw ValueError('Invalid ``FailureAction``.', -1, FailureAction)
                }
            }
        }
    }
    AddFromPath(ImagePath, hbmMask := 0, Background?) {
        img := this.__AddFromPath(ImagePath, false)
        hBitmap := img.GetHBitmap(Background ?? this.Background)
        result := DllCall(g_proc_comctl32_ImageList_Add, 'ptr', this.Handle, 'ptr', hBitmap, 'ptr', hbmMask, 'int')
        if result == -1 {
            this.Pop()
        }
        img.DeleteHBitmap()
        img.DeleteBitmap()
        return result
    }
    Dispose(ClearArray := false) {
        if ClearArray {
            this.Length := 0
        }
        if this.Handle {
            Handle := this.Handle
            this.Handle := 0
            return DllCall(g_proc_comctl32_ImageList_Destroy, 'ptr', Handle, 'int')
        } else {
            return -1
        }
    }
    /**
     * @param {Integer} Index - The 1-based index of the image to remove.
     * @returns {GdipBitmap} - The {@link GdipBitmap} object if it was successfully removed. If
     * `ImageList_Remove` failed, returns an empty string.
     */
    Remove(Index) {
        img := this[Index]
        if result := DllCall(g_proc_comctl32_ImageList_Remove, 'ptr', this.Handle, 'int', Index - 1, 'int') {
            this.RemoveAt(Index)
            return img
        }
    }
    RemoveAll(ClearArray := false) {
        if ClearArray {
            this.Length := 0
        }
        return DllCall(g_proc_comctl32_ImageList_Remove, 'ptr', this.Handle, 'int', -1, 'int')
    }
    __Delete() {
        if this.Handle {
            DllCall(g_proc_comctl32_ImageList_Destroy, 'ptr', this.Handle, 'int')
        }
    }

    class Options {
        static __New() {
            this.DeleteProp('__New')
            if !IsSet(ILC_COLOR32) {
                ImageList.__SetConstants()
            }
            this.Default := {
                Background: 0xFFFFFFFF
              , Flags: ILC_COLOR32
              , GrowCount: 1
              , hbmMask: 0
            }
        }
        static Call(Options?) {
            if IsSet(Options) {
                o := {}
                d := this.Default
                for prop in d.OwnProps() {
                    o.%prop% := HasProp(Options, prop) ? Options.%prop% : d.%prop%
                }
                return o
            } else {
                return this.Default.Clone()
            }
        }
    }
}

/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/ImageStack.ahk
    Author: Nich-Cebolla
    License: MIT
*/

class ImageStack extends Array {
    /**
     * @param {String[]|Integer[]} List - An array of values to use to construct the {@link GdipBitmap}
     * objects. The type of values in the array depend on the value of parameter `ItemType`.
     *
     * @param {Integer} [ItemType = 1] - One of the following:
     * - 1: The values in `List` are file paths as string.
     * - 2: The values in `List` are pointers to bitmap objects as integers.
     *
     * @param {Boolean} [Load = true] - `Load` is passed to the second parameter
     * of {@link ImageStack.Prototype.AddListFromPath} if `ItemType == 1`, and is ignored in all
     * other cases.
     */
    __New(List, ItemType := 1, Load := true) {
        switch ItemType, 0 {
            case 1: this.AddListFromPath(List, Load)
            case 2: this.AddListFromBitmap(List)
        }
    }
    AddFromBitmap(pBitmap) {
        this.Push(GdipBitmap.FromBitmap(pBitmap))
        return this[-1]
    }
    AddListFromBitmap(List) {
        for pBitmap in List {
            this.Push(GdipBitmap.FromBitmap(pBitmap))
        }
    }
    AddListFromPath(List, Load := true) {
        for path in List {
            this.Push(GdipBitmap(path, Load))
        }
    }
    AddFromPath(ImagePath, Load := false) {
        this.Push(GdipBitmap(ImagePath, Load))
        return this[-1]
    }
    DeleteBitmap() {
        for i in this {
            i.DeleteBitmap()
        }
    }
    DeleteHBitmap() {
        for i in this {
            i.DeleteHBitmap()
        }
    }
    /**
     * @param {String|Integer} Value - The value used to find the object to delete.
     * @param {Integer} [ItemType = 1] - One of the following:
     * - 1: `Value` is the file path.
     * - 2: `Value` is the pointer to the bitmap object ("pBitmap").
     * - 3: `Value` is the HBITMAP ("hBitmap").
     * @returns {GdipBitmap} - The deleted {@link GdipBitmap} object.
     */
    DeleteObject(Value, ItemType := 1) {
        switch ItemType, 0 {
            case 1:
                for i in this {
                    if i.Path = Value {
                        this.RemoveAt(A_Index)
                        return i
                    }
                }
            case 2:
                for i in this {
                    if i.pBitmap = Value {
                        this.RemoveAt(A_Index)
                        return i
                    }
                }
            case 3:
                for i in this {
                    if i.hBitmap = Value {
                        this.RemoveAt(A_Index)
                        return i
                    }
                }
        }
    }
    Dispose() {
        this.FreeResources()
        this.Length := 0
    }
    FreeResources() {
        for i in this {
            i.Dispose()
        }
    }
    GetBitmapFromFile() {
        for i in this {
            i.GetBitmapFromFile()
        }
    }
    GetHBitmap(Background := 0xFFFFFFFF) {
        for i in this {
            i.GetHBitmap(Background)
        }
    }
    LoadImage() {
        for i in this {
            i.LoadImage()
        }
    }
    /**
     * Sorts the images by one dimension.
     * @param {String} [Dimension = "Width"] - Either "Width" or "Height".
     * @param {Integer} [Direction = 1] - One of the following:
     * - 1: Sorts in ascending order (index 1 is the smallest length).
     * - -1: Sorts in descending order (index 1 is the greatest length).
     */
    Sort(Dimension := 'Width', Direction := 1) {
        i := 1
        loop this.Length - 1 {
            current := this[++i]
            j := i - 1
            loop j {
                if (this[j].%Dimension% - current.%Dimension%) * Direction < 0 {
                    break
                }
                this[j + 1] := this[j--]
            }
            this[j + 1] := Current
        }
    }
    __Delete() {
        this.Dispose()
    }
}
/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/GdipBitmap.ahk
    Author: Nich-Cebolla
    License: MIT
*/

class GdipBitmap {
    static __New() {
        global GDIPBITMAP_DEFAULT_ENCODING
        this.DeleteProp('__New')
        if !IsSet(GDIPBITMAP_DEFAULT_ENCODING) {
            GDIPBITMAP_DEFAULT_ENCODING := 'cp1200'
        }
        this.GdipStartup := this.LibToken := 0
        this.__InitializeProcedureVars()
        this.LoadLibrary()
    }
    static LoadLibrary() {
        if !this.GdipStartup {
            this.GdipStartup := GdipStartup()
        }
        if !this.LibToken {
            this.LibToken := LibraryManager(Map(
                'gdiplus', ['GdipDisposeImage', 'GdipLoadImageFromFile', 'GdipGetImageHeight'
                  , 'GdipGetImageWidth', 'GdipCreateBitmapFromFile', 'GdipCreateHBITMAPFromBitmap']
              , 'gdi32', ['DeleteObject']
            ))
        }
    }
    static FreeLibrary() {
        this.GdipStartup.Shutdown()
        this.LibToken.Free()
        this.GdipStartup := this.LibToken := 0
    }
    static FromBitmap(pBitmap) {
        img := { pBitmap: pBitmap }
        ObjSetBase(img, this.Prototype)
        return img
    }
    static __InitializeProcedureVars() {
        global
        if !IsSet(g_proc_gdiplus_GdipDisposeImage) {
            g_proc_gdiplus_GdipDisposeImage := 0
        }
        if !IsSet(g_proc_gdiplus_GdipLoadImageFromFile) {
            g_proc_gdiplus_GdipLoadImageFromFile := 0
        }
        if !IsSet(g_proc_gdiplus_GdipGetImageHeight) {
            g_proc_gdiplus_GdipGetImageHeight := 0
        }
        if !IsSet(g_proc_gdiplus_GdipGetImageWidth) {
            g_proc_gdiplus_GdipGetImageWidth := 0
        }
        if !IsSet(g_proc_gdiplus_GdipCreateBitmapFromFile) {
            g_proc_gdiplus_GdipCreateBitmapFromFile := 0
        }
        if !IsSet(g_proc_gdiplus_GdipCreateHBITMAPFromBitmap) {
            g_proc_gdiplus_GdipCreateHBITMAPFromBitmap := 0
        }
        if !IsSet(g_proc_gdi32_DeleteObject) {
            g_proc_gdi32_DeleteObject := 0
        }
    }
    __New(Path, Load := false) {
        this.__Path := Buffer(StrPut(Path, GDIPBITMAP_DEFAULT_ENCODING))
        StrPut(Path, this.__Path, GDIPBITMAP_DEFAULT_ENCODING)
        if Load {
            this.LoadImage()
        }
    }
    DeleteBitmap() {
        if this.pBitmap {
            if status := DllCall(g_proc_gdiplus_GdipDisposeImage, 'ptr', this.pBitmap, 'uint') {
                throw OSError('``GdipDisposeImage`` failed.', -1, 'status: ' status)
            }
            this.pBitmap := 0
        } else {
            throw Error('The bitmap has not been created.', -1)
        }
    }
    DeleteHBitmap() {
        if this.hBitmap {
            if !DllCall(g_proc_gdi32_DeleteObject, 'ptr', this.hBitmap, 'uint'){
                throw OSError()
            }
            this.hBitmap := 0
        } else {
            throw Error('The HBITMAP has not been created.', -1)
        }
    }
    Dispose() {
        if this.hBitmap {
            DllCall(g_proc_gdi32_DeleteObject, 'ptr', this.hBitmap, 'uint')
            this.hBitmap := 0
        }
        if this.pBitmap {
            DllCall(g_proc_gdiplus_GdipDisposeImage, 'ptr', this.pBitmap, 'int')
            this.pBitmap := 0
        }
    }
    GetAspectRatio(Digits := 2, &OutWidth?, &OutHeight?) {
        w := Abs(this.Width)
        h := Abs(this.Height)

        if w {
            if h {
                ; Euclidean algorithm (GCD)
                a := w
                b := h
                while (b) {
                    t := Mod(a, b)
                    a := b
                    b := t
                }
                g := a  ; gcd
                if Mod(w, g) {
                    OutWidth := Round(w / g, Digits)
                } else {
                    OutWidth := Round(w / g, 0)
                }
                if Mod(h, g) {
                    OutHeight := Round(h / g, Digits)
                } else {
                    OutHeight := Round(h / g, 0)
                }
                return OutWidth ':' OutHeight
            } else {
                OutWidth := 1
                OutHeight := 0
                return '1:0'
            }
        } else {
            if h {
                OutWidth := 0
                OutHeight := 1
                return '0:1'
            } else {
                OutWidth := 0
                OutHeight := 0
                return '0:0'
            }
        }
    }
    GetBitmapFromFile() {
        if !this.pBitmap {
            if status := DllCall(g_proc_gdiplus_GdipCreateBitmapFromFile, 'ptr', this.__Path, 'ptr', this.__pBitmap, 'uint') {
                throw OSError('GdipCreateBitmapFromFile failed.', -1, 'status: ' status)
            }
        }
        return this.pBitmap
    }
    GetHBitmap(Background := 0xFFFFFFFF) {
        if !this.hBitmap {
            if !this.pBitmap {
                if status := DllCall(g_proc_gdiplus_GdipCreateBitmapFromFile, 'ptr', this.__Path, 'ptr', this.__pBitmap, 'uint') {
                    throw OSError('GdipCreateBitmapFromFile failed.', -1, 'status: ' status)
                }
            }
            if status := DllCall(g_proc_gdiplus_GdipCreateHBITMAPFromBitmap, 'ptr', this.pBitmap, 'ptr', this.__hBitmap, 'uint', Background, 'uint') {
                throw OSError('GdipCreateHBITMAPFromBitmap failed.', -1, 'status: ' status)
            }
        }
        return this.hBitmap
    }
    LoadImage() {
        if !this.pBitmap {
            if status := DllCall(g_proc_gdiplus_GdipLoadImageFromFile, 'ptr', this.__Path, 'ptr', this.__pBitmap, 'uint') {
                throw OSError('GdipLoadImageFromFile failed.', -1, 'status: ' status)
            }
        }
        return this.pBitmap
    }
    __Delete() {
        this.Dispose()
    }
    AspectRatio => this.Width / this.Height
    Height {
        Get {
            h := 0
            if status := DllCall(g_proc_gdiplus_GdipGetImageHeight, 'ptr', this.pBitmap, 'uint*', &h, 'int') {
                throw OSError('GdipGetImageHeight failed.', -1, 'status: ' status)
            }
            return h
        }
    }
    hBitmap {
        Get {
            if !this.HasOwnProp('__hBitmap') {
                this.__hBitmap := GdipBitmap_hBitmap()
            }
            this.DefineProp('hBitmap', GdipBitmap.Prototype.GetOwnPropDesc('__hBitmap__'))
            return this.hBitmap
        }
        Set {
            if !this.HasOwnProp('__hBitmap') {
                this.__hBitmap := GdipBitmap_hBitmap()
            }
            this.DefineProp('hBitmap', GdipBitmap.Prototype.GetOwnPropDesc('__hBitmap__'))
            this.hBitmap := Value
        }
    }
    Path {
        Get => StrGet(this.__Path, GDIPBITMAP_DEFAULT_ENCODING)
        Set {
            bytes := StrPut(Value, GDIPBITMAP_DEFAULT_ENCODING)
            if bytes > this.__Path.Size {
                this.__Path.Size := bytes
            }
            StrPut(Value, this.__Path, GDIPBITMAP_DEFAULT_ENCODING)
        }
    }
    pBitmap {
        Get {
            if !this.HasOwnProp('__pBitmap') {
                this.__pBitmap := GdipBitmap_pBitmap()
            }
            this.DefineProp('pBitmap', GdipBitmap.Prototype.GetOwnPropDesc('__pBitmap__'))
            return this.pBitmap
        }
        Set {
            if !this.HasOwnProp('__pBitmap') {
                this.__pBitmap := GdipBitmap_pBitmap()
            }
            this.DefineProp('pBitmap', GdipBitmap.Prototype.GetOwnPropDesc('__pBitmap__'))
            this.pBitmap := Value
        }
    }
    Width {
        Get {
            w := 0
            if status := DllCall(g_proc_gdiplus_GdipGetImageWidth, 'ptr', this.pBitmap, 'uint*', &w, 'int') {
                throw OSError('GdipGetImageWidth failed.', -1, 'status: ' status)
            }
            return w
        }
    }
    __hBitmap__ {
        Get => NumGet(this.__hBitmap, 0, 'ptr')
        Set => NumPut('ptr', Value, this.__hBitmap, 0)
    }
    __pBitmap__ {
        Get => NumGet(this.__pBitmap, 0, 'ptr')
        Set => NumPut('ptr', Value, this.__pBitmap, 0)
    }
}

class GdipBitmap_pBitmap extends GdipBitmap_BufferBase {
}
class GdipBitmap_hBitmap extends GdipBitmap_BufferBase {
}
class GdipBitmap_BufferBase extends Buffer {
    __New() {
        this.Size := A_PtrSize
        NumPut('ptr', 0, this)
    }
}
/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/LibraryManager.ahk
    Author: Nich-Cebolla
    License: MIT
*/

/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/GdipStartup.ahk
    Author: Nich-Cebolla
    License: MIT
*/

/**
 * @classdesc -
 * The benefit to using {@link GdipStartup} to handle initializing and terminating Gdiplus is that each
 * caller is responsible for managing its own token and its own gdiplus reference, and that
 * responsibility is encapsulated in an easy-to-use class.
 *
 * The Windows API that handles calls to `LoadLibrary` and `FreeLibrary` uses a reference count system.
 * If a library has already been loaded by a process, and if `LoadLibrary` is called for that same
 * library again, the reference count is incremented. When `FreeLibrary` is called, the reference count
 * is decremented. If the reference count reaches 0, the library is actually unloaded. The handle
 * returned by `LoadLibrary` is the same each time.
 *
 * The Windows API that handles calls to `GdiplusStartup` and `GdiplusShutdown` works slightly
 * differently. The token returned by `GdiplusStartup` is different for each call.
 *
 * Using {@link GdipStartup} is straightforward: Each subprocess should obtain its own reference to a
 * {@link GdipStartup} object. When that subprocess is no longer needed, or when that subprocess no
 * longer needs GDI+, it should call {@link GdipStartup.Prototype.Shutdown}. The subprocess can
 * maintain its {@link GdipStartup} object; if GDI+ is needed again in the future, simply call
 * {@link GdipStartup.Prototype.Startup} to obtain a new token.
 *
 * With this approach, there are never any issues with one subprocess freeing GDI+ when another
 * subprocess still needs access to it.
 */
class GdipStartup {
    static __New() {
        global g_proc_gdiplus_GdiplusShutdown, g_proc_gdiplus_GdiplusStartup
        this.DeleteProp('__New')
        this.Prototype.LibToken := 0
        if !IsSet(g_proc_gdiplus_GdiplusShutdown) {
            g_proc_gdiplus_GdiplusShutdown := 0
        }
        if !IsSet(g_proc_gdiplus_GdiplusStartup) {
            g_proc_gdiplus_GdiplusStartup := 0
        }
    }
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/api/gdiplusinit/nf-gdiplusinit-gdiplusstartup}
     * @param {Boolean} [Startup = true] - If true, {@link GdipStartup.Prototype.Startup} is called.
     * @param {Integer} [DebugEventCallback = 0] - See
     * {@link https://learn.microsoft.com/en-us/windows/desktop/api/gdiplusinit/ns-gdiplusinit-gdiplusstartupinput GdiplusStartupInput}
     * for info.
     * @param {Integer} [SuppressBackgroundThread = 0] - See
     * {@link https://learn.microsoft.com/en-us/windows/desktop/api/gdiplusinit/ns-gdiplusinit-gdiplusstartupinput GdiplusStartupInput}
     * for info.
     */
    __New(Startup := true, DebugEventCallback := 0, SuppressBackgroundThread := 0) {
        this.Input := GdiplusStartupInput(DebugEventCallback, SuppressBackgroundThread)
        this.__Token := GdiplusToken()
        if Startup {
            this.Startup()
        }
    }
    Startup() {
        if this.Token {
            throw Error('The Gdiplus token is already active.', -1)
        } else {
            this.LibToken := LibraryManager(Map('gdiplus', ['GdiplusStartup', 'GdiplusShutdown']))
            if this.Input.SuppressBackgroundThread {
                if !this.HasOwnProp('Output') {
                    this.Output := GdiplusStartupOutput()
                }
                if status := DllCall(g_proc_gdiplus_GdiplusStartup, 'ptr', this.__Token, 'ptr', this.Input, 'ptr', this.Output, 'uint') {
                    throw OSError('``GdiplusStartup`` failed.', -1, 'Status: ' status)
                }
            } else if status := DllCall(g_proc_gdiplus_GdiplusStartup, 'ptr', this.__Token, 'ptr', this.Input, 'ptr', 0, 'uint') {
                throw OSError('``GdiplusStartup`` failed.', -1, 'Status: ' status)
            }
        }
    }
    Shutdown() {
        if this.Token {
            DllCall(g_proc_gdiplus_GdiplusShutdown, 'ptr', this.Token)
            this.LibToken.Free()
            this.Token := this.LibToken := 0
            if this.HasOwnProp('Output') {
                this.Output.NotificationUnhook := this.Output.NotificationHook := 0
            }
        } else {
            throw Error('There is no Gdiplus token to shutdown.', -1)
        }
    }
    Hook() {
        if !this.HasOwnProp('__NotificationHookToken') {
            this.__NotificationHookToken := GdipNotificationHookToken()
        }
        if this.NotificationHookToken {
            throw Error('The notification hook proc has already been called.', -1)
        } else {
            DllCall(this.Output.NotificationHook, 'ptr', this.__NotificationHookToken)
        }
    }
    Unhook() {
        if this.NotificationHookToken {
            DllCall(this.Output.NotificationUnhook, 'ptr', this.__NotificationHookToken)
            this.NotificationHookToken := 0
        } else {
            throw Error('The notification hook proc has not been called.', -1)
        }
    }
    NotificationHookToken {
        Get => NumGet(this.__NotificationHookToken, 0, 'ptr')
        Set => NumPut('ptr', Value, this.__NotificationHookToken, 0)
    }
    Token {
        Get => NumGet(this.__Token, 0, 'ptr')
        Set => NumPut('ptr', Value, this.__Token, 0)
    }
    __Delete() {
        if this.Token {
            DllCall('gdiplus\GdiplusShutdown', 'ptr', this.Token)
        }
        if this.LibToken {
            this.LibToken.Free()
        }
    }
}

class GdiplusStartupInput {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.cbSize :=
        ; Size      Type                Symbol                      Offset               Padding
        A_PtrSize + ; UINT32            GdiplusVersion              0                    +4 on x64 only
        A_PtrSize + ; DebugEventProc    DebugEventCallback          0 + A_PtrSize * 1
        4 +         ; BOOL              SuppressBackgroundThread    0 + A_PtrSize * 2
        4           ; BOOL              SuppressExternalCodecs      4 + A_PtrSize * 2
        proto.offset_GdiplusVersion            := 0
        proto.offset_DebugEventCallback        := 0 + A_PtrSize * 1
        proto.offset_SuppressBackgroundThread  := 0 + A_PtrSize * 2
        proto.offset_SuppressExternalCodecs    := 4 + A_PtrSize * 2
    }
    /**
     * {@link https://learn.microsoft.com/en-us/windows/desktop/api/gdiplusinit/ns-gdiplusinit-gdiplusstartupinput}
     */
    __New(DebugEventCallback := 0, SuppressBackgroundThread := 0) {
        this.Buffer := Buffer(this.cbSize)
        this.GdiplusVersion := 1
        this.DebugEventCallback := DebugEventCallback
        this.SuppressBackgroundThread := SuppressBackgroundThread
        this.SuppressExternalCodecs := 0
    }
    GdiplusVersion {
        Get => NumGet(this.Buffer, this.offset_GdiplusVersion, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_GdiplusVersion)
        }
    }
    DebugEventCallback {
        Get => NumGet(this.Buffer, this.offset_DebugEventCallback, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_DebugEventCallback)
        }
    }
    SuppressBackgroundThread {
        Get => NumGet(this.Buffer, this.offset_SuppressBackgroundThread, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_SuppressBackgroundThread)
        }
    }
    SuppressExternalCodecs {
        Get => NumGet(this.Buffer, this.offset_SuppressExternalCodecs, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_SuppressExternalCodecs)
        }
    }
    Ptr => this.Buffer.Ptr
    Size => this.Buffer.Size
}

class GdiplusStartupOutput {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.cbSize :=
        ; Size      Type                        Symbol                Offset               Padding
        A_PtrSize + ; NotificationHookProc      NotificationHook      0
        A_PtrSize   ; NotificationUnhookProc    NotificationUnhook    0 + A_PtrSize * 1
        proto.offset_NotificationHook    := 0
        proto.offset_NotificationUnhook  := 0 + A_PtrSize * 1
    }
    __New(NotificationHook?, NotificationUnhook?) {
        this.Buffer := Buffer(this.cbSize)
        if IsSet(NotificationHook) {
            this.NotificationHook := NotificationHook
        }
        if IsSet(NotificationUnhook) {
            this.NotificationUnhook := NotificationUnhook
        }
    }
    NotificationHook {
        Get => NumGet(this.Buffer, this.offset_NotificationHook, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_NotificationHook)
        }
    }
    NotificationUnhook {
        Get => NumGet(this.Buffer, this.offset_NotificationUnhook, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_NotificationUnhook)
        }
    }
    Ptr => this.Buffer.Ptr
    Size => this.Buffer.Size
}

class GdiplusToken extends Buffer {
    __New() {
        this.Size := A_PtrSize
        NumPut('ptr', 0, this)
    }
}

class GdipNotificationHookToken extends Buffer {
    __New() {
        this.Size := A_PtrSize
        NumPut('ptr', 0, this)
    }
}
