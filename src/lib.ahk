/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

TreeViewEx_HandlerGetDispInfoW(Ctrl, lParam) {
    _tvDispInfoExW := TvDispInfoExW.FromPtr(lParam)
    if _tvDispInfoExW.mask & TVIF_TEXT {
        Ctrl.__HandlerNameGet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_IMAGE {
        Ctrl.__HandlerImageGet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_SELECTEDIMAGE {
        Ctrl.__HandlerSelectedImageGet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_CHILDREN {
        Ctrl.__HandlerChildrenGet.Call(Ctrl, _tvDispInfoExW)
    } else {
        throw Error('Unexpected ``mask`` member of ``NMTVDISPINFOW`` structure.', -1, _tvDispInfoExW.mask)
    }
}

TreeViewEx_HandlerSetDispInfoW(Ctrl, lParam) {
    _tvDispInfoExW := TvDispInfoExW.FromPtr(lParam)
    if _tvDispInfoExW.mask & TVIF_TEXT {
        Ctrl.__HandlerNameSet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_IMAGE {
        Ctrl.__HandlerImageSet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_SELECTEDIMAGE {
        Ctrl.__HandlerSelectedImageSet.Call(Ctrl, _tvDispInfoExW)
    } else {
        throw Error('Unexpected ``mask`` member of ``NMTVDISPINFOW`` structure.', -1, _tvDispInfoExW.mask)
    }
}

TreeViewEx_CloneBuffer(ObjToClone, Buf?, Offset := 0, MakeInstance := true) {
    if Offset < 0 {
        throw ValueError('``Offset`` must be a positive integer.', -1, Offset)
    }
    if IsSet(Buf) {
        if not Buf is Buffer && Type(Buf) != ObjToClone.__Class {
            throw TypeError('Invalid input parameter ``Buf``.', -1)
        }
    } else {
        Buf := Buffer(ObjToClone.Size + Offset)
    }
    if Buf.Size < ObjToClone.Size + Offset {
        throw Error('The input buffer`'s size is insufficient.', -1, Buf.Size)
    }
    DllCall(
        'msvcrt.dll\memmove'
      , 'ptr', Buf.Ptr + Offset
      , 'ptr', ObjToClone.Ptr
      , 'int', ObjToClone.Size
      , 'ptr'
    )
    if MakeInstance && Type(Buf) != ObjToClone.__Class {
        b := ObjToClone
        loop {
            if b := b.Base {
                if Type(b) = 'Prototype' {
                    break
                }
            } else {
                throw Error('Unable to identify the prototype object.', -1)
            }
        }
        if Offset {
            Obj := { Buffer: { __Buffer: Buf, Ptr: Buf.Ptr + Offset, Size: ObjToClone.Size } }
        } else {
            Obj := { Buffer: Buf }
        }
        ObjSetBase(Obj, b)
        return Obj
    } else {
        return Buf
    }
}

TreeViewEx_GetProcAddresses() {

}

TreeViewEx_SetConstants() {
    global

    TVEX_DEFAULT_ENCODING := 'cp1200'

    TV_FIRST := 0x1100

    ; TVM_INSERTITEMA            := TV_FIRST + 0
    TVM_INSERTITEMW            := TV_FIRST + 50
    ; TVM_DELETEITEM             := TV_FIRST + 1
    TVM_EXPAND                 := TV_FIRST + 2
    TVM_GETITEMRECT            := TV_FIRST + 4
    TVM_GETCOUNT               := TV_FIRST + 5
    TVM_GETINDENT              := TV_FIRST + 6
    TVM_SETINDENT              := TV_FIRST + 7
    TVM_GETIMAGELIST           := TV_FIRST + 8
    TVM_SETIMAGELIST           := TV_FIRST + 9
    TVM_GETNEXTITEM            := TV_FIRST + 10
    TVM_SELECTITEM             := TV_FIRST + 11
    ; TVM_GETITEMA               := TV_FIRST + 12
    TVM_GETITEMW               := TV_FIRST + 62
    ; TVM_SETITEMA               := TV_FIRST + 13
    TVM_SETITEMW               := TV_FIRST + 63
    ; TVM_EDITLABELA             := TV_FIRST + 14
    TVM_EDITLABELW             := TV_FIRST + 65
    TVM_GETEDITCONTROL         := TV_FIRST + 15
    TVM_GETVISIBLECOUNT        := TV_FIRST + 16
    TVM_HITTEST                := TV_FIRST + 17
    TVM_CREATEDRAGIMAGE        := TV_FIRST + 18
    TVM_SORTCHILDREN           := TV_FIRST + 19
    TVM_ENSUREVISIBLE          := TV_FIRST + 20
    TVM_SORTCHILDRENCB         := TV_FIRST + 21
    TVM_ENDEDITLABELNOW        := TV_FIRST + 22
    ; TVM_GETISEARCHSTRINGA      := TV_FIRST + 23
    TVM_GETISEARCHSTRINGW      := TV_FIRST + 64
    TVM_SETTOOLTIPS            := TV_FIRST + 24
    TVM_GETTOOLTIPS            := TV_FIRST + 25
    TVM_SETINSERTMARK          := TV_FIRST + 26
    TVM_SETITEMHEIGHT          := TV_FIRST + 27
    TVM_GETITEMHEIGHT          := TV_FIRST + 28
    TVM_SETBKCOLOR             := TV_FIRST + 29
    TVM_SETTEXTCOLOR           := TV_FIRST + 30
    TVM_GETBKCOLOR             := TV_FIRST + 31
    TVM_GETTEXTCOLOR           := TV_FIRST + 32
    TVM_SETSCROLLTIME          := TV_FIRST + 33
    TVM_GETSCROLLTIME          := TV_FIRST + 34
    TVM_SETINSERTMARKCOLOR     := TV_FIRST + 37
    TVM_GETINSERTMARKCOLOR     := TV_FIRST + 38
    TVM_SETBORDER              := TV_FIRST + 35
    TVM_GETITEMSTATE           := TV_FIRST + 39
    TVM_SETLINECOLOR           := TV_FIRST + 40
    TVM_GETLINECOLOR           := TV_FIRST + 41
    TVM_MAPACCIDTOHTREEITEM    := TV_FIRST + 42
    TVM_MAPHTREEITEMTOACCID    := TV_FIRST + 43
    TVM_SETEXTENDEDSTYLE       := TV_FIRST + 44
    TVM_GETEXTENDEDSTYLE       := TV_FIRST + 45
    TVM_SETAUTOSCROLLINFO      := TV_FIRST + 59
    ; TVM_SETHOT                 := TV_FIRST + 58
    ; TVM_GETSELECTEDCOUNT       := TV_FIRST + 70
    TVM_SHOWINFOTIP            := TV_FIRST + 71

    TVN_FIRST                  := -400
    TVN_LAST                   := -499

    ; TVN_SELCHANGINGW           := TVN_FIRST - 50
    ; TVN_SELCHANGEDW            := TVN_FIRST - 51
    TVN_GETDISPINFOW           := TVN_FIRST - 52
    TVN_SETDISPINFOW           := TVN_FIRST - 53
    ; TVN_ITEMEXPANDINGW         := TVN_FIRST - 54
    ; TVN_ITEMEXPANDEDW          := TVN_FIRST - 55
    ; TVN_BEGINDRAGW             := TVN_FIRST - 56
    ; TVN_BEGINRDRAGW            := TVN_FIRST - 57
    ; TVN_DELETEITEMW            := TVN_FIRST - 58
    ; TVN_BEGINLABELEDITW        := TVN_FIRST - 59
    ; TVN_ENDLABELEDITW          := TVN_FIRST - 60
    ; TVN_KEYDOWN                := TVN_FIRST - 12
    ; TVN_GETINFOTIPW            := TVN_FIRST - 14
    ; TVN_SINGLEEXPAND           := TVN_FIRST - 15
    ; TVN_ITEMCHANGINGW          := TVN_FIRST - 17
    ; TVN_ITEMCHANGEDW           := TVN_FIRST - 19
    ; TVN_ASYNCDRAW              := TVN_FIRST - 20

    ; TVN_SELCHANGINGA           := TVN_FIRST - 1
    ; TVN_SELCHANGEDA            := TVN_FIRST - 2
    ; TVN_GETDISPINFOA           := TVN_FIRST - 3
    ; TVN_SETDISPINFOA           := TVN_FIRST - 4
    ; TVN_ITEMEXPANDINGA         := TVN_FIRST - 5
    ; TVN_ITEMEXPANDEDA          := TVN_FIRST - 6
    ; TVN_BEGINDRAGA             := TVN_FIRST - 7
    ; TVN_BEGINRDRAGA            := TVN_FIRST - 8
    ; TVN_DELETEITEMA            := TVN_FIRST - 9
    ; TVN_BEGINLABELEDITA        := TVN_FIRST - 10
    ; TVN_ENDLABELEDITA          := TVN_FIRST - 11
    ; TVN_GETINFOTIPA            := TVN_FIRST - 13
    ; TVN_ITEMCHANGINGA          := TVN_FIRST - 16
    ; TVN_ITEMCHANGEDA           := TVN_FIRST - 18

    TVIF_DI_SETITEM            := 0x1000

    TVNRET_DEFAULT             := 0
    TVNRET_SKIPOLD             := 1
    TVNRET_SKIPNEW             := 2

    TVC_UNKNOWN                := 0x0000
    TVC_BYMOUSE                := 0x0001
    TVC_BYKEYBOARD             := 0x0002

    TVE_COLLAPSE               := 0x0001
    TVE_EXPAND                 := 0x0002
    TVE_TOGGLE                 := 0x0003
    TVE_EXPANDPARTIAL          := 0x4000
    TVE_COLLAPSERESET          := 0x8000

    TVI_ROOT                   := -0x10000
    TVI_FIRST                  := -0x0FFFF
    TVI_LAST                   := -0x0FFFE
    TVI_SORT                   := -0x0FFFD

    TVSIL_NORMAL               := 0
    TVSIL_STATE                := 2

    TVGN_ROOT                  := 0x0000
    TVGN_NEXT                  := 0x0001
    TVGN_PREVIOUS              := 0x0002
    TVGN_PARENT                := 0x0003
    TVGN_CHILD                 := 0x0004
    TVGN_FIRSTVISIBLE          := 0x0005
    TVGN_NEXTVISIBLE           := 0x0006
    TVGN_PREVIOUSVISIBLE       := 0x0007
    TVGN_DROPHILITE            := 0x0008
    TVGN_CARET                 := 0x0009
    TVGN_LASTVISIBLE           := 0x000A
    TVGN_NEXTSELECTED          := 0x000B

    ; TVSI_NOSINGLEEXPAND        := 0x8000

    TVIF_TEXT                  := 0x0001
    TVIF_IMAGE                 := 0x0002
    TVIF_PARAM                 := 0x0004
    TVIF_STATE                 := 0x0008
    TVIF_HANDLE                := 0x0010
    TVIF_SELECTEDIMAGE         := 0x0020
    TVIF_CHILDREN              := 0x0040
    TVIF_INTEGRAL              := 0x0080
    TVIF_STATEEX               := 0x0100
    TVIF_EXPANDEDIMAGE         := 0x0200

    TVHT_NOWHERE               := 0x0001
    TVHT_ONITEMICON            := 0x0002
    TVHT_ONITEMLABEL           := 0x0004
    TVHT_ONITEMINDENT          := 0x0008
    TVHT_ONITEMBUTTON          := 0x0010
    TVHT_ONITEMRIGHT           := 0x0020
    TVHT_ONITEMSTATEICON       := 0x0040
    TVHT_ABOVE                 := 0x0100
    TVHT_BELOW                 := 0x0200
    TVHT_TORIGHT               := 0x0400
    TVHT_TOLEFT                := 0x0800
    TVHT_ONITEM                := TVHT_ONITEMICON | TVHT_ONITEMLABEL | TVHT_ONITEMSTATEICON

    TVSBF_XBORDER              := 0x00000001
    TVSBF_YBORDER              := 0x00000002

    TVS_HASBUTTONS             := 0x0001
    TVS_HASLINES               := 0x0002
    TVS_LINESATROOT            := 0x0004
    TVS_EDITLABELS             := 0x0008
    TVS_DISABLEDRAGDROP        := 0x0010
    TVS_SHOWSELALWAYS          := 0x0020
    TVS_RTLREADING             := 0x0040
    TVS_NOTOOLTIPS             := 0x0080
    TVS_CHECKBOXES             := 0x0100
    TVS_TRACKSELECT            := 0x0200
    TVS_SINGLEEXPAND           := 0x0400
    TVS_INFOTIP                := 0x0800
    TVS_FULLROWSELECT          := 0x1000
    TVS_NOSCROLL               := 0x2000
    TVS_NONEVENHEIGHT          := 0x4000
    TVS_NOHSCROLL              := 0x8000

    TVS_EX_NOSINGLECOLLAPSE    := 0x0001
    TVS_EX_MULTISELECT         := 0x0002
    TVS_EX_DOUBLEBUFFER        := 0x0004
    TVS_EX_NOINDENTSTATE       := 0x0008
    TVS_EX_RICHTOOLTIP         := 0x0010
    TVS_EX_AUTOHSCROLL         := 0x0020
    TVS_EX_FADEINOUTEXPANDOS   := 0x0040
    TVS_EX_PARTIALCHECKBOXES   := 0x0080
    TVS_EX_EXCLUSIONCHECKBOXES := 0x0100
    TVS_EX_DIMMEDCHECKBOXES    := 0x0200
    TVS_EX_DRAWIMAGEASYNC      := 0x0400

    TVIS_SELECTED              := 0x0002
    TVIS_CUT                   := 0x0004
    TVIS_DROPHILITED           := 0x0008
    TVIS_BOLD                  := 0x0010
    TVIS_EXPANDED              := 0x0020
    TVIS_EXPANDEDONCE          := 0x0040
    TVIS_EXPANDPARTIAL         := 0x0080
    TVIS_OVERLAYMASK           := 0x0F00
    TVIS_STATEIMAGEMASK        := 0xF000
    TVIS_USERMASK              := 0xF000
    TVIS_EX_FLAT               := 0x0001
    TVIS_EX_DISABLED           := 0x0002
    TVIS_EX_ALL                := 0x0002

    I_CHILDRENCALLBACK         := -1
    I_CHILDRENAUTO             := -2

    CLR_NONE                   := 0xFFFFFFFF
    CLR_DEFAULT                := 0xFF000000

    LPSTR_TEXTCALLBACKW        := -1
}
