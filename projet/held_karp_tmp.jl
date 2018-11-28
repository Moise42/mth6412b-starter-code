

############## HK ##############



## Init
n = size(N)[1]
k = 0 # compteur d etape
Π = zeros(n)
W = -Inf
E_1_tree = nothing
N_1_tree = nothing

while (k<1000)
    ## 1-tree
    G_1_tree = deepcopy(G)
    N_1_tree = G_1_tree.nodes
    # on enleve un noeud
    removed_node_idx = rand(1:n)
    source = N_1_tree[removed_node_idx];
    deleteat!(N_1_tree, removed_node_idx);
    # on enleve les aretes de ce noeud
    E_1_tree = G_1_tree.edges
    removed_edges_idx = findall(x -> (x.node1 == N[removed_node_idx] || x.node2 == N[removed_node_idx]), E);
    deleteat!(E_1_tree, removed_edges_idx);
    # on construit le MST de ce nouveau graphe
    prim_1_tree = Prim(N_1_tree, E_1_tree)
    buildMST!(prim_1_tree,prim_1_tree.nodes[1])
    E_1_tree = prim_1_tree.mst[:]
    # on rajoute le noeud et deux aretes partant de ce noeud
    N_1_tree = deepcopy(G.nodes)
    added_edges_idx = removed_edges_idx[randperm(length(removed_edges_idx))[1:2]]
    push!(E_1_tree, E[added_edges_idx[1]])
    push!(E_1_tree, E[added_edges_idx[2]])
    # Longueur du 1-tree
    L = prim_1_tree.mst_weight + E[added_edges_idx[1]].weight + E[added_edges_idx[2]].weight


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
        #println("HK finished")

    else
        #println("HK continues")
    end
    t = 1/(k+1) # step
    Π += t*v
    k += 1

    ## MAJ des poids des aretes
    for edg in G.edges
        node1_idx = findall(x -> isequal(x,edg.node1), N_1_tree)[1]
        node2_idx = findall(x -> isequal(x,edg.node2), N_1_tree)[1]
        edg.weight += floor(Π[node1_idx] + Π[node2_idx])
    end

end

###################################
