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



## Choisir le graphe et graph path

# graph_file = "bays29"
# graph_file = "bayg29"
# graph_file = "dantzig42"
# graph_file = "gr120"
# graph_file = "pa561"
# graph_path = "./instances/stsp/"*graph_file*".tsp"

graph_file = "pizza-food-wallpaper"
# graph_file = "alaska-railroad"
# graph_file = "abstract-light-painting"
# graph_file = "blue-hour-paris"
# graph_file = "lower-kananaskis-lake"
# graph_file = "marlet2-radio-board"
# graph_file = "nikos-cat"
# graph_file = "the-enchanted-garden"
# graph_file = "tokyo-skytree-aerial"
graph_path = "./shredder-julia/tsp/instances/"*graph_file*".tsp"

## Recuperation des aretes et noeuds d un graphe
println("chargement du graphe $graph_file ..")
header = read_header(graph_path)
edges = read_edges(header, graph_path)
nodes = read_nodes(header, graph_path)
if isempty(nodes)
    for k = 1:size(edges[1])[1]
        edges[1][k] = edges[1][k] .-1
    end
    nodes_nb = edges[1][end][1]
    for k = 0:nodes_nb+1
        nodes[k] = [0.0, 0.0]
    end
end
data = dataToNodeAndEdge(nodes, edges)
N = sort!(data[1])
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
# println("calcul du MST")
# mst = MST(deepcopy(G))
# buildMST_kruskal!(mst)
# buildMST_prim!(mst)



## Circuits
# use_prim = false
# nb_iter = 100000
# RSL
# circuit_edges_RSL, circuit_weight_RSL, order_of_visit_data = rsl(G, use_prim)
# HK
# circuit_edges_HK, circuit_weight_HK, order_of_visit_data = hk(G, use_prim, nb_iter)


## Images
println("calcul d un circuit")
picture_path = "./shredder-julia/images/shuffled/"*graph_file*".png"
use_HK = true # HK ou RSL
use_prim = true
nb_iteration_HK = 100
# reorder_picture(graph_file, picture_path, use_HK, use_prim, nb_iteration_HK)

circuit_edges_HK, circuit_weight_HK, order_of_visit_data = hk(G, use_prim, nb_iteration_HK)

save_name = "tour_HK_poids-$circuit_weight_HK"*"_it-$nb_iteration_HK"*"_useprim-$use_prim"*"_"*graph_file
write_tour("plot/tour/"*save_name*".tour", order_of_visit_data, float32(circuit_weight_HK))
reconstruct_picture("plot/tour/"*save_name*".tour", picture_path, "plot/image/"*save_name*".png", view = false)


## Recuperation des aretes et noeuds d un graphe




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
# savefig("plot/circuit/circuit_HK_"*"$circuit_weight_HK"*"_"*graph_file)
