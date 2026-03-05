
class TreeViewEx_Rect {
    static __New() {
        this.DeleteProp('__New')
        TreeViewEx_Rect_SetConstants()
        this.Prototype.DefineProp('Clone', { Call: TreeViewEx_Rect_Clone })
    }
    static FromDimensions(X, Y, W, H) => this(X, Y, X + W, Y + H)
    static FromCursor() {
        rc := this()
        DllCall(g_user32_GetCursorPos, 'ptr', rc, 'int')
        rc.R := rc.L
        rc.B := rc.T
        return rc
    }
    /**
     * @description - Creates a new {@link TreeViewEx_Rect} object.
     * @param {Integer} [L] - The left coordinate.
     * @param {Integer} [T] - The top coordinate.
     * @param {Integer} [R] - The right coordinate.
     * @param {Integer} [B] - The bottom coordinate.
     */
    __New(L?, T?, R?, B?) {
        this.Buffer := Buffer(16, 0)
        if IsSet(L) {
            this.L := L
        }
        if IsSet(T) {
            this.T := T
        }
        if IsSet(R) {
            this.R := R
        }
        if IsSet(B) {
            this.B := B
        }
    }
    Clone() {
        ; this is overridden
    }
    Equal(rc) => DllCall(g_user32_EqualRect, 'ptr', this, 'ptr', rc, 'int')
    GetHeightSegment(Divisor, DecimalPlaces := 0) => Round(this.H / Divisor, DecimalPlaces)
    GetWidthSegment(Divisor, DecimalPlaces := 0) => Round(this.W / Divisor, DecimalPlaces)
    Inflate(dx, dy) => DllCall(g_user32_InflateRect, 'ptr', this, 'int', dx, 'int', dy, 'int')
    Intersect(rc) {
        out := TreeViewEx_Rect()
        if DllCall(g_user32_IntersectRect, 'ptr', out, 'ptr', this, 'ptr', rc, 'int') {
            return out
        }
    }
    IsEmpty() => DllCall(g_user32_IsRectEmpty, 'ptr', this, 'int')
    MoveAdjacent(Target?, ContainerRect?, Dimension := 'X', Prefer := '', Padding := 0, InsufficientSpaceAction := 0) {
        Result := 0
        if IsSet(Target) {
            tarL := Target.L
            tarT := Target.T
            tarR := Target.R
            tarB := Target.B
        } else {
            mode := CoordMode('Mouse', 'Screen')
            MouseGetPos(&tarL, &tarT)
            tarR := tarL
            tarB := tarT
            CoordMode('Mouse', mode)
        }
        tarW := tarR - tarL
        tarH := tarB - tarT
        if IsSet(ContainerRect) {
            monL := ContainerRect.L
            monT := ContainerRect.T
            monR := ContainerRect.R
            monB := ContainerRect.B
            monW := monR - monL
            monH := monB - monT
        } else {
            buf := Buffer(16)
            NumPut('int', tarL, 'int', tarT, 'int', tarR, 'int', tarB, buf)
            Hmon := DllCall('MonitorFromRect', 'ptr', buf, 'uint', 0x00000002, 'ptr')
            mon := Buffer(40)
            NumPut('int', 40, mon)
            if !DllCall('GetMonitorInfo', 'ptr', Hmon, 'ptr', mon, 'int') {
                throw OSError()
            }
            monL := NumGet(mon, 20, 'int')
            monT := NumGet(mon, 24, 'int')
            monR := NumGet(mon, 28, 'int')
            monB := NumGet(mon, 32, 'int')
            monW := monR - monL
            monH := monB - monT
        }
        subL := this.L
        subT := this.T
        subR := this.R
        subB := this.B
        subW := subR - subL
        subH := subB - subT
        if Dimension = 'X' {
            if Prefer = 'L' {
                if tarL - subW - Padding >= monL {
                    X := tarL - subW - Padding
                } else if tarL - subW >= monL {
                    X := monL
                }
            } else if Prefer = 'R' {
                if tarR + subW + Padding <= monR {
                    X := tarR + Padding
                } else if tarR + subW <= monR {
                    X := monR - subW
                }
            } else if Prefer {
                throw _ValueError('Prefer', Prefer)
            }
            if !IsSet(X) {
                flag_nomove := false
                X := _Proc(subW, tarL, tarR, monL, monR)
                if flag_nomove {
                    return Result
                }
            }
            Y := tarT + tarH / 2 - subH / 2
            if Y + subH > monB {
                Y := monB - subH
            } else if Y < monT {
                Y := monT
            }
        } else if Dimension = 'Y' {
            if Prefer = 'T' {
                if tarT - subH - Padding >= monT {
                    Y := tarT - subH - Padding
                } else if tarT - subH >= monT {
                    Y := monT
                }
            } else if Prefer = 'B' {
                if tarB + subH + Padding <= monB {
                    Y := tarB + Padding
                } else if tarB + subH <= monB {
                    Y := monB - subH
                }
            } else if Prefer {
                throw _ValueError('Prefer', Prefer)
            }
            if !IsSet(Y) {
                flag_nomove := false
                Y := _Proc(subH, tarT, tarB, monT, monB)
                if flag_nomove {
                    return Result
                }
            }
            X := tarL + tarW / 2 - subW / 2
            if X + subW > monR {
                X := monR - subW
            } else if X < monL {
                X := monL
            }
        } else {
            throw _ValueError('Dimension', Dimension)
        }
        this.L := X
        this.T := Y
        this.R := X + subW
        this.B := Y + subH

        return Result

        _Proc(SubLen, TarMainSide, TarAltSide, MonMainSide, MonAltSide) {
            if TarMainSide - MonMainSide > MonAltSide - TarAltSide {
                if TarMainSide - SubLen - Padding >= MonMainSide {
                    return TarMainSide - SubLen - Padding
                } else if TarMainSide - SubLen >= MonMainSide {
                    return MonMainSide + TarMainSide - SubLen
                } else {
                    Result := 1
                    switch InsufficientSpaceAction, 0 {
                        case 0: flag_nomove := true
                        case 1: return TarMainSide - SubLen
                        case 2: return MonMainSide
                        default: throw _ValueError('InsufficientSpaceAction', InsufficientSpaceAction)
                    }
                }
            } else if TarAltSide + SubLen + Padding <= MonAltSide {
                return TarAltSide + Padding
            } else if TarAltSide + SubLen <= MonAltSide {
                return MonAltSide - TarAltSide + SubLen
            } else {
                Result := 1
                switch InsufficientSpaceAction, 0 {
                    case 0: flag_nomove := true
                    case 1: return TarAltSide
                    case 2: return MonAltSide - SubLen
                    default: throw _ValueError('InsufficientSpaceAction', InsufficientSpaceAction)
                }
            }
        }
        _ValueError(name, Value) {
            if IsObject(Value) {
                return TypeError('Invalid type passed to ``' name '``.')
            } else {
                return ValueError('Unexpected value passed to ``' name '``.', , Value)
            }
        }
    }
    Offset(dx, dy) => DllCall(g_user32_OffsetRect, 'ptr', this, 'int', dx, 'int', dy, 'int')
    PtIn(pt) => DllCall(g_user32_PtInRect, 'ptr', this, 'ptr', pt, 'int')
    Set(X?, Y?, W?, H?) {
        if IsSet(X) {
            this.L := X
        }
        if IsSet(Y) {
            this.T := Y
        }
        if IsSet(W) {
            this.R := this.L + W
        }
        if IsSet(H) {
            this.B := this.T + H
        }
    }
    Subtract(rc) {
        out := TreeViewEx_Rect()
        DllCall(g_user32_SubtractRect, 'ptr', out, 'ptr', this, 'ptr', rc, 'int')
        return out
    }
    ToClient(Hwnd, InPlace := false) {
        if InPlace {
            rc := this
        } else {
            rc := this.Clone()
        }
        if !DllCall(g_user32_ScreenToClient, 'ptr', Hwnd, 'ptr', rc, 'int') {
            throw OSError()
        }
        if !DllCall(g_user32_ScreenToClient, 'ptr', Hwnd, 'ptr', rc.Ptr + 8, 'int') {
            throw OSError()
        }
        return rc
    }
    ToScreen(Hwnd, InPlace := false) {
        if InPlace {
            rc := this
        } else {
            rc := this.Clone()
        }
        if !DllCall(g_user32_ClientToScreen, 'ptr', Hwnd, 'ptr', rc, 'int') {
            throw OSError()
        }
        if !DllCall(g_user32_ClientToScreen, 'ptr', Hwnd, 'ptr', rc.ptr + 8, 'int') {
            throw OSError()
        }
        return rc
    }
    Union(rc) {
        out := TreeViewEx_Rect()
        if DllCall(g_user32_UnionRect, 'ptr', out, 'ptr', this, 'ptr', rc, 'int') {
            return out
        }
    }

    B {
        Get => NumGet(this, 12, 'int')
        Set => NumPut('int', Value, this, 12)
    }
    BL => TreeViewEx_Point(NumGet(this, 0, 'int'), NumGet(this, 12, 'int'))
    BR => TreeViewEx_Point(NumGet(this, 8, 'int'), NumGet(this, 12, 'int'))
    Dpi {
        Get {
            if DllCall(g_shcore_GetDpiForMonitor, 'ptr', DllCall(g_shcore_MonitorFromRect, 'ptr', this, 'uint', 0, 'ptr'), 'uint', 0, 'uint*', &DpiX := 0, 'uint*', &DpiY := 0, 'int') {
                throw OSError('``MonitorFomPoint`` received an invalid parameter.')
            } else {
                return DpiX
            }
        }
    }
    H {
        Get => NumGet(this, 12, 'int') - NumGet(this, 4, 'int')
        Set => NumPut('int', NumGet(this, 4, 'int') + Value, this, 12)
    }
    L {
        Get => NumGet(this, 0, 'int')
        Set => NumPut('int', Value, this)
    }
    Monitor => DllCall(g_user32_MonitorFromRect, 'ptr', this, 'uint', 0, 'uptr')
    Ptr => this.Buffer.Ptr
    R {
        Get => NumGet(this, 8, 'int')
        Set => NumPut('int', Value, this, 8)
    }
    Size => this.Buffer.Size
    T {
        Get => NumGet(this, 4, 'int')
        Set => NumPut('int', Value, this, 4)
    }
    TL {
        Get => TreeViewEx_Point(NumGet(this, 0, 'int'), NumGet(this, 4, 'int'))
    }
    TR {
        Get => TreeViewEx_Point(NumGet(this, 8, 'int'), NumGet(this, 4, 'int'))
    }
    W {
        Get => NumGet(this, 8, 'int') - NumGet(this, 0, 'int')
        Set => NumPut('int', NumGet(this, 0, 'int') + Value, this, 8)
    }
}

TreeViewEx_Rect_Clone(Self) {
    obj := Object.Prototype.Clone.Call(Self)
    obj.Buffer := Buffer(Self.Size)
    ObjSetBase(obj, %Self.__Class%.Prototype)
    DllCall(
        g_msvcrt_memcpy
      , 'ptr', obj.Ptr
      , 'ptr', Self.Ptr
      , 'int', Self.Size
      , 'cdecl'
    )
    return obj
}

TreeViewEx_Rect_SetConstants(force := false) {
    global
    if IsSet(Rect_constants_set) && !force {
        return
    }

    local hmod := DllCall('GetModuleHandle', 'str', 'User32', 'ptr')
    g_user32_AdjustWindowRectEx := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'AdjustWindowRectEx', 'ptr')
    g_user32_BringWindowToTop := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'BringWindowToTop', 'ptr')
    g_user32_ChildWindowFromPoint := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'ChildWindowFromPoint', 'ptr')
    g_user32_ChildWindowFromPointEx := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'ChildWindowFromPointEx', 'ptr')
    g_user32_ClientToScreen := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'ClientToScreen', 'ptr')
    g_user32_EnumChildWindows := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'EnumChildWindows', 'ptr')
    g_user32_EqualRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'EqualRect', 'ptr')
    g_user32_GetCaretPos := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetCaretPos', 'ptr')
    g_user32_GetClientRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetClientRect', 'ptr')
    g_user32_GetCursorPos := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetCursorPos', 'ptr')
    g_user32_GetDesktopWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetDesktopWindow', 'ptr')
    g_user32_GetDpiForWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetDpiForWindow', 'ptr')
    g_user32_GetForegroundWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetForegroundWindow', 'ptr')
    g_user32_GetMenu := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetMenu', 'ptr')
    g_user32_GetParent := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetParent', 'ptr')
    g_user32_GetShellWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetShellWindow', 'ptr')
    g_user32_GetTopWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetTopWindow', 'ptr')
    g_user32_GetWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetWindow', 'ptr')
    g_user32_GetWindowInfo := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetWindowInfo', 'ptr')
    g_user32_GetWindowRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetWindowRect', 'ptr')
    g_user32_InflateRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'InflateRect', 'ptr')
    g_user32_IntersectRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'IntersectRect', 'ptr')
    g_user32_IsChild := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'IsChild', 'ptr')
    g_user32_IsRectEmpty := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'IsRectEmpty', 'ptr')
    g_user32_IsWindowVisible := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'IsWindowVisible', 'ptr')
    g_user32_LogicalToPhysicalPoint := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'LogicalToPhysicalPoint', 'ptr')
    g_user32_LogicalToPhysicalPointForPerMonitorDPI := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'LogicalToPhysicalPointForPerMonitorDPI', 'ptr')
    g_user32_MapWindowPoints := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'MapWindowPoints', 'ptr')
    g_user32_MonitorFromPoint := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'MonitorFromPoint', 'ptr')
    g_user32_MonitorFromRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'MonitorFromRect', 'ptr')
    g_user32_MonitorFromWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'MonitorFromWindow', 'ptr')
    g_user32_GetNextWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetNextWindow', 'ptr')
    g_user32_OffsetRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'OffsetRect', 'ptr')
    g_user32_PhysicalToLogicalPoint := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'PhysicalToLogicalPoint', 'ptr')
    g_user32_PhysicalToLogicalPointForPerMonitorDPI := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'PhysicalToLogicalPointForPerMonitorDPI', 'ptr')
    g_user32_PtInRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'PtInRect', 'ptr')
    g_user32_RealChildWindowFromPoint := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'RealChildWindowFromPoint', 'ptr')
    g_user32_ScreenToClient := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'ScreenToClient', 'ptr')
    g_user32_SetActiveWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'SetActiveWindow', 'ptr')
    g_user32_SetCaretPos := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'SetCaretPos', 'ptr')
    g_user32_SetForegroundWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'SetForegroundWindow', 'ptr')
    g_user32_SetParent := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'SetParent', 'ptr')
    g_user32_SetThreadDpiAwarenessContext := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'SetThreadDpiAwarenessContext', 'ptr')
    g_user32_SetWindowPos := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'SetWindowPos', 'ptr')
    g_user32_ShowWindow := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'ShowWindow', 'ptr')
    g_user32_SubtractRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'SubtractRect', 'ptr')
    g_user32_UnionRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'UnionRect', 'ptr')
    g_user32_WindowFromPoint := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'WindowFromPoint', 'ptr')
    hmod := DllCall('LoadLibrary', 'str', 'Shcore', 'ptr')
    g_shcore_GetDpiForMonitor := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'GetDpiForMonitor', 'ptr')
    g_shcore_MonitorFromRect := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'MonitorFromRect', 'ptr')
    hmod := DllCall('LoadLibrary', 'str', 'Dwmapi', 'ptr')
    g_dwmapi_DwmGetWindowAttribute := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'DwmGetWindowAttribute', 'ptr')
    hmod := DllCall('LoadLibrary', 'str', 'msvcrt', 'ptr')
    g_msvcrt_memcpy := DllCall('GetProcAddress', 'ptr', hmod, 'astr', 'memcpy', 'ptr')

    Rect_constants_set := true
}
