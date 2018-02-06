doc"""
Convenience methods for accessing CLV matrices.

Methods `CLV.C`, `CLV.R` and `CLV.G` are the accessor to the matrices
``C``, ``R`` and ``G`` in

```math
G_{n+k} C_{n+k} D_{k,n} =
M_{k,n} G_n C_n =
G_{n+k} R_{k,n} C_n
```

(Eq. 32, Ginelli et al., 2013).
"""
module CLV
using ..CovariantVectors: ForwardDynamics, BackwardRelaxer, BackwardDynamics,
    BackwardDynamicsWithD, BackwardPass,
    ForwardDynamicsWithGHistory, BackwardDynamicsWithCHistory
import ...LyapunovExponents: tangent_propagate

R_prev(fitr::ForwardDynamics) = fitr.le_solver.R
R_prev(bitr::BackwardPass) = bitr.R_history[end-bitr.i-1]
R(bitr::BackwardPass)      = bitr.R_history[end-bitr.i]
R_next(bitr::BackwardPass) = bitr.R_history[end-bitr.i+1]

const R₋ = R_prev
const R₊ = R_next

G(fitr::ForwardDynamics) = fitr.le_solver.tangent_state
G(fitr::ForwardDynamicsWithGHistory) = G(fitr.stage)
C(bitr::Union{BackwardRelaxer, BackwardDynamics}) = bitr.C
C(bitr::BackwardDynamicsWithCHistory) = C(bitr.stage)

D(bitr::BackwardDynamicsWithD) = Diagonal(bitr.D_diag)
M(fitr::ForwardDynamics) = tangent_propagate(fitr.le_solver, I)

end
