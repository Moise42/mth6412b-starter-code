import Base.isless, Base.isequal
include("./projet/node.jl")
include("./projet/edge.jl")
include("./projet/read_stsp.jl")
include("./projet/graph.jl")
include("./projet/kruskal.jl")
include("./projet/prim.jl")
include("./projet/rsl.jl")

graph_file = "bays29"
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
buildMST!(prim,prim.nodes[1])

## RST algorithm

#circuit_nodes = prim.order_of_visit
#n = length(circuit_nodes)
#T = typeof(circuit_nodes[1].data)
#circuit_edges = Vector{Edge{T}}()
#circuit_weight = 0;
#for k = 1:n-1
#    e_idx = findall(x-> ( isequal(x.node1,circuit_nodes[k]) && isequal(x.node2,circuit_nodes[k+1])
#    || isequal(x.node1,circuit_nodes[k+1]) && isequal(x.node2,circuit_nodes[k])  ), E)[1]
#    push!(circuit_edges, E[e_idx]);
#    circuit_weight += E[e_idx].weight;
#end
#e_idx = findall(x-> ( isequal(x.node1,circuit_nodes[1]) && isequal(x.node2,circuit_nodes[n])
#|| isequal(x.node1,circuit_nodes[n]) && isequal(x.node2,circuit_nodes[1])  ), E)[1]
#push!(circuit_edges, E[e_idx]);
#circuit_weight += E[e_idx].weight;

circuit_edges = rsl!(prim)





## plot
# plot_graph(nodes, E)
# savefig("plot/graph_"*graph_file)

# plot_graph(nodes, kruskal.mst)
# savefig("plot/mst_kruskal_"*graph_file)

# plot_graph(nodes, prim.mst)
# savefig("plot/mst_prim_"*graph_file)

plot_graph(nodes, circuit_edges)
savefig("plot/circuit_"*graph_file)
