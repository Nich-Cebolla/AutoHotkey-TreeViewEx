/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TreeViewNode {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        for prop in [ 'InfoChildren', 'InfoName', 'InfoImage', 'InfoSelectedImage' ] {
            proto.DefineProp('__' prop, proto.GetOwnPropDesc(prop))
        }
    }
    static SetChildrenHandler(CallbackGet) {
        this.__SetHandler('Children', CallbackGet, 'G')
    }
    static SetNameHandler(CallbackGet?, CallbackSet?) {
        if IsSet(CallbackGet) {
            this.__SetHandler('Name', CallbackGet, 'G')
        }
        if IsSet(CallbackSet) {
            this.__SetHandler('Name', CallbackSet, 'S')
        }
    }
    static SetImageHandler(CallbackGet?, CallbackSet?) {
        if IsSet(CallbackGet) {
            this.__SetHandler('Image', CallbackGet, 'G')
        }
        if IsSet(CallbackSet) {
            this.__SetHandler('Image', CallbackSet, 'S')
        }
    }
    static SetSelectedImageHandler(CallbackGet?, CallbackSet?) {
        if IsSet(CallbackGet) {
            this.__SetHandler('SelectedImage', CallbackGet, 'G')
        }
        if IsSet(CallbackSet) {
            this.__SetHandler('SelectedImage', CallbackSet, 'S')
        }
    }
    static __SetHandler(Name, Callback, Which) {
        descCurrent := this.Prototype.GetOwnPropDesc('Info' Name)
        if Callback {
            descCurrent.%Which%et := Callback
        } else {
            descCurrent.%Which%et := this.Prototype.GetOwnPropDesc('__Info' Name).%Which%et
        }
        this.Prototype.DefineProp('Info' Name, descCurrent)
    }
    __New(Handle) {
        this.Handle := Handle
    }

    AddChild(Name := '', Options?) => this.Ctrl.Add(Name, this.Handle, Options ?? unset)
    Copy() => A_Clipboard := this.Ctrl.GetText(this.Handle)
    CopyItemId() {
        A_Clipboard := this.Handle
    }
    Collapse() => SendMessage(TVM_EXPAND, TVE_COLLAPSE, this.Handle, this.HwndTv)
    CollapseReset() => SendMessage(TVM_EXPAND, TVE_COLLAPSERESET, this.Handle, this.HwndTv)
    CreateDragImage() => SendMessage(TVM_CREATEDRAGIMAGE, 0, this.Handle, this.HwndTv)
    EnsureVisible() => SendMessage(TVM_ENSUREVISIBLE, 0, this.Handle, this.HwndTv)
    EnumChildren(VarCount?) => this.Ctrl.EnumChildren(this.Handle, VarCount ?? unset)
    EnumChildrenRecursive(VarCount?) => this.Ctrl.EnumChildrenRecursive(this.Handle, VarCount ?? unset)
    Expand() => SendMessage(TVM_EXPAND, TVE_EXPAND, this.Handle, this.HwndTv)
    ExpandPartial() => SendMessage(TVM_EXPAND, TVE_EXPANDPARTIAL, this.Handle, this.HwndTv)
    GetItemState(Mask) => SendMessage(TVM_GETITEMSTATE, this.Handle, Mask, this.HwndTv)
    GetText() => this.Ctrl.GetText(this.Handle)
    MapHTreeItemToAccId() => SendMessage(TVM_MAPHTREEITEMTOACCID, this.Handle, 0, this.HwndTv)
    Select() => SendMessage(TVM_SELECTITEM, TVGN_CARET, this.Handle, this.HwndTv)
    SetInsertMark(AfterItem := false) => SendMessage(TVM_SETINSERTMARK, AfterItem, this.Handle, this.HwndTv)
    SetTreeView(Hwnd) {
        this.HwndTv := Hwnd
    }
    ShowInfoTip() => SendMessage(TVM_SHOWINFOTIP, 0, this.Handle, this.HwndTv)
    SortChildren(Recursive := true) => SendMessage(TVM_SORTCHILDREN, Recursive, this.Handle, this.HwndTv)
    SortChildrenCb(Callback, lParam?) => this.Ctrl.SortChildrenCb(this.Handle, Callback, lParam ?? 0)
    Toggle() => SendMessage(TVM_EXPAND, TVE_TOGGLE, this.Handle, this.HwndTv)

    Child => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, this.Handle, this.HwndTv)
    Ctrl => GuiCtrlFromHwnd(this.HwndTv)
    Gui => GuiFromHwnd(this.HwndTv).Gui

    ; These are intended to be overridden by classes which inherit from `TreeViewNode`. See README.md
    ; for more info.
    InfoChildren => ''
    InfoImage {
        Get => ''
        Set => ''
    }
    InfoName {
        Get => ''
        Set => ''
    }
    InfoSelectedImage {
        Get => ''
        Set => ''
    }

    IsParent => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, this.Handle, this.HwndTv) ? 1 : 0
    IsRoot => !SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, this.Handle, this.HwndTv)
    LineRect => this.Ctrl.GetLineRect(this.Handle)
    Next => SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, this.Handle, this.HwndTv)
    Parent => SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, this.Handle, this.HwndTv)
    Previous => SendMessage(TVM_GETNEXTITEM, TVGN_PREVIOUS, this.Handle, this.HwndTv)
    Root => SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, this.Handle, this.HwndTv)
    Rect => this.Ctrl.GetItemRect(this.Handle)
}
