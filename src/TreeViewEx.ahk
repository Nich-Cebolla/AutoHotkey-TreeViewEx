/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

; See the README for tested methods and properties.

class TreeViewEx {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.Constructor := proto.Collection := proto.ParentSubclass := proto.Subclass :=
        proto.CallbackOnExit := ''
        if !IsSet(TVS_HASBUTTONS) {
            TreeViewEx_SetConstants()
        }
        this.ClassName := Buffer(StrPut('SysTreeView32', TVEX_DEFAULT_ENCODING))
        StrPut('SysTreeView32', this.ClassName, TVEX_DEFAULT_ENCODING)
        this.Collection_TVEX := TreeViewExCollection()
    }
    static Add(TreeViewExObj) {
        return this.Collection_TVEX.InsertIfAbsent(TreeViewExObj)
    }
    static Delete(Hwnd) {
        return this.Collection_TVEX.RemoveIf(Hwnd)
    }
    static Get(Hwnd) {
        if this.Collection_TVEX.Find(Hwnd, &tvex) {
            return tvex
        } else {
            throw UnsetItemError('Failed to find a value with the input hwnd.', , Hwnd)
        }
    }
    /**
     * {@link TreeViewEx} is a custom tree-view control. It does not inherit from `Gui.Control`
     * nor `Gui.TreeView`, and so the behavior adding it is different from `Gui.Prototype.Add`.
     *
     * When the {@link TreeViewEx} control is created, it will not be affected by AutoHotkey's
     * auto-positioning mechanic; your code will need to set the size and position options
     * directly.
     *
     * If neither `Options.Height` nor `Options.Rows` are set, the height defaults to 1 row.
     *
     * When using `Options.Rows`, the height calculation automatically accounts for the WS_BORDER
     * style, adding 2 additional pixels to the height.
     *
     * Style options are defined using WS and WS_EX style flag constants. Your code can use
     * the global variables (e.g. WS_CHILD, WS_EX_COMPOSITED). If your code encounters a var unset
     * error, call {@link TreeViewEx_SetConstants} any time before using the variables.
     *
     * Font options are defined using `Options.Font`. See {@link TreeViewEx_LogFont}.
     *
     * Most of the {@link https://learn.microsoft.com/en-us/windows/win32/controls/bumper-tree-view-control-reference-messages TVM messages}
     * have been adapted into class instance methods; many of these also expose style and customization
     * capabilities, and are included as available options on the `Options` object.
     *
     * @param {Gui} GuiObj - The `Gui` object on which to add the {@link TreeViewEx}.
     *
     * @param {Object} [Options] - An object with zero or more options as property : value pairs.
     *
     * See {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-createwindowexw CreateWindowExW}
     * for information about the CreateWindowExW options. Each CreateWindowExW parameter is associated
     * with a property on the `Options` object.
     *
     * @param {Integer} [Options.AddExStyle] - ExStyle flags to add onto the default.
     * The default is `TVS_EX_DOUBLEBUFFER | WS_EX_COMPOSITED`. Use `Options.AddExStyle` instead
     * of `Options.ExStyle` when your intent is to use additional flags on top of the defaults. The
     * default ExStyle flags are applicable for general use cases.
     *
     * @param {Integer} [Options.AddStyle] - Style flags to add onto the default.
     * The default is `TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT | TVS_SHOWSELALWAYS | WS_CHILD | WS_CLIPSIBLINGS | WS_VISIBLE | WS_BORDER`.
     * Use `Options.AddStyle` instead of `Options.Style` when your intent is to use additional flags
     * on top of the defaults. The default Style flags are applicable for general use cases.
     *
     * @param {Integer} [Options.BkColor] - A COLORREF value to set as the background color.
     * Your code can use {@link TreeViewEx_RGB} to convert r, g, b values to COLORREF.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setbkcolor}.
     *
     * @param {Integer} [Options.ExStyle = TVS_EX_DOUBLEBUFFER | WS_EX_COMPOSITED] - The value to
     * pass to the `dwExStyle` parameter of CreateWindowExW.
     *
     * @param {Object} [Options.Font] - An options object to pass to {@link TreeViewEx_LogFont},
     * setting the font characteristics of the TreeViewEx control. The system may not honor all
     * properties exposed by {@link TreeViewEx_LogFont}; if setting a property value does not invoke
     * any difference in the TreeViewEx control's appearance, that property is likely not available
     * for use for tree-view control text. See {@link TreeViewEx_LogFont.Prototype.__New} for
     * the list of options.
     *
     * @param {Integer} [Options.Height] - The value to pass to the `nHeight` parameter of CreateWindowExW.
     * Also see `Options.Rows`.
     *
     * @param {Integer} [Options.ImageListNormal] - The handle to an image list to use with selected,
     * nonselected, and overlay images for the items of the TreeViewEx control. See my class
     * {@link https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/ImageList.ahk ImageList}
     * to create an image list from a list of file paths.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setimagelist}.
     *
     * @param {Integer} [Options.ImageListState] - The handle to an image list to use with application-
     * defined item states. A state image is displayed to the left of an item's selected or nonselected
     * image. See my class
     * {@link https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/ImageList.ahk ImageList}
     * to create an image list from a list of file paths.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setimagelist}.
     *
     * @param {Integer} [Options.Indent] - The width, in pixels, of indentation for the TreeViewEx control.
     * If this value is less than the system-defined minimum width, the new width is set to the system-
     * defined minimum.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setindent}.
     *
     * @param {Integer} [Options.InsertMarkColor] - A COLORREF value to set as the color used to
     * draw the insertion mark for the tree view. Your code can use {@link TreeViewEx_RGB} to convert
     * r, g, b values to COLORREF.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setinsertmarkcolor}.
     *
     * @param {Integer} [Options.Instance = 0] - The value to pass to the `hInstance` parameter of CreateWindowExW.
     * Generally this should be left the default ( 0 ).
     *
     * @param {Integer} [Options.ItemHeight] - New height of every item in the tree view, in pixels.
     * Heights less than 1 will be set to 1. If this argument is not even and the tree-view control
     * does not have the TVS_NONEVENHEIGHT style, this value will be rounded down to the nearest even
     * value.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setitemheight}.
     *
     * @param {Integer} [Options.LineColor] - A COLORREF value to set as the line color. Your code
     * can use {@link TreeViewEx_RGB} to convert r, g, b values to COLORREF.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setlinecolor}.
     *
     * @param {Integer} [Options.Menu = 0] - The value to pass to the `hMenu` parameter of CreateWindowExW.
     * In the context of a tree-view control, `hMenu` is a child-window identifier. Generally this
     * should be left the default ( 0 ).
     *
     * @param {String} [Options.Name] - A name to associate with the TreeViewEx control. The
     * value is set to property {@link TreeViewEx#Name}.
     *
     * @param {Integer} [Options.Param = 0] - The value to pass to the `lpParam` parameter of CreateWindowExW.
     * Generally this should be left the default ( 0 ).
     *
     * @param {Integer} [Options.Rows = 0] - Use `Options.Rows` as an alternative to `Options.Height`.
     * Similar to the `Gui.Control` option "r<n>", `Options.Rows` allows your code to set the height
     * of the TreeViewEx as a number of rows that can be displayed in the control's client area
     * concurrently.
     *
     * @param {Integer} [Options.ScrollTime] - Sets the maximum scroll time, in milliseconds, for
     * the TreeViewEx control. The maximum scroll time is the longest amount of time that a scroll
     * operation can take. Scrolling will be adjusted so that the scroll will take place within the
     * maximum scroll time. A scroll operation may take less time than the maximum.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setscrolltime}.
     *
     * @param {Integer} [Options.Style = TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT | TVS_SHOWSELALWAYS | WS_CHILD | WS_CLIPSIBLINGS | WS_VISIBLE | WS_BORDER] -
     * The value to pass to the `dwStyle` parameter of CreateWindowExW.
     *
     * @param {Integer} [Options.TextColor] - A COLORREF value that contains the new text color.
     * Your code can use {@link TreeViewEx_RGB} to convert r, g, b values to COLORREF.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-settextcolor}.
     *
     * @param {Integer} [Options.Width = 100] - The value to pass to the `nWidth` parameter of
     * CreateWindowExW.
     *
     * @param {Integer|String} [Options.WindowName = 0] -
     * - If an integer, the address to a null-terminated string that is passed to the `lpWindowName`
     *   parameter of CreateWindowExW.
     * - If a string, the string to pass to the `lpWindowName` parameter of CreateWindowExW.
     *
     * @param {Integer} [Options.X] - Set `Options.X` with an integer to specify the x-coordinate
     * at which to place the TreeViewEx control. The coordinate is relative to the top-left corner
     * of the gui's client area. If an empty string, `GuiObj.MarginX` is used.
     *
     * @param {Integer} [Options.Y] - Set `Options.Y` with an integer to specify the Y-coordinate
     * at which to place the TreeViewEY control. The coordinate is relative to the top-left corner
     * of the gui's client area. If an empty string, `GuiObj.MarginY` is used.
     *
     */
    __New(GuiObj, Options?) {
        options := TreeViewEx.Options(Options ?? unset)
        this.HwndGui := GuiObj.Hwnd
        rc := WinRect(GuiObj.Hwnd, 1)
        if IsNumber(options.WindowName) {
            windowName := options.WindowName
        } else {
            windowName := Buffer(StrPut(options.WindowName, TVEX_DEFAULT_ENCODING))
            StrPut(options.WindowName, windowName, TVEX_DEFAULT_ENCODING)
        }
        style := options.AddStyle ? options.Style | options.AddStyle : options.Style
        this.Hwnd := DllCall(
            g_user32_CreateWindowExW
          , 'uint', options.AddExStyle ? options.ExStyle | options.AddExStyle : options.ExStyle ; dwExStyle
          , 'ptr', TreeViewEx.ClassName                                                         ; lpClassName
          , 'ptr', windowName                                                                   ; lpWindowName
          , 'uint', style                                                                       ; dwStyle
          , 'int', rc.L + (IsNumber(options.X) ? options.X : GuiObj.MarginX)                    ; X
          , 'int', rc.T + (IsNumber(options.Y) ? options.Y : GuiObj.MarginY)                    ; Y
          , 'int', options.Width                                                                ; nWidth
          , 'int', IsNumber(options.Height) ? options.Height : 1                                ; nHeight
          , 'ptr', this.HwndGui                                                                 ; hWndParent
          , 'ptr', options.Menu                                                                 ; hMenu
          , 'ptr', options.Instance                                                             ; hInstance
          , 'ptr', options.Param                                                                ; lpParam
        )
        TreeViewEx.Add(this)

        this.Name := options.Name

        if options.BkColor {
            this.SetBkColor(options.BkColor)
        }
        if options.Font {
            this.DefineProp('Font', { Value: TreeViewEx_LogFont(this.Hwnd, options.Font) })
        }
        if options.ImageListNormal {
            this.SetImageList(TVSIL_NORMAL, options.ImageListNormal)
        }
        if options.ImageListState {
            this.SetImageList(TVSIL_STATE, options.ImageListState)
        }
        if options.Indent {
            this.SetIndent(options.Indent)
        }
        if options.InsertMarkColor {
            this.SetInsertMarkColor(options.InsertMarkColor)
        }
        if options.ItemHeight {
            this.SetItemHeight(options.ItemHeight)
        }
        if options.LineColor {
            this.SetLineColor(options.LineColor)
        }
        if options.ScrollTime {
            this.SetScrollTime(options.ScrollTime)
        }
        if options.TextColor {
            this.SetTextColor(options.TextColor)
        }

        if options.Rows || !IsNumber(options.Height) {
            this.GetPos(&x, &y, &w, &h)
            WinMove(x, y, w, (options.Rows || 1) * this.GetItemHeight() + (style & WS_BORDER ? 2 : 0), this.Hwnd)
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
        global g_TreeViewEx_Node := this.Constructor.Call(Params*)
        local node := g_TreeViewEx_Node
        Struct.lParam := ObjPtrAddRef(node)
        if handle := SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
            node.Handle := handle
            g_TreeViewEx_Node := ''
            return node
        } else {
            throw Error('Sending ``TVM_INSERTITEMW`` failed.')
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
        global g_TreeViewEx_Node := this.Constructor.Call(Params*)
        local node := g_TreeViewEx_Node
        if SetParam {
            Struct.lParam := ObjPtrAddRef(node)
        }
        if handle := SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
            node.Handle := handle
            if !this.Collection.InsertIfAbsent(node) {
                throw Error('Handle already exists in the collection.', , handle)
            }
            g_TreeViewEx_Node := ''
            return node
        } else {
            throw Error('Sending ``TVM_INSERTITEMW`` failed.')
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
    AddObj(Obj, InitialParentId := 0, LabelProp := 'Name', ChildrenProp := 'Children', MaxDepth := 0) {
        struct := TvInsertStruct()
        struct.mask := TVIF_TEXT
        this.AddObjListFromTemplate([ Obj ], struct, InitialParentId, LabelProp, ChildrenProp, MaxDepth)
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
    AddObjList(List, InitialParentId := 0, LabelProp := 'Name', ChildrenProp := 'Children', MaxDepth := 0) {
        struct := TvInsertStruct()
        struct.mask := TVIF_TEXT
        this.AddObjListFromTemplate(List, struct, InitialParentId, LabelProp, ChildrenProp, MaxDepth)
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
    AddObjListFromTemplate(List, Struct, InitialParentId := 0, LabelProp := 'Name', ChildrenProp := 'Children', MaxDepth := 0) {
        if IsObject(Struct) {
            Struct := Struct.Clone()
        } else {
            Struct := this.Templates.Get(Struct).Clone()
        }
        Struct.hParent := InitialParentId
        stack := ['']
        this.SetRedraw(0)
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
        this.SetRedraw(1)

        return

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
            this.Templates := TreeViewExCollection_Template(false)
        }
        this.Templates.Set(Items*)
    }
    Collapse(Handle) => SendMessage(TVM_EXPAND, TVE_COLLAPSE, Handle, this.Hwnd)
    CollapseRecursive(Handle := 0) {
        toCollapse := []
        toCollapse.Capacity := this.GetCount()
        if Handle {
            _Recurse(Handle)
        } else {
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, 0, this.Hwnd) {
                _Recurse(child)
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    _Recurse(child)
                }
            }
        }
        loop toCollapse.Length {
            SendMessage(TVM_EXPAND, TVE_COLLAPSE, toCollapse[-A_Index], this.Hwnd)
        }

        return

        _Recurse(Handle) {
            local child, _child
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                toCollapse.Push(Handle)
                _Recurse(child)
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    _Recurse(child)
                }
            }
        }
    }
    CollapseReset(Handle) => SendMessage(TVM_EXPAND, TVE_COLLAPSE | TVE_COLLAPSERESET, Handle, this.Hwnd)
    CopyItemId(Handle) => A_Clipboard := Handle
    CopyText(Handle) {
        A_Clipboard := this.GetText(Handle)
    }
    CreateDragImage(Handle) => SendMessage(TVM_CREATEDRAGIMAGE, 0, Handle, this.Hwnd)
    CreateParentSubclass(SetOnExit := true) {
        this.ParentSubclass := TreeViewEx_Subclass(TreeViewEx_ParentSubclassProc, this.HwndGui, this.Hwnd)
        this.Subclass := TreeViewEx_WindowSubclass(TreeViewEx_ControlSubclassProc, this.Hwnd)
        if SetOnExit {
            this.CallbackOnExit := TreeViewEx_CallbackOnExit.Bind(this.Hwnd)
            OnExit(this.CallbackOnExit, -1)
        }
    }
    /**
     * Delete all callbacks associated with a command code.
     */
    DeleteCommandCode(CommandCode) {
        this.ParentSubclass.CommandDelete(this.HwndGui, this, CommandCode)
    }
    /**
     * Delete all callbacks associated with a message code.
     */
    DeleteMessageCode(MessageCode) {
        this.ParentSubclass.MessageDelete(this.HwndGui, this, MessageCode)
    }
    /**
     * Delete all callbacks associated with a notify code.
     */
    DeleteNotifyCode(NotifyCode) {
        this.ParentSubclass.NotifyDelete(this.HwndGui, this, NotifyCode)
    }
    DeleteAll() => SendMessage(TVM_DELETEITEM, 0, 0, this.Hwnd)
    DeleteAll_C() {
        this.DeleteAll()
        this.Collection.Length := 0
    }
    DeleteItem(Handle) => SendMessage(TVM_DELETEITEM, 0, Handle, this.Hwnd)
    DeleteNode_C(Handle) {
        this.Collection.Remove(Handle, &node)
        return node
    }
    Destroy() => DllCall(g_user32_DestroyWindow, 'ptr', this.Hwnd, 'int')
    Dispose() {
        if this.GetCount() {
            this.SetRedraw(0)
            this.DeleteAll()
        }
        if this.ParentSubclass && this.ParentSubclass.WindowSubclass.IsInstalled {
            this.ParentSubclass.WindowSubclass.Uninstall()
        }
        if this.Subclass && this.Subclass.IsInstalled {
            this.Subclass.Uninstall()
        }
        TreeViewEx.Delete(this.Hwnd)
        if IsObject(this.CallbackOnExit) {
            OnExit(this.CallbackOnExit, 0)
            this.DeleteProp('CallbackOnExit')
        }
        if WinExist(this.Hwnd) {
            this.Destroy()
        }
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
     * @param {Integer} [Handle] - The id of the item. If unset, the first root node is used.
     * @returns {Integer} - Returns nonzero if the system scrolled the items in the tree-view control
     * and no items were expanded. Otherwise, the message returns zero.
     */
    EnsureVisible(Handle?) => SendMessage(TVM_ENSUREVISIBLE, 0, Handle ?? this.GetChild(), this.Hwnd)
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
    /**
     * @param {Integer} [Handle = 0] - The handle of the item for which its children will be enumerated.
     * @param {Integer} [MaxDepth = 0] - The maximum depth to expand.
     */
    EnumChildrenRecursive(Handle := 0, MaxDepth := 0) {
        enum := { Child: SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd), Stack: [], Parent: Handle }
        if MaxDepth > 0 {
            enum.DefineProp('Call', { Call: _EnumMaxDepth })
        } else {
            enum.DefineProp('Call', { Call: _Enum })
        }

        return enum

        _Enum(Self, &Handle?, &Parent?) {
            if Self.Child {
                Parent := Self.Parent
                Handle := Self.Child
                if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
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
                } else {
                    Self.Child := 0
                }
                return 1
            } else {
                return 0
            }
        }

        _EnumMaxDepth(Self, &Handle?, &Parent?) {
            if Self.Child {
                Parent := Self.Parent
                Handle := Self.Child
                if Self.Stack.Length < MaxDepth && (child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd)) {
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
                } else {
                    Self.Child := 0
                }
                return 1
            } else {
                return 0
            }
        }
    }
    Expand(Handle) => SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
    /**
     * @param {Integer} [Handle = 0] - The node to expand. If 0, all nodes are expanded.
     * @param {Integer} [MaxDepth = 0] - The maximum depth to expand.
     */
    ExpandRecursive(Handle := 0, MaxDepth := 0) {
        if MaxDepth > 0 {
            depth := 0
            _RecurseMaxDepth(Handle)
        } else {
            _Recurse(Handle)
        }

        return

        _Recurse(Handle) {
            SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                _Recurse(child)
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    _Recurse(child)
                }
            }
        }
        _RecurseMaxDepth(Handle) {
            depth++
            SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                if depth < MaxDepth {
                    _RecurseMaxDepth(child)
                }
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    if depth < MaxDepth {
                        _RecurseMaxDepth(child)
                    }
                }
            }
            depth--
        }
        _Throw() {
            throw Error('Sending message ``TVM_GETITEMW`` failed.', -1)
        }
    }
    /**
     * @param {*} Callback - A `Func` or callable object that is called to determine if a node should
     * be expanded.
     * - Parameters:
     *   1. {Integer} The tree-view item handle.
     *   2. {Integer} The handle to the parent item of #1.
     *   3. {Integer} The current depth (children of `Handle` are depth 1).
     *   4. {TreeViewEx} The {@link TreeViewEx} object.
     * - The function should return one of the following integers:
     *   - 0 : Do not expand the node and move on to the next sibling node.
     *   - 1 : Expand the node and iterate the node's children.
     *   - 2 : Expand the node but do not iterate the node's children, move on to the next sibling node.
     *
     * @param {Integer} [Handle = 0] - The node to expand. If 0, the root nodes are iterated and
     * expanded, depending on the return value from `Callback`.
     *
     * @param {Integer} [MaxDepth = 0] - The maximum depth to expand.
     */
    ExpandRecursiveSelective(Callback, Handle := 0, MaxDepth := 0) {
        depth := 0
        item := TvItem()
        item.mask := TVIF_CHILDREN
        SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
        if MaxDepth > 0 {
            _RecurseMaxDepth(Handle)
        } else {
            _Recurse(Handle)
        }

        return

        _Recurse(Handle) {
            local child
            depth++
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                item.hItem := child
                if !SendMessage(TVM_GETITEMW, 0, item.Ptr, this.Hwnd) {
                    throw OSError()
                }
                if item.cChildren {
                    switch Callback(child, Handle, depth, this), 0 {
                        case 0: ; do nothing
                        case 1:
                            SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                            _Recurse(child)
                        case 2: SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                    }
                }
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    item.hItem := child
                    if !SendMessage(TVM_GETITEMW, 0, item.Ptr, this.Hwnd) {
                        throw OSError()
                    }
                    if item.cChildren {
                        switch Callback(child, Handle, depth, this), 0 {
                            case 0: ; do nothing
                            case 1:
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                _Recurse(child)
                            case 2: SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                        }
                    }
                }
            }
            depth--
        }
        _RecurseMaxDepth(Handle) {
            local child
            depth++
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                item.hItem := child
                if !SendMessage(TVM_GETITEMW, 0, item.Ptr, this.Hwnd) {
                    throw OSError()
                }
                if item.cChildren {
                    switch Callback(child, Handle, depth, this), 0 {
                        case 0: ; do nothing
                        case 1:
                            SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                            if depth < MaxDepth {
                                _RecurseMaxDepth(child)
                            }
                        case 2: SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                    }
                }
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    item.hItem := child
                    if !SendMessage(TVM_GETITEMW, 0, item.Ptr, this.Hwnd) {
                        throw OSError()
                    }
                    if item.cChildren {
                        switch Callback(child, Handle, depth, this), 0 {
                            case 0: ; do nothing
                            case 1:
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                if Depth < MaxDepth {
                                    _RecurseMaxDepth(child)
                                }
                            case 2: SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                        }
                    }
                }
            }
            depth--
        }
    }
    ExpandPartial(Handle) => SendMessage(TVM_EXPAND, TVE_EXPANDPARTIAL, Handle, this.Hwnd)
    GetBkColor() => SendMessage(TVM_GETBKCOLOR, 0, 0, this.Hwnd)
    GetChild(Handle := 0) => SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd)
    GetCount() => SendMessage(TVM_GETCOUNT, 0, 0, this.Hwnd)
    GetEditControl() => SendMessage(TVM_GETEDITCONTROL, 0, 0, this.Hwnd)
    GetExtendedStyle() => SendMessage(TVM_GETEXTENDEDSTYLE, 0, 0, this.Hwnd)
    /**
     * Creates a {@link TreeViewEx_LogFont} object and sets it to property "Font". Use the font object
     * to adjust the control's font attributes. See {@link TreeViewEx_LogFont} for details.
     *
     * @returns {TreeViewEx_LogFont}
     */
    GetFont() {
        if !this.HasOwnProp('Font') {
            this.Font := TreeViewEx_LogFont(this.Hwnd)
        }
        this.Font.Call()
        return this.Font
    }
    GetAdjacentRect(RectObj, Handle?, ContainerRect?, Dimension := 'X', Prefer := '', Padding := 0, InsufficientSpaceAction := 0) {
        if !IsSet(Handle) {
            Handle := this.GetSelected()
        }
        if !Handle {
            return 0
        }
        RectMoveAdjacent(RectObj, this.GetItemRect(Handle), ContainerRect ?? unset, Dimension, Prefer, Padding, InsufficientSpaceAction)
        return RectObj
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
    GetItemRect(Handle?) {
        rc := Rect()
        if !IsSet(Handle) {
            Handle := this.GetSelected()
            if !Handle {
                throw Error('No item is selected', -1)
            }
        }
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
    GetNext(Handle) => SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, Handle, this.Hwnd)
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
        return this.Collection.GetValue(Handle)
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
        rc.ToClient(this.HwndGui, true)
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
    GetTemplate(Name) {
        return this.Templates.Get(Name)
    }
    GetText(Handle) {
        struct := TvItem()
        struct.mask := TVIF_TEXT | TVIF_HANDLE
        struct.hItem := Handle
        struct.SetTextBuffer()
        if SendMessage(TVM_GETITEMW, 0, struct.Ptr, this.Hwnd) {
            return struct.pszText
        }
        throw Error('Failed to get the item`'s text.')
    }
    GetTextColor() => SendMessage(TVM_GETTEXTCOLOR, 0, 0, this.Hwnd)
    GetTooltips() => SendMessage(TVM_GETTOOLTIPS, 0, 0, this.Hwnd)
    GetVisibleCount() => SendMessage(TVM_GETVISIBLECOUNT, 0, 0, this.Hwnd)
    HasChildren(Handle) {
        item := TvItem()
        item.mask := TVIF_CHILDREN
        item.hItem := Handle
        if SendMessage(TVM_GETITEMW, 0, item.Ptr, this.Hwnd) {
            return item.cChildren
        } else {
            throw OSError()
        }
    }
    Hide() {
        this.Enabled := this.Visible := 0
    }
    /**
     * If one or both of `X` and `Y` are unset, the mouse's position is used.
     * @param {Integer} [X] - The X-coordinate relative to the TreeView control (client coordinate).
     * @param {Integer} [Y] - The Y-coordinate relative to the TreeView control (client coordinate).
     * @returns {TvHitTestInfo}
     */
    HitTest(X?, Y?) {
        if IsSet(X) && IsSet(Y) {
            hitTestInfo := TvHitTestInfo()
            hitTestInfo.X := X
            hitTestInfo.Y := Y
        } else {
            pt := Point.FromCursor()
            pt.ToClient(this.Hwnd, true)
            hitTestInfo := TvHitTestInfo(pt)
        }
        SendMessage(TVM_HITTEST, 0, hitTestInfo.Ptr, this.Hwnd)
        return hitTestInfo
    }
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-insertitem}
     * @param {TvInsertStruct} Struct - {@link TvInsertStruct}
     */
    Insert(Struct) => SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd)
    IsExpanded(Handle?) {
        if !IsSet(Handle) {
            Handle := this.GetSelected()
        }
        return SendMessage(TVM_GETITEMSTATE, Handle, TVIS_EXPANDED, this.Hwnd) & TVIS_EXPANDED
    }
    IsRoot(Handle) => !SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Handle, this.Hwnd)
    /**
     * Returns 1 if `HandleDescentant` is a descendant of `HandlePotentialAncestor`.
     *
     * @param {Integer} [HandleDescendant] - A tree-view item handle. If unset, the handle to the
     * currently selected item is used. If unset and no item is selected, the function returns 0.
     *
     * @param {Integer} [HandlePotentialAncestor] - A tree-view item handle. If unset, the handle to
     * the currently selected item is used. If unset and no item is selected, the function returns 0.
     *
     * @returns {Integer} -
     * - Returns 0 if `HandleDescendant` is unset and no item is selected.
     * - Returns 0 if `HandlePotentialAncestor` is unset and no item is selected.
     * - Returns 0 if `HandleDescendant = HandlePotentialAncestor`.
     * - Returns 1 if `HandleDescendant` is a descendant of `HandlePotentialAncestor`.
     */
    IsAncestor(HandleDescendant?, HandlePotentialAncestor?) {
        if !IsSet(HandleDescendant) {
            HandleDescendant := this.GetSelected()
            if !HandleDescendant {
                return 0
            }
        }
        if !IsSet(HandlePotentialAncestor) {
            HandlePotentialAncestor := this.GetSelected()
            if !HandlePotentialAncestor {
                return 0
            }
        }
        if HandleDescendant = HandlePotentialAncestor {
            return 0
        }
        h := HandleDescendant
        while h := SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, h, this.Hwnd) {
            if h = HandlePotentialAncestor {
                return 1
            }
        }
        return 0
    }
    MapAccIdToHTreeItem(AccId) => SendMessage(TVM_MAPACCIDTOHTREEITEM, AccId, 0, this.Hwnd)
    MapHTreeItemToAccId(Handle) => SendMessage(TVM_MAPHTREEITEMTOACCID, Handle, 0, this.Hwnd)
    OnCommand(CommandCode, Callback, AddRemove := 1) {
        if !this.HasOwnProp('ParentSubclass') {
            this.CreateParentSubclass()
        }
        if AddRemove {
            this.ParentSubclass.CommandAdd(CommandCode, Callback, AddRemove)
        } else {
            this.ParentSubclass.CommandDelete(CommandCode, Callback)
        }
    }
    OnMessage(MessageCode, Callback, AddRemove := 1) {
        if !this.HasOwnProp('ParentSubclass') {
            this.CreateParentSubclass()
        }
        if AddRemove {
            this.ParentSubclass.MessageAdd(MessageCode, Callback, AddRemove)
        } else {
            this.ParentSubclass.MessageDelete(MessageCode, Callback)
        }
    }
    OnNotify(NotifyCode, Callback, AddRemove := 1) {
        if !this.HasOwnProp('ParentSubclass') {
            this.CreateParentSubclass()
        }
        if AddRemove {
            this.ParentSubclass.NotifyAdd(NotifyCode, Callback, AddRemove)
        } else {
            this.ParentSubclass.NotifyDelete(NotifyCode, Callback)
        }
    }
    /**
     * See {@link https://learn.microsoft.com/en-us/windows/win32/api/Winuser/nf-winuser-redrawwindow}.
     * @param {Integer} [flags = RDW_ERASE | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN] -
     * Zero or a combination of the flags lsited in the
     * {@link https://learn.microsoft.com/en-us/windows/win32/api/Winuser/nf-winuser-redrawwindow documentation}.
     */
    Redraw(flags := RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN) {
        Sleep(-1)
        return DllCall(
            g_user32_RedrawWindow
          , 'ptr', this.Hwnd
          , 'ptr', 0
          , 'ptr', 0
          , 'uint', flags
        )
    }
    RemoveParentSubclass() {
        this.ParentSubclass.Dispose()
    }
    Select(Handle) => SendMessage(TVM_SELECTITEM, TVGN_CARET, Handle, this.Hwnd)
    SetAutoScrollInfo(PixelsPerSecond, RedrawInterval) => SendMessage(TVM_SETAUTOSCROLLINFO, PixelsPerSecond, RedrawInterval, this.Hwnd)
    SetBkColor(Color) => SendMessage(TVM_SETBKCOLOR, 0, Color, this.Hwnd)
    SetContextMenu(MenuExObj) {
        if IsSet(MenuEx) && MenuExObj is MenuEx {
            this.OnMessage(WM_CONTEXTMENU, TreeViewEx_HandlerContextMenu)
            this.ContextMenu := MenuExObj
        } else {
            throw TypeError('``MenuExObj`` must inherit from ``MenuEx``.')
        }
    }
    /**
     *
     */
    SetExtendedStyle(Value, Styles) => SendMessage(TVM_SETEXTENDEDSTYLE, Value, Styles, this.Hwnd)
    /**
     * Sets the height of the TreeViewEx control as a number of rows that can be displayed in the
     * control's client area concurrently.
     * @param {Integer} Rows - The number of rows.
     * @returns {Integer} - The new height.
     */
    SetHeight(Rows) {
        height := Rows * this.GetItemHeight() + (this.Border ? 2 : 0)
        WinMove(, , , height)
        return height
    }
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
    /**
     * Example setting two states, both true states.
     * @example
     * ; Assume `tvex` references an existing TreeViewEx object and `handle` is a tree-view item handle.
     * ; Set as expanded and selected.
     * ; This would not expand the node, it only sets the state value.
     * tvex.SetItemState(tv, TVIS_EXPANDED | TVIS_SELECTED, TVIS_EXPANDED | TVIS_SELECTED, handle)
     * @
     *
     * Example setting two states, one true one false states.
     * @example
     * ; Assume `tvex` references an existing TreeViewEx object and `handle` is a tree-view item handle.
     * ; Set as expanded and not selected.
     * ; This would not expand or deselect the node, it only sets the state value.
     * tvex.SetItemState(tv, TVIS_EXPANDED | TVIS_SELECTED, TVIS_EXPANDED, hItem)
     * @
     *
     * Example setting two states, both false states.
     * @example
     * ; Assume `tvex` references an existing TreeViewEx object and `handle` is a tree-view item handle.
     * ; Set as not expanded and not selected.
     * ; This would not collapse or deselect the node, it only sets the state value.
     * tvex.SetItemState(tv, TVIS_EXPANDED | TVIS_SELECTED, , hItem)
     * @
     */
    SetItemState(StateMask, ValueMask := 0, Handle?) {
        if !IsSet(Handle) {
            Handle := this.GetSelected()
        }
        if !Handle {
            return 0
        }
        struct := TvItem()
        struct.mask := TVIF_STATE
        struct.hItem := Handle
        struct.stateMask := StateMask
        struct.state := ValueMask
        return SendMessage(TVM_SETITEMW, 0, struct.Ptr, this.Hwnd)
    }
    SetItemHeight(Height) => SendMessage(TVM_SETITEMHEIGHT, Height, 0, this.Hwnd)
    SetLineColor(Color) => SendMessage(TVM_SETLINECOLOR, 0, Color, this.Hwnd)
    SetNodeConstructor(NodeClass) {
        this.Constructor := Class()
        this.Constructor.Base := NodeClass
        this.Constructor.Prototype := {
            HwndCtrl: this.Hwnd
          , __Class: NodeClass.Prototype.__Class
        }
        ObjSetBase(this.Constructor.Prototype, NodeClass.Prototype)
        this.Constructor.Prototype.DefineProp('Ctrl', { Get: TreeViewEx_GetTreeViewExCtrl })
        this.Collection := TreeViewExCollection_Node()
    }
    /**
     * @param {Boolean} Value - If true, allows changes in the window to be redrawn, and also calls
     * {@link TreeViewEx.Prototype.Redraw}. If false, does not allow changes in the window to be redrawn.
     *
     * This is analagous to the
     * {@link https://www.autohotkey.com/docs/v2/lib/Gui.htm#Add_Parameters "+/-Redraw" Gui.Control option}.
     */
    SetRedraw(Value) {
        SendMessage(WM_SETREDRAW, Value, 0, this.Hwnd)
        if Value {
            this.Redraw()
        }
    }
    SetScrollTime(TimeMs) => SendMessage(TVM_SETSCROLLTIME, TimeMs, 0, this.Hwnd)
    SetTextColor(Color) => SendMessage(TVM_SETTEXTCOLOR, 0, Color, this.Hwnd)
    SetTooltips(Handle) => SendMessage(TVM_SETTOOLTIPS, Handle, 0, this.Hwnd)
    Show() {
        this.Enabled := this.Visible := 1
    }
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
    Border {
        Get => WinGetStyle(this.Hwnd) & WS_BORDER
        Set {
            if Value {
                WinSetStyle('+' WS_BORDER, this.Hwnd)
            } else {
                WinSetStyle('-' WS_BORDER, this.Hwnd)
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
    Enabled {
        Get => DllCall(g_user32_IsWindowEnabled, 'ptr', this.Hwnd, 'int')
        Set => DllCall(g_user32_EnableWindow, 'ptr', this.Hwnd, 'int', Value ? 1 : 0, 'int')
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
    Font {
        Get {
            this.DefineProp('Font', { Value: TreeViewEx_LogFont(this.Hwnd) })
            return this.Font
        }
        Set {
            this.DefineProp('Font', { Value: Value })
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
    Visible {
        Get => DllCall(g_user32_IsWindowVisible, 'ptr', this.Hwnd, 'int')
        Set => DllCall(g_user32_ShowWindow, 'ptr', this.Hwnd, 'int', Value ? 4 : 0, 'int')
    }

    class Options {
        static __New() {
            this.DeleteProp('__New')
            if !IsSet(TVS_HASBUTTONS) {
                TreeViewEx_SetConstants()
            }
            this.Default := {
                AddExStyle: ''
              , AddStyle: ''
              , BkColor: ''
              , ExStyle: TVS_EX_DOUBLEBUFFER | WS_EX_COMPOSITED
              , Font: ''
              , Height: ''
              , ImageListNormal: ''
              , ImageListState: ''
              , Indent: ''
              , InsertMarkColor: ''
              , Instance: 0
              , ItemHeight: ''
              , LineColor: ''
              , Menu: 0
              , Name: ''
              , Param: 0
              , Rows: ''
              , ScrollTime: ''
              , Style: TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT | TVS_SHOWSELALWAYS | WS_CHILD | WS_CLIPSIBLINGS | WS_VISIBLE | WS_BORDER
              , TextColor: ''
              , Width: 100
              , WindowName: 0
              , X: ''
              , Y: ''
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
