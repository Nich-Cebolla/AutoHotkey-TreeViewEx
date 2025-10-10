
class TreeViewExContextMenu extends MenuEx {
    static __New() {
        this.DeleteProp('__New')
        this.DefaultItems := [
            ; Only the "Name" and "Value" are required. Other properties are "Options", which are the
            ; options described by https://www.autohotkey.com/docs/v2/lib/Menu.htm#Add, and "Tooltip",
            ; which controls the tooltip text that will be displayed. Details about "Tooltip" are
            ; available in the description of `MenuExItem.Prototype.SetTooltipHandler`.

            ; Since we have defined the functions as class instance methods, we can define "Value"
            ; with the name of the method.
            { Name: 'Copy node ID', Value: 'SelectCopyNodeId' }
          , { Name: 'Copy value', Value: 'SelectCopyValue' }
          , { Name: 'Expand', Value: 'SelectExpand' }
          , { Name: 'Expand recursive', Value: 'SelectExpandRecursive' }
        ]
    }
    HandlerItemAvailability() {
        ctrl := this.Token.Ctrl
        items := this.__Item
        if this.Token.Item {
            items.Get('Copy node ID').Enable()
            items.Get('Copy value').Enable()
            items.Get('Expand').Enable()
            items.Get('Expand recursive').Enable()
        } else {
            items.Get('Copy node ID').Disable()
            items.Get('Copy value').Disable()
            items.Get('Expand').Disable()
            items.Get('Expand recursive').Disable()
        }
    }
    Initialize(*) {
        this.AddObjectList(TreeViewExContextMenu.DefaultItems)
    }
    SelectCopyNodeId(Params) {
        if A_Clipboard := Params.Token.Item {
            return 'Copied: ' Params.Token.Item
        } else {
            return 'Could not get the node ID.'
        }
    }
    SelectCopyValue(Params) {
        if Params.Token.Ctrl.GetText(Params.Token.Item, &text) {
            A_Clipboard := text
            return 'Copied: ' text
        } else {
            return 'Could not get the item`'s value.'
        }
    }
    SelectExpand(Params) {
        Params.Token.Ctrl.Expand(Params.Token.Item)
        if Params.Token.Ctrl.GetText(Params.Token.Item, &text) {
            return 'Expanded from node: ' text
        } else {
            return 'Expanded from node: ' Params.Token.Item
        }
    }
    SelectExpandRecursive(Params) {
        Params.Token.Ctrl.ExpandRecursive(Params.Token.Item, 5)
    }
    Ctrl => GuiCtrlFromHwnd(this.TvHwnd)
}
