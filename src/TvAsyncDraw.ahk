

class TvAsyncDraw extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type                     Symbol            Offset               Padding
        A_PtrSize + ; HWND                   hwndFrom          0
        A_PtrSize + ; UINT_PTR               idFrom            0 + A_PtrSize * 1
        A_PtrSize + ; UINT                   code              0 + A_PtrSize * 2    +4 on x64 only
        A_PtrSize + ; IMAGELISTDRAWPARAMS    *pimldp           0 + A_PtrSize * 3
        A_PtrSize + ; HRESULT                hr                0 + A_PtrSize * 4    +4 on x64 only
        A_PtrSize + ; HTREEITEM              hItem             0 + A_PtrSize * 5
        A_PtrSize + ; LPARAM                 lParam            0 + A_PtrSize * 6
        4 +         ; DWORD                  dwRetFlags        0 + A_PtrSize * 7
        4           ; int                    iRetImageIndex    4 + A_PtrSize * 7
        proto.offset_hwndFrom        := 0
        proto.offset_idFrom          := 0 + A_PtrSize * 1
        proto.offset_code            := 0 + A_PtrSize * 2
        proto.offset_pimldp         := 0 + A_PtrSize * 3
        proto.offset_hr              := 0 + A_PtrSize * 4
        proto.offset_hItem           := 0 + A_PtrSize * 5
        proto.offset_lParam          := 0 + A_PtrSize * 6
        proto.offset_dwRetFlags      := 0 + A_PtrSize * 7
        proto.offset_iRetImageIndex  := 4 + A_PtrSize * 7
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
    pimldp {
        Get {
            if !this.HasOwnProp('__pimldp') {
                this.__pimldp := TvImageListDrawParams.FromPtr(NumGet(this.Buffer, this.offset_pimldp, 'ptr'))
            }
            return this.__pimldp
        }
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_pimldp)
            if Value {
                this.__pimldp := TvImageListDrawParams.FromPtr(Value)
            }
        }
    }
    hr {
        Get => NumGet(this.Buffer, this.offset_hr, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_hr)
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
    dwRetFlags {
        Get => NumGet(this.Buffer, this.offset_dwRetFlags, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_dwRetFlags)
        }
    }
    iRetImageIndex {
        Get => NumGet(this.Buffer, this.offset_iRetImageIndex, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_iRetImageIndex)
        }
    }
}
