
/**
 * {@link https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-size}
 */
class TreeViewEx_Size extends Buffer {
    /**
     * @description - The `Size` constructor.
     * @param [W] - The width value.
     * @param [H] - The height value.
     * @returns {Size}
     */
    __New(W?, H?) {
        this.Size := 8
        if IsSet(W) {
            this.W := W
        }
        if IsSet(H) {
            this.H := H
        }
    }
    W {
        Get => NumGet(this, 0, 'int')
        Set => NumPut('int', Value, this)
    }
    H {
        Get => NumGet(this, 4, 'int')
        Set => NumPut('int', Value, this, 4)
    }
}

