TreeViewEx_HandlerBeginLabelEdit_Node_C(Ctrl, _tvDispInfoEx) {
    if _tvDispInfoEx.pszText {
        if node := Ctrl.GetNode_C(_tvDispInfoEx.hItem) {
            return node.OnBeginLabelEdit(_tvDispInfoEx)
        }
    }
}
TreeViewEx_HandlerDeleteItem_Node_C(Ctrl, _nmTreeView) {
    return Ctrl.GetNode_C(_nmTreeView.hItem_old).OnDeleteItem(_nmTreeView)
}
TreeViewEx_HandlerEndLabelEdit_Node_C(Ctrl, _tvDispInfoEx) {
    if _tvDispInfoEx.pszText {
        if node := Ctrl.GetNode_C(_tvDispInfoEx.hItem) {
            return node.OnEndLabelEdit(_tvDispInfoEx)
        }
    }
}
TreeViewEx_HandlerGetDispInfo_Node_C(Ctrl, _tvDispInfoEx) {
    if node := Ctrl.GetNode_C(_tvDispInfoEx.hItem) {
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
}
TreeViewEx_HandlerGetInfoTip_Node_C(Ctrl, _tvGetInfoTip) {
    return Ctrl.GetNode_C(_tvGetInfoTip.hItem).OnGetInfoTip(_tvGetInfoTip)
}
TreeViewEx_HandlerItemChanged_Node_C(Ctrl, _tvItemChanged) {
    return Ctrl.GetNode_C(_tvItemChanged.hItem).OnItemChanged(_tvItemChanged)
}
TreeViewEx_HandlerItemChanging_Node_C(Ctrl, _tvItemChanged) {
    return Ctrl.GetNode_C(_tvItemChanged.hItem).OnItemChanging(_tvItemChanged)
}
TreeViewEx_HandlerItemExpanded_Node_C(Ctrl, _nmTreeView) {
    return Ctrl.GetNode_C(_nmTreeView.hItem_new).OnItemExpanded(_nmTreeView)
}
TreeViewEx_HandlerItemExpanding_Node_C(Ctrl, _nmTreeView) {
    return Ctrl.GetNode_C(_nmTreeView.hItem_new).OnItemExpanding(_nmTreeView)
}
TreeViewEx_HandlerSetDispInfo_Node_C(Ctrl, _tvDispInfoEx) {
    if node := Ctrl.GetNode_C(_tvDispInfoEx.hItem) {
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
}
TreeViewEx_HandlerSingleExpand_Node_C(Ctrl, _nmTreeView) {
    return Ctrl.GetNode_C(_nmTreeView.hItem_new).OnSingleExpand(_nmTreeView)
}
