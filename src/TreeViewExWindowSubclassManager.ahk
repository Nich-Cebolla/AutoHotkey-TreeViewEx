
class TreeViewExWindowSubclassManager {
    static __New() {
        this.DeleteProp('__New')
        this.Collection := TreeViewExWindowSubclassCollection()
        this.SetOnExit()
    }
    static AddNotifyHandler(HwndSubclass, CtrlObj, NotifyCode, Callback, CallAfter := true) {
        if !this.Collection.Has(HwndSubclass) {
            this.Collection.Set(HwndSubclass, TreeViewExWindowSubclassNotifyManager(HwndSubclass))
        }
        this.Collection.Get(HwndSubclass).Add(CtrlObj, NotifyCode, Callback, CallAfter)
    }
    static DeleteNotifyHandler(HwndSubclass, HwndControl, NotifyCode, Item?) {
        this.Collection.Get(HwndSubclass).Delete(HwndControl, NotifyCode, Item ?? unset)
    }
    static UnsetOnExit() {
        OnExit(this.HandlerOnExit, 0)
        this.HandlerOnExit := ''
    }
    static SetOnExit() {
        this.HandlerOnExit := ObjBindMethod(this, 'OnExit')
        OnExit(this.HandlerOnExit, 1)
    }
    static OnExit(*) {
        for hwndSubclass, collectionControl in this.Collection {
            collectionControl.Dispose()
        }
        this.UnsetOnExit()
    }
    static RemoveControl(HwndSubclass, HwndControl) {
        this.Collection.Get(HwndSubclass).RemoveControl(HwndControl)
    }
}

class TreeViewExWindowSubclassNotifyManager {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.WindowSubclass := proto.Collection := ''
    }
    __New(HwndSubclass) {
        this.HwndSubclass := HwndSubclass
        this.WindowSubclass := WindowSubclass(TreeViewEx_SubclassProc, this.HwndSubclass, , ObjPtr(this))
        this.Collection := TreeViewExWindowSubclasscollectionControl()
    }
    Add(CtrlObj, NotifyCode, Callback, CallAfter := true) {
        if !this.Collection.Has(CtrlObj.Hwnd) {
            this.Collection.Set(CtrlObj.Hwnd, TreeViewExWindowSubclassNotifyCodeCollection(, , Map('Ctrl', CtrlObj)))
        }
        if !this.Collection.Get(CtrlObj.Hwnd).Has(NotifyCode) {
            this.Collection.Get(CtrlObj.Hwnd).Set(NotifyCode, [])
        }
        if CallAfter {
            this.Collection.Get(CtrlObj.Hwnd).Get(NotifyCode).Push(Callback)
        } else {
            this.Collection.Get(CtrlObj.Hwnd).Get(NotifyCode).InsertAt(1, Callback)
        }
    }
    Delete(HwndControl, NotifyCode, Item?) {
        collectionControl := this.Collection.Get(HwndControl)
        if IsSet(Item) {
            list := collectionControl.Get(NotifyCode)
            flag := list.Length
            if IsObject(Item) {
                ptr := ObjPtr(Item)
                for _item in list {
                    if ObjPtr(_item) = ptr {
                        list.RemoveAt(A_Index)
                        break
                    }
                }
            } else {
                for _item in list {
                    if _item = Item {
                        list.RemoveAt(A_Index)
                        break
                    }
                }
            }
            if list.Length == flag {
                throw UnsetItemError('Item not found.', -1)
            }
            if !list.Length {
                collectionControl.Delete(NotifyCode)
            }
        } else {
            collectionControl.Delete(NotifyCode)
        }
        if !this.Collection.Get(HwndControl).Count {
            this.Collection.Delete(HwndControl)
        }
    }
    Dispose() {
        if IsObject(this.WindowSubclass) && HasMethod(this.WindowSubclass, 'Dispose') {
            this.WindowSubclass.Dispose()
        }
    }
    RemoveControl(HwndControl) {
        this.Collection.Delete(HwndControl)
    }
    __Delete() {
        this.Dispose()
    }
}

class TreeViewExWindowSubclassCollectionBase extends Map {
    __New(CaseSense := true, Default := '', Params?) {
        this.CaseSense := CaseSense
        this.Default := Default
        if IsSet(Params) {
            for name, value in Params {
                this.%name% := value
            }
        }
    }
}

class TreeViewExWindowSubclassCollection extends TreeViewExWindowSubclassCollectionBase {
}

class TreeViewExWindowSubclasscollectionControl extends TreeViewExWindowSubclassCollectionBase {
}

class TreeViewExWindowSubclassNotifyCodeCollection extends TreeViewExWindowSubclassCollectionBase {
}
