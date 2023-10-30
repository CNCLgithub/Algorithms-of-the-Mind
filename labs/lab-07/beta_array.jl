struct BetaArray <: Gen.Distribution{Array{Float64}} end
const beta_array = BetaArray()

function Gen.logpdf(::BetaArray, x::Array{Float64}, a, b)
    pdf((val, a_i, b_i)) = Gen.logpdf(Gen.beta,val,a_i,b_i) 
    logprobs = pdf.(zip(x,a,b))
    sum(logprobs)
end

function Gen.random(::BetaArray, a, b)
    [Gen.random(Gen.beta,a[i],b[i]) for i in 1:length(a)]
end

function Gen.logpdf_grad(::BetaArray, x::Array{Float64}, a, b)
    pdf_grad((val, a_i, b_i)) = Gen.logpdf_grad(Gen.beta,val,a_i,b_i) 
    grads = pdf_grad.(zip(x,a,b))
    map(i->i[1], grads),map(i->i[2], grads),map(i->i[3], grads)
end

Gen.has_output_grad(::BetaArray) = true
Gen.has_argument_grads(::BetaArray) = (true, true)

export beta_array