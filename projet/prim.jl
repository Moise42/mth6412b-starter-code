include("./node.jl")
include("./edge.jl")

"""Type abstrait"""
abstract type AbstractPrim end

"""Type prim contenant les noeuds et aretes d un graphe, plus son arbre de recouvrement minimal"""
mutable struct Prim<: AbstractPrim
    nodes::Vector{Node}
    edges::Vector{Edge}
    mst::Vector{Edge}
end

"""Constructeur initialisant l arbre de recouvrement a un tableau d aretes vide, et triant les aretes par poids"""
function Prim(nodes::Vector{Node}, edges::Vector{Edge})
    Prim(nodes,edges,Vector{Edge}())
end

function buildMST!(prim::Prim)
    root = pop!(prim.nodes)
    listePrio = inEdges(root,prim.edges)
    while !isempty(listePrio)
        
end
