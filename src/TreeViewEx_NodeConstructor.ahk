
/**
 * @classdesc - The purpose of {@link TreeViewEx_NodeConstructor} is to provide a systematic entry
 * point for making changes to the node base object.
 *
 * When our code calls {@link TreeViewEx.Prototype.SetNodeConstructor}, the function creates an
 * intermediate base object that acts as a bridge between the class passed to the `NodeClass`
 * parameter and the instances of the class which get created through the use of the
 * {@link TreeViewEx} object.
 *
 * @example
 * SetNodeConstructor(NodeClass) {
 *     this.Constructor := TreeViewEx_NodeConstructor()
 *     this.Constructor.Base := NodeClass
 *     this.Constructor.Prototype := {
 *         HwndCtrl: this.Hwnd
 *       , __Class: NodeClass.Prototype.__Class
 *     }
 *     ObjSetBase(this.Constructor.Prototype, NodeClass.Prototype)
 *     this.Collection := TreeViewExCollection_Node()
 * }
 * @
 *
 * There's a number of benefits to doing this, each benefit an extension of one fundamental purpose -
 * this allows our code to make changes to all of the node objects associated with this
 * {@link TreeViewEx} object, without influencing the node objects associated with any other
 * {@link TreeViewEx} object.
 */
class TreeViewEx_NodeConstructor extends Class {
    ProtoDefineProp(Name, Descriptor) {
        this.Prototype.DefineProp(Name, Descriptor)
    }
    ProtoDeleteProp(Name) {
        this.Prototype.DeleteProp(Name)
    }
    ProtoDeletePropIf(Name) {
        if this.Prototype.HasOwnProp(Name) {
            this.Prototype.DeleteProp(Name)
            return 1
        }
    }
    ProtoGetProp(Name) {
        return this.Prototype.%Name%
    }
    ProtoGetPropIf(Name, &OutValue) {
        if HasProp(this.Prototype, Name) {
            OutValue := this.Prototype.%Name%
            return 1
        }
    }
    ProtoGetPropDesc(Name) {
        return this.Prototype.GetOwnPropDesc(Name)
    }
    ProtoGetPropDescIf(Name, &OutValue) {
        if this.Prototype.HasOwnProp(Name) {
            OutValue := this.Prototype.GetOwnPropDesc(Name)
            return 1
        }
    }
    ProtoHasProp(Name) {
        return HasProp(this.Prototype, Name)
    }
    ProtoHasOwnProp(Name) {
        return this.Prototype.HasOwnProp(Name)
    }
    ProtoSetProp(Name, Value) {
        this.Prototype.DefineProp(Name, { Value: Value })
    }
}
