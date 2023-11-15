function render(mdp::GridWorld, step::Union{NamedTuple,Dict}=(;);
                color = s->reward(mdp, s),
                policy::Union{Policy,Nothing} = nothing,
                colormin::Float64 = -10.0, colormax::Float64 = 10.0
               )
    
    color = tofunc(mdp, color)
    
    nx, ny = (mdp.size_x, mdp.size_y)

    cells = []
    for x in 1:nx, y in 1:ny
        cell = cell_ctx((x,y), (mdp.size_x, mdp.size_y))
        if policy !== nothing
            a = action(policy, GridWorldState(x,y))
            txt = compose(context(), Compose.text(0.5, 0.5, aarrow[a], hcenter, vcenter), Compose.stroke("black"), fill("black"))
            compose!(cell, txt)
        end
        #clr = tocolor(color(GWPos(x,y)), colormin, colormax)
        clr = tocolor(color(GridWorldState(x,y)), colormin, colormax)    
        
        compose!(cell, rectangle(), fill(clr), Compose.stroke("gray"))
        push!(cells, cell)
    end
    
    grid = compose(context(), linewidth(0.5mm), cells...)
    outline = compose(context(), linewidth(1mm), rectangle(), Compose.stroke("gray"))

    history = []
    if haskey(step, :start)
        agent = cell_ctx(step[:start], (mdp.size_x, mdp.size_y))
        txt = compose!(context(), Compose.text(0.5, 0.5, aarrow[step[:actions][1]], hcenter, vcenter), Compose.stroke("black"), fill("black"))
        compose!(agent, circle(0.5, 0.5, 0.4), fill("orange")) 
        compose!(agent, txt)
        curr_x, curr_y = step[:start]
        if haskey(step, :actions)
            for (k, curr_action) in enumerate(step[:actions])
                element = cell_ctx((curr_x, curr_y), (mdp.size_x, mdp.size_y))
                act = compose!(context(), Compose.text(0.5, 0.5, aarrow[curr_action], hcenter, vcenter), Compose.stroke("black"), fill("black"))
                compose!(element, act)
                push!(history, element)
                if haskey(step, :visitedstates)
                    curr_x, curr_y = step[:visitedstates][k]
                else
                    (curr_x, curr_y) = Point(curr_x, curr_y) + curr_action.pos
                end
            end
        end  
    else
        agent = nothing
    end

    allsteps = compose(context(), history...)
    if haskey(step, :sp) && !isterminal(mdp, step[:sp])
        next_agent = cell_ctx(step[:sp], (mdp.size_x, mdp.size_y))
        compose!(next_agent, circle(0.5, 0.5, 0.4), fill("lightblue"))
    else
        next_agent = nothing
    end

    sz = min(w,h)
    return compose(context((w-sz)/2, (h-sz)/2, sz, sz), agent, allsteps, next_agent, grid, outline)
end

function cell_ctx(xy, size)
    nx, ny = size
    x, y = xy
    return context((x-1)/nx, (ny-y)/ny, 1/nx, 1/ny)
end

tocolor(x, colormin, colormax) = x
function tocolor(r::Float64, colormin::Float64, colormax::Float64)
    frac = (r-colormin)/(colormax-colormin)
    return get(ColorSchemes.redgreensplit, frac)
end

tofunc(m::GridWorld, f) = f
tofunc(m::GridWorld, mat::AbstractMatrix) = s -> mat[s...]
tofunc(m::GridWorld, v::AbstractVector) = s -> v[stateindex(m, s)]
