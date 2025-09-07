/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvInsertStructW {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.cbSize :=
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
        A_PtrSize + ; LPARAM       lParam            24 + A_PtrSize * 5
        4 +         ; int          iIntegral         24 + A_PtrSize * 6
        4 +         ; UINT         uStateEx          28 + A_PtrSize * 6
        A_PtrSize + ; HWND         hwnd              32 + A_PtrSize * 6
        4 +         ; int          iExpandedImage    32 + A_PtrSize * 7
        4           ; int          iReserved         36 + A_PtrSize * 7
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
        proto.offset_iIntegral       := 24 + A_PtrSize * 6
        proto.offset_uStateEx        := 28 + A_PtrSize * 6
        proto.offset_hwnd            := 32 + A_PtrSize * 6
        proto.offset_iExpandedImage  := 32 + A_PtrSize * 7
        proto.offset_iReserved       := 36 + A_PtrSize * 7

        protoItemExW := TvItemExW.Prototype
        for prop in protoItemExW.OwnProps() {
            if HasMethod(protoItemExW, prop) && !HasMethod(proto, prop) {
                proto.DefineProp(prop, protoItemExW.GetOwnPropDesc(prop))
            }
        }
        proto.DefineProp('Clone', { Call: TreeViewEx_CloneBuffer })
    }
    __New(Members?) {
        this.Buffer := Buffer(this.cbSize)
        this.iIntegral := 1
        this.hwnd := 0
        this.iReserved := 0
        proto := TvInsertStructW.Prototype
        if IsSet(Members) {
            for prop in proto.OwnProps() {
                if HasProp(Members, prop) {
                    this.%prop% := Members.%prop%
                }
            }
        }
    }
    /**
     * @description - Copies the bytes from this object's buffer to another buffer.
     *
     * @param {TvInsertStructW|Buffer|Object} [Buf] - If set, one of the following kinds of objects:
     * - A `TvInsertStructW` object.
     * - A `Buffer` object.
     * - An object with properties { Ptr, Size }.
     *
     * The size of the buffer must be at least `TvInsertStructW.Prototype.cbSize + Offset`.
     *
     * If unset, a buffer of adequate size will be created.
     *
     * @param {Integer} [Offset = 0] - The byte offset at which to copy the data. For example, if
     * `Offset == 8`, then the data will be copied to `Buf.Ptr + 8`. The first 8 bytes of the
     * new/target buffer will be unchanged.
     *
     * @param {Boolean} [MakeInstance = true] - If true, and if `Buf` is unset or is not already
     * an instance of `TvInsertStructW`, then an instance of `TvInsertStructW` will be created.
     *
     * @returns {Buffer|TvInsertStructW} - Depending on the value of `MakeInstance`, the `Buffer`
     * object or the `TvInsertStructW` object.
     *
     * @throws {Error} - "The input buffer's size is insufficient."
     */
    Clone(Buf?, Offset := 0, MakeInstance := true) {
        ; This is overridden
    }
    /**
     * @param {Integer} [InsertStyle = 1] - One of the following:
     * - 1: TVI_ROOT  - The item will be added as a root node.
     * - 2: TVI_FIRST  - The item will be added as the first child beneath the parent node.
     * - 3: TVI_LAST  - The item will be added as the last child beneath the parent node.
     * - 4: TVI_SORT  - The item will be added in alphanumeric order.
     */
    SetInsertAfter(InsertStyle := 1) {
        switch InsertStyle, 0 {
            case 1: this.hInsertAfter := TVI_ROOT
            case 2: this.hInsertAfter := TVI_FIRST
            case 3: this.hInsertAfter := TVI_LAST
            case 4: this.hInsertAfter := TVI_SORT
        }
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
            if this.__pszText == LPSTR_TEXTCALLBACKW {
                return LPSTR_TEXTCALLBACKW
            } else {
                return StrGet(this.__pszText, 'UTF-16')
            }
        }
        Set {
            if Value == LPSTR_TEXTCALLBACKW {
                this.__pszText := LPSTR_TEXTCALLBACKW
                NumPut('ptr', this.__pszText, this.Buffer, this.offset_pszText)
            } else {
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
    Ptr => this.Buffer.Ptr
    Size => this.Buffer.Size
}
