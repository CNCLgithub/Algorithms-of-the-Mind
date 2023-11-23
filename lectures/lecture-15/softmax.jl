function softmax(vs::AbstractVector{T}) where {T <: Real}
    if isempty(vs) return T[] end
    ws = exp.(vs .- maximum(vs))
    return ws ./ sum(ws)
end