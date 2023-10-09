import Gen
import Gen: logpdf, logpdf_grad, Distribution, random, is_discrete, has_argument_grads, has_output_grad, categorical

struct Draw <: Distribution{Any} end
const draw = Draw()

function logpdf(::Draw, x::T, items::Vector{T}, probs::AbstractArray{U,1}) where {T, U<:Real}
    idx = findfirst(isequal(x), items)
    (idx > 0 && idx <= length(probs)) ? log(probs[idx]) : -Inf
end
function logpdf(::Draw, x::T, items::Vector{T}) where {T}
    probs = ones(length(items)) ./ length(items)
    logpdf(Draw(), x, items, probs)
end

function logpdf_grad(::Draw, x::T, items::Vector{T}, probs::AbstractArray{U,1}) where {T, U<:Real}
    idx = findfirst(isequal(x), items)
    grad = zeros(length(probs))
    grad[idx] = 1.0 / probs[idx]
    (nothing, grad)
end
function logpdf_grad(::Draw, x::T, items::Vector{T}) where {T}
    probs = ones(length(items)) ./ length(items)
    logpdf_grad(Draw(), x, items, probs)
end

function random(::Draw, items::Vector{T}, probs::AbstractArray{U,1}) where {T, U<:Real}
    idx = Gen.categorical(probs)
    items[idx]
end
function Gen.random(::Draw, items::Vector{T}) where {T}
    probs = ones(length(items)) ./ length(items)
    random(Draw(), items, probs)
end
is_discrete(::Draw) = true

(::Draw)(items::Vector{T}, probs) where {T} = random(Draw(), items, probs)
(::Draw)(items::Vector{T}) where {T} = random(Draw(), items)

has_output_grad(::Draw) = false
has_argument_grads(::Draw) = (true,)
