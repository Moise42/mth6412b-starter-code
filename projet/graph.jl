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

"""Reset"""
function reset_graph!(graph::Graph{T}) where T
	for n in graph.nodes
		n.visited = false
		n.rang = 0
		n.parent = n
	end
	for edg in graph.edges
		n1_idx = findall(x -> isequal(edg.node1,x), graph.nodes)[1]
		n2_idx = findall(x -> isequal(edg.node2,x), graph.nodes)[1]
		edg.node1 = graph.nodes[n1_idx]
		edg.node2 = graph.nodes[n2_idx]
	end
end

"""Renvoie le nom du graphe."""
getName(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
getNodes(graph::AbstractGraph) = graph.nodes

"""Renvoie la liste des arretes du graphe."""
getEdges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre de noeuds du graphe."""
getNbNodes(graph::AbstractGraph) = length(graph.nodes)

"""Renvoie le nombre d arretes du graphe."""
getNbEdges(graph::AbstractGraph) = length(graph.edges)

"""Affiche un graphe"""
function show(graph::Graph)
	name = getName(graph)
	nb_nodes = getNbNodes(graph)
	nb_edges = getNbEdges(graph)
	s = string("Graph ", name, " has ", nb_nodes, " nodes and ", nb_edges, " edge")
	for node in getNodes(graph)
		s = string(s, "\n", show(node))
	end
	for edge in getEdges(graph)
		s = string(s, "\n", show(edge))
	end
	println(s)
	return s
end
