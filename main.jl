using Random
import Base.isless, Base.isequal

include("./projet/node.jl")
include("./projet/edge.jl")
include("./projet/read_stsp.jl")
include("./projet/graph.jl")
include("./projet/kruskal.jl")
include("./projet/prim.jl")
include("./projet/MST.jl")
# include("./projet/RSL.jl")

graph_file = "bayg29"
graph_path = "./instances/stsp/"*graph_file*".tsp"


### Recuperation des aretes et noeuds d un graphe
header = read_header(graph_path)
edges = read_edges(header, graph_path)
nodes = read_nodes(header, graph_path)
data = dataToNodeAndEdge(nodes, edges)
N = data[1]
E = data[2]
G = Graph(graph_file,N, E)


## MST
# mst = MST(deepcopy(G))
# buildMST_kruskal!(mst)
# buildMST_prim!(mst)









## plot
# plot_graph(nodes, E)
# savefig("plot/graph_"*graph_file)

#plot_graph(nodes, kruskal.mst)
#savefig("plot/mst_kruskal_"*graph_file)

#plot_graph(nodes, mst.mst_edges)
#savefig("plot/mst_"*graph_file)


# plot_graph(nodes, circuit_edges)
# savefig("plot/circuit_"*graph_file)

plot_graph(nodes, hk(G, true))
 savefig("plot/circuit_"*graph_file)
# nodes_1_tree = copy(nodes);
# delete!(nodes_1_tree, N[removed_node_idx].data)
# plot_graph(nodes, E_1_tree)
# savefig("plot/1-tree_"*graph_file)
