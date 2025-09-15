/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvSortCb extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type              Symbol         Offset               Padding
        A_PtrSize + ; HTREEITEM       hParent        0
        A_PtrSize + ; PFNTVCOMPARE    lpfnCompare    0 + A_PtrSize * 1
        A_PtrSize   ; LPARAM          lParam         0 + A_PtrSize * 2
        proto.offset_hParent      := 0
        proto.offset_lpfnCompare  := 0 + A_PtrSize * 1
        proto.offset_lParam       := 0 + A_PtrSize * 2
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
}
