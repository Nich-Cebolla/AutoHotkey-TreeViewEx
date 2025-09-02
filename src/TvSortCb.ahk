class TvSortCb {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.cbSize :=
        ; Size      Type              Symbol         Offset               Padding
        A_PtrSize + ; HTREEITEM       hParent        0
        A_PtrSize + ; PFNTVCOMPARE    lpfnCompare    0 + A_PtrSize * 1
        A_PtrSize   ; LPARAM          lParam         0 + A_PtrSize * 2
        proto.offset_hParent := 0
        proto.offset_lpfnCompare := 0 + A_PtrSize * 1
        proto.offset_lParam := 0 + A_PtrSize * 2
    }
    __New(hParent?, lpfnCompare?, lParam?) {
        this.Buffer := Buffer(this.cbSize)
        if IsSet(hParent) {
            this.hParent := hParent
        }
        if IsSet(lpfnCompare) {
            this.lpfnCompare := lpfnCompare
        }
        if IsSet(lParam) {
            this.lParam := lParam
        }
    }
    hParent {
        Get => NumGet(this.Buffer, this.offset_hParent, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hParent)
        }
    }
    lpfnCompare {
        Get => NumGet(this.Buffer, this.offset_lpfnCompare, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_lpfnCompare)
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
