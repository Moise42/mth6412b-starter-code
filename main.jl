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

graph_file = "pa561"
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


## RSL algorithm


size_nodes = length(G.nodes)
circ_weights = Vector{Integer}()
mst = nothing;
circuit_edges = nothing;

for j = 1:10

    ## avec Kruskal
    mst = MST(deepcopy(G))
    buildMST_prim!(mst, mst.graph.nodes[j])
    #buildMST_kruskal!(mst)


    n = length(mst.order_of_visit)
    T = typeof(mst.order_of_visit[1].data)
    circuit_edges = Vector{Edge{T}}()
    circuit_weight = 0;
    for k = 1:n-1
        e_idx = findall(x-> ( isequal(x.node1,mst.order_of_visit[k]) && isequal(x.node2,mst.order_of_visit[k+1])
        || isequal(x.node1,mst.order_of_visit[k+1]) && isequal(x.node2,mst.order_of_visit[k])  ), mst.graph.edges)[1]
        push!(circuit_edges, mst.graph.edges[e_idx]);
        circuit_weight += mst.graph.edges[e_idx].weight;
    end
    e_idx = findall(x-> ( isequal(x.node1,mst.order_of_visit[1]) && isequal(x.node2,mst.order_of_visit[n])
    || isequal(x.node1,mst.order_of_visit[n]) && isequal(x.node2,mst.order_of_visit[1])  ), mst.graph.edges)[1]
    push!(circuit_edges, mst.graph.edges[e_idx]);
    circuit_weight += mst.graph.edges[e_idx].weight;

    push!(circ_weights,circuit_weight)
    println(j)
end



## plot
# plot_graph(nodes, E)
# savefig("plot/graph_"*graph_file)

#plot_graph(nodes, kruskal.mst)
#savefig("plot/mst_kruskal_"*graph_file)

#plot_graph(nodes, mst.mst_edges)
#savefig("plot/mst_"*graph_file)


# plot_graph(nodes, circuit_edges)
# savefig("plot/circuit_"*graph_file)

# nodes_1_tree = copy(nodes);
# delete!(nodes_1_tree, N[removed_node_idx].data)
# plot_graph(nodes, E_1_tree)
# savefig("plot/1-tree_"*graph_file)
