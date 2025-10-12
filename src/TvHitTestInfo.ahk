/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

/**
 * {@link https://learn.microsoft.com/en-us/windows/win32/api/Commctrl/ns-commctrl-tvhittestinfo}.
 */
class TvHitTestInfo extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type           Symbol   Offset               Padding
        4 +         ; INT          X        0
        4 +         ; INT          Y        4
        A_PtrSize + ; UINT         flags    8                    +4 on x64 only
        A_PtrSize   ; HTREEITEM    hItem    8 + A_PtrSize * 1
        proto.offset_X := 0
        proto.offset_Y := 4
        proto.offset_flags := 8
        proto.offset_hItem := 8 + A_PtrSize * 1
    }
    X {
        Get => NumGet(this.Buffer, this.offset_X, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_X)
        }
    }
    Y {
        Get => NumGet(this.Buffer, this.offset_Y, 'int')
        Set {
            NumPut('int', Value, this.Buffer, this.offset_Y)
        }
    }
    flags {
        Get => NumGet(this.Buffer, this.offset_flags, 'uint')
        Set {
            NumPut('uint', Value, this.Buffer, this.offset_flags)
        }
    }
    hItem {
        Get => NumGet(this.Buffer, this.offset_hItem, 'ptr')
        Set {
            NumPut('ptr', Value, this.Buffer, this.offset_hItem)
        }
    }
}
