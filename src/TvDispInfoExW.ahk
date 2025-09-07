/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvDispInfoExW {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.cbSize :=
        ; Size      Type           Symbol            Offset                Padding
        A_PtrSize + ; HWND         hwndFrom          0
        4 +         ; UINT         idFrom            0 + A_PtrSize * 1
        4 +         ; UINT         code              4 + A_PtrSize * 1
        A_PtrSize + ; UINT         mask              8 + A_PtrSize * 1     +4 on x64 only
        A_PtrSize + ; HTREEITEM    hItem             8 + A_PtrSize * 2
        4 +         ; UINT         state             8 + A_PtrSize * 3
        4 +         ; UINT         stateMask         12 + A_PtrSize * 3
        A_PtrSize + ; LPWSTR       pszText           16 + A_PtrSize * 3
        4 +         ; int          cchTextMax        16 + A_PtrSize * 4
        4 +         ; int          iImage            20 + A_PtrSize * 4
        4 +         ; int          iSelectedImage    24 + A_PtrSize * 4
        4 +         ; int          cChildren         28 + A_PtrSize * 4
        A_PtrSize   ; LPARAM       lParam            32 + A_PtrSize * 4
        proto.offset_hwndFrom        := 0
        proto.offset_idFrom          := 0 + A_PtrSize * 1
        proto.offset_code            := 4 + A_PtrSize * 1
        proto.offset_mask            := 8 + A_PtrSize * 1
        proto.offset_hItem           := 8 + A_PtrSize * 2
        proto.offset_state           := 8 + A_PtrSize * 3
        proto.offset_stateMask       := 12 + A_PtrSize * 3
        proto.offset_pszText         := 16 + A_PtrSize * 3
        proto.offset_cchTextMax      := 16 + A_PtrSize * 4
        proto.offset_iImage          := 20 + A_PtrSize * 4
        proto.offset_iSelectedImage  := 24 + A_PtrSize * 4
        proto.offset_cChildren       := 28 + A_PtrSize * 4
        proto.offset_lParam          := 32 + A_PtrSize * 4

        proto.DefineProp('Clone', { Call: TreeViewEx_CloneBuffer })
    }
    static FromPtr(Ptr) {
        _tvDispInfoExW := { Buffer: { Ptr: Ptr, Size: this.Prototype.cbSize } }
        ObjSetBase(_tvDispInfoExW, this.Prototype)
        return _tvDispInfoExW
    }
    __New(Members?) {
        this.Buffer := Buffer(this.cbSize)
        this.iIntegral := 1
        this.hwnd := 0
        this.iReserved := 0
        proto := TvDispInfoExW.Prototype
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
     * @param {TvDispInfoExW|Buffer|Object} [Buf] - If set, one of the following kinds of objects:
     * - A `TvDispInfoExW` object.
     * - A `Buffer` object.
     * - An object with properties { Ptr, Size }.
     *
     * The size of the buffer must be at least `TvDispInfoExW.Prototype.cbSize + Offset`.
     *
     * If unset, a buffer of adequate size will be created.
     *
     * @param {Integer} [Offset = 0] - The byte offset at which to copy the data. For example, if
     * `Offset == 8`, then the data will be copied to `Buf.Ptr + 8`. The first 8 bytes of the
     * new/target buffer will be unchanged.
     *
     * @param {Boolean} [MakeInstance = true] - If true, and if `Buf` is unset or is not already
     * an instance of `TvDispInfoExW`, then an instance of `TvDispInfoExW` will be created.
     *
     * @returns {Buffer|TvDispInfoExW} - Depending on the value of `MakeInstance`, the `Buffer`
     * object or the `TvDispInfoExW` object.
     *
     * @throws {Error} - "The input buffer's size is insufficient."
     */
    Clone(Buf?, Offset := 0, MakeInstance := true) {
        ; This is overridden
    }
    hwndFrom {
        Get => NumGet(this.Buffer, this.offset_hwndFrom, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hwndFrom)
        }
    }
    idFrom {
        Get => NumGet(this.Buffer, this.offset_idFrom, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_idFrom)
        }
    }
    code {
        Get => NumGet(this.Buffer, this.offset_code, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_code)
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
    Ptr => this.Buffer.Ptr
    Size => this.Buffer.Size
}
