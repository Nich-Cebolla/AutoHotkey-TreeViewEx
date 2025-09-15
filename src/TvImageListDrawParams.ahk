

class TvImageListDrawParams extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type            Symbol      Offset                Padding
        A_PtrSize + ; DWORD         cbSize      0                     +4 on x64 only
        A_PtrSize + ; HIMAGELIST    himl        0 + A_PtrSize * 1
        A_PtrSize + ; int           i           0 + A_PtrSize * 2     +4 on x64 only
        A_PtrSize + ; HDC           hdcDst      0 + A_PtrSize * 3
        4 +         ; int           x           0 + A_PtrSize * 4
        4 +         ; int           y           4 + A_PtrSize * 4
        4 +         ; int           cx          8 + A_PtrSize * 4
        4 +         ; int           cy          12 + A_PtrSize * 4
        4 +         ; int           xBitmap     16 + A_PtrSize * 4
        4 +         ; int           yBitmap     20 + A_PtrSize * 4
        4 +         ; COLORREF      rgbBk       24 + A_PtrSize * 4
        4 +         ; COLORREF      rgbFg       28 + A_PtrSize * 4
        4 +         ; UINT          fStyle      32 + A_PtrSize * 4
        4 +         ; DWORD         dwRop       36 + A_PtrSize * 4
        4 +         ; DWORD         fState      40 + A_PtrSize * 4
        4 +         ; DWORD         Frame       44 + A_PtrSize * 4
        A_PtrSize   ; COLORREF      crEffect    48 + A_PtrSize * 4    +4 on x64 only
        proto.offset_cbSize    := 0
        proto.offset_himl      := 0 + A_PtrSize * 1
        proto.offset_i         := 0 + A_PtrSize * 2
        proto.offset_hdcDst    := 0 + A_PtrSize * 3
        proto.offset_x         := 0 + A_PtrSize * 4
        proto.offset_y         := 4 + A_PtrSize * 4
        proto.offset_cx        := 8 + A_PtrSize * 4
        proto.offset_cy        := 12 + A_PtrSize * 4
        proto.offset_xBitmap   := 16 + A_PtrSize * 4
        proto.offset_yBitmap   := 20 + A_PtrSize * 4
        proto.offset_rgbBk     := 24 + A_PtrSize * 4
        proto.offset_rgbFg     := 28 + A_PtrSize * 4
        proto.offset_fStyle    := 32 + A_PtrSize * 4
        proto.offset_dwRop     := 36 + A_PtrSize * 4
        proto.offset_fState    := 40 + A_PtrSize * 4
        proto.offset_Frame     := 44 + A_PtrSize * 4
        proto.offset_crEffect  := 48 + A_PtrSize * 4
    }
    cbSize {
        Get => NumGet(this.Buffer, this.offset_cbSize, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_cbSize)
        }
    }
    himl {
        Get => NumGet(this.Buffer, this.offset_himl, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_himl)
        }
    }
    i {
        Get => NumGet(this.Buffer, this.offset_i, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_i)
        }
    }
    hdcDst {
        Get => NumGet(this.Buffer, this.offset_hdcDst, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hdcDst)
        }
    }
    x {
        Get => NumGet(this.Buffer, this.offset_x, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_x)
        }
    }
    y {
        Get => NumGet(this.Buffer, this.offset_y, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_y)
        }
    }
    cx {
        Get => NumGet(this.Buffer, this.offset_cx, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_cx)
        }
    }
    cy {
        Get => NumGet(this.Buffer, this.offset_cy, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_cy)
        }
    }
    xBitmap {
        Get => NumGet(this.Buffer, this.offset_xBitmap, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_xBitmap)
        }
    }
    yBitmap {
        Get => NumGet(this.Buffer, this.offset_yBitmap, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_yBitmap)
        }
    }
    rgbBk {
        Get => NumGet(this.Buffer, this.offset_rgbBk, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_rgbBk)
        }
    }
    rgbFg {
        Get => NumGet(this.Buffer, this.offset_rgbFg, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_rgbFg)
        }
    }
    fStyle {
        Get => NumGet(this.Buffer, this.offset_fStyle, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_fStyle)
        }
    }
    dwRop {
        Get => NumGet(this.Buffer, this.offset_dwRop, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_dwRop)
        }
    }
    fState {
        Get => NumGet(this.Buffer, this.offset_fState, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_fState)
        }
    }
    Frame {
        Get => NumGet(this.Buffer, this.offset_Frame, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_Frame)
        }
    }
    crEffect {
        Get => NumGet(this.Buffer, this.offset_crEffect, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_crEffect)
        }
    }
}
