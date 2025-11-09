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
        proto.NodeConstructor := proto.Collection := proto.ParentSubclass := proto.Subclass :=
        proto.CallbackOnExit := proto.ContextMenu := proto.TvexTabId := ''
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
     * @param {Boolean} [Options.SkipOptions = false] - If true, the `Options` object does not get passed
     * to {@link TreeViewEx.Options.Call}. Set this to true only if the object has already been passed
     * to {@link TreeViewEx.Options.Call}, and so it does not need to be processed again.
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
     * If you use this, your code must set a TVN_DELETEITEMW handler that includes calling
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
        global g_TreeViewEx_Node := this.NodeConstructor.Call(Params*)
        node := g_TreeViewEx_Node
        Struct.lParam := ObjPtrAddRef(node)
        if node.handle := SendMessage(TVM_INSERTITEMW, 0, Struct.Ptr, this.Hwnd) {
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
        global g_TreeViewEx_Node := this.NodeConstructor.Call(Params*)
        node := g_TreeViewEx_Node
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
        this.Templates.Set(Items*)
    }
    Collapse(Handle) => SendMessage(TVM_EXPAND, TVE_COLLAPSE, Handle, this.Hwnd)
    /**
     * - Sends TVN_ITEMEXPANDINGW with TVE_COLLAPSE. If the return value is zero or an empty string:
     *   - Sends TVM_EXPAND with TVE_COLLAPSE.
     *   - Sends TVN_ITEMEXPANDEDW with TVE_COLLAPSE.
     *
     * @param {Integer} Handle - The tree-view item handle.
     * @param {VarRef} [OutExpandedResult] - A variable that receives the return value from
     * `SendMessage` with TVN_ITEMEXPANDEDW.
     * @returns {Integer} - If `SendMessage` with TVN_ITEMEXPANDINGW returns a nonzero number, returns
     * that value. Else, returns 0.
     */
    CollapseNotify(Handle, &OutExpandedResult?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        if result := this.SendItemExpanding(Handle, TVE_COLLAPSE, &Struct, UseCache) {
            return result
        }
        SendMessage(TVM_EXPAND, TVE_COLLAPSE, Handle, this.Hwnd)
        OutExpandedResult := this.SendItemExpanded(Struct)
        return 0
    }
    CollapseRecursive(Handle := 0, Reset := false) {
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
        action := Reset ? TVE_COLLAPSERESET : TVE_COLLAPSE
        loop toCollapse.Length {
            SendMessage(TVM_EXPAND, action, toCollapse[-A_Index], this.Hwnd)
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
    CollapseRecursiveNotify(Handle := 0, Reset := false, UseCache := TVEX_SENDNOTIFY_USECACHE) {
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
        action := Reset ? TVE_COLLAPSERESET : TVE_COLLAPSE
        loop toCollapse.Length {
            if !this.SendItemExpanding(toCollapse[-A_Index], action, &Struct, UseCache) {
                SendMessage(TVM_EXPAND, action, toCollapse[-A_Index], this.Hwnd)
                this.SendItemExpanded(Struct)
            }
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
    CollapseReset(Handle) => SendMessage(TVM_EXPAND, TVE_COLLAPSERESET, Handle, this.Hwnd)
    /**
     * - Sends TVN_ITEMEXPANDINGW with TVE_COLLAPSE. If the return value is zero or an empty string:
     *   - Sends TVM_EXPAND with TVE_COLLAPSE.
     *   - Sends TVN_ITEMEXPANDEDW with TVE_COLLAPSE.
     *
     * @param {Integer} Handle - The tree-view item handle.
     * @param {VarRef} [OutExpandedResult] - A variable that receives the return value from
     * `SendMessage` with TVN_ITEMEXPANDEDW.
     * @returns {Integer} - If `SendMessage` with TVN_ITEMEXPANDINGW returns a nonzero number, returns
     * that value. Else, returns 0.
     */
    CollapseResetNotify(Handle, &OutExpandedResult?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        if result := this.SendItemExpanding(Handle, TVE_COLLAPSERESET, &Struct, UseCache) {
            return result
        }
        SendMessage(TVM_EXPAND, TVE_COLLAPSERESET, Handle, this.Hwnd)
        OutExpandedResult := this.SendItemExpanded(Struct)
        return 0
    }
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
    DeleteAll() => SendMessage(TVM_DELETEITEM, 0, 0, this.Hwnd)
    DeleteAll_C() {
        this.DeleteAll()
        this.Collection.Length := 0
    }
    DeleteChildren(Handle) {
        while child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
            SendMessage(TVM_DELETEITEM, 0, child, this.Hwnd)
        }
    }
    /**
     * Delete all callbacks associated with a command code.
     */
    DeleteCommandCode(CommandCode) {
        this.ParentSubclass.CommandDelete(this.HwndGui, this, CommandCode)
    }
    DeleteItem(Handle) => SendMessage(TVM_DELETEITEM, 0, Handle, this.Hwnd)
    /**
     * Delete all callbacks associated with a message code.
     */
    DeleteMessageCode(MessageCode) {
        this.ParentSubclass.MessageDelete(this.HwndGui, this, MessageCode)
    }
    DeleteNode_C(Handle) {
        this.Collection.Remove(Handle, &node)
        SendMessage(TVM_DELETEITEM, 0, Handle, this.Hwnd)
        return node
    }
    /**
     * Delete all callbacks associated with a notify code.
     */
    DeleteNotifyCode(NotifyCode) {
        this.ParentSubclass.NotifyDelete(this.HwndGui, this, NotifyCode)
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
        if this.CallbackOnExit {
            OnExit(this.CallbackOnExit, 0)
            this.DeleteProp('CallbackOnExit')
        }
        if this.ContextMenu {
            this.DeleteProp('ContextMenu')
        }
        if WinExist(this.Hwnd) {
            this.Destroy()
        }
    }
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvm-editlabel}.
     * @param {Integer} [Handle] - The id of the item to edit. If unset, the currently selected
     * item is edited.
     * @returns {Integer} - The handle to the edit control that is created for editing the label, or
     * 0 if unsuccessful.
     */
    EditLabel(Handle?) {
        if !IsSet(Handle) {
            Handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
        }
        if !Handle {
            return 0
        }
        SendMessage(TVM_EDITLABELW, 0, Handle, this.Hwnd)
    }
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
     * @param {Integer} [MaxDepth = TVEX_MAX_RECURSION] - The maximum depth to expand.
     */
    EnumChildrenRecursive(Handle := 0, MaxDepth := TVEX_MAX_RECURSION) {
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
     * - Sends TVN_ITEMEXPANDINGW with TVE_EXPAND. If the return value is zero or an empty string:
     *   - Sends TVM_EXPAND with TVE_EXPAND.
     *   - Sends TVN_ITEMEXPANDEDW with TVE_EXPAND.
     *
     * @param {Integer} Handle - The tree-view item handle.
     * @param {VarRef} [OutExpandedResult] - A variable that receives the return value from
     * `SendMessage` with TVN_ITEMEXPANDEDW.
     * @returns {Integer} - If `SendMessage` with TVN_ITEMEXPANDINGW returns a nonzero number, returns
     * that value. Else, returns 0.
     */
    ExpandNotify(Handle, &OutExpandedResult?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        if result := this.SendItemExpanding(Handle, TVE_EXPAND, &Struct, UseCache) {
            return result
        }
        SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
        OutExpandedResult := this.SendItemExpanded(Struct)
        return 0
    }
    ExpandPartial(Handle) => SendMessage(TVM_EXPAND, TVE_EXPANDPARTIAL | TVE_EXPAND, Handle, this.Hwnd)
    /**
     * - Sends TVN_ITEMEXPANDINGW with TVE_EXPANDPARTIAL. If the return value is zero or an empty
     *   string:
     *   - Sends TVM_EXPAND with TVE_EXPANDPARTIAL.
     *   - Sends TVN_ITEMEXPANDEDW with TVE_EXPANDPARTIAL.
     *
     * @param {Integer} Handle - The tree-view item handle.
     * @param {VarRef} [OutExpandedResult] - A variable that receives the return value from
     * `SendMessage` with TVN_ITEMEXPANDEDW.
     * @returns {Integer} - If `SendMessage` with TVN_ITEMEXPANDINGW returns a nonzero number, returns
     * that value. Else, returns 0.
     */
    ExpandPartialNotify(Handle, &OutExpandedResult?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        if result := this.SendItemExpanding(Handle, TVE_EXPANDPARTIAL | TVE_EXPAND, &Struct, UseCache) {
            return result
        }
        SendMessage(TVM_EXPAND, TVE_EXPANDPARTIAL | TVE_EXPAND, Handle, this.Hwnd)
        OutExpandedResult := this.SendItemExpanded(Struct)
        return 0
    }
    /**
     * @param {Integer} [Handle = 0] - The node to expand. If 0, all nodes are expanded.
     * @param {Integer} [MaxDepth = TVEX_MAX_RECURSION] - The maximum depth to expand.
     */
    ExpandRecursive(Handle := 0, MaxDepth := TVEX_MAX_RECURSION, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        if Handle {
            if MaxDepth > 0 {
                depth := 0
                _RecurseMaxDepth(Handle)
            } else {
                _Recurse(Handle)
            }
        } else {
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, 0, this.Hwnd) {
                if MaxDepth > 0 {
                    depth := 0
                    _RecurseMaxDepth(child)
                    while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                        _RecurseMaxDepth(child)
                    }
                } else {
                    _Recurse(child)
                    while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                        _Recurse(child)
                    }
                }
            }
        }

        return

        _Recurse(Handle) {
            local child
            if this.HasChildren(Handle, UseCache) {
                SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
            }
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                _Recurse(child)
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    _Recurse(child)
                }
            }
        }
        _RecurseMaxDepth(Handle) {
            local child
            depth++
            if this.HasChildren(Handle, UseCache) {
                SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
            }
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
     * - Sends TVN_ITEMEXPANDINGW with TVE_EXPAND. If the return value is zero or an empty string:
     *   - Sends TVM_EXPAND with TVE_EXPAND.
     *   - Sends TVN_ITEMEXPANDEDW with TVE_EXPAND.
     *
     * @param {Integer} [Handle = 0] - The node to expand. If 0, all nodes are expanded.
     * @param {Integer} [MaxDepth = TVEX_MAX_RECURSION] - The maximum depth to expand.
     */
    ExpandRecursiveNotify(Handle := 0, MaxDepth := TVEX_MAX_RECURSION, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        if Handle {
            if MaxDepth > 0 {
                depth := 0
                _RecurseMaxDepth(Handle)
            } else {
                _Recurse(Handle)
            }
        } else {
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, 0, this.Hwnd) {
                if MaxDepth > 0 {
                    depth := 0
                    _RecurseMaxDepth(child)
                    while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                        _RecurseMaxDepth(child)
                    }
                } else {
                    _Recurse(child)
                    while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                        _Recurse(child)
                    }
                }
            }
        }

        return

        _Recurse(Handle) {
            local child
            if this.HasChildren(Handle, UseCache) {
                if !this.SendItemExpanding(Handle, TVE_EXPAND, &Struct, UseCache) {
                    SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
                    this.SendItemExpanded(Struct)
                }
            }
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                _Recurse(child)
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    _Recurse(child)
                }
            }
        }
        _RecurseMaxDepth(Handle) {
            local child
            depth++
            if this.HasChildren(Handle, UseCache) {
                if !this.SendItemExpanding(Handle, TVE_EXPAND, &Struct, UseCache) {
                    SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
                    this.SendItemExpanded(Struct)
                }
            }
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
     * - Sends TVN_ITEMEXPANDINGW with TVE_EXPAND. If the return value is zero or an empty string:
     *   - Sends TVM_EXPAND with TVE_EXPAND.
     *   - Sends TVN_ITEMEXPANDEDW with TVE_EXPAND.
     *
     * @param {*} Callback - A `Func` or callable object that is called to determine if a node should
     * be expanded. The callback does not get called for `Handle`.
     * - Parameters:
     *   1. {Integer} The tree-view item handle.
     *   2. {Integer} The handle to the parent item of #1.
     *   3. {Integer} The depth at which the tree-view item associated with parameter 1 is located.
     *      Children of `Handle` are depth 1.
     *   4. {TreeViewEx} The {@link TreeViewEx} object.
     * - The function should return one of the following:
     *   - 0 (or an empty string) : Expand the node and iterate the node's children.
     *   - 1 : Expand the node but do not iterate the node's children, move on to the next sibling node.
     *   - 2 : Expand the node and end the function call. {@link TreeViewEx.Prototype.ExpandRecursiveNotifySelective}
     *     returns `2` to the caller.
     *   - 3 : Do not expand the node and move on to the next sibling node.
     *   - Any other number : Do not expand the node and end the function call.
     *    {@link TreeViewEx.Prototype.ExpandRecursiveNotifySelective} returns the number to the caller.
     *
     * @param {Integer} [Handle = 0] - The node to expand. If 0, all nodes are expanded.
     *
     * @returns {Integer} - One of the following:
     * - 0 : If `Callback` never returned `2` or `4`.
     * - 2 : If `Callback` returned `2`.
     * - 4 : If `Callback` returned `4`.
     */
    ExpandRecursiveNotifySelective(Callback, Handle := 0, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        flag_unwind := false
        if Handle {
            depth := 0
            _Recurse(Handle)
        } else {
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, 0, this.Hwnd) {
                depth := 1
                result := Callback(child, Handle, depth, this)
                switch result, 0 {
                    case 0, '': _Recurse(child)
                    case 1:
                        if this.HasChildren(child, UseCache) {
                            if !this.SendItemExpanding(child, TVE_EXPAND, &Struct, UseCache) {
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                this.SendItemExpanded(Struct)
                            }
                        }
                    case 2:
                        if this.HasChildren(child, UseCache) {
                            if !this.SendItemExpanding(child, TVE_EXPAND, &Struct, UseCache) {
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                this.SendItemExpanded(Struct)
                            }
                        }
                        return 2
                    case 3: ; do nothing
                    default: return result
                }
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    result := Callback(child, Handle, depth, this)
                    switch result, 0 {
                        case 0, '': _Recurse(child)
                        case 1:
                            if this.HasChildren(child, UseCache) {
                                if !this.SendItemExpanding(child, TVE_EXPAND, &Struct, UseCache) {
                                    SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                    this.SendItemExpanded(Struct)
                                }
                            }
                        case 2:
                            if this.HasChildren(child, UseCache) {
                                if !this.SendItemExpanding(child, TVE_EXPAND, &Struct, UseCache) {
                                    SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                    this.SendItemExpanded(Struct)
                                }
                            }
                            return 2
                        case 3: ; do nothing
                        default: return result
                    }
                }
            }
        }

        return flag_unwind

        _Recurse(Handle) {
            local child
            depth++
            if this.HasChildren(Handle, UseCache) {
                if !this.SendItemExpanding(Handle, TVE_EXPAND, &Struct, UseCache) {
                    SendMessage(TVM_EXPAND, TVE_EXPAND, Handle, this.Hwnd)
                    this.SendItemExpanded(Struct)
                }
            }
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                result := Callback(child, Handle, depth, this)
                switch result, 0 {
                    case 0, '': _Recurse(child)
                    case 1:
                        if this.HasChildren(child, UseCache) {
                            if !this.SendItemExpanding(child, TVE_EXPAND, &Struct, UseCache) {
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                this.SendItemExpanded(Struct)
                            }
                        }
                    case 2:
                        if this.HasChildren(child, UseCache) {
                            if !this.SendItemExpanding(child, TVE_EXPAND, &Struct, UseCache) {
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                this.SendItemExpanded(Struct)
                            }
                        }
                        flag_unwind := 2
                    case 3: ; do nothing
                    default: flag_unwind := result
                }
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    if flag_unwind {
                        return
                    }
                    result := Callback(child, Handle, depth, this)
                    switch result, 0 {
                        case 0, '': _Recurse(child)
                        case 1:
                            if this.HasChildren(child, UseCache) {
                                if !this.SendItemExpanding(child, TVE_EXPAND, &Struct, UseCache) {
                                    SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                    this.SendItemExpanded(Struct)
                                }
                            }
                        case 2:
                            if this.HasChildren(child, UseCache) {
                                if !this.SendItemExpanding(child, TVE_EXPAND, &Struct, UseCache) {
                                    SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                                    this.SendItemExpanded(Struct)
                                }
                            }
                            flag_unwind := 2
                        case 3: ; do nothing
                        default: flag_unwind := result
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
     * be expanded. The callback does not get called for `Handle`.
     * - Parameters:
     *   1. {Integer} The tree-view item handle.
     *   2. {Integer} The handle to the parent item of #1.
     *   3. {Integer} The depth at which the tree-view item associated with parameter 1 is located.
     *      Children of `Handle` are depth 1.
     *   4. {TreeViewEx} The {@link TreeViewEx} object.
     * - The function should return one of the following:
     *   - 0 (or an empty string) : Expand the node and iterate the node's children.
     *   - 1 : Expand the node but do not iterate the node's children, move on to the next sibling node.
     *   - 2 : Expand the node and end the function call. {@link TreeViewEx.Prototype.ExpandRecursiveNotifySelective}
     *     returns `2` to the caller.
     *   - 3 : Do not expand the node and move on to the next sibling node.
     *   - Any other number : Do not expand the node and end the function call.
     *    {@link TreeViewEx.Prototype.ExpandRecursiveNotifySelective} returns the number to the caller.
     *
     * @param {Integer} [Handle = 0] - The node to expand. If 0, all nodes are expanded.
     *
     * @returns {Integer} - One of the following:
     * - 0 : If `Callback` never returned `2` or `4`.
     * - 2 : If `Callback` returned `2`.
     * - 4 : If `Callback` returned `4`.
     */
    ExpandRecursiveSelective(Callback, Handle := 0, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        flag_unwind := false
        if Handle {
            depth := 0
            _Recurse(Handle)
        } else {
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, 0, this.Hwnd) {
                depth := 1
                result := Callback(child, Handle, depth, this)
                switch result, 0 {
                    case 0, '': _Recurse(child)
                    case 1:
                        if this.HasChildren(child, UseCache) {
                            SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                        }
                    case 2:
                        if this.HasChildren(child, UseCache) {
                            SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                        }
                        return 2
                    case 3: ; do nothing
                    default: return result
                }
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    result := Callback(child, Handle, depth, this)
                    switch result, 0 {
                        case 0, '': _Recurse(child)
                        case 1:
                            if this.HasChildren(child, UseCache) {
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                            }
                        case 2:
                            if this.HasChildren(child, UseCache) {
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                            }
                            return 2
                        case 3: ; do nothing
                        default: return result
                    }
                }
            }
        }

        return flag_unwind

        _Recurse(Handle) {
            local child
            depth++
            if this.HasChildren(Handle, UseCache) {
                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
            }
            if child := SendMessage(TVM_GETNEXTITEM, TVGN_CHILD, Handle, this.Hwnd) {
                result := Callback(child, Handle, depth, this)
                switch result, 0 {
                    case 0, '': _Recurse(child)
                    case 1:
                        if this.HasChildren(child, UseCache) {
                            SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                        }
                    case 2:
                        if this.HasChildren(child, UseCache) {
                            SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                        }
                        flag_unwind := 2
                    case 3: ; do nothing
                    default: flag_unwind := result
                }
                while child := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, child, this.Hwnd) {
                    if flag_unwind {
                        return
                    }
                    result := Callback(child, Handle, depth, this)
                    switch result, 0 {
                        case 0, '': _Recurse(child)
                        case 1:
                            if this.HasChildren(child, UseCache) {
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                            }
                        case 2:
                            if this.HasChildren(child, UseCache) {
                                SendMessage(TVM_EXPAND, TVE_EXPAND, child, this.Hwnd)
                            }
                            flag_unwind := 2
                        case 3: ; do nothing
                        default: flag_unwind := result
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
     * Calculates the optimal position to move one rectangle adjacent to another while
     * ensuring that the `Subject` rectangle stays within the monitor's work area. The properties
     * { L, T, R, B } of `Subject` are updated with the new values.
     *
     * @see {@link RectMoveAdjacent} for parameter information.
     */
    GetAdjacentRect(RectObj, Handle?, ContainerRect?, Dimension := 'X', Prefer := '', Padding := 0, InsufficientSpaceAction := 0) {
        if !IsSet(Handle) {
            Handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
        }
        if !Handle {
            return 0
        }
        RectMoveAdjacent(RectObj, this.GetItemRect(Handle), ContainerRect ?? unset, Dimension, Prefer, Padding, InsufficientSpaceAction)
        return RectObj
    }
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
        if this.HasOwnProp('__Class') {
            return ''
        }
        if !this.HasOwnProp('Font') {
            this.DefineProp('Font', { Value: TreeViewEx_LogFont(this.Hwnd) })
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
    GetItemRect(Handle?) {
        rc := Rect()
        if !IsSet(Handle) {
            Handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
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
        node := this.NodeConstructor.Call(Handle)
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
    GetParam(Handle, UseCache := true) {
        if UseCache {
            if this.Templates.Has('_param') {
                item := this.Templates.Get('_param')
            } else {
                item := TvItem()
                item.mask := TVIF_PARAM
                this.Templates.Set('_param', item)
            }
        } else {
            item := TvItem()
            item.mask := TVIF_PARAM
        }
        item.hItem := Handle
        if !SendMessage(TVM_GETITEMW, 0, item.Ptr, this.Hwnd) {
            throw OSError()
        }
        return item.lParam
    }
    GetParent(Handle?) {
        if !IsSet(Handle) {
            Handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
        }
        if !Handle {
            return 0
        }
        return SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Handle, this.Hwnd)
    }
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
     * @returns {WinRect} - A buffer object representing the control's display rect relative to
     * the parent window. See {@link WinRect}.
     */
    GetRect() => WinRect(this.Hwnd).ToClient(this.HwndGui, true)
    GetRoot(Handle?) {
        if !IsSet(Handle) {
            Handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
        }
        if !Handle {
            return 0
        }
        return SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, Handle, this.Hwnd)
    }
    GetScrollTime() => SendMessage(TVM_GETSCROLLTIME, 0, 0, this.Hwnd)
    GetSelected() => SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
    GetTemplate(Name) {
        return this.Templates.Get(Name)
    }
    /**
     * Returns a template {@link TvDispInfoEx} object with the general properties already set. This
     * does the following:
     * - Sets the state mask with TVIS_STATEIMAGEMASK | TVIS_EXPANDED | TVIS_EXPANDEDONCE | TVIS_SELECTED
     *   | TVIS_CUT | TVIS_DROPHILITED | TVIS_BOLD
     * - If `FillText` is true
     *   - Sets the mask with TVIF_HANDLE | TVIF_STATE | TVIF_PARAM | TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_TEXT.
     *   - Sets cchTextMax with `TVEX_DEFAULT_TEXT_MAX / 2` (TVEX_DEFAULT_TEXT_MAX = 256 by default, so 128).
     *   - Sets pszText with a buffer of size `TVEX_DEFAULT_TEXT_MAX`.
     * - If `FillText` is false
     *   - Sets the mask with TVIF_HANDLE | TVIF_STATE | TVIF_PARAM | TVIF_IMAGE | TVIF_SELECTEDIMAGE.
     * - Sets the hwndFrom member with {@link TreeViewEx#Hwnd}.
     * - Sets the idFrom member with {@link TreeViewEx.Prototype.CtrlId}.
     * - Sends TVM_GETITEMW.
     *
     * The caller then should:
     * - Set the code property.
     * - Send the notification.
     *
     * @param {Integer} Handle - The tree-view item handle.
     *
     * @param {Boolean} [FillText = false] - If true, includes TVIF_TEXT and sets cchTextMax and
     * pszText.
     *
     * @param {Boolean} [UseCache = true] - If true:
     * - If this has been called with the same `FillText` value in the past and if
     *   that object still exists in {@link TreeViewEx#Templates}, the cached object is retrieved
     *   and used instead of creating a new object.
     * - If the relevant object does not exist in {@link TreeViewEx#Templates}, then a new object
     *   is created and cached.
     * - The key used depends on the values of `FillText`.
     *
     * If false, a new object is always created and is not cached.
     *
     * @returns {TvDispInfoEx}
     */
    GetTemplateDispInfo(Handle, FillText := false, UseCache := true) {
        local nmtv
        if UseCache {
            if FillText {
                if this.Templates.Has('_dispinfo_text') {
                    nmtv := this.Templates.Get('_dispinfo_text')
                } else {
                    _GetText()
                    this.Templates.Set('_dispinfo_text', nmtv)
                }
            } else {
                if this.Templates.Has('_dispinfo_notext') {
                    nmtv := this.Templates.Get('_dispinfo_notext')
                } else {
                    _GetNoText()
                    this.Templates.Set('_dispinfo_notext', nmtv)
                }
            }
        } else if FillText {
            _GetText()
        } else {
            _GetNoText()
        }
        nmtv.idFrom := this.CtrlId
        nmtv.hItem := Handle
        if !SendMessage(TVM_GETITEMW, 0, nmtv.Ptr + nmtv.offset_mask, this.Hwnd) {
            throw OSError()
        }
        return nmtv

        _GetNoText() {
            nmtv := TvDispInfoEx()
            nmtv.hwndFrom := this.Hwnd
            nmtv.mask := TVIF_HANDLE | TVIF_STATE | TVIF_PARAM | TVIF_IMAGE | TVIF_SELECTEDIMAGE
            nmtv.stateMask := TVIS_STATEIMAGEMASK | TVIS_EXPANDED | TVIS_EXPANDEDONCE
                | TVIS_SELECTED | TVIS_CUT | TVIS_DROPHILITED | TVIS_BOLD
        }
        _GetText() {
            _GetNoText()
            nmtv.mask := nmtv.mask | TVIF_TEXT
            nmtv.SetTextBuffer()
        }
    }
    /**
     * Returns a template {@link TvGetInfoTip} object with the general properties already set. This
     * does the following:
     * - Sets the hwndFrom member with {@link TreeViewEx#Hwnd}.
     * - Sets the idFrom member with {@link TreeViewEx.Prototype.CtrlId}.
     * - Sets the code member with TVN_GETINFOTIPW.
     * - Sets hItem with `Handle`.
     * - Sends TVM_GETITEMW (with a separate structure) to get the lParam associated with `Handle`
     *   and sets lParam.
     *
     * The caller then should:
     * - Call {@link TvGetInfoTip.Prototype.SetTextBuffer} passing the buffer size.
     * - Send the notification.
     *
     * @param {Integer} Handle - The tree-view item handle.
     *
     * @param {Boolean} [UseCache = true] - If true:
     * - If this has been called in the past and if that object still exists in
     *   {@link TreeViewEx#Templates}, the cached object is retrieved and used instead of creating a
     *   new object.
     * - If the relevant object does not exist in {@link TreeViewEx#Templates}, then a new object
     *   is created and cached.
     *
     * If false, a new object is always created and is not cached.
     *
     * @returns {TvGetInfoTip}
     */
    GetTemplateInfoTip(Handle, UseCache := true) {
        local nmtv
        if UseCache {
            if this.Templates.Has('_infotip') {
                nmtv := this.Templates.Get('_infotip')
            } else {
                _Get()
                this.Templates.Set('_infotip', nmtv)
            }
        } else {
            _Get()
        }
        nmtv.hItem := Handle
        nmtv.lParam := this.GetParam(Handle, UseCache)
        nmtv.idFrom := this.CtrlId
        return nmtv

        _Get() {
            nmtv := TvGetInfoTip()
            nmtv.hwndFrom := this.Hwnd
            nmtv.code := TVN_GETINFOTIPW
        }
    }
    /**
     * Returns a template {@link TvItemChange} object with the general properties already set. This
     * does the following:
     * - Sets the hwndFrom member with {@link TreeViewEx#Hwnd}.
     * - Sets the idFrom member with {@link TreeViewEx.Prototype.CtrlId}.
     * - Sets hItem with `Handle`.
     * - Sends TVM_GETITEMW (with a separate structure) to get the lParam associated with `Handle`
     *   and sets lParam.
     * - Sets uChanged with TVIF_STATE.
     *
     * The caller then should:
     * - Set code, uStateNew and uStateOld.
     * - Send the notification.
     *
     * @param {Integer} Handle - The tree-view item handle.
     *
     * @param {Boolean} [UseCache = true] - If true:
     * - If this has been called in the past and if that object still exists in
     *   {@link TreeViewEx#Templates}, the cached object is retrieved and used instead of creating a
     *   new object.
     * - If the relevant object does not exist in {@link TreeViewEx#Templates}, then a new object
     *   is created and cached.
     *
     * If false, a new object is always created and is not cached.
     *
     * @returns {TvItemChange}
     */
    GetTemplateItemChange(Handle, UseCache := true) {
        local nmtv
        if UseCache {
            if this.Templates.Has('_itemchange') {
                nmtv := this.Templates.Get('_itemchange')
            } else {
                _Get()
                this.Templates.Set('_itemchange', nmtv)
            }
        } else {
            _Get()
        }
        nmtv.hItem := Handle
        nmtv.lParam := this.GetParam(Handle, UseCache)
        nmtv.idFrom := this.CtrlId
        return nmtv

        _Get() {
            nmtv := TvItemChange()
            nmtv.hwndFrom := this.Hwnd
            nmtv.uChanged := TVIF_STATE
        }
    }
    /**
     * Returns a template {@link TvKeyDown} object with the general properties already set. This
     * does the following:
     * - Sets the hwndFrom member with {@link TreeViewEx#Hwnd}.
     * - Sets the idFrom member with {@link TreeViewEx.Prototype.CtrlId}.
     * - Sets the code member with TVN_KEYDOWN.
     * - Sets the flags member with 0.
     *
     * The caller then should:
     * - Set wVKey.
     * - Send the notification.
     *
     * @param {Boolean} [UseCache = true] - If true:
     * - If this has been called in the past and if that object still exists in
     *   {@link TreeViewEx#Templates}, the cached object is retrieved and used instead of creating a
     *   new object.
     * - If the relevant object does not exist in {@link TreeViewEx#Templates}, then a new object
     *   is created and cached.
     *
     * If false, a new object is always created and is not cached.
     *
     * @returns {TvKeyDown}
     */
    GetTemplateKeyDown(UseCache := true) {
        local nmtv
        if UseCache {
            if this.Templates.Has('_keydown') {
                nmtv := this.Templates.Get('_keydown')
            } else {
                _Get()
                this.Templates.Set('_keydown', nmtv)
            }
        } else {
            _Get()
        }
        nmtv.idFrom := this.CtrlId
        return nmtv

        _Get() {
            nmtv := TvKeyDown()
            nmtv.hwndFrom := this.Hwnd
            nmtv.code := TVN_KEYDOWN
            nmtv.flags := 0
        }
    }
    /**
     * Returns a template {@link NmTreeView} object with the general properties already set. This
     * does the following:
     * - Sets the state mask with TVIS_STATEIMAGEMASK | TVIS_EXPANDED | TVIS_EXPANDEDONCE | TVIS_SELECTED
     *   | TVIS_CUT | TVIS_DROPHILITED | TVIS_BOLD
     * - If `FillText` is true
     *   - Sets the mask with TVIF_HANDLE | TVIF_STATE | TVIF_PARAM | TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_TEXT.
     *   - Sets cchTextMax with `TVEX_DEFAULT_TEXT_MAX / 2` (TVEX_DEFAULT_TEXT_MAX = 256 by default, so 128).
     *   - Sets pszText with a buffer of size `TVEX_DEFAULT_TEXT_MAX`.
     * - If `FillText` is false
     *   - Sets the mask with TVIF_HANDLE | TVIF_STATE | TVIF_PARAM | TVIF_IMAGE | TVIF_SELECTEDIMAGE.
     * - Sets the hwndFrom member with {@link TreeViewEx#Hwnd}.
     * - Sets the idFrom member with {@link TreeViewEx.Prototype.CtrlId}.
     * - If `FillNew` is true
     *   - Sets hItem_new with `Handle`.
     *   - Sends TVM_GETITEMW specifying the offset to fill the new members.
     * - If `FillNew` is false
     *   - Sets hItem_old with `Handle`.
     *   - Sends TVM_GETITEMW specifying the offset to fill the old members.
     *
     * The caller then should:
     * - Set the other properties (as needed) like code, action, ptDrag.
     * - Send the notification.
     *
     * @param {Integer} Handle - The tree-view item handle.
     *
     * @param {Boolean} [FillNew = true] - If true, sends TVM_GETITEMW to fill the itemNew member of
     * the NMTREEVIEWW structure (setting the properties suffixed with "_new"). If false, sends
     * TVM_GETITEMW to fill the itemOld member of the structure (setting the properties suffixed with
     * "_old").
     *
     * @param {Boolean} [FillText = false] - If true, includes TVIF_TEXT and sets cchTextMax and
     * pszText.
     *
     * @param {Boolean} [UseCache = true] - If true:
     * - If this has been called with the same values of `FillNew` and `FillText` in the past and if
     *   that object still exists in {@link TreeViewEx#Templates}, the cached object is retrieved
     *   and used instead of creating a new object.
     * - If the relevant object does not exist in {@link TreeViewEx#Templates}, then a new object
     *   is created and cached.
     * - The key used depends on the values of `Fillnew` and `FillText`.
     *
     * If false, a new object is always created and is not cached.
     *
     * @returns {NmTreeView}
     */
    GetTemplateNmtv(Handle, FillNew := true, FillText := false, UseCache := true) {
        local nmtv
        if FillNew {
            suffix := '_new'
        } else {
            suffix := '_old'
        }
        if UseCache {
            if FillText {
                if this.Templates.Has('_nmtv' suffix '_text') {
                    nmtv := this.Templates.Get('_nmtv' suffix '_text')
                } else {
                    _GetText()
                    this.Templates.Set('_nmtv' suffix '_text', nmtv)
                }
            } else {
                if this.Templates.Has('_nmtv' suffix '_notext') {
                    nmtv := this.Templates.Get('_nmtv' suffix '_notext')
                } else {
                    _GetNoText()
                    this.Templates.Set('_nmtv' suffix '_notext', nmtv)
                }
            }
        } else if FillText {
            _GetText()
        } else {
            _GetNoText()
        }
        nmtv.idFrom := this.CtrlId
        nmtv.hItem%suffix% := Handle
        if !SendMessage(TVM_GETITEMW, 0, nmtv.Ptr + nmtv.offset_mask%suffix%, this.Hwnd) {
            throw OSError()
        }
        return nmtv

        _GetNoText() {
            nmtv := NmTreeView()
            nmtv.hwndFrom := this.Hwnd
            nmtv.mask%suffix% := TVIF_HANDLE | TVIF_STATE | TVIF_PARAM | TVIF_IMAGE | TVIF_SELECTEDIMAGE
            nmtv.stateMask%suffix% := TVIS_STATEIMAGEMASK | TVIS_EXPANDED | TVIS_EXPANDEDONCE
                | TVIS_SELECTED | TVIS_CUT | TVIS_DROPHILITED | TVIS_BOLD
        }
        _GetText() {
            _GetNoText()
            nmtv.mask%suffix% := nmtv.mask%suffix% | TVIF_TEXT
            nmtv.SetTextBuffer(suffix)
        }
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
    HasChildren(Handle, UseCache := true) {
        if UseCache {
            if this.Templates.Has('_children') {
                item := this.Templates.Get('_children')
            } else {
                item := TvItem()
                item.mask := TVIF_CHILDREN
                this.Templates.Set('_children', item)
            }
        } else {
            item := TvItem()
            item.mask := TVIF_CHILDREN
        }
        item.hItem := Handle
        if !SendMessage(TVM_GETITEMW, 0, item.Ptr, this.Hwnd) {
            throw OSError()
        }
        return item.cChildren
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
            HandleDescendant := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
            if !HandleDescendant {
                return 0
            }
        }
        if !IsSet(HandlePotentialAncestor) {
            HandlePotentialAncestor := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
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
    IsExpanded(Handle?) {
        if !IsSet(Handle) {
            Handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
        }
        return SendMessage(TVM_GETITEMSTATE, Handle, TVIS_EXPANDED, this.Hwnd) & TVIS_EXPANDED
    }
    IsRoot(Handle) => !SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Handle, this.Hwnd)
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
        this.DeleteProp('ParentSubclass')
    }
    ScrollToBottom() {
        this.EnsureVisible(SendMessage(TVM_GETNEXTITEM, TVGN_LASTVISIBLE, 0, this.Hwnd))
    }
    ScrollToTop() {
        this.EnsureVisible(SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, 0, this.Hwnd))
    }
    Select(Handle) => SendMessage(TVM_SELECTITEM, TVGN_CARET, Handle, this.Hwnd)
    SendBeginDrag(Handle, ptDrag?, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateNmtv(Handle, true, false, UseCache)
        OutStruct.code := TVN_BEGINDRAGW
        if !IsSet(ptDrag) {
            ptDrag := Point.FromCursor()
        }
        OutStruct.x := ptDrag.X
        OutStruct.y := ptDrag.Y
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    SendBeginLabelEdit(Handle, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateDispInfo(Handle, true, UseCache)
        OutStruct.code := TVN_BEGINLABELEDITW
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    SendBeginRDrag(Handle, ptDrag?, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateNmtv(Handle, true, false, UseCache)
        OutStruct.code := TVN_BEGINRDRAGW
        if !IsSet(ptDrag) {
            ptDrag := Point.FromCursor()
        }
        OutStruct.x := ptDrag.X
        OutStruct.y := ptDrag.Y
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    SendDeleteItem(Handle, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateNmtv(Handle, false, false, UseCache)
        OutStruct.code := TVN_DELETEITEMW
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvn-endlabeledit}
     *
     * @param {TvDispInfoEx} Struct - The {@link TvDispInfoEx} object with the modified
     * NMTVDISPINFO structure. The item member of this structure is a TVITEM structure whose hItem,
     * lParam, and pszText members contain valid information about the item that was edited. If label
     * editing was canceled, the pszText member of the TVITEM structure is NULL; otherwise, pszText
     * is the address of the edited text.
     *
     * @param {Boolean} [FillMembers = false] - If true, the caller is only responsible for providing
     * a {@link TvDispInfoEx} object with the pszText property and hItem property set; this function
     * will fill the other members of the structure that are expected to be filled when sending the
     * notification. If false, the caller has filled all expected members (except code which this
     * this function always sets).
     *
     * @returns {Integer} - The value returned by `SendMessage`.
     */
    SendEndLabelEdit(Struct, FillMembers := false) {
        if FillMembers {
            Struct.hwndFrom := this.Hwnd
            Struct.idFrom := this.CtrlId
            Struct.mask := TVIF_HANDLE | TVIF_PARAM
            if !SendMessage(TVM_GETITEMW, 0, Struct.Ptr + Struct.offset_mask, this.Hwnd) {
                throw OSError()
            }
            Struct.mask := Struct.mask | TVIF_TEXT
        }
        Struct.code := TVN_ENDLABELEDITW
        return SendMessage(WM_NOTIFY, Struct.idFrom, Struct.Ptr, , this.HwndGui)
    }
    SendGetDispInfo(Handle, Mask, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateDispInfo(Handle, false, UseCache)
        OutStruct.mask := Mask
        OutStruct.code := TVN_GETDISPINFOW
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    SendGetInfoTip(Handle, TextMax := TVEX_DEFAULT_TEXT_MAX, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateInfoTip(Handle, UseCache)
        OutStruct.SetTextBuffer(TextMax)
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvn-itemchanged}
     *
     * @param {TvItemChange} Struct - The {@link TvItemChange} object, typically the same object
     * that was sent with TVN_ITEMCHANGINGW.
     *
     * @param {Boolean} [FillMembers = false] - If true, the caller is only responsible for providing
     * a {@link TvItemChange} object with the hItem, uStateNew, and uStateOld properties set; this
     * function will fill the other members of the structure that are expected to be filled when
     * sending the notification. If false, the caller has filled all expected members (except code
     * which this this function always sets).
     *
     * @returns {Integer} - The value returned by `SendMessage`.
     */
    SendItemChanged(Struct, FillMembers := false, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        if FillMembers {
            Struct.lParam := this.GetParam(Struct.hItem, UseCache)
            Struct.idFrom := this.CtrlId
            Struct.hwndFrom := this.Hwnd
            Struct.uChanged := TVIF_STATE
        }
        Struct.code := TVN_ITEMCHANGEDW
        return SendMessage(WM_NOTIFY, Struct.idFrom, Struct.Ptr, , this.HwndGui)
    }
    SendItemChanging(Handle, StateNew, StateOld, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateItemChange(Handle, UseCache)
        OutStruct.uStateNew := StateNew
        OutStruct.uStateOld := StateOld
        OutStruct.code := TVN_ITEMCHANGINGW
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    /**
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tvn-itemexpanded}
     *
     * @param {NmTreeView} Struct - The {@link NmTreeView} object, typically the same object
     * that was sent with TVN_ITEMEXPANDINGW.
     *
     * @param {Boolean} [FillMembers = false] - If true, the caller is only responsible for providing
     * a {@link NmTreeView} object with the hItem and action properties set; this
     * function will fill the other members of the structure that are expected to be filled when
     * sending the notification. If false, the caller has filled all expected members (except code
     * which this this function always sets).
     *
     * @returns {Integer} - The value returned by `SendMessage`.
     */
    SendItemExpanded(Struct, FillMembers := false) {
        if FillMembers {
            Struct.idFrom := this.CtrlId
            Struct.hwndFrom := this.Hwnd
            Struct.mask_new := TVIF_HANDLE | TVIF_STATE | TVIF_PARAM | TVIF_IMAGE | TVIF_SELECTEDIMAGE
            Struct.stateMask_new := TVIS_STATEIMAGEMASK | TVIS_EXPANDED | TVIS_EXPANDEDONCE
                | TVIS_SELECTED | TVIS_CUT | TVIS_DROPHILITED | TVIS_BOLD
            if !SendMessage(TVM_GETITEMW, 0, Struct.Ptr + Struct.offset_mask_new, this.Hwnd) {
                throw OSError()
            }
        }
        Struct.code := TVN_ITEMEXPANDEDW
        return SendMessage(WM_NOTIFY, Struct.idFrom, Struct.Ptr, , this.HwndGui)
    }
    SendItemExpanding(Handle, Action, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateNmtv(Handle, true, false, UseCache)
        OutStruct.code := TVN_ITEMEXPANDINGW
        OutStruct.action := Action
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    SendKeyDown(Handle, VKey, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateKeyDown(UseCache)
        OutStruct.wVKey := VKey
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    SendSetDispInfo(Handle, Mask, &OutStruct?, UseCache := TVEX_SENDNOTIFY_USECACHE) {
        OutStruct := this.GetTemplateDispInfo(Handle, false, UseCache)
        OutStruct.mask := Mask
        OutStruct.code := TVN_SETDISPINFOW
        return SendMessage(WM_NOTIFY, OutStruct.idFrom, OutStruct.Ptr, , this.HwndGui)
    }
    SetAutoScrollInfo(PixelsPerSecond, RedrawInterval) => SendMessage(TVM_SETAUTOSCROLLINFO, PixelsPerSecond, RedrawInterval, this.Hwnd)
    SetBkColor(Color) => SendMessage(TVM_SETBKCOLOR, 0, Color, this.Hwnd)
    SetContextMenu(MenuExObj) {
        if IsSet(MenuEx) && MenuExObj is MenuEx {
            if this.ContextMenuActive {
                this.ParentSubclass.MessageDelete(WM_CONTEXTMENU)
            }
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
    SetItemHeight(Height) => SendMessage(TVM_SETITEMHEIGHT, Height, 0, this.Hwnd)
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
            Handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
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
    SetLabel(Text, Handle?) {
        if !IsSet(Handle) {
            Handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXTSELECTED, 0, this.Hwnd)
            if !Handle {
                throw Error('No item is currently selected.')
            }
        }
        item := TvItem()
        item.mask := TVIF_TEXT
        item.hItem := Handle
        item.pszText := Text
        return SendMessage(TVM_SETITEMW, 0, item.Ptr, this.Hwnd)
    }
    SetLineColor(Color) => SendMessage(TVM_SETLINECOLOR, 0, Color, this.Hwnd)
    SetNodeConstructor(NodeClass) {
        this.NodeConstructor := TreeViewEx_NodeConstructor()
        this.NodeConstructor.Prototype := {
            HwndCtrl: this.Hwnd
          , __Class: NodeClass.Prototype.__Class
        }
        ObjSetBase(this.NodeConstructor.Prototype, NodeClass.Prototype)
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
    /**
     * @param {Boolean} Value - When nonzero, does the following:
     * - Sets {@link TreeViewEx#Enabled} and {@link TreeViewEx#Visible} to `1`.
     * - Calls `TreeViewExObj.ParentSubclass.WindowSubclass.Install` to activate the SUBCLASSPROC.
     *
     * When zero or an empty string, does the following:
     * - Sets {@link TreeViewEx#Enabled} and {@link TreeViewEx#Visible} to `0`.
     * - Calls `TreeViewExObj.ParentSubclass.WindowSubclass.Uninstall` to deactivate the SUBCLASSPROC.
     */
    SetStatus(Value) {
        if Value {
            this.Enabled := this.Visible := 1
            this.ParentSubclass.WindowSubclass.Install()
        } else {
            this.Enabled := this.Visible := 0
            this.ParentSubclass.WindowSubclass.Uninstall()
        }
    }
    SetTextColor(Color) => SendMessage(TVM_SETTEXTCOLOR, 0, Color, this.Hwnd)
    SetTooltips(Handle) => SendMessage(TVM_SETTOOLTIPS, Handle, 0, this.Hwnd)
    SetTvexTabId(Id) {
        this.TvexTabId := Id
    }
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
    ContextMenuActive => this.ContextMenu && this.HasOwnProp('ParentSubclass') && this.ParentSubclass.MessageGet(WM_CONTEXTMENU)
    CtrlId {
        Get => DllCall(g_user32_GetDlgCtrlID, 'ptr', this.Hwnd, 'ptr')
        Set => DllCall(g_user32_SetWindowLongPtrW, 'ptr', this.Hwnd, 'int', GWLP_ID, 'ptr', Value, 'int')
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
        Get => this.GetFont()
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
    Templates {
        Get {
            this.DefineProp('Templates', { Value: TreeViewExCollection_Template(false) })
            return this.Templates
        }
        Set {
            this.DefineProp('Templates', { Value: Value })
            return this.Templates
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
    TvexTab => this.TvexTabId ? TreeViewEx_Tab.Get(this.TvexTabId) : ''
    Visible {
        Get => DllCall(g_user32_IsWindowVisible, 'ptr', this.Hwnd, 'int')
        Set => DllCall(g_user32_ShowWindow, 'ptr', this.Hwnd, 'int', Value ? 4 : 0, 'int')
    }

    class Options {
        static __New() {
            this.DeleteProp('__New')
            TreeViewEx_SetConstants()
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
              , SkipOptions: false
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
