
TreeViewEx_HandlerGetDispInfoW(Ctrl, lParam) {
    _tvDispInfoExW := TvDispInfoExW.FromPtr(lParam)
    if _tvDispInfoExW.mask & TVIF_TEXT {
        Ctrl.__HandlerNameGet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_IMAGE {
        Ctrl.__HandlerImageGet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_SELECTEDIMAGE {
        Ctrl.__HandlerSelectedImageGet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_CHILDREN {
        Ctrl.__HandlerChildrenGet.Call(Ctrl, _tvDispInfoExW)
    } else {
        throw Error('Unexpected ``mask`` member of ``NMTVDISPINFOW`` structure.', -1, _tvDispInfoExW.mask)
    }
}

TreeViewEx_HandlerSetDispInfoW(Ctrl, lParam) {
    _tvDispInfoExW := TvDispInfoExW.FromPtr(lParam)
    if _tvDispInfoExW.mask & TVIF_TEXT {
        Ctrl.__HandlerNameSet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_IMAGE {
        Ctrl.__HandlerImageSet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_SELECTEDIMAGE {
        Ctrl.__HandlerSelectedImageSet.Call(Ctrl, _tvDispInfoExW)
    } else if _tvDispInfoExW.mask & TVIF_CHILDREN {
        Ctrl.__HandlerChildrenSet.Call(Ctrl, _tvDispInfoExW)
    } else {
        throw Error('Unexpected ``mask`` member of ``NMTVDISPINFOW`` structure.', -1, _tvDispInfoExW.mask)
    }
}

TreeViewEx_CloneBuffer(ObjToClone, Buf?, Offset := 0, MakeInstance := true) {
    if IsSet(Buf) {
        if not Buf is Buffer && Type(Buf) != ObjToClone.__Class {
            throw TypeError('Invalid input parameter ``Buf``.', -1)
        }
    } else {
        Buf := Buffer(ObjToClone.Size + Offset)
    }
    if Buf.Size < ObjToClone.Size + Offset {
        throw Error('The input buffer`'s size is insufficient.', -1, Buf.Size)
    }
    DllCall(
        'msvcrt.dll\memmove'
      , 'ptr', Buf.Ptr + Offset
      , 'ptr', ObjToClone.Ptr
      , 'int', ObjToClone.Size
      , 'ptr'
    )
    if MakeInstance {
        b := ObjToClone
        while b {
            if Type(b) = 'Prototype' {
                break
            }
            b := b.Base
        }
        if !b {
            throw Error('Unable to identify the prototype object.', -1)
        }
        Obj := { Buffer: Buf }
        ObjSetBase(Obj, b)
        return Obj
    }
    return Buf
}
