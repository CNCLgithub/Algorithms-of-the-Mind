const aarrow = Dict(N=>'↑', W=>'←', S=>'↓', E=>'→')

function Base.show(io::IO, action::GridWorldAction)
    direction = aarrow[action]
    write(io, "Action($direction)")
end

# checks if the position of two states are the same
Base.:(==)(s1::GridWorldState, s2::GridWorldState) = all(s1.pos .== s2.pos)

# adds a state to an action
Base.:(+)(s::GridWorldState, a::GridWorldAction) = GridWorldState(s.pos + a.pos, s.done)

function POMDPs.states(mdp::GridWorld)
    s = GridWorldState[] # initialize an array of GridWorldStates
    # loop over all our states, remeber there are two binary variables:
    # done (d)
    for d = [false, true], y = 1:mdp.size_y, x = 1:mdp.size_x
        push!(s, GridWorldState(Point(x, y),d))
    end
    return s
end;

POMDPs.actions(mdp::GridWorld) = [N, E, S, W];

# transition helpers
function inbounds(mdp::GridWorld, s::GridWorldState)
    return all(Point(1, 1) .<= s.pos .<= Point(mdp.size_x, mdp.size_y))
end

function POMDPs.transition(mdp::GridWorld, state::GridWorldState, action::GridWorldAction)
    a = action
    (x, y) = state.pos
    
    if state.done || state in mdp.reward_states
        return Deterministic(state)
    end

    if !inbounds(mdp, state + action)
        # If would transition out of bounds, stay in
        # same cell with probability 1
        return Deterministic(state)
    else
        statep = map(actions(mdp)) do a
            inbounds(mdp, state + a) ?  state + a : nothing
        end
        statep = filter(s -> !isnothing(s), statep)

        statep_idx = findfirst(isequal(state + action), statep)
        pdist = zeros(length(statep))
        pdist[statep_idx] = mdp.tprob
        pdist[1:length(pdist) .!= statep_idx] .= (1 - mdp.tprob) / (length(pdist) - 1)

        return SparseCat(statep, pdist)
    end
end;

function POMDPs.reward(mdp::GridWorld, state::GridWorldState) 
    if state.done
        return 0.0
    end

    reward_state_idx = findfirst(isequal(state), mdp.reward_states)
    if !(reward_state_idx isa Nothing)
        return mdp.reward_values[reward_state_idx]
    end

    return 0.
end;

function POMDPs.reward(
    mdp::GridWorld,
    state::GridWorldState, action::GridWorldAction, statep::GridWorldState
)
    return POMDPs.reward(mdp, state)
end

POMDPs.discount(mdp::GridWorld) = mdp.discount_factor;

function POMDPs.stateindex(mdp::GridWorld, state::GridWorldState)
    sd = Int(state.done + 1)
    ci = CartesianIndices((mdp.size_x, mdp.size_y, 2))
    return LinearIndices(ci)[state.pos.x, state.pos.y, sd]
end

function POMDPs.actionindex(mdp::GridWorld, act::GridWorldAction)
    index = findfirst(isequal(act), actions(mdp))
    @assert !isnothing(index) "Invalid GridWorld action: $(act)"
    return index
end;

POMDPs.isterminal(mdp::GridWorld, s::GridWorldState) = s.done
