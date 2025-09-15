/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvItemEx extends TvItem {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type           Symbol            Offset                Padding
        A_PtrSize + ; UINT         mask              0                     +4 on x64 only
        A_PtrSize + ; HTREEITEM    hItem             0 + A_PtrSize * 1
        4 +         ; UINT         state             0 + A_PtrSize * 2
        4 +         ; UINT         stateMask         4 + A_PtrSize * 2
        A_PtrSize + ; LPWSTR       pszText           8 + A_PtrSize * 2
        4 +         ; int          cchTextMax        8 + A_PtrSize * 3
        4 +         ; int          iImage            12 + A_PtrSize * 3
        4 +         ; int          iSelectedImage    16 + A_PtrSize * 3
        4 +         ; int          cChildren         20 + A_PtrSize * 3
        A_PtrSize + ; LPARAM       lParam            24 + A_PtrSize * 3
        4 +         ; int          iIntegral         24 + A_PtrSize * 4
        4 +         ; UINT         uStateEx          28 + A_PtrSize * 4
        A_PtrSize + ; HWND         hwnd              32 + A_PtrSize * 4
        4 +         ; int          iExpandedImage    32 + A_PtrSize * 5
        4           ; int          iReserved         36 + A_PtrSize * 5
        proto.offset_mask            := 0
        proto.offset_hItem           := 0 + A_PtrSize * 1
        proto.offset_state           := 0 + A_PtrSize * 2
        proto.offset_stateMask       := 4 + A_PtrSize * 2
        proto.offset_pszText         := 8 + A_PtrSize * 2
        proto.offset_cchTextMax      := 8 + A_PtrSize * 3
        proto.offset_iImage          := 12 + A_PtrSize * 3
        proto.offset_iSelectedImage  := 16 + A_PtrSize * 3
        proto.offset_cChildren       := 20 + A_PtrSize * 3
        proto.offset_lParam          := 24 + A_PtrSize * 3
        proto.offset_iIntegral       := 24 + A_PtrSize * 4
        proto.offset_uStateEx        := 28 + A_PtrSize * 4
        proto.offset_hwnd            := 32 + A_PtrSize * 4
        proto.offset_iExpandedImage  := 32 + A_PtrSize * 5
        proto.offset_iReserved       := 36 + A_PtrSize * 5
    }
    __New(Members?) {
        this.Buffer := Buffer(this.cbSizeInstance, 0)
        this.iIntegral := 1
        if IsSet(Members) {
            b := this.Base
            while b {
                if b.HasOwnProp('StructureProps') {
                    for prop in b.StructureProps {
                        if HasProp(Members, prop) {
                            this.%prop% := Members.%prop%
                        }
                    }
                }
                b := b.Base
            }
        }
    }
    iIntegral {
        Get => NumGet(this.Buffer, this.offset_iIntegral, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iIntegral)
        }
    }
    uStateEx {
        Get => NumGet(this.Buffer, this.offset_uStateEx, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_uStateEx)
        }
    }
    hwnd {
        Get => NumGet(this.Buffer, this.offset_hwnd, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hwnd)
        }
    }
    iExpandedImage {
        Get => NumGet(this.Buffer, this.offset_iExpandedImage, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iExpandedImage)
        }
    }
    iReserved {
        Get => NumGet(this.Buffer, this.offset_iReserved, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iReserved)
        }
    }
}
