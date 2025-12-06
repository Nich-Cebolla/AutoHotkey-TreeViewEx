/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvItem extends TreeViewExStructBase {
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
        proto.__pszText := ''
    }
    GetStateImageIndex() {
        return (this.state & TVIS_STATEIMAGEMASK) >> 12
    }
    SetBold(Value := true) {
        this.mask := this.mask | TVIF_STATE
        if Value {
            this.state := this.state | TVIS_BOLD
        }
        this.stateMask := this.stateMask | TVIS_BOLD
    }
    SetChecked(Value := true) {
        this.SetStateImage(Value ? 2 : 1)
    }
    SetExpand(Value := true) {
        this.mask := this.mask | TVIF_STATE
        if Value {
            this.state := this.state | TVIS_EXPANDED
        }
        this.stateMask := this.stateMask | TVIS_EXPANDED
    }
    SetTextBuffer(Bytes := TVEX_DEFAULT_TEXT_MAX * 2) {
        this.__pszText := Buffer(Bytes)
        this.cchTextMax := Floor(Bytes / 2)
        NumPut('ptr', this.__pszText.Ptr, this.Buffer, this.offset_pszText)
    }
    SetSelected(Value := true) {
        this.mask := this.mask | TVIF_STATE
        if Value {
            this.state := this.state | TVIS_SELECTED
        }
        this.stateMask := this.stateMask | TVIS_SELECTED
    }
    SetStateImage(Index) {
        if Index < 0 || Index > 15 {
            throw ValueError('Invalid index.', -1, Index)
        }
        this.mask := this.mask | TVIF_STATE
        this.stateMask := this.stateMask | TVIS_STATEIMAGEMASK
        this.state := (this.state & ~TVIS_STATEIMAGEMASK) | (index << 12)
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
        Get {
            Value := NumGet(this.Buffer, this.offset_pszText, 'ptr')
            if Value > 0 {
                return StrGet(Value, TVEX_DEFAULT_ENCODING)
            } else {
                return Value
            }
        }
        Set {
            if Value == LPSTR_TEXTCALLBACKW {
                NumPut('ptr', Value, this.Buffer, this.offset_pszText)
            } else {
                if ptr := NumGet(this.Buffer, this.offset_pszText, 'ptr') {
                    if this.__pszText {
                        bytes := StrPut(Value, TVEX_DEFAULT_ENCODING)
                        if bytes > this.__pszText.Size {
                            this.__pszText.Size := bytes
                            ptr := this.__pszText.Ptr
                            NumPut('ptr', ptr, this.Buffer, this.offset_pszText)
                        }
                    }
                } else {
                    this.__pszText := Buffer(StrPut(Value, TVEX_DEFAULT_ENCODING))
                    ptr := this.__pszText.Ptr
                    NumPut('ptr', ptr, this.Buffer, this.offset_pszText)
                }
                if chars := this.cchTextMax {
                    StrPut(SubStr(Value, 1, chars - 1), ptr, TVEX_DEFAULT_ENCODING)
                } else {
                    StrPut(Value, ptr, TVEX_DEFAULT_ENCODING)
                }
            }
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
}
