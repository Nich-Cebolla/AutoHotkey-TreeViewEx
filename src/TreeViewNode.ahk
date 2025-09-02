/*
    Github: https://github.com/Nich-Cebolla/
    Author: Nich-Cebolla
    Version: 1.0.0
    License: MIT
*/

class TreeViewNode {
    __New(Id) {
        this.Id := Id
    }

    AddChild(Name := '', Options?) => this.Ctrl.Add(Name, this.Id, Options ?? unset)
    Copy() => A_Clipboard := this.Ctrl.GetText(this.Id)
    CopyItemId() {
        A_Clipboard := this.Id
    }
    Collapse() => SendMessage(TVM_EXPAND, TVE_COLLAPSE, this.Id, this.HwndTv)
    CollapseReset() => SendMessage(TVM_EXPAND, TVE_COLLAPSERESET, this.Id, this.HwndTv)
    EnsureVisible() => SendMessage(TVM_ENSUREVISIBLE, 0, this.Id, this.HwndTv)
    EnumChildren(VarCount?) => this.Ctrl.EnumChildren(this.Id, VarCount ?? unset)
    EnumChildrenRecursive(VarCount?) => this.Ctrl.EnumChildrenRecursive(this.Id, VarCount ?? unset)
    Expand() => SendMessage(TVM_EXPAND, TVE_EXPAND, this.Id, this.HwndTv)
    ExpandPartial() => SendMessage(TVM_EXPAND, TVE_EXPANDPARTIAL, this.Id, this.HwndTv)
    Select() => SendMessage(TVM_SELECTITEM, TVGN_CARET, this.Id, this.HwndTv)
    SetCollectionName(Name) => this.CollectionName := Name
    SetTreeView(Hwnd) {
        this.HwndTv := Hwnd
    }
    SortChildren(Recursive := true) => SendMessage(TVM_SORTCHILDREN, Recursive, this.Id, this.HwndTv)
    SortChildrenCb(Callback, lParam?) => this.Ctrl.SortChildrenCb(this.Id, Callback, lParam ?? 0)
    Toggle() => SendMessage(TVM_EXPAND, TVE_TOGGLE, this.Id, this.HwndTv)

    Child => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, this.Id, this.HwndTv)
    Ctrl => GuiCtrlFromHwnd(this.HwndTv)
    Gui => GuiFromHwnd(this.HwndTv).Gui
    IsParent => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, this.Id, this.HwndTv) ? 1 : 0
    IsRoot => !SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, this.Id, this.HwndTv)
    LineRect => this.Ctrl.GetLineRect(this.Id)
    Next => SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, this.Id, this.HwndTv)
    Parent => SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, this.Id, this.HwndTv)
    Previous => SendMessage(TVM_GETNEXTITEM, TVGN_PREVIOUS, this.Id, this.HwndTv)
    Root => SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, this.Id, this.HwndTv)
    Rect => this.Ctrl.GetItemRect(this.Id)
}
