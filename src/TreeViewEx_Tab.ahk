
#include <TreeViewEx>
; https://github.com/Nich-Cebolla/AutoHotkey-TabEx
#include <TabEx>


class TreeViewEx_Tab {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
    }
    __New(GuiObj, Options?, DefaultAddOptions := '', DefaultTreeViewExOptions := '') {
        options := TreeViewEx_Tab.Options(Options ?? unset)
        this.Tab := TabEx(GuiObj, options.Which, options.Opt, options.Text || unset)
        this.HwndGui := GuiObj.Hwnd
        if options.Name {
            this.Tab.Name := options.Name
        }
        this.Collection := Container.CbString(TreeViewEx_Tab_CallbackValue_Name, , options.CaseSense ? 0 : LINGUISTIC_IGNORECASE)
        this.ContextMenu := options.ContextMenu
        this.DefaultAddOptions := DefaultAddOptions
        this.DefaultTreeViewExOptions := DefaultTreeViewExOptions
        this.Callback := options.Callback
        this.Tab.TvexTab := this
        ObjRelease(ObjPtr(this))
        this.Tab.OnEvent('Change', TreeViewEx_Tab_OnChange)
        this.ActiveControls := []
    }
    Add(TvexName, Options?, TreeViewExOptions?) {
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
                throw ValueError('The TreeViewEx options cannot have WS_CLIPSIBLINGS style flag.')
            }
        } else {
            tvexOptions.Style := TreeViewEx.Options.Default.Style & ~WS_CLIPSIBLINGS
        }
        if IsSet(Options) {
            if this.DefaultAddOptions {
                ObjSetBase(Options, this.DefaultAddOptions)
            }
            options := TreeViewEx_Tab.AddOptions(Options)
        } else if this.DefaultAddOptions {
            options := TreeViewEx_Tab.AddOptions(this.DefaultAddOptions)
        } else {
            options := TreeViewEx_Tab.AddOptions()
        }
        tab := this.Tab
        if options.CreateTab {
            tab.Add([TvexName])
            tabValue := tab.GetItemCount()
        } else if options.UseTab {
            if options.UseTab is Number {
                tabValue := options.UseTab
            } else {
                tabValue := tab.FindTab(options.UseTab, , , options.UseTabCaseSense)
                if !tabValue {
                    throw ValueError('Tab not found.', , options.UseTab)
                }
            }
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
        if options.FitTab {
            rc := tab.GetClientDisplayRect()
            tvexOptions.Width := rc.W - g.MarginX * 2
            tvexOptions.Height := rc.H - g.MarginY * 2
            tvexOptions.X := rc.L + g.MarginX
            tvexOptions.Y := rc.T + g.MarginY
        }
        tvex := TreeViewEx(g, tvexOptions)
        item := TreeViewEx_Tab.Item(tvex, tab, tabValue, options.Autosize, options.FitTab)
        if tabValue = tab.Value {
            this.ActiveControls.Push(item)
            if !DllCall(
                g_user32_SetWindowPos
              , 'ptr', tvex.Hwnd
              , 'ptr', tab.Hwnd
              , 'int', 0, 'int', 0, 'int', 0, 'int', 0
              , 'uint', SWP_SHOWWINDOW | SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE | SWP_NOCOPYBITS
              , 'int'
            ) {
                throw OSError()
            }
            tvex.Redraw()
        } else {
            for item in this.ActiveControls {
                item.tvex.Redraw()
            }
        }
        this.Collection.Insert(item)
        if options.SetContextMenu && IsObject(this.ContextMenu) {
            tvex.SetContextMenu(this.ContextMenu)
        }
        if IsObject(this.Callback) {
            this.Callback.Call(tvex, this)
        }
        return tvex
    }
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
                        return
                    }
                }
            }
        }
    }
    Get(Name) => this.Collection.GetValue(Name)
    Has(Name) => this.Collection.Find(Name)
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

    class Options {
        static Default := {
            Opt: 'w100 h100'
          , Name: ''
          , Which: 'Tab3'
          , Text: ''
          , ContextMenu: ''
          , CaseSense: false
          , Callback: ''
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
    class AddOptions {
        static Default := {
            Autosize: true
          , CreateTab: true
          , FitTab: true
          , SetContextMenu: true
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
        __New(tvex, tab, tabValue, fitTab, autosize) {
            this.tvex := tvex
            this.tabValue := tabValue
            this.HwndTab := tab.Hwnd
            this.fitTab := fitTab
            this.SetAutosize(autosize)
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
        Tab => GuiCtrlFromHwnd(this.HwndTab)
    }
}

TreeViewEx_Tab_CallbackValue_Name(value) {
    return value.tvex.name
}
TreeViewEx_Tab_OnChange(tab, *) {
    tvexTab := tab.tvexTab
    for item in tvexTab.ActiveControls {
        item.tvex.Enabled := item.tvex.Visible := 0
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
        tvex := item.tvex
        if item.autosize {
            ; If autosize is true, ensure the control's position is consistent relative to the tab's borders.
            diff := item.diff
            WinMove(rc.L + diff.L, rc.T + diff.T, rc.W + diff.W, rc.H + diff.H, tvex.Hwnd)
        }
        ; Display the control
        tvex.Enabled := 1
        if !DllCall(
            g_user32_SetWindowPos
          , 'ptr', tvex.Hwnd
          , 'ptr', tab.Hwnd
          , 'int', 0, 'int', 0, 'int', 0, 'int', 0
          , 'uint', SWP_SHOWWINDOW | SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE | SWP_NOCOPYBITS
          , 'int'
        ) {
            throw OSError()
        }
        tvex.Redraw()
    }
}
