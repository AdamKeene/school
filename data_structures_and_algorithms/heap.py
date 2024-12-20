from Tree import LinkedBinaryTree

class Node:
    def __init__(self, data, left=None, right=None):
        self._data = data
        self._left = left
        self._right = right

    class _Item:
        __slots__ = '_key', '_value'

        def __init__(self, k, v):
            self._key = k
            self._value = v

        def __lt__(self, other):
            return self._key < other._key

    def is_empty(self):
        return len(self) == 0

class HeapBuilder(Node):
    def __init__ (self, contents=()):
        if contents and isinstance(contents[0], tuple):
            self._data = [self._Item(k,v) for k,v in contents]
        else:
            self._data = [self._Item(k,k) for k in contents]
        if len(self._data) > 1:
            self._heapify()

    def heapify(self, minheap=True):
        start = self._parent(len(self._data) - 1) 
        for j in range(start, -1, -1):
            if minheap == True:
                self._downheap(j)
            else:
                self._downheap(j, minheap=False)

    def create_max_heap(self, arr):
        self._data = [self._Item(k, k) for k in arr]
        self.heapify(False)
        return [item._key for item in self._data]

    def create_min_heap(self, arr):
        self._data = [self._Item(k, k) for k in arr]
        self.heapify()
        return [item._key for item in self._data]
    
    def _parent(self, j):
        return (j - 1) // 2
    
    def _left(self, j):
        return 2 * j + 1
    
    def _right(self, j):
        return 2 * j + 2
    
    def _has_left(self, j):
        return self._left(j) < len(self._data)
    
    def _has_right(self, j):
        return self._right(j) < len(self._data)
    
    def _swap(self, i, j):
        self._data[i], self._data[j] = self._data[j], self._data[i]

    def _upheap(self, j, minheap=True):
        parent = self._parent(j)
        if minheap:
            if j > 0 and self._data[j] < self._data[parent]:
                self._swap(j, parent)
                self._upheap(parent, minheap)
        else:
            if j > 0 and self._data[j] > self._data[parent]:
                self._swap(j, parent)
                self._upheap(parent, minheap=False)

    def _downheap(self, j, minheap=True):
        if self._has_left(j):
            left = self._left(j)
            small_child = left
            if self._has_right(j):
                right = self._right(j)
                if (minheap and self._data[right] < self._data[left]) or (not minheap and self._data[right] > self._data[left]):
                    small_child = right
            if minheap:
                if self._data[small_child] < self._data[j]:
                    self._swap(j, small_child)
                    self._downheap(small_child)
            else:
                if self._data[small_child] > self._data[j]:
                    self._swap(j, small_child)
                    self._downheap(small_child, minheap=False)

    def __len__(self):
        return len(self._data)
    
    def add(self, key, value):
        self._data.append(self._Item(key, value))
        self._upheap(len(self._data) - 1)

    def min(self):
        if self.is_empty():
            raise ValueError('Priority queue is empty')
        item = self._data[0]
        return (item._key, item._value)
    
    def remove_min(self):
        if self.is_empty():
            raise ValueError('Priority queue is empty')
        self._swap(0, len(self._data) - 1)
        item = self._data.pop()
        self._downheap(0)
        return (item._key, item._value)
    
    def remove_max(self):
        if self.is_empty():
            raise ValueError('Priority queue is empty')
        self._swap(0, len(self._data) - 1)
        item = self._data.pop()
        self._downheap(0, minheap=False)
        return (item._key, item._value)
    
balls = [10, 1, 2, 3, 4, 5, 6, 7, 8, 9]
heap = HeapBuilder()
maxsack = heap.create_max_heap(balls)
print(maxsack)
minsack = heap.create_min_heap(balls)
print(minsack)
    
class BSTToHeapTransformer(HeapBuilder):
    def __init__(self, tree):
        self.tree = tree
        self._data = []
        self._create_min_heap()

    def _collect_elements(self, node):
        if node is not None:
            self._collect_elements(self.tree.left(node))
            self._data.append(self._Item(node._element['ID'], node._element))
            self._collect_elements(self.tree.right(node))  

    def _create_min_heap(self):
        self._collect_elements(self.tree.root())
        return self.create_min_heap(self._data)

    def get_heap(self):
        return [item._key for item in self._data]
    
BSTToHeapTransformer(LinkedBinaryTree())

tree = LinkedBinaryTree()
root = tree._add_root({'ID': 10, 'Name': 'Root'})
left = tree._add_left(root, {'ID': 5, 'Name': 'Left'})
right = tree._add_right(root, {'ID': 15, 'Name': 'Right'})
leftleft = tree._add_left(left, {'ID': 2, 'Name': 'LeftLeft'})
leftright = tree._add_right(left, {'ID': 7, 'Name': 'LeftRight'})
rightright = tree._add_right(right, {'ID': 20, 'Name': 'RightRight'})

# Transform the BST to a heap
transformer = BSTToHeapTransformer(tree)
heap = transformer.create_min_heap(transformer._data)

print("Heap:", heap)