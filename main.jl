import Base.isless, Base.isequal

include("./projet/phase1/node.jl")
include("./projet/phase1/edge.jl")
include("./projet/phase1/read_stsp.jl")
include("./projet/phase1/graph.jl")
include("./projet/phase1/kruskal.jl")

graph_file = "bayg29"
graph_path = "./instances/stsp/"*graph_file*".tsp"

### pour le fichier test
node1=Node("a", 2)
node2=Node("b", 2)
edge1 = Edge(node1, node2, 54252)
graph1=Graph("g", [node1,node2],[edge1])
show(graph1)
edge2=Edge(node2, node1, 5)
add_edge!(graph1,edge2)
show(graph1)

### Recuperation des aretes et noeuds d un graphe
header = read_header(graph_path)
edges = read_edges(header, graph_path)
nodes = read_nodes(header, graph_path)
data = dataToNodeAndEdge(nodes, edges)
N = data[1]
E = data[2]

### Creation de l objet kruskal, et calcul de l arbre de recouvrement minimal
kruskal = Kruskal(N[:],E[:])
buildMST!(kruskal)

### plot
plot_graph(nodes, kruskal.edges)
savefig("plot/graph_"*graph_file)
plot_graph(nodes, kruskal.mst)
savefig("plot/mst_"*graph_file)
