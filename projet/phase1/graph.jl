import Base.show

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T} end

"""Type representant un graphe comme un ensemble de noeuds.

Exemple :

		node1 = Node("Joe", 3.14)
		node2 = Node("Steve", exp(1))
		node3 = Node("Jill", 4.12)
		G = Graph("Ick", [node1, node2, node3])

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T} <: AbstractGraph{T}
	name::String
	nodes::Vector{Node{T}}
	edges::Vector{Edge{T}}
end

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T}, node::Node{T}) where T
	push!(graph.nodes, node)
	graph
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name` et `nodes`.

"""Ajoute une arrete au graphe"""
function add_edge!(graph::Graph{T}, edge::Edge{T}) where T
	push!(graph.edges, edge)
	graph
end

"""Renvoie le nom du graphe."""
get_name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
getNodes(graph::AbstractGraph) = graph.nodes

"""Renvoie la liste des arretes du graphe."""
getEdges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre de noeuds du graphe."""
get_nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Renvoie le nombre d arretes du graphe."""
get_nb_edges(graph::AbstractGraph) = length(graph.edges)

"""Affiche un graphe"""
function show(graph::Graph)
	name = get_name(graph)
	nb_nodes = get_nb_nodes(graph)
	nb_edges = get_nb_edges(graph)
	s = string("Graph ", name, " has ", nb_nodes, " nodes and ", nb_edges, " edge")
	for node in getNodes(graph)
		s = string(s, "\n", show(node))
	end
	for edge in getEdges(graph)
		s = string(s, "\n", show(edge))
	end
	println(s)
end
