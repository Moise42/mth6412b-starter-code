import Base.isless, Base.isequal
include("./projet/node.jl")
include("./projet/edge.jl")
include("./projet/read_stsp.jl")
include("./projet/graph.jl")
include("./projet/kruskal.jl")
include("./projet/prim.jl")

graph_file = "bayg29"
graph_path = "./instances/stsp/"*graph_file*".tsp"


### Recuperation des aretes et noeuds d un graphe
header = read_header(graph_path)
edges = read_edges(header, graph_path)
nodes = read_nodes(header, graph_path)
data = dataToNodeAndEdge(nodes, edges)
N = data[1]
E = data[2]

#graph = Graph(graph_file,N, E)

## Creation de l objet kruskal, et calcul de l arbre de recouvrement minimal
kruskal = Kruskal(N[:],E[:])
buildMST!(kruskal)

### Creation de l objet prim, et calcul de l arbre de recouvrement minimal
prim = Prim(N[:],E[:])
buildMST!(prim,prim.nodes[20])

## plot
plot_graph(nodes, E)
savefig("plot/graph_"*graph_file)

plot_graph(nodes, kruskal.mst)
savefig("plot/mst_kruskal_"*graph_file)

plot_graph(nodes, prim.mst)
savefig("plot/mst_prim_"*graph_file)
