include("./node.jl")
include("./edge.jl")

"""Type abstrait"""
abstract type AbstractKruskal{T} end

"""Type kruskal contenant les noeuds et aretes d un graphe, plus son arbre de recouvrement minimal"""
mutable struct Kruskal{T} <: AbstractKruskal{T}
    nodes::Vector{Node{T}}
    edges::Vector{Edge{T}}
    mst::Vector{Edge{T}}
    mst_weight::Integer
end

"""Constructeur initialisant l arbre de recouvrement a un tableau d aretes vide, et triant les aretes par poids"""
function Kruskal(nodes::Vector{Node{T}}, edges::Vector{Edge{T}}) where T
    sort!(edges)
    Kruskal(nodes,edges,Vector{Edge{T}}(),0)
end

"""Construit l arbre de recouvrement minimal a partir de nodes et edges, et le store dans mst"""
function buildMST!(kruskal::Kruskal{T}) where T
    kruskal.mst = Vector{Edge{T}}()
    kruskal.mst_weight = 0;
    for edge in kruskal.edges   # parcour des aretes par ordre de poids croissant
        n1 = edge.node1         # selection des noeuds des aretes
        n2 = edge.node2
        node1_idx = findall(x->isequal(x,edge.node1), N)[1]
        node2_idx = findall(x->isequal(x,edge.node2), N)[1]
        # on verifie que les noeuds n appartiennent pas a la meme classe d equivalence (i.e. meme composante connexe)
        if isequal(n1.parent,n2.parent) == false

            # si c est bien le cas, on ajoute l arete a l arbre de recouvrement et on met a jour le poids de l arbre
            push!(kruskal.mst,edge)
            kruskal.mst_weight = kruskal.mst_weight + edge.weight

            # et on unit les classes d equivalence des deux noeuds
            unionRang!(n1,n2) # par l union des rangs
            # compressionChemin!(n1,n2) # ou par la compression des chemins

        end
    end
    kruskal.mst
end

function unionRang!(n1::Node{T}, n2::Node{T}) where T
    if n1.parent.rang == n2.parent.rang
        n1.parent.rang +=1
        compressionChemin!(n1,n2)
    elseif n1.parent.rang > n2.parent.rang
        compressionChemin!(n1,n2)
    else
        compressionChemin!(n2,n1)
    end
end

function compressionChemin!(n1::Node{T}, n2::Node{T}) where T
    class_eq_idx = findall(x->isequal(x.parent,n2.parent), kruskal.nodes)
    for idx in class_eq_idx
        kruskal.nodes[idx].parent = n1.parent
    end
end
