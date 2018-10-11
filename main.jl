import Base.isless, Base.isequal

include("./projet/phase1/node.jl")
include("./projet/phase1/edge.jl")
include("./projet/phase1/read_stsp.jl")
include("./projet/phase1/graph.jl")
include("./projet/phase1/kruskal.jl")

graph_file = "bayg29"
graph_path = "./instances/stsp/"*graph_file*".tsp"


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
