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
        proto.FlagSymbols := Map()
        proto.FlagSymbols.CaseSense := false
        proto.FlagSymbols.Default := ''
        proto.FlagSymbols.Set(
            TVHT_ABOVE, 'Above'
          , TVHT_BELOW, 'Below'
          , TVHT_NOWHERE, 'Nowhere'
          , TVHT_ONITEM, 'OnItem'
          , TVHT_ONITEMBUTTON, 'OnItemButton'
          , TVHT_ONITEMICON, 'OnItemIcon'
          , TVHT_ONITEMINDENT, 'OnItemIndent'
          , TVHT_ONITEMLABEL, 'OnItemLabel'
          , TVHT_ONITEMRIGHT, 'OnItemRight'
          , TVHT_ONITEMSTATEICON, 'OnItemStateIcon'
          , TVHT_TOLEFT, 'ToLeft'
          , TVHT_TORIGHT, 'ToRight'
        )
        proto.flags_OnItemGeneral := TVHT_ONITEM | TVHT_ONITEMBUTTON | TVHT_ONITEMICON | TVHT_ONITEMLABEL | TVHT_ONITEMSTATEICON
    }
    GetFlags() {
        list := []
        for flag in this.FlagSymbols {
            if this.flags & flag {
                list.Push(flag)
            }
        }
        return list.Length ? list : ''
    }
    GetSymbols(delimiter := '`n') {
        s := ''
        for flag, symbol in this.FlagSymbols {
            if this.flags & flag {
                s .= symbol delimiter
            }
        }
        return SubStr(s, 1, -StrLen(delimiter))
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
    Above => this.flags & TVHT_ABOVE
    Below => this.flags & TVHT_BELOW
    Nowhere => this.flags & TVHT_NOWHERE
    OnItem => this.flags & TVHT_ONITEM
    OnItemButton => this.flags & TVHT_ONITEMBUTTON
    OnItemGeneral => this.flags & this.flags_OnItemGeneral
    OnItemIcon => this.flags & TVHT_ONITEMICON
    OnItemIndent => this.flags & TVHT_ONITEMINDENT
    OnItemLabel => this.flags & TVHT_ONITEMLABEL
    OnItemRight => this.flags & TVHT_ONITEMRIGHT
    OnItemStateIcon => this.flags & TVHT_ONITEMSTATEICON
    Symbols => this.GetSymbols()
    ToLeft => this.flags & TVHT_TOLEFT
    ToRight => this.flags & TVHT_TORIGHT
}
