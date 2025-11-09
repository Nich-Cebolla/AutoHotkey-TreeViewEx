
/**
 * Used to handle NM_CUSTOMDRAW notifications.
 */
class NmTvCustomDraw extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type           Symbol         Offset                Padding
        A_PtrSize + ; HWND         hwndFrom       0
        A_PtrSize + ; UINT_PTR     idFrom         0 + A_PtrSize * 1
        A_PtrSize + ; UINT         code           0 + A_PtrSize * 2     +4 on x64 only
        A_PtrSize + ; DWORD        dwDrawStage    0 + A_PtrSize * 3     +4 on x64 only
        A_PtrSize + ; HDC          hdc            0 + A_PtrSize * 4
        4 +         ; INT          left           0 + A_PtrSize * 5
        4 +         ; INT          top            4 + A_PtrSize * 5
        4 +         ; INT          right          8 + A_PtrSize * 5
        4 +         ; INT          bottom         12 + A_PtrSize * 5
        A_PtrSize + ; DWORD_PTR    dwItemSpec     16 + A_PtrSize * 5
        A_PtrSize + ; UINT         uItemState     16 + A_PtrSize * 6    +4 on x64 only
        A_PtrSize + ; LPARAM       lItemlParam    16 + A_PtrSize * 7
        4 +         ; COLORREF     clrText        16 + A_PtrSize * 8
        4 +         ; COLORREF     clrTextBk      20 + A_PtrSize * 8
        A_PtrSize   ; int          iLevel         24 + A_PtrSize * 8    +4 on x64 only
        proto.offset_hwndFrom     := 0
        proto.offset_idFrom       := 0 + A_PtrSize * 1 8
        proto.offset_code         := 0 + A_PtrSize * 2 16
        proto.offset_dwDrawStage  := 0 + A_PtrSize * 3 24
        proto.offset_hdc          := 0 + A_PtrSize * 4 32
        proto.offset_left         := 0 + A_PtrSize * 5 40
        proto.offset_top          := 4 + A_PtrSize * 5 44
        proto.offset_right        := 8 + A_PtrSize * 5 48
        proto.offset_bottom       := 12 + A_PtrSize * 5 52
        proto.offset_dwItemSpec   := 16 + A_PtrSize * 5 56
        proto.offset_uItemState   := 16 + A_PtrSize * 6 64
        proto.offset_lItemlParam  := 16 + A_PtrSize * 7 72
        proto.offset_clrText      := 16 + A_PtrSize * 8 80
        proto.offset_clrTextBk    := 20 + A_PtrSize * 8 84
        proto.offset_iLevel       := 24 + A_PtrSize * 8 88
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
        Get => NumGet(this.Buffer, this.offset_code, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_code)
        }
    }
    dwDrawStage {
        Get => NumGet(this.Buffer, this.offset_dwDrawStage, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_dwDrawStage)
        }
    }
    hdc {
        Get => NumGet(this.Buffer, this.offset_hdc, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hdc)
        }
    }
    left {
        Get => NumGet(this.Buffer, this.offset_left, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_left)
        }
    }
    top {
        Get => NumGet(this.Buffer, this.offset_top, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_top)
        }
    }
    right {
        Get => NumGet(this.Buffer, this.offset_right, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_right)
        }
    }
    bottom {
        Get => NumGet(this.Buffer, this.offset_bottom, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_bottom)
        }
    }
    dwItemSpec {
        Get => NumGet(this.Buffer, this.offset_dwItemSpec, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_dwItemSpec)
        }
    }
    uItemState {
        Get => NumGet(this.Buffer, this.offset_uItemState, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_uItemState)
        }
    }
    lItemlParam {
        Get => NumGet(this.Buffer, this.offset_lItemlParam, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_lItemlParam)
        }
    }
    clrText {
        Get => NumGet(this.Buffer, this.offset_clrText, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_clrText)
        }
    }
    clrTextBk {
        Get => NumGet(this.Buffer, this.offset_clrTextBk, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_clrTextBk)
        }
    }
    iLevel {
        Get => NumGet(this.Buffer, this.offset_iLevel, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iLevel)
        }
    }
    Ptr => this.Buffer.Ptr
    Size => this.Buffer.Size
}
