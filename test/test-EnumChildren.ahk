
#include ..\src\TreeViewEx.ahk

test()

class test {
    static Obj := {
        Name: 'obj1'
      , Children: [
            { Name: 'obj1-1', Children: [ 'obj1-1-1' ] }
          , { Name: 'obj1-2', Children: [ 'obj1-2-1' ] }
          , { Name: 'obj1-3', Children: [ { Name: 'obj1-3-1', Children: [
                'obj1-3-1-1', 'obj1-3-1-2', 'obj1-3-1-3', { Name: 'obj1-3-1-4', Children: [ 'obj1-3-1-4-1' ] }
            ] } ] }
        ]
    }
    static Call() {
        g := this.g := Gui('+Resize')
        tv := TreeViewEx(g, 'w600 r20 vTv')
        tv.AddObj(this.Obj, 'Name', 'Children')
        tv.SetNodeConstructor(TreeViewNode)
        g.Add('Button', 'section vBtnEnum', 'Enum').OnEvent('Click', HClickButtonEnum)
        g.Add('Button', 'ys vBtnEnumRecursive', 'EnumRecursive').OnEvent('Click', HClickButtonEnumRecursive)
        g.Add('Edit', 'xs w600 vEdtInput')
        g.Add('Edit', 'xs w600 r20 vEdtDisplay')
        g.show()

        return

        HClickButtonEnum(Ctrl, *) {
            g := Ctrl.Gui
            display := g['EdtDisplay']
            for id, node in g['Tv'].EnumChildren(g['EdtInput'].Text || 0) {
                display.Text .= '`r`n' id ' :: ' node.GetText()
            }
        }
        HClickButtonEnumRecursive(Ctrl, *) {
            g := Ctrl.Gui
            display := g['EdtDisplay']
            for parent, id, node in g['Tv'].EnumChildrenRecursive(g['EdtInput'].Text || 0) {
                display.Text .= '`r`n' id ' :: ' node.GetText() ' :: ' parent
            }
        }
    }
}
