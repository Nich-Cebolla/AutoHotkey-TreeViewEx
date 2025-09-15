# AutoHotkey-TreeViewEx

An AutoHotkey (AHK) library that extends the built-in tree-view control functionality.

## Table of contents

<ol type="I">
  <li><a href="#autohotkey-treeviewex">AutoHotkey-TreeViewEx</a></li>
  <ol type="A">
    <li><a href="#related-libraries">Related libraries</a></li>
  </ol>
  <li><a href="#treeviewex">TreeViewEx</a></li>
  <ol type="A">
    <li><a href="#treeviewex-tested-methods-and-properties">TreeViewEx: Tested methods and properties</a></li>
    <ol type="A">
      <li><a href="#treeviewex-static-methods">TreeViewEx: Static methods</a></li>
      <li><a href="#treeviewex-instance-methods">TreeViewEx: Instance methods</a></li>
      <li><a href="#treeviewex-instance-properties">TreeViewEx: Instance properties</a></li>
    </ol>
    <li><a href="#treeviewex-tested-notification-handlers">TreeViewEx: Tested notification handlers</a></li>
  </ol>
  <li><a href="#TreeViewExNode">TreeViewExNode</a></li>
  <ol type="A">
    <li><a href="#extending-TreeViewExNode">Extending TreeViewExNode</a></li>
    <li><a href="#TreeViewExNode-tested-methods-and-properties">TreeViewExNode: Tested methods and properties</a></li>
    <ol type="A">
      <li><a href="#TreeViewExNode-static-methods">TreeViewExNode: Static methods</a></li>
      <li><a href="#TreeViewExNode-instance-methods">TreeViewExNode: Instance methods</a></li>
      <li><a href="#TreeViewExNode-instance-properties">TreeViewExNode: Instance properties</a></li>
    </ol>
  </ol>
</ol>

## Related libraries

- [ImageList:](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/ImageList.ahk) Create an `ImageList` from an array of file paths or an array of bitmap pointers. For use with `TreeViewEx.Prototype.SetImageList` and related methods. For a usage example, see "test\test-ImageList.ahk". Requires several dependencies from the same [repository](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/).
- [Logfont:](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/structs/Logfont.ahk) A full-featured font object. `TreeViewEx` has a built-in [`TreeViewExLogFont`](https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx/blob/main/src/TreeViewExLogFont.ahk) class which encapsulates the core functionality necessary for adjusting the control's font, but [`TreeViewExLogFont`](https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx/blob/main/src/TreeViewExLogFont.ahk) does not include functionality related to enumerating a system's fonts and evaluating the fonts. If your application would benefit from being able to find the optimal font available on the system, check out [Logfont](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/structs/Logfont.ahk)

# TreeViewEx

`TreeViewEx` implements almost all of the TVM messages, and a number of additional methods. Most of the methods are currently undocumented, but for the most part you can find the needed information on [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/bumper-tree-view-control-reference-messages).

## TreeViewEx: Tested methods and properties

The following is a list of methods and properties. The items with an "X" next to them have been tested. The items with no "X" have not been tested. Most of the methods and properties probably work, but only the marked items have been verified.

### TreeViewEx: Static methods

None.

### TreeViewEx: Instance methods

|  Name                    |  Is Tested  |
|  ------------------------|-----------  |
|  __New                   |      X      |
|  AddNode                 |      X      |
|  AddNode_C               |      X      |
|  AddObj                  |      X      |
|  AddObjList              |      X      |
|  AddObjListFromTemplate  |      X      |
|  AddTemplate             |      X      |
|  Collapse                |             |
|  CollapseReset           |             |
|  CopyItemId              |             |
|  CopyText                |             |
|  CreateDragImage         |             |
|  DeleteAll               |      X      |
|  DeleteItem              |      X      |
|  DeleteNode_C            |             |
|  Destroy                 |      X      |
|  Dispose                 |      X      |
|  EditLabel               |      X      |
|  EditSelectedLabel       |      X      |
|  EndEditLabel            |      X      |
|  EnsureVisible           |             |
|  EnumChildren            |      X      |
|  EnumChildrenRecursive   |      X      |
|  Expand                  |      X      |
|  ExpandPartial           |             |
|  GetBkColor              |             |
|  GetEditControl          |             |
|  GetExtendedStyle        |             |
|  GetFont                 |             |
|  GetImageList            |             |
|  GetIndent               |             |
|  GetInsertMarkColor      |             |
|  GetISearchString        |             |
|  GetItem                 |      X      |
|  GetItemHeight           |             |
|  GetItemRect             |      X      |
|  GetItemState            |             |
|  GetLineColor            |             |
|  GetLineRect             |             |
|  GetNode                 |      X      |
|  GetNode_C               |      X      |
|  GetNode_Ptr             |             |
|  GetParent               |             |
|  GetPos                  |             |
|  GetRoot                 |             |
|  GetScrollTime           |             |
|  GetSelected             |      X      |
|  GetText                 |      X      |
|  GetTextColor            |             |
|  GetTooltips             |             |
|  GetVisibleCount         |             |
|  HasChildren             |      X      |
|  HitTest                 |             |
|  Insert                  |      X      |
|  IsExpanded              |             |
|  IsRoot                  |             |
|  IsAncestor              |             |
|  MapAccIdToHTreeItem     |             |
|  MapHTreeItemToAccId     |             |
|  OnNotify                |      X      |
|  Select                  |      X      |
|  SetAutoScrollInfo       |             |
|  SetBkColor              |             |
|  SetBorder               |             |
|  SetExtendedStyle        |             |
|  SetImageList            |      X      |
|  SetIndent               |             |
|  SetInsertMark           |             |
|  SetInsertMarkColor      |             |
|  SetItem                 |      X      |
|  SetItemHeight           |             |
|  SetLineColor            |             |
|  SetNodeConstructor      |      X      |
|  SetScrollTime           |             |
|  SetTextColor            |             |
|  SetTooltips             |             |
|  ShowInfoTip             |             |
|  SortChildren            |      X      |
|  SortChildrenCb          |             |
|  Toggle                  |             |
|  __Delete                |             |
|  __SetHandler            |             |
|  __SetHandlerDispInfo    |             |

### TreeViewEx: Instance properties

|  Name                     |  Is Tested  |
|  -------------------------|-----------  |
|  AutoHScroll              |             |
|  Checkboxes               |             |
|  DimmedCheckboxes         |             |
|  DisableDragDrop          |             |
|  DoubleBuffer             |             |
|  DrawImageAsync           |             |
|  EditLabels               |             |
|  ExclusionCheckboxes      |             |
|  FadeInOutExpandos        |             |
|  FullRowselect            |             |
|  Gui                      |      X      |
|  HandlerChildrenGet       |             |
|  HandlerGetDispInfo       |             |
|  HandlerImageGet          |             |
|  HandlerImageSet          |             |
|  HandlerNameGet           |             |
|  HandlerNameSet           |             |
|  HandlerSelectedImageGet  |             |
|  HandlerSelectedImageSet  |             |
|  HandlerSetDispInfo       |             |
|  HasButtons               |             |
|  HasLines                 |             |
|  Infotip                  |             |
|  LinesAtRoot              |             |
|  MultiSelect              |             |
|  NoHScroll                |             |
|  NoIndentState            |             |
|  NonEvenHeight            |             |
|  NoScroll                 |             |
|  NoSingleCollapse         |             |
|  NoTooltips               |             |
|  PartialCheckboxes        |             |
|  RichTooltip              |             |
|  RtlReading               |             |
|  ShowSelAlways            |             |
|  SingleExpand             |             |
|  TrackSelect              |             |

## TreeViewEx - Tested notification handlers

`TreeViewEx` currently offers three sets of notification handlers, each using a different approach to managing the item collection on our side of the code.

### TreeViewEx - Tested notification handlers - Node

These are the functions in file "src\notify-node.ahk". They get the node object by calling `TreeViewEx.Prototype.GetNode(Handle)`, which calls `TreeViewExObj.Constructor(Handle)`.

|  Name                                   |  Is Tested  |
|  ---------------------------------------|-----------  |
|  TreeViewEx_HandlerBeginLabelEdit_Node  |             |
|  TreeViewEx_HandlerDeleteItem_Node      |             |
|  TreeViewEx_HandlerEndLabelEdit_Node    |             |
|  TreeViewEx_HandlerGetDispInfo_Node     |             |
|  TreeViewEx_HandlerGetInfoTip_Node      |             |
|  TreeViewEx_HandlerItemChanged_Node     |             |
|  TreeViewEx_HandlerItemChanging_Node    |             |
|  TreeViewEx_HandlerItemExpanded_Node    |             |
|  TreeViewEx_HandlerItemExpanding_Node   |             |
|  TreeViewEx_HandlerSetDispInfo_Node     |             |
|  TreeViewEx_HandlerSingleExpand_Node    |             |

### TreeViewEx - Tested notification handlers - Node_C

These are the functions in file "src\notify-node-c.ahk". They get the node object by calling `TreeViewEx.Prototype.GetNode_C(Handle)`, which accesses `TreeViewExObj.Collection.Get(Handle)`.

|  Name                                     |  Is Tested  |
|  -----------------------------------------|-----------  |
|  TreeViewEx_HandlerBeginLabelEdit_Node_C  |             |
|  TreeViewEx_HandlerDeleteItem_Node_C      |             |
|  TreeViewEx_HandlerEndLabelEdit_Node_C    |             |
|  TreeViewEx_HandlerGetDispInfo_Node_C     |             |
|  TreeViewEx_HandlerGetInfoTip_Node_C      |             |
|  TreeViewEx_HandlerItemChanged_Node_C     |             |
|  TreeViewEx_HandlerItemChanging_Node_C    |             |
|  TreeViewEx_HandlerItemExpanded_Node_C    |             |
|  TreeViewEx_HandlerItemExpanding_Node_C   |             |
|  TreeViewEx_HandlerSetDispInfo_Node_C     |             |
|  TreeViewEx_HandlerSingleExpand_Node_C    |             |

### TreeViewEx - Tested notification handlers - Node_Ptr

These are the functions in file "src\notify-node-ptr.ahk". They get the node object by calling `node := ObjFromPtrAddRef(struct.lParam)`.

|  Name                                       |  Is Tested  |
|  -------------------------------------------|-----------  |
|  TreeViewEx_HandlerBeginLabelEdit_Node_Ptr  |      X      |
|  TreeViewEx_HandlerDeleteItem_Node_Ptr      |      X      |
|  TreeViewEx_HandlerEndLabelEdit_Node_Ptr    |      X      |
|  TreeViewEx_HandlerGetDispInfo_Node_Ptr     |      X      |
|  TreeViewEx_HandlerGetInfoTip_Node_Ptr      |             |
|  TreeViewEx_HandlerItemChanged_Node_Ptr     |      X      |
|  TreeViewEx_HandlerItemChanging_Node_Ptr    |      X      |
|  TreeViewEx_HandlerItemExpanded_Node_Ptr    |      X      |
|  TreeViewEx_HandlerItemExpanding_Node_Ptr   |      X      |
|  TreeViewEx_HandlerSetDispInfo_Node_Ptr     |      X      |
|  TreeViewEx_HandlerSingleExpand_Node_Ptr    |             |

# TreeViewExNode

Each instance of `TreeViewExNode` has a property "Handle" which is set with the HTREEITEM handle. This is the same value as the `ItemID` parameter used by various `TreeView` methods as described in the [AutoHotkey documentation](https://www.autohotkey.com/docs/v2/lib/TreeView.htm). For example, the first parameter of [TreeView.Prototype.Modify](https://www.autohotkey.com/docs/v2/lib/TreeView.htm#Modify), expects an HTREEITEM handle. When you call a method or access a property from a `TreeViewExNode` instance, in most cases it calls a function which sends a TVM message where the `wParam` or `lParam` is expected to be an HTREEITEM handle.

## Extending TreeViewExNode

`TreeViewExNode` is intended to be extended and coupled with callback functions passed to one or more of `TreeViewEx.Prototype.SetChildrenHandler`, `TreeViewEx.Prototype.SetImageHandler`, `TreeViewEx.Prototype.SetNameHandler`, `TreeViewEx.Prototype.SetSelectedImageHandler`. This allows our code to reduce memory overhead and increase customizability by controlling these characteristics of the tree-view items dynamically.

This section needs more work and there may be some delay before I get back to writing it. Use the [demo file](https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx/blob/main/test/demo-NotificationHandlers.ahk) as a guide, and if something is unclear or you have a question, message [@Cebolla](https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=170932) on [AutoHotkey.com](https://www.autohotkey.com/boards/).


### TVN_GETDISPINFO

For [TVN_GETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-getdispinfo) notifications, your function is expected to fill the members of the [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure with the requested information. Your code does not need to calculate any of the byte offsets, this is already done for you by the [TvDispInfoEx](https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx/blob/main/src/TvDispInfoEx.ahk) class. Your code can simply assign a value to the appropriate property.

[TVN_GETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-getdispinfo) is only sent if the relevant member of a tree-view item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure has been set with a specific value:
- The `pszText` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure is the `LPSTR_TEXTCALLBACK` value (-1).
- The `iImage` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure is the `I_IMAGECALLBACK` value (-1).
- The `iSelectedImage` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure is the `I_IMAGECALLBACK` value (-1).
- The `cChildren` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure is the `I_CHILDRENCALLBACK` value (-1).

### TVN_SETDISPINFO

[TVN_SETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-setdispinfo) is only sent if the relevant member of a tree-view item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure has been set with a specific value. Unlike [TVN_GETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-getdispinfo) which has four related members, `TVN_SETDISPINFO` only has three:
- The `pszText` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure is the `LPSTR_TEXTCALLBACK` value (-1).
- The `iImage` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure is the `I_IMAGECALLBACK` value (-1).
- The `iSelectedImage` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure is the `I_IMAGECALLBACK` value (-1).

The tree-view control sends [TVN_SETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-setdispinfo) notifications to inform your code that an event occurred that caused a change to a characteristic of a tree-view item. Typically the events are raised by the user's actions. The notification provides information about what characteristic was changed, and provides the new value.

The following are the contexts in which the tree-view control sends [TVN_SETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-setdispinfo):
- If the `pszText` member of the item's The user edits the label of an item (if this functionality is enabled for the control). The `mask` member will have the `TVIF_FLAG` set.
- An item's selected state has changed. If the item's selected state has changed from being selected to being not selected, the `mask` member will have the `TVIF_IMAGE` flag set. If the item's selected state has changed from being not selected to being selected, the `mask` member will have the `TVIF_SELECTEDIMAGE` flag set.

## TreeViewExNode: Tested methods and properties

The following is a list of methods and properties. The items with an "X" next to them have been tested. The items with no "X" have not been tested. Most of the methods and properties probably work, but only the marked items have been verified.

### TreeViewExNode: Static methods

|  Name                     |  Is Tested  |
|  -------------------------|-----------  |
|  SetChildrenHandler       |             |
|  SetNameHandler           |             |
|  SetImageHandler          |             |
|  SetSelectedImageHandler  |             |

### TreeViewExNode: Instance methods

|  Name                     |  Is Tested  |
|  -------------------------|-----------  |
|  __New                    |             |
|  AddChild                 |             |
|  Copy                     |             |
|  CopyItemId               |             |
|  Collapse                 |             |
|  CollapseReset            |             |
|  CreateDragImage          |             |
|  EnsureVisible            |             |
|  EnumChildren             |             |
|  EnumChildrenRecursive    |             |
|  Expand                   |             |
|  ExpandPartial            |             |
|  GetItemState             |             |
|  GetText                  |             |
|  MapHTreeItemToAccId      |             |
|  Select                   |             |
|  SetInsertMark            |             |
|  SetTreeView              |             |
|  ShowInfoTip              |             |
|  SortChildren             |             |
|  SortChildrenCb           |             |
|  Toggle                   |             |

### TreeViewExNode: Instance properties

|  Name                     |  Is Tested  |
|  -------------------------|-----------  |
|  Child                    |             |
|  Ctrl                     |             |
|  Gui                      |             |
|  InfoChildren             |             |
|  InfoImage                |             |
|  InfoName                 |             |
|  InfoSelectedImage        |             |
|  IsParent                 |             |
|  IsRoot                   |             |
|  LineRect                 |             |
|  Next                     |             |
|  Parent                   |             |
|  Previous                 |             |
|  Root                     |             |
|  Rect                     |             |
