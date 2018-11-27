include("./prim.jl")



function rsl!(prim::Prim{T}) where T
    circuit_nodes = prim.order_of_visit
    n = length(circuit_nodes)
    T = typeof(circuit_nodes[1].data)
    circuit_edges = Vector{Edge{T}}()
    circuit_weight = 0;
    for k = 1:n-1
        e_idx = findall(x-> ( isequal(x.node1,circuit_nodes[k]) && isequal(x.node2,circuit_nodes[k+1])
        || isequal(x.node1,circuit_nodes[k+1]) && isequal(x.node2,circuit_nodes[k])  ), E)[1]
        push!(circuit_edges, E[e_idx]);
        circuit_weight += E[e_idx].weight;
    end
    e_idx = findall(x-> ( isequal(x.node1,circuit_nodes[1]) && isequal(x.node2,circuit_nodes[n])
    || isequal(x.node1,circuit_nodes[n]) && isequal(x.node2,circuit_nodes[1])  ), E)[1]
    push!(circuit_edges, E[e_idx]);
    circuit_weight += E[e_idx].weight;
    return circuit_edges
end
