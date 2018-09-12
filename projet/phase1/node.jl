import Base.show

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud = Node("James", [π, exp(1)])
        noeud = Node("Kirk", "guitar")
        noeud = Node("Lars", 2)

"""
mutable struct Node{T} <: AbstractNode{T}
    name::String
    data::T
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
    println(s)
end
