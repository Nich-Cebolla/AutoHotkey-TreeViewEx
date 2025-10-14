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
  <li><a href="#TreeViewEx_Node">TreeViewEx_Node</a></li>
  <ol type="A">
    <li><a href="#extending-TreeViewEx_Node">Extending TreeViewEx_Node</a></li>
    <li><a href="#TreeViewEx_Node-tested-methods-and-properties">TreeViewEx_Node: Tested methods and properties</a></li>
    <ol type="A">
      <li><a href="#TreeViewEx_Node-static-methods">TreeViewEx_Node: Static methods</a></li>
      <li><a href="#TreeViewEx_Node-instance-methods">TreeViewEx_Node: Instance methods</a></li>
      <li><a href="#TreeViewEx_Node-instance-properties">TreeViewEx_Node: Instance properties</a></li>
    </ol>
  </ol>
</ol>

## Related libraries

- [`ImageList`:](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/ImageList.ahk)
Create an `ImageList` from an array of file paths or an array of bitmap pointers. For use with
`TreeViewEx.Prototype.SetImageList` and related methods. For a usage example, see
test\test-ImageList.ahk. Requires several dependencies from the same
[repository](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/).
- [`Logfont`:](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/structs/Logfont.ahk)
A full-featured font object. `TreeViewEx` has a built-in
[`TreeViewEx_LogFont`](https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx/blob/main/src/TreeViewEx_LogFont.ahk)
class which encapsulates the core functionality necessary for adjusting the control's font, but
`TreeViewEx_LogFont` does not include functionality related to enumerating a system's fonts and
evaluating the fonts. If your application would benefit from being able to find the optimal font
available on the system, check out Logfont.
- [`MenuEx`:](https://github.com/Nich-Cebolla/AutoHotkey-MenuEx) - A class that streamlines the process
of creating a context menu. See file test\demo-context-menu.ahk for an example.

# TreeViewEx

`TreeViewEx` implements almost all of the TVM messages, and a number of additional methods. Most of
the methods are currently undocumented, but for the most part you can find the needed information on
[Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/controls/bumper-tree-view-control-reference-messages).

To use the library `#include` [VENV.ahk](https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx/blob/main/src/VENV.ahk).
VENV.ahk packages all of the files together. To make the library available to any script, I recommend
this setup:

- Clone the repository.
  ```cmd
  git clone https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
  ```
- Make a copy of the cloned repository and work with the copy. This is to avoid a situation where
  pulling an update breaks our scripts; by using a separate copy we can give ourselves time to review
  updates before updating the active copy.
  ```cmd
  xcopy AutoHotkey-TreeViewEx AutoHotkey-TreeViewEx-Active /I /E
  ```
- Add a file TreeViewEx.ahk to your [lib folder](https://www.autohotkey.com/docs/v2/Scripts.htm#lib).
  In the file is a single statement.
  ```ahk
  #include C:\users\you\path\to\AutoHotkey-TreeViewEx-Active\src\VENV.ahk
  ```

With this setup, we can use `#include <TreeViewEx>` from any other script. Also, when we want to test
updates to the repository, we just need to go into that file and change the path to the VENV.ahk
file in the git clone, then run our scripts that use `TreeViewEx` to check for errors. Then change
the path back when done.

# Dependencies

`TreeViewEx` requires the following dependencies. I recommend preparing the dependencies with a
similar approach to the above steps.

- [`Rect`](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/structs/Rect.ahk)
  - Clone [AutoHotkey-LibV2](https://github.com/Nich-Cebolla/AutoHotkey-LibV2), create a copy of
    the directory to use as your active copy, then create a file Rect.ahk in your lib folder
    with `#include C:\users\you\path\to\AutoHotkey-LibV2-Active\structs\Rect.ahk`.
- [`LibraryManager`](https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/LibraryManager.ahk)
  - `LibraryManager` is also in AutoHotkey-LibV2, so just create a file LibraryManager.ahk in your
    lib folder with `#include C:\users\you\path\to\AutoHotkey-LibV2-Active\LibraryManager.ahk`.
- [`Container`](https://github.com/Nich-Cebolla/AutoHotkey-Container)
  - Clone [`Container`](https://github.com/Nich-Cebolla/AutoHotkey-Container), create a copy of the
    directory to use as your active copy, then create a file Container.ahk in your lib folder
    with `#include C:\users\you\path\to\Container-Active\src\Container.ahk`.

# Demo

See [the demo script](https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx/blob/main/test/demo-NotificationHandlers.ahk)
for a working example. The demo file will run as-is (but still requires the above dependencies). The
demo script focuses on setting event handlers for TVN notifications. All nodes are added to the
tree-view with `item.pszText = LPSTR_TEXTCALLBACK` and `item.cChildren = TVIF_CHILDREN`. The following
notifications are handled in the demo:
- [TVN_BEGINLABELEDITW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-beginlabeledit)
- [TVN_DELETEITEMW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-deleteitem)
- [TVN_ENDLABELEDITW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-endlabeledit)
- [TVN_GETDISPINFOW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-getdispinfo)
- [TVN_GETINFOTIPW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-getinfotip)
- [TVN_ITEMCHANGEDW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-itemchanged)
- [TVN_ITEMCHANGINGW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-itemchanging)
- [TVN_ITEMEXPANDEDW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-itemexpanded)
- [TVN_ITEMEXPANDINGW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-itemexpanding)
- [TVN_SETDISPINFOW](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-setdispinfo)
- [NM_CLICK](https://learn.microsoft.com/en-us/windows/win32/controls/nm-click-tree-view)

# TreeViewEx_Tab.ahk

TreeViewEx_Tab.ahk is a separate script (not included in VENV.ahk) containing class `TreeViewEx_Tab`.
`TreeViewEx_Tab` has one dependency, [TabEx.ahk](https://github.com/Nich-Cebolla/AutoHotkey-TabEx).
`TreeViewEx_Tab` creates a tab control in a gui window and makes it easy to associate new `TreeViewEx`
controls with an individual tab so the user can change what information is displayed by selecting
a new tab.

For the developer, `TreeViewEx_Tab` handles all of the legwork around adding, positioning, displaying,
and removing `TreeViewEx` controls and the tabs they are associated with. These are the general steps
for using the class:

1. Prepare [TabEx.ahk](https://github.com/Nich-Cebolla/AutoHotkey-TabEx) in the same way as described
  [above](#treeviewex).
2. Add a file TreeViewEx_Tab.ahk to your [lib folder](https://www.autohotkey.com/docs/v2/Scripts.htm#lib).
  In the file is a single statement.
    ```ahk
    #include C:\users\you\path\to\AutoHotkey-TreeViewEx-Active\src\TreeViewEx_Tab.ahk
    ```
3. In your script that will use `TreeViewEx_Tab`, include:
    ```ahk
    #include <TreeViewEx_Tab>
    ```
4. (Optional) Create a context menu class using [MenuEx](#related-libraries).
5. (Optional) Define a function that all new `TreeViewEx` controls will be passed to to use
   custom instantiation logic.
6. Define 0-3 options objects, each associated with a parameter of `TreeViewEx_Tab.Prototype.__New`.
    ```ahk
    __New(GuiObj, Options?, DefaultAddOptions := '', DefaultTreeViewExOptions := '')
    ```
    None of the options are strictly necessary, but generally you'll want to create the `Options` object
    to specify the tab control's options, and optionally supply the objects described by steps 4 and 5
    above. The other two, `DefaultAddOptions` and `DefaultTreeViewExOptions`, can be left the default
    for general use.
    - `Options` - The options for `TreeViewEx_Tab` and the tab control it will create. These are described
    in the parameter hint above `TreeViewEx_Tab.Prototype.__New`.
    - `DefaultAddOptions` - The default options that will be used when adding a `TreeViewEx` control
    via `TreeViewEx_Tab.Prototype.Add`. These are described in the parameter hint above
    `TreeViewEx_Tab.Prototype.Add`.
    - `DefaultTreeViewExOptions` - The default options that will be used when adding a `TreeViewEx`
    control via `TreeViewEx_Tab.Prototype.Add`. These are described in the parameter hint above
    `TreeViewEx.Prototype.__New`.
7. Create the object
    ```ahk
    options := { opt: 'w400 r15', name: 'tab' } ; no context menu or instantiation callback seen here
    tvexTab := TreeViewEx_Tab(GuiObj, options) ; assume GuiObj reference a Gui object
    ```
8. Add `TreeViewEx` controls to the tab control by supplying a name. If using the default add options,
   calling `TreeViewEx_Tab.Prototype.Add` with just a name will:
  - Create a new tab using the name.
  - Create a new `TreeViewEx` control positioned neatly in the center of the tab control's client area.
    The control is associated with the newly created tab. This does not automatically display the tab
    (unless its the first tab).
  - Return a `TreeViewEx_Tab.Item` object. The `TreeViewEx` control is set to property "tvex".

See the test file test\test-TreeViewEx_Tab.ahk for a working demo.


## TreeViewEx: Tested methods and properties

The following is a list of methods and properties. The items with an "X" next to them have been tested.
The items with no "X" have not been tested. Most of the methods and properties probably work, but
only the marked items have been verified.

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
|  Collapse                |      X      |
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
|  ExpandRecursive         |      X      |
|  GetBkColor              |             |
|  GetEditControl          |      X      |
|  GetExtendedStyle        |             |
|  GetFont                 |             |
|  GetImageList            |             |
|  GetIndent               |             |
|  GetInsertMarkColor      |             |
|  GetISearchString        |             |
|  GetItem                 |      X      |
|  GetItemHeight           |      X      |
|  GetItemRect             |      X      |
|  GetItemState            |             |
|  GetLineColor            |             |
|  GetLineRect             |             |
|  GetNext                 |      X      |
|  GetChild                |      X      |
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
|  Hide                    |      X      |
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
|  SetContextMenu          |      X      |
|  SetExtendedStyle        |             |
|  SetImageList            |             |
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
|  Show                    |      X      |
|  ShowInfoTip             |             |
|  SortChildren            |             |
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
|  Enabled                  |      X      |
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
|  Visible                  |      X      |

## TreeViewEx - Tested notification handlers

`TreeViewEx` currently offers three sets of notification handlers, each using a different approach to
managing the item collection on our side of the code.

### TreeViewEx - Tested notification handlers - Node

These are the functions in file "src\notify-node.ahk". They get the node object by calling
`TreeViewEx.Prototype.GetNode(Handle)`, which calls `TreeViewExObj.Constructor(Handle)`.

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

These are the functions in file "src\notify-node-c.ahk". They get the node object by calling
`TreeViewEx.Prototype.GetNode_C(Handle)`, which accesses `TreeViewExObj.Collection.Get(Handle)`.

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

These are the functions in file "src\notify-node-ptr.ahk". They get the node object by calling
`node := ObjFromPtrAddRef(struct.lParam)`.

|  Name                                       |  Is Tested  |
|  -------------------------------------------|-----------  |
|  TreeViewEx_HandlerBeginLabelEdit_Node_Ptr  |      X      |
|  TreeViewEx_HandlerDeleteItem_Node_Ptr      |      X      |
|  TreeViewEx_HandlerEndLabelEdit_Node_Ptr    |      X      |
|  TreeViewEx_HandlerGetDispInfo_Node_Ptr     |      X      |
|  TreeViewEx_HandlerGetInfoTip_Node_Ptr      |      X      |
|  TreeViewEx_HandlerItemChanged_Node_Ptr     |      X      |
|  TreeViewEx_HandlerItemChanging_Node_Ptr    |      X      |
|  TreeViewEx_HandlerItemExpanded_Node_Ptr    |      X      |
|  TreeViewEx_HandlerItemExpanding_Node_Ptr   |      X      |
|  TreeViewEx_HandlerSetDispInfo_Node_Ptr     |      X      |
|  TreeViewEx_HandlerSingleExpand_Node_Ptr    |             |

# TreeViewEx_Node

Each instance of `TreeViewEx_Node` has a property "Handle" which is set with the HTREEITEM handle.
This is the same value as the `ItemID` parameter used by various `TreeView` methods as described in
the [AutoHotkey documentation](https://www.autohotkey.com/docs/v2/lib/TreeView.htm). For example,
the first parameter of [TreeView.Prototype.Modify](https://www.autohotkey.com/docs/v2/lib/TreeView.htm#Modify),
expects an HTREEITEM handle. When you call a method or access a property from a `TreeViewEx_Node`
instance, in most cases it calls a function which sends a TVM message where the `wParam` or `lParam`
is expected to be an HTREEITEM handle.

## Extending TreeViewEx_Node

`TreeViewEx_Node` is intended to be extended and coupled with callback functions passed to
`TreeViewEx.Prototype.OnNotify`. This allows our code to reduce memory overhead and increase
customizability by controlling characteristics of the tree-view items dynamically.

This section needs more work and there may be some delay before I get back to writing it. Use the
[demo file](https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx/blob/main/test/demo-NotificationHandlers.ahk)
as a guide, and if something is unclear or you have a question, message
[@Cebolla](https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=170932) on
[AutoHotkey.com](https://www.autohotkey.com/boards/).


### TVN_GETDISPINFO

For [TVN_GETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-getdispinfo)
notifications, your function is expected to fill the members of the
[TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure
with the requested information. Your code does not need to calculate any of the byte offsets, this
is already done for you by the
[TvDispInfoEx](https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx/blob/main/src/TvDispInfoEx.ahk)
class. Your code can simply assign a value to the appropriate property.

[TVN_GETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-getdispinfo) is only
sent if the relevant member of a tree-view item's
[TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure
has been set with a specific value:
- The `pszText` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw)
  structure is the `LPSTR_TEXTCALLBACK` value (-1).
- The `iImage` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw)
  structure is the `I_IMAGECALLBACK` value (-1).
- The `iSelectedImage` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw)
  structure is the `I_IMAGECALLBACK` value (-1).
- The `cChildren` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw)
  structure is the `I_CHILDRENCALLBACK` value (-1).

### TVN_SETDISPINFO

[TVN_SETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-setdispinfo) is only
sent if the relevant member of a tree-view item's
[TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw) structure
has been set with a specific value. Unlike
[TVN_GETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-getdispinfo) which has
four related members, `TVN_SETDISPINFO` only has three:
- The `pszText` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw)
  structure is the `LPSTR_TEXTCALLBACK` value (-1).
- The `iImage` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw)
  structure is the `I_IMAGECALLBACK` value (-1).
- The `iSelectedImage` member of the item's [TVITEMW](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemw)
  structure is the `I_IMAGECALLBACK` value (-1).

The tree-view control sends [TVN_SETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-setdispinfo)
notifications to inform your code that an event occurred that caused a change to a characteristic
of a tree-view item. Typically the events are raised by the user's actions. The notification provides
information about what characteristic was changed, and provides the new value.

The following are the contexts in which the tree-view control sends
[TVN_SETDISPINFO](https://learn.microsoft.com/en-us/windows/win32/controls/tvn-setdispinfo):
- If the `pszText` member of the item's The user edits the label of an item (if this functionality
  is enabled for the control). The `mask` member will have the `TVIF_FLAG` set.
- An item's selected state has changed. If the item's selected state has changed from being selected
  to being not selected, the `mask` member will have the `TVIF_IMAGE` flag set. If the item's selected
  state has changed from being not selected to being selected, the `mask` member will have the
  `TVIF_SELECTEDIMAGE` flag set.

## TreeViewEx_Node: Tested methods and properties

The following is a list of methods and properties. The items with an "X" next to them have been tested.
The items with no "X" have not been tested. Most of the methods and properties probably work, but
only the marked items have been verified.

### TreeViewEx_Node: Static methods

|  Name                     |  Is Tested  |
|  -------------------------|-----------  |
|  SetChildrenHandler       |             |
|  SetNameHandler           |             |
|  SetImageHandler          |             |
|  SetSelectedImageHandler  |             |

### TreeViewEx_Node: Instance methods

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

### TreeViewEx_Node: Instance properties

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
