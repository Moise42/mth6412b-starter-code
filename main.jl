using Random
# using ImageView, Images
import Base.isless, Base.isequal

include("./projet/node.jl")
include("./projet/edge.jl")
include("./projet/read_stsp.jl")
include("./projet/graph.jl")
include("./projet/MST.jl")
include("./projet/RSL.jl")
include("./projet/HK.jl")

include("./shredder-julia/bin/tools.jl")

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
# circuit_edges_RSL, circuit_weight_RSL, order_of_visit_data = rsl(G, false)
# HK
circuit_edges_HK, circuit_weight_HK, order_of_visit_data = hk(G, false, 100000)


## Images
# picture_name = "alaska-railroad"
# picture_path = "./shredder-julia/images/shuffled/"*picture_name*".png"
# picture = load(picture_path)
# nb_row, nb_col = size(picture)
#
# N = Vector{Node{Int64}}()
# # creation des noeuds sans oublier le noeud 0
# for k = 0 : nb_col
#     nd = Node(picture_name,k)
#     nd.parent = nd;
#     push!(N, nd)
# end
#
# # creation des aretes
# E = Vector{Edge{Int64}}()
# w = zeros(nb_col, nb_col)
# for j1 = 1 : nb_col
#     for j2 = j1 + 1 : nb_col
#         w[j1, j2] = compare_columns(picture[:, j1], picture[:, j2])
#         push!(E, Edge(N[j1+1], N[j2+1], floor(Int, w[j1, j2])))
#     end
# end
# # on n oublie pas les aretes de poids nul reliant le noeud 0 au reste du graphe
# for j1 = 1 : nb_col
#     push!(E, Edge(N[1], N[j1], 0))
# end
#
# G = Graph(picture_name,N,E)
#
# circuit_edges_RSL, circuit_weight_RSL, tour = rsl(G, false)
# # circuit_edges_RSL, circuit_weight_RSL, tour = hk(G, false, 10)
#
# write_tour(picture_name*".tour", tour, float32(circuit_weight_RSL))
# reconstruct_picture(picture_name*".tour", picture_path, picture_name*".png", view = false)
#
#
# #reconstruct_picture("shredder-julia/tsp/tours/alaska-railroad.tour", picture_path, picture_name*".png", view = false)

##### PLOT #####

## Graph
# plot_graph(nodes, E)
# savefig("plot/graph/graph_"*graph_file)

## MST
# plot_graph(nodes, mst.mst_edges)
# savefig("plot/mst/mst_"*graph_file)

## Circuits
# RSL
# plot_graph(nodes, circuit_edges_RSL)
# savefig("plot/circuit/circuit_RSL_"*graph_file)
# HK
plot_graph(nodes, circuit_edges_HK)
savefig("plot/circuit/circuit_HK_"*graph_file)
