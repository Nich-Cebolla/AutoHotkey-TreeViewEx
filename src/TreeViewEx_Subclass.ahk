
class TreeViewEx_Subclass {
    static __New() {
        this.DeleteProp('__New')
        proto := this.Prototype
        proto.WindowSubclass := proto.NotifyCollection := proto.MessageCollection := proto.CommandCollection :=
        ''
        proto.flag_Command := proto.flag_Message := proto.flag_Notify := 0
    }
    __New(SubclassProc, HwndSubclass, uIdSubclass) {
        this.WindowSubclass := TreeViewEx_WindowSubclass(SubclassProc, HwndSubclass, uIdSubclass, ObjPtr(this))
    }
    Add(Name, Code, Callback, AddRemove := 1) {
        if !this.flag_%Name% {
            if !this.HasOwnProp(Name 'Collection') {
                this.%Name%Collection := TreeViewExCollection_Code()
            }
            this.flag_%Name% := 1
            if !this.WindowSubclass.IsInstalled {
                this.WindowSubclass.Install()
            }
        }
        Collection := this.%Name%Collection
        if !Collection.Find(Code, &collectionCallback) {
            collectionCallback := TreeViewExCollection_Callback(Code)
            Collection.Insert(collectionCallback)
        }
        switch AddRemove, 0 {
            case 1: collectionCallback.Push(Callback)
            case -1: collectionCallback.InsertAt(1, Callback)
        }
    }
    Delete(Name, Code, Callback?) {
        Collection := this.%Name%Collection
        if IsSet(Callback) {
            if !Collection.Find(Code, &collectionCallback) {
                throw UnsetItemError('Code not found.', , Code)
            }
            ; DeleteCallback returns the number of items in the collection after deletion.
            if !collectionCallback.DeleteCallback(Callback) {
                Collection.Remove(Code)
            }
        } else {
            Collection.Remove(Code)
        }
        if !Collection.Length {
            this.flag_%Name% := 0
        }
        if this.flag_Notify + this.flag_Message + this.flag_Command = 0 {
            this.WindowSubclass.Uninstall()
        }
    }
    Dispose() {
        if this.WindowSubclass {
            this.WindowSubclass.Dispose()
        }
        for name in [ 'Command', 'Message', 'Notify' ] {
            if this.HasOwnProp(name 'Collection') {
                collection := this.%name%Collection
                for callback in collection {
                    callback.Length := 0
                }
                collection.Length := 0
                this.DeleteProp(name 'Collection')
            }
        }
    }
    CommandAdd(CommandCode, Callback, AddRemove := true) {
        this.Add('Command', CommandCode, Callback, AddRemove)
    }
    CommandDelete(CommandCode, Callback?) {
        this.Delete('Command', CommandCode, Callback ?? unset)
    }
    CommandGet(Code) {
        if this.CommandCollection.Find(Code, &collectionCallback) {
            return collectionCallback
        }
    }
    MessageAdd(MessageCode, Callback, AddRemove := true) {
        this.Add('Message', MessageCode, Callback, AddRemove)
    }
    MessageDelete(MessageCode, Callback?) {
        this.Delete('Message', MessageCode, Callback ?? unset)
    }
    MessageGet(Code) {
        if this.MessageCollection.Find(Code, &collectionCallback) {
            return collectionCallback
        }
    }
    NotifyAdd(NotifyCode, Callback, AddRemove := true) {
        this.Add('Notify', NotifyCode, Callback, AddRemove)
    }
    NotifyDelete(NotifyCode, Callback?) {
        this.Delete('Notify', NotifyCode, Callback ?? unset)
    }
    NotifyGet(Code) {
        if this.NotifyCollection.Find(Code, &collectionCallback) {
            return collectionCallback
        }
    }
    __Delete() {
        this.Dispose()
    }
    HwndSubclass => this.WindowSubclass.HwndSubclass
    uIdSubclass => this.WindowSubclass.uIdSubclass
}
