function hk(G::Graph{T}, use_prim::Bool=false, nb_iterations::Integer=100) where T
    ## Init
    G2 = deepcopy(G)
    n = size(G2.nodes)[1]
    k = 0 # compteur d etape
    Π = zeros(n)
    W = -Inf
    mst_1_tree = nothing
    E_1_tree = nothing
    N_1_tree = nothing
    v = ones(n)


    while (v!=zeros(n) && k < nb_iterations)

        ## 1-tree
        G_1_tree = deepcopy(G2)
        N_1_tree = G_1_tree.nodes
        E_1_tree = G_1_tree.edges
        # on enleve un noeud
        removed_node_idx = rand(1:n)
        source = N_1_tree[removed_node_idx];
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
            println("HK finished")
        end
        #t = 1/(k+1) # step
        t = 1
        Π = Π + t*v
        k += 1

        ## MAJ des poids des aretes
        G2 = deepcopy(G)
        for edg in G2.edges
            node1_idx = findall(x -> isequal(x,edg.node1), N_1_tree)[1]
            node2_idx = findall(x -> isequal(x,edg.node2), N_1_tree)[1]
            edg.weight += floor(Π[node1_idx] + Π[node2_idx])
        end
    end



    if v != zeros(n)
        # si pas de tournee trouvee on en creait une a partir de RSL et du graphe avec les poids modifies
        circuit_edges_HK = nothing
        circuit_weight = nothing
        reset_graph!(G2)
        circuit_edges_HK, circuit_weight = rsl(G2, use_prim)
    else
        # sinon la tournee est le 1_tree
        circuit_edges_HK = E_1_tree
    end

    ## calcul du vrai poids la tournee trouvee
    circuit_weight_HK = 0
    for edg in circuit_edges_HK
        edg_idx = findall(x -> (isequal(x.node1,edg.node1) && isequal(x.node2,edg.node2) ||
        isequal(x.node1,edg.node2) && isequal(x.node2,edg.node1)), G.edges)[1]
        circuit_weight_HK += G.edges[edg_idx].weight
    end


    return circuit_edges_HK, circuit_weight_HK
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
