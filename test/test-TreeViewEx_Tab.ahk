
#SingleInstance force
#include ..\src\TreeViewEx_Tab.ahk

test_TreeViewEx_Tab()

class test_TreeViewEx_Tab {

    static Call() {
        g := this.g := Gui('+Resize', , test_TreeViewEx_Tab_EventHandler())
        tvexTab := this.tvexTab := TreeViewEx_Tab(g, { opt: 'w400 r15', name: 'tab' })
        tvex := this.tvex := tvexTab.Add('tvex1')
        obj := test_TreeViewEx_Tab_ObjDeepClone(test_TreeViewEx_Tab.Obj, '-tvex1')
        tvex.AddObj(obj)
        rc := tvexTab.Tab.GetClientWindowRect()
        tvexTab.Tab.UseTab()
        this.input := g.Add('Edit', 'x' g.MarginX ' y' (rc.B + g.MarginY) ' w' rc.W ' r1 Section vEdtInput')
        g.Add('Button', 'xs section vBtnAdd', 'Add').OnEvent('Click', 'Add')
        g.Add('Button', 'ys vBtnDeleteTab', 'DeleteTab').OnEvent('Click', 'DeleteTab')
        g.Add('Button', 'ys vBtnDeleteTreeViewEx', 'DeleteTreeViewEx').OnEvent('Click', 'DeleteTreeViewEx')
        g.Add('Button', 'ys vBtnHide', 'Hide').OnEvent('Click', 'Hide')
        g.Add('Button', 'ys vBtnShow', 'Show').OnEvent('Click', 'Show')
        g.Show()
        tvex.Redraw()
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
        tvex := test_TreeViewEx_Tab.tvexTab.Add(name)
        obj := test_TreeViewEx_Tab_ObjDeepClone(test_TreeViewEx_Tab.Obj, '-' name)
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
        tvexTab.DeleteTab(name)
        if count > 1 {
            test_TreeViewEx_Tab.input.Text := tab.GetTabText(index = count ? index - 1 : index)
        } else {
            test_TreeViewEx_Tab.input.Text := ''
        }
    }
    DeleteTreeViewEx(*) {
        name := test_TreeViewEx_Tab.input.Text || test_TreeViewEx_Tab.tvexTab.Tab.Text
        test_TreeViewEx_Tab.tvexTab.DeleteTreeViewEx(name)
    }
    Hide(*) {
        name := test_TreeViewEx_Tab.tvexTab.Tab.Text
        item := test_TreeViewEx_Tab.tvexTab.Collection.GetValue(name)
        tvex := item.tvex
        tvex.Enabled := tvex.Visible := 0
        tvex.Redraw()
    }
    Show(*) {
        name := test_TreeViewEx_Tab.tvexTab.Tab.Text
        item := test_TreeViewEx_Tab.tvexTab.Collection.GetValue(name)
        tvex := item.tvex
        tvex.Enabled := tvex.Visible := 1
        tvex.Redraw()
    }
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
                Target.DefineProp(Prop, { Value: IsObject(Desc.Value) ? _ProcessValue(Desc.Value) : RegExReplace(Desc.Value, '\d+', n, , 1) })
            } else {
                Target.DefineProp(Prop, Desc)
            }
        }
        if Target is Array {
            Target.Length := Subject.Length
            for item in Subject {
                if IsSet(item) {
                    Target[A_Index] := IsObject(item) ? _ProcessValue(item) : item
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
