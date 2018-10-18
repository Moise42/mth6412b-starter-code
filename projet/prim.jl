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
    prim.mst = Vector{Edge}()
    node = prim.nodes[1]
    node.visited = true
    priorList = inEdges(node, prim.edges)
    while !isempty(priorList)
        sort!(priorList)
        edge = popfirst!(priorList)
        idx = findall(x->isequal(x,edge.node1), prim.nodes)[1]
        prim.nodes[idx].visited ? node = edge.node2 : node = edge.node1
        idx = findall(x->isequal(x,node), prim.nodes)[1]
        if prim.nodes[idx].visited == false
            prim.nodes[idx].visited = true
            push!(prim.mst, edge)
            for edge in inEdges(node, prim.edges)
                push!(priorList,edge)
            end
        end
    end
    prim.mst
end
