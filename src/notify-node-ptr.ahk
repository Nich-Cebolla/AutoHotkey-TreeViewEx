TreeViewEx_HandlerBeginLabelEdit_Node_Ptr(Ctrl, _tvDispInfoEx) {
    if _tvDispInfoEx.lParam {
        if _tvDispInfoEx.pszText {
            return ObjFromPtrAddRef(_tvDispInfoEx.lParam).OnBeginLabelEdit(_tvDispInfoEx)
        }
    } else {
        return g_TreeViewEx_Node.OnBeginLabelEdit(_tvDispInfoEx)
    }
}
TreeViewEx_HandlerDeleteItem_Node_Ptr(Ctrl, _nmTreeView) {
    if _nmTreeView.lParam_old {
        return ObjFromPtrAddRef(_nmTreeView.lParam_old).OnDeleteItem(_nmTreeView)
    } else {
        g_TreeViewEx_Node.OnDeleteItem(_nmTreeView)
    }
}
TreeViewEx_HandlerEndLabelEdit_Node_Ptr(Ctrl, _tvDispInfoEx) {
    if _tvDispInfoEx.pszText {
        if _tvDispInfoEx.lParam {
            return ObjFromPtrAddRef(_tvDispInfoEx.lParam).OnEndLabelEdit(_tvDispInfoEx)
        } else {
            g_TreeViewEx_Node.OnEndLabelEdit(_tvDispInfoEx)
        }
    }
}
TreeViewEx_HandlerGetDispInfo_Node_Ptr(Ctrl, _tvDispInfoEx) {
    node := _tvDispInfoEx.lParam ? ObjFromPtrAddRef(_tvDispInfoEx.lParam) : g_TreeViewEx_Node
    if _tvDispInfoEx.mask & TVIF_TEXT {
        node.OnGetInfoName(_tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_IMAGE {
        node.OnGetInfoImage(_tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_SELECTEDIMAGE {
        node.OnGetInfoSelectedImage(_tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_CHILDREN {
        node.OnGetInfoChildren(_tvDispInfoEx)
    }
}
TreeViewEx_HandlerGetInfoTip_Node_Ptr(Ctrl, _tvGetInfoTip) {
    if _tvGetInfoTip.lParam {
        return ObjFromPtrAddRef(_tvGetInfoTip.lParam).OnGetInfoTip(_tvGetInfoTip)
    } else {
        g_TreeViewEx_Node.OnGetInfoTip(_tvGetInfoTip)
    }
}
TreeViewEx_HandlerItemChanged_Node_Ptr(Ctrl, _tvItemChanged) {
    if _tvItemChanged.lParam {
        return ObjFromPtrAddRef(_tvItemChanged.lParam).OnItemChanged(_tvItemChanged)
    } else {
        g_TreeViewEx_Node.OnItemChanged(_tvItemChanged)
    }
}
TreeViewEx_HandlerItemChanging_Node_Ptr(Ctrl, _tvItemChanged) {
    if _tvItemChanged.lParam {
        return ObjFromPtrAddRef(_tvItemChanged.lParam).OnItemChanging(_tvItemChanged)
    } else {
        g_TreeViewEx_Node.OnItemChanging(_tvItemChanged)
    }
}
TreeViewEx_HandlerItemExpanded_Node_Ptr(Ctrl, _nmTreeView) {
    if _nmTreeView.lParam_new {
        return ObjFromPtrAddRef(_nmTreeView.lParam_new).OnItemExpanded(_nmTreeView)
    } else {
        g_TreeViewEx_Node.OnItemExpanded(_nmTreeView.action, _nmTreeView)
    }
}
TreeViewEx_HandlerItemExpanding_Node_Ptr(Ctrl, _nmTreeView) {
    if _nmTreeView.lParam_new {
        return ObjFromPtrAddRef(_nmTreeView.lParam_new).OnItemExpanding(_nmTreeView)
    } else {
        g_TreeViewEx_Node.OnItemExpanding(_nmTreeView.action, _nmTreeView)
    }
}
TreeViewEx_HandlerSetDispInfo_Node_Ptr(Ctrl, _tvDispInfoEx) {
    node := _tvDispInfoEx.lParam ? ObjFromPtrAddRef(_tvDispInfoEx.lParam) : g_TreeViewEx_Node
    if _tvDispInfoEx.mask & TVIF_TEXT {
        node.OnSetInfoName(_tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_IMAGE {
        node.OnSetInfoImage(_tvDispInfoEx)
    }
    if _tvDispInfoEx.mask & TVIF_SELECTEDIMAGE {
        node.OnSetInfoSelectedImage(_tvDispInfoEx)
    }
}
TreeViewEx_HandlerSingleExpand_Node_Ptr(Ctrl, _nmTreeView) {
    if _nmTreeView.lParam_new {
        return ObjFromPtrAddRef(_nmTreeView.lParam_new).OnSingleExpand(_nmTreeView)
    } else {
        g_TreeViewEx_Node.OnSingleExpand(_nmTreeView)
    }
}
