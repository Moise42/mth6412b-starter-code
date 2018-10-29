include("./node.jl")
include("./edge.jl")

"""Type abstrait"""
abstract type AbstractPrim{T} end

"""Type prim contenant les noeuds et aretes d un graphe, plus son arbre de recouvrement minimal"""
mutable struct Prim{T} <: AbstractPrim{T}
    nodes::Vector{Node{T}}
    edges::Vector{Edge{T}}
    mst::Vector{Edge{T}}
    mst_weight::Integer
end

"""Constructeur initialisant l arbre de recouvrement a un tableau d aretes vide, et triant les aretes par poids"""
function Prim(nodes::Vector{Node{T}}, edges::Vector{Edge{T}}) where T
    Prim(nodes,edges,Vector{Edge{T}}(),0)
end


"""Construit l arbre de recouvrement minimal a partir de nodes et edges, et le store dans mst"""
function buildMST!(prim::Prim{T},node::Node{T}=prim.nodes[1]) where T
    prim.mst = Vector{Edge{T}}()
    prim.mst_weight = 0
    node.visited = true
    # algorithme de prim, la liste de priorite contient les aretes sortante du noeud de depart
    priorityQueue = inEdges(node, prim.edges)
    while !isempty(priorityQueue)
        # l arete de poid le plus faible dans la file de priorite est selectionnee
        sort!(priorityQueue)
        edge = popfirst!(priorityQueue)

        # on verifie que l on ne forme pas de cycles
        edge.node1.visited ? node = edge.node2 : node = edge.node1
        if node.visited == false
            node.visited = true

            # on ajoute l arete a l arbre de recouvrement minimal en mettant a jour son poids
            push!(prim.mst, edge)
            prim.mst_weight = prim.mst_weight + edge.weight
            for edge in inEdges(node, prim.edges)
                # on ajoute a la file de priorite toutes les aretes sortantes du nouveau noeud visite 
                push!(priorityQueue,edge)
            end
        end
    end
    prim.mst
end
