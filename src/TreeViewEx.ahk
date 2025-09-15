/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

; https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/structs/Rect.ahk
#include <Rect>
; https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/Win32/WindowSubclass.ahk
#include <WindowSubclass>
; https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/LibraryManager.ahk
#include <LibraryManager>

#include lib.ahk
#include NmTreeView.ahk
#include notify-node-c.ahk
#include notify-node-ptr.ahk
#include notify-node.ahk
#include TreeViewExCollections.ahk
#include TreeViewExLogFont.ahk
#include TreeViewExNode.ahk
#include TreeViewExStructBase.ahk
#include TreeViewExWindowSubclassManager.ahk
#include TvAsyncDraw.ahk
#include TvDispInfoEx.ahk
#include TvGetInfoTip.ahk
#include TvHitTestInfo.ahk
#include TvImageListDrawParams.ahk
#include TvInsertStruct.ahk
#include TvItem.ahk
#include TvItemChange.ahk
#include TvItemEx.ahk
#include TvKeyDown.ahk
#include TvNmHdr.ahk
#include TvSortCb.ahk

; See the README for tested methods and properties.

class TreeViewEx {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.Constructor := proto.Collection := ''
        if !IsSet(TVS_HASBUTTONS) {
            TreeViewEx_SetConstants()
        }
        this.ClassName := Buffer(StrPut('SysTreeView32', TVEX_DEFAULT_ENCODING))
        StrPut('SysTreeView32', this.ClassName, TVEX_DEFAULT_ENCODING)
    }
    __New(HwndGui, Options?) {
        options := TreeViewEx.Options(Options ?? unset)
        this.HwndGui := HwndGui
        g := this.Gui
        this.Hwnd := DllCall(
            g_proc_user32_CreateWindowExW
          , 'uint', options.ExStyle            ; dwExStyle
          , 'ptr', TreeViewEx.ClassName        ; lpClassName
          , 'ptr', options.WindowName
          , 'uint', options.Style              ; dwStyle
          , 'int', IsNumber(options.X) ? options.X : g.MarginX            ; X
          , 'int', IsNumber(options.Y) ? options.Y : g.MarginY            ; Y
          , 'int', options.Width             ; nWidth
          , 'int', IsNumber(options.Height) ? options.Height : 10            ; nHeight
          , 'ptr', HwndGui               ; hWndParent
          , 'ptr', IsObject(options.Menu) ? options.Menu.Hwnd : options.Menu
          , 'ptr', options.Instance
          , 'ptr', options.Param
        )
        if options.Rows || !options.Height {
            WinMove(, , , (options.Rows || 1) * this.GetItemHeight(), this.Hwnd)
        }
    }
    /**
     * Creates a node object, sets `Struct.lParam := ObjPtrAddRef(node)`, then adds the node to the
     * tree-view.
     *
     * There are two reasons for setting `lParam` with the ptr of the node object:
     * - To prevent the node object from being deleted because this version of the method does
     *   not add it to a collection.
     * - To enable the the use of the notification callback functions that end in "_Ptr".
     *   These functions are likely the most efficient.
     *
     * Managing the collection directly using {@link TreeViewEx.Prototype.AddNode_C} might be
     * more useful in cases when your code needs to regularly access specific node objects outside
     * of the context of a WM_NOTIFY handler. If your code only accesses the nodes from within
     * the context of the WM_NOTIFY handlers, using this method will be more efficient.
     *
     * If you use `SetParam`, your code must set a TVN_DELETEITEMW handler that includes calling
     * `ObjRelease(struct.lParam)` to allow the node object to be deleted. The demo file
     * {@link Demo "test\demo-NotificationHandlers.ahk"} has an example of this.
     *
     * @param {TvInsertStruct} Struct - An instance of {@link TvInsertStruct} that is sent with
     * TVM_INSERTITEMW.
     *
     * @param {...*} [Params] - Any parameters that must be passed to the node constructor.
     */
    AddNode(Struct, Params*) {
        if !IsObject(Struct) {
            Struct := this.Templates.Get(Struct)
        }
        if Params.Length {
            global g_TreeViewEx_Node := this.Constructor.Call(0, Params*)
        } else {
            global g_TreeViewEx_Node := this.Constructor.Call(0)
        }
        local node := g_TreeViewEx_Node
        Struct.lParam := ObjPtrAddRef(node)
        if handle := SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
            node.Handle := handle
            g_TreeViewEx_Node := ''
            return node
        }
    }
    /**
     * Creates a node object, then adds the node to the tree-view, then adds the node to the
     * collection {@link TreeViewEx#Collection}.
     *
     * @param {TvInsertStruct} Struct - An instance of {@link TvInsertStruct} that is sent with
     * TVM_INSERTITEMW.
     *
     * @param {Boolean} [SetParam = false] - If true, ets the member `lParam` with `ObjPtrAddRef(node)`.
     *
     * The purpose of setting `lParam` with the ptr of the node object is to enable the the use of
     * the notification callback functions that end in "_Ptr". These functions are likely the most
     * efficient. When `SetParam` is used, it adds one reference to the reference table for the node
     * object, meaning the node object will not be deleted automatically even if it goes out of scope.
     *
     * If you use `SetParam`, your code must set a TVN_DELETEITEMW handler that includes calling
     * `ObjRelease(struct.lParam)` to allow the node object to be deleted. The demo file
     * {@link Demo "test\demo-NotificationHandlers.ahk"} has an example of this.
     *
     * @param {...*} [Params] - Any parameters that must be passed to the node constructor.
     */
    AddNode_C(Struct, SetParam := false, Params*) {
        if !IsObject(Struct) {
            Struct := this.Templates.Get(Struct)
        }
        if Params.Length {
            node := this.Constructor.Call(0, Params*)
        } else {
            node := this.Constructor.Call(0)
        }
        if SetParam {
            Struct.lParam := ObjPtrAddRef(node)
        }
        this.Collection.Default := node
        if handle := SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
            node.Handle := handle
            this.Collection.Set(handle, node)
            this.Collection.Default := ''
            return node
        }
    }
    /**
     * @param {Object} Obj - An object with a nested structure representing nodes to be added
     * to the tree view control. The object must have a property that will be used as the node's
     * label, and may have a property that is an array of strings or objects. The strings will be
     * added as nodes with the string Obj.%LabelProp%ue as the label, and the objects are expected to follow this
     * same stucture and will be added as nodes accordingly. The object will be processed recursively.
     *
     * @param {String} [Options] - A Obj.%LabelProp%ue to pass to the `Options` parameter of
     * {@link https://www.autohotkey.com/docs/v2/lib/TreeView.htm#Add `Gui.TreeView.Prototype.Add`}.
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
     * @param {Integer} [InitialParentId = 0] - The initial Handle under which to start adding items.
     * If 0, the first item is added as a root node.
     */
    AddObj(Obj, LabelProp := 'Name', ChildrenProp := 'Children', MaxDepth := 0, InitialParentId := 0) {
        struct := TvInsertStruct()
        struct.mask := TVIF_TEXT
        this.AddObjListFromTemplate([ Obj ], struct, LabelProp, ChildrenProp, MaxDepth, InitialParentId)
    }
    /**
     * @param {Object[]|String[]} List - A list of objects or strings. The strings are added as items
     * where the string Obj.%LabelProp%ue is the item text. The objects have a nested structure representing
     * nodes to be added to the tree view control. The object must have a property that will be used
     * as the node's label, and may have a property that is an array of strings or objects. The strings
     * will be added as nodes with the string Obj.%LabelProp%ue as the label, and the objects are expected to
     * follow this same stucture and will be added as nodes accordingly. The object will be processed
     * recursively.
     *
     * @param {String} [Options] - A Obj.%LabelProp%ue to pass to the `Options` parameter of
     * {@link https://www.autohotkey.com/docs/v2/lib/TreeView.htm#Add `Gui.TreeView.Prototype.Add`}.
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
     * @param {Integer} [InitialParentId = 0] - The initial Handle under which to start adding items.
     * If 0, the first item is added as a root node.
     */
    AddObjList(List, LabelProp := 'Name', ChildrenProp := 'Children', MaxDepth := 0, InitialParentId := 0) {
        struct := TvInsertStruct()
        struct.mask := TVIF_TEXT
        this.AddObjListFromTemplate(List, struct, LabelProp, ChildrenProp, MaxDepth, InitialParentId)
    }
    /**
     * Performs the same action as {@link TreeViewEx.Prototype.AddObjList}, but instead of specifying
     * options, you specify a template structure that is sent with
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-insertitem TVM_INSERTITEM}
     * messages.
     *
     * @param {Object[]|String[]} List - A list of objects or strings. The strings are added as items
     * where the string value is the item text. The objects have a nested structure representing
     * nodes to be added to the tree view control. The object must have a property that will be used
     * as the node's label, and may have a property that is an array of strings or objects. The strings
     * will be added as nodes with the string value as the label, and the objects are expected to
     * follow this same stucture and will be added as nodes accordingly. The object will be processed
     * recursively.
     *
     * @param {String|TvInsertStruct} Struct - If a string, the name of a template {@link TvInsertStruct}
     * stored by {@link TreeViewEx.Prototype.AddTemplate}. The {@link TvInsertStruct} object is used
     * as the foundation for each
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-insertitem TVM_INSERTITEM}
     * message sent to the tree-view control. The structure is cloned, then the values of
     * {@link TvInsertStruct#hParent} and {@link TvInsertStruct#pszText} are modified according
     * to the object structure defined by `List` and `InitialParentId`.
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
     * @param {Integer} [InitialParentId = 0] - The initial Handle under which to start adding items.
     * If 0, the first item is added as a root node.
     */
    AddObjListFromTemplate(List, Struct, LabelProp := 'Name', ChildrenProp := 'Children', MaxDepth := 0, InitialParentId := 0) {
        if IsObject(Struct) {
            Struct := Struct.Clone()
        } else {
            Struct := this.Templates.Get(Struct).Clone()
        }
        Struct.hParent := InitialParentId
        stack := ['']
        if MaxDepth > 0 {
            for val in List {
                if IsObject(val) {
                    Struct.pszText := val.%LabelProp%
                    if HasProp(val, ChildrenProp) && val.%ChildrenProp% is Array && stack.Length <= MaxDepth {
                        if id := SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                            stack.Push(id)
                            _ProcessMaxDepth(val.%ChildrenProp%)
                            stack.Pop()
                            Struct.hParent := InitialParentId
                        } else {
                            _Throw()
                        }
                    } else if !SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                        _Throw()
                    }
                } else {
                    Struct.pszText := val
                    if !SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                        _Throw()
                    }
                }
            }
        } else {
            for val in List {
                if IsObject(val) {
                    Struct.pszText := val.%LabelProp%
                    if HasProp(val, ChildrenProp) && val.%ChildrenProp% is Array {
                        if id := SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                            stack.Push(id)
                            _Process(val.%ChildrenProp%)
                            stack.Pop()
                            Struct.hParent := InitialParentId
                        } else {
                            _Throw()
                        }
                    } else if !SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                        _Throw()
                    }
                } else {
                    Struct.pszText := val
                    if !SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                        _Throw()
                    }
                }
            }
        }

        _Process(List) {
            Struct.hParent := stack[-1]
            for val in List {
                if IsObject(val) {
                    Struct.pszText := val.%LabelProp%
                    if id := SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                        if HasProp(val, ChildrenProp) && val.%ChildrenProp% is Array {
                            stack.Push(id)
                            _Process(val.%ChildrenProp%)
                            stack.Pop()
                            Struct.hParent := stack[-1]
                        }
                    } else {
                        _Throw()
                    }
                } else {
                    Struct.pszText := val
                    if !SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                        _Throw()
                    }
                }
            }
        }
        _ProcessMaxDepth(List) {
            Struct.hParent := stack[-1]
            for val in List {
                if IsObject(val) {
                    Struct.pszText := val.%LabelProp%
                    if id := SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                        if HasProp(val, ChildrenProp) && val.%ChildrenProp% is Array && stack.Length < MaxDepth {
                            stack.Push(id)
                            _ProcessMaxDepth(val.%ChildrenProp%)
                            stack.Pop()
                            Struct.hParent := stack[-1]
                        }
                    } else {
                        _Throw()
                    }
                } else {
                    Struct.pszText := val
                    if !SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
                        _Throw()
                    }
                }
            }
        }
        _Throw() {
            throw Error('TVM_INSERTITEMW failed.', -1)
        }
    }
    /**
     * Adds one or more items to the "Templates" map. The purpose of storing templates is to improve
     * performance by reusing structures with pre-set members for common tasks.
     *
     * @param {...*} Items - Key-value pairs where the value is an instance of
     * {@link TvInsertStruct}, {@link TvHitTestInfo}, {@link TvItemEx}, {@link TvItem}, or
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
    Collapse(Handle) => SendMessage(TVM_EXPAND, TVE_COLLAPSE, Handle, this.Hwnd)
    CollapseReset(Handle) => SendMessage(TVM_EXPAND, TVE_COLLAPSERESET, Handle, this.Hwnd)
    CopyItemId(Handle) => A_Clipboard := Handle
    CopyText(Handle) => A_Clipboard := this.GetText(Handle)
    CreateDragImage(Handle) => SendMessage(TVM_CREATEDRAGIMAGE, 0, Handle, this.Hwnd)
    DeleteAll() => SendMessage(TVM_DELETEITEM, 0, 0, this.Hwnd)
    DeleteItem(Handle) => SendMessage(TVM_DELETEITEM, 0, Handle, this.Hwnd)
    DeleteNode_C(Handle) {
        node := this.Collection.Get(Handle)
        this.Collection.Delete(Node)
        return node
    }
    Destroy() => DllCall(g_proc_user32_DestroyWindow, 'ptr', this.Hwnd, 'int')
    Dispose() {
        this.DeleteAll()
        if TreeViewExWindowSubclassManager.Collection.Has(this.HwndGui) {
            if TreeViewExWindowSubclassManager.Collection.Get(this.HwndGui).Collection.Has(this.Hwnd) {
                TreeViewExWindowSubclassManager.RemoveControl(this.HwndGui, this.Hwnd)
            }
        }
        if IsObject(this.Constructor)
        && this.Constructor.HasOwnProp('Prototype')
        && this.Constructor.Prototype.HasOwnProp('Ctrl')
        && ObjPtr(this.Constructor.Prototype.Ctrl) == ObjPtr(this) {
            ObjPtrAddRef(this)
            this.DeleteProp('Constructor')
        }
        this.Destroy()
    }
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-editlabel}.
     * @param {Integer} Handle - The id of the item to edit.
     * @returns {Integer} - The handle to the edit control that is created for editing the label, or
     * 0 if unsuccessful.
     */
    EditLabel(Handle) => SendMessage(TVM_EDITLABELW, 0, Handle, this.Hwnd)
    EditSelectedLabel() => SendMessage(TVM_EDITLABELW, 0, this.GetSelected(), this.Hwnd)
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
     * @param {Integer} Handle - The id of the item.
     * @returns {Integer} - Returns nonzero if the system scrolled the items in the tree-view control
     * and no items were expanded. Otherwise, the message returns zero.
     */
    EnsureVisible(Handle) => SendMessage(TVM_ENSUREVISIBLE, 0, Handle, this.Hwnd)
    EnumChildren(Handle := 0) {
        child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd)
        return _Enum

        _Enum(&Handle?) {
            if child {
                Handle := child
                child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, Handle, this.Hwnd)
                return 1
            } else {
                return 0
            }
        }
    }
    EnumChildrenRecursive(Handle := 0, MaxDepth := 0) {
        enum := { Child: SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd), Stack: [], Parent: Handle }
        enum.DefineProp('Call', { Call: _Enum })

        return enum

        _Enum(Self, &Handle?, &Parent?) {
            if Self.Child {
                Parent := Self.Parent
                Handle := Self.Child
                if (MaxDepth <= 0 || Self.Stack.Length < MaxDepth) && child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                    Self.Stack.Push({ Parent: Self.Parent, Child: Handle })
                    Self.Parent := Handle
                    Self.Child := child
                } else if child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, Handle, this.Hwnd) {
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
    Expand(Handle) => SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
    ExpandPartial(Handle) => SendMessage(TVM_EXPAND, TVE_EXPANDPARTIAL, Handle, this.Hwnd)
    GetBkColor() => SendMessage(TVM_GETBKCOLOR, 0, 0, this.Hwnd)
    GetEditControl() => SendMessage(TVM_GETEDITCONTROL, 0, 0, this.Hwnd)
    GetExtendedStyle() => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd)
    /**
     * Creates a {@link TreeViewExLogFont} object and sets it to property "Font". Use the font object
     * to adjust the control's font attributes. See {@link TreeViewExLogFont} for details.
     *
     * @returns {TreeViewExLogFont}
     */
    GetFont() {
        if !this.HasOwnProp('Font') {
            this.Font := TreeViewExLogFont(this.Hwnd)
        }
        this.Font.Call()
        return this.Font
    }
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
    GetItemRect(Handle) {
        rc := Rect()
        NumPut('ptr', Handle, rc, 0)
        if SendMessage(TVM_GETITEMRECT, 1, rc.ptr, this.Hwnd) {
            return rc
        }
    }
    GetItemState(Handle, Mask) => SendMessage(TVM_GETITEMSTATE, Handle, Mask, this.Hwnd)
    GetLineColor() => SendMessage(TVM_GETLINECOLOR, 0, 0, this.Hwnd)
    GetLineRect(Handle) {
        rc := Rect()
        NumPut('ptr', Handle, rc, 0)
        if SendMessage(TVM_GETITEMRECT, 0, rc.ptr, this.Hwnd) {
            return rc
        }
    }
    /**
     * Creates a new node object passing `Handle` to the constructor. Adds the node to the collection
     * (if the collection has been created).
     */
    GetNode(Handle) {
        node := this.Constructor.Call(Handle)
        if IsObject(this.Collection) {
            this.Collection.Set(Handle, node)
        }
        return node
    }
    /**
     * Retrieves a node object from the collection.
     */
    GetNode_C(Handle) {
        return this.Collection.Get(Handle)
    }
    /**
     * Retrieves a node object by calling `ObjPtrAddRef(TVITEM.lParam)`. This is only viable if
     * your code sets the `lParam` member with the node objects' ptr addresses.
     */
    GetNode_Ptr(Handle) {
        struct := TvItem()
        struct.mask := TVIF_PARAM | TVIF_HANDLE
        struct.hItem := Handle
        SendMessage(TVM_GETITEMW, 0, struct.Ptr, this.Hwnd)
        return ObjFromPtrAddRef(struct.lParam)
    }
    GetParent(Handle) => SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Handle, this.Hwnd)
    GetPos(&X?, &Y?, &W?, &H?) {
        rc := WinRect(this.Hwnd, 0)
        X := rc.L
        y := rc.T
        W := rc.W
        H := rc.H
        return rc
    }
    /**
     * @param {Integer} [Flag = 0] - A flag that determines what function is called when the
     * buffer's values are updated using `WinRectGetPos` or `WinRectUpdate`.
     * - 0 : `GetWindowRect`
     * - 1 : `GetClientRect`
     * - 2 : `DwmGetWindowAttribute` passing DWMWA_EXTENDED_FRAME_BOUNDS to dwAttribute.
     */
    GetRect(Flag := 0) => WinRect(this.Hwnd, Flag).ToClient(this.HwndGui, true)
    GetRoot(Handle) => SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, Handle, this.Hwnd)
    GetScrollTime() => SendMessage(TVM_GETSCROLLTIME, 0, 0, this.Hwnd)
    GetSelected() => SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
    GetText(Handle) {
        struct := TvItem()
        struct.mask := TVIF_TEXT | TVIF_HANDLE
        struct.hItem := Handle
        SendMessage(TVM_GETITEMW, 0, struct.Ptr, this.Hwnd)
        return struct.pszText
    }
    GetTextColor() => SendMessage(TVM_GETTEXTCOLOR, 0, 0, this.Hwnd)
    GetTooltips() => SendMessage(TVM_GETTOOLTIPS, 0, 0, this.Hwnd)
    GetVisibleCount() => SendMessage(TVM_GETVISIBLECOUNT, 0, 0, this.Hwnd)
    HasChildren(Handle) => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) ? 1 : 0
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
     * @param {TvInsertStruct} Struct - {@link TvInsertStruct}
     */
    Insert(Struct) => SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd)
    IsExpanded(Handle) {
        struct := TvItemEx()
        struct.mask := TVIF_STATE | TVIF_HANDLE
        struct.hItem := Handle
        struct.stateMask := TVIS_EXPANDED
        SendMessage(TVM_GETITEMW, 0, struct.Ptr, this.Hwnd)
        return struct.mask & TVIS_EXPANDED
    }
    IsRoot(Handle) => !SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Handle, this.Hwnd)
    IsAncestor(HandleDescendant, HandlePotentialAncestor) {
        if HandleDescendant = HandlePotentialAncestor {
            return 1
        }
        if h := HandlePotentialAncestor {
            while h := SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, h, this.Hwnd) {
                if h = HandlePotentialAncestor {
                    return 1
                }
            }
        }
    }
    MapAccIdToHTreeItem(AccId) => SendMessage(TVM_MAPACCIDTOHTREEITEM, AccId, 0, this.Hwnd)
    MapHTreeItemToAccId(Handle) => SendMessage(TVM_MAPHTREEITEMTOACCID, Handle, 0, this.Hwnd)
    OnNotify(NotifyCode, Callback?, Add := 1) {
        if Add {
            TreeViewExWindowSubclassManager.AddNotifyHandler(this.HwndGui, this, NotifyCode, Callback)
        } else {
            TreeViewExWindowSubclassManager.DeleteNotifyHandler(this.HwndGui, this.Hwnd, NotifyCode)
        }
    }
    Select(Handle) => SendMessage(TVM_SELECTITEM, TVGN_CARET, Handle, this.Hwnd)
    SetAutoScrollInfo(PixelsPerSecond, RedrawInterval) => SendMessage(TVM_SETAUTOSCROLLINFO, PixelsPerSecond, RedrawInterval, this.Hwnd)
    SetBkColor(Color) => SendMessage(TVM_SETBKCOLOR, 0, Color, this.Hwnd)
    SetBorder(Flags, SizeHoriz, SizeVert, &OutOldHoriz?, &OutOldVert?) {
        result := SendMessage(TVM_SETBORDER, Flags, (SizeVert & 0xFFFF) << 16 | (SizeHoriz & 0xFFFF), this.Hwnd)
        OutOldHoriz := result & 0xFFFF
        OutOldVert := (result >> 16) & 0xFFFF
    }
    /**
     *
     */
    SetExtendedStyle(Value, Styles) => SendMessage(TVM_SETEXTENDEDSTYLE, Value, Styles, this.Hwnd)
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setimagelist}
     *
     * @param {Integer} ImageListType - One of the following:
     * - TVSIL_NORMAL
     * - TVSIL_STATE
     * @param {Integer} Handle - The handle to the image list.
     */
    SetImageList(ImageListType, Handle) => SendMessage(TVM_SETIMAGELIST, ImageListType, Handle, this.Hwnd)
    SetIndent(Value) => SendMessage(TVM_SETINDENT, Value, 0, this.Hwnd)
    SetInsertMark(Handle, AfterItem := false) => SendMessage(TVM_SETINSERTMARK, AfterItem, Handle, this.Hwnd)
    SetInsertMarkColor(Color) => SendMessage(TVM_SETINSERTMARKCOLOR, 0, Color, this.Hwnd)
    SetItem(Struct) => SendMessage(TVM_SETITEMW, 0, Struct.Ptr, this.Hwnd)
    SetItemHeight(Height) => SendMessage(TVM_SETITEMHEIGHT, Height, 0, this.Hwnd)
    SetLineColor(Color) => SendMessage(TVM_SETLINECOLOR, 0, Color, this.Hwnd)
    SetNodeConstructor(NodeClass) {
        this.Constructor := Class()
        this.Constructor.Base := NodeClass
        this.Constructor.Prototype := {
            Ctrl: this
          , HwndTv: this.Hwnd
          , __Class: NodeClass.Prototype.__Class
        }
        ObjRelease(ObjPtr(this))
        ObjSetBase(this.Constructor.Prototype, NodeClass.Prototype)
        this.Collection := TreeViewExNodeCollection()
    }
    SetScrollTime(TimeMs) => SendMessage(TVM_SETSCROLLTIME, TimeMs, 0, this.Hwnd)
    SetTextColor(Color) => SendMessage(TVM_SETTEXTCOLOR, 0, Color, this.Hwnd)
    SetTooltips(Handle) => SendMessage(TVM_SETTOOLTIPS, Handle, 0, this.Hwnd)
    ShowInfoTip(Handle) => SendMessage(TVM_SHOWINFOTIP, 0, Handle, this.Hwnd)
    SortChildren(Handle, Recursive := true) => SendMessage(TVM_SORTCHILDREN, Recursive, Handle, this.Hwnd)
    /**
     * See {@link https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvsortcb}
     * for details about the callback.
     *
     * See {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-sortchildrencb} for
     * details about the message.
     */
    SortChildrenCb(hParent, Callback, lParam := 0) {
        cb := CallbackCreate(Callback)
        _tvSortCb := TvSortCb()
        _tvSortCb.hParent := hParent
        _tvSortCb.lpfnCompare := cb
        _tvSortCb.lParam := lParam
        try {
            result := SendMessage(TVM_SORTCHILDREN, 0, _tvSortCb.Ptr, this.Hwnd)
        } catch Error as err {
            CallbackFree(cb)
            throw err
        }
        CallbackFree(cb)
        return result
    }
    Toggle(Handle) => SendMessage(TVM_EXPAND, TVE_TOGGLE, Handle, this.Hwnd)
    __Delete() {
        this.Dispose()
    }
    __SetHandler(Callback, Code, Name, AddRemove) {
        if IsObject(this.%Name%) {
            this.OnNotify(Code, this.%Name%, 0)
        }
        this.%Name% := Callback
        if Callback {
            this.OnNotify(Code, Callback, AddRemove)
        }
    }
    __SetHandlerDispInfo(Callback, Name) {
        if Callback {
            this.__Handler%Name% := Callback
        } else {
            this.__Handler%Name% := ''
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
    Gui => GuiFromHwnd(this.HwndGui)
    HandlerChildrenGet {
        Get => this.__HandlerChildrenGet
        Set => this.SetHandlerChildren(Value)
    }
    HandlerGetDispInfo {
        Get => this.__HandlerGetDispInfo
        Set => this.SetHandlerGetDispInfo(Value)
    }
    HandlerImageGet {
        Get => this.__HandlerImageGet
        Set => this.SetHandlerImage(Value)
    }
    HandlerImageSet {
        Get => this.__HandlerImageSet
        Set => this.SetHandlerImage(, Value)
    }
    HandlerNameGet {
        Get => this.__HandlerNameGet
        Set => this.SetHandlerNameGet(Value)
    }
    HandlerNameSet {
        Get => this.__HandlerNameSet
        Set => this.SetHandlerNameSet(, Value)
    }
    HandlerSelectedImageGet {
        Get => this.__HandlerSelectedImageGet
        Set => this.SetHandlerSelectedImageGet(Value)
    }
    HandlerSelectedImageSet {
        Get => this.__HandlerSelectedImageSet
        Set => this.SetHandlerSelectedImageSet(, Value)
    }
    HandlerSetDispInfo {
        Get => this.__HandlerSetDispInfo
        Set => this.SetHandlerSetDispInfo(Value)
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

    class Options {
        static __New() {
            this.DeleteProp('__New')
            if !IsSet(TVS_HASBUTTONS) {
                TreeViewEx_SetConstants()
            }
            this.Default := {
                Style: TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT | TVS_SHOWSELALWAYS | WS_CHILD | WS_CLIPSIBLINGS | WS_VISIBLE
              , ExStyle: TVS_EX_DOUBLEBUFFER | WS_EX_COMPOSITED
              , WindowName: 0
              , X: ''
              , Y: ''
              , Width: 100
              , Height: ''
              , Menu: 0
              , Instance: 0
              , Param: 0
              , Rows: 0
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
