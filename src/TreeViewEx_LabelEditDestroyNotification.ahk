
class TreeViewEx_LabelEditDestroyNotification {
    static __New() {
        this.DeleteProp('__New')
        this.Collection := TreeViewExCollection_LabelEditDestroyNotification()
    }
    static Add(LabelEditDestroyNotificationObj) {
        if !this.Collection.InsertIfAbsent(LabelEditDestroyNotificationObj) {
            throw Error('The handle already exists in the collection.', , LabelEditDestroyNotificationObj.Handle)
        }
    }
    static Process(Handle) {
        OutputDebug('Tick: ' A_TickCount '; Func: ' A_ThisFunc '`n')
        this.Collection.DeleteValue(Handle, &LabelEditDestroyNotificationObj)
        LabelEditDestroyNotificationObj.WindowSubclass.Dispose()
        LabelEditDestroyNotificationObj.Callback.Call()
    }
    /**
     * Sets a callback that is called when the label edit control is destroyed. Use this to perform
     * any other actions related to editing the label of a TreeViewEx item, such as disabling hotkeys.
     *
     * @param {Integer} Handle - The handle to the label edit control. This can be obtained with
     * {@link TreeViewEx.Prototype.GetEditControl}.
     *
     * @param {*} Callback - A `Func` or callable object to call when the edit control is destroyed.
     */
    __New(Handle, Callback) {
        this.Handle := Handle
        this.Callback := Callback
        TreeViewEx_LabelEditDestroyNotification.Add(this)
        this.WindowSubclass := TreeViewEx_WindowSubclass(TreeViewEx_LabelEditSubclassProc, Handle)
    }
}
