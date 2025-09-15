/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TreeViewExNode {
    static SetHandlerBeginLabelEdit(Callback) {
        this.__SetHandler(Callback, 'OnBeginLabelEdit')
    }
    static SetHandlerChildren(CallbackGet) {
        this.__SetHandler(CallbackGet, 'OnGetInfoChildren')
    }
    static SetHandlerDeleteItem(Callback) {
        this.__SetHandler(Callback, 'OnDeleteItem')
    }
    static SetHandlerEndLabelEdit(Callback) {
        this.__SetHandler(Callback, 'OnEndLabelEdit')
    }
    static SetHandlerImage(CallbackGet?, CallbackSet?) {
        if IsSet(CallbackGet) {
            this.__SetHandler(CallbackGet, 'OnGetInfoImage')
        }
        if IsSet(CallbackSet) {
            this.__SetHandler(CallbackSet, 'OnSetInfoImage')
        }
    }
    static SetHandlerInfoTip(CallbackGet) {
        this.__SetHandler(CallbackGet, 'OnGetInfoTip')
    }
    static SetHandlerItemChanged(Callback) {
        this.__SetHandler(Callback, 'OnItemChanged')
    }
    static SetHandlerItemChanging(Callback) {
        this.__SetHandler(Callback, 'OnItemChanging')
    }
    static SetHandlerItemExpanded(Callback) {
        this.__SetHandler(Callback, 'OnItemExpanded')
    }
    static SetHandlerItemExpanding(Callback) {
        this.__SetHandler(Callback, 'OnItemExpanding')
    }
    static SetHandlerName(CallbackGet?, CallbackSet?) {
        if IsSet(CallbackGet) {
            this.__SetHandler(CallbackGet, 'OnGetInfoName')
        }
        if IsSet(CallbackSet) {
            this.__SetHandler(CallbackSet, 'OnSetInfoName')
        }
    }
    static SetHandlerSelectedImage(CallbackGet?, CallbackSet?) {
        if IsSet(CallbackGet) {
            this.__SetHandler(CallbackGet, 'OnGetInfoSelectedImage')
        }
        if IsSet(CallbackSet) {
            this.__SetHandler(CallbackSet, 'OnSetInfoSelectedImage')
        }
    }
    static SetHandlerSingleExpand(Callback) {
        this.__SetHandler(Callback, 'OnSingleExpand')
    }
    static __SetHandler(Callback, Name) {
        if Callback {
            this.Prototype.DefineProp(Name, { Call: Callback })
        } else {
            this.Prototype.DefineProp(Name, { Call: ((Name, *) => TreeViewEx_ThrowOverrideMethodError(Name)).Bind(this.Prototype.__Class '.Prototype.' Name) } )
        }
    }
    __New(Handle := '') {
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
    Delete() => SendMessage(TVM_DELETEITEM, 0, this.Handle, this.HwndTv)
    EnsureVisible() => SendMessage(TVM_ENSUREVISIBLE, 0, this.Handle, this.HwndTv)
    EnumChildren(VarCount?) => this.Ctrl.EnumChildren(this.Handle, VarCount ?? unset)
    EnumChildrenRecursive(VarCount?) => this.Ctrl.EnumChildrenRecursive(this.Handle, VarCount ?? unset)
    Expand() => SendMessage(TVM_EXPAND, TVE_EXPAND, this.Handle, this.HwndTv)
    ExpandPartial() => SendMessage(TVM_EXPAND, TVE_EXPANDPARTIAL, this.Handle, this.HwndTv)
    GetItemState(Mask) => SendMessage(TVM_GETITEMSTATE, this.Handle, Mask, this.HwndTv)
    GetRect() => this.Ctrl.GetItemRect(this.Handle)
    GetText() => this.Ctrl.GetText(this.Handle)
    MapHTreeItemToAccId() => SendMessage(TVM_MAPHTREEITEMTOACCID, this.Handle, 0, this.HwndTv)
    Select() => SendMessage(TVM_SELECTITEM, TVGN_CARET, this.Handle, this.HwndTv)
    SetHandle(Handle) => this.Handle := Handle
    SetInsertMark(AfterItem := false) => SendMessage(TVM_SETINSERTMARK, AfterItem, this.Handle, this.HwndTv)
    SetTreeView(Hwnd) {
        this.HwndTv := Hwnd
    }
    ShowInfoTip() => SendMessage(TVM_SHOWINFOTIP, 0, this.Handle, this.HwndTv)
    SortChildren(Recursive := true) => SendMessage(TVM_SORTCHILDREN, Recursive, this.Handle, this.HwndTv)
    SortChildrenCb(Callback, lParam?) => this.Ctrl.SortChildrenCb(this.Handle, Callback, lParam ?? 0)
    Toggle() => SendMessage(TVM_EXPAND, TVE_TOGGLE, this.Handle, this.HwndTv)

    ; These are intended to be overridden by classes which inherit from `TreeViewExNode` or by calling
    ; one of the static "Set<Name>Handler" methods. See README.md for more info.
    OnBeginLabelEdit(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnDeleteItem(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnEndLabelEdit(Value, Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnGetInfoChildren(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnGetInfoImage(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnGetInfoName(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnGetInfoSelectedImage(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnGetInfoTip(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnItemChanged(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnItemChanging(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnItemExpanded(Value, Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnItemExpanding(Value, Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnSetInfoImage(Value, Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnSetInfoName(Value, Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnSetInfoSelectedImage(Value, Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }
    OnSingleExpand(Struct) {
        TreeViewEx_ThrowOverrideMethodError(A_ThisFunc)
    }

    Child => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, this.Handle, this.HwndTv)
    Gui => GuiFromHwnd(this.HwndTv).Gui
    IsExpanded => this.Ctrl.IsExpanded(this.Handle)
    HasChildren => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, this.Handle, this.HwndTv) ? 1 : 0
    IsRoot => !SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, this.Handle, this.HwndTv)
    LineRect => this.Ctrl.GetLineRect(this.Handle)
    Next => SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, this.Handle, this.HwndTv)
    Parent => SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, this.Handle, this.HwndTv)
    Previous => SendMessage(TVM_GETNEXTITEM, TVGN_PREVIOUS, this.Handle, this.HwndTv)
    Root => SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, this.Handle, this.HwndTv)
    Rect => this.Ctrl.GetItemRect(this.Handle)
}

TreeViewEx_ThrowOverrideMethodError(fn) {
    throw Error('This method must be overridden.', -1, fn)
}
