/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvItemChange extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type           Symbol       Offset               Padding
        A_PtrSize + ; HWND         hwndFrom     0
        A_PtrSize + ; UINT_PTR     idFrom       0 + A_PtrSize * 1
        A_PtrSize + ; UINT         code         0 + A_PtrSize * 2    +4 on x64 only
        A_PtrSize + ; UINT         uChanged     0 + A_PtrSize * 3    +4 on x64 only
        A_PtrSize + ; HTREEITEM    hItem        0 + A_PtrSize * 4
        4 +         ; UINT         uStateNew    0 + A_PtrSize * 5
        4 +         ; UINT         uStateOld    4 + A_PtrSize * 5
        A_PtrSize   ; LPARAM       lParam       8 + A_PtrSize * 5
        proto.offset_hwndFrom   := 0
        proto.offset_idFrom     := 0 + A_PtrSize * 1
        proto.offset_code       := 0 + A_PtrSize * 2
        proto.offset_uChanged   := 0 + A_PtrSize * 3
        proto.offset_hItem      := 0 + A_PtrSize * 4
        proto.offset_uStateNew  := 0 + A_PtrSize * 5
        proto.offset_uStateOld  := 4 + A_PtrSize * 5
        proto.offset_lParam     := 8 + A_PtrSize * 5
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
    uChanged {
        Get => NumGet(this.Buffer, this.offset_uChanged, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_uChanged)
        }
    }
    hItem {
        Get => NumGet(this.Buffer, this.offset_hItem, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hItem)
        }
    }
    uStateNew {
        Get => NumGet(this.Buffer, this.offset_uStateNew, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_uStateNew)
        }
    }
    uStateOld {
        Get => NumGet(this.Buffer, this.offset_uStateOld, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_uStateOld)
        }
    }
    lParam {
        Get => NumGet(this.Buffer, this.offset_lParam, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_lParam)
        }
    }
}
