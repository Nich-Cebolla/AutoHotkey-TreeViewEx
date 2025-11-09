
class TvNmHdr extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        this.__GetStructureProps()
        proto := this.Prototype
        proto.cbSizeInstance :=
        ; Size      Type          Symbol      Offset               Padding
        A_PtrSize + ; HWND        hwndFrom    0
        A_PtrSize + ; UINT_PTR    idFrom      0 + A_PtrSize * 1
        A_PtrSize   ; UINT        code        0 + A_PtrSize * 2    +4 on x64 only
        proto.offset_hwndFrom  := 0
        proto.offset_idFrom    := 0 + A_PtrSize * 1
        proto.offset_code      := 0 + A_PtrSize * 2

        proto.Collection := Map()
        proto.Collection.Default := 0
        proto.Collection.Set(
            TVN_ASYNCDRAW, TvAsyncDraw
          , TVN_BEGINDRAGW, NmTreeView
          , TVN_BEGINLABELEDITW, TvDispInfoEx
          , TVN_BEGINRDRAGW, NmTreeView
          , TVN_DELETEITEMW, NmTreeView
          , TVN_ENDLABELEDITW, TvDispInfoEx
          , TVN_GETDISPINFOW, TvDispInfoEx
          , TVN_GETINFOTIPW, TvGetInfoTip
          , TVN_ITEMCHANGEDW, TvItemChange
          , TVN_ITEMCHANGINGW, TvItemChange
          , TVN_ITEMEXPANDEDW, NmTreeView
          , TVN_ITEMEXPANDINGW, NmTreeView
          , TVN_KEYDOWN, TvKeyDown
          , TVN_SELCHANGEDW, NmTreeView
          , TVN_SELCHANGINGW, NmTreeView
          , TVN_SETDISPINFOW, TvDispInfoEx
          , TVN_SINGLEEXPAND, NmTreeView
          , NM_CUSTOMDRAW, NmTvCustomDraw
        )
    }
    Cast() {
        if cls := this.Collection.Get(this.code_int) {
            return cls.FromPtr(this.ptr)
        } else {
            return this
        }
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
}
