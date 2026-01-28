/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TreeViewEx
    Author: Nich-Cebolla
    License: MIT
*/

/**
 * @classdesc - A wrapper around the LOGFONT structure.
 * {@link https://learn.microsoft.com/en-us/windows/win32/api/dimm/ns-dimm-logfontw}
 */
class TreeViewEx_LogFont extends TreeViewExStructBase {
    static __New() {
        this.DeleteProp('__New')
        Proto := this.Prototype
        Proto.Encoding := TVEX_DEFAULT_ENCODING
        /**
         * The structure's size.
         * @memberof Logfont
         * @instance
         */
        Proto.cbSizeInstance :=
        4 + ; LONG  lfHeight                    0
        4 + ; LONG  lfWidth                     4
        4 + ; LONG  lfEscapement                8
        4 + ; LONG  lfOrientation               12
        4 + ; LONG  lfWeight                    16
        1 + ; BYTE  lfItalic                    20
        1 + ; BYTE  lfUnderline                 21
        1 + ; BYTE  lfStrikeOut                 22
        1 + ; BYTE  lfCharSet                   23
        1 + ; BYTE  lfOutPrecision              24
        1 + ; BYTE  lfClipPrecision             25
        1 + ; BYTE  lfQuality                   26
        1 + ; BYTE  lfPitchAndFamily            27
        64  ; WCHAR lfFaceName[LF_FACESIZE]     28
        Proto.Handle := Proto.Hwnd := 0
    }
    /**
     * @param {Integer} [Hwnd = 0] - The window handle to associate with the {@link TreeViewEx_LogFont}
     * object. If `Hwnd` is set with a nonzero value, {@link TreeViewEx_LogFont.Prototype.Call} is
     * called to initialize this object's properties with values obtained from the window. If `Hwnd`
     * is zero, the value of each property is 0.
     *
     * @param {Object} [Options] - An object with zero or more options as property : value pairs.
     * The value of any instance property can be assigned using the `Options` object.
     *
     * @param {Integer} [Options.CharSet] - The value to assign to CharSet.
     * @param {Integer} [Options.ClipPrecision] - The value to assign to ClipPrecision.
     * @param {Integer} [Options.Escapement] - The value to assign to Escapement.
     * @param {String} [Options.FaceName] - The value to assign to FaceName.
     * @param {Integer} [Options.Family] - The value to assign to Family.
     * @param {Integer} [Options.FontSize] - The value to assign to FontSize.
     * @param {Integer} [Options.Height] - The value to assign to Height.
     * @param {Integer} [Options.Italic] - The value to assign to Italic.
     * @param {Integer} [Options.Orientation] - The value to assign to Orientation.
     * @param {Integer} [Options.OutPrecision] - The value to assign to OutPrecision.
     * @param {Integer} [Options.Pitch] - The value to assign to Pitch.
     * @param {Integer} [Options.Quality] - The value to assign to Quality.
     * @param {Integer} [Options.StrikeOut] - The value to assign to StrikeOut.
     * @param {Integer} [Options.Underline] - The value to assign to Underline.
     * @param {Integer} [Options.Weight] - The value to assign to Weight.
     * @param {Integer} [Options.Width] - The value to assign to Width.
     *
     * @return {Logfont}
     */
    __New(Hwnd := 0, Options?) {
        /**
         * A reference to the buffer object which is used as the LOGFONT structure.
         * @memberof Logfont
         * @instance
         */
        this.Buffer := Buffer(this.cbSizeInstance, 0)
        /**
         * The handle to the window associated with this object, if any.
         * @memberof Logfont
         * @instance
         */
        if this.Hwnd := Hwnd {
            this()
        }
        if IsSet(Options) {
            for opt in TreeViewEx_LogFont.Options.Number {
                if HasProp(Options, opt) && IsNumber(options.%opt%) {
                    this.%opt% := options.%opt%
                }
            }
            for opt in TreeViewEx_LogFont.Options.String {
                if HasProp(Options, opt) && StrLen(options.%opt%) {
                    this.%opt% := options.%opt%
                }
            }
            this.Apply()
        }
    }
    /**
     * @description - Calls `CreateFontIndirectW` then sends WM_SETFONT to the window associated
     * with this `Logfont` object.
     * @param {Boolean} [Redraw = true] - The value to pass to the `lParam` parameter when sending
     * WM_SETFONT. If true, the control redraws itself.
     */
    Apply(Redraw := true) {
        hFontOld := SendMessage(WM_GETFONT,,, this.Hwnd)
        Flag := this.Handle = hFontOld
        this.Handle := DllCall(g_gdi32_CreateFontIndirectW, 'ptr', this, 'ptr')
        SendMessage(WM_SETFONT, this.Handle, Redraw, this.Hwnd)
        if Flag {
            DllCall(g_gdi32_DeleteObject, 'ptr', hFontOld, 'int')
        }
    }
    /**
     * @description - Sends WM_GETFONT to the window associated with this `Logfont` object, updating
     * this object's properties with the values obtained from the window.
     * @throws {OSError} - Failed to get font object.
     */
    Call(*) {
        hFont := SendMessage(WM_GETFONT,,, this.Hwnd)
        if !DllCall(g_gdi32_GetObjectW, 'ptr', hFont, 'int', this.Size, 'ptr', this, 'uint') {
            throw OSError()
        }
    }
    /**
     * @description - If a font object has been created by this `Logfont` object, the font object
     * is deleted.
     */
    Dispose() {
        if this.Handle {
            DllCall(g_gdi32_DeleteObject, 'ptr', this.Handle)
            this.Handle := 0
        }
    }
    /**
     * @description - Updates a property's value and calls `Logfont.Prototype.Apply` immediately afterward.
     * @param {String} Name - The name of the property.
     * @param {String|Number} Value - The value.
     */
    Set(Name, Value) {
        this.%Name% := Value
        this.Apply()
    }
    /**
     * Gets or sets the character set.
     * @memberof Logfont
     * @instance
     */
    CharSet {
        Get => NumGet(this, 23, 'uchar')
        Set => NumPut('uchar', Value, this, 23)
    }
    /**
     * Gets or sets the behavior when part of a character is clipped.
     * @memberof Logfont
     * @instance
     */
    ClipPrecision {
        Get => NumGet(this, 25, 'uchar')
        Set => NumPut('uchar', Value, this, 25)
    }
    /**
     * If this `Logfont` object is associated with a window, returns the dpi for the window.
     * @memberof Logfont
     * @instance
     */
    Dpi => this.Hwnd ? DllCall(g_user32_GetDpiForWindow, 'Ptr', this.Hwnd, 'UInt') : ''
    /**
     * Gets or sets the escapement measured in tenths of a degree.
     * @memberof Logfont
     * @instance
     */
    Escapement {
        Get => NumGet(this, 8, 'int')
        Set => NumPut('int', Value, this, 8)
    }
    /**
     * Gets or sets the font facename.
     * @memberof Logfont
     * @instance
     */
    FaceName {
        Get => StrGet(this.ptr + 28, 32, this.Encoding)
        Set => StrPut(SubStr(Value, 1, 31), this.Ptr + 28, 32, TVEX_DEFAULT_ENCODING)
    }
    /**
     * Gets or sets the font family.
     * @memberof Logfont
     * @instance
     */
    Family {
        Get => NumGet(this, 27, 'uchar') & 0xF0
        Set => NumPut('uchar', (this.Family & 0x0F) | (Value & 0xF0), this, 27)
    }
    /**
     * Gets or sets the font size. "FontSize" requires that the `Logfont` object is associated
     * with a window handle because it needs a dpi value to work with.
     * @memberof Logfont
     * @instance
     */
    FontSize {
        Get => this.Hwnd ? Round(this.Height * -72 / this.Dpi, 2) : ''
        Set => this.Height := Round(Value * this.Dpi / -72)
    }
    /**
     * Gets or sets the font height.
     * @memberof Logfont
     * @instance
     */
    Height {
        Get => NumGet(this, 0, 'int')
        Set => NumPut('int', Value, this, 0)
    }
    /**
     * Gets or sets the italic flag.
     * @memberof Logfont
     * @instance
     */
    Italic {
        Get => NumGet(this, 20, 'uchar')
        Set => NumPut('uchar', Value ? 1 : 0, this, 20)
    }
    /**
     * Gets or sets the orientation measured in tenths of degrees.
     * @memberof Logfont
     * @instance
     */
    Orientation {
        Get => NumGet(this, 12, 'int')
        Set => NumPut('int', Value, this, 12)
    }
    /**
     * Gets or sets the behavior when multiple fonts with the same name exist on the system.
     * @memberof Logfont
     * @instance
     */
    OutPrecision {
        Get => NumGet(this, 24, 'uchar')
        Set => NumPut('uchar', Value, this, 24)
    }
    /**
     * Gets or sets the pitch.
     * @memberof Logfont
     * @instance
     */
    Pitch {
        Get => NumGet(this, 27, 'uchar') & 0x0F
        Set => NumPut('uchar', (this.Pitch & 0xF0) | (Value & 0x0F), this, 27)
    }
    /**
     * Gets or sets the quality flag.
     * @memberof Logfont
     * @instance
     */
    Quality {
        Get => NumGet(this, 26, 'uchar')
        Set => NumPut('uchar', Value, this, 26)
    }
    /**
     * Gets or sets the strikeout flag.
     * @memberof Logfont
     * @instance
     */
    StrikeOut {
        Get => NumGet(this, 22, 'uchar')
        Set => NumPut('uchar', Value ? 1 : 0, this, 22)
    }
    /**
     * Gets or sets the underline flag.
     * @memberof Logfont
     * @instance
     */
    Underline {
        Get => NumGet(this, 21, 'uchar')
        Set => NumPut('uchar', Value ? 1 : 0, this, 21)
    }
    /**
     * Gets or sets the weight flag.
     * @memberof Logfont
     * @instance
     */
    Weight {
        Get => NumGet(this, 16, 'int')
        Set => NumPut('int', Value, this, 16)
    }
    /**
     * Gets or sets the width.
     * @memberof Logfont
     * @instance
     */
    Width {
        Get => NumGet(this, 4, 'int')
        Set => NumPut('int', Value, this, 4)
    }

    class Options {
        static __New() {
            this.DeleteProp('__New')
            this.Number := [
                'CharSet'
              , 'ClipPrecision'
              , 'Escapement'
              , 'Family'
              , 'FontSize'
              , 'Height'
              , 'Italic'
              , 'Orientation'
              , 'OutPrecision'
              , 'Pitch'
              , 'Quality'
              , 'StrikeOut'
              , 'Underline'
              , 'Weight'
              , 'Width'
            ]
            this.String := [ 'FaceName' ]
        }
    }
}
