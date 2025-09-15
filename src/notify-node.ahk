
TreeViewEx_HandlerBeginLabelEdit_Node(Ctrl, _tvDispInfoEx) {
    if _tvDispInfoEx.pszText {
        return Ctrl.GetNode(_tvDispInfoEx.hItem).OnBeginLabelEdit(_tvDispInfoEx)
    }
}
TreeViewEx_HandlerDeleteItem_Node(Ctrl, _nmTreeView) {
    return Ctrl.GetNode(_nmTreeView.hItem_old).OnDeleteItem(_nmTreeView)
}
TreeViewEx_HandlerEndLabelEdit_Node(Ctrl, _tvDispInfoEx) {
    if _tvDispInfoEx.pszText {
        return Ctrl.GetNode(_tvDispInfoEx.hItem).OnEndLabelEdit(_tvDispInfoEx)
    }
}
TreeViewEx_HandlerGetDispInfo_Node(Ctrl, _tvDispInfoEx) {
    if node := Ctrl.GetNode(_tvDispInfoEx.hItem) {
        if _tvDispInfoEx.mask & TVIF_TEXT {
            _tvDispInfoEx.pszText := node.OnGetInfoName(_tvDispInfoEx)
        }
        if _tvDispInfoEx.mask & TVIF_IMAGE {
            _tvDispInfoEx.iImage := node.OnGetInfoImage(_tvDispInfoEx)
        }
        if _tvDispInfoEx.mask & TVIF_SELECTEDIMAGE {
            _tvDispInfoEx.iSelectedImage := node.OnGetInfoSelectedImage(_tvDispInfoEx)
        }
        if _tvDispInfoEx.mask & TVIF_CHILDREN {
            _tvDispInfoEx.cChildren := node.OnGetInfoChildren(_tvDispInfoEx)
        }
    }
}
TreeViewEx_HandlerGetInfoTip_Node(Ctrl, _tvGetInfoTip) {
    return Ctrl.GetNode(_tvGetInfoTip.hItem).OnGetInfoTip(_tvGetInfoTip)
}
TreeViewEx_HandlerItemChanged_Node(Ctrl, _tvItemChanged) {
    return Ctrl.GetNode(_tvItemChanged.hItem).OnItemChanged(_tvItemChanged)
}
TreeViewEx_HandlerItemChanging_Node(Ctrl, _tvItemChanged) {
    return Ctrl.GetNode(_tvItemChanged.hItem).OnItemChanging(_tvItemChanged)
}
TreeViewEx_HandlerItemExpanded_Node(Ctrl, _nmTreeView) {
    return Ctrl.GetNode(_nmTreeView.hItem_new).OnItemExpanded(_nmTreeView)
}
TreeViewEx_HandlerItemExpanding_Node(Ctrl, _nmTreeView) {
    return Ctrl.GetNode(_nmTreeView.hItem_new).OnItemExpanding(_nmTreeView)
}
TreeViewEx_HandlerSetDispInfo_Node(Ctrl, _tvDispInfoEx) {
    if node := Ctrl.GetNode(_tvDispInfoEx.hItem) {
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
TreeViewEx_HandlerSingleExpand_Node(Ctrl, _nmTreeView) {
    return Ctrl.GetNode(_nmTreeView.hItem_new).OnSingleExpand(_nmTreeView)
}
