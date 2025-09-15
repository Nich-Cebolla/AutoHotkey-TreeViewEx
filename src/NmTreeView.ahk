/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class NmTreeView extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type           Symbol                Offset                 Padding
        A_PtrSize + ; HWND         hwndFrom              0
        A_PtrSize + ; UINT_PTR     idFrom                0 + A_PtrSize * 1
        A_PtrSize + ; UINT         code                  0 + A_PtrSize * 2      +4 on x64 only
        A_PtrSize + ; UINT         action                0 + A_PtrSize * 3      +4 on x64 only
        A_PtrSize + ; UINT         mask_old              0 + A_PtrSize * 4      +4 on x64 only
        A_PtrSize + ; HTREEITEM    hItem_old             0 + A_PtrSize * 5
        4 +         ; UINT         state_old             0 + A_PtrSize * 6
        4 +         ; UINT         stateMask_old         4 + A_PtrSize * 6
        A_PtrSize + ; LPWSTR       pszText_old           8 + A_PtrSize * 6
        4 +         ; int          cchTextMax_old        8 + A_PtrSize * 7
        4 +         ; int          iImage_old            12 + A_PtrSize * 7
        4 +         ; int          iSelectedImage_old    16 + A_PtrSize * 7
        4 +         ; int          cChildren_old         20 + A_PtrSize * 7
        A_PtrSize + ; LPARAM       lParam_old            24 + A_PtrSize * 7
        A_PtrSize + ; UINT         mask_new              24 + A_PtrSize * 8     +4 on x64 only
        A_PtrSize + ; HTREEITEM    hItem_new             24 + A_PtrSize * 9
        4 +         ; UINT         state_new             24 + A_PtrSize * 10
        4 +         ; UINT         stateMask_new         28 + A_PtrSize * 10
        A_PtrSize + ; LPWSTR       pszText_new           32 + A_PtrSize * 10
        4 +         ; int          cchTextMax_new        32 + A_PtrSize * 11
        4 +         ; int          iImage_new            36 + A_PtrSize * 11
        4 +         ; int          iSelectedImage_new    40 + A_PtrSize * 11
        4 +         ; int          cChildren_new         44 + A_PtrSize * 11
        A_PtrSize + ; LPARAM       lParam_new            48 + A_PtrSize * 11
        4 +         ; LONG         x                     48 + A_PtrSize * 12
        4           ; LONG         y                     52 + A_PtrSize * 12
        proto.offset_hwndFrom            := 0
        proto.offset_idFrom              := 0 + A_PtrSize * 1
        proto.offset_code                := 0 + A_PtrSize * 2
        proto.offset_action              := 0 + A_PtrSize * 3
        proto.offset_mask_old            := 0 + A_PtrSize * 4
        proto.offset_hItem_old           := 0 + A_PtrSize * 5
        proto.offset_state_old           := 0 + A_PtrSize * 6
        proto.offset_stateMask_old       := 4 + A_PtrSize * 6
        proto.offset_pszText_old         := 8 + A_PtrSize * 6
        proto.offset_cchTextMax_old      := 8 + A_PtrSize * 7
        proto.offset_iImage_old          := 12 + A_PtrSize * 7
        proto.offset_iSelectedImage_old  := 16 + A_PtrSize * 7
        proto.offset_cChildren_old       := 20 + A_PtrSize * 7
        proto.offset_lParam_old          := 24 + A_PtrSize * 7
        proto.offset_mask_new            := 24 + A_PtrSize * 8
        proto.offset_hItem_new           := 24 + A_PtrSize * 9
        proto.offset_state_new           := 24 + A_PtrSize * 10
        proto.offset_stateMask_new       := 28 + A_PtrSize * 10
        proto.offset_pszText_new         := 32 + A_PtrSize * 10
        proto.offset_cchTextMax_new      := 32 + A_PtrSize * 11
        proto.offset_iImage_new          := 36 + A_PtrSize * 11
        proto.offset_iSelectedImage_new  := 40 + A_PtrSize * 11
        proto.offset_cChildren_new       := 44 + A_PtrSize * 11
        proto.offset_lParam_new          := 48 + A_PtrSize * 11
        proto.offset_x                   := 48 + A_PtrSize * 12
        proto.offset_y                   := 52 + A_PtrSize * 12
    }
    hwndFrom {
        Get => NumGet(this.Buffer, this.offset_hwndFrom, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hwndFrom)
        }
    }
    idFrom {
        Get => NumGet(this.Buffer, this.offset_idFrom, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_idFrom)
        }
    }
    code {
        Get => NumGet(this.Buffer, this.offset_code, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_code)
        }
    }
    code_int {
        Get => NumGet(this.Buffer, this.offset_code, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_code)
        }
    }
    action {
        Get => NumGet(this.Buffer, this.offset_action, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_action)
        }
    }
    mask_old {
        Get => NumGet(this.Buffer, this.offset_mask_old, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_mask_old)
        }
    }
    hItem_old {
        Get => NumGet(this.Buffer, this.offset_hItem_old, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hItem_old)
        }
    }
    state_old {
        Get => NumGet(this.Buffer, this.offset_state_old, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_state_old)
        }
    }
    stateMask_old {
        Get => NumGet(this.Buffer, this.offset_stateMask_old, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_stateMask_old)
        }
    }
    pszText_old {
        Get {
            Value := NumGet(this.Buffer, this.offset_pszText_old, 'ptr')
            if Value > 0 {
                return StrGet(Value, TVEX_DEFAULT_ENCODING)
            } else {
                return Value
            }
        }
        Set {
            if Type(Value) = 'String' {
                if !this.HasOwnProp('__pszText_old')
                || (this.__pszText_old is Buffer && this.__pszText_old.Size < StrPut(Value, TVEX_DEFAULT_ENCODING)) {
                    this.__pszText_old := Buffer(StrPut(Value, TVEX_DEFAULT_ENCODING))
                    NumPut('ptr', this.__pszText_old.Ptr, this.Buffer, this.offset_pszText_old)
                }
                StrPut(Value, this.__pszText_old, TVEX_DEFAULT_ENCODING)
            } else if Value is Buffer {
                this.__pszText_old := Value
                NumPut('ptr', this.__pszText_old.Ptr, this.Buffer, this.offset_pszText_old)
            } else {
                this.__pszText_old := Value
                NumPut('ptr', this.__pszText_old, this.Buffer, this.offset_pszText_old)
            }
        }
    }
    cchTextMax_old {
        Get => NumGet(this.Buffer, this.offset_cchTextMax_old, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_cchTextMax_old)
        }
    }
    iImage_old {
        Get => NumGet(this.Buffer, this.offset_iImage_old, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iImage_old)
        }
    }
    iSelectedImage_old {
        Get => NumGet(this.Buffer, this.offset_iSelectedImage_old, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iSelectedImage_old)
        }
    }
    cChildren_old {
        Get => NumGet(this.Buffer, this.offset_cChildren_old, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_cChildren_old)
        }
    }
    lParam_old {
        Get => NumGet(this.Buffer, this.offset_lParam_old, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_lParam_old)
        }
    }
    mask_new {
        Get => NumGet(this.Buffer, this.offset_mask_new, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_mask_new)
        }
    }
    hItem_new {
        Get => NumGet(this.Buffer, this.offset_hItem_new, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hItem_new)
        }
    }
    state_new {
        Get => NumGet(this.Buffer, this.offset_state_new, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_state_new)
        }
    }
    stateMask_new {
        Get => NumGet(this.Buffer, this.offset_stateMask_new, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_stateMask_new)
        }
    }
    pszText_new {
        Get {
            Value := NumGet(this.Buffer, this.offset_pszText_new, 'ptr')
            if Value > 0 {
                return StrGet(Value, TVEX_DEFAULT_ENCODING)
            } else {
                return Value
            }
        }
        Set {
            if Type(Value) = 'String' {
                if !this.HasOwnProp('__pszText_new')
                || (this.__pszText_new is Buffer && this.__pszText_new.Size < StrPut(Value, TVEX_DEFAULT_ENCODING)) {
                    this.__pszText_new := Buffer(StrPut(Value, TVEX_DEFAULT_ENCODING))
                    NumPut('ptr', this.__pszText_new.Ptr, this.Buffer, this.offset_pszText_new)
                }
                StrPut(Value, this.__pszText_new, TVEX_DEFAULT_ENCODING)
            } else if Value is Buffer {
                this.__pszText_new := Value
                NumPut('ptr', this.__pszText_new.Ptr, this.Buffer, this.offset_pszText_new)
            } else {
                this.__pszText_new := Value
                NumPut('ptr', this.__pszText_new, this.Buffer, this.offset_pszText_new)
            }
        }
    }
    cchTextMax_new {
        Get => NumGet(this.Buffer, this.offset_cchTextMax_new, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_cchTextMax_new)
        }
    }
    iImage_new {
        Get => NumGet(this.Buffer, this.offset_iImage_new, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iImage_new)
        }
    }
    iSelectedImage_new {
        Get => NumGet(this.Buffer, this.offset_iSelectedImage_new, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iSelectedImage_new)
        }
    }
    cChildren_new {
        Get => NumGet(this.Buffer, this.offset_cChildren_new, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_cChildren_new)
        }
    }
    lParam_new {
        Get => NumGet(this.Buffer, this.offset_lParam_new, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_lParam_new)
        }
    }
    x {
        Get => NumGet(this.Buffer, this.offset_x, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_x)
        }
    }
    y {
        Get => NumGet(this.Buffer, this.offset_y, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_y)
        }
    }
}
