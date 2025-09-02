
; https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/structs/Rect.ahk
#include <Rect>

#include TreeViewNode.ahk
#include TvHitTestInfo.ahk
#include TvSortCb.ahk

; The methods are untested.

class TreeViewEx extends Gui.TreeView {
    static __New() {
        this.DeleteProp('__New')
        this.SetConstants()
        proto := this.Prototype

    }
    static Call(GuiObj, Opt?) {
        tv := GuiObj.Add('TreeView', Opt ?? unset)
        ObjSetBase(tv, this.Prototype)
        return tv
    }
    static SetConstants() {
        global
        TV_FIRST := 0x1100

        ; TVM_INSERTITEMA            := TV_FIRST + 0
        ; TVM_INSERTITEMW            := TV_FIRST + 50
        ; TVM_DELETEITEM             := TV_FIRST + 1
        TVM_EXPAND                 := TV_FIRST + 2
        TVM_GETITEMRECT            := TV_FIRST + 4
        TVM_GETCOUNT               := TV_FIRST + 5
        TVM_GETINDENT              := TV_FIRST + 6
        TVM_SETINDENT              := TV_FIRST + 7
        TVM_GETIMAGELIST           := TV_FIRST + 8
        TVM_SETIMAGELIST           := TV_FIRST + 9
        TVM_GETNEXTITEM            := TV_FIRST + 10
        TVM_SELECTITEM             := TV_FIRST + 11
        ; TVM_GETITEMA               := TV_FIRST + 12
        ; TVM_GETITEMW               := TV_FIRST + 62
        ; TVM_SETITEMA               := TV_FIRST + 13
        ; TVM_SETITEMW               := TV_FIRST + 63
        ; TVM_EDITLABELA             := TV_FIRST + 14
        TVM_EDITLABELW             := TV_FIRST + 65
        TVM_GETEDITCONTROL         := TV_FIRST + 15
        TVM_GETVISIBLECOUNT        := TV_FIRST + 16
        TVM_HITTEST                := TV_FIRST + 17
        ; TVM_CREATEDRAGIMAGE        := TV_FIRST + 18
        TVM_SORTCHILDREN           := TV_FIRST + 19
        TVM_ENSUREVISIBLE          := TV_FIRST + 20
        TVM_SORTCHILDRENCB         := TV_FIRST + 21
        TVM_ENDEDITLABELNOW        := TV_FIRST + 22
        ; TVM_GETISEARCHSTRINGA      := TV_FIRST + 23
        ; TVM_GETISEARCHSTRINGW      := TV_FIRST + 64
        ; TVM_SETTOOLTIPS            := TV_FIRST + 24
        ; TVM_GETTOOLTIPS            := TV_FIRST + 25
        ; TVM_SETINSERTMARK          := TV_FIRST + 26
        TVM_SETITEMHEIGHT          := TV_FIRST + 27
        TVM_GETITEMHEIGHT          := TV_FIRST + 28
        TVM_SETBKCOLOR             := TV_FIRST + 29
        TVM_SETTEXTCOLOR           := TV_FIRST + 30
        TVM_GETBKCOLOR             := TV_FIRST + 31
        TVM_GETTEXTCOLOR           := TV_FIRST + 32
        ; TVM_SETSCROLLTIME          := TV_FIRST + 33
        ; TVM_GETSCROLLTIME          := TV_FIRST + 34
        ; TVM_SETINSERTMARKCOLOR     := TV_FIRST + 37
        ; TVM_GETINSERTMARKCOLOR     := TV_FIRST + 38
        TVM_SETBORDER              := TV_FIRST + 35
        ; TVM_GETITEMSTATE           := TV_FIRST + 39
        TVM_SETLINECOLOR           := TV_FIRST + 40
        TVM_GETLINECOLOR           := TV_FIRST + 41
        ; TVM_MAPACCIDTOHTREEITEM    := TV_FIRST + 42
        ; TVM_MAPHTREEITEMTOACCID    := TV_FIRST + 43
        TVM_SETEXTENDEDSTYLE       := TV_FIRST + 44
        TVM_GETEXTENDEDSTYLE       := TV_FIRST + 45
        ; TVM_SETAUTOSCROLLINFO      := TV_FIRST + 59
        ; TVM_SETHOT                 := TV_FIRST + 58
        ; TVM_GETSELECTEDCOUNT       := TV_FIRST + 70
        ; TVM_SHOWINFOTIP            := TV_FIRST + 71

        TVE_COLLAPSE               := 0x0001
        TVE_EXPAND                 := 0x0002
        TVE_TOGGLE                 := 0x0003
        TVE_EXPANDPARTIAL          := 0x4000
        TVE_COLLAPSERESET          := 0x8000

        TVSIL_NORMAL               := 0
        TVSIL_STATE                := 2

        TVGN_ROOT                  := 0x0000
        TVGN_NEXT                  := 0x0001
        TVGN_PREVIOUS              := 0x0002
        TVGN_PARENT                := 0x0003
        TVGN_CHILD                 := 0x0004
        TVGN_FIRSTVISIBLE          := 0x0005
        TVGN_NEXTVISIBLE           := 0x0006
        TVGN_PREVIOUSVISIBLE       := 0x0007
        TVGN_DROPHILITE            := 0x0008
        TVGN_CARET                 := 0x0009
        TVGN_LASTVISIBLE           := 0x000A
        TVGN_NEXTSELECTED          := 0x000B

        ; TVSI_NOSINGLEEXPAND        := 0x8000

        ; TVIF_TEXT                  := 0x0001
        ; TVIF_IMAGE                 := 0x0002
        ; TVIF_PARAM                 := 0x0004
        ; TVIF_STATE                 := 0x0008
        ; TVIF_HANDLE                := 0x0010
        ; TVIF_SELECTEDIMAGE         := 0x0020
        ; TVIF_CHILDREN              := 0x0040
        ; TVIF_INTEGRAL              := 0x0080
        ; TVIF_STATEEX               := 0x0100
        ; TVIF_EXPANDEDIMAGE         := 0x0200

        TVHT_NOWHERE               := 0x0001
        TVHT_ONITEMICON            := 0x0002
        TVHT_ONITEMLABEL           := 0x0004
        TVHT_ONITEMINDENT          := 0x0008
        TVHT_ONITEMBUTTON          := 0x0010
        TVHT_ONITEMRIGHT           := 0x0020
        TVHT_ONITEMSTATEICON       := 0x0040
        TVHT_ABOVE                 := 0x0100
        TVHT_BELOW                 := 0x0200
        TVHT_TORIGHT               := 0x0400
        TVHT_TOLEFT                := 0x0800
        TVHT_ONITEM                := TVHT_ONITEMICON | TVHT_ONITEMLABEL | TVHT_ONITEMSTATEICON

        TVSBF_XBORDER              := 0x00000001
        TVSBF_YBORDER              := 0x00000002

        TVS_EX_NOSINGLECOLLAPSE    := 0x0001
        TVS_EX_MULTISELECT         := 0x0002
        TVS_EX_DOUBLEBUFFER        := 0x0004
        TVS_EX_NOINDENTSTATE       := 0x0008
        TVS_EX_RICHTOOLTIP         := 0x0010
        TVS_EX_AUTOHSCROLL         := 0x0020
        TVS_EX_FADEINOUTEXPANDOS   := 0x0040
        TVS_EX_PARTIALCHECKBOXES   := 0x0080
        TVS_EX_EXCLUSIONCHECKBOXES := 0x0100
        TVS_EX_DIMMEDCHECKBOXES    := 0x0200
        TVS_EX_DRAWIMAGEASYNC      := 0x0400

        CLR_NONE                   := 0xFFFFFFFF
        CLR_DEFAULT                := 0xFF000000
    }
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-editlabel}.
     * @param {Integer} Id - The id of the item to edit.
     * @returns {Integer} - The handle to the edit control that is created for editing the label, or
     * 0 if unsuccessful.
     */
    EditLabel(Id) => SendMessage(TVM_EDITLABELW, 0, Id, this.Hwnd)
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-endeditlabelnow}.
     * @param {Boolean} [CancelChanges = false] - Variable that indicates whether the editing is
     * canceled without being saved to the label. If this parameter is TRUE, the system cancels
     * editing without saving the changes. Otherwise, the system saves the changes to the label.
     * @returns {Integer} - Returns nonzero if the system scrolled the items in the tree-view control
     * and no items were expanded. Otherwise, the message returns zero..
     */
    EndEditLabel(CancelChanges := false) => SendMessage(TVM_ENDEDITLABELNOW, CancelChanges, 0, this.Hwnd)
    AddChild(Id, Name := '', Options?) => this.Add(Name, Id, Options ?? unset)
    CopyText(Id) => A_Clipboard := this.GetText(Id)
    CopyItemId(Id) => A_Clipboard := Id
    Collapse(Id) => SendMessage(TVM_EXPAND, TVE_COLLAPSE, Id, this.Hwnd)
    CollapseReset(Id) => SendMessage(TVM_EXPAND, TVE_COLLAPSERESET, Id, this.Hwnd)
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-ensurevisible}.
     * @param {Integer} Id - The id of the item.
     * @returns {Integer} - Returns nonzero if the system scrolled the items in the tree-view control
     * and no items were expanded. Otherwise, the message returns zero.
     */
    EnsureVisible(Id) => SendMessage(TVM_ENSUREVISIBLE, 0, Id, this.Hwnd)
    EnumChildren(Id, VarCount?) {
        child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, Id, this.Hwnd)
        if IsSet(VarCount) {
            if VarCount == 2 {
                return _Enum1
            } else {
                return _Enum2
            }
        } else {
            if this.HasOwnProp('Constructor') {
                return _Enum1
            } else {
                return _Enum2
            }
        }

        _Enum1(&_Id?, &Node?) {
            if child {
                _Id := child
                Node := this.Constructor.Call(child)
                child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, _Id, this.Hwnd)
                return 1
            } else {
                return 0
            }
        }
        _Enum2(&_Id?) {
            if child {
                _Id := child
                child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, _Id, this.Hwnd)
                return 1
            } else {
                return 0
            }
        }
    }
    EnumChildrenRecursive(Id, VarCount?) {
        enum := { Child: SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, Id, this.Hwnd), Stack: [], Parent: Id }
        if IsSet(VarCount) {
            if VarCount == 3 {
                enum.DefineProp('Call', { Call: _Enum1 })
            } else if VarCount == 2 {
                enum.DefineProp('Call', { Call: _Enum2 })
            } else {
                throw ValueError('Invalid ``VarCount``.', -1, VarCount)
            }
        } else {
            if this.HasOwnProp('Constructor') {
                enum.DefineProp('Call', { Call: _Enum1 })
            } else {
                enum.DefineProp('Call', { Call: _Enum2 })
            }
        }

        return enum

        _Enum1(Self, &Parent?, &_Id?, &Node?) {
            if Self.Child {
                Parent := Self.Parent
                _Id := Self.Child
                Node := this.Constructor.Call(Self.Child)
                if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, _Id, this.Hwnd) {
                    Self.Stack.Push({ Parent: Self.Parent, Child: _Id })
                    Self.Parent := _Id
                    Self.Child := child
                } else if child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, _Id, this.Hwnd) {
                    Self.Child := child
                } else if Self.Stack.Length {
                    flag := false
                    while Self.Stack.Length {
                        obj := Self.Stack.Pop()
                        if child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, obj.Child, this.Hwnd) {
                            Self.Parent := obj.Parent
                            Self.Child := child
                            flag := true
                            break
                        }
                    }
                    if !flag {
                        Self.Child := 0
                    }
                }
                return 1
            } else {
                return 0
            }
        }
        _Enum2(Self, &Parent?, &_Id?) {
            if Self.Child {
                Parent := Self.Parent
                _Id := Self.Child
                if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, _Id, this.Hwnd) {
                    Self.Stack.Push({ Parent: Self.Parent, Child: _Id })
                    Self.Parent := _Id
                    Self.Child := child
                } else if child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, _Id, this.Hwnd) {
                    Self.Child := child
                } else if Self.Stack.Length {
                    flag := false
                    while Self.Stack.Length {
                        obj := Self.Stack.Pop()
                        if child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, obj.Child, this.Hwnd) {
                            Self.Parent := obj.Parent
                            Self.Child := child
                            flag := true
                            break
                        }
                    }
                    if !flag {
                        Self.Child := 0
                    }
                }
                return 1
            } else {
                return 0
            }
        }
    }
    Expand(Id) => SendMessage(TVM_EXPAND, TVE_EXPAND, Id, this.Hwnd)
    ExpandPartial(Id) => SendMessage(TVM_EXPAND, TVE_EXPANDPARTIAL, Id, this.Hwnd)
    IsParent(Id) => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Id, this.Hwnd) ? 1 : 0
    IsRoot(Id) => !SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Id, this.Hwnd)
    GetBkColor() => SendMessage(TVM_GETBKCOLOR, 0, 0, this.Hwnd)
    GetEditControl() => SendMessage(TVM_GETEDITCONTROL, 0, 0, this.Hwnd)
    GetExtendedStyle() => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd)
    GetIndent() => SendMessage(TVM_GETINDENT, 0, 0, this.Hwnd)
    GetImageList(ImageListType) => SendMessage(TVM_GETIMAGELIST, ImageListType, 0, this.Hwnd)
    GetItemHeight() => SendMessage(TVM_GETITEMHEIGHT, 0, 0, this.Hwnd)
    GetItemRect(Id) {
        rc := Rect()
        NumPut('ptr', Id, rc, 0)
        if SendMessage(TVM_GETITEMRECT, 1, rc.ptr, this.Hwnd) {
            return rc
        }
    }
    GetLineColor() => SendMessage(TVM_GETLINECOLOR, 0, 0, this.Hwnd)
    GetLineRect(Id) {
        rc := Rect()
        NumPut('ptr', Id, rc, 0)
        if SendMessage(TVM_GETITEMRECT, 0, rc.ptr, this.Hwnd) {
            return rc
        }
    }
    GetRoot(Id) => SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, Id, this.Hwnd)
    GetVisibleCount() => SendMessage(TVM_GETVISIBLECOUNT, 0, 0, this.Hwnd)
    GetTextColor() => SendMessage(TVM_GETTEXTCOLOR, 0, 0, this.Hwnd)
    /**
     * If one or both of `X` and `Y` are unset, the mouse's position is used.
     * @param {Integer} [X] - The X-coordinate relative to the TreeView control (client coordinate).
     * @param {Integer} [Y] - The Y-coordinate relative to the TreeView control (client coordinate).
     */
    HitTest(X?, Y?) {
        if IsSet(X) && IsSet(Y) {
            hitTestInfo := TvHitTestInfo(X, Y)
        } else {
            mouseMode := CoordMode('Mouse', 'Screen')
            MouseGetPos(&X, &Y)
            CoordMode('Mouse', mouseMode)
            pt := Point(X, Y)
            pt.ToClient(this.Hwnd, true)
            hitTestInfo := TvHitTestInfo(pt.X, pt.Y)
        }
        if SendMessage(TVM_HITTEST, 0, hitTestInfo.Ptr, this.Hwnd) {
            return hitTestInfo
        } else {
            return ''
        }
    }
    Select(Id) => SendMessage(TVM_SELECTITEM, TVGN_CARET, Id, this.Hwnd)
    SetBkColor(Color) => SendMessage(TVM_SETBKCOLOR, 0, Color, this.Hwnd)
    SetBorder(Flags, SizeHoriz, SizeVert, &OutOldHoriz?, &OutOldVert?) {
        result := SendMessage(TVM_SETBORDER, Flags, (SizeVert & 0xFFFF) << 16 | (SizeHoriz & 0xFFFF), this.Hwnd)
        OutOldHoriz := result & 0xFFFF
        OutOldVert := (result >> 16) & 0xFFFF
    }
    SetExtendedStyle(Value, Styles) => SendMessage(TVM_SETEXTENDEDSTYLE, Value, Styles, this.Hwnd)
    SetImageList(ImageListType, Handle) => SendMessage(TVM_SETIMAGELIST, ImageListType, Handle, this.Hwnd)
    SetIndent(Value) => SendMessage(TVM_SETINDENT, Value, 0, this.Hwnd)
    SetItemHeight(Height) => SendMessage(TVM_SETITEMHEIGHT, Height, 0, this.Hwnd)
    SetLineColor(Color) => SendMessage(TVM_SETLINECOLOR, 0, Color, this.Hwnd)
    SetNodeConstructor(NodeClass) {
        this.Constructor := Class()
        this.Constructor.Base := NodeClass
        this.Constructor.Prototype := {
            HwndTv: this.Hwnd
          , __Class: NodeClass.Prototype.__Class
        }
        ObjSetBase(this.Constructor.Prototype, NodeClass.Prototype)
    }
    SetTextColor(Color) => SendMessage(TVM_SETTEXTCOLOR, 0, Color, this.Hwnd)
    SortChildren(Id, Recursive := true) => SendMessage(TVM_SORTCHILDREN, Recursive, Id, this.Hwnd)
    /**
     * See {@link https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvsortcb}
     * for details about the callback.
     *
     * See {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-sortchildrencb} for
     * details about the message.
     */
    SortChildrenCb(Id, Callback, lParam?) {
        cb := CallbackCreate(Callback)
        _tvSortCb := TvSortCb(Id, cb, lParam ?? 0)
        try {
            result := SendMessage(TVM_SORTCHILDREN, 0, _tvSortCb.Ptr, this.Hwnd)
        } catch Error as err {
            CallbackFree(cb)
            throw err
        }
        CallbackFree(cb)
        return result
    }
    Toggle(Id) => SendMessage(TVM_EXPAND, TVE_TOGGLE, Id, this.Hwnd)
}
