__precompile__()
"Minimal Probabilistic Programming Langauge"
module Mu

using Distributions
using ProgressMeter
using Spec
using RunTools
# using Lens

# Util
include("util/misc.jl")

# Core
include("omega/omega.jl") # Sample Space
include("omega/proj.jl") # Sample Space
include("randvar.jl")    # Random Variables

## Different Types of Omega 
include("omega/nested.jl") # Sample Space
include("omega/simple.jl") # Sample Space
include("omega/countvec.jl") # Sample Space
include("omega/dirtyomega.jl") # Sample Space
include("omega/id.jl")  # Pairing functions for omega ids
include("omega/diffomega.jl")  # Differentiable Omega

include("randvarapply.jl")    # Random Variables

include("rcd.jl")  # Random Conditional Distributi
include("array.jl")     # Array primitives
include("lift.jl")      # Lifting functions to RandVar domain

# Inference
include("algorithm.jl") # Algorithm abstract type
include("soft.jl")      # Soft logic
include("cond.jl")      # Conditional Random Variables

# Inference Algorithms
include("inference/rand.jl")      # Sampling
include("inference/rs.jl")       # Metropolized Independent Sampling
include("inference/mi.jl")       # Metropolized Independent Sampling
include("inference/ssmh.jl")      # Single Site Metropolis Hastings
include("inference/hmc.jl")      # Single Site Metropolis Hastings
include("inference/sghmc.jl")      # Single Site Metropolis Hastings

include("inference/cgan.jl")      # Conditional GAN inference
include("inference/spen.jl")      # Structured Predicton Energy Networks

# Causal Inference
include("do.jl")        # Causal Reasoning

# Gradient
include("gradient.jl")

# Library
include("distributions.jl")  # Sampling
include("statistics.jl")     # Mean, etc

include("params.jl")

export mean,
       prob,
       rcd,
       ∥,
       softeq,
       ≊,
       ⪆,
       randarray,
       @lift,
       lift,
       @id,
       iid,

       # Distributions
       gammarv,
       Γ,
       normal,
       uniform,
       inversegamma,
       dirichlet,
       betarv,
       bernoulli,
       poisson,

       # Do
       intervene,

       # Algorithms
       RejectionSample,
       MI,
       SSMH,
       HMC,
       SGHMC,

       # Gradient
       gradient,

       # Parameters
       Params
end
