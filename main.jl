using Random
# using ImageView, Images
import Base.isless, Base.isequal, Base.popfirst!, Base.push!

include("./projet/node.jl")
include("./projet/edge.jl")
include("./projet/read_stsp.jl")
include("./projet/graph.jl")
include("./projet/priorityQueue.jl")
include("./projet/MST.jl")
include("./projet/RSL.jl")
include("./projet/HK.jl")
include("./projet/reorder_picture.jl")

include("./shredder-julia/bin/tools.jl")

graph_file = "gr120"
graph_path = "./instances/stsp/"*graph_file*".tsp"


## Recuperation des aretes et noeuds d un graphe
println("chargement du graphe ..")
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

## priority queue
# L = [3,6,1,5,9,4,7]
# sort!(L)
# L = [1,3,4,6,7,9,11]
# p = PriorityQueue(L)
# push!(p,0)
# println(p.queue)
# popfirst!(p)
# println(p.queue)

## MST
println("calcul du MST")
mst = MST(deepcopy(G))
# buildMST_kruskal!(mst)
buildMST_prim!(mst)



## Circuits
# use_prim = false
# nb_iter = 1000
# RSL
# circuit_edges_RSL, circuit_weight_RSL, order_of_visit_data = rsl(G, use_prim)
# HK
# circuit_edges_HK, circuit_weight_HK, order_of_visit_data = hk(G, false, nb_iter)


## Images
# picture_name = "pizza-food-wallpaper"
# # picture_name = "nikos-cat"
# picture_path = "./shredder-julia/images/shuffled/"*picture_name*".png"
# use_HK = true # HK ou RSL
# use_prim = false
# nb_iteration_HK = 1000
#
# reorder_picture(picture_name, picture_path, use_HK, use_prim, nb_iteration_HK)




##### PLOT #####

## Graph
# plot_graph(nodes, E)
# savefig("plot/graph/graph_"*graph_file)

## MST
# plot_graph(nodes, mst.mst_edges)
# savefig("plot/mst/mst_kruskal_"*graph_file)
# savefig("plot/mst/mst_prim_"*graph_file)

## Circuits
# RSL
# plot_graph(nodes, circuit_edges_RSL)
# savefig("plot/circuit/circuit_RSL_"*graph_file)
# HK
# plot_graph(nodes, circuit_edges_HK)
# savefig("plot/circuit/circuit_HK_"*graph_file)
