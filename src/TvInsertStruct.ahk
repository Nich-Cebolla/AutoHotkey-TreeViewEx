/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvInsertStruct extends TvItem {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type           Symbol            Offset                Padding
        A_PtrSize + ; HTREEITEM    hParent           0
        A_PtrSize + ; HTREEITEM    hInsertAfter      0 + A_PtrSize * 1
        A_PtrSize + ; UINT         mask              0 + A_PtrSize * 2     +4 on x64 only
        A_PtrSize + ; HTREEITEM    hItem             0 + A_PtrSize * 3
        4 +         ; UINT         state             0 + A_PtrSize * 4
        4 +         ; UINT         stateMask         4 + A_PtrSize * 4
        A_PtrSize + ; LPWSTR       pszText           8 + A_PtrSize * 4
        4 +         ; int          cchTextMax        8 + A_PtrSize * 5
        4 +         ; int          iImage            12 + A_PtrSize * 5
        4 +         ; int          iSelectedImage    16 + A_PtrSize * 5
        4 +         ; int          cChildren         20 + A_PtrSize * 5
        A_PtrSize   ; LPARAM       lParam            24 + A_PtrSize * 5
        proto.offset_hParent         := 0
        proto.offset_hInsertAfter    := 0 + A_PtrSize * 1
        proto.offset_mask            := 0 + A_PtrSize * 2
        proto.offset_hItem           := 0 + A_PtrSize * 3
        proto.offset_state           := 0 + A_PtrSize * 4
        proto.offset_stateMask       := 4 + A_PtrSize * 4
        proto.offset_pszText         := 8 + A_PtrSize * 4
        proto.offset_cchTextMax      := 8 + A_PtrSize * 5
        proto.offset_iImage          := 12 + A_PtrSize * 5
        proto.offset_iSelectedImage  := 16 + A_PtrSize * 5
        proto.offset_cChildren       := 20 + A_PtrSize * 5
        proto.offset_lParam          := 24 + A_PtrSize * 5
    }
    hParent {
        Get => NumGet(this.Buffer, this.offset_hParent, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hParent)
        }
    }
    hInsertAfter {
        Get => NumGet(this.Buffer, this.offset_hInsertAfter, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hInsertAfter)
        }
    }
}
