struct SSMHAlg <: Algorithm end
"Single Site Metropolis Hastings"
const SSMH = SSMHAlg()

struct SSMHDriftAlg <: Algorithm end
"Single Site Metropolis Hastings with drift"
const SSMHDrift = SSMHDriftAlg()
defΩ(::SSMHDriftAlg) = SimpleΩ{Vector{Int}, Float64}

defcb(::Union{SSMHAlg, SSMHDriftAlg}) = default_cbs()
isapproximate(::Union{SSMHAlg, SSMHDriftAlg}) = true

function update_random(sω::SO)  where {SO <: SimpleΩ}
  k = rand(1:length(sω))
  filtered = Iterators.filter(sω.vals |> keys |> enumerate) do x
    x[1] != k end
  SO(Dict(k => sω.vals[k] for (i, k) in filtered))
end

function update_random(sω::SO, noiseσ)  where {SO <: SimpleΩ}
  tomodify = rand(1:length(sω))
  elements = map(sω.vals |> keys |> enumerate) do (i,k)
    val = if i == tomodify
      (sω.vals[k] |> transform) + noiseσ*randn() |> inv_transform
    else
      sω.vals[k]
    end
    k => val
  end
  elements |> Dict |> SO
end

"Sample from `x` with Single Site Metropolis Hasting"
function Base.rand(x::RandVar,
                   n::Integer,
                   alg::SSMHAlg,
                   ΩT::Type{OT};
                   cb = donothing) where {OT <: Ω}
  rand_(x, n, alg, ΩT; cb = cb, noise = false)
end

function Base.rand(x::RandVar,
                  n::Integer,
                  alg::SSMHDriftAlg,
                  ΩT::Type{OT};
                  cb = donothing,
                  noiseσ = 0.1) where {OT <: Ω}
  rand_(x, n, alg, ΩT; cb = cb, noiseσ = noiseσ, noise = true)
end                  

function rand_(x::RandVar,
               n::Integer,
               alg::Union{SSMHAlg, SSMHDriftAlg},
               ΩT::Type{OT};
               cb = donothing,
               noiseσ = 0.1,
               noise = false) where {OT <: Ω}
  ω = ΩT()
  xω, sb = trackerrorapply(x, ω)
  plast = logepsilon(sb)
  qlast = 1.0
  samples = []
  accepted = 0
  for i = 1:n
    ω_ = if isempty(ω)
      ω
    else
      if noise
        update_random(ω, noiseσ)
      else 
        update_random(ω) 
      end
    end
    xω_, sb = trackerrorapply(x, ω_)
    p_ = logepsilon(sb)
    ratio = p_ - plast
    if log(rand()) < ratio
      ω = ω_
      plast = p_
      accepted += 1
      xω = xω_
    end
    push!(samples, xω)
    cb((ω = ω, accepted = accepted, p = plast, i = i), Outside)
  end
  samples
end