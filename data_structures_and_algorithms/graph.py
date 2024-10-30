class Vertex:
    __slots__ = '_element'

    def __init__(self, x):
        self._element = x
    
    def element(self):
        return self._element
    
    def __hash__(self):
        return hash(id(self))
    
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
        self._incoming[v][u] = e

city_graph = Graph()

with open('.\\data_structures_and_algorithms\\city_population.txt', 'r') as f:
    city_pop = f.readlines()
    for line in city_pop:
        line = line.strip()
        line = line.split(':')
        city_graph.insert_vertex(line[0])

with open('.\\data_structures_and_algorithms\\road_network.txt', 'r') as f:
    road_network = f.readlines()
    for line in road_network:
        line = line.strip()
        line = line.split(':')
        city_graph.insert_edge(line[0], line[1])

print(city_graph.vertex_count())
