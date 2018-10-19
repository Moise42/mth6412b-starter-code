include("./node.jl")
include("./edge.jl")

"""Type abstrait"""
abstract type AbstractPrim{T} end

"""Type prim contenant les noeuds et aretes d un graphe, plus son arbre de recouvrement minimal"""
mutable struct Prim{T} <: AbstractPrim{T}
    nodes::Vector{Node{T}}
    edges::Vector{Edge{T}}
    mst::Vector{Edge{T}}
end

"""Constructeur initialisant l arbre de recouvrement a un tableau d aretes vide, et triant les aretes par poids"""
function Prim(nodes::Vector{Node{T}}, edges::Vector{Edge{T}}) where T
    Prim(nodes,edges,Vector{Edge{T}}())
end


"""Construit l arbre de recouvrement minimal a partir de nodes et edges, et le store dans mst"""
function buildMST!(prim::Prim{T}) where T
    prim.mst = Vector{Edge{T}}()
    node = prim.nodes[1]
    node.visited = true
    priorList = inEdges(node, prim.edges)
    while !isempty(priorList)
        sort!(priorList)
        edge = popfirst!(priorList)
        edge.node1.visited ? node = edge.node2 : node = edge.node1
        if node.visited == false
            node.visited = true
            push!(prim.mst, edge)
            for edge in inEdges(node, prim.edges)
                push!(priorList,edge)
            end
        end
    end
    prim.mst
end
