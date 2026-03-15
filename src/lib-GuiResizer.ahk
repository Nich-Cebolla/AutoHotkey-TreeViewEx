
/**
    The functions in this file are intended to be used with
    {@link https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GuiResizer.ahk GuiResizer}.

    These are kept separately to avoid the VarUnset warning that would occur due to `GuiResizer`
    being an unset variable when not #included in a script.
*/

class TreeViewEx_CallbackSetSizeEventHandler {
    __New(GuiResizerObj) {
        this.eventHandler := TreeViewEx_SizeEventHandler(GuiResizerObj.id)
    }
    Call(Hwnd, GuiResizerObj, AddRemove) {
        if TreeViewEx.Collection_TVEX.Find(Hwnd, &tvex) {
            tvex.OnMessage(0x0005, this.eventHandler, AddRemove) ; WM_SIZE
        } else {
            throw UnsetItemError('Failed to find a value with the input hwnd.', , Hwnd)
        }
    }
}

class TreeViewEx_SizeEventHandler {
    __New(idGuiResizer) {
        this.idGuiResizer := idGuiResizer
    }
    Call(tvex, wParam, lParam, uMsg, HwndSubclass) {
        if GuiResizerObj := GuiResizer.collection.Get(this.idGuiResizer) {
            if wParam = 0 {
                GuiResizerObj(
                    tvex.Gui,
                    0,
                    lParam & 0xFFFF,
                    (lParam >> 16) & 0xFFFF
                )
            } else if wParam = 2 {
                GuiResizerObj(
                    tvex.Gui,
                    1,
                    lParam & 0xFFFF,
                    (lParam >> 16) & 0xFFFF
                )
            } else if wParam = 1 {
                GuiResizerObj(
                    tvex.Gui,
                    -1,
                    lParam & 0xFFFF,
                    (lParam >> 16) & 0xFFFF
                )
            }
        } else {
            tvex.OnMessage(0x0005, this, 0) ;  WM_SIZE
        }
    }
}
