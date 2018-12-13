include("./node.jl")
include("./edge.jl")

"""Type abstrait"""
abstract type AbstractMST{T} end

"""Type kruskal contenant les noeuds et aretes d un graphe, plus son arbre de recouvrement minimal"""
mutable struct MST{T} <: AbstractMST{T}
    graph::Graph{T}
    mst_edges::Vector{Edge{T}}
    mst_weight::Integer
    order_of_visit::Vector{Node{T}}
end

"""Constructeur initialisant l arbre de recouvrement a un tableau d aretes vide, et triant les aretes par poids"""
function MST(graph::Graph{T}) where T
    MST(graph, Vector{Edge{T}}(), 0, Vector{Node{T}}())
end

"""Construit l arbre de recouvrement minimal a partir de nodes et edges, et le store dans mst"""
function buildMST_kruskal!(mst::MST{T}) where T
    mst.mst_edges = Vector{Edge{T}}()
    sort!(mst.graph.edges)
    mst.mst_weight = 0;
    for edge in mst.graph.edges   # parcour des aretes par ordre de poids croissant
        n1 = edge.node1         # selection des noeuds des aretes
        n2 = edge.node2
        node1_idx = findall(x->isequal(x,edge.node1), mst.graph.nodes)[1]
        node2_idx = findall(x->isequal(x,edge.node2), mst.graph.nodes)[1]
        # on verifie que les noeuds n appartiennent pas a la meme classe d equivalence (i.e. meme composante connexe)
        if isequal(n1.parent,n2.parent) == false

            # si c est bien le cas, on ajoute l arete a l arbre de recouvrement et on met a jour le poids de l arbre
            push!(mst.mst_edges,edge)
            mst.mst_weight = mst.mst_weight + edge.weight

            # et on unit les classes d equivalence des deux noeuds
            unionRang!(n1,n2,mst) # par l union des rangs
            # compressionChemin!(n1,n2) # ou par la compression des chemins

        end
    end
    tree_preodre!(mst)
    mst
end


function buildMST_prim!(mst::MST{T},node::Node{T}=mst.graph.nodes[1]) where T
    mst.mst_edges = Vector{Edge{T}}()
    mst.mst_weight = 0
    node.visited = true
    push!(mst.order_of_visit, node)
    # algorithme de prim, la liste de priorite contient les aretes sortante du noeud de depart
    # println("u")
    dic = Dict{Node{Int64}, Vector{Edge{Int64}}}()
    for n in mst.graph.nodes
        dic[n] = []
    end
    for e in mst.graph.edges
        push!(dic[e.node1], e)
        push!(dic[e.node2], e)
    end

    priorityQueue = PriorityQueue(dic[node])
    while !isempty(priorityQueue.queue)
        # l arete de poid le plus faible dans la file de priorite est selectionnee
        # sort!(priorityQueue)
        # edge = popfirst!(priorityQueue)

        # edge_idx = argmin(priorityQueue)
        # edge = priorityQueue[edge_idx]
        # deleteat!(priorityQueue, edge_idx)
        edge = popfirst!(priorityQueue)


        # on verifie que l on ne forme pas de cycles
        edge.node1.visited ? node = edge.node2 : node = edge.node1
        if node.visited == false
            node.visited = true
            push!(mst.order_of_visit, node)
            # on ajoute l arete a l arbre de recouvrement minimal en mettant a jour son poids
            push!(mst.mst_edges, edge)
            mst.mst_weight = mst.mst_weight + edge.weight
            # for edge in inEdges(node, mst.graph.edges)
            for edge in dic[node]
                # on ajoute a la file de priorite toutes les aretes sortantes du nouveau noeud visite
                push!(priorityQueue,edge)
            end
        end
    end
    mst
end

function unionRang!(n1::Node{T}, n2::Node{T}, mst::MST{T}) where T
    if n1.parent.rang == n2.parent.rang
        n1.parent.rang +=1
        compressionChemin!(n1,n2,mst)
    elseif n1.parent.rang > n2.parent.rang
        compressionChemin!(n1,n2,mst)
    else
        compressionChemin!(n2,n1,mst)
    end
end

function compressionChemin!(n1::Node{T}, n2::Node{T}, mst::MST{T}) where T
    class_eq_idx = findall(x->isequal(x.parent,n2.parent), mst.graph.nodes)
    for idx in class_eq_idx
        mst.graph.nodes[idx].parent = n1.parent
    end
end



""" parcour preordre du mst """
function tree_preodre!(mst::MST{T}) where T

    stack = Vector{Node}()
    push!(stack, mst.graph.nodes[1])
    preorder = Vector{Node}()
    while !isempty(stack)
       current_node = pop!(stack)
       current_node.visited = true
       push!(preorder, current_node)
       edges_from_current = inEdges(current_node, mst.mst_edges)
       for edg in edges_from_current
           if !isequal(current_node, edg.node1)
               if edg.node1.visited == false
                   push!(stack, edg.node1)
               end
           else
               if edg.node2.visited == false
                   push!(stack, edg.node2)
               end
           end
       end
    end
    mst.order_of_visit = preorder
    return mst
end
