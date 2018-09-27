include("./node.jl")
include("./edge.jl")

"""Type abstrait"""
abstract type AbstractKruskal end

"""Type kruskal contenant les noeuds et aretes d un graphe, plus son arbre de recouvrement minimal"""
mutable struct Kruskal<: AbstractKruskal
    nodes::Vector{Node}
    edges::Vector{Edge}
    mst::Vector{Edge}
end

"""Constructeur initialisant l arbre de recouvrement a un tableau d aretes vide, et triant les aretes par poids"""
function Kruskal(nodes::Vector{Node}, edges::Vector{Edge})
    sort!(edges)
    Kruskal(nodes,edges,Vector{Edge}())
end

"""Construit l arbre de recouvrement minimal a partir de nodes et edges, et le store dans mst"""
function buildMST!(kruskal::Kruskal)
    kruskal.mst = Vector{Edge}()
    for edge in kruskal.edges   # parcour des aretes par ordre de poids croissant
        n1 = edge.node1         # selection des noeuds des aretes
        n2 = edge.node2
        node1_idx = findall(x->isequal(x,edge.node1), N)[1]
        node2_idx = findall(x->isequal(x,edge.node2), N)[1]
        # on verifie que les noeuds n appartiennent pas a la meme classe d equivalence (i.e. meme composante connexe)
        if isequal(kruskal.nodes[node1_idx].parent,kruskal.nodes[node2_idx].parent) == false

            # si c est bien le cas, on ajoute l arete a l arbres de recouvrement
            push!(kruskal.mst,edge)
            # et on unit les classes d equivalence des deux noeuds
            class_eq_idx = findall(x->isequal(x.parent,kruskal.nodes[node2_idx].parent), kruskal.nodes)
            for idx in class_eq_idx
                kruskal.nodes[idx].parent = kruskal.nodes[node1_idx].parent
            end

            #kruskal.nodes[node2_idx].parent = kruskal.nodes[node1_idx].parent

        end
    end
    kruskal.mst
end
