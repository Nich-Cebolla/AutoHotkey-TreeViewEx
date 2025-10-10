
class TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        if !IsSet(TVS_HASBUTTONS) {
            TreeViewEx_SetConstants()
        }
    }
    static FromPtr(Ptr) {
        struct := { Buffer: { Ptr: Ptr, Size: this.Prototype.cbSizeInstance } }
        ObjSetBase(struct, this.Prototype)
        return struct
    }
    static __GetStructureProps() {
        proto := this.Prototype
        structureProps := proto.StructureProps := []
        for prop in proto.OwnProps() {
            if proto.GetOwnPropDesc(prop).HasOwnProp('Set') {
                structureProps.Push(prop)
            }
        }
    }
    __New(Members?) {
        this.Buffer := Buffer(this.cbSizeInstance, 0)
        if IsSet(Members) {
            b := this.Base
            while b {
                if b.HasOwnProp('StructureProps') {
                    for prop in b.StructureProps {
                        if HasProp(Members, prop) {
                            this.%prop% := Members.%prop%
                        }
                    }
                    break
                }
                b := b.Base
            }
        }
    }
    /**
     * @description - Copies the bytes from this object's buffer to another buffer.
     *
     * @param {*} [Buf] - If set, one of the following kinds of objects:
     * - An instance of a class that inherits from {@link TreeViewExStructBase}.
     * - A `Buffer` object.
     * - An object with properties { Ptr, Size }.
     *
     * The size of the buffer must be at least `this.cbSizeInstance + Offset`.
     *
     * If unset, a buffer of adequate size will be created.
     *
     * @param {Integer} [Offset = 0] - The byte offset at which to copy the data. For example, if
     * `Offset == 8`, then the data will be copied to `Buf.Ptr + 8`. The first 8 bytes of the
     * new/target buffer will be unchanged.
     *
     * @param {Boolean} [MakeInstance = true] - If true, and if `Buf` is unset or is not already
     * an instance of the class, then an instance of the class will be created.
     *
     * @returns {*} - Depending on the value of `MakeInstance`, the `Buffer` object or the instance object.
     *
     * @throws {Error} - "The input buffer's size is insufficient."
     */
    Clone(Buf?, Offset := 0, MakeInstance := true) {
        if Offset < 0 {
            throw ValueError('``Offset`` must be a positive integer.', -1, Offset)
        }
        if IsSet(Buf) {
            if not Buf is Buffer && Type(Buf) != this.__Class {
                throw TypeError('Invalid input parameter ``Buf``.', -1)
            }
        } else {
            Buf := Buffer(this.Size + Offset)
        }
        if Buf.Size < this.Size + Offset {
            throw Error('The input buffer`'s size is insufficient.', -1, Buf.Size)
        }
        DllCall(
            g_proc_msvcrt_memmove
          , 'ptr', Buf.Ptr + Offset
          , 'ptr', this.Ptr
          , 'int', this.Size
          , 'ptr'
        )
        if MakeInstance && Type(Buf) != this.__Class {
            b := this
            loop {
                if b := b.Base {
                    if Type(b) = 'Prototype' {
                        break
                    }
                } else {
                    throw Error('Unable to identify the prototype object.', -1)
                }
            }
            if Offset {
                Obj := { Buffer: { __Buffer: Buf, Ptr: Buf.Ptr + Offset, Size: this.Size } }
            } else {
                Obj := { Buffer: Buf }
            }
            ObjSetBase(Obj, b)
            return Obj
        } else {
            return Buf
        }
    }
    Ptr => this.Buffer.Ptr
    Size => this.Buffer.Size
}
