
TreeViewEx_CallbackValue_Hwnd(value) {
    return value.Hwnd
}
class TreeViewExCollection extends Container {
    static __New() {
        this.DeleteProp('__New')
        proto := Container.CbNumber(TreeViewEx_CallbackValue_Hwnd)
        proto.__Class := proto.__Class
        this.Prototype := proto
    }
}

class TreeViewExCollection_Node extends Container {
    static __New() {
        this.DeleteProp('__New')
        proto := Container.CbNumber(TreeViewEx_CallbackValue_Handle)
        proto.__Class := proto.__Class
        this.Prototype := proto
    }
}
TreeViewEx_CallbackValue_Handle(value) {
    return value.Handle
}


class TreeViewExCollection_Template extends Map {
    __New(CaseSense := false) {
        this.CaseSense := CaseSense
    }
}

class TreeViewExCollection_Code extends Container {
    static __New() {
        this.DeleteProp('__New')
        proto := Container.CbNumber(TreeViewEx_CallbackValue_Code)
        proto.__Class := proto.__Class
        this.Prototype := proto
    }
}
TreeViewEx_CallbackValue_Code(value) {
    return value.Code
}

; This does not use sort / find capabilities because the position where values are added depends
; on the parameter `AddRemove`.
class TreeViewExCollection_Callback extends Container {
    __New(Code) {
        this.Code := Code
    }
    DeleteCallback(Callback) {
        ptr := ObjPtr(Callback)
        for cb in this {
            if ptr = ObjPtr(cb) {
                this.RemoveAt(A_Index)
                return this.Length
            }
        }
        throw UnsetItemError('Callback not found.', , HasProp(Callback, 'Name') ? Callback.Name : '')
    }
}

class TreeViewExCollection_LabelEditDestroyNotification extends Container {
    static __New() {
        this.DeleteProp('__New')
        proto := Container.CbNumber(TreeViewEx_CallbackValue_Handle)
        proto.__Class := proto.__Class
        this.Prototype := proto
    }
}
