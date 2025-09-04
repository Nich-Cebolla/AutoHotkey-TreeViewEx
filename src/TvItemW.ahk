
class TvItemW {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.cbSize :=
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
        A_PtrSize   ; LPARAM       lParam            24 + A_PtrSize * 3
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
    }
    __New(Members?) {
        this.Buffer := Buffer(this.cbSize)
        proto := TvItemW.Prototype
        if IsSet(Members) {
            for prop in proto.OwnProps() {
                if HasProp(Members, prop) {
                    this.%prop% := Members.%prop%
                }
            }
        }
    }
    mask {
        Get => NumGet(this.Buffer, this.offset_mask, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_mask)
        }
    }
    hItem {
        Get => NumGet(this.Buffer, this.offset_hItem, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hItem)
        }
    }
    state {
        Get => NumGet(this.Buffer, this.offset_state, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_state)
        }
    }
    stateMask {
        Get => NumGet(this.Buffer, this.offset_stateMask, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_stateMask)
        }
    }
    pszText {
        Get => StrGet(this.__pszText, 'UTF-16')
        Set {
            if this.HasOwnProp('__pszText') {
                bytes := StrPut(Value, 'UTF-16')
                if this.__pszText.Size < bytes {
                    this.__pszText.Size := bytes
                    NumPut('ptr', this.__pszText.Ptr, this.Buffer, this.offset_pszText)
                }
            } else {
                this.__pszText := Buffer(StrPut(Value, 'UTF-16'))
                NumPut('ptr', this.__pszText.Ptr, this.Buffer, this.offset_pszText)
            }
            StrPut(Value, this.__pszText, 'UTF-16')
        }
    }
    cchTextMax {
        Get => NumGet(this.Buffer, this.offset_cchTextMax, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_cchTextMax)
        }
    }
    iImage {
        Get => NumGet(this.Buffer, this.offset_iImage, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iImage)
        }
    }
    iSelectedImage {
        Get => NumGet(this.Buffer, this.offset_iSelectedImage, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iSelectedImage)
        }
    }
    cChildren {
        Get => NumGet(this.Buffer, this.offset_cChildren, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_cChildren)
        }
    }
    lParam {
        Get => NumGet(this.Buffer, this.offset_lParam, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_lParam)
        }
    }
    Ptr => this.Buffer.Ptr
    Size => this.Buffer.Size
}
