
include("./node.jl")

"""Type abstrait dont d'autres types de edge dériveront."""
abstract type AbstractEdge{T} end

mutable struct Edge{T} <: AbstractEdge{T}
    node1::AbstractNode{T}
    node2::AbstractNode{T}
    poid::Integer

#On represente une arrete avec deux noeuds et un poid.
end

"""Renvoie le nom du noeud de depart."""
getNode1(edge::AbstractEdge) = edge.node1

"""Renvoie le nom du noeud d arrive."""
getNode2(edge::AbstractEdge) = edge.node2

"""Renvoie le poid de l arrete."""
getPoid(edge::AbstractEdge) = edge.poid

"""Affiche un edge"""
function show(edge::AbstractEdge)
    s = string("Edge entre ", getName(getNode1(edge)), " et ", getName(getNode2(edge)), " de poid ", getPoid(edge));
    s
end
