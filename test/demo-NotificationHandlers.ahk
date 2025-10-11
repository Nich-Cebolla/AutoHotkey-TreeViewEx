
#SingleInstance force

#include ..\src\VENV.ahk

!esc::ExitApp()
f2::SendLabelEditBegin()

Demo()

class Demo {
    static Call() {

        ; Create Gui
        g := this.g := Gui('+Resize')

        ; Add TreeViewEx
        ; We are enabling TVS_EDITLABELS, press f2 with an item selected to edit the label.
        ; The code will only allow the user to edit labels for objects with names.
        ; We are also enabling TVS_INFOTIP to demonstrate how to customize the tooltip when the mouse
        ; hovers over an item.
        tvex := this.tvex := TreeViewEx(g, { Width: 550, Rows: 21, AddStyle: TVS_EDITLABELS | TVS_INFOTIP })

        ; Set the node constructor
        tvex.SetNodeConstructor(DemoTreeViewEx_Node)

        ; Set handlers. Since we are using a TreeViewEx_Node template, we can use the built-in
        ; handlers. This example uses the "_Ptr" version of the handlers.
        tvex.OnNotify(TVN_BEGINLABELEDITW, TreeViewEx_HandlerBeginLabelEdit_Node_Ptr)
        tvex.OnNotify(TVN_DELETEITEMW, TreeViewEx_HandlerDeleteItem_Node_Ptr)
        tvex.OnNotify(TVN_GETDISPINFOW, TreeViewEx_HandlerGetDispInfo_Node_Ptr)
        tvex.OnNotify(TVN_ENDLABELEDITW, TreeViewEx_HandlerEndLabelEdit_Node_Ptr)
        tvex.OnNotify(TVN_GETINFOTIPW, TreeViewEx_HandlerGetInfoTip_Node_Ptr)
        tvex.OnNotify(TVN_ITEMCHANGEDW, TreeViewEx_HandlerItemChanged_Node_Ptr)
        tvex.OnNotify(TVN_ITEMCHANGINGW, TreeViewEx_HandlerItemChanging_Node_Ptr)
        tvex.OnNotify(TVN_ITEMEXPANDEDW, TreeViewEx_HandlerItemExpanded_Node_Ptr)
        tvex.OnNotify(TVN_ITEMEXPANDINGW, TreeViewEx_HandlerItemExpanding_Node_Ptr)
        tvex.OnNotify(TVN_SETDISPINFOW, TreeViewEx_HandlerSetDispInfo_Node_Ptr)

        ; Example object which defines the node structure.
        this.list := TreeViewExDemo_GetObj()
        ; Add the root nodes. Our TVN_GETDISPINFO handler tells the system that the nodes have children
        ; so the tree-view control displays the + symbol next to the node even though the child nodes
        ; don't actually exist yet. Our TVN_ITEMEXPANDING handler adds the nodes when the
        ; user clicks the +. This is to conserve some resources and also to have more control over
        ; the tree-view's behavior.
        ; Create the TVINSERTSTRUCT
        struct := TvInsertStruct()
        struct.pszText := LPSTR_TEXTCALLBACKW
        struct.cChildren := I_CHILDRENCALLBACK
        struct.mask := TVIF_CHILDREN | TVIF_TEXT | TVIF_PARAM
        struct.hParent := 0
        struct.hInsertAfter := TVI_LAST
        ; Save the struct as a template
        tvex.AddTemplate('insert', struct)
        for obj in this.list {
            tvex.AddNode(struct, obj)
        }

        ; Add an exit button and display the gui.
        tvex.GetPos(&x, &y, &w, &h)
        btn := g.Add('Button', 'section x' x ' y' (y + h + 10) ' vBtnExit', 'Exit')
        btn.OnEvent('Click', _Exit)
        btn.GetPos(, &y, , &h)
        g.Show('x20 y20 w' (x + w + g.MarginX) ' h' (y + h + g.MarginY))

        return

        _Exit(*) {
            ExitApp()
        }
    }
}

class DemoTreeViewEx_Node extends TreeViewEx_Node {
    __New(Value) {
        this.Value := Value
        if IsObject(Value) {
            this.ImageGroup := 1
        } else {
            this.ImageGroup := 2
        }
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc '`n')
    }
    OnBeginLabelEdit(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        if IsObject(this.Value) && !HasProp(this.Value, 'Name') {
            TreeViewExDemo_ShowTooltip('Unable to modify the name of the object because it does not have a name property.')
            return true
        }
        HotKey('Enter', SubmitLabelEdit, 'On')
        HotKey('Esc', CancelLabelEdit, 'On')
        ; Sets a callback function that is called when the label edit control is destroyed. Use this
        ; to disable the hotkeys.
        TreeViewEx_LabelEditDestroyNotification(this.Ctrl.GetEditControl(), DisableLabelEditHotkeys)
        TreeViewExDemo_ShowTooltip('Editing label. Press Enter to submit the changes or Escape to cancel the changes.')
    }
    OnDeleteItem(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        ObjRelease(Struct.lParam_old)
    }
    OnEndLabelEdit(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        if IsObject(this.Value) {
            ; If the object has a property "Name", update the value
            if HasProp(this.Value, 'Name') {
                this.Value.Name := Struct.pszText
            } else {
                ; This should not occur because we already handled it in "OnBeginLabelEdit".
                TreeViewExDemo_ShowTooltip('Unable to modify the name of the object because it does not have a name property.')
                return 0
            }
        } else {
            ; Update the value
            this.Value := Struct.pszText
        }
        TreeViewExDemo_ShowTooltip('Updated the name to: ' Struct.pszText)
        return 1
    }
    OnGetInfoChildren(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        if IsObject(this.Value) && HasProp(this.Value, 'Children') && this.Value.Children is Array && this.Value.Children.Length {
            return 1
        } else {
            return 0
        }
    }
    OnGetInfoName(Struct) {
        if Struct {
            OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        } else {
            OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ""; Node: ' this.Handle '`n')
        }
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
    OnGetInfoTip(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        ; Just set the pszText property of the structure to define the tooltip text.
        Struct.pszText := 'Tooltip for ' this.OnGetInfoName('')
    }
    OnItemChanged(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        new := Struct.uStateNew
        old := Struct.uStateOld
        ; This example doesn't do anything with the TVN_ITEMCHANGED notification except display
        ; the information in OutputDebug.
        for name, flag in Map(
            'TVIS_BOLD', TVIS_BOLD, 'TVIS_CUT', TVIS_CUT
          , 'TVIS_DROPHILITED', TVIS_DROPHILITED, 'TVIS_EXPANDED', TVIS_EXPANDED
          , 'TVIS_EXPANDEDONCE', TVIS_EXPANDEDONCE, 'TVIS_EXPANDPARTIAL', TVIS_EXPANDPARTIAL
          , 'TVIS_SELECTED', TVIS_SELECTED, 'TVIS_OVERLAYMASK', TVIS_OVERLAYMASK
          , 'TVIS_STATEIMAGEMASK', TVIS_STATEIMAGEMASK, 'TVIS_USERMASK', TVIS_USERMASK
        ) {
            if (new & flag) != (old & flag) {
                OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc '; State ' name ' changed.`n')
            }
        }
        return 0
    }
    OnItemChanging(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        new := Struct.uStateNew
        old := Struct.uStateOld
        ; This example doesn't do anything with the TVN_ITEMCHANGING notification except display
        ; the information in OutputDebug.
        for name, flag in Map(
            'TVIS_BOLD', TVIS_BOLD, 'TVIS_CUT', TVIS_CUT
          , 'TVIS_DROPHILITED', TVIS_DROPHILITED, 'TVIS_EXPANDED', TVIS_EXPANDED
          , 'TVIS_EXPANDEDONCE', TVIS_EXPANDEDONCE, 'TVIS_EXPANDPARTIAL', TVIS_EXPANDPARTIAL
          , 'TVIS_SELECTED', TVIS_SELECTED, 'TVIS_OVERLAYMASK', TVIS_OVERLAYMASK
          , 'TVIS_STATEIMAGEMASK', TVIS_STATEIMAGEMASK, 'TVIS_USERMASK', TVIS_USERMASK
        ) {
            if (new & flag) != (old & flag) {
                OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc '; State ' name ' is changing.`n')
            }
        }
        return 0
    }
    OnItemExpanded(Struct) {
        OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        switch Struct.action {
            case TVE_COLLAPSE, TVE_COLLAPSERESET:
                TreeViewExDemo_ShowTooltip('Collapsed item ' this.OnGetInfoName(''))
            case TVE_EXPAND:
                TreeViewExDemo_ShowTooltip('Expanded item ' this.OnGetInfoName(''))
            case TVE_EXPANDPARTIAL:
                TreeViewExDemo_ShowTooltip('Partially expanded item ' this.OnGetInfoName(''))
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
                ; If a descendent node is currently selected, we have to un-select it
                ctrl.Select(0)
                for child in ctrl.EnumChildren(this.Handle) {
                    ; I defined the "__Delete" property to display a tooltip with the number of node
                    ; objects destroyed. Whenever we collapse a node, we should see the tooltip display
                    ; the correct number of child nodes that were beneath the collapsed node.
                    ; If we see an incorrect value or no tooltip at all, there is a memory leak
                    ; caused by incorrect handling of the reference count.
                    ctrl.DeleteItem(child)
                }
                ; Update the state flag
                _struct := TvItem()
                _struct.mask := TVIF_HANDLE | TVIF_STATE
                _struct.hItem := this.Handle
                _struct.state := 0
                _struct.stateMask := TVIS_EXPANDED
                ctrl.SetItem(_struct)
            case TVE_EXPAND:
                ; Add items
                struct := ctrl.GetTemplate('insert')
                struct.hParent := this.Handle
                for child in this.Value.Children {
                    ctrl.AddNode(struct, child)
                }
            ; To be added.
            case TVE_EXPANDPARTIAL: throw Error('Invalid operation.', -1)
        }
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
    __Delete() {
        global g_TreeViewExDemo_NodeDeleteCounter
        if IsSet(g_TreeViewExDemo_NodeDeleteCounter) {
            g_TreeViewExDemo_NodeDeleteCounter.Count++
        } else {
            g_TreeViewExDemo_NodeDeleteCounter := NodeDeleteCounter()
        }
    }
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.Handle := ''
    }
}

SendLabelEditBegin() {
    Demo.tvex.EditSelectedLabel()
}
SubmitLabelEdit(*) {
    Demo.tvex.EndEditLabel()
}
CancelLabelEdit(*) {
    Demo.tvex.EndEditLabel(true)
}
DisableLabelEditHotkeys() {
    HotKey('Enter', SubmitLabelEdit, 'Off')
    HotKey('Esc', CancelLabelEdit, 'Off')
}

class NodeDeleteCounter {
    __New() {
        this.Count := 1
        SetTimer(this, -150)
    }
    Call() {
        if this.Count == 1 {
            TreeViewExDemo_ShowTooltip('1 node was destroyed.')
        } else {
            TreeViewExDemo_ShowTooltip(this.Count ' nodes were destroyed.')
        }
        global g_TreeViewExDemo_NodeDeleteCounter := unset
    }
}

TreeViewExDemo_GetObj() {
    return [
        {
            Name: 'obj1'
          , Children: [
                { Name: 'obj1-1', Children: [ 'obj1-1-1' ] }
              , { Name: 'obj1-2', Children: [ 'obj1-2-1' ] }
              , {
                    Name: 'obj1-3'
                  , Children: [
                        {
                            Name: 'obj1-3-1'
                          , Children: [
                                'obj1-3-1-1'
                              , 'obj1-3-1-2'
                              , 'obj1-3-1-3'
                              , {
                                    Name: 'obj1-3-1-4'
                                  , Children: [ 'obj1-3-1-4-1' ]
                                }
                            ]
                        }
                    ]
                }
            ]
        }
      , {
            Children: [
                {
                    Children: [
                        {
                            Name: 'obj2-1-1'
                          , Children: [ ]
                        }
                    ]
                }
              , {
                    Name: 'obj2-2'
                }
              , {
                    Name: 'obj2-3'
                  , Children: [
                        { Name: 'obj2-3-1', Children: [] }
                      , 'obj2-3-2'
                      , 'obj2-3-3'
                      , 'obj2-3-4'
                    ]
                }
            ]
        }
    ]
}

TreeViewExDemo_ShowTooltip(Str) {
    static N := [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    Z := N.Pop()
    OM := CoordMode('Mouse', 'Screen')
    OT := CoordMode('Tooltip', 'Screen')
    MouseGetPos(&x, &y)
    Tooltip(Str, x, y, Z)
    SetTimer(_End.Bind(Z), -2000)
    CoordMode('Mouse', OM)
    CoordMode('Tooltip', OT)

    _End(Z) {
        ToolTip(,,,Z)
        N.Push(Z)
    }
}
