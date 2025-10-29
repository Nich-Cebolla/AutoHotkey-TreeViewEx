
#SingleInstance force
#include ..\src\TreeViewEx_Tab.ahk
; This will run with or without TreeViewEx_ContextMenu
; The class `TreeViewEx_ContextMenu` is located in file src\TreeViewEx_ContextMenu.ahk
; but is not included in VENV.ahk.
#include *i <TreeViewEx_ContextMenu>
; https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GuiResizer.ahk
#include <GuiResizer>

test_TreeViewEx_Tab()

class test_TreeViewEx_Tab {

    static Call() {
        g := this.g := Gui('+Resize', , test_TreeViewEx_Tab_EventHandler())
        controls := this.controls := []
        tvexTab := this.tvexTab := TreeViewEx_Tab(g, { opt: 'w400 r15', name: 'tab', CallbackOnChangeAfter: test_TreeViewEx_Tab_CallbackOnChange, Which: 'Tab2' })
        item := this.item := tvexTab.Add('tvex1')
        tvex := item.tvex
        obj := test_TreeViewEx_Tab_ObjDeepClone(test_TreeViewEx_Tab.Obj, 'tvex1')
        tvex.AddObj(obj)
        tvexTab.Tab.Resizer := tvex.Resizer := { W: 1, H: 1 }
        controls.Push(tvex)
        rc := tvexTab.Tab.GetClientWindowRect()
        this.input := g.Add('Edit', 'x' g.MarginX ' y' (rc.B + g.MarginY) ' w' rc.W ' r1 Section vEdtInput')
        g.Add('Button', 'xs section vBtnAdd', 'Add').OnEvent('Click', 'Add')
        g.Add('Button', 'ys vBtnDeleteTab', 'DeleteTab').OnEvent('Click', 'DeleteTab')
        g.Add('Button', 'ys vBtnDeleteTreeViewEx', 'DeleteTreeViewEx').OnEvent('Click', 'DeleteTreeViewEx')
        g.Add('Button', 'ys vBtnHide', 'Hide').OnEvent('Click', 'Hide')
        g.Add('Button', 'ys vBtnShow', 'Show').OnEvent('Click', 'Show')
        g.Add('Button', 'ys vBtnExit', 'Exit').OnEvent('Click', (*) => ExitApp())
        resizerObj := { Y: 1 }
        for ctrl in g {
            switch Ctrl.Type, 0 {
                case 'Button', 'Edit': ctrl.Resizer := resizerObj
            }
        }
        g.Show()
        WinRedraw(g.Hwnd)
        if IsSet(GuiResizer) {
            g.resizer := GuiResizer(g, , controls)
            ; { Callback: test_TreeViewEx_Tab_GuiResizerCallback }
        }
    }
    static Obj := {
        Name: 'obj1'
      , Children: [
            { Name: 'obj1-1', Children: [ 'obj1-1-1' ] }
          , { Name: 'obj1-2', Children: [ 'obj1-2-1' ] }
          , {
                Name: 'obj1-3'
              , Children: [
                    {
                        Name: 'obj1-3-1'
                      , Children: [
                            'obj1-3-1-1'
                          , 'obj1-3-1-2'
                          , 'obj1-3-1-3'
                          , {
                                Name: 'obj1-3-1-4'
                              , Children: [ 'obj1-3-1-4-1' ]
                            }
                        ]
                    }
                ]
            }
        ]
    }
}

class test_TreeViewEx_Tab_EventHandler {
    Add(*) {
        tvexTab := test_TreeViewEx_Tab.tvexTab
        tab := tvexTab.Tab
        name := test_TreeViewEx_Tab.input.Text
        if !name {
            i := 1
            while tab.FindTab('tvex' i) {
                ++i
            }
            name := 'tvex' i
        }
        flag := tvexTab.ActiveControls.Length
        item := tvexTab.Add(name)
        tvex := item.tvex
        tvex.Resizer := { W: 1, H: 1 }
        if !flag {
            test_TreeViewEx_Tab.controls.Push(tvex)
            test_TreeViewEx_Tab.g.resizer.Activate(test_TreeViewEx_Tab.controls)
        }
        obj := test_TreeViewEx_Tab_ObjDeepClone(test_TreeViewEx_Tab.Obj, name)
        tvex.AddObj(obj)
    }
    DeleteTab(*) {
        tvexTab := test_TreeViewEx_Tab.tvexTab
        tab := tvexTab.Tab
        name := test_TreeViewEx_Tab.input.Text
        count := tab.GetItemCount()
        if !name {
            name := tab.GetTabText(count, 100)
        }
        index := tab.FindTab(name)
        list := tvexTab.DeleteTab(name)
        resizer := test_TreeViewEx_Tab.g.resizer
        size := resizer.Size
        controls := test_TreeViewEx_Tab.controls
        for item in list {
            for _item in controls {
                if item.Hwnd = _item.Hwnd {
                    controls.RemoveAt(A_Index)
                    break
                }
            }
        }
        resizer.Activate(controls)
        if count > 1 {
            test_TreeViewEx_Tab.input.Text := tab.GetTabText(index = count ? index - 1 : index)
        } else {
            test_TreeViewEx_Tab.input.Text := ''
        }
    }
    DeleteTreeViewEx(*) {
        name := test_TreeViewEx_Tab.input.Text || test_TreeViewEx_Tab.tvexTab.Tab.Text
        tvex := test_TreeViewEx_Tab.tvexTab.DeleteTreeViewEx(name)
        resizer := test_TreeViewEx_Tab.g.resizer
        size := resizer.Size
        controls := test_TreeViewEx_Tab.controls
        for item in controls {
            if item.Hwnd = tvex.Hwnd {
                controls.RemoveAt(A_Index)
                break
            }
        }
        resizer.Activate(controls)
    }
    Hide(*) {
        name := test_TreeViewEx_Tab.tvexTab.Tab.Text
        item := test_TreeViewEx_Tab.tvexTab.Collection.GetValue(name)
        tvex := item.tvex
        tvex.Hide()
    }
    Show(*) {
        name := test_TreeViewEx_Tab.tvexTab.Tab.Text
        item := test_TreeViewEx_Tab.tvexTab.Collection.GetValue(name)
        tvex := item.tvex
        tvex.Show()
        tvex.Redraw()
    }
}

test_TreeViewEx_Tab_GuiResizerCallback(resizer) {
    for item in test_TreeViewEx_Tab.tvexTab.ActiveControls {
        item.tvex.Redraw()
    }
}

test_TreeViewEx_Tab_CallbackOnChange(tvexTab, formerActive, newlyActive) {
    resizer := test_TreeViewEx_Tab.g.resizer
    size := resizer.Size
    controls := test_TreeViewEx_Tab.controls
    for item in formerActive {
        for list in [ controls, size ] {
            for _item in list {
                if item.tvex.Hwnd = _item.Hwnd {
                    list.RemoveAt(A_Index)
                    break
                }
            }
        }
    }
    for item in newlyActive {
        controls.Push(item.tvex)
    }
    resizer.Activate(controls)
}

test_TreeViewEx_Tab_ObjDeepClone(Self, n, ConstructorParams?, Depth := 0) {
    GetTarget := IsSet(ConstructorParams) ? _GetTarget2 : _GetTarget1
    PtrList := Map(ObjPtr(Self), Result := GetTarget(Self))
    CurrentDepth := 0
    return _Recurse(Result, Self)

    _Recurse(Target, Subject) {
        CurrentDepth++
        for Prop in Subject.OwnProps() {
            Desc := Subject.GetOwnPropDesc(Prop)
            if Desc.HasOwnProp('Value') {
                Target.DefineProp(Prop, { Value: IsObject(Desc.Value) ? _ProcessValue(Desc.Value) : StrReplace(Desc.Value, 'obj1', n, , , 1) })
            } else {
                Target.DefineProp(Prop, Desc)
            }
        }
        if Target is Array {
            Target.Length := Subject.Length
            for item in Subject {
                if IsSet(item) {
                    Target[A_Index] := IsObject(item) ? _ProcessValue(item) : StrReplace(item, 'obj1', n, , , 1)
                }
            }
        } else if Target is Map {
            Target.Capacity := Subject.Capacity
            for Key, Val in Subject {
                if IsObject(Key) {
                    Target.Set(_ProcessValue(Key), IsObject(Val) ? _ProcessValue(Val) : Val)
                } else {
                    Target.Set(Key, IsObject(Val) ? _ProcessValue(Val) : Val)
                }
            }
        }
        CurrentDepth--
        return Target
    }
    _GetTarget1(Subject) {
        try {
            Target := GetObjectFromString(Subject.__Class)()
        } catch {
            if Subject Is Map {
                Target := Map()
            } else if Subject is Array {
                Target := Array()
            } else {
                Target := Object()
            }
        }
        try {
            ObjSetBase(Target, Subject.Base)
        }
        return Target
    }
    _GetTarget2(Subject) {
        if ConstructorParams.Has(Subject.__Class) {
            Target := GetObjectFromString(Subject.__Class)(ConstructorParams.Get(Subject.__Class)*)
        } else {
            try {
                Target := GetObjectFromString(Subject.__Class)()
            } catch {
                if Subject Is Map {
                    Target := Map()
                } else if Subject is Array {
                    Target := Array()
                } else {
                    Target := Object()
                }
            }
            try {
                ObjSetBase(Target, Subject.Base)
            }
        }
        return Target
    }
    _ProcessValue(Val) {
        if Type(Val) == 'ComValue' || Type(Val) == 'ComObject' {
            return Val
        }
        if PtrList.Has(ObjPtr(Val)) {
            return PtrList.Get(ObjPtr(Val))
        }
        if CurrentDepth == Depth {
            return Val
        } else {
            PtrList.Set(ObjPtr(Val), _Target := GetTarget(Val))
            return _Recurse(_Target, Val)
        }
    }

    /**
     * @description -
     * Use this function when you need to convert a string to an object reference, and the object
     * is nested within an object path. For example, we cannot get a reference to the class `Gui.Control`
     * by setting the string in double derefs like this: `obj := %'Gui.Control'%. Instead, we have to
     * traverse the path to get each object along the way, which is what this function does.
     * @param {String} Path - The object path.
     * @returns {*} - The object if it exists in the scope. Else, returns an empty string.
     * @example
     *  class MyClass {
     *      class MyNestedClass {
     *          static MyStaticProp := {prop1_1: 1, prop1_2: {prop2_1: {prop3_1: 'Hello, World!'}}}
     *      }
     *  }
     *  obj := GetObjectFromString('MyClass.MyNestedClass.MyStaticProp.prop1_2.prop2_1')
     *  OutputDebug(obj.prop3_1) ; Hello, World!
     * @
     */
    GetObjectFromString(Path) {
        Split := StrSplit(Path, '.')
        if !IsSet(%Split[1]%)
            return
        OutObj := %Split[1]%
        i := 1
        while ++i <= Split.Length {
            if !OutObj.HasOwnProp(Split[i])
                return
            OutObj := OutObj.%Split[i]%
        }
        return OutObj
    }
}
