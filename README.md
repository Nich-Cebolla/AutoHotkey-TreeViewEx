# AutoHotkey-TreeViewEx

An AutoHotkey (AHK) library that extends the built-in tree view control functionality.

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
  </ol>
  <li><a href="#treeviewnode">TreeViewNode</a></li>
  <ol type="A">
    <li><a href="#extending-treeviewnode">Extending TreeViewNode</a></li>
    <li><a href="#treeviewnode-tested-methods-and-properties">TreeViewNode: Tested methods and properties</a></li>
    <ol type="A">
      <li><a href="#treeviewnode-static-methods">TreeViewNode: Static methods</a></li>
      <li><a href="#treeviewnode-instance-methods">TreeViewNode: Instance methods</a></li>
      <li><a href="#treeviewnode-instance-properties">TreeViewNode: Instance properties</a></li>
    </ol>
  </ol>
</ol>

## Related libraries

- [ImageList:](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/ImageList.ahk) Create an `ImageList` from an array of file paths or an array of bitmap pointers. For use with `TreeViewEx.Prototype.SetImageList` and related methods. For a usage example, see "test\test-ImageList.ahk". Requires several dependencies from the same [repository](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/).

# TreeViewEx

`TreeViewEx` implements almost all of the TVM messages, and a number of additional methods. Most of the methods are currently undocumented, but for the most part you can find the needed information on [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/bumper-tree-view-control-reference-messages).

## TreeViewEx: Tested methods and properties

The following is a list of methods and properties. The items with an "X" next to them have been tested. The items with no "X" have not been tested. Most of the methods and properties probably work, but only the marked items have been verified.

### TreeViewEx: Static methods

|  Name                     |  Is tested  |
|  -------------------------|-----------  |
|  Call                     |      X      |

### TreeViewEx: Instance methods

|  Name                     |  Is tested  |
|  -------------------------|-----------  |
|  AddObj                   |      X      |
|  AddObjList               |      X      |
|  AddObjListFromTemplate   |      X      |
|  AddTemplate              |      X      |
|  Collapse                 |             |
|  CollapseReset            |             |
|  CopyItemId               |             |
|  CopyText                 |             |
|  CreateDragImage          |             |
|  EditLabel                |             |
|  EndEditLabel             |             |
|  EnsureVisible            |             |
|  EnumChildren             |      X      |
|  EnumChildrenRecursive    |      X      |
|  Expand                   |             |
|  ExpandPartial            |             |
|  GetBkColor               |             |
|  GetEditControl           |             |
|  GetExtendedStyle         |             |
|  GetImageList             |      X      |
|  GetIndent                |             |
|  GetInsertMarkColor       |             |
|  GetISearchString         |             |
|  GetItem                  |             |
|  GetItemHeight            |             |
|  GetItemRect              |             |
|  GetItemState             |             |
|  GetLineColor             |             |
|  GetLineRect              |             |
|  GetRoot                  |             |
|  GetScrollTime            |             |
|  GetTextColor             |             |
|  GetTooltips              |             |
|  GetVisibleCount          |             |
|  HitTest                  |             |
|  Insert                   |             |
|  IsParent                 |             |
|  IsRoot                   |             |
|  MapAccIdToHTreeItem      |             |
|  MapHTreeItemToAccId      |             |
|  Select                   |             |
|  SetAutoScrollInfo        |             |
|  SetBkColor               |             |
|  SetBorder                |             |
|  SetChildrenHandler       |             |
|  SetExtendedStyle         |             |
|  SetGetDispInfoWHandler   |             |
|  SetImageHandler          |             |
|  SetImageList             |      X      |
|  SetIndent                |             |
|  SetInsertMark            |             |
|  SetInsertMarkColor       |             |
|  SetItem                  |      X      |
|  SetItemHeight            |             |
|  SetLineColor             |             |
|  SetNameHandler           |             |
|  SetNodeConstructor       |      X      |
|  SetScrollTime            |             |
|  SetSelectedImageHandler  |             |
|  SetSetDispInfoWHandler   |             |
|  SetTextColor             |             |
|  SetTooltips              |             |
|  ShowInfoTip              |             |
|  SortChildren             |             |
|  SortChildrenCb           |             |
|  Toggle                   |             |

### TreeViewEx: Instance properties

|  Name                     |  Is tested  |
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
|  HandlerChildrenGet       |             |
|  HandlerGetDispInfoW      |             |
|  HandlerImageGet          |             |
|  HandlerImageSet          |             |
|  HandlerNameGet           |             |
|  HandlerNameSet           |             |
|  HandlerSelectedImageGet  |             |
|  HandlerSelectedImageSet  |             |
|  HandlerSetDispInfoW      |             |
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

# TreeViewNode

Each instance of `TreeViewNode` has a property "Handle" which is set with the HTREEITEM handle. This is the same value as the `ItemID` parameter used by various `TreeView` methods as described in the [AutoHotkey documentation](https://www.autohotkey.com/docs/v2/lib/TreeView.htm). For example, the first parameter of [TreeView.Prototype.Modify](https://www.autohotkey.com/docs/v2/lib/TreeView.htm#Modify), expects an HTREEITEM handle. When you call a method or access a property from a `TreeViewNode` instance, in most cases it calls a function which sends a TVM message where the `wParam` or `lParam` is expected to be an HTREEITEM handle.

## Extending TreeViewNode

To be added...

## TreeViewNode: Tested methods and properties

The following is a list of methods and properties. The items with an "X" next to them have been tested. The items with no "X" have not been tested. Most of the methods and properties probably work, but only the marked items have been verified.

### TreeViewNode: Static methods

|  Name                     |  Is Tested  |
|  -------------------------|-----------  |
|  SetChildrenHandler       |             |
|  SetNameHandler           |             |
|  SetImageHandler          |             |
|  SetSelectedImageHandler  |             |

### TreeViewNode: Instance methods

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

### TreeViewNode: Instance properties

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
