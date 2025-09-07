/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

class TvHitTestInfo {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.cbSize :=
        ; Size      Type           Symbol   Offset               Padding
        4 +         ; INT          X        0
        4 +         ; INT          Y        4
        A_PtrSize + ; UINT         flags    8                    +4 on x64 only
        A_PtrSize   ; HTREEITEM    hItem    8 + A_PtrSize * 1
        proto.offset_X := 0
        proto.offset_Y := 4
        proto.offset_flags := 8
        proto.offset_hItem := 8 + A_PtrSize * 1

        proto.DefineProp('Clone', { Call: TreeViewEx_CloneBuffer })
    }
    __New(X, Y) {
        this.Buffer := Buffer(this.cbSize)
        this.X := X
        this.Y := Y
        this.flags := this.hItem := 0
    }
    /**
     * @description - Copies the bytes from this object's buffer to another buffer.
     *
     * @param {TvHitTestInfo|Buffer|Object} [Buf] - If set, one of the following kinds of objects:
     * - A `TvHitTestInfo` object.
     * - A `Buffer` object.
     * - An object with properties { Ptr, Size }.
     *
     * The size of the buffer must be at least `TvHitTestInfo.Prototype.cbSize + Offset`.
     *
     * If unset, a buffer of adequate size will be created.
     *
     * @param {Integer} [Offset = 0] - The byte offset at which to copy the data. For example, if
     * `Offset == 8`, then the data will be copied to `Buf.Ptr + 8`. The first 8 bytes of the
     * new/target buffer will be unchanged.
     *
     * @param {Boolean} [MakeInstance = true] - If true, and if `Buf` is unset or is not already
     * an instance of `TvHitTestInfo`, then an instance of `TvHitTestInfo` will be created.
     *
     * @returns {Buffer|TvHitTestInfo} - Depending on the value of `MakeInstance`, the `Buffer`
     * object or the `TvHitTestInfo` object.
     *
     * @throws {Error} - "The input buffer's size is insufficient."
     */
    Clone(Buf?, Offset := 0, MakeInstance := true) {
        ; This is overridden
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
    Ptr => this.Buffer.Ptr
    Size => this.Buffer.Size
}
