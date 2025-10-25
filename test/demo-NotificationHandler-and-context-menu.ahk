
; This has one dependency (not including TreeViewEx)
#include ..\src\TreeViewEx_ContextMenu.ahk

; This combines the content from test\demo-context-menu.ahk and test\NotificationHandlers.ahk

#SingleInstance force

#include ..\src\VENV.ahk

!esc::ExitApp()
!+`::Reload()
f2::SendLabelEditBegin()

Demo()

class Demo {
    static Call() {

        ; Create Gui
        g := this.g := Gui('+Resize')
        g.OnEvent('Close', (*) => ExitApp())

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
        tvex.OnNotify(TVN_ENDLABELEDITW, TreeViewEx_HandlerEndLabelEdit_Node_Ptr)
        tvex.OnNotify(TVN_GETDISPINFOW, TreeViewEx_HandlerGetDispInfo_Node_Ptr)
        tvex.OnNotify(TVN_GETINFOTIPW, TreeViewEx_HandlerGetInfoTip_Node_Ptr)
        tvex.OnNotify(TVN_ITEMCHANGEDW, TreeViewEx_HandlerItemChanged_Node_Ptr)
        tvex.OnNotify(TVN_ITEMCHANGINGW, TreeViewEx_HandlerItemChanging_Node_Ptr)
        tvex.OnNotify(TVN_ITEMEXPANDEDW, TreeViewEx_HandlerItemExpanded_Node_Ptr)
        tvex.OnNotify(TVN_ITEMEXPANDINGW, TreeViewEx_HandlerItemExpanding_Node_Ptr)
        tvex.OnNotify(TVN_SETDISPINFOW, TreeViewEx_HandlerSetDispInfo_Node_Ptr)

        ; Deselects any items when clicking in an area within the TreeViewEx control but not on an item.
        tvex.OnNotify(NM_CLICK, TreeViewEx_OnClick)

        ; Set the context menu.
        tvex.SetContextMenu(TreeViewEx_ContextMenu(, { ShowTooltips: true }))

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
        btn := g.Add('Button', 'Section x' x ' y' (y + h + 10) ' vBtnExit', 'Exit')
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
        ; We have to release the reference so the node object can be destroyed.
        ; We'll delete the children whenever a node is collapsed.
        ; If a descendent node is currently selected, we have to un-select it.
        if this.ctrl.IsAncestor(, this.Handle) {
            this.ctrl.Select(0)
        }
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
        ; OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        if IsObject(this.Value) && HasProp(this.Value, 'Children') && this.Value.Children is Array && this.Value.Children.Length {
            ; Node has children.
            Struct.cChildren := 1
        } else {
            ; Node does not have children.
            Struct.cChildren := 0
        }
    }
    OnGetInfoName(Struct) {
        ; OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc '; Node: ' this.Handle '`n')
        if IsObject(this.Value) {
            if HasProp(this.Value, 'Name') {
                if IsNumber(this.Value.Name) {
                    Struct.pszText := String(this.Value.Name) ' :: ' this.Handle
                } else {
                    Struct.pszText := '"' this.Value.Name '" :: ' this.Handle
                }
            } else {
                Struct.pszText := '{ ' Type(this.Value) ' } :: ' this.Handle
            }
        } else if IsNumber(this.Value) {
            Struct.pszText := String(this.Value) ' :: ' this.Handle
        } else {
            Struct.pszText := '"' this.Value '" :: ' this.Handle
        }
    }
    OnGetInfoTip(Struct) {
        ; OutputDebug('Tick: ' A_TickCount ', Func: ' A_ThisFunc ' : Code: ' Struct.code_int '; Node: ' this.Handle '`n')
        ; Just set the pszText property of the structure to define the tooltip text.
        Struct.pszText := 'Tooltip for ' this.Name
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
                ctrl := this.Ctrl
                for child in ctrl.EnumChildren(this.Handle) {
                    ; I defined the "__Delete" property to display a tooltip with the number of node
                    ; objects destroyed. Whenever we collapse a node, we should see the tooltip display
                    ; the correct number of child nodes that were beneath the collapsed node.
                    ; If we see an incorrect value or no tooltip at all, there is a memory leak
                    ; caused by incorrect handling of the reference count.
                    ctrl.DeleteItem(child)
                }
                ; Set flag indicating children have not been added.
                this.flag_children := 0
            case TVE_EXPAND:
                ; do nothing
            case TVE_EXPANDPARTIAL:
                ; do nothing
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
                ; Do nothing
            case TVE_EXPAND:
                ; Check if children have already been added
                if !this.flag_children {
                    ; Add children
                    _struct := ctrl.GetTemplate('insert')
                    _struct.hParent := this.Handle
                    for child in this.Value.Children {
                        ctrl.AddNode(_struct, child)
                    }
                    this.flag_children := 1
                }
            ; To be added.
            case TVE_EXPANDPARTIAL: throw Error('Invalid operation.', -1)
        }
        return 0
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

    Name {
        Get {
            if IsObject(this.Value) {
                if HasProp(this.Value, 'Name') {
                    if IsNumber(this.Value.Name) {
                        return String(this.Value.Name) ' :: ' this.Handle
                    } else {
                        return '"' this.Value.Name '" :: ' this.Handle
                    }
                } else {
                    return '{ ' Type(this.Value) ' } :: ' this.Handle
                }
            } else if IsNumber(this.Value) {
                return String(this.Value) ' :: ' this.Handle
            } else {
                return '"' this.Value '" :: ' this.Handle
            }
        }
    }

    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.Handle := ''
        proto.flag_children := 0
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
      , {
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
    Tooltip(Str, x, y + Demo.tvex.GetItemHeight(), Z)
    SetTimer(_End.Bind(Z), -1500)
    CoordMode('Mouse', OM)
    CoordMode('Tooltip', OT)

    _End(Z) {
        ToolTip(,,,Z)
        N.Push(Z)
    }
}
