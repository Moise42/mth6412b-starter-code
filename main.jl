using Random
import Base.isless, Base.isequal

include("./projet/node.jl")
include("./projet/edge.jl")
include("./projet/read_stsp.jl")
include("./projet/graph.jl")
include("./projet/MST.jl")
include("./projet/RSL.jl")
include("./projet/HK.jl")

graph_file = "bayg29"
graph_path = "./instances/stsp/"*graph_file*".tsp"


## Recuperation des aretes et noeuds d un graphe
header = read_header(graph_path)
edges = read_edges(header, graph_path)
nodes = read_nodes(header, graph_path)
data = dataToNodeAndEdge(nodes, edges)
N = data[1]
E = data[2]
# on ne considere pas les aretes ayant le noeud de depart et d arrive identique (de poids nul)
useless_edges_idx = find(x -> isequal(x.node1, x.node2), E)
deleteat!(E, useless_edges_idx)
G = Graph(graph_file,N, E)


## MST
# mst = MST(deepcopy(G))
# buildMST_kruskal!(mst)
# buildMST_prim!(mst)

## Circuits
# RSL
circuit_edges_RSL, circuit_weight_RSL = rsl(G, false)
# HK
# circuit_edges_HK, circuit_weight_HK = hk(G, true, 10)
G2, v, n = hk(G, false, 10000)
########################## IMPOSSIBLE TO BUILD CIRCUIT WITH 1_TREE AS IT IS NOT COMPLETE GRAPH ####################
circuit_edges_HK = nothing
circuit_weight = nothing

if v != zeros(n)
    # graph_final = Graph("final", deepcopy(G.nodes), G2)
    reset_graph!(G2)
    circuit_edges_HK, circuit_weight = rsl(G2, false)
    # mst = MST(G2)
    # buildMST_kruskal!(mst)
    # n = length(mst.order_of_visit)
    # T = typeof(mst.order_of_visit[1].data)
    # circuit_edges_HK = Vector{Edge{T}}()
    # circuit_weight = 0;
    # for k = 1:n-1
    #     # println(k)
    #     e_idx = findall(x-> ( isequal(x.node1,mst.order_of_visit[k]) && isequal(x.node2,mst.order_of_visit[k+1])
    #     || isequal(x.node1,mst.order_of_visit[k+1]) && isequal(x.node2,mst.order_of_visit[k])  ), mst.graph.edges)[1]
    #     push!(circuit_edges_HK, mst.graph.edges[e_idx]);
    #     circuit_weight += mst.graph.edges[e_idx].weight;
    # end
    # e_idx = findall(x-> ( isequal(x.node1,mst.order_of_visit[1]) && isequal(x.node2,mst.order_of_visit[n])
    # || isequal(x.node1,mst.order_of_visit[n]) && isequal(x.node2,mst.order_of_visit[1])  ), mst.graph.edges)[1]
    # push!(circuit_edges_HK, mst.graph.edges[e_idx]);
    # circuit_weight += mst.graph.edges[e_idx].weight;
end

circuit_weight_HK = 0
for edg in circuit_edges_HK
    edg_idx = findall(x -> (isequal(x.node1,edg.node1) && isequal(x.node2,edg.node2) ||
    isequal(x.node1,edg.node2) && isequal(x.node2,edg.node1)), G.edges)[1]
    circuit_weight_HK += G.edges[edg_idx].weight
end


## plot

# Graph
# plot_graph(nodes, E)
# savefig("plot/graph/graph_"*graph_file)

# MST
# plot_graph(nodes, mst.mst_edges)
# savefig("plot/mst/mst_"*graph_file)

# Circuits
# RSL
plot_graph(nodes, circuit_edges_RSL)
savefig("plot/circuit/circuit_RSL_"*graph_file)
# HK
plot_graph(nodes, circuit_edges_HK)
savefig("plot/circuit/circuit_HK_"*graph_file)
