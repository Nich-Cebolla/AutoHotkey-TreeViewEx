
#include ..\src\TreeViewEx.ahk

test_AddObjList()

class test_AddObjList {
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
        g.Show('x20 w600 y20 h600')

        ; Add TreeViewEx
        tv1 := this.tv1 := TreeViewEx(
            g.Hwnd
          , {
                Width: 500
              , Rows: 20
              , Style: TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT | TVS_SHOWSELALWAYS | WS_CHILD | WS_CLIPSIBLINGS | WS_VISIBLE | TVS_EDITLABELS
              , ExStyle: TVS_EX_DOUBLEBUFFER | WS_EX_COMPOSITED
            }
        )
        list := this.list := [this.Obj.Clone(), this.Obj.Clone(), this.Obj.Clone()]
        list[1].Name := 'c' list[1].Name
        list[2].Name := 'b' list[2].Name
        list[3].Name := 'a' list[3].Name
        tv1.AddObjList(list)
        rc := tv1.GetRect()
        tv2 := this.tv2 := TreeViewEx(
            g.Hwnd
          , {
                Width: 500
              , Rows: 20
              , Style: TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT | TVS_SHOWSELALWAYS | WS_CHILD | WS_CLIPSIBLINGS | WS_VISIBLE | TVS_EDITLABELS
              , ExStyle: TVS_EX_DOUBLEBUFFER | WS_EX_COMPOSITED
              , Y: rc.B + g.MarginY
            }
        )
        struct := this.struct := TvInsertStruct()
        struct.hInsertAfter := TVI_SORT
        struct.mask := TVIF_TEXT | TVIF_STATE
        struct.state := TVIS_BOLD
        struct.stateMask := TVIS_BOLD
        tv2.AddTemplate('test', struct)
        tv2.AddObjListFromTemplate(list, 'test')
        rc := tv2.GetRect()

        x := 600
        y := 15
        

        g.show('w820 h' (rc.B + g.MarginY))
    }
}
