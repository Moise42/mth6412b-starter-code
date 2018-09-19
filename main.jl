include("./projet/phase1/read_stsp.jl")
include("./projet/phase1/node.jl")
include("./projet/phase1/edge.jl")
include("./projet/phase1/graph.jl")
graph_file = "./instances/stsp/bayg29.tsp"

node1=Node("a", 2)
node2=Node("b", 3)
edge = Edge(node1, node2, 54252)
graph1=Graph("g", [node1,node2],[edge])
show(graph1)
edge2=Edge(node2, node1, 5)
add_edge!(graph1,edge2)
show(graph1)

e = read_edges(read_header(graph_file), graph_file)
e
#show(edge)
#show(node1)
plot_graph(graph_file)
