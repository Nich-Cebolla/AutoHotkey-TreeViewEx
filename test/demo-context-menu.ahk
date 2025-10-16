
; https://github.com/Nich-Cebolla/AutoHotkey-MenuEx
#include <MenuEx>

#SingleInstance force
#include ..\src\VENV.ahk

!esc::ExitApp()

demo_ContextMenu()

class TreeViewExContextMenu extends MenuEx {
    static __New() {
        this.DeleteProp('__New')
        this.Prototype.DefaultItems := [
            /**
                Only the "Name" and "Value" are required. Other properties are "Options", which are the
                options described by https://www.autohotkey.com/docs/v2/lib/Menu.htm#Add, and "Tooltip",
                which controls the tooltip text that will be displayed. Details about "Tooltip" are
                available in the description of {@link MenuExItem.Prototype.SetTooltipHandler}.
                Since we have defined the functions as class instance methods, we can define "Value"
                with the name of the method.
            */
            { Name: 'Copy node ID', Value: 'SelectCopyNodeId' }
          , { Name: 'Copy value', Value: 'SelectCopyValue' }
          , { Name: 'Collapse recursive', Value: 'SelectCollapseRecursive' }
          , { Name: 'Expand', Value: 'SelectExpand' }
          , { Name: 'Expand recursive', Value: 'SelectExpandRecursive' }
        ]
    }
    ; When the context menu is activated, if the MenuEx object (an instance of this class is
    ; a MenuEx object; it inherits from MenuEx) has a method "HandlerItemAvailability", that method
    ; is called before showing to context menu. The method is intended to enable and disable items
    ; as a function of what was underneath the mouse cursor when the context menu was activated,
    ; if anything.
    HandlerItemAvailability(Ctrl, IsRightClick, Item, X, Y) {
        items := this.__Item
        ; Since most of our methods act on the `Item` in some way, we only want to enable the menu items
        ; if `Item` has a significant value. The exceptions are "Collapse recursive" and "Expand recursive"
        ; which can still execute without `Item`.
        if Item {
            items.Get('Copy node ID').Enable()
            items.Get('Copy value').Enable()
            items.Get('Expand').Enable()
        } else {
            items.Get('Copy node ID').Disable()
            items.Get('Copy value').Disable()
            items.Get('Expand').Disable()
        }
    }
    SelectCollapseRecursive(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        if Item {
            Ctrl.CollapseRecursive(Item || 0)
            return 'Collapsed from node: ' Ctrl.GetText(Item)
        } else {
            Ctrl.CollapseRecursive(0)
            return 'Collapsed root nodes'
        }
    }
    SelectCopyNodeId(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        A_Clipboard := Item
        ; The text that is returned gets displayed in the tooltip.
        ; The option "ShowTooltips" must be enabled for the tooltips to be displayed.
        return 'Copied: ' Item
    }
    SelectCopyValue(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        text := Ctrl.GetText(Item)
        A_Clipboard := text
        return 'Copied: ' text
    }
    SelectExpand(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        Ctrl.ExpandNotify(Item)
        return 'Expanded from node: ' Ctrl.GetText(Item)
    }
    SelectExpandRecursive(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        if Item {
            Ctrl.ExpandRecursive(Item || 0)
            return 'Expanded from node: ' Ctrl.GetText(Item)
        } else {
            Ctrl.ExpandRecursive(0)
            return 'Expanded root nodes'
        }
    }
}

class demo_ContextMenu {
    static Call() {
        ; This is our example object that we are using to construct the nodes
        Obj := [
            {
                Name: 'obj1'
              , Children: [
                    { Name: 'obj1-1', Children: [ 'obj1-1-1' ] }
                  , { Name: 'obj1-2', Children: [ 'obj1-2-1' ] }
                  , {
                        Name: 'obj1-3'
                      , Children: [
                            {
                                Name: 'obj1-3-1'
                              , Children: [
                                    'obj1-3-1-1'
                                  , 'obj1-3-1-2'
                                  , 'obj1-3-1-3'
                                  , {
                                        Name: 'obj1-3-1-4'
                                      , Children: [ 'obj1-3-1-4-1' ]
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
          , {
                Name: 'obj2'
              , Children: [
                    'obj2-1'
                  , 'obj2-2'
                  , 'obj2-3'
                  , 'obj2-4'
                ]
            }
        ]

        ; Create Gui
        g := this.g := Gui('+Resize')
        g.OnEvent('Close', (*) => ExitApp())

        ; Add TreeViewEx
        tvex := this.tvex := TreeViewEx(g, { Width: 300, Rows: 17 })

        ; Add the context menu, with ShowTooltips enabled.
        tvex.SetContextMenu(TreeViewExContextMenu(, { ShowTooltips: true }))

        ; Add the nodes
        tvex.AddObjList(Obj)

        ; Show the gui
        tvex.GetPos(&x, &y, &w, &h)
        g.Show('x100 y100 w' (w + x + g.MarginX) ' h' (y + h + g.MarginY))
        tvex.Redraw()
    }
}
