
#include <TreeViewEx>
; https://github.com/Nich-Cebolla/AutoHotkey-TabEx
#include <TabEx>


class TreeViewEx_Tab {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.NodeConstructor := ''
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
     * @param {*} [Options.Callback] - If set, a `Func` or callable object that is called for every
     * new {@link TreeViewEx} control. The function can have up to two parameters.
     * 1. The new {@link TreeViewEx} control.
     * 2. The {@link TreeViewEx_Tab} object.
     *
     * The return value is ignored.
     *
     * @param {Boolean} [Options.CaseSense = false] - If true, any operations using the `TvexName`
     * value (first parameter of {@link TreeViewEx_Tab.Prototype.Add}) are performed using case
     * sensitivity. If false, they are performed without case sensitivity.
     *
     * @param {MenuEx} [Options.ContextMenu] - If set, an object that inherits from {@link MenuEx}.
     * See the demo file test\demo-context-menu.ahk for an example context menu. The context
     * menu can be added to new {@link TreeViewEx} controls. Also see option
     * {@link TreeViewEx_Tab.Prototype.Add~AddOptions.SetContextMenu} which is `true` by default.
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
     * @param {String[]} [Options.Tabs] - If set, an array of strings to pass to the third parameter
     * of {@link https://www.autohotkey.com/docs/v2/lib/Gui.htm#Add Gui.Prototype.Add} when creating
     * the tab control.
     *
     * @param {String} [Options.Which = "Tab3"] - One of {@link https://www.autohotkey.com/docs/v2/lib/GuiControls.htm#Tab_vs "Tab", "Tab2", or "Tab3"}.
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
        options := TreeViewEx_Tab.Options(Options ?? unset)
        this.Tab := TabEx(GuiObj, options.Which, options.Opt, options.Tabs || unset)
        this.HwndGui := GuiObj.Hwnd
        if options.Name {
            this.Tab.Name := options.Name
        }
        this.Collection := Container.CbString(TreeViewEx_Tab_CallbackValue_Name, , options.CaseSense ? 0 : LINGUISTIC_IGNORECASE)
        this.ContextMenu := options.ContextMenu
        this.DefaultAddOptions := TreeViewEx_Tab.AddOptions(DefaultAddOptions)
        this.DefaultTreeViewExOptions := DefaultTreeViewExOptions
        this.Callback := options.Callback
        this.Tab.TvexTab := this
        ObjRelease(ObjPtr(this))
        this.Tab.OnEvent('Change', TreeViewEx_Tab_OnChange)
        this.Tab.UseTab()
        this.ActiveControls := []
        if options.NodeClass {
            this.SetNodeConstructor(options.NodeClass)
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
     * @param {Boolean} [AddOptions.Autosize = true] - If true, whenever the {@link TreeViewEx} control is
     * enabled its dimensions are adjusted to maintain its position relative to the tab's borders.
     * For example, If another row of tabs is added / removed, the {@link TreeViewEx} control's height
     * is adjusted accordingly. If false, no resizing occurs. This option can be changed by calling
     * {@link TreeViewEx_Tab.Item.Prototype.SetAutosize}.
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
     * @param {Object} [TreeViewExOptions] -  An object with zero or more options as
     * property : value pairs. See the parameter hint for {@link TreeViewEx.Prototype.__New} for
     * information about the options. The options passed to the
     * {@link TreeViewEx_Tab.Prototype.__New~DefaultTreeViewExOptions DefaultTreeViewExOptions}
     * parameter of {@link TreeViewEx_Tab.Prototype.__New} are used as the base, and these
     * `TreeViewExOptions` supersede those.
     *
     * @returns {TreeViewEx_Tab.Item} - The {@link TreeViewEx_Tab.Item} object. The control is on
     * property {@link TreeViewEx_Tab.Item#tvex}.
     */
    Add(TvexName, AddOptions?, TreeViewExOptions?) {
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
        if tabValue == tab.Value {
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
        tvex := TreeViewEx(g, tvexOptions)
        item := TreeViewEx_Tab.Item(tvex, tab, tabValue, addOptions.Autosize)
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
            for item in this.ActiveControls {
                item.Enable()
            }
        }
        this.Collection.Insert(item)
        if addOptions.SetContextMenu && this.ContextMenu {
            tvex.SetContextMenu(this.ContextMenu)
        }
        if addOptions.SetNodeConstructor && IsObject(this.NodeConstructor) {
            tvex.SetNodeConstructor(this.NodeConstructor)
        }
        if IsObject(this.Callback) {
            this.Callback.Call(tvex, this)
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
            Value := tab.FindTab(Value, , , CaseSense)
        }
        if !Value {
            throw ValueError('Tab not found.')
        }
        collection := this.Collection
        list := []
        i := 0
        loop collection.Length {
            item := collection[++i]
            if Value = item.tabValue {
                list.Push(item)
                collection.RemoveAt(i--)
                item.tvex.Dispose()
            } else if item.tabValue > Value {
                item.tabValue--
            }
        }
        if Value = tab.Value {
            if Value = 1 {
                if tab.GetItemCount() = 1 {
                    this.ActiveControls.Length := 0
                } else {
                    tab.Value := 2
                }
            } else {
                tab.Value := 1
            }
        }
        tab.Delete(Value)
        TreeViewEx_Tab_OnChange(tab)
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
                active.Length := 0
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
    SetNodeConstructor(NodeClass) {
        this.NodeConstructor := TreeViewEx_NodeConstructor()
        this.NodeConstructor.Prototype := { __Class: NodeClass.Prototype.__Class }
        ObjSetBase(this.NodeConstructor.Prototype, NodeClass.Prototype)
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
          , CreateTab: true
          , FitTab: true
          , SetContextMenu: true
          , SetNodeConstructor: true
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
            this.tvex := tvex
            this.tabValue := tabValue
            this.hwndTab := tab.Hwnd
            this.SetAutosize(autosize)
        }
        Disable() {
            this.tvex.Enabled := this.tvex.Visible := 0
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
            tvex.Enabled := 1
            if !DllCall(
                g_user32_SetWindowPos
              , 'ptr', tvex.Hwnd
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
        Tab => GuiCtrlFromHwnd(this.hwndTab)
    }
    class Options {
        static Default := {
            Callback: ''
          , CaseSense: false
          , ContextMenu: ''
          , Name: ''
          , NodeClass: ''
          , Opt: 'w100 h100'
          , Tabs: ''
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
    for item in tvexTab.ActiveControls {
        item.Disable()
    }
    n := tab.Value
    list := tvexTab.ActiveControls
    list.Length := 0
    for item in tvexTab.Collection {
        if n = item.tabValue {
            list.Push(item)
        }
    }
    if !list.Length {
        return
    }
    rc := tab.GetClientDisplayRect()
    g := tab.Gui
    for item in list {
        item.Enable(rc)
    }
}
