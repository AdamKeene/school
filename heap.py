class Node:
    def __init__(self, data, left=None, right=None):
        self._data = data
        self._left = left
        self._right = right

class HeapBuilder:
    def create_min_heap(self, arr):
        n = len(arr)
        for i in range(n//2, -1, -1):
            self.min_heapify(arr, i, n)
        return arr