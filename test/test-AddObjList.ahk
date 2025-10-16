
#SingleInstance force
#include ..\src\VENV.ahk

test_AddObjList()

class test_AddObjList {
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
        ; Add TreeViewEx
        tvex1 := this.tvex1 := TreeViewEx(g, { Width: 300, Rows: 12 })
        list := this.list := [this.Obj.Clone(), this.Obj.Clone(), this.Obj.Clone()]
        list[1].Name := 'c' list[1].Name
        list[2].Name := 'b' list[2].Name
        list[3].Name := 'a' list[3].Name
        tvex1.AddObjList(list)
        tvex1.ExpandRecursive()
        tvex1.EnsureVisible()

        rc := tvex1.GetRect()
        tvex2 := this.tvex2 := TreeViewEx(g, { Width: 300, Rows: 12 , Y: rc.B + g.MarginY })
        struct := this.struct := TvInsertStruct()
        struct.hInsertAfter := TVI_SORT
        struct.mask := TVIF_TEXT | TVIF_STATE
        struct.state := TVIS_BOLD
        struct.stateMask := TVIS_BOLD
        tvex2.AddTemplate('test', struct)
        tvex2.AddObjListFromTemplate(list, 'test')
        tvex2.ExpandRecursive()
        tvex2.EnsureVisible()

        rc := tvex2.GetRect()
        g.show('w' (rc.R + g.MarginX) ' h' (rc.B + g.MarginY))
        tvex1.Redraw()
    }
}
