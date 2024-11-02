for i in range(1,8):
    print(i)
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

class Vertex:
    __slots__ = '_element', '_value'

    def __init__(self, x):
        self._element = x
        self._value = None
    
    def element(self):
        return self._element

    def set_element(self, x):
        self._element = x

    def get_value(self):
        return self._value

    def set_value(self, value):
        self._value = value
    
class Edge:
    __slots__ = '_origin', '_destination', '_element'

    def __init__(self, u, v, x):
        self._origin = u
        self._destination = v
        self._element = x
    
    def endpoints(self):
        return (self._origin, self._destination)
    
    def opposite(self, v):
        return self._destination if v is self._origin else self._origin
    
    def element(self):
        return self._element
    
    def __hash__(self):
        return hash((self._origin, self._destination))
    
class Graph:
    def __init__(self, directed=False):
        self._outgoing = {}
        self._incoming = {} if directed else self._outgoing

    def is_directed(self):
        return self._incoming is not self._outgoing

    def vertex_count(self):
        return len(self._outgoing)
    
    def vertices(self):
        return self._outgoing.keys()

    def edge_count(self):
        total = sum(len(self._outgoing[v]) for v in self._outgoing)
        return total if self.is_directed() else total // 2
    
    def edges(self):
        result = set()
        for secondary_map in self._outgoing.values():
            result.update(secondary_map.values())
        return result
    
    def get_edge(self, u, v):
        return self._outgoing[u].get(v)
    
    def degree(self, v, outgoing=True):
        adj = self._outgoing if outgoing else self._incoming
        return len(adj[v])
    
    def incident_edges(self, v, outgoing=True):
        adj = self._outgoing if outgoing else self._incoming
        for edge in adj[v].values():
            yield edge

    def insert_vertex(self, x=None):
        v = Vertex(x)
        self._outgoing[v] = {}
        if self.is_directed():
            self._incoming[v] = {}
        return v
    
    def insert_edge(self, u, v, x=None):
        e = Edge(u, v, x)
        if u not in self._outgoing:
            self._outgoing[u] = {}
        self._outgoing[u][v] = e
        if v not in self._outgoing:
            self._outgoing[v] = {}
        self._incoming[v][u] = e

city_graph = Graph()

with open('.\\data_structures_and_algorithms\\city_population.txt', 'r') as f:
    city_pop = f.readlines()
    for line in city_pop:
        line = line.strip()
        line = line.split(':')
        v = city_graph.insert_vertex(line[0])
        v.set_value(line[1])

with open('.\\data_structures_and_algorithms\\road_network.txt', 'r') as f:
    road_network = f.readlines()
    for line in road_network:
        line = line.strip()
        line = line.split(':')
        city_graph.insert_edge(line[0], line[1])

print(city_graph.vertex_count())

start_vertex = next(iter(city_graph.vertices()))
discovered = {start_vertex: None}

def DFS(graph, u, discovered):
    for e in graph.incident_edges(u):
        v = e.opposite(u)
        if v not in discovered:
            discovered[v] = e
            DFS(graph, v, discovered)
    return discovered

archipalegos = DFS(city_graph, start_vertex, discovered)

print("Archipalegos:", len(archipalegos))
for vertex in archipalegos:
    print(f"{vertex.element()}: population {vertex.get_value()}")

# discovered = {start_vertex: None}
# def BFS(graph, start, discovered):
#     level = [start]
#     while len(level) > 0:
#         next_level = []
#         for u in level:
#             for e in graph.incident_edges(u):
#                 v = e.opposite(u)
#                 if v not in discovered:
#                     discovered[v] = e
#                     next_level.append(v)
#         level = next_level
# print(BFS(city_graph, start_vertex, discovered))