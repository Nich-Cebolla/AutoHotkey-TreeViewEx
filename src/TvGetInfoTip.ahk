/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvGetInfoTip extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type           Symbol        Offset               Padding
        A_PtrSize + ; HWND         hwndFrom      0
        A_PtrSize + ; UINT_PTR     idFrom        0 + A_PtrSize * 1
        A_PtrSize + ; UINT         code          0 + A_PtrSize * 2    +4 on x64 only
        A_PtrSize + ; LPWSTR       pszText       0 + A_PtrSize * 3
        A_PtrSize + ; int          cchTextMax    0 + A_PtrSize * 4    +4 on x64 only
        A_PtrSize + ; HTREEITEM    hItem         0 + A_PtrSize * 5
        A_PtrSize   ; LPARAM       lParam        0 + A_PtrSize * 6
        proto.offset_hwndFrom    := 0
        proto.offset_idFrom      := 0 + A_PtrSize * 1
        proto.offset_code        := 0 + A_PtrSize * 2
        proto.offset_pszText     := 0 + A_PtrSize * 3
        proto.offset_cchTextMax  := 0 + A_PtrSize * 4
        proto.offset_hItem       := 0 + A_PtrSize * 5
        proto.offset_lParam      := 0 + A_PtrSize * 6

        proto.__pszText := ''
    }
    SetTextBuffer(Bytes := TVEX_DEFAULT_TEXT_MAX) {
        this.__pszText := Buffer(Bytes)
        this.cchTextMax := Floor(Bytes / 2)
        NumPut('ptr', this.__pszText.Ptr, this.Buffer, this.offset_pszText)
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
    cchTextMax {
        Get => NumGet(this.Buffer, this.offset_cchTextMax, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_cchTextMax)
        }
    }
    hItem {
        Get => NumGet(this.Buffer, this.offset_hItem, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hItem)
        }
    }
    lParam {
        Get => NumGet(this.Buffer, this.offset_lParam, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_lParam)
        }
    }
}
