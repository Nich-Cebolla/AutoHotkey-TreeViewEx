
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
        tv1 := this.tv1 := TreeViewEx(g, 'w600 r20 vTv1')
        list := this.list := [this.Obj.Clone(), this.Obj.Clone(), this.Obj.Clone()]
        list[1].Name := 'c' list[1].Name
        list[2].Name := 'b' list[2].Name
        list[3].Name := 'a' list[3].Name
        tv1.AddObjList(list)
        tv2 := this.tv2 := TreeViewEx(g, 'w600 r20 vTv2')
        struct := this.struct := TvInsertStructW()
        struct.hInsertAfter := TVI_SORT
        struct.mask := TVIF_TEXT | TVIF_STATE
        struct.state := TVIS_BOLD
        struct.stateMask := TVIS_BOLD
        tv2.AddTemplate('test', struct)
        tv2.AddObjListFromTemplate(list, 'test')

        g.show()
    }
}
