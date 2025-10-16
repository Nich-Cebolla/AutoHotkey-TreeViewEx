
#SingleInstance force
#include ..\src\VENV.ahk

test_EnumChildren()

class test_EnumChildren {
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
    static Call() {
        g := this.g := Gui('+Resize')
        g.OnEvent('Close', (*) => ExitApp())
        tvex := this.tvex := TreeViewEx(g, { Width: 300, Rows: 12 })
        tvex.AddObj(this.Obj)
        tvex.GetPos(&x, &y, &w, &h)
        g.Add('Button', 'x' x ' y' (y + h + g.MarginY) ' section vBtnEnum', 'Enum').OnEvent('Click', HClickButtonEnum)
        g.Add('Button', 'ys vBtnEnumRecursive', 'EnumRecursive').OnEvent('Click', HClickButtonEnumRecursive)
        g.Add('Edit', 'xs w' w ' vEdtInput')
        edt := g.Add('Edit', 'xs w' w ' r20 vEdtDisplay')
        edt.GetPos(&x, &y, &w, &h)
        g.Show('x100 y100 w' (x + w + g.MarginX) ' h' (y + h + g.MarginY))
        tvex.ExpandRecursive()

        return

        HClickButtonEnum(Ctrl, *) {
            g := Ctrl.Gui
            display := g['EdtDisplay']
            tvex := test_EnumChildren.tvex
            display.Text := '`r`n' display.Text
            for id in tvex.EnumChildren(Trim(g['EdtInput'].Text, '`s`t') || 0) {
                display.Text := id ' :: ' tvex.GetText(id) '`r`n' display.Text
            }
        }
        HClickButtonEnumRecursive(Ctrl, *) {
            g := Ctrl.Gui
            display := g['EdtDisplay']
            tvex := test_EnumChildren.tvex
            display.Text := '`r`n' display.Text
            for id, parent in tvex.EnumChildrenRecursive(Trim(g['EdtInput'].Text, '`s`t') || 0) {
                display.Text := id ' :: ' tvex.GetText(id) ' :: ' parent '`r`n' display.text
            }
        }
    }
}
