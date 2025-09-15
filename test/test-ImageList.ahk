
; https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/GDI/ImageList.ahk
#include <ImageList>

#include ..\src\TreeViewEx.ahk

test_ImageList()

class test_ImageList {
    static PathIcons := 'icons'
    static __New() {
        this.DeleteProp('__New')
        paths := this.paths := Map('20', [], '25', [], '30', [], '35', [], '40', [])
        loop Files this.PathIcons '\*.ico' {
            if RegExMatch(A_LoopFileName, '^\d+', &match) {
                paths.Get(match[0]).Push(A_LoopFileFullPath)
            }
        }
        this.Obj := {
            Name: 'obj1'
          , Children: [
                { Name: 'obj1-1', Children: [ 'obj1-1-1' ] }
              , { Name: 'obj1-2', Children: [ 'obj1-2-1' ] }
              , { Name: 'obj1-3', Children: [ { Name: 'obj1-3-1', Children: [
                    'obj1-3-1-1', 'obj1-3-1-2', 'obj1-3-1-3', { Name: 'obj1-3-1-4', Children: [ 'obj1-3-1-4-1' ] }
                ] } ] }
            ]
        }
    }
    static Call() {
        paths := this.paths
        listPath := paths.Get('20')

        imgList := this.ImageList := ImageList(listPath)

        g := this.g := Gui('+Resize')

        tv1 := this.tv1 := TreeViewEx(g.Hwnd, { Width: 600, Rows: 20 })
        tv1.SetImageList(TVSIL_NORMAL, imgList.Handle)
        if tv1.GetImageList(TVSIL_NORMAL) != imgList.Handle {
            throw Error('Mismatched image list handles.', -1)
        }
        listObj := this.listObj := [this.Obj.Clone(), this.Obj.Clone(), this.Obj.Clone()]
        struct1 := this.struct1 := TvInsertStruct()
        struct1.hInsertAfter := TVI_SORT
        struct1.mask := TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE
        struct1.iImage := 0
        struct1.iSelectedImage := 1
        tv1.AddTemplate('test1', struct1)
        tv1.AddObjListFromTemplate(listObj, 'test1')

        tv1.GetPos(, &y, , &h)
        tv2 := this.tv2 := TreeViewEx(g.Hwnd, { Width: 600, Rows: 20, Y: y + h + 10, X: 10 })
        tv2.SetImageList(TVSIL_STATE, imgList.Handle)
        if tv2.GetImageList(TVSIL_STATE) != imgList.Handle {
            throw Error('Mismatched image list handles.', -1)
        }
        struct2 := this.struct2 := TvInsertStruct()
        struct2.hInsertAfter := TVI_SORT
        struct2.SetStateImage(1)
        tv2.AddTemplate('test2', struct2)
        tv2.AddObjListFromTemplate(listObj, 'test2')

        g.Add('Edit', 'section w100 vEdtIndex', '1')
        g.Add('Button', 'ys vBtnState', 'Set TVSIL_STATE').OnEvent('Click', HClickButtonState)
        g.Add('Button', 'ys vBtnExit', 'Exit').OnEvent('Click', (*) => ExitApp())
        g.ImageList := imgList
        g.Show()

        return

        HClickButtonState(Ctrl, *) {
            struct := TvItemEx()
            struct.mask := struct.mask | TVIF_HANDLE
            struct.SetStateImage(Ctrl.Gui['EdtIndex'].Text)
            for parent, id in this.tv2.EnumChildrenRecursive() {
                struct.hItem := id
                this.tv2.SetItem(struct)
            }
        }
    }
}
