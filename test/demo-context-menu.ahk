
; This has one dependency (not including TreeViewEx)
#include ..\src\TreeViewEx_ContextMenu.ahk

#SingleInstance force
#include ..\src\VENV.ahk

!esc::ExitApp()

demo_ContextMenu()


class demo_ContextMenu {
    static Call() {
        ; This is our example object that we are using to construct the nodes
        Obj := [
            {
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
          , {
                Name: 'obj2'
              , Children: [
                    'obj2-1'
                  , 'obj2-2'
                  , 'obj2-3'
                  , 'obj2-4'
                ]
            }
          , {
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
          , {
                Name: 'obj2'
              , Children: [
                    'obj2-1'
                  , 'obj2-2'
                  , 'obj2-3'
                  , 'obj2-4'
                ]
            }
          , {
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
          , {
                Name: 'obj2'
              , Children: [
                    'obj2-1'
                  , 'obj2-2'
                  , 'obj2-3'
                  , 'obj2-4'
                ]
            }
        ]

        ; Create Gui
        g := this.g := Gui('+Resize')
        g.OnEvent('Close', (*) => ExitApp())

        ; Add TreeViewEx
        tvex := this.tvex := TreeViewEx(g, { Width: 300, Rows: 17 })

        ; Add the context menu, with ShowTooltips enabled.
        tvex.SetContextMenu(TreeViewExContextMenu(, { ShowTooltips: true }))

        ; Add the nodes
        tvex.AddObjList(Obj)

        ; Show the gui
        tvex.GetPos(&x, &y, &w, &h)
        g.Show('x100 y100 w' (w + x + g.MarginX) ' h' (y + h + g.MarginY))
        tvex.Redraw()
    }
}
