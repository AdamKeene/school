from StackQueue import Queue

class Tree:
    class Position:
        def element(self):
            raise NotImplementedError('must be implemented by subclass')
    
        def __eq__(self, other):
            raise NotImplementedError('must be implemented by subclass')
    
        def __ne__(self, other):
            return not (self == other)
    
    def root(self):
        raise NotImplementedError('must be implemented by subclass')
    
    def parent(self, p):
        raise NotImplementedError('must be implemented by subclass')
    
    def num_children(self, p):
        raise NotImplementedError('must be implemented by subclass')
    
    def children(self, p):
        raise NotImplementedError('must be implemented by subclass')
    
    def __len__(self):
        raise NotImplementedError('must be implemented by subclass')
    
    def is_root(self, p):
        return self.root() == p
    
    def is_leaf(self, p):
        return self.num_children(p) == 0
    
    def is_empty(self):
        return len(self) == 0
    
    def depth(self, p):
        if self.is_root(p):
            return 0
        else:
            return 1 + self.depth(self.parent(p))
    
    def _height1(self):
        return max(self.depth(p) for p in self.positions() if self.is_leaf(p))
    
    def _height2(self, p):
        if self.is_leaf(p):
            return 0
        else:
            return 1 + max(self._height2(c) for c in self.children(p))
    
    def height(self, p=None):
        if p is None:
            p = self.root()
        return self._height2(p)

class BinaryTree(Tree):
    def left(self, p):
        raise NotImplementedError('must be implemented by subclass')
    
    def right(self, p):
        raise NotImplementedError('must be implemented by subclass')
    
    def sibling(self, p):
        parent = self.parent(p)
        if parent is None:
            return None
        else:
            if p == self.left(parent):
                return self.right(parent)
            else:
                return self.left(parent)
    
    def children(self, p):
        if self.left(p) is not None:
            yield self.left(p)
        if self.right(p) is not None:
            yield self.right(p)

class LinkedBinaryTree(BinaryTree):
    class _Node:
        __slots__ = '_element', '_parent', '_left', '_right'
        def __init__(self, element, parent=None, left=None, right=None):
            self._element = element
            self._parent = parent
            self._left = left
            self._right = right

    class Position(BinaryTree.Position):
        def __init__(self, container, node):
            self._container = container
            self._node = node
            self._element = node._element

    def element(self):
      return self._node._element

    def __eq__(self, other):
      return type(other) is type(self) and other._node is self._node

    def _validate(self, p):
        if not isinstance(p, self.Position):
            raise TypeError('p must be proper Position type')
        if p._container is not self:
            raise ValueError('p does not belong to this container')
        if p._node._parent is p._node:
            raise ValueError('p is no longer valid')
        return p._node

    def _make_position(self, node):
        return self.Position(self, node) if node is not None else None

    def __init__(self):
        self._root = None
        self._size = 0

    def __len__(self):
        return self._size

    def root(self):
        return self._make_position(self._root)

    def parent(self, p):
        node = self._validate(p)
        return self._make_position(node._parent)

    def left(self, p):
        node = self._validate(p)
        return self._make_position(node._left)

    def right(self, p):
        node = self._validate(p)
        return self._make_position(node._right)

    def num_children(self, p):
        node = self._validate(p)
        count = 0
        if node._left is not None:
            count += 1
        if node._right is not None:
            count += 1
        return count
    
    def _create_dict(self, e):
        return {'ID': e[:6].strip(), 'name': e[7:31].strip(), 'department': e[32:35].strip(), 'program': e[36:39].strip(), 'year': e[40].strip()}

    def _add_root(self, e):
        if self._root is not None: raise ValueError('Root exists')
        self._size = 1
        self._root = self._Node(e)
        return self._make_position(self._root)

    def _add_left(self, p, e):
        node = self._validate(p)
        if node._left is not None:
            raise ValueError('Left child exists')
        self._size += 1
        node._left = self._Node(e, node)
        return self._make_position(node._left)
    def _add_right(self, p, e):
        node = self._validate(p)
        if node._right is not None:
            raise ValueError('Right child exists')
        self._size += 1
        node._right = self._Node(e, node)
        return self._make_position(node._right)
  
    def _insert(self, p, e): #TODO change data format
        if p is None:
            return self._add_root(e)  
        # Compare the last names
        current_name = p._element['name']
        # Go left if name is alphabetically earlier
        if e['name'].lower() < current_name.lower():
            if self.left(p) is None:
                return self._add_left(p, e)
            else:
                return self._insert(self.left(p), e)
        # Go right if name is later
        else:
            if self.right(p) is None:
                return self._add_right(p, e)
            else:
                return self._insert(self.right(p), e)
        
    def _inorder_traversal(self, p, result):
        if self.left(p) is not None:
            self._inorder_traversal(self.left(p), result)
        result.append(p._element)
        if self.right(p) is not None:
            self._inorder_traversal(self.right(p), result)
    
    def _find_node(self, p, e):
        if p is None:
            return None
        if p._element['ID'] == e:
            return p
        left = self._find_node(self.left(p), e)
        right = self._find_node(self.right(p), e)
        if left is not None:
            return left
        if right is not None:
            return right
        return None

    def _delete(self, p):
        node = self._validate(p)
        if self.num_children(p) == 2:
            raise ValueError('p has two children')
        child = node._left if node._left else node._right
        if child is not None:
            child._parent = node._parent
        if node is self._root:
            self._root = child
        else:
            parent = node._parent
            if node is parent._left:
                parent._left = child
            else:
                parent._right = child
        self._size -= 1
        node._parent = node
        return node._element

    def print_inorder(self):
        result = []
        if not self.is_empty():
            self._inorder_traversal(self.root(), result)
        print("\n".join(str(item) for item in result))
    
    def return_inorder(self):
        result = []
        if not self.is_empty():
            self._inorder_traversal(self.root(), result)
        return("\n".join(str(result)))

    def print_breadthfirst(self):
        if not self.is_empty():
            fringe = Queue()
            fringe.enqueue(self.root())
            while not fringe.is_empty():
                p = fringe.dequeue()
                print(p._element)
                for c in self.children(p):
                    fringe.enqueue(c)

    def return_breadthfirst(self):
        if not self.is_empty():
            fringe = Queue()
            fringe.enqueue(self.root())
            result = []
            while not fringe.is_empty():
                p = fringe.dequeue()
                result.append(p._element)
                for c in self.children(p):
                    fringe.enqueue(c)
            return('\n'.join(str(result)))

        
def load_file(file):
    tree = LinkedBinaryTree()
    with open(file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            line = line.strip()
            if line == '' or line[0] not in {'I', 'D'}:
                continue
            record = line[1:].strip()
            if line[0] == 'I':
                record = tree._create_dict(record)
                if tree.is_empty():
                    tree._add_root(record)
                else:
                    tree._insert(tree.root(), record)
            if line[0] == 'D':
                node = tree._find_node(tree.root(), tree._create_dict(record)['ID'])
                if node is not None:
                    deletedElement = node._element
                    tree._delete(node)
                    print('Deleted:', deletedElement['name'])
                else:
                    print("coundn't find it :/")

    tree.print_inorder()
    print('-')
    tree.print_breadthfirst()
    with open('inorder.txt', 'w') as out_file:
        out_file.write(str(tree.return_inorder()))
    with open('breadthfirst.txt', 'w') as out_file:
        out_file.write(str(tree.return_breadthfirst()))
    return tree

balls = load_file('data_structures_and_algorithms\\tree-input.txt')