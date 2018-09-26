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

edges = read_edges(read_header(graph_file), graph_file)
nodes = read_nodes(read_header(graph_file), graph_file)

N = Vector{Node}();
for k in keys(nodes)
    push!(N,Node(graph_file,k))
end

E = Vector{Edge}();
es = edges[1]
ws = edges[2]
node1_data = 0
node2_data = 0
for k = 1:length(es)
    ed = es[k]
    node1_data = findall(x->getData(x)==ed[1],N)
    node2_data = findall(x->getData(x)==ed[2],N)
    edge = Edge(Node(graph_file, node1_data[1]), Node(graph_file, node2_data[1]), ws[k])
    push!(E,edge)
end

for edge in E
    println(getWeight(edge))
end


#index_sort=sortperm(e[2])

#show(edge)
#show(node1)
#plot_graph(graph_file)
