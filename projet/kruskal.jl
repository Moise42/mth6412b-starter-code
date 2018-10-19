include("./node.jl")
include("./edge.jl")

"""Type abstrait"""
abstract type AbstractKruskal{T} end

"""Type kruskal contenant les noeuds et aretes d un graphe, plus son arbre de recouvrement minimal"""
mutable struct Kruskal{T} <: AbstractKruskal{T}
    nodes::Vector{Node{T}}
    edges::Vector{Edge{T}}
    mst::Vector{Edge{T}}
end

"""Constructeur initialisant l arbre de recouvrement a un tableau d aretes vide, et triant les aretes par poids"""
function Kruskal(nodes::Vector{Node{T}}, edges::Vector{Edge{T}}) where T
    sort!(edges)
    Kruskal(nodes,edges,Vector{Edge{T}}())
end

"""Construit l arbre de recouvrement minimal a partir de nodes et edges, et le store dans mst"""
function buildMST!(kruskal::Kruskal{T}) where T
    kruskal.mst = Vector{Edge{T}}()
    for edge in kruskal.edges   # parcour des aretes par ordre de poids croissant
        n1 = edge.node1         # selection des noeuds des aretes
        n2 = edge.node2
        node1_idx = findall(x->isequal(x,edge.node1), N)[1]
        node2_idx = findall(x->isequal(x,edge.node2), N)[1]
        # on verifie que les noeuds n appartiennent pas a la meme classe d equivalence (i.e. meme composante connexe)
        if isequal(n1.parent,n2.parent) == false

            # si c est bien le cas, on ajoute l arete a l arbres de recouvrement
            push!(kruskal.mst,edge)
            # et on unit les classes d equivalence des deux noeuds
            class_eq_idx = findall(x->isequal(x.parent,n2.parent), kruskal.nodes)
            for idx in class_eq_idx
                kruskal.nodes[idx].parent = n1.parent
            end

            #kruskal.nodes[node2_idx].parent = kruskal.nodes[node1_idx].parent

        end
    end
    kruskal.mst
end
