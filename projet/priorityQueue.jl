"""Type abstrait dont d'autres file de priorites dériveront."""
abstract type AbstractPriorityQueue{T} end


""" File de priorite """
mutable struct PriorityQueue{T} <: AbstractPriorityQueue{T}
    queue :: Vector{T}
end

function PriorityQueue(queue::Vector{T}) where T
    sort!(queue)
    PriorityQueue{T}(queue)
end

function PriorityQueue() where T
    PriorityQueue{T}(Vector{T}())
end

function popfirst!(priorityQueue::PriorityQueue{T}) where T
    popfirst!(priorityQueue.queue)
end

function push!(priorityQueue::PriorityQueue{T}, item::T) where T
    # dichotomie
    # insert x
    n = length(priorityQueue.queue)
    a = 1
    b = n
    while(a <= b)
        m = floor(Int,(a+b)/2)
        y = priorityQueue.queue[m]
        if item < y
            b = m-1
        elseif item > y
            a = m+1
        else
            break
        end
    end
    insert!(priorityQueue.queue, floor(Int,(a+b)/2)+1, item)
end
