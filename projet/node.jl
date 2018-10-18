import Base.show
import Base.isequal

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

mutable struct EmptyNodeType{T} <: AbstractNode{T}
    data::Int64
end

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud = Node("James", [π, exp(1)])
        noeud = Node("Kirk", "guitar")
        noeud = Node("Lars", 2)

"""
mutable struct Node{T} <: AbstractNode{T}
    name::String
    data::T
    parent::AbstractNode{T}
    visited::Bool
end

function Node(name::String, data::T) where T
    Node{T}(name,data,EmptyNodeType{T}(data),false)
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Renvoie le nom du noeud."""
getName(node::AbstractNode) = node.name

"""Renvoie les donnees contenues dans le noeud."""
getData(node::AbstractNode) = node.data


"""Affiche un noeud"""
function show(node::AbstractNode)

    s = string("Node ", getName(node), ", data: ", getData(node))
    #println(s)
    s
end

"""Methode egale"""
isequal(n1::Node, n2::Node) = getData(n1) == getData(n2)
