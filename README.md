# AutoHotkey-TreeViewEx

An AutoHotkey (AHK) library that extends the built-in tree view control functionality.

The following is a list of methods and properties. The items with an "X" next to them have been tested. The items with no "X" have not been tested.

## Static methods

|  Name                     |  Is tested  |
|  -------------------------|-----------  |
|  static Call              |      X      |
|  static SetConstants      |      X      |

## Instance methods

|  Name                     |  Is tested  |
|  -------------------------|-----------  |
|  AddObj                   |      X      |
|  AddObjList               |             |
|  AddTemplate              |             |
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
|  GetImageList             |             |
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
|  SetImageList             |             |
|  SetIndent                |             |
|  SetInsertMark            |             |
|  SetInsertMarkColor       |             |
|  SetItem                  |             |
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

## Instance properties

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
