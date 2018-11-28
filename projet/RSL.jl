include("./prim.jl")

"""Type abstrait"""
abstract type AbstractRSL{T} end

"""Type RSL contenant un objet prim, les aretes du tour, et les poids du tour"""
mutable struct RSL{T} <: AbstractRSL{T}
    graph::Graph{T}
    circuit_edges::Vector{Edge{T}}
    circuit_weight::Integer
end

"""Constructeur prenant le graphe en parametre"""
function RSL(graph::Graph{T}) where T
    RSL(graph, Vector{Edge{T}}(), 0)
end


function rsl!(rsl::RSL{T}) where T

    ## avec Prim
    # prim = Prim(rsl.nodes, rsl.edges)
    # buildMST!(prim)
    # circuit_nodes = prim.order_of_visit

    println(length(rsl.edges))

    ## avec Kruskal

    kruskal = Kruskal(rsl.nodes, rsl.edges)
    buildMST!(kruskal)
    println(length(kruskal.mst))


    reset_nodes(kruskal.nodes)
    circuit_nodes = tree_preodre(kruskal.nodes, kruskal.mst)



    n = length(circuit_nodes)

    #T = typeof(circuit_nodes[1].data)
    rsl.circuit_edges = Vector{Edge{T}}()
    rsl.circuit_weight = 0;
    for k = 1:n-1
        e_idx = findall(x-> ( isequal(x.node1,circuit_nodes[k]) && isequal(x.node2,circuit_nodes[k+1])
        || isequal(x.node1,circuit_nodes[k+1]) && isequal(x.node2,circuit_nodes[k])  ), rsl.edges)[1]
        push!(rsl.circuit_edges, rsl.edges[e_idx]);
        rsl.circuit_weight += rsl.edges[e_idx].weight;
    end
    e_idx = findall(x-> ( isequal(x.node1,circuit_nodes[1]) && isequal(x.node2,circuit_nodes[n])
    || isequal(x.node1,circuit_nodes[n]) && isequal(x.node2,circuit_nodes[1])  ), rsl.edges)[1]
    push!(rsl.circuit_edges, rsl.edges[e_idx]);
    rsl.circuit_weight += rsl.edges[e_idx].weight;
    return rsl


end
