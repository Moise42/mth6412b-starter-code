function hk(G::Graph{T}, use_prim::Bool=false, nb_iterations::Int64=100) where T
    ## Init
    G2 = deepcopy(G)
    E = G.edges
    n = size(G2.nodes)[1]
    k = 0 # compteur d etape
    Π = zeros(n)
    W = -Inf
    mst_1_tree = nothing
    E_1_tree = nothing
    N_1_tree = nothing
    v = ones(n)

    weights = Vector{Integer}()
    for edg in G.edges
        push!(weights, edg.weight)
    end

    while (v!=zeros(n) && k < nb_iterations)

        println("iteration $k / $nb_iterations")

        ## 1-tree
        G_1_tree = deepcopy(G2)
        # G_1_tree = G2
        N_1_tree = G_1_tree.nodes
        E_1_tree = G_1_tree.edges
        # on enleve un noeud
        removed_node_idx = rand(1:n)
        # source = N_1_tree[removed_node_idx];
        deleteat!(N_1_tree, removed_node_idx);
        # on enleve les aretes de ce noeud
        removed_edges_idx = findall(x -> (x.node1 == G2.nodes[removed_node_idx] || x.node2 == G2.nodes[removed_node_idx]), G2.edges);
        deleteat!(E_1_tree, removed_edges_idx);
        # on construit le MST de ce nouveau graphe
        G_1_tree = Graph(getName(G_1_tree),N_1_tree, E_1_tree)
        mst_1_tree = MST(G_1_tree)
        if use_prim
            buildMST_prim!(mst_1_tree)
        else
            buildMST_kruskal!(mst_1_tree)
        end
        E_1_tree = mst_1_tree.mst_edges
        # on rajoute le noeud et deux aretes partant de ce noeud
        N_1_tree = deepcopy(G2.nodes)
        added_edges_idx = removed_edges_idx[randperm(length(removed_edges_idx))[1:2]]
        push!(E_1_tree, deepcopy(G2.edges[added_edges_idx[1]]))
        push!(E_1_tree, deepcopy(G2.edges[added_edges_idx[2]]))
        # Longueur du 1-tree
        L = mst_1_tree.mst_weight + E[added_edges_idx[1]].weight + E[added_edges_idx[2]].weight


        z = L - 2*sum(Π)
        W = max(W, z)
        d = zeros(n)
        edg = nothing
        for edg in E_1_tree
            nodes_idx = findall(x -> (isequal(edg.node1,x) || isequal(edg.node2,x)),N_1_tree)
            d[nodes_idx[1]] += 1
            d[nodes_idx[2]] += 1
        end
        v = d - ones(n)*2
        if v == zeros(n)
            println("HK finished en $k iterations")
        end
        #t = 1/(k+1) # step
        t = 1/sqrt(k+1)
        Π = Π + t*v
        k += 1

        ## MAJ des poids des aretes
        # G2 = deepcopy(G)
        # for edg in G2.edges
        #     node1_idx = findall(x -> isequal(x,edg.node1), N_1_tree)[1]
        #     node2_idx = findall(x -> isequal(x,edg.node2), N_1_tree)[1]
        #     edg.weight += floor(Π[node1_idx] + Π[node2_idx])
        # end

        for edg_idx = 1 : length(G2.edges)
            node1_idx = findall(x -> isequal(x,G2.edges[edg_idx].node1), N_1_tree)[1]
            node2_idx = findall(x -> isequal(x,G2.edges[edg_idx].node2), N_1_tree)[1]
            G2.edges[edg_idx].weight = weights[edg_idx] + floor(Π[node1_idx] + Π[node2_idx])
        end
    end


    order_of_visit_data = Vector{T}()
    order_of_visit = Vector{Node{T}}()
    circuit_edges = nothing
    circuit_weight = nothing

    if v != zeros(n)
        # si pas de tournee trouvee on en creait une a partir de RSL et du graphe avec les poids modifies
        reset_graph!(G2)
        circuit_edges, circuit_weight, order_of_visit_data = rsl(G2, use_prim)
    else
        # sinon la tournee est le 1_tree
        circuit_edges = deepcopy(E_1_tree)
        push!(order_of_visit, N[1])
        push!(order_of_visit_data, N[1].data)
        for j = 1 : n-1

            node = order_of_visit[end]
            edge_idx = findall(x -> isequal(x.node1,node) || isequal(x.node2,node), E_1_tree)[1]
            if isequal(E_1_tree[edge_idx].node1, node)
                push!(order_of_visit, E_1_tree[edge_idx].node2)
                push!(order_of_visit_data, E_1_tree[edge_idx].node2.data)
            else
                push!(order_of_visit, E_1_tree[edge_idx].node1)
                push!(order_of_visit_data, E_1_tree[edge_idx].node1.data)
            end
            deleteat!(E_1_tree, edge_idx)
        end

    end

    ## calcul du vrai poids la tournee trouvee
    circuit_weight = 0
    for edg in circuit_edges
        edg_idx = findall(x -> (isequal(x.node1,edg.node1) && isequal(x.node2,edg.node2) ||
        isequal(x.node1,edg.node2) && isequal(x.node2,edg.node1)), G.edges)[1]
        circuit_weight += G.edges[edg_idx].weight
    end


    return circuit_edges, circuit_weight, order_of_visit_data
end

###################################



#
# function hk(G::Graph{T}, use_prim::Bool=false, nb_iterations::Integer=100) where T
#     ## Init
#     G2 = deppcopy(G)
#     n = size(G2.nodes)[1]
#     k = 0 # compteur d etape
#     Π = zeros(n)
#     W = -Inf
#     E_1_tree = nothing
#     N_1_tree = nothing
#     v = ones(n)
#
#
#     while (v!=zeros(n) && k < nb_iterations)
#
#         ## 1-tree
#         G_1_tree = deepcopy(G)
#         N_1_tree = G_1_tree.nodes
#         # on enleve un noeud
#         removed_node_idx = rand(1:n)
#         source = N_1_tree[removed_node_idx];
#         deleteat!(N_1_tree, removed_node_idx);
#         # on enleve les aretes de ce noeud
#         E_1_tree = G_1_tree.edges
#         removed_edges_idx = findall(x -> (x.node1 == N[removed_node_idx] || x.node2 == N[removed_node_idx]), E);
#         deleteat!(E_1_tree, removed_edges_idx);
#         # on construit le MST de ce nouveau graphe
#         graphe = Graph(getName(G_1_tree),N_1_tree, E_1_tree)
#         mst_1_tree = MST(graphe)
#         if use_prim
#             buildMST_prim!(mst_1_tree)
#         else
#             buildMST_kruskal!(mst_1_tree)
#         end
#         E_1_tree = mst_1_tree.mst_edges
#         # on rajoute le noeud et deux aretes partant de ce noeud
#         N_1_tree = deepcopy(G.nodes)
#         added_edges_idx = removed_edges_idx[randperm(length(removed_edges_idx))[1:2]]
#         push!(E_1_tree, E[added_edges_idx[1]])
#         push!(E_1_tree, E[added_edges_idx[2]])
#         # Longueur du 1-tree
#         L = mst_1_tree.mst_weight + E[added_edges_idx[1]].weight + E[added_edges_idx[2]].weight
#
#
#         z = L - 2*sum(Π)
#         W = max(W, z)
#         d = zeros(n)
#         edg = nothing
#         for edg in E_1_tree
#             nodes_idx = findall(x -> (isequal(edg.node1,x) || isequal(edg.node2,x)),N_1_tree)
#             d[nodes_idx[1]] += 1
#             d[nodes_idx[2]] += 1
#         end
#         v = d - ones(n)*2
#         if v == zeros(n)
#             println("HK finished")
#         end
#         t = 1/(k+1) # step
#         Π += t*v
#         k += 1
#
#         ## MAJ des poids des aretes
#         for edg in G.edges
#             node1_idx = findall(x -> isequal(x,edg.node1), N_1_tree)[1]
#             node2_idx = findall(x -> isequal(x,edg.node2), N_1_tree)[1]
#             edg.weight += floor(Π[node1_idx] + Π[node2_idx])
#         end
#
#     end
#     return E_1_tree
# end
# ###################################
