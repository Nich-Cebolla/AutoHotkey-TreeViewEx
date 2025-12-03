
#include <TreeViewEx>
; https://github.com/Nich-Cebolla/AutoHotkey-TabEx
#include <TabEx>


class TreeViewEx_Tab {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.NodeConstructor := proto.DefaultPropsInfoTreeOptions := proto.DefaultUIATreeOptions :=
        proto.PropsInfoTreeContextMenu := proto.UIATreeContextMenu := proto.PropsInfoTree_NodeConstructor :=
        proto.ContextMenu := proto.DefaultAddOptions := proto.DefaultTreeViewExOptions :=
        proto.UIATree_NodeConstructor :=
        ''
        this.Collection := TreeViewExTabCollection()
    }
    static Add(TreeViewExTabObj) {
        if !this.Collection.Has(TreeViewExTabObj.Id) {
            this.Collection.Set(TreeViewExTabObj.Id, TreeViewExTabObj)
        }
    }
    static Delete(Id) {
        this.Collection.Delete(Number(Id))
    }
    static Get(Id) {
        return this.Collection.Get(Number(Id))
    }
    static GetUid() {
        loop 100 {
            n := Random(1, 2 ** 32 - 1)
            if !this.Collection.Has(n) {
                return n
            }
        }
        throw Error('Failed to generate a unique id.')
    }
    /**
     * Creates a new {@link TreeViewEx_Tab} object. The purpose of {@link TreeViewEx_Tab} is to
     * create a tab control that's primary purpose is for displaying multiple {@link TreeViewEx}
     * controls.
     *
     * @param {Gui} GuiObj - The `Gui` on which to add the tab.
     *
     * @param {Object} [Options] - An object with zero or more options as property : value pairs.
     *
     * @param {*} [Options.CallbackAdd] - If set, a `Func` or callable object that is called for every
     * new {@link TreeViewEx} control. The function can have up to two parameters:
     * 1. The new {@link TreeViewEx} control.
     * 2. The {@link TreeViewEx_Tab} object.
     *
     * The return value is ignored.
     *
     * @param {*} [Options.CallbackDelete] - If set, a `Func` or callable object that is called for
     * every {@link TreeViewEx} control associated with a tab when the tab is deleted.
     *
     * The function can have up to two parameters:
     * 1. {TreeViewEx_Tab.Item} - The new {@link TreeViewEx_Tab.Item} object. Retrieve the control object
     *   from property {@link TreeViewEx_Tab.Item#tvex}.
     * 2. {Boolean} - If the tab being deleted is the currently active tab, this parameter is set with
     *   `1`. Else, this parameter is set with `0`.
     * 3. {Boolean} - If the tab being deleted is the last tab in tab control's internal collection,
     *   this parameter is set with `1`. Else, this parameter is set with `0`.
     * 4. {TreeViewEx_Tab} - The {@link TreeViewEx_Tab} object.
     *
     * The return value is ignored.
     *
     * When `Options.CallbackDelete` is set, the method {@link TreeViewEx_Tab.Prototype.DeleteTab}
     * does **not** call {@link TreeViewEx.Prototype.Dispose}. This is to permit your function the
     * choice whether or not to destroy the control.
     *
     * When `Options.CallbackDelete` is not set, the method does call {@link TreeViewEx.Prototype.Dispose}.
     *
     * @param {*} [Options.CallbackOnChangeBefore] - If set, a `Func` or callable object that is called
     * every time the tab changes. The function can have up to three parameters:
     * 1. The {@link TreeViewEx_Tab} object.
     * 2. An array of the previously active {@link TreeViewEx} controls.
     * 3. An array of the newly active {@link TreeViewEx} controls.
     *
     * The return value is ignored.
     *
     * The function is called before any the previously active controls are disabled.
     *
     * @param {*} [Options.CallbackOnChangeAfter] - If set, a `Func` or callable object that is called
     * every time the tab changes. The function can have up to three parameters:
     * 1. The {@link TreeViewEx_Tab} object.
     * 2. An array of the previously active {@link TreeViewEx} controls.
     * 3. An array of the newly active {@link TreeViewEx} controls.
     *
     * The return value is ignored.
     *
     * The function is called after the previously active controls are disabled, the newly active controls
     * are enabled and the newly active controls are resized.
     *
     * @param {Boolean} [Options.CaseSense = false] - If true, any operations using the `TvexName`
     * value (first parameter of {@link TreeViewEx_Tab.Prototype.Add}) are performed using case
     * sensitivity. If false, they are performed without case sensitivity.
     *
     * @param {Boolean|MenuEx} [Options.ContextMenu = true] - If true, sets property
     * {@link TreeViewEx_Tab#ContextMenu} with an instance of {@link TreeViewEx_ContextMenu}. This
     * requires that file src\TreeViewEx_ContextMenu.ahk is included in the script, and requires
     * {@link https://github.com/Nich-Cebolla/AutoHotkey-MenuEx MenuEx}.
     *
     * Your code can also set `Options.ContextMenu` with an object that inherits from {@link MenuEx}
     * See the demo file test\demo-context-menu.ahk for an example context menu. The context
     * menu can be added to new {@link TreeViewEx} controls.
     *
     * Also see option {@link TreeViewEx_Tab.Prototype.Add~AddOptions.SetContextMenu} which is `true`
     * by default.
     *
     * @param {Object} [Options.DefaultPropsInfoTreeOptions] - An object with zero or more
     * options as property : value pairs. The options are for
     * {@link https://github.com/Nich-Cebolla/AutoHotkey-PropsInfoTree PropsInfoTree}. For more
     * information see {@link PropsInfoTree.Prototype.__New} and
     * {@link TreeViewEx_Tab.Prototype.SetDefaultPropsInfoTreeOptions}.
     *
     * @param {Object} [Options.DefaultUIATreeOptions] - An object with zero or more
     * options as property : value pairs. The options are for
     * {@link https://github.com/Nich-Cebolla/AutoHotkey-UIATree UIATree}. For more
     * information see {@link UIATree.Prototype.__New} and
     * {@link TreeViewEx_Tab.Prototype.SetDefaultUIATreeOptions}.
     *
     * @param {String} [Options.Name] - If set, the name assigned to the tab control.
     *
     * @param {Class} [Options.NodeClass] - If set, the node class that will be passed to
     * {@link TreeViewEx.Prototype.SetNodeConstructor}. By providing the node class with this option,
     * this enables the ability to make changes that effect all node objects associated with all
     * {@link TreeViewEx} objects associated with this {@link TreeViewEx_Tab}. This is done
     * through the {@link TreeViewEx_Tab#NodeConstructor} property, which is an instance of
     * {@link TreeViewEx_NodeConstructor}. You can use the {@link TreeViewEx_NodeConstructor}
     * instance methods to make changes to the prototype object from which all nodes associated
     * with this {@link TreeViewEx_Tab} inherit. These changes would not be seen on other node
     * objects or other {@link TreeViewEx} objects which are NOT associated with this {@link TreeViewEx_Tab}.
     *
     * Also see {@link TreeViewEx_Tab.Prototype.Add~AddOptions.SetNodeConstructor} which is `true`
     * by default.
     *
     * @param {String} [Options.Opt = "w100 h100"] - The options to pass to the first parameter
     * of {@link https://www.autohotkey.com/docs/v2/lib/Gui.htm#Add Gui.Prototype.Add} when creating
     * the tab control.
     *
     * @param {Boolean|MenuEx} [Options.PropsInfoTreeContextMenu = true] - If true, sets property
     * {@link TreeViewEx_Tab#PropsInfoTreeContextMenu} with an instance of
     * {@link PropsInfoTree_ContextMenu}. This is only relevant if you are using
     * {@link https://github.com/Nich-Cebolla/AutoHotkey-PropsInfoTree PropsInfoTree}. When a
     * {@link PropsInfoTree} instance is created by calling {@link TreeViewEx_Tab.Prototype.Add}, the
     * value {@link TreeViewEx_Tab#PropsInfoTreeContextMenu} is set to option
     * `PropsInfoTreeOptions.ContextMenu`.
     *
     * Your code can also set `Options.PropsInfoTreeContextMenu` with an object that inherits from
     * {@link MenuEx} to use that instead of {@link PropsInfoTree_ContextMenu}.
     *
     * @param {Boolean} [Options.SetPropsInfoTreeNodeConstructor = true] - If true, and if the
     * class {@link PropsInfoTree} exists, calls
     * {@link TreeViewEx_Tab.Prototype.SetPropsInfoTreeNodeConstructor} which defines
     * {@link TreeViewEx_Tab#PropsInfoTreeCollection_NodeConstructor} which is a collection of
     * {@link TreeViewEx_NodeConstructor} objects used by {@link PropsInfoTree} to construct
     * the various node objects. This enables the ability to make changes that are seen across
     * each of the {@link PropsInfoTree_Node} objects associated with this {@link TreeViewEx_Tab}
     * object. See the section "TreeViewEx_Tab" in README.md for more information.
     *
     * @param {Boolean} [Options.SetUIATreeNodeConstructor = true] - If true, and if the
     * class {@link UIATree} exists, calls
     * {@link TreeViewEx_Tab.Prototype.SetUIATreeNodeConstructor} which sets
     * {@link TreeViewEx_Tab#UIATree_NodeConstructor} with a {@link TreeViewEx_NodeConstructor}
     * object. When a {@link UIATree} instance is created by calling
     * {@link TreeViewEx_Tab.Prototype.Add}, the value {@link TreeViewEx_Tab#UIATree_NodeConstructor}
     * is assigned to option `UIATreeOptions.NodeClass`. This enables the ability to make changes that
     * are seen across each of the {@link UIATree_Node} objects associated with this
     * {@link TreeViewEx_Tab} object. See the section "TreeViewEx_Tab" in README.md for more information.
     *
     * @param {String[]} [Options.Tabs] - If set, an array of strings to pass to the third parameter
     * of {@link https://www.autohotkey.com/docs/v2/lib/Gui.htm#Add Gui.Prototype.Add} when creating
     * the tab control.
     *
     * @param {Boolean|MenuEx} [Options.UIATreeContextMenu = true] - If true, sets property
     * {@link TreeViewEx_Tab#UIATreeContextMenu} with an instance of
     * {@link UIATree_ContextMenu}. This is only relevant if you are using
     * {@link https://github.com/Nich-Cebolla/AutoHotkey-UIATree UIATree}. When a {@link UIATree}
     * instance is created by calling {@link TreeViewEx_Tab.Prototype.Add}, the value
     * {@link TreeViewEx_Tab#UIATreeContextMenu} is set to option `UIATreeOptions.ContextMenu`.
     *
     * Your code can also set `Options.UIATreeContextMenu` with an object that inherits from
     * {@link MenuEx} to use that instead of {@link UIATree_ContextMenu}.
     *
     * @param {String} [Options.Which = "Tab3"] - One of
     * {@link https://www.autohotkey.com/docs/v2/lib/GuiControls.htm#Tab_vs "Tab", "Tab2", or "Tab3"}.
     *
     * @param {Object} [DefaultAddOptions] - Options to use as the defaults when calling
     * {@link TreeViewEx_Tab.Prototype.Add}. See the parameter hint for
     * {@link TreeViewEx_Tab.Prototype.Add} for information about the options.
     *
     * @param {Object} [DefaultTreeViewExOptions] - An object with zero or more options as
     * property : value pairs. See the parameter hint for {@link TreeViewEx.Prototype.__New} for
     * information about the options.
     */
    __New(GuiObj, Options?, DefaultAddOptions := '', DefaultTreeViewExOptions := '') {
        this.Id := TreeViewEx_Tab.GetUid()
        TreeViewEx_Tab.Add(this)
        options := TreeViewEx_Tab.Options(Options ?? unset)
        this.Tab := TabEx(GuiObj, options.Which, options.Opt, options.Tabs || unset)
        this.HwndGui := GuiObj.Hwnd
        this.Collection := Container.CbString(TreeViewEx_Tab_CallbackValue_Name, , options.CaseSense ? 0 : LINGUISTIC_IGNORECASE)
        this.DefaultAddOptions := TreeViewEx_Tab.AddOptions(DefaultAddOptions)
        this.DefaultTreeViewExOptions := DefaultTreeViewExOptions
        this.Tab.TvexTab := this
        ObjRelease(ObjPtr(this))
        this.Tab.OnEvent('Change', TreeViewEx_Tab_OnChange)
        this.Tab.UseTab()
        this.ActiveControls := []
        this.CallbackAdd := options.CallbackAdd
        this.CallbackOnChangeBefore := options.CallbackOnChangeBefore
        this.CallbackOnChangeAfter := options.CallbackOnChangeAfter
        this.CallbackDelete := options.CallbackDelete
        if IsObject(options.ContextMenu) {
            this.ContextMenu := options.ContextMenu
        } else if options.ContextMenu && IsSet(TreeViewEx_ContextMenu) {
            this.ContextMenu := TreeViewEx_ContextMenu()
        }
        if options.Name {
            this.Tab.Name := options.Name
        }
        if options.NodeClass {
            this.SetNodeConstructor(options.NodeClass)
        }
        if IsSet(PropsInfoTree) {
            if options.PropsInfoTreeContextMenu {
                this.SetPropsInfoTreeContextMenu(IsObject(options.PropsInfoTreeContextMenu) ? options.PropsInfoTreeContextMenu : unset)
            }
            if options.DefaultPropsInfoTreeOptions {
                this.SetDefaultPropsInfoTreeOptions(options.DefaultPropsInfoTreeOptions, options.SetPropsInfoTreeNodeConstructor)
            } else if options.SetPropsInfoTreeNodeConstructor {
                this.SetDefaultPropsInfoTreeOptions()
            }
        }
        if IsSet(UIATree) {
            if options.UIATreeContextMenu {
                this.SetUIATreeContextMenu(IsObject(options.UIATreeContextMenu) ? options.UIATreeContextMenu : unset)
            }
            if options.DefaultUIATreeOptions {
                this.SetDefaultUIATreeOptions(options.DefaultUIATreeOptions,  options.SetUIATreeNodeConstructor)
            } else if options.SetUIATreeNodeConstructor {
                this.SetDefaultUIATreeOptions()
            }
        }
    }
    /**
     * Adds a {@link TreeViewEx} control to the gui, optionally creating a new tab. This returns
     * a {@link TreeViewEx_Tab.Item} object.
     *
     * If both `Options.CreateTab` and `Options.UseTab` are false, the currently active tab is used.
     * If there are no tabs, an error is thrown.
     *
     * @param {String} TvexName - The name to assign to the control.
     *
     * @param {Object} [AddOptions] - An object with zero or more options as property : value pairs.
     * The options passed to the {@link TreeViewEx_Tab.Prototype.__New~DefaultAddOptions DefaultAddOptions}
     * parameter of {@link TreeViewEx_Tab.Prototype.__New} are used as the base, and these `AddOptions`
     * supersede those.
     *
     * @param {Boolean} [AddOptions.Autosize = true] - If true, whenever the {@link TreeViewEx} control
     * is enabled, its dimensions are adjusted to maintain its position relative to the tab's borders.
     * For example, If another row of tabs is added / removed, the {@link TreeViewEx} control's height
     * is adjusted accordingly. If false, no resizing occurs. This option can be changed by calling
     * {@link TreeViewEx_Tab.Item.Prototype.SetAutosize}.
     *
     * @param {Boolean} [AddOptions.CopyActiveFont = true] - If true, whenever a control is added
     * using {@link TreeViewEx_Tab.Prototype.Add}, the font object from the first control in the arraay
     * {@link TreeViewEx_Tab#ActiveControls} is cloned and applied to the new control. This option
     * has no effect when the first control is added and when {@link TreeViewEx_Tab#ActiveControls}
     * is empty.
     *
     * @param {Integer|String} [AddOptions.CreateTab = true] - If a numeric 1, a new tab is created
     * using `TvexName` as the name. If a string, a new tab is created using `AddOptions.CreateTab`
     * as the name. If false, a new tab is not created.
     *
     * @param {Boolean} [AddOptions.FitTab = true] - If true, fits the {@link TreeViewEx} control
     * evenly in the center of the tab's client area with padding separating the {@link TreeViewEx}
     * control's edge with the tab's edge. The size of the padding is determined by the "MarginX"
     * and "MarginY" properties of the `Gui` object.
     *
     * @param {Boolean} [AddOptions.SetContextMenu = true] - If true, and if a value is set to
     * {@link TreeViewEx_Tab#ContextMenu} (usually by including it with
     * {@link TreeViewEx_Tab.Prototype.__New~Options.ContextMenu}), this calls
     * {@link TreeViewEx.Prototype.SetContextMenu}
     * passing {@link TreeViewEx_Tab#ContextMenu} as the argument. If false or if
     * {@link TreeViewEx_Tab#ContextMenu} is not set with a value, this does not occur.
     *
     * @param {Boolean} [AddOptions.SetNodeConstructor = true] - If true, and if a value is set to
     * {@link TreeViewEx_Tab#NodeConstructor} (usually by including it with
     * {@link TreeViewEx_Tab.Prototype.__New~Options.NodeClass}), this calls
     * {@link TreeViewEx.Prototype.SetNodeConstructor}
     * passing {@link TreeViewEx_Tab#NodeConstructor} as the argument. If false or if
     * {@link TreeViewEx_Tab#NodeConstructor} is not set with a value, this does not occur.
     *
     * @param {Integer|String} [AddOptions.UseTab] - If set, and if `AddOptions.CreateTab` is not in use,
     * the {@link TreeViewEx} control is associated with `AddOptions.UseTab`. `AddOptions.UseTab`
     * can be the tab index as a 1-based integer, or it can be the name of the tab. If
     * `AddOptions.CreateTab` is used, `AddOptions.UseTab` is ignored.
     *
     * @param {Boolean} [AddOptions.UseTabCaseSense = true] - If true, and if `AddOptions.UseTab`
     * is set with a string, case sensitivity is used when using the tab name to get the tab index.
     * If false, case sensitivity is not used. If `AddOptions.UseTab` is not set,
     * `AddOptions.UseTabCaseSense` is ignored.
     *
     * @param {Object} [TreeViewExOptions] - An object with zero or more options as
     * property : value pairs. See the parameter hint for {@link TreeViewEx.Prototype.__New} for
     * information about the options. The options passed to the
     * {@link TreeViewEx_Tab.Prototype.__New~DefaultTreeViewExOptions DefaultTreeViewExOptions}
     * parameter of {@link TreeViewEx_Tab.Prototype.__New} are used as the base, and these
     * `TreeViewExOptions` supersede those.
     *
     * @param {*} [ConstructorParams] - Any additional parameters to pass to the tree-view object's
     * constructor.
     * - If `AddOptions.TreeViewClass` is {@link TreeViewEx}, `ConstructorParams` is ignored.
     * - If `AddOptions.TreeViewClass` is {@link PropsInfoTree}, `ConstructorParams` is assumed
     *   to be the value to pass to the parameter `PropsInfoTreeParams`. If
     *   {@link TreeViewEx_Tab.Prototype.SetDefaultPropsInfoTreeOptions} has been called, the base
     *   of `ConstructorParams` is set to {@link TreeViewEx_Tab#DefaultPropsInfoTreeOptions} before calling
     *   {@link PropsInfoTree.Prototype.__New}.
     * - If `AddOptions.TreeViewClass` is {@link UIATree}, `ConstructorParams` is assumed
     *   to be the value to pass to the parameter `UIATreeParams`. If
     *   {@link TreeViewEx_Tab.Prototype.SetDefaultUIATreeOptions} has been called, the base
     *   of `ConstructorParams` is set to {@link TreeViewEx_Tab#DefaultUIATreeOptions} before calling
     *   {@link UIATree.Prototype.__New}.
     * - If `AddOptions.TreeViewClass` is another class, and if `ConstructorParams` is an array,
     *   and if `AddOptions.TreeViewClass.Prototype.__New.MaxParams > 4`,
     *   the variadic operator ( * ) will be applied to the value when calling the constructor.
     *   In other cases, the value is passed as-is.
     *
     * @returns {TreeViewEx_Tab.Item} - The {@link TreeViewEx_Tab.Item} object. The control is on
     * property {@link TreeViewEx_Tab.Item#tvex}.
     */
    Add(TvexName, AddOptions?, TreeViewExOptions?, ConstructorParams?) {
        tvexOptions := { Name: TvexName }
        if IsSet(TreeViewExOptions) {
            if this.DefaultTreeViewExOptions {
                ObjSetBase(TreeViewExOptions, this.DefaultTreeViewExOptions)
            }
            ObjSetBase(tvexOptions, TreeViewExOptions)
        } else if this.DefaultTreeViewExOptions {
            ObjSetBase(tvexOptions, this.DefaultTreeViewExOptions)
        }
        if HasProp(tvexOptions, 'Style') {
            if tvexOptions.Style & WS_CLIPSIBLINGS {
                throw ValueError('The TreeViewEx options cannot have the WS_CLIPSIBLINGS style flag.')
            }
        } else {
            tvexOptions.Style := TreeViewEx.Options.Default.Style & ~WS_CLIPSIBLINGS
        }
        if IsSet(AddOptions) {
            if this.DefaultAddOptions {
                ObjSetBase(AddOptions, this.DefaultAddOptions)
            } else {
                addOptions := TreeViewEx_Tab.AddOptions(AddOptions)
            }
        } else if this.DefaultAddOptions {
            addOptions := this.DefaultAddOptions
        } else {
            addOptions := TreeViewEx_Tab.AddOptions()
        }
        tab := this.Tab
        if addOptions.CreateTab {
            tab.Add([addOptions.CreateTab == 1 ? TvexName : addOptions.CreateTab])
            tabValue := tab.GetItemCount()
        } else if addOptions.UseTab {
            if addOptions.UseTab is Integer {
                tabValue := addOptions.UseTab
            } else {
                tabValue := tab.FindTab(addOptions.UseTab, , , addOptions.UseTabCaseSense)
                if !tabValue {
                    throw ValueError('Tab not found.', , addOptions.UseTab)
                }
            }
        } else if tab.Value {
            tabValue := tab.Value
        } else {
            throw Error('Unable to create the TreeViewEx control because no tabs currently exist.')
        }
        ; If the new control will be added to the active tab
        if tabValue = tab.Value {
            if tvexOptions.Style & WS_DISABLED {
                tvexOptions.Style := tvexOptions.Style & ~WS_DISABLED
            }
            if !(tvexOptions.Style & WS_VISIBLE) {
                tvexOptions.Style := tvexOptions.Style | WS_VISIBLE
            }
        } else {
            if !(tvexOptions.Style & WS_DISABLED) {
                tvexOptions.Style := tvexOptions.Style | WS_DISABLED
            }
            if tvexOptions.Style & WS_VISIBLE {
                tvexOptions.Style := tvexOptions.Style & ~WS_VISIBLE
            }
        }
        g := this.Gui
        if addOptions.FitTab {
            rc := tab.GetClientDisplayRect()
            tvexOptions.Width := rc.W - g.MarginX * 2
            tvexOptions.Height := rc.H - g.MarginY * 2
            tvexOptions.X := rc.L + g.MarginX
            tvexOptions.Y := rc.T + g.MarginY
        }
        cls := addOptions.TreeViewClass
        switch cls.Prototype.__Class, 0 {
            case 'PropsInfoTree':
                if !IsSet(ConstructorParams) {
                    ConstructorParams := {}
                }
                if this.DefaultPropsInfoTreeOptions {
                    ObjSetBase(ConstructorParams, this.DefaultPropsInfoTreeOptions)
                }
                if this.PropsInfoTreeContextMenu {
                    ConstructorParams.ContextMenu := this.PropsInfoTreeContextMenu
                }
                tvex := cls(g, tvexOptions, ConstructorParams)
            case 'TreeViewEx':
                tvex := cls(g, tvexOptions)
                if addOptions.SetContextMenu && this.ContextMenu {
                    tvex.SetContextMenu(this.ContextMenu)
                }
                if addOptions.SetNodeConstructor && IsObject(this.NodeConstructor) {
                    tvex.SetNodeConstructor(this.NodeConstructor)
                }
            case 'UIATree':
                if !IsSet(ConstructorParams) {
                    ConstructorParams := {}
                }
                if this.DefaultUIATreeOptions {
                    ObjSetBase(ConstructorParams, this.DefaultUIATreeOptions)
                }
                if this.UIATreeContextMenu {
                    ConstructorParams.ContextMenu := this.UIATreeContextMenu
                }
                tvex := cls(g, tvexOptions, ConstructorParams)

                if this.DefaultUIATreeOptions {
                    if !IsSet(ConstructorParams) {
                        ConstructorParams := {}
                    }
                    ObjSetBase(ConstructorParams, this.DefaultUIATreeOptions)
                }
                tvex := cls(g, tvexOptions, ConstructorParams ?? unset)
            default:
                if IsSet(ConstructorParams) {
                    if ConstructorParams is Array && cls.Prototype.__New.MaxParams > 4 {
                        tvex := cls(g, tvexOptions, ConstructorParams*)
                    } else {
                        tvex := cls(g, tvexOptions, ConstructorParams)
                    }
                } else {
                    tvex := cls(g, tvexOptions)
                }
        }
        item := TreeViewEx_Tab.Item(tvex, tab, tabValue, addOptions.Autosize)
        item.tvex.SetTvexTabId(this.Id)
        if this.ActiveControls.Length && addOptions.CopyActiveFont {
            lfNew := item.tvex.GetFont()
            this.ActiveControls[1].tvex.GetFont().Clone(lfNew, , false)
            lfNew.Apply()
        }
        if tabValue = tab.Value {
            this.ActiveControls.Push(item)
            if !DllCall(
                g_user32_SetWindowPos
              , 'ptr', tvex.Hwnd
              , 'ptr', tab.Hwnd
              , 'int', 0, 'int', 0, 'int', 0, 'int', 0
              , 'uint', SWP_SHOWWINDOW | SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE
              , 'int'
            ) {
                throw OSError()
            }
            tvex.Redraw()
        } else {
            item.Disable()
        }
        this.Collection.Insert(item)
        if IsObject(this.CallbackAdd) {
            this.CallbackAdd.Call(tvex, this)
        }
        return item
    }
    /**
     * Deletes a tab and any {@link TreeViewEx} controls associated with it.
     * @param {Integer|String} Value - Either the string name of the tab, or the integer tab index
     * (1-based) of the tab.
     * @param {Boolean} [ValueIsName = true] - If true, `Value` is the name. If false, `Value` is
     * the index.
     * @param {Boolean} [CaseSense = true] - If true, and if `ValueIsName` is true, case sensitivity
     * is used when using the name to get the tab index. If false, case sensitivity is not used.
     * If `ValueIsName` is false, `CaseSense` is ignored.
     */
    DeleteTab(Value, ValueIsName := true, CaseSense := true) {
        tab := this.Tab
        if ValueIsName {
            tabValue := tab.FindTab(Value, , , CaseSense)
        } else {
            tabValue := Value
        }
        if !tabValue {
            throw ValueError('Tab not found.')
        }
        flag_isLastTab := tabValue = tab.GetItemCount()
        flag_isCurrentTab := tabValue = tab.Value
        collection := this.Collection
        list := []
        i := 0
        if callbackDelete := this.CallbackDelete {
            loop collection.Length {
                item := collection[++i]
                if tabValue = item.tabValue {
                    list.Push(item)
                    collection.RemoveAt(i--)
                    callbackDelete(item, flag_isCurrentTab, flag_isLastTab, this)
                } else if item.tabValue > tabValue {
                    item.tabValue--
                }
            }
        } else {
            loop collection.Length {
                item := collection[++i]
                if tabValue = item.tabValue {
                    list.Push(item)
                    collection.RemoveAt(i--)
                    item.tvex.Dispose()
                } else if item.tabValue > tabValue {
                    item.tabValue--
                }
            }
        }
        tab.Delete(tabValue)
        if flag_isCurrentTab {
            this.ActiveControls.Length := 0
            if flag_isLastTab {
                if tab.GetItemCount() {
                    tab.Value := tabValue - 1
                }
            } else {
                tab.Value := tabValue
            }
        }
        TreeViewEx_Tab_OnChange(tab)
        return list
    }
    /**
     * Deletes a {@link TreeViewEx} control but does not delete the tab it is associated with.
     * @param {String} TvexName - The name of the control.
     * @returns {TreeViewEx_Tab.Item} - The deleted item. The control is on property
     * {@link TreeViewEx_Tab.Item#tvex}.
     */
    DeleteTreeViewEx(TvexName) {
        this.Collection.Remove(TvexName, &item)
        item.tvex.Dispose()
        if item.tabValue = this.Tab.Value {
            active := this.ActiveControls
            if active.Length == 1 {
                item := active[1]
                active.Length := 0
                return item
            } else {
                for _item in active {
                    if item == _item {
                        active.RemoveAt(A_Index)
                        return item
                    }
                }
            }
        }
    }
    Dispose() {
        TreeViewEx_Tab.Delete(this.Id)
        props := []
        props.Capacity := ObjOwnPropCount(this)
        for prop in this.OwnProps() {
            props.Push(prop)
        }
        for prop in props {
            this.DeleteProp(prop)
        }
    }
    /**
     * Gets a {@link TreeViewEx_Tab.Item} object using the name.
     * @param {String} Name - The name associated with the item.
     * @returns {TreeViewEx_Tab.Item}
     */
    Get(Name) => this.Collection.GetValue(Name)
    /**
     * Returns the array index of the item if an item associated with the name exists in the
     * collection. Else, returns 0.
     * @param {String} Name - The name associated with the item.
     * @returns {Integer}
     */
    Has(Name) => this.Collection.Find(Name)
    /**
     * {@link TreeViewEx_Tab} has built-in support for
     * {@link https://github.com/Nich-Cebolla/AutoHotkey-PropsInfoTree}. {@link PropsInfoTree} has its
     * own set of options. By calling {@link TreeViewEx_Tab.Prototype.SetDefaultPropsInfoTreeOptions},
     * you define an options object that will be used for all instances of {@link PropsInfoTree}
     * associated with this {@link TreeViewEx_Tab} object.
     *
     * The object is set to property {@link TreeViewEx_Tab#PropsInfoTreeOptions}. You can change the
     * values of that object and the change will be seen by all instances of
     * {@link PropsInfoTree} associated with this {@link TreeViewEx_Tab} object unless an individual
     * instance overrides the option with a value on its own options object. You can access the
     * individual options objects from the {@link PropsInfoTree#PropsInfoTreeOptions} property.
     *
     * If parameter `PrepareNodeConstructor` is true, this function will do the following:
     * - Call {@link TreeViewEx_Tab.Prototype.SetPropsInfoTreeNodeConstructor}.
     * - Set `PropsInfoTreeOptions.CallbackSetNodeConstructor` with
     * {@link TreeViewEx_Tab_Pit_CallbackSetNodeConstructor}, binding the collection to the first parameter.
     * - Set `PropsInfoTreeOptions.NodeClass` with {@link TreeViewEx_Tab#PropsInfoTree_NodeConstructor}.
     *
     * This makes it possible to make changes to all node objects of a specific type associated with
     * this {@link TreeViewEx_Tab}. For example, to change the text that is displayed for tree-view
     * items associated with {@link PropsInfoTree_Node_Object} nodes:
     * @example
     * tvexTab := TreeViewEx_Tab()
     * tvexTab.SetDefaultPropsInfoTreeOptions()
     * constructor := tvexTab.PropsInfoTreeCollection_NodeConstructor.Get('Object')
     * prototype := constructor.Prototype
     * MyCustomLabelFunc(Node) {
     *     ; custom logic
     * }
     * prototype.DefineProp('Label', { Get: MyCustomLabelFunc })
     * @
     *
     * @param {Object} [PropsInfoTreeOptions] - The default options to pass to
     * {@link PropsInfoTree.Prototype.__New~PropsInfoTreeOptions}.
     *
     * @param {Boolean} [PrepareNodeConstructor = true] - If true, prepares the options
     * `PropsInfoTreeOptions.CallbackSetNodeConstructor` and `PropsInfoTreeOptions.NodeClass` as
     * described in the description of this method. `PrepareNodeConstructor` should be left true
     * to make it possible to make changes to the node objects' collective behavior.
     */
    SetDefaultPropsInfoTreeOptions(PropsInfoTreeOptions?, PrepareNodeConstructor := true) {
        if PrepareNodeConstructor {
            if !IsSet(PropsInfoTreeOptions) {
                PropsInfoTreeOptions := {}
            }
            this.SetPropsInfoTreeNodeConstructor(HasProp(PropsInfoTreeOptions, 'NodeClass') ? PropsInfoTreeOptions.NodeClass : unset)
            PropsInfoTreeOptions.CallbackSetNodeConstructor := TreeViewEx_Tab_Pit_CallbackSetNodeConstructor.Bind(this.PropsInfoTreeCollection_NodeConstructor)
            PropsInfoTreeOptions.NodeClass := this.PropsInfoTree_NodeConstructor
        }
        this.DefaultPropsInfoTreeOptions := PropsInfoTreeOptions ?? {}
    }
    /**
     * {@link TreeViewEx_Tab} has built-in support for
     * {@link https://github.com/Nich-Cebolla/AutoHotkey-UIATree}. {@link UIATree} has its own
     * set of options. By calling {@link TreeViewEx_Tab.Prototype.SetDefaultUIATreeOptions}, you
     * define an options object that will be used for all instances of {@link UIATree} associated
     * with this {@link TreeViewEx_Tab} object.
     *
     * The object is set to property {@link TreeViewEx_Tab#UIATreeOptions}. You can change the
     * values of that object and the change will be seen by all instances of
     * {@link UIATree} associated with this {@link TreeViewEx_Tab} object unless an individual
     * instance overrides the option with a value on its own options object. You can access the
     * individual options objects from the {@link UIATree#UIATreeOptions} property.
     *
     * @param {Object} [UIATreeOptions] - The default options to pass to
     * {@link UIATree.Prototype.__New~UIATreeOptions}.
     *
     * @param {Boolean} [PrepareNodeConstructor = true] - If true, prepares the options
     * `UIATreeOptions.NodeClass` as described in the description of this method.
     * `PrepareNodeConstructor` should be left true to make it possible to make changes to the node
     * objects' collective behavior.
     */
    SetDefaultUIATreeOptions(UIATreeOptions?, PrepareNodeConstructor := true) {
        if PrepareNodeConstructor {
            if !IsSet(UIATreeOptions) {
                UIATreeOptions := {}
            }
            this.SetUIATreeNodeConstructor(HasProp(UIATreeOptions, 'NodeClass') ? UIATreeOptions.NodeClass : unset)
            UIATreeOptions.NodeClass := this.UIATree_NodeConstructor
        }
        this.DefaultUIATreeOptions := UIATreeOptions ?? {}
    }
    SetNodeConstructor(NodeClass) {
        this.NodeConstructor := TreeViewEx_NodeConstructor()
        this.NodeConstructor.Prototype := { __Class: NodeClass.Prototype.__Class }
        ObjSetBase(this.NodeConstructor.Prototype, NodeClass.Prototype)
    }
    SetPropsInfoTreeNodeConstructor(NodeClass?) {
        if IsSet(PropsInfoTree_Node) && IsSet(PropsInfoTree) {
            if !IsSet(NodeClass) {
                NodeClass := PropsInfoTree_Node
            }
            /**
             * A collection of {@link TreeViewEx_NodeConstructor} objects.
             * @memberof TreeViewEx_Tab
             * @instance
             * @type {PropsInfoTreeCollection_NodeConstructor}
             */
            this.PropsInfoTreeCollection_NodeConstructor := PropsInfoTreeCollection_NodeConstructor()
            collectionNodeConstructor := this.PropsInfoTreeCollection_NodeConstructor
            /**
             * @memberof TreeViewEx_Tab
             * @instance
             * @type {TreeViewEx_NodeConstructor}
             */
            this.PropsInfoTree_NodeConstructor := TreeViewEx_NodeConstructor()
            collectionNodeConstructor.Primary := this.PropsInfoTree_NodeConstructor
            primaryProto := this.PropsInfoTree_NodeConstructor.Prototype := { __Class: NodeClass.Prototype.__Class }
            ObjSetBase(primaryProto, NodeClass.Prototype)
            inheritsFrom := Map()
            for obj in PropsInfoTree.NodeTypes {
                ; Each of these individual constructor properties can be used to make changes that affect
                ; just the relevant nodes associated with this PropsInfoTree object. These are also used
                ; to construct new node objects.
                constructor := TreeViewEx_NodeConstructor()
                collectionNodeConstructor.Set(obj.Name, constructor)
                proto := obj.Class.Prototype
                _proto := constructor.Prototype := { }
                for prop in proto.OwnProps() {
                    _proto.DefineProp(prop, proto.GetOwnPropDesc(prop))
                }
                baseName := proto.Base.__Class
                if !inheritsFrom.Has(baseName) {
                    inheritsFrom.Set(baseName, [])
                }
                inheritsFrom.Get(baseName).Push(constructor)
            }
            for baseName, list in inheritsFrom {
                if baseName = primaryProto.__Class {
                    for constructor in list {
                        ObjSetBase(constructor.Prototype, primaryProto)
                    }
                } else {
                    proto := collectionNodeConstructor.Get(SubStr(baseName, InStr(baseName, '_', , , -1) + 1)).Prototype
                    for constructor in list {
                        ObjSetBase(constructor.Prototype, proto)
                    }
                }
            }
        } else {
            throw Error('PropsInfoTree.ahk must be included in the script to use this method.')
        }
    }
    SetPropsInfoTreeContextMenu(MenuExObj?) {
        if IsSet(MenuExObj) {
            this.PropsInfoTreeContextMenu := MenuExObj
        } else if IsSet(PropsInfoTree_ContextMenu) {
            this.PropsInfoTreeContextMenu := PropsInfoTree_ContextMenu()
        } else {
            throw Error('PropsInfoTree_ContextMenu.ahk must be included in the script to use this method.', , A_ThisFunc)
        }
    }
    SetUIATreeNodeConstructor(NodeClass?) {
        if IsSet(UIATree_Node) {
            if !IsSet(NodeClass) {
                NodeClass := UIATree_Node
            }
            this.UIATree_NodeConstructor := TreeViewEx_NodeConstructor()
            this.UIATree_NodeConstructor.Prototype := { __Class: NodeClass.Prototype.__Class }
            ObjSetBase(this.UIATree_NodeConstructor.Prototype, NodeClass.Prototype)
        } else {
            throw Error('UIATree.ahk must be included in the script to use this method.', , A_ThisFunc)
        }
    }
    SetUIATreeContextMenu(MenuExObj?) {
        if IsSet(MenuExObj) {
            this.UIATreeContextMenu := MenuExObj
        } else if IsSet(UIATree_ContextMenu) {
            this.UIATreeContextMenu := UIATree_ContextMenu()
        } else {
            throw Error('UIATree_ContextMenu.ahk must be included in the script to use this method.', , A_ThisFunc)
        }
    }
    __Delete() {
        if this.HasOwnProp('Tab') && this.Tab.HasOwnProp('TvexTab') && this = this.Tab.TvexTab {
            ObjPtrAddRef(this)
            this.Tab.DeleteProp('TvexTab')
            this.DeleteProp('Tab')
        }
    }
    __Enum(VarCount) => this.Collection.__Enum(VarCount)

    Gui => GuiFromHwnd(this.HwndGui)
    Name => this.Tab.Name

    class AddOptions {
        static Default := {
            Autosize: true
          , CopyActiveFont: true
          , CreateTab: true
          , FitTab: true
          , SetContextMenu: true
          , SetNodeConstructor: true
          , TreeViewClass: TreeViewEx
          , UseTab: ''
          , UseTabCaseSense: true
        }
        static Call(Options?) {
            if IsSet(Options) {
                o := {}
                d := this.Default
                for prop in d.OwnProps() {
                    o.%prop% := HasProp(Options, prop) ? Options.%prop% : d.%prop%
                }
            } else {
                o := this.Default.Clone()
            }
            return o
        }
    }
    class Item {
        __New(tvex, tab, tabValue, autosize) {
            this.HwndTvex := tvex.Hwnd
            this.tabValue := tabValue
            this.HwndTab := tab.Hwnd
            this.SetAutosize(autosize)
        }
        Disable() {
            this.tvex.SetStatus(false)
        }
        Enable(rc?) {
            if !IsSet(rc) {
                rc := this.Tab.GetClientDisplayRect()
            }
            tvex := this.tvex
            if this.autosize {
                ; If autosize is true, ensure the control's position is consistent relative to the tab's borders.
                diff := this.diff
                WinMove(rc.L + diff.L, rc.T + diff.T, rc.W + diff.W, rc.H + diff.H, tvex.Hwnd)
            }
            ; Display the control
            tvex.SetStatus(true)
            if !DllCall(
                g_user32_SetWindowPos
              , 'ptr', this.HwndTvex
              , 'ptr', this.HwndTab
              , 'int', 0, 'int', 0, 'int', 0, 'int', 0
              , 'uint', SWP_SHOWWINDOW | SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE
              , 'int'
            ) {
                throw OSError()
            }
            tvex.Redraw()
        }
        SetAutosize(Value) {
            if this.__autosize := Value {
                tvex := this.tvex
                tvex.GetPos(&x, &y, &w, &h)
                rc := this.Tab.GetClientDisplayRect()
                this.diff := {
                    L: x - rc.L
                  , T: y - rc.T
                  , W: w - rc.W
                  , H: h - rc.H
                }
            } else {
                this.diff := ''
            }
        }
        Autosize {
            Get => this.__autosize
            Set => this.SetAutosize(Value)
        }
        Name => this.tvex.Name
        Tab => GuiCtrlFromHwnd(this.HwndTab)
        Tvex => TreeViewEx.Get(this.HwndTvex)
    }
    class Options {
        static Default := {
            CallbackAdd: ''
          , CallbackDelete: ''
          , CallbackOnChangeBefore: ''
          , CallbackOnChangeAfter: ''
          , CaseSense: false
          , ContextMenu: true
          , DefaultPropsInfoTreeOptions: ''
          , DefaultUIATreeOptions: ''
          , Name: ''
          , NodeClass: ''
          , Opt: 'w100 h100'
          , PropsInfoTreeContextMenu: true
          , SetPropsInfoTreeNodeConstructor: true
          , SetUIATreeNodeConstructor: true
          , Tabs: ''
          , UIATreeContextMenu: true
          , Which: 'Tab3'
        }
        static Call(Options?) {
            if IsSet(Options) {
                o := {}
                d := this.Default
                for prop in d.OwnProps() {
                    o.%prop% := HasProp(Options, prop) ? Options.%prop% : d.%prop%
                }
            } else {
                o := this.Default.Clone()
            }
            return o
        }
    }
}

TreeViewEx_Tab_CallbackValue_Name(item) {
    return item.tvex.name
}
TreeViewEx_Tab_OnChange(tab, *) {
    tvexTab := tab.tvexTab
    formerActive := tvexTab.ActiveControls
    tabValue := tab.Value
    ActiveControls := tvexTab.ActiveControls := []
    for item in tvexTab.Collection {
        if tabValue = item.tabValue {
            ActiveControls.Push(item)
        }
    }
    if tvexTab.CallbackOnChangeBefore {
        tvexTab.CallbackOnChangeBefore.Call(tvexTab, formerActive, ActiveControls)
    }
    for item in formerActive {
        item.Disable()
    }
    if !ActiveControls.Length {
        return
    }
    rc := tab.GetClientDisplayRect()
    g := tab.Gui
    for item in ActiveControls {
        item.Enable(rc)
    }
    if tvexTab.CallbackOnChangeAfter {
        tvexTab.CallbackOnChangeAfter.Call(tvexTab, formerActive, ActiveControls)
    }
}
TreeViewEx_Tab_Pit_CallbackSetNodeConstructor(collection, PropsInfoTreeObj, PropsInfoTreeOptions) {
    ObjSetBase(PropsInfoTreeObj.NodeConstructor.Prototype, collection.Primary.Prototype)
    for name, constructor in collection {
        _constructor := PropsInfoTreeObj.NodeConstructor_%name% := TreeViewEx_NodeConstructor()
        _constructor.Prototype := { PropsInfoTreeOptions: PropsInfoTreeOptions, HwndCtrl: PropsInfoTreeObj.Hwnd, __Class: constructor.Prototype.__Class }
        ObjSetBase(_constructor.Prototype, constructor.Prototype)
    }
}

class TreeViewExTabCollection extends Map {
    __New(items*) {
        this.CaseSense := false
        if items.Length {
            this.Set(items*)
        }
    }
}
