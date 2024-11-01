from heap import HeapBuilder

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
        
    def __hash__(self):
        return hash(self._element)

    def __eq__(self, other):
        return isinstance(other, Vertex) and self._element == other._element
    
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
        if v not in self._outgoing:
            self._outgoing[v] = {}
        self._outgoing[u][v] = e
        self._outgoing[v][u] = e 
        if self.is_directed():
            self._incoming[v][u] = e

city_graph = Graph()

with open('.\\data_structures_and_algorithms\\city_population.txt', 'r') as f:
    city_pop = f.readlines()
    for line in city_pop:
        line = line.strip()
        line = line.split(':')
        v = city_graph.insert_vertex(line[0].strip())
        v.set_value(line[1].strip())

with open('.\\data_structures_and_algorithms\\road_network.txt', 'r') as f:
    road_network = f.readlines()
    for line in road_network:
        line = line.strip()
        line = line.split(':')
        u = next(v for v in city_graph.vertices() if v.element() == line[0].strip())
        v = next(v for v in city_graph.vertices() if v.element() == line[1].strip())
        city_graph.insert_edge(u, v)

print(city_graph.vertex_count())

start_vertex = next(iter(city_graph.vertices()))
discovered = {start_vertex: None}

def DFS(graph, u, discovered):
    for e in graph.incident_edges(u):
        v = e.opposite(u)
        if v not in discovered:
            discovered[v] = e
            DFS(graph, v, discovered)

def find_archipelagos(graph):
    visited = set()
    archipelagos = 0
    for v in graph.vertices():
        if v not in visited:
            discovered = {v: None}
            DFS(graph, v, discovered)
            visited.update(discovered)
            archipelagos += 1
    return archipelagos

archipelagos = find_archipelagos(city_graph)
print("Archipelagos:", archipelagos)

# for vertex in archipalegos:
#     print(f"{vertex.element()}: population {vertex.get_value()}")

discovered = {start_vertex: None}
def BFS(graph, start_vertex):
    level = [start_vertex]
    while len(level) > 0:
        next_level = []
        for u in level:
            for e in graph.incident_edges(u):
                v = e.opposite(u)
                if v not in discovered:
                    discovered[v] = e
                    next_level.append(v)
        level = next_level
    return discovered

def shortest_path(graph, start, goal):
    discovered = {start: None}
    level = [start]
    while len(level) > 0:
        next_level = []
        for u in level:
            for e in graph.incident_edges(u):
                v = e.opposite(u)
                if v not in discovered:
                    discovered[v] = e
                    next_level.append(v)
                    if v == goal:
                        path = []
                        while v is not None:
                            path.append(v)
                            e = discovered[v]
                            v = e.opposite(v) if e else None
                        return path[::-1]
        level = next_level
    return None

# Example usage:
start_vertex = next(v for v in city_graph.vertices() if v.element() == "Aliso Viejo")
goal_vertex = next(v for v in city_graph.vertices() if v.element() == "Chicago")
path = shortest_path(city_graph, start_vertex, goal_vertex)
if path:
    print("Shortest path:")
    for vertex in path:
        print(vertex.element())
else:
    print("No path found")