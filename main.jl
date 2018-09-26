import Base.isless, Base.isequal

include("./projet/phase1/read_stsp.jl")
include("./projet/phase1/node.jl")
include("./projet/phase1/edge.jl")
include("./projet/phase1/graph.jl")
include("./projet/phase1/kruskal.jl")

graph_file = "bayg29.tsp"
graph_path = "./instances/stsp/"*graph_file

### pour le fichier test
node1=Node("a", 2)
node2=Node("b", 2)
edge1 = Edge(node1, node2, 54252)
graph1=Graph("g", [node1,node2],[edge1])
show(graph1)
edge2=Edge(node2, node1, 5)
add_edge!(graph1,edge2)
show(graph1)

### Recuperation des aretes et noeuds d un graphe
header = read_header(graph_path)
edges = read_edges(header, graph_path)
nodes = read_nodes(header, graph_path)

### formatage des noeuds du graphe en type Node
N = Vector{Node}();
for k in keys(nodes)
    push!(N,Node(graph_file,k))
end

### formatage des aretes du graphe en type Edge
E = Vector{Edge}();
es = edges[1]
ws = edges[2]
for k = 1:length(es)
    ed = es[k]
    #node1_data = findall(x->getData(x)==ed[1],N)[1]
    #node2_data = findall(x->getData(x)==ed[2],N)[1]
    edge = Edge(Node(graph_file, ed[1]), Node(graph_file, ed[2]), ws[k])
    push!(E,edge)
end

### Creation de l objet kruskal, et calcul de l arbre de recouvrement minimal
kruskal = Kruskal(N[:],E[:])
buildMST!(kruskal::Kruskal)




"""
edges_bruts = []
for edge = kruskal.mst
    edge_brut = (edge.node1.data, edge.node2.data)
    push!(edges_bruts, edge_brut)
end

plot_graph(graph_path)
"""
