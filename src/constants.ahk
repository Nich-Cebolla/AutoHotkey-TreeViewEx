
/**
 * Sets the global constant variables.
 *
 * @param {Boolean} [force = false] - When false, if `TreeViewEx_SetConstants` has already been called
 * (more specifically, if `tvex_flag_constants_set` has been set), the function returns immediately.
 * If true, the function executes in its entirety.
 */
TreeViewEx_SetConstants(force := false) {
    global
    if IsSet(tvex_flag_constants_set) && !force {
        return
    }
    g_proc_comctl32_DefSubclassProc :=
    g_proc_gdi32_CreateFontIndirectW :=
    g_proc_gdi32_DeleteObject :=
    g_proc_gdi32_GetObjectW :=
    g_proc_msvcrt_memmove :=
    g_proc_user32_CreateWindowExW :=
    g_proc_user32_DestroyWindow :=
    g_proc_user32_GetDpiForWindow :=
    g_proc_user32_RedrawWindow :=
    0

    TreeViewEx.LibToken := LibraryManager(Map(
        'comctl32', [ 'DefSubclassProc' ]
      , 'msvcrt', [ 'memmove' ]
      , 'user32', [ 'CreateWindowExW', 'DestroyWindow', 'GetDpiForWindow', 'RedrawWindow' ]
      , 'gdi32', [ 'CreateFontIndirectW', 'GetObjectW', 'DeleteObject' ]
    ))

	TVEX_DEFAULT_ENCODING                       := 'cp1200'
    TVEX_DEFAULT_TEXT_MAX                       := 256

	TV_FIRST                                    := 0x1100
	TVN_FIRST                                   := -400
	TVN_LAST                                    := -499

    ; https://learn.microsoft.com/en-us/windows/win32/controls/bumper-tree-view-tree-view-control-reference
	TVM_CREATEDRAGIMAGE                         := TV_FIRST + 18
	TVM_DELETEITEM                              := TV_FIRST + 1
	TVM_EDITLABELW                              := TV_FIRST + 65
	TVM_ENDEDITLABELNOW                         := TV_FIRST + 22
	TVM_ENSUREVISIBLE                           := TV_FIRST + 20
	TVM_EXPAND                                  := TV_FIRST + 2
	TVM_GETBKCOLOR                              := TV_FIRST + 31
	TVM_GETCOUNT                                := TV_FIRST + 5
	TVM_GETEDITCONTROL                          := TV_FIRST + 15
	TVM_GETEXTENDEDSTYLE                        := TV_FIRST + 45
	TVM_GETIMAGELIST                            := TV_FIRST + 8
	TVM_GETINDENT                               := TV_FIRST + 6
	TVM_GETINSERTMARKCOLOR                      := TV_FIRST + 38
	TVM_GETISEARCHSTRINGW                       := TV_FIRST + 64
	TVM_GETITEMHEIGHT                           := TV_FIRST + 28
	TVM_GETITEMRECT                             := TV_FIRST + 4
	TVM_GETITEMSTATE                            := TV_FIRST + 39
	TVM_GETITEMW                                := TV_FIRST + 62
	TVM_GETLINECOLOR                            := TV_FIRST + 41
	TVM_GETNEXTITEM                             := TV_FIRST + 10
	TVM_GETSCROLLTIME                           := TV_FIRST + 34
	TVM_GETSELECTEDCOUNT                        := TV_FIRST + 70
	TVM_GETTEXTCOLOR                            := TV_FIRST + 32
	TVM_GETTOOLTIPS                             := TV_FIRST + 25
	TVM_GETVISIBLECOUNT                         := TV_FIRST + 16
	TVM_HITTEST                                 := TV_FIRST + 17
	TVM_INSERTITEMW                             := TV_FIRST + 50
	TVM_MAPACCIDTOHTREEITEM                     := TV_FIRST + 42
	TVM_MAPHTREEITEMTOACCID                     := TV_FIRST + 43
	TVM_SELECTITEM                              := TV_FIRST + 11
	TVM_SETAUTOSCROLLINFO                       := TV_FIRST + 59
	TVM_SETBKCOLOR                              := TV_FIRST + 29
	TVM_SETBORDER                               := TV_FIRST + 35
	TVM_SETEXTENDEDSTYLE                        := TV_FIRST + 44
	TVM_SETHOT                                  := TV_FIRST + 58
	TVM_SETIMAGELIST                            := TV_FIRST + 9
	TVM_SETINDENT                               := TV_FIRST + 7
	TVM_SETINSERTMARK                           := TV_FIRST + 26
	TVM_SETINSERTMARKCOLOR                      := TV_FIRST + 37
	TVM_SETITEMHEIGHT                           := TV_FIRST + 27
	TVM_SETITEMW                                := TV_FIRST + 63
	TVM_SETLINECOLOR                            := TV_FIRST + 40
	TVM_SETSCROLLTIME                           := TV_FIRST + 33
	TVM_SETTEXTCOLOR                            := TV_FIRST + 30
	TVM_SETTOOLTIPS                             := TV_FIRST + 24
	TVM_SHOWINFOTIP                             := TV_FIRST + 71
	TVM_SORTCHILDREN                            := TV_FIRST + 19
	TVM_SORTCHILDRENCB                          := TV_FIRST + 21

	; TVM_EDITLABELA                              := TV_FIRST + 14
	; TVM_GETISEARCHSTRINGA                       := TV_FIRST + 23
	; TVM_GETITEMA                                := TV_FIRST + 12
	; TVM_INSERTITEMA                             := TV_FIRST + 0
	; TVM_SETITEMA                                := TV_FIRST + 13

    ; https://learn.microsoft.com/en-us/windows/win32/controls/bumper-tree-view-control-reference-notifications
    ; TVN_ and NM_ messages are all sent via WM_NOTIFY, use `TreeViewEx.Prototype.OnNotify`.
	TVN_ASYNCDRAW                               := TVN_FIRST - 20
	TVN_BEGINDRAGW                              := TVN_FIRST - 56
	TVN_BEGINLABELEDITW                         := TVN_FIRST - 59
	TVN_BEGINRDRAGW                             := TVN_FIRST - 57
	TVN_DELETEITEMW                             := TVN_FIRST - 58
	TVN_ENDLABELEDITW                           := TVN_FIRST - 60
	TVN_GETDISPINFOW                            := TVN_FIRST - 52
	TVN_GETINFOTIPW                             := TVN_FIRST - 14
	TVN_ITEMCHANGEDW                            := TVN_FIRST - 19
	TVN_ITEMCHANGINGW                           := TVN_FIRST - 17
	TVN_ITEMEXPANDEDW                           := TVN_FIRST - 55
	TVN_ITEMEXPANDINGW                          := TVN_FIRST - 54
	TVN_KEYDOWN                                 := TVN_FIRST - 12
	TVN_SELCHANGEDW                             := TVN_FIRST - 51
	TVN_SELCHANGINGW                            := TVN_FIRST - 50
	TVN_SETDISPINFOW                            := TVN_FIRST - 53
	TVN_SINGLEEXPAND                            := TVN_FIRST - 15

    ; TVN_ and NM_ messages are all sent via WM_NOTIFY, use `TreeViewEx.Prototype.OnNotify`.
    NM_FIRST                                    := 0

    NM_OUTOFMEMORY                              := NM_FIRST - 1
    NM_CLICK                                    := NM_FIRST - 2    ; uses NMCLICK struct
    NM_DBLCLK                                   := NM_FIRST - 3
    NM_RETURN                                   := NM_FIRST - 4
    NM_RCLICK                                   := NM_FIRST - 5    ; uses NMCLICK struct
    NM_RDBLCLK                                  := NM_FIRST - 6
    NM_SETFOCUS                                 := NM_FIRST - 7
    NM_KILLFOCUS                                := NM_FIRST - 8
    NM_CUSTOMDRAW                               := NM_FIRST - 12
    NM_HOVER                                    := NM_FIRST - 13
    NM_NCHITTEST                                := NM_FIRST - 14   ; uses NMMOUSE struct
    NM_KEYDOWN                                  := NM_FIRST - 15   ; uses NMKEY struct
    NM_RELEASEDCAPTURE                          := NM_FIRST - 16
    NM_SETCURSOR                                := NM_FIRST - 17   ; uses NMMOUSE struct
    NM_CHAR                                     := NM_FIRST - 18   ; uses NMCHAR struct
    NM_TOOLTIPSCREATED                          := NM_FIRST - 19   ; notify of when the tooltips window is create
    NM_LDOWN                                    := NM_FIRST - 20
    NM_RDOWN                                    := NM_FIRST - 21
    NM_THEMECHANGED                             := NM_FIRST - 22
    NM_FONTCHANGED                              := NM_FIRST - 23
    NM_CUSTOMTEXT                               := NM_FIRST - 24   ; uses NMCUSTOMTEXT struct
    NM_TVSTATEIMAGECHANGING                     := NM_FIRST - 24   ; uses NMTVSTATEIMAGECHANGING struct, defined after HTREEITEM

	; TVN_BEGINDRAGA                              := TVN_FIRST - 7
	; TVN_BEGINLABELEDITA                         := TVN_FIRST - 10
	; TVN_BEGINRDRAGA                             := TVN_FIRST - 8
	; TVN_DELETEITEMA                             := TVN_FIRST - 9
	; TVN_ENDLABELEDITA                           := TVN_FIRST - 11
	; TVN_GETDISPINFOA                            := TVN_FIRST - 3
	; TVN_GETINFOTIPA                             := TVN_FIRST - 13
	; TVN_ITEMCHANGEDA                            := TVN_FIRST - 18
	; TVN_ITEMCHANGINGA                           := TVN_FIRST - 16
	; TVN_ITEMEXPANDEDA                           := TVN_FIRST - 6
	; TVN_ITEMEXPANDINGA                          := TVN_FIRST - 5
	; TVN_SELCHANGEDA                             := TVN_FIRST - 2
	; TVN_SELCHANGINGA                            := TVN_FIRST - 1
	; TVN_SETDISPINFOA                            := TVN_FIRST - 4

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvn-singleexpand
	TVNRET_DEFAULT                              := 0
	TVNRET_SKIPOLD                              := 1
	TVNRET_SKIPNEW                              := 2

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvn-selchanged
	TVC_UNKNOWN                                 := 0x0000
	TVC_BYMOUSE                                 := 0x0001
	TVC_BYKEYBOARD                              := 0x0002

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvm-expand
	TVE_COLLAPSE                                := 0x0001
	TVE_EXPAND                                  := 0x0002
	TVE_TOGGLE                                  := 0x0003
	TVE_EXPANDPARTIAL                           := 0x4000
	TVE_COLLAPSERESET                           := 0x8000

    ; https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvinsertstructw
	TVI_FIRST                                   := -0x0FFFF
	TVI_LAST                                    := -0x0FFFE
	TVI_ROOT                                    := -0x10000
	TVI_SORT                                    := -0x0FFFD

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setimagelist
	TVSIL_NORMAL                                := 0
	TVSIL_STATE                                 := 2

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvm-getnextitem
    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvm-selectitem
	TVGN_CARET                                  := 0x0009
	TVGN_CHILD                                  := 0x0004
	TVGN_DROPHILITE                             := 0x0008
	TVGN_FIRSTVISIBLE                           := 0x0005
	TVGN_LASTVISIBLE                            := 0x000A
	TVGN_NEXT                                   := 0x0001
	TVGN_NEXTSELECTED                           := 0x000B
	TVGN_NEXTVISIBLE                            := 0x0006
	TVGN_PARENT                                 := 0x0003
	TVGN_PREVIOUS                               := 0x0002
	TVGN_PREVIOUSVISIBLE                        := 0x0007
	TVGN_ROOT                                   := 0x0000
	TVSI_NOSINGLEEXPAND                         := 0x8000

	; https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemexa
	TVIF_CHILDREN                               := 0x0040
	TVIF_DI_SETITEM                             := 0x1000
	TVIF_EXPANDEDIMAGE                          := 0x0200
	TVIF_HANDLE                                 := 0x0010
	TVIF_IMAGE                                  := 0x0002
	TVIF_INTEGRAL                               := 0x0080
	TVIF_PARAM                                  := 0x0004
	TVIF_SELECTEDIMAGE                          := 0x0020
	TVIF_STATE                                  := 0x0008
	TVIF_STATEEX                                := 0x0100
	TVIF_TEXT                                   := 0x0001

    ; https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvhittestinfo
	TVHT_ABOVE                                  := 0x0100
	TVHT_BELOW                                  := 0x0200
	TVHT_NOWHERE                                := 0x0001
	TVHT_ONITEMBUTTON                           := 0x0010
	TVHT_ONITEMICON                             := 0x0002
	TVHT_ONITEMINDENT                           := 0x0008
	TVHT_ONITEMLABEL                            := 0x0004
	TVHT_ONITEMRIGHT                            := 0x0020
	TVHT_ONITEMSTATEICON                        := 0x0040
	TVHT_TOLEFT                                 := 0x0800
	TVHT_TORIGHT                                := 0x0400
	TVHT_ONITEM                                 := TVHT_ONITEMICON | TVHT_ONITEMLABEL | TVHT_ONITEMSTATEICON

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setborder
	TVSBF_XBORDER                               := 0x00000001
	TVSBF_YBORDER                               := 0x00000002

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tree-view-control-window-styles
	TVS_CHECKBOXES                              := 0x0100
	TVS_DISABLEDRAGDROP                         := 0x0010
	TVS_EDITLABELS                              := 0x0008
	TVS_FULLROWSELECT                           := 0x1000
	TVS_HASBUTTONS                              := 0x0001
	TVS_HASLINES                                := 0x0002
	TVS_INFOTIP                                 := 0x0800
	TVS_LINESATROOT                             := 0x0004
	TVS_NOHSCROLL                               := 0x8000
	TVS_NONEVENHEIGHT                           := 0x4000
	TVS_NOSCROLL                                := 0x2000
	TVS_NOTOOLTIPS                              := 0x0080
	TVS_RTLREADING                              := 0x0040
	TVS_SHOWSELALWAYS                           := 0x0020
	TVS_SINGLEEXPAND                            := 0x0400
	TVS_TRACKSELECT                             := 0x0200

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tree-view-control-window-extended-styles
	TVS_EX_AUTOHSCROLL                          := 0x0020
	TVS_EX_DIMMEDCHECKBOXES                     := 0x0200
	TVS_EX_DOUBLEBUFFER                         := 0x0004
	TVS_EX_DRAWIMAGEASYNC                       := 0x0400
	TVS_EX_EXCLUSIONCHECKBOXES                  := 0x0100
	TVS_EX_FADEINOUTEXPANDOS                    := 0x0040
	TVS_EX_MULTISELECT                          := 0x0002
	TVS_EX_NOINDENTSTATE                        := 0x0008
	TVS_EX_NOSINGLECOLLAPSE                     := 0x0001
	TVS_EX_PARTIALCHECKBOXES                    := 0x0080
	TVS_EX_RICHTOOLTIP                          := 0x0010

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tree-view-control-item-states
	TVIS_BOLD                                   := 0x0010
	TVIS_CUT                                    := 0x0004
	TVIS_DROPHILITED                            := 0x0008
	TVIS_EXPANDED                               := 0x0020
	TVIS_EXPANDEDONCE                           := 0x0040
	TVIS_EXPANDPARTIAL                          := 0x0080
	TVIS_OVERLAYMASK                            := 0x0F00
	TVIS_SELECTED                               := 0x0002
	TVIS_STATEIMAGEMASK                         := 0xF000
	TVIS_USERMASK                               := 0xF000

    ; https://learn.microsoft.com/en-us/windows/win32/api/commctrl/ns-commctrl-tvitemexw
	TVIS_EX_FLAT                                := 0x0001
	TVIS_EX_DISABLED                            := 0x0002
	TVIS_EX_ALL                                 := 0x0002 ; TVIS_EX_ALL == TVIS_EX_DISABLED
    ; None of my header files contain TVIS_EX_HWND, not sure where it is defined

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvn-getdispinfo
	I_CHILDRENCALLBACK                          := -1
	I_CHILDRENAUTO                              := -2
	LPSTR_TEXTCALLBACKW                         := -1
	I_IMAGECALLBACK                             := -1
	I_IMAGENONE                                 := -2

    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvm-getlinecolor
    ; https://learn.microsoft.com/en-us/windows/win32/controls/tvm-setlinecolor
	CLR_NONE                                    := 0xFFFFFFFF
	CLR_DEFAULT                                 := 0xFF000000

    ; https://learn.microsoft.com/en-us/windows/win32/winmsg/window-styles
	WS_BORDER                                   := 0x00800000
	WS_CAPTION                                  := 0x00C00000
	WS_CHILD                                    := 0x40000000
	WS_CHILDWINDOW                              := 0x40000000
	WS_CLIPCHILDREN                             := 0x02000000
	WS_CLIPSIBLINGS                             := 0x04000000
	WS_DISABLED                                 := 0x08000000
	WS_DLGFRAME                                 := 0x00400000
	WS_GROUP                                    := 0x00020000
	WS_HSCROLL                                  := 0x00100000
	WS_ICONIC                                   := 0x20000000
	WS_MAXIMIZE                                 := 0x01000000
	WS_MAXIMIZEBOX                              := 0x00010000
	WS_MINIMIZE                                 := 0x20000000
	WS_MINIMIZEBOX                              := 0x00020000
	WS_OVERLAPPED                               := 0x00000000
	WS_POPUP                                    := 0x80000000
	WS_SIZEBOX                                  := 0x00040000
	WS_SYSMENU                                  := 0x00080000
	WS_TABSTOP                                  := 0x00010000
	WS_THICKFRAME                               := 0x00040000
	WS_TILED                                    := 0x00000000
	WS_VISIBLE                                  := 0x10000000
	WS_VSCROLL                                  := 0x00200000
	WS_POPUPWINDOW                              := WS_POPUP | WS_BORDER | WS_SYSMENU
	WS_TILEDWINDOW                              := WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX
	WS_OVERLAPPEDWINDOW                         := WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX

    ; https://learn.microsoft.com/en-us/windows/win32/winmsg/extended-window-styles
	WS_EX_ACCEPTFILES                           := 0x00000010
	WS_EX_APPWINDOW                             := 0x00040000
	WS_EX_CLIENTEDGE                            := 0x00000200
	WS_EX_COMPOSITED                            := 0x02000000
	WS_EX_CONTEXTHELP                           := 0x00000400
	WS_EX_CONTROLPARENT                         := 0x00010000
	WS_EX_DLGMODALFRAME                         := 0x00000001
	WS_EX_LAYERED                               := 0x00080000
	WS_EX_LAYOUTRTL                             := 0x00400000
	WS_EX_LEFT                                  := 0x00000000
	WS_EX_LEFTSCROLLBAR                         := 0x00004000
	WS_EX_LTRREADING                            := 0x00000000
	WS_EX_MDICHILD                              := 0x00000040
	WS_EX_NOACTIVATE                            := 0x08000000
	WS_EX_NOINHERITLAYOUT                       := 0x00100000
	WS_EX_NOPARENTNOTIFY                        := 0x00000004
	WS_EX_NOREDIRECTIONBITMAP                   := 0x00200000
	WS_EX_RIGHT                                 := 0x00001000
	WS_EX_RIGHTSCROLLBAR                        := 0x00000000
	WS_EX_RTLREADING                            := 0x00002000
	WS_EX_STATICEDGE                            := 0x00020000
	WS_EX_TOOLWINDOW                            := 0x00000080
	WS_EX_TOPMOST                               := 0x00000008
	WS_EX_TRANSPARENT                           := 0x00000020
	WS_EX_WINDOWEDGE                            := 0x00000100
	WS_EX_OVERLAPPEDWINDOW                      := WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE
	WS_EX_PALETTEWINDOW                         := WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST

    ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-createwindowexw
	CW_USEDEFAULT                               := 0x80000000

    ; https://learn.microsoft.com/en-us/windows/win32/menurc/wm-command
    WM_COMMAND                                  := 0x0111
    ; https://learn.microsoft.com/en-us/windows/win32/controls/wm-notify
    WM_NOTIFY                                   := 0x004E
    ; https://learn.microsoft.com/en-us/windows/win32/menurc/wm-contextmenu
    WM_CONTEXTMENU                              := 0x007B
    ; https://learn.microsoft.com/en-us/windows/win32/controls/wm-hscroll
    WM_HSCROLL                                  := 0x0114
    ; https://learn.microsoft.com/en-us/windows/win32/controls/wm-vscroll
    WM_VSCROLL                                  := 0x0115
    ; https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-destroy
    WM_DESTROY                                  := 0x0002
    ; https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-close
    WM_CLOSE                                    := 0x0010
    ; https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-ncdestroy
    WM_NCDESTROY                                := 0x0082
    ; If the user clicks the "X" to close the gui window
    ; https://learn.microsoft.com/en-us/windows/win32/menurc/wm-syscommand
    WM_SYSCOMMAND                               := 0x0112
    SC_CLOSE                                    := 0xF060
    ; https://learn.microsoft.com/en-us/windows/win32/gdi/wm-setredraw
    WM_SETREDRAW                                := 0x000B
    ; https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-getfont
    WM_GETFONT                                  := 0x0031
    ; https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-setfont
    WM_SETFONT                                  := 0x0030

    ; https://learn.microsoft.com/en-us/windows/win32/api/Winuser/nf-winuser-redrawwindow
    RDW_INVALIDATE                              := 0x0001
    RDW_INTERNALPAINT                           := 0x0002
    RDW_ERASE                                   := 0x0004
    RDW_VALIDATE                                := 0x0008
    RDW_NOINTERNALPAINT                         := 0x0010
    RDW_NOERASE                                 := 0x0020
    RDW_NOCHILDREN                              := 0x0040
    RDW_ALLCHILDREN                             := 0x0080
    RDW_UPDATENOW                               := 0x0100
    RDW_ERASENOW                                := 0x0200
    RDW_FRAME                                   := 0x0400
    RDW_NOFRAME                                 := 0x0800

    ; Messages sent when editing a tree-view item's label, not currently implemented.
    ; EN_SETFOCUS                                 := 0x0100
    ; EN_KILLFOCUS                                := 0x0200
    ; EN_CHANGE                                   := 0x0300
    ; EN_UPDATE                                   := 0x0400
    ; EN_ERRSPACE                                 := 0x0500
    ; EN_MAXTEXT                                  := 0x0501
    ; EN_HSCROLL                                  := 0x0601
    ; EN_VSCROLL                                  := 0x0602

    ; These are messages that might be sent to the tree-view control. Handling messages to the tree-view
    ; control is not implemented currently.
    ; Message                     Value        Description                                   Purpose
    ; WM_CHAR                                     := 0x0102     ; Translated key input (character).             Hotkey text entry, search filtering, rename activation.
    ; WM_CONTEXTMENU                              := 0x007B     ; Right-click menu trigger.                     Override context menu position or contents.
    ; WM_CREATE                                   := 0x0001     ; Sent when control is being created.           Initialize custom data, fonts, or subclass child edit control.
    ; WM_DPICHANGED                               := 0x02E0     ; Monitor DPI changed.                          Recompute item spacing, icons.
    ; WM_ENABLE                                   := 0x000A     ; Control enabled/disabled.                     Repaint to show disabled state.
    ; WM_ERASEBKGND                               := 0x0014     ; Erase background before paint.                Return nonzero to prevent flicker (double-buffering).
    ; WM_GETDLGCODE                               := 0x0087     ; Query input handling.                         Allow Enter/Tab to behave differently.
    ; WM_GETOBJECT                                := 0x003D     ; Accessibility (UIA/MSAA).                     Let default handler process this or accessibility breaks.
    ; WM_HITTEST                                  := 0x0084     ; Non-client hit test (rare).                   Custom resizing, border drag.
    ; WM_KEYDOWN                                  := 0x0100     ; A key pressed.                                Custom shortcuts (e.g. Delete key behavior).
    ; WM_KEYUP                                    := 0x0101     ; A key released.                               Often ignored.
    ; WM_KILLFOCUS                                := 0x0008     ; TreeView loses focus.                         Clear hover/selection highlight.
    ; WM_LBUTTONDBLCLK                            := 0x0203     ; Double-click.                                 Suppress expansion or override default behavior.
    ; WM_LBUTTONDOWN                              := 0x0201     ; Left click pressed/released.                  Custom drag-drop, selection tweaks, hit-testing.
    ; WM_LBUTTONUP                                := 0x0202     ; Left click pressed/released.                  Custom drag-drop, selection tweaks, hit-testing.
    ; WM_MOUSEHOVER                               := 0x02A1     ; Hover state tracking.                         Show custom tooltip or highlight node.
    ; WM_MOUSELEAVE                               := 0x02A3     ; Hover state tracking.                         Show custom tooltip or highlight node.
    ; WM_MOUSEMOVE                                := 0x0200     ; Mouse moved.                                  Hover effects, tooltips, auto-scroll.
    ; WM_MOUSEWHEEL                               := 0x020A     ; Wheel scrolled.                               Custom scroll behavior (e.g., zoom or horizontal scroll).
    ; WM_MOVE                                     := 0x0003     ; Control moved.                                Update coordinate-dependent resources.
    ; WM_NCDESTROY                                := 0x0082     ; Window non-client area destroyed.             Clean up subclass pointers (you usually restore old WndProc here).
    ; WM_NOTIFYFORMAT                             := 0x0055     ; Unicode/ANSI negotiation.                     Return NFR_UNICODE to force Unicode notifications.
    ; WM_PAINT                                    := 0x000F     ; Paints the control.                           Owner-draw / custom background or highlight logic.
    ; WM_PRINT                                    := 0x0317     ; Used by system for Print/Preview.             Usually ignored.
    ; WM_PRINTCLIENT                              := 0x0318     ; Used by system for Print/Preview.             Usually ignored.
    ; WM_RBUTTONDOWN                              := 0x0204     ; Right-click.                                  Custom context menus, multi-select.
    ; WM_RBUTTONUP                                := 0x0205     ; Right-click.                                  Custom context menus, multi-select.
    ; WM_SETCURSOR                                := 0x0020     ; Mouse cursor moves over control.              Custom cursor per region/item.
    ; WM_SETFOCUS                                 := 0x0007     ; TreeView gains focus.                         Custom highlight or state behavior.
    ; WM_SIZE                                     := 0x0005     ; TreeView resized.                             Recalculate layout, reposition overlay elements.
    ; WM_STYLECHANGED                             := 0x007D     ; Window style modified.                        Respond to checkboxes, lines, root toggling.
    ; WM_STYLECHANGING                            := 0x007C     ; Window style modified.                        Respond to checkboxes, lines, root toggling.
    ; WM_SYSKEYDOWN                               := 0x0104     ; Alt key combinations.                         Custom menu accelerators.
    ; WM_SYSKEYUP                                 := 0x0105     ; Alt key combinations.                         Custom menu accelerators.
    ; WM_THEMECHANGED                             := 0x031A     ; Theme or visual style changed.                Re-query theme data (UXTheme).
    ; WM_TIMER                                    := 0x0113     ; Used internally by hover-select / scroll.     Avoid interfering unless you own the timer ID.
    ; WM_WINDOWPOSCHANGED                         := 0x0047     ; Z-order / position changes.                   Adjust or lock layout behavior.
    ; WM_WINDOWPOSCHANGING                        := 0x0046     ; Z-order / position changes.                   Adjust or lock layout behavior.

    ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw
	OUT_CHARACTER_PRECIS                        := 2
	OUT_DEFAULT_PRECIS                          := 0
	OUT_DEVICE_PRECIS                           := 5
	OUT_OUTLINE_PRECIS                          := 8
	OUT_PS_ONLY_PRECIS                          := 10
	OUT_RASTER_PRECIS                           := 6
	OUT_SCREEN_OUTLINE_PRECIS                   := 9
	OUT_STRING_PRECIS                           := 1
	OUT_STROKE_PRECIS                           := 3
	OUT_TT_ONLY_PRECIS                          := 7
	OUT_TT_PRECIS                               := 4

    ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw
	CLIP_CHARACTER_PRECIS                       := 1
	CLIP_DEFAULT_PRECIS                         := 0
	CLIP_DFA_DISABLE                            := 4 << 4
	CLIP_EMBEDDED                               := 8 << 4
	CLIP_LH_ANGLES                              := 1 << 4
	CLIP_MASK                                   := 0xf
	CLIP_STROKE_PRECIS                          := 2
	CLIP_TT_ALWAYS                              := 2 << 4

    ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw
	ANTIALIASED_QUALITY                         := 4
	DEFAULT_QUALITY                             := 0
	DRAFT_QUALITY                               := 1
	NONANTIALIASED_QUALITY                      := 3
	PROOF_QUALITY                               := 2

    ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw
	CLEARTYPE_NATURAL_QUALITY                   := 6
	CLEARTYPE_QUALITY                           := 5

    ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw
	DEFAULT_PITCH                               := 0
	FIXED_PITCH                                 := 1
	MONO_FONT                                   := 8
	VARIABLE_PITCH                              := 2

    ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw
	ANSI_CHARSET                                := 0
	ARABIC_CHARSET                              := 178
	CHINESEBIG5_CHARSET                         := 136
	DEFAULT_CHARSET                             := 1
	EASTEUROPE_CHARSET                          := 238
	GB2312_CHARSET                              := 134
	GREEK_CHARSET                               := 161
	HANGEUL_CHARSET                             := 129
	HANGUL_CHARSET                              := 129
	HEBREW_CHARSET                              := 177
	JOHAB_CHARSET                               := 130
	OEM_CHARSET                                 := 255
	RUSSIAN_CHARSET                             := 204
	SHIFTJIS_CHARSET                            := 128
	SYMBOL_CHARSET                              := 2
	THAI_CHARSET                                := 222
	TURKISH_CHARSET                             := 162
	VIETNAMESE_CHARSET                          := 163
	BALTIC_CHARSET                              := 186
	MAC_CHARSET                                 := 77

    ; https://learn.microsoft.com/en-us/windows/win32/intl/code-page-bitfields
	FS_LATIN1                                   := 0x00000001
	FS_LATIN2                                   := 0x00000002
	FS_CYRILLIC                                 := 0x00000004
	FS_GREEK                                    := 0x00000008
	FS_TURKISH                                  := 0x00000010
	FS_HEBREW                                   := 0x00000020
	FS_ARABIC                                   := 0x00000040
	FS_BALTIC                                   := 0x00000080
	FS_VIETNAMESE                               := 0x00000100
	FS_THAI                                     := 0x00010000
	FS_JISJAPAN                                 := 0x00020000
	FS_CHINESESIMP                              := 0x00040000
	FS_WANSUNG                                  := 0x00080000
	FS_CHINESETRAD                              := 0x00100000
	FS_JOHAB                                    := 0x00200000
	FS_SYMBOL                                   := 0x80000000

    ; https://learn.microsoft.com/en-us/windows/win32/api/dimm/ns-dimm-logfontw
	FF_DECORATIVE                               := 0x50 ; 80    Old English, etc.
	FF_DONTCARE                                 := 0x00 ; 0     Don't care or don't know.
	FF_MODERN                                   := 0x30 ; 48    Constant stroke width, serifed or sans-serifed. Pica, Elite, Courier, etc.
	FF_ROMAN                                    := 0x10 ; 16    Variable stroke width, serifed. Times Roman, Century Schoolbook, etc.
	FF_SCRIPT                                   := 0x40 ; 64    Cursive, etc.
	FF_SWISS                                    := 0x20 ; 32    Variable stroke width, sans-serifed. Helvetica, Swiss, etc.

    ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw
	FW_BOLD                                     := 700
	FW_DONTCARE                                 := 0
	FW_EXTRABOLD                                := 800
	FW_EXTRALIGHT                               := 200
	FW_HEAVY                                    := 900
	FW_LIGHT                                    := 300
	FW_MEDIUM                                   := 500
	FW_NORMAL                                   := 400
	FW_SEMIBOLD                                 := 600
	FW_THIN                                     := 100
	FW_BLACK                                    := FW_HEAVY
	FW_DEMIBOLD                                 := FW_SEMIBOLD
	FW_REGULAR                                  := FW_NORMAL
	FW_ULTRABOLD                                := FW_EXTRABOLD
	FW_ULTRALIGHT                               := FW_EXTRALIGHT

    ; https://learn.microsoft.com/en-us/windows/win32/gdi/enumerating-the-installed-fonts
	RASTER_FONTTYPE                             := 0x0001
	DEVICE_FONTTYPE                             := 0x0002
	TRUETYPE_FONTTYPE                           := 0x0004

    tvex_flag_constants_set := 1
}
