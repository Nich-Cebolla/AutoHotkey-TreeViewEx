
class TreeViewEx_Point {
    static __New() {
        this.DeleteProp('__New')
        TreeViewEx_Rect_SetConstants()
        this.Prototype.DefineProp('Clone', { Call: TreeViewEx_Rect_Clone })
    }
    /**
     * @description - Creates a {@link TreeViewEx_Point} object with the client position of the caret.
     * {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getcaretpos}.
     * @returns {TreeViewEx_Point}
     */
    static FromCaret() {
        pt := this()
        DllCall(g_user32_GetCaretPos, 'ptr', pt, 'int')
        return pt
    }
    /**
     * @description - Creates a {@link TreeViewEx_Point} object with the cursor position in screen coordinates.
     * {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getcursorpos}.
     * @returns {TreeViewEx_Point}
     */
    static FromCursor() {
        pt := this()
        DllCall(g_user32_GetCursorPos, 'ptr', pt, 'int')
        return pt
    }
    /**
     * @description - Creates a new {@link TreeViewEx_Point} object.
     * @param {Integer} [X] - The X-coordinate.
     * @param {Integer} [Y] - The Y-coordinate.
     */
    __New(X?, Y?) {
        this.Buffer := Buffer(8, 0)
        if IsSet(X) {
            this.X := X
        }
        if IsSet(Y) {
            this.Y := Y
        }
    }
    /**
     * @description - Use this to convert client coordinates (which should already be contained by
     * this {@link TreeViewEx_Point} object), to screen coordinates.
     * {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-clienttoscreen}.
     * @param {Integer} Hwnd - The handle to the window whose client area will be used for the conversion.
     * @param {Boolean} [InPlace = false] - If true, the current object is modified. If false, a new
     * {@link TreeViewEx_Point} is created.
     * @returns {TreeViewEx_Point}
     */
    ClientToScreen(Hwnd, InPlace := false) {
        if InPlace {
            pt := this
        } else {
            pt := TreeViewEx_Point(this.X, this.Y)
        }
        if !DllCall(g_user32_ClientToScreen, 'ptr', Hwnd, 'ptr', pt, 'int') {
            throw OSError()
        }
        return pt
    }
    /**
     * @description - Creates a copy of the {@link TreeViewEx_Point} object. The buffer on property
     * {@link TreeViewEx_Point#Buffer} is different, so changes to one will not affect the other.
     */
    Clone() {
        ; this is overridden
    }
    /**
     * @description - Calls {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getcursorpos}.
     * @returns {Boolean} - True if successful.
     */
    GetCursorPos() => DllCall(g_user32_GetCursorPos, 'ptr', this, 'int')
    /**
     * @description - Calls {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-logicaltophysicalpointforpermonitordpi}.
     * @param {Integer} Hwnd - A handle to the window whose transform is used for the conversion.
     * @returns {Boolean} - True if successful.
     */
    LogicalToPhysicalForPerMonitorDPI(Hwnd) {
        return DllCall(g_user32_LogicalToPhysicalPointForPerMonitorDPI, 'ptr', Hwnd, 'ptr', this, 'int')
    }
    /**
     * @description - Calls {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-logicaltophysicalpoint}.
     * @param {Integer} Hwnd - A handle to the window whose transform is used for the conversion.
     * Top level windows are fully supported. In the case of child windows, only the area of overlap
     * between the parent and the child window is converted.
     */
    LogicalToPhysicalPoint(Hwnd) {
        DllCall(g_user32_LogicalToPhysicalPoint, 'ptr', Hwnd, 'ptr', this)
    }
    /**
     * @description - Calls {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-physicaltologicalpointforpermonitordpi}.
     * @param {Integer} Hwnd - A handle to the window whose transform is used for the conversion.
     * @returns {Boolean} - True if successful.
     */
    PhysicalToLogicalForPerMonitorDPI(Hwnd) {
        return DllCall(g_user32_PhysicalToLogicalPointForPerMonitorDPI, 'ptr', Hwnd, 'ptr', this, 'int')
    }
    /**
     * @description - Calls {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-physicaltologicalpoint}.
     * @param {Integer} Hwnd - A handle to the window whose transform is used for the conversion.
     * Top level windows are fully supported. In the case of child windows, only the area of overlap
     * between the parent and the child window is converted.
     */
    PhysicalToLogicalPoint(Hwnd) {
        DllCall(g_user32_PhysicalToLogicalPoint, 'ptr', Hwnd, 'ptr', this)
    }
    /**
     * @description - Use this to convert screen coordinates (which should already be contained by
     * this {@link TreeViewEx_Point} object), to client coordinates.
     * {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-screentoclient}
     * @param {Integer} Hwnd - The handle to the window whose client area will be used for the conversion.
     * @param {Boolean} [InPlace = false] - If true, the current object is modified. If false, a new
     * {@link TreeViewEx_Point} is created.
     * @returns {TreeViewEx_Point}
     */
    ScreenToClient(Hwnd, InPlace := false) {
        if InPlace {
            pt := this
        } else {
            pt := TreeViewEx_Point(this.X, this.Y)
        }
        if !DllCall(g_user32_ScreenToClient, 'ptr', Hwnd, 'ptr', pt, 'int') {
            throw OSError()
        }
        return pt
    }
    /**
     * @description - Calls {@link https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setcaretpos}.
     * @returns {Boolean} - Nonzero if successful.
     */
    SetCaretPos() {
        return DllCall(g_user32_SetCaretPos, 'int', this.X, 'int', this.Y, 'int')
    }

    /**
     * @returns {Integer} - The dpi of the monitor containing the point.
     */
    Dpi {
        Get {
            if DllCall(g_shcore_GetDpiForMonitor, 'ptr', DllCall(g_user32_MonitorFromPoint, 'int', this.Value, 'uint', 0, 'ptr'), 'uint', 0, 'uint*', &DpiX := 0, 'uint*', &DpiY := 0, 'int') {
                throw OSError('``MonitorFomPoint`` received an invalid parameter.')
            } else {
                return DpiX
            }
        }
    }
    /**
     * @returns {Integer} - The handle to the monitor that contains the point.
     */
    Monitor  => DllCall(g_user32_MonitorFromPoint, 'int', this.Value, 'uint', 0, 'ptr')
    Ptr => this.Buffer.Ptr
    Size => this.Buffer.Size
    /**
     * @returns {Integer} - Returns a 64-bit value containing the x-coordinate in the low word and
     * the y-coordinate in the high word.
     */
    Value => (this.X & 0xFFFFFFFF) | (this.Y << 32)
    /**
     * @descriptions - Gets or sets the X coordinate value.
     * @returns {Integer}
     */
    X {
        Get => NumGet(this, 0, 'int')
        Set => NumPut('int', Value, this)
    }
    /**
     * @descriptions - Gets or sets the Y coordinate value.
     * @returns {Integer}
     */
    Y {
        Get => NumGet(this, 4, 'int')
        Set => NumPut('int', Value, this, 4)
    }
}
