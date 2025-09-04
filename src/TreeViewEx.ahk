
; https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/structs/Rect.ahk
#include <Rect>

#include lib.ahk
#include TreeViewNode.ahk
#include TvHitTestInfo.ahk
#include TvSortCb.ahk
#include TvInsertStructW.ahk
#include TvDispInfoExW.ahk
#include TvItemW.ahk
#include TvItemExW.ahk
#include TreeViewExTemplatesCollection.ahk

; See the README for tested methods and properties.

class TreeViewEx extends Gui.TreeView {
    static __New() {
        this.DeleteProp('__New')
        this.SetConstants()
        proto := this.Prototype
        proto.__HandlerChildrenGet :=
        proto.__HandlerImageGet := proto.__HandlerImageSet :=
        proto.__HandlerSelectedImageGet := proto.__HandlerSelectedImageSet :=
        proto.__HandlerNameGet := proto.__HandlerNameSet :=
        proto.__HandlerGetDispInfoW := proto.__HandlerSetDispInfoW := ''
    }
    static Call(GuiObj, Opt?) {
        tv := GuiObj.Add('TreeView', Opt ?? unset)
        ObjSetBase(tv, this.Prototype)
        return tv
    }
    static SetConstants() {
        global

        TVEX_DEFAULT_ENCODING := 'cp1200'

        TV_FIRST := 0x1100

        ; TVM_INSERTITEMA            := TV_FIRST + 0
        TVM_INSERTITEMW            := TV_FIRST + 50
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
        TVM_GETITEMW               := TV_FIRST + 62
        ; TVM_SETITEMA               := TV_FIRST + 13
        TVM_SETITEMW               := TV_FIRST + 63
        ; TVM_EDITLABELA             := TV_FIRST + 14
        TVM_EDITLABELW             := TV_FIRST + 65
        TVM_GETEDITCONTROL         := TV_FIRST + 15
        TVM_GETVISIBLECOUNT        := TV_FIRST + 16
        TVM_HITTEST                := TV_FIRST + 17
        TVM_CREATEDRAGIMAGE        := TV_FIRST + 18
        TVM_SORTCHILDREN           := TV_FIRST + 19
        TVM_ENSUREVISIBLE          := TV_FIRST + 20
        TVM_SORTCHILDRENCB         := TV_FIRST + 21
        TVM_ENDEDITLABELNOW        := TV_FIRST + 22
        ; TVM_GETISEARCHSTRINGA      := TV_FIRST + 23
        TVM_GETISEARCHSTRINGW      := TV_FIRST + 64
        TVM_SETTOOLTIPS            := TV_FIRST + 24
        TVM_GETTOOLTIPS            := TV_FIRST + 25
        TVM_SETINSERTMARK          := TV_FIRST + 26
        TVM_SETITEMHEIGHT          := TV_FIRST + 27
        TVM_GETITEMHEIGHT          := TV_FIRST + 28
        TVM_SETBKCOLOR             := TV_FIRST + 29
        TVM_SETTEXTCOLOR           := TV_FIRST + 30
        TVM_GETBKCOLOR             := TV_FIRST + 31
        TVM_GETTEXTCOLOR           := TV_FIRST + 32
        TVM_SETSCROLLTIME          := TV_FIRST + 33
        TVM_GETSCROLLTIME          := TV_FIRST + 34
        TVM_SETINSERTMARKCOLOR     := TV_FIRST + 37
        TVM_GETINSERTMARKCOLOR     := TV_FIRST + 38
        TVM_SETBORDER              := TV_FIRST + 35
        TVM_GETITEMSTATE           := TV_FIRST + 39
        TVM_SETLINECOLOR           := TV_FIRST + 40
        TVM_GETLINECOLOR           := TV_FIRST + 41
        TVM_MAPACCIDTOHTREEITEM    := TV_FIRST + 42
        TVM_MAPHTREEITEMTOACCID    := TV_FIRST + 43
        TVM_SETEXTENDEDSTYLE       := TV_FIRST + 44
        TVM_GETEXTENDEDSTYLE       := TV_FIRST + 45
        TVM_SETAUTOSCROLLINFO      := TV_FIRST + 59
        ; TVM_SETHOT                 := TV_FIRST + 58
        ; TVM_GETSELECTEDCOUNT       := TV_FIRST + 70
        TVM_SHOWINFOTIP            := TV_FIRST + 71

        TVN_FIRST                  := -400
        TVN_LAST                   := -499

        ; TVN_SELCHANGINGW           := TVN_FIRST - 50
        ; TVN_SELCHANGEDW            := TVN_FIRST - 51
        TVN_GETDISPINFOW           := TVN_FIRST - 52
        TVN_SETDISPINFOW           := TVN_FIRST - 53
        ; TVN_ITEMEXPANDINGW         := TVN_FIRST - 54
        ; TVN_ITEMEXPANDEDW          := TVN_FIRST - 55
        ; TVN_BEGINDRAGW             := TVN_FIRST - 56
        ; TVN_BEGINRDRAGW            := TVN_FIRST - 57
        ; TVN_DELETEITEMW            := TVN_FIRST - 58
        ; TVN_BEGINLABELEDITW        := TVN_FIRST - 59
        ; TVN_ENDLABELEDITW          := TVN_FIRST - 60
        ; TVN_KEYDOWN                := TVN_FIRST - 12
        ; TVN_GETINFOTIPW            := TVN_FIRST - 14
        ; TVN_SINGLEEXPAND           := TVN_FIRST - 15
        ; TVN_ITEMCHANGINGW          := TVN_FIRST - 17
        ; TVN_ITEMCHANGEDW           := TVN_FIRST - 19
        ; TVN_ASYNCDRAW              := TVN_FIRST - 20

        ; TVN_SELCHANGINGA           := TVN_FIRST - 1
        ; TVN_SELCHANGEDA            := TVN_FIRST - 2
        ; TVN_GETDISPINFOA           := TVN_FIRST - 3
        ; TVN_SETDISPINFOA           := TVN_FIRST - 4
        ; TVN_ITEMEXPANDINGA         := TVN_FIRST - 5
        ; TVN_ITEMEXPANDEDA          := TVN_FIRST - 6
        ; TVN_BEGINDRAGA             := TVN_FIRST - 7
        ; TVN_BEGINRDRAGA            := TVN_FIRST - 8
        ; TVN_DELETEITEMA            := TVN_FIRST - 9
        ; TVN_BEGINLABELEDITA        := TVN_FIRST - 10
        ; TVN_ENDLABELEDITA          := TVN_FIRST - 11
        ; TVN_GETINFOTIPA            := TVN_FIRST - 13
        ; TVN_ITEMCHANGINGA          := TVN_FIRST - 16
        ; TVN_ITEMCHANGEDA           := TVN_FIRST - 18

        TVIF_DI_SETITEM            := 0x1000

        TVNRET_DEFAULT             := 0
        TVNRET_SKIPOLD             := 1
        TVNRET_SKIPNEW             := 2

        TVC_UNKNOWN                := 0x0000
        TVC_BYMOUSE                := 0x0001
        TVC_BYKEYBOARD             := 0x0002

        TVE_COLLAPSE               := 0x0001
        TVE_EXPAND                 := 0x0002
        TVE_TOGGLE                 := 0x0003
        TVE_EXPANDPARTIAL          := 0x4000
        TVE_COLLAPSERESET          := 0x8000

        TVI_ROOT                   := -0x10000
        TVI_FIRST                  := -0x0FFFF
        TVI_LAST                   := -0x0FFFE
        TVI_SORT                   := -0x0FFFD

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

        TVIF_TEXT                  := 0x0001
        TVIF_IMAGE                 := 0x0002
        TVIF_PARAM                 := 0x0004
        TVIF_STATE                 := 0x0008
        TVIF_HANDLE                := 0x0010
        TVIF_SELECTEDIMAGE         := 0x0020
        TVIF_CHILDREN              := 0x0040
        TVIF_INTEGRAL              := 0x0080
        TVIF_STATEEX               := 0x0100
        TVIF_EXPANDEDIMAGE         := 0x0200

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

        TVS_HASBUTTONS             := 0x0001
        TVS_HASLINES               := 0x0002
        TVS_LINESATROOT            := 0x0004
        TVS_EDITLABELS             := 0x0008
        TVS_DISABLEDRAGDROP        := 0x0010
        TVS_SHOWSELALWAYS          := 0x0020
        TVS_RTLREADING             := 0x0040
        TVS_NOTOOLTIPS             := 0x0080
        TVS_CHECKBOXES             := 0x0100
        TVS_TRACKSELECT            := 0x0200
        TVS_SINGLEEXPAND           := 0x0400
        TVS_INFOTIP                := 0x0800
        TVS_FULLROWSELECT          := 0x1000
        TVS_NOSCROLL               := 0x2000
        TVS_NONEVENHEIGHT          := 0x4000
        TVS_NOHSCROLL              := 0x8000

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

        TVIS_SELECTED              := 0x0002
        TVIS_CUT                   := 0x0004
        TVIS_DROPHILITED           := 0x0008
        TVIS_BOLD                  := 0x0010
        TVIS_EXPANDED              := 0x0020
        TVIS_EXPANDEDONCE          := 0x0040
        TVIS_EXPANDPARTIAL         := 0x0080
        TVIS_OVERLAYMASK           := 0x0F00
        TVIS_STATEIMAGEMASK        := 0xF000
        TVIS_USERMASK              := 0xF000
        TVIS_EX_FLAT               := 0x0001
        TVIS_EX_DISABLED           := 0x0002
        TVIS_EX_ALL                := 0x0002

        I_CHILDRENCALLBACK         := -1
        I_CHILDRENAUTO             := -2

        CLR_NONE                   := 0xFFFFFFFF
        CLR_DEFAULT                := 0xFF000000

        LPSTR_TEXTCALLBACKW        := -1
    }
    /**
     * @param {Object} Obj - An objected with a nested structure representing nodes to be added
     * to the tree view control. The object must have a property that will be used as the node's
     * label, and may have a property that is an array of strings or objects. The strings will be added
     * as nodes with the string value as the label, and the objects are expected to follow this same
     * stucture and will be added as nodes accordingly. The object will be processed recursively.
     *
     * @param {String} [LabelProp = "Name"] - The name of the property that will be used to define
     * the node's label.
     *
     * @param {String} [ChildrenProp = "Children"] - The name of the property that may have an array
     * of strings/objects.
     *
     * @param {Integer} [MaxDepth = 0] - If a positive integer, the maximum depth limiting the function's
     * recursion. If zero or a negative integer, no limit will be imposed. The initial depth is 1.
     *
     * @param {Integer} [InitialParentId = 0] - The initial Id under which to start adding items.
     * If 0, the first item is added as a root node.
     *
     * @param {String} [Options] - A value to pass to the `Options` parameter of
     * {@link https://www.autohotkey.com/docs/v2/lib/TreeView.htm#Add `Gui.TreeView.Prototype.Add`}.
     */
    AddObj(Obj, LabelProp := 'Name', ChildrenProp := 'Children', MaxDepth := 0, InitialParentId := 0, Options?) {
        stack := [this.Add(Obj.%LabelProp%, InitialParentId, Options ?? unset)]
        if MaxDepth > 0 {
            if HasProp(Obj, ChildrenProp) && Obj.%ChildrenProp% is Array && stack.Length <= MaxDepth {
                _ProcessMaxDepth(Obj.%ChildrenProp%)
            }
        } else {
            if HasProp(Obj, ChildrenProp) && Obj.%ChildrenProp% is Array {
                _Process(Obj.%ChildrenProp%)
            }
        }

        _Process(List) {
            for val in List {
                if IsObject(val) {
                    if HasProp(val, ChildrenProp) && val.%ChildrenProp% is Array {
                        stack.Push(this.Add(val.%LabelProp%, stack[-1], Options ?? unset))
                        _Process(val.%ChildrenProp%)
                        stack.Pop()
                    } else {
                        this.Add(val.%LabelProp%, stack[-1], Options ?? unset)
                    }
                } else {
                    this.Add(val, stack[-1], Options ?? unset)
                }
            }
        }
        _ProcessMaxDepth(List) {
            for val in List {
                if IsObject(val) {
                    if HasProp(val, ChildrenProp) && val.%ChildrenProp% is Array && stack.Length < MaxDepth {
                        stack.Push(this.Add(val.%LabelProp%, stack[-1], Options ?? unset))
                        _ProcessMaxDepth(val.%ChildrenProp%)
                        stack.Pop()
                    } else {
                        this.Add(val.%LabelProp%, stack[-1], Options ?? unset)
                    }
                } else {
                    this.Add(val, stack[-1], Options ?? unset)
                }
            }
        }
    }
    /**
     * See {@link TreeViewEx.Prototype.AddObj} for descriptions of the parameters.
     * @param {Object[]} List - A list of objects as described in {@link TreeViewEx.Prototype.AddObj}.
     */
    AddObjList(List, LabelProp := 'Name', ChildrenProp := 'Children', MaxDepth := 0, InitialParentId := 0, Options?) {
        if MaxDepth > 0 {
            for Obj in List {
                stack := [this.Add(Obj.%LabelProp%, InitialParentId, Options ?? unset)]
                if HasProp(Obj, ChildrenProp) && Obj.%ChildrenProp% is Array && stack.Length <= MaxDepth {
                    _ProcessMaxDepth(Obj.%ChildrenProp%)
                }
            }
        } else {
            for Obj in List {
                stack := [this.Add(Obj.%LabelProp%, InitialParentId, Options ?? unset)]
                if HasProp(Obj, ChildrenProp) && Obj.%ChildrenProp% is Array {
                    _Process(Obj.%ChildrenProp%)
                }
            }
        }

        _Process(List) {
            for val in List {
                if IsObject(val) {
                    if HasProp(val, ChildrenProp) && val.%ChildrenProp% is Array {
                        stack.Push(this.Add(val.%LabelProp%, stack[-1], Options ?? unset))
                        _Process(val.%ChildrenProp%)
                        stack.Pop()
                    } else {
                        this.Add(val.%LabelProp%, stack[-1], Options ?? unset)
                    }
                } else {
                    this.Add(val, stack[-1], Options ?? unset)
                }
            }
        }
        _ProcessMaxDepth(List) {
            for val in List {
                if IsObject(val) {
                    if HasProp(val, ChildrenProp) && val.%ChildrenProp% is Array && stack.Length < MaxDepth {
                        stack.Push(this.Add(val.%LabelProp%, stack[-1], Options ?? unset))
                        _ProcessMaxDepth(val.%ChildrenProp%)
                        stack.Pop()
                    } else {
                        this.Add(val.%LabelProp%, stack[-1], Options ?? unset)
                    }
                } else {
                    this.Add(val, stack[-1], Options ?? unset)
                }
            }
        }
    }
    /**
     * Adds one or more items to the "Templates" map. The purpose of storing templates is to improve
     * performance by reusing structures with pre-set members for common tasks.
     *
     * @param {...*} Items - Key-value pairs where the value is an instance of
     * {@link TvInsertStructW}, {@link TvHitTestInfo}, {@link TvItemExW}, {@link TvItemW}, or
     * {@link TvSortCb}.
     */
    AddTemplate(Items*) {
        if !this.HasOwnProp('Templates') {
            this.Templates := TreeViewExTemplatesCollection(false)
        }
        name := this.AddTemplate.Name
        this.DefineProp('AddTemplate', { Call: _AddTemplate })
        this.AddTemplate.DefineProp('Name', { Value: name })
        this.AddTemplate(Items*)

        return

        _AddTemplate(Self, Items*) {
            this.Templates.Set(Items*)
        }
    }
    Collapse(Id) => SendMessage(TVM_EXPAND, TVE_COLLAPSE, Id, this.Hwnd)
    CollapseReset(Id) => SendMessage(TVM_EXPAND, TVE_COLLAPSERESET, Id, this.Hwnd)
    CopyItemId(Id) => A_Clipboard := Id
    CopyText(Id) => A_Clipboard := this.GetText(Id)
    CreateDragImage(Id) => SendMessage(TVM_CREATEDRAGIMAGE, 0, Id, this.Hwnd)
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
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-ensurevisible}.
     * @param {Integer} Id - The id of the item.
     * @returns {Integer} - Returns nonzero if the system scrolled the items in the tree-view control
     * and no items were expanded. Otherwise, the message returns zero.
     */
    EnsureVisible(Id) => SendMessage(TVM_ENSUREVISIBLE, 0, Id, this.Hwnd)
    EnumChildren(Id := 0, VarCount?) {
        child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Id, this.Hwnd)
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
    EnumChildrenRecursive(Id := 0, MaxDepth := 0, VarCount?) {
        enum := { Child: SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Id, this.Hwnd), Stack: [], Parent: Id }
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
                if (MaxDepth <= 0 || Self.Stack.Length < MaxDepth) && child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, _Id, this.Hwnd) {
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
                if (MaxDepth <= 0 || Self.Stack.Length < MaxDepth) && child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, _Id, this.Hwnd) {
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
    GetBkColor() => SendMessage(TVM_GETBKCOLOR, 0, 0, this.Hwnd)
    GetEditControl() => SendMessage(TVM_GETEDITCONTROL, 0, 0, this.Hwnd)
    GetExtendedStyle() => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd)
    GetImageList(ImageListType) => SendMessage(TVM_GETIMAGELIST, ImageListType, 0, this.Hwnd)
    GetIndent() => SendMessage(TVM_GETINDENT, 0, 0, this.Hwnd)
    GetInsertMarkColor() => SendMessage(TVM_GETINSERTMARKCOLOR, 0, 0, this.Hwnd)
    /**
     * Tree-views maintain an “incremental search string” when the user types while the control has
     * focus. Example: if you have items Apple, Banana, Cherry and the user types “c”, then “h”, the
     * buffer contains "ch" until it times out.
     */
    GetISearchString() {
        if n := SendMessage(TVM_GETISEARCHSTRINGW, 0, 0, this.Hwnd) {
            buf := Buffer(n * 2 + 2)
            SendMessage(TVM_GETISEARCHSTRINGW, 0, buf.Ptr, this.Hwnd)
            return StrGet(buf, TVEX_DEFAULT_ENCODING)
        }
    }
    GetItem(Struct) => SendMessage(TVM_GETITEMW, 0, Struct.Ptr, this.Hwnd)
    GetItemHeight() => SendMessage(TVM_GETITEMHEIGHT, 0, 0, this.Hwnd)
    GetItemRect(Id) {
        rc := Rect()
        NumPut('ptr', Id, rc, 0)
        if SendMessage(TVM_GETITEMRECT, 1, rc.ptr, this.Hwnd) {
            return rc
        }
    }
    GetItemState(Id, Mask) => SendMessage(TVM_GETITEMSTATE, Id, Mask, this.Hwnd)
    GetLineColor() => SendMessage(TVM_GETLINECOLOR, 0, 0, this.Hwnd)
    GetLineRect(Id) {
        rc := Rect()
        NumPut('ptr', Id, rc, 0)
        if SendMessage(TVM_GETITEMRECT, 0, rc.ptr, this.Hwnd) {
            return rc
        }
    }
    GetRoot(Id) => SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, Id, this.Hwnd)
    GetScrollTime() => SendMessage(TVM_GETSCROLLTIME, 0, 0, this.Hwnd)
    GetTextColor() => SendMessage(TVM_GETTEXTCOLOR, 0, 0, this.Hwnd)
    GetTooltips() => SendMessage(TVM_GETTOOLTIPS, 0, 0, this.Hwnd)
    GetVisibleCount() => SendMessage(TVM_GETVISIBLECOUNT, 0, 0, this.Hwnd)
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
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-insertitem}
     * @param {TvInsertStructW} Struct - {@link TvInsertStructW}
     */
    Insert(Struct) => SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd)
    IsParent(Id) => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Id, this.Hwnd) ? 1 : 0
    IsRoot(Id) => !SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Id, this.Hwnd)
    MapAccIdToHTreeItem(AccId) => SendMessage(TVM_MAPACCIDTOHTREEITEM, AccId, 0, this.Hwnd)
    MapHTreeItemToAccId(Id) => SendMessage(TVM_MAPHTREEITEMTOACCID, Id, 0, this.Hwnd)
    Select(Id) => SendMessage(TVM_SELECTITEM, TVGN_CARET, Id, this.Hwnd)
    SetAutoScrollInfo(PixelsPerSecond, RedrawInterval) => SendMessage(TVM_SETAUTOSCROLLINFO, PixelsPerSecond, RedrawInterval, this.Hwnd)
    SetBkColor(Color) => SendMessage(TVM_SETBKCOLOR, 0, Color, this.Hwnd)
    SetBorder(Flags, SizeHoriz, SizeVert, &OutOldHoriz?, &OutOldVert?) {
        result := SendMessage(TVM_SETBORDER, Flags, (SizeVert & 0xFFFF) << 16 | (SizeHoriz & 0xFFFF), this.Hwnd)
        OutOldHoriz := result & 0xFFFF
        OutOldVert := (result >> 16) & 0xFFFF
    }
    SetChildrenHandler(CallbackGet) {
        this.__SetHandler(CallbackGet, 'ChildrenGet', 'G')
    }
    /**
     *
     */
    SetExtendedStyle(Value, Styles) => SendMessage(TVM_SETEXTENDEDSTYLE, Value, Styles, this.Hwnd)
    SetGetDispInfoWHandler(Callback := TreeViewEx_HandlerGetDispInfoW, AddRemove := 1) {
        this.__SetDispInfoWHandler(Callback, AddRemove, 'G')
    }
    SetImageHandler(CallbackGet?, CallbackSet?) {
        if IsSet(CallbackGet) {
            this.__SetHandler(CallbackGet, 'ImageGet', 'G')
        }
        if IsSet(CallbackSet) {
            this.__SetHandler(CallbackSet, 'ImageSet', 'S')
        }
    }
    SetImageList(ImageListType, Handle) => SendMessage(TVM_SETIMAGELIST, ImageListType, Handle, this.Hwnd)
    SetIndent(Value) => SendMessage(TVM_SETINDENT, Value, 0, this.Hwnd)
    SetInsertMark(Id, AfterItem := false) => SendMessage(TVM_SETINSERTMARK, AfterItem, Id, this.Hwnd)
    SetInsertMarkColor(Color) => SendMessage(TVM_SETINSERTMARKCOLOR, 0, Color, this.Hwnd)
    SetItem(Struct) => SendMessage(TVM_SETITEMW, 0, Struct.Ptr, this.Hwnd)
    SetItemHeight(Height) => SendMessage(TVM_SETITEMHEIGHT, Height, 0, this.Hwnd)
    SetLineColor(Color) => SendMessage(TVM_SETLINECOLOR, 0, Color, this.Hwnd)
    SetNameHandler(CallbackGet?, CallbackSet?) {
        if IsSet(CallbackGet) {
            this.__SetHandler(CallbackGet, 'NameGet', 'G')
        }
        if IsSet(CallbackSet) {
            this.__SetHandler(CallbackSet, 'NameSet', 'S')
        }
    }
    SetNodeConstructor(NodeClass) {
        this.Constructor := Class()
        this.Constructor.Base := NodeClass
        this.Constructor.Prototype := {
            HwndTv: this.Hwnd
          , __Class: NodeClass.Prototype.__Class
        }
        ObjSetBase(this.Constructor.Prototype, NodeClass.Prototype)
    }
    SetScrollTime(TimeMs) => SendMessage(TVM_SETSCROLLTIME, TimeMs, 0, this.Hwnd)
    SetSelectedImageHandler(CallbackGet?, CallbackSet?) {
        if IsSet(CallbackGet) {
            this.__SetHandler(CallbackGet, 'SelectedImageGet', 'G')
        }
        if IsSet(CallbackSet) {
            this.__SetHandler(CallbackSet, 'SelectedImageSet', 'S')
        }
    }
    SetSetDispInfoWHandler(Callback := TreeViewEx_HandlerSetDispInfoW, AddRemove := 1) {
        this.__SetDispInfoWHandler(Callback, AddRemove, 'S')
    }
    SetTextColor(Color) => SendMessage(TVM_SETTEXTCOLOR, 0, Color, this.Hwnd)
    SetTooltips(Handle) => SendMessage(TVM_SETTOOLTIPS, Handle, 0, this.Hwnd)
    ShowInfoTip(Id) => SendMessage(TVM_SHOWINFOTIP, 0, Id, this.Hwnd)
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
    __SetDispInfoWHandler(Callback, AddRemove, Which) {
        if IsObject(this.__Handler%Which%etDispInfoW) {
            this.OnNotify(TVN_%Which%ETDISPINFOW, this.__Handler%Which%etDispInfoW, 0)
        }
        if AddRemove {
            this.__Handler%Which%etDispInfoW := Callback
            this.OnNotify(TVN_%Which%ETDISPINFOW, Callback, AddRemove)
        } else {
            this.__Handler%Which%etDispInfoW := ''
        }
    }
    __SetHandler(Callback, Name, Which) {
        if Callback {
            this.__Handler%Name% := Callback
            if !IsObject(this.__Handler%Which%etDispInfoW) {
                this.Set%Which%etDispInfoWHandler()
            }
        } else {
            this.__Handler%Name% := ''
            if IsObject(this.__Handler%Which%etDispInfoW) {
                if (Which = 'S' || !IsObject(this.__HandlerChildrenGet))
                && !IsObject(this.__HandlerImage%Which%et)
                && !IsObject(this.__HandlerSelectedImage%Which%et)
                && !IsObject(this.__HandlerName%Which%et) {
                    this.Set%Which%etDispInfoWHandler(this.__Handler%Which%etDispInfoW, 0)
                }
            }
        }
    }
    AutoHScroll {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_AUTOHSCROLL
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_AUTOHSCROLL, TVS_EX_AUTOHSCROLL, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_AUTOHSCROLL, this.Hwnd)
            }
        }
    }
    Checkboxes {
        Get => WinGetStyle(this.Hwnd) & TVS_CHECKBOXES
        Set {
            if Value {
                WinSetStyle('+' TVS_CHECKBOXES, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_CHECKBOXES, this.Hwnd)
            }
        }
    }
    DimmedCheckboxes {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_DIMMEDCHECKBOXES
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_DIMMEDCHECKBOXES, TVS_EX_DIMMEDCHECKBOXES, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_DIMMEDCHECKBOXES, this.Hwnd)
            }
        }
    }
    DisableDragDrop {
        Get => WinGetStyle(this.Hwnd) & TVS_DISABLEDRAGDROP
        Set {
            if Value {
                WinSetStyle('+' TVS_DISABLEDRAGDROP, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_DISABLEDRAGDROP, this.Hwnd)
            }
        }
    }
    DoubleBuffer {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_DOUBLEBUFFER
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_DOUBLEBUFFER, TVS_EX_DOUBLEBUFFER, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_DOUBLEBUFFER, this.Hwnd)
            }
        }
    }
    DrawImageAsync {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_DRAWIMAGEASYNC
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_DRAWIMAGEASYNC, TVS_EX_DRAWIMAGEASYNC, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_DRAWIMAGEASYNC, this.Hwnd)
            }
        }
    }
    EditLabels {
        Get => WinGetStyle(this.Hwnd) & TVS_EDITLABELS
        Set {
            if Value {
                WinSetStyle('+' TVS_EDITLABELS, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_EDITLABELS, this.Hwnd)
            }
        }
    }
    ExclusionCheckboxes {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_EXCLUSIONCHECKBOXES
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_EXCLUSIONCHECKBOXES, TVS_EX_EXCLUSIONCHECKBOXES, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_EXCLUSIONCHECKBOXES, this.Hwnd)
            }
        }
    }
    FadeInOutExpandos {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_FADEINOUTEXPANDOS
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_FADEINOUTEXPANDOS, TVS_EX_FADEINOUTEXPANDOS, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_FADEINOUTEXPANDOS, this.Hwnd)
            }
        }
    }
    FullRowselect {
        Get => WinGetStyle(this.Hwnd) & TVS_FULLROWSELECT
        Set {
            if Value {
                WinSetStyle('+' TVS_FULLROWSELECT, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_FULLROWSELECT, this.Hwnd)
            }
        }
    }
    HandlerChildrenGet {
        Get => this.__HandlerChildrenGet
        Set => this.SetChildrenHandler(Value)
    }
    HandlerGetDispInfoW {
        Get => this.__HandlerGetDispInfoW
        Set => this.SetGetDispInfoWHandler(Value)
    }
    HandlerImageGet {
        Get => this.__HandlerImageGet
        Set => this.SetImageHandler(Value)
    }
    HandlerImageSet {
        Get => this.__HandlerImageSet
        Set => this.SetImageHandler(, Value)
    }
    HandlerNameGet {
        Get => this.__HandlerNameGet
        Set => this.SetNameGetHandler(Value)
    }
    HandlerNameSet {
        Get => this.__HandlerNameSet
        Set => this.SetNameSetHandler(, Value)
    }
    HandlerSelectedImageGet {
        Get => this.__HandlerSelectedImageGet
        Set => this.SetSelectedImageGetHandler(Value)
    }
    HandlerSelectedImageSet {
        Get => this.__HandlerSelectedImageSet
        Set => this.SetSelectedImageSetHandler(, Value)
    }
    HandlerSetDispInfoW {
        Get => this.__HandlerSetDispInfoW
        Set => this.SetSetDispInfoWHandler(Value)
    }
    HasButtons {
        Get => WinGetStyle(this.Hwnd) & TVS_HASBUTTONS
        Set {
            if Value {
                WinSetStyle('+' TVS_HASBUTTONS, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_HASBUTTONS, this.Hwnd)
            }
        }
    }
    HasLines {
        Get => WinGetStyle(this.Hwnd) & TVS_HASLINES
        Set {
            if Value {
                WinSetStyle('+' TVS_HASLINES, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_HASLINES, this.Hwnd)
            }
        }
    }
    Infotip {
        Get => WinGetStyle(this.Hwnd) & TVS_INFOTIP
        Set {
            if Value {
                WinSetStyle('+' TVS_INFOTIP, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_INFOTIP, this.Hwnd)
            }
        }
    }
    LinesAtRoot {
        Get => WinGetStyle(this.Hwnd) & TVS_LINESATROOT
        Set {
            if Value {
                WinSetStyle('+' TVS_LINESATROOT, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_LINESATROOT, this.Hwnd)
            }
        }
    }
    MultiSelect {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_MULTISELECT
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_MULTISELECT, TVS_EX_MULTISELECT, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_MULTISELECT, this.Hwnd)
            }
        }
    }
    NoHScroll {
        Get => WinGetStyle(this.Hwnd) & TVS_NOHSCROLL
        Set {
            if Value {
                WinSetStyle('+' TVS_NOHSCROLL, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_NOHSCROLL, this.Hwnd)
            }
        }
    }
    NoIndentState {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_NOINDENTSTATE
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_NOINDENTSTATE, TVS_EX_NOINDENTSTATE, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_NOINDENTSTATE, this.Hwnd)
            }
        }
    }
    NonEvenHeight {
        Get => WinGetStyle(this.Hwnd) & TVS_NONEVENHEIGHT
        Set {
            if Value {
                WinSetStyle('+' TVS_NONEVENHEIGHT, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_NONEVENHEIGHT, this.Hwnd)
            }
        }
    }
    NoScroll {
        Get => WinGetStyle(this.Hwnd) & TVS_NOSCROLL
        Set {
            if Value {
                WinSetStyle('+' TVS_NOSCROLL, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_NOSCROLL, this.Hwnd)
            }
        }
    }
    NoSingleCollapse {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_NOSINGLECOLLAPSE
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_NOSINGLECOLLAPSE, TVS_EX_NOSINGLECOLLAPSE, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_NOSINGLECOLLAPSE, this.Hwnd)
            }
        }
    }
    NoTooltips {
        Get => WinGetStyle(this.Hwnd) & TVS_NOTOOLTIPS
        Set {
            if Value {
                WinSetStyle('+' TVS_NOTOOLTIPS, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_NOTOOLTIPS, this.Hwnd)
            }
        }
    }
    PartialCheckboxes {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_PARTIALCHECKBOXES
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_PARTIALCHECKBOXES, TVS_EX_PARTIALCHECKBOXES, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_PARTIALCHECKBOXES, this.Hwnd)
            }
        }
    }
    RichTooltip {
        Get => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd) & TVS_EX_RICHTOOLTIP
        Set {
            if Value {
                SendMessage(TVM_SETEXTENDEDSTYLE, TVS_EX_RICHTOOLTIP, TVS_EX_RICHTOOLTIP, this.Hwnd)
            } else {
                SendMessage(TVM_SETEXTENDEDSTYLE, 0, TVS_EX_RICHTOOLTIP, this.Hwnd)
            }
        }
    }
    RtlReading {
        Get => WinGetStyle(this.Hwnd) & TVS_RTLREADING
        Set {
            if Value {
                WinSetStyle('+' TVS_RTLREADING, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_RTLREADING, this.Hwnd)
            }
        }
    }
    ShowSelAlways {
        Get => WinGetStyle(this.Hwnd) & TVS_SHOWSELALWAYS
        Set {
            if Value {
                WinSetStyle('+' TVS_SHOWSELALWAYS, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_SHOWSELALWAYS, this.Hwnd)
            }
        }
    }
    SingleExpand {
        Get => WinGetStyle(this.Hwnd) & TVS_SINGLEEXPAND
        Set {
            if Value {
                WinSetStyle('+' TVS_SINGLEEXPAND, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_SINGLEEXPAND, this.Hwnd)
            }
        }
    }
    TrackSelect {
        Get => WinGetStyle(this.Hwnd) & TVS_TRACKSELECT
        Set {
            if Value {
                WinSetStyle('+' TVS_TRACKSELECT, this.Hwnd)
            } else {
                WinSetStyle('-' TVS_TRACKSELECT, this.Hwnd)
            }
        }
    }
}
