import Base.isless
include("./node.jl")

"""Type abstrait dont d'autres types de edge dériveront."""
abstract type AbstractEdge{T} end

mutable struct Edge{T} <: AbstractEdge{T}
    node1::AbstractNode{T}
    node2::AbstractNode{T}
    weight::Integer

#On represente une arrete avec deux noeuds et un poid.
end

"""Renvoie le nom du noeud de depart."""
getNode1(edge::AbstractEdge) = edge.node1

"""Renvoie le nom du noeud d arrive."""
getNode2(edge::AbstractEdge) = edge.node2

"""Renvoie le poid de l arrete."""
getWeight(edge::AbstractEdge) = edge.weight

"""Affiche un edge"""
function show(edge::AbstractEdge)
    s = string("Edge entre ", getName(getNode1(edge)), " et ", getName(getNode2(edge)), " de poid ", getWeight(edge));
    s
end

"""Surchage de l operateur inferieur qui permettra de trier un tableau d aretes par ordre de poids avec sort"""
isless(e1::Edge, e2::Edge) = getWeight(e1) < getWeight(e2)
