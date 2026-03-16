
/**
    The functions in this file are intended to be used with
    {@link https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GuiResizer.ahk GuiResizer}.

    These are kept separately to avoid the VarUnset warning that would occur due to `GuiResizer`
    being an unset variable when not #included in a script.
*/

class TreeViewEx_CallbackSetSizeEventHandler {
    /**
     * @desc - Intended to be assigned to property {@link GuiResizer#CallbackSetEventHandler}.
     * Since this class' constructor requires the {@link GuiResizer} instance object, we can't
     * assign this object to `Options.CallbackSetEventHandler`. We have to create the
     * {@link GuiResizer} object first, then assign this object to the property
     * "CallbackSetEventHandler".
     *
     * The below example demonstrates how to set this up.
     *
     * @example
     * #include <TreeViewEx>
     * #include <GuiResizer>
     * #include <TreeViewEx_CallbackSetSizeEventHandler>
     *
     * guiObj := Gui()
     * tvex := TreeViewEx(guiObj)
     * ; Set resizer options for the TreeViewEx control
     * tvex.Resizer := { W: 1, H: 1 }
     * guiResizerObj := GuiResizer(guiObj, , , true) ; to defer calling Activate()
     * ; Assign an instance of this class to property "CallbackSetEventHandler"
     * guiResizerObj.CallbackSetEventHandler := TreeViewEx_CallbackSetEventHandler(tvex.hwnd, guiResizerObj)
     * ; Call Activate(), passing the TreeViewEx object to the first parameter
     * guiResizerObj.Activate(tvex)
     * @
     *
     * @param {Integer} Hwnd - Bind the {@link TreeViewEx} control's hwnd to this function.
     *
     * @param {GuiResizer} GuiResizerObj - The {@link GuiResizer} object.
     */
    __New(Hwnd, GuiResizerObj) {
        this.Hwnd := Hwnd
        this.eventHandler := TreeViewEx_SizeEventHandler(GuiResizerObj.id)
    }
    /**
     * @desc - This enables or disables the Size event handler.
     *
     * @param {GuiResizer} GuiResizerObj - The {@link GuiResizer} object.
     *
     * @param {Integer} AddRemove - One of the following:
     * - -1 : Add the event handler to be called before any other event handlers.
     * - 0 : Disable the event handler.
     * - 1 : Add the event handler to be called after any other event handlers.
     */
    Call(GuiResizerObj, AddRemove) {
        if TreeViewEx.Collection_TVEX.Find(this.Hwnd, &tvex) {
            tvex.OnMessage(0x0005, this.eventHandler, AddRemove) ; WM_SIZE
        } else {
            throw UnsetItemError('Failed to find a value with the input hwnd.', , this.Hwnd)
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
