/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

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

        proto.DefineProp('Clone', { Call: TreeViewEx_CloneBuffer })
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
    /**
     * @description - Copies the bytes from this object's buffer to another buffer.
     *
     * @param {TvSortCb|Buffer|Object} [Buf] - If set, one of the following kinds of objects:
     * - A `TvSortCb` object.
     * - A `Buffer` object.
     * - An object with properties { Ptr, Size }.
     *
     * The size of the buffer must be at least `TvSortCb.Prototype.cbSize + Offset`.
     *
     * If unset, a buffer of adequate size will be created.
     *
     * @param {Integer} [Offset = 0] - The byte offset at which to copy the data. For example, if
     * `Offset == 8`, then the data will be copied to `Buf.Ptr + 8`. The first 8 bytes of the
     * new/target buffer will be unchanged.
     *
     * @param {Boolean} [MakeInstance = true] - If true, and if `Buf` is unset or is not already
     * an instance of `TvSortCb`, then an instance of `TvSortCb` will be created.
     *
     * @returns {Buffer|TvSortCb} - Depending on the value of `MakeInstance`, the `Buffer`
     * object or the `TvSortCb` object.
     *
     * @throws {Error} - "The input buffer's size is insufficient."
     */
    Clone(Buf?, Offset := 0, MakeInstance := true) {
        ; This is overridden
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
