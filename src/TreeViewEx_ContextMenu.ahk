
#include <TreeViewEx>
; https://github.com/Nich-Cebolla/AutoHotkey-MenuEx
#include <MenuEx>

class TreeViewEx_ContextMenu extends MenuEx {
    static __New() {
        this.DeleteProp('__New')
        this.Prototype.DefaultItems := TreeViewExCollection_ContextMenuItem(
            /**
                Only the "Name" and "Value" are required. Other properties are "Options", which are the
                options described by https://www.autohotkey.com/docs/v2/lib/Menu.htm#Add, and "Tooltip",
                which controls the tooltip text that will be displayed. Details about "Tooltip" are
                available in the description of {@link MenuExItem.Prototype.SetTooltipHandler}.
                Since we have defined the functions as class instance methods, we can define "Value"
                with the name of the method.

                Used accelerators: A, B, C, D, E, F, I, O, P, Q, S, T, W, X, Z
            */
            { Name: 'Copy node ID (&D)', Value: 'SelectCopyNodeId' }
          , { Name: 'Copy label (&C)', Value: 'SelectCopyLabel' }
          , { Name: 'Collapse recursive (&S)', Value: 'SelectCollapseRecursive' }
          , { Name: 'Collapse all recursive (&A)', Value: 'SelectCollapseAllRecursive' }
          , { Name: 'Collapse parent (&P)', Value: 'SelectCollapseParent' }
          , { Name: 'Collapse parent recursive (&O)', Value: 'SelectCollapseParentRecursive' }
          , { Name: 'Collapse siblings (&G)', Value: 'SelectCollapseSiblings' }
          , { Name: 'Collapse siblings recursive (&F)', Value: 'SelectCollapseSiblingsRecursive' }
          , { Name: 'Expand recursive (&X)', Value: 'SelectExpandRecursive' }
          , { Name: 'Expand all recursive (&Z)', Value: 'SelectExpandAllRecursive' }
          , { Name: 'Expand partial (&I)', Value: 'SelectExpandPartial' }
          , { Name: 'Scroll to top (&T)', Value: 'SelectScrollToTop' }
          , { Name: 'Scroll to bottom (&B)', Value: 'SelectScrollToBottom' }
          , { Name: 'Select parent (&W)', Value: 'SelectSelectParent' }
          , { Name: 'Select previous sibling (&Q)', Value: 'SelectSelectPreviousSibling' }
          , { Name: 'Select next sibling (&E)', Value: 'SelectSelectNextSibling' }
        )
    }
    ; When the context menu is activated, if the MenuEx object (an instance of this class is
    ; a MenuEx object; it inherits from MenuEx) has a method "HandlerItemAvailability", that method
    ; is called before showing to context menu. The method is intended to enable and disable items
    ; as a function of what was underneath the mouse cursor when the context menu was activated,
    ; if anything.
    HandlerItemAvailability(Ctrl, IsRightClick, Item, X, Y) {
        items := this.__Item
        ; Since most of our methods act on the `Item` in some way, we only want to enable the menu items
        ; if `Item` has a significant value. The exceptions are "Collapse recursive (&S)" and "Expand recursive"
        ; which can still execute without `Item`.
        if Item {
            items.Get('Copy node ID (&D)').Enable()
            items.Get('Copy label (&C)').Enable()
            items.Get('Expand recursive (&X)').Enable()
            items.Get('Collapse recursive (&S)').Enable()
            items.Get('Expand partial (&I)').Enable()
            if SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Item, Ctrl.Hwnd) {
                items.Get('Select parent (&W)').Enable()
                items.Get('Collapse parent (&P)').Enable()
                items.Get('Collapse parent recursive (&O)').Enable()
            } else {
                items.Get('Select parent (&W)').Disable()
                items.Get('Collapse parent (&P)').Disable()
                items.Get('Collapse parent recursive (&O)').Disable()
            }
            flag_siblings := false
            if SendMessage(TVM_GETNEXTITEM, TVGN_PREVIOUS, Item, Ctrl.Hwnd) {
                items.Get('Select previous sibling (&Q)').Enable()
                flag_siblings := true
            } else {
                items.Get('Select previous sibling (&Q)').Disable()
            }
            if SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, Item, Ctrl.Hwnd) {
                items.Get('Select next sibling (&E)').Enable()
                flag_siblings := true
            } else {
                items.Get('Select next sibling (&E)').Disable()
            }
            if flag_siblings {
                items.Get('Collapse siblings (&G)').Enable()
                items.Get('Collapse siblings recursive (&F)').Enable()
            } else {
                items.Get('Collapse siblings (&G)').Disable()
                items.Get('Collapse siblings recursive (&F)').Disable()
            }
        } else {
            items.Get('Copy node ID (&D)').Disable()
            items.Get('Copy label (&C)').Disable()
            items.Get('Collapse recursive (&S)').Disable()
            items.Get('Collapse parent (&P)').Disable()
            items.Get('Collapse parent recursive (&O)').Disable()
            items.Get('Collapse siblings (&G)').Disable()
            items.Get('Collapse siblings recursive (&F)').Disable()
            items.Get('Expand recursive (&X)').Disable()
            items.Get('Select parent (&W)').Disable()
            items.Get('Select previous sibling (&Q)').Disable()
            items.Get('Select next sibling (&E)').Disable()
            items.Get('Expand partial (&I)').Disable()
        }
    }
    SelectCollapseAllRecursive(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        Ctrl.CollapseRecursiveNotify()
        Ctrl.Redraw()
        return 'Collapsed all nodes'
    }
    SelectCollapseParent(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        if handle := SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Item, Ctrl.Hwnd) {
            if Ctrl.CollapseNotify(handle, &result) || result {
                return 'Unable to collapse the parent node'
            }
            Ctrl.Select(handle)
            Ctrl.Redraw()
            return 'Collapsed node: ' Ctrl.GetText(handle)
        }
    }
    SelectCollapseParentRecursive(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        if handle := SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Item, Ctrl.Hwnd) {
            Ctrl.CollapseRecursiveNotify(handle)
            Ctrl.Select(handle)
            Ctrl.Redraw()
            return 'Collapsed from node: ' Ctrl.GetText(handle)
        }
    }
    SelectCollapseRecursive(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        Ctrl.CollapseRecursiveNotify(Item)
        Ctrl.Redraw()
        return 'Collapsed from node: ' Ctrl.GetText(Item)
    }
    SelectCollapseSiblings(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        handle := Item
        while handle := SendMessage(TVM_GETNEXTITEM, TVGN_PREVIOUS, handle, Ctrl.Hwnd) {
            Ctrl.CollapseNotify(handle)
        }
        handle := Item
        while handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, handle, Ctrl.Hwnd) {
            Ctrl.CollapseNotify(handle)
        }
        Ctrl.Redraw()
        return 'Collapsed siblings'
    }
    SelectCollapseSiblingsRecursive(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        handle := Item
        while handle := SendMessage(TVM_GETNEXTITEM, TVGN_PREVIOUS, handle, Ctrl.Hwnd) {
            Ctrl.CollapseRecursiveNotify(handle)
        }
        handle := Item
        while handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, handle, Ctrl.Hwnd) {
            Ctrl.CollapseRecursiveNotify(handle)
        }
        Ctrl.Redraw()
        return 'Collapsed siblings'
    }
    SelectCopyLabel(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        text := Ctrl.GetText(Item)
        A_Clipboard := text
        return 'Copied: ' text
    }
    SelectCopyNodeId(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        A_Clipboard := Item
        ; The text that is returned gets displayed in the tooltip.
        ; The option "ShowTooltips" must be enabled for the tooltips to be displayed.
        return 'Copied: ' Item
    }
    SelectExpandAllRecursive(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        Ctrl.SetRedraw(0)
        Ctrl.ExpandRecursiveNotify()
        Ctrl.EnsureVisible(SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, 0, Ctrl.Hwnd))
        Ctrl.SetRedraw(1)
        return 'Expanded all nodes'
    }
    SelectExpandRecursive(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        Ctrl.ExpandRecursiveNotify(Item)
        Ctrl.Redraw()
        return 'Expanded from node: ' Ctrl.GetText(Item)
    }
    SelectExpandPartial(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        Ctrl.ExpandPartial(Item)
        Ctrl.Redraw()
        return 'Expanded from node: ' Ctrl.GetText(Item)
    }
    SelectScrollToBottom(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        Ctrl.EnsureVisible(SendMessage(TVM_GETNEXTITEM, TVGN_LASTVISIBLE, 0, Ctrl.Hwnd))
        Ctrl.Redraw()
    }
    SelectScrollToTop(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        Ctrl.EnsureVisible(SendMessage(TVM_GETNEXTITEM, TVGN_ROOT, 0, Ctrl.Hwnd))
        Ctrl.Redraw()
    }
    SelectSelectNextSibling(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        handle := SendMessage(TVM_GETNEXTITEM, TVGN_NEXT, Item, Ctrl.Hwnd)
        Ctrl.Select(handle)
        Ctrl.EnsureVisible(handle)
        Ctrl.Redraw()
        return 'Selected node: ' ctrl.GetText(handle)
    }
    SelectSelectParent(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        handle := SendMessage(TVM_GETNEXTITEM, TVGN_PARENT, Item, Ctrl.Hwnd)
        Ctrl.Select(handle)
        Ctrl.EnsureVisible(handle)
        Ctrl.Redraw()
        return 'Selected node: ' ctrl.GetText(handle)
    }
    SelectSelectPreviousSibling(Name, ItemPos, MenuObj, GuiObj, Ctrl, Item) {
        handle := SendMessage(TVM_GETNEXTITEM, TVGN_PREVIOUS, Item, Ctrl.Hwnd)
        Ctrl.Select(handle)
        Ctrl.EnsureVisible(handle)
        Ctrl.Redraw()
        return 'Selected node: ' ctrl.GetText(handle)
    }
}
