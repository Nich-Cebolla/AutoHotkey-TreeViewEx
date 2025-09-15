/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvKeyDown extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type          Symbol      Offset               Padding
        A_PtrSize + ; HWND        hwndFrom    0
        A_PtrSize + ; UINT_PTR    idFrom      0 + A_PtrSize * 1
        A_PtrSize + ; UINT        code        0 + A_PtrSize * 2    +4 on x64 only
        2 + 2 +     ; WORD        wVKey       0 + A_PtrSize * 3    + 2
        4           ; UINT        flags       4 + A_PtrSize * 3
        proto.offset_hwndFrom  := 0
        proto.offset_idFrom    := 0 + A_PtrSize * 1
        proto.offset_code      := 0 + A_PtrSize * 2
        proto.offset_wVKey     := 0 + A_PtrSize * 3
        proto.offset_flags     := 4 + A_PtrSize * 3
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
    wVKey {
        Get => NumGet(this.Buffer, this.offset_wVKey, 'ushort')
        Set {
            NumPut('ushort', Value, this.Buffer, this.offset_wVKey)
        }
    }
    flags {
        Get => NumGet(this.Buffer, this.offset_flags, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_flags)
        }
    }
}
