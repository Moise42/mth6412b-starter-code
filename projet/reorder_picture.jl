function reorder_picture(picture_name::String, picture_path::String, use_HK::Bool, use_prim::Bool, nb_iteration_HK::Int64=100)

    picture = load(picture_path)
    nb_row, nb_col = size(picture)

    N = Vector{Node{Int64}}()
    # creation des noeuds sans oublier le noeud 0
    for k = 0 : nb_col
        nd = Node(picture_name,k)
        nd.parent = nd;
        push!(N, nd)
    end

    # creation des aretes
    E = Vector{Edge{Int64}}()
    w = zeros(nb_col, nb_col)
    for j1 = 1 : nb_col
        for j2 = j1 + 1 : nb_col
            w[j1, j2] = compare_columns(picture[:, j1], picture[:, j2])
            push!(E, Edge(N[j1+1], N[j2+1], floor(Int, w[j1, j2])))
        end
    end
    # on n oublie pas les aretes de poids nul reliant le noeud 0 au reste du graphe
    for j1 = 1 : nb_col
        push!(E, Edge(N[1], N[j1], 0))
    end

    G = Graph(picture_name,N,E)

    if use_HK
        circuit_edges_HK, circuit_weight_HK, tour = hk(G, use_prim, nb_iteration_HK)
        save_name = "tour_HK_poids-$circuit_weight_HK"*"_it-$nb_iteration_HK"*"_"*picture_name
        write_tour("plot/tour/"*save_name*".tour", tour, float32(circuit_weight_HK))
        reconstruct_picture("plot/tour/"*save_name*".tour", picture_path, "plot/image/"*save_name*".png", view = false)

    else
        circuit_edges_RSL, circuit_weight_RSL, tour = rsl(G, use_prim)
        save_name = "tour_RSL_poids-$circuit_weight_RSL"*"_"*picture_name
        write_tour("plot/tour/"*save_name*".tour", tour, float32(circuit_weight_RSL))
        reconstruct_picture("plot/tour/"*save_name*".tour", picture_path, "plot/image/"*save_name*".png", view = false)
    end

    #reconstruct_picture("shredder-julia/tsp/tours/alaska-railroad.tour", picture_path, picture_name*".png", view = false)

end
