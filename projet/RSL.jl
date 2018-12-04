
function rsl(G::Graph{T}, use_prim::Bool=false) where T

    size_nodes = length(G.nodes)
    mst = nothing;
    circuit_edges = nothing;


    ## avec Kruskal ou Prim
    mst = MST(deepcopy(G))
    if use_prim
        buildMST_prim!(mst, mst.graph.nodes[1])
    else
        buildMST_kruskal!(mst)
    end

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

    return circuit_edges, circuit_weight
end






# function rsl!(G::Graph{T}) where T
#
#     size_nodes = length(G.nodes)
#     circ_weights = Vector{Integer}()
#     mst = nothing;
#     circuit_edges = nothing;
#
#     for j = 1:size_nodes
#
#         ## avec Kruskal
#         mst = MST(deepcopy(G))
#         buildMST_prim!(mst, mst.graph.nodes[j])
#         #buildMST_kruskal!(mst)
#
#
#         n = length(mst.order_of_visit)
#         T = typeof(mst.order_of_visit[1].data)
#         circuit_edges = Vector{Edge{T}}()
#         circuit_weight = 0;
#         for k = 1:n-1
#             e_idx = findall(x-> ( isequal(x.node1,mst.order_of_visit[k]) && isequal(x.node2,mst.order_of_visit[k+1])
#             || isequal(x.node1,mst.order_of_visit[k+1]) && isequal(x.node2,mst.order_of_visit[k])  ), mst.graph.edges)[1]
#             push!(circuit_edges, mst.graph.edges[e_idx]);
#             circuit_weight += mst.graph.edges[e_idx].weight;
#         end
#         e_idx = findall(x-> ( isequal(x.node1,mst.order_of_visit[1]) && isequal(x.node2,mst.order_of_visit[n])
#         || isequal(x.node1,mst.order_of_visit[n]) && isequal(x.node2,mst.order_of_visit[1])  ), mst.graph.edges)[1]
#         push!(circuit_edges, mst.graph.edges[e_idx]);
#         circuit_weight += mst.graph.edges[e_idx].weight;
#
#         push!(circ_weights,circuit_weight)
#         println(j)
#     end
# end
