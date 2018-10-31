using Test
include("./node.jl")
include("./edge.jl")
include("./graph.jl")
include("./kruskal.jl")
include("./read_stsp.jl")
include("./prim.jl")

"""tests de la classe node"""
node = Node("node", 0)

@test getName(node) == "node"
@test getData(node) == 0
@test show(node) == "Node node, data: 0"
node2 = Node("node2", 0)
node3 = Node("node3", 1)
@test isequal(node, node2)
@test isequal(node, node3) == false

"""tests de la classe edge"""
edge = Edge(node, node3, 1)

@test getNode1(edge) == node
@test getNode2(edge) == node3
@test getWeight(edge) == 1
@test show(edge) == "Edge entre node et node3 de poid 1"

edge2 = Edge(node2,node3, 2)
@test isless(edge,edge2)
@test isless(edge2,edge) == false

"""tests de la classe graph"""
nodea = Node("a", 0)
nodeb = Node("b", 1)
nodec = Node("c", 2)
noded = Node("d", 3)
nodea.parent = nodea;
nodeb.parent = nodeb;
nodec.parent = nodec;
noded.parent = noded;

edgea = Edge(nodea, nodeb, 0)
edgeb = Edge(nodeb, nodec, 1)
edgec = Edge(nodec, noded, 2)
graph = Graph("graph", [nodea, nodeb, nodec], [edgea, edgeb])

@test getName(graph) == "graph"
@test getNbNodes(graph) == 3
@test getNodes(graph) == [nodea, nodeb, nodec]
add_node!(graph, noded)
@test getNbNodes(graph) == 4

@test getNbEdges(graph) == 2
@test getEdges(graph) == [edgea, edgeb]
add_edge!(graph, edgec)
@test getNbEdges(graph) == 3

graph2 = Graph("graph2", [nodea], [edgea])
@test show(graph2) == "Graph graph2 has 1 nodes and 1 edge\nNode a, data: 0\nEdge entre a et b de poid 0"


""" tests de kruskal"""
edgee = Edge(nodec, nodea, 3)
N = Vector{Node{Int64}}()
push!(N, nodea)
push!(N, nodeb)
push!(N, nodec)
E = Vector{Edge{Int64}}()
push!(E, edgea)
push!(E, edgeb)
push!(E, edgee)
kruskal = Kruskal(N[:], E[:])
buildMST!(kruskal)
@test kruskal.mst == [edgea, edgeb]
@test kruskal.mst_weight == 1

""" tests de prim"""
prim = Prim(N[:], E[:])
buildMST!(prim)
@test prim.mst == [edgea, edgeb]
@test prim.mst_weight == kruskal.mst_weight
