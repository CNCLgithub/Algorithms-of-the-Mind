using Pkg
Pkg.activate("myenv")
using Distributions
using ProgressMeter
using Gen, Plots
using Parameters
using PyCall
numpy = pyimport("numpy")
mi = pyimport("mitsuba")
mi.set_variant("scalar_rgb")

@with_kw struct ModelParams
    path::String = "./cbox_generic.xml"
    scene::PyObject = mi.load_file(path)::PyObject
    params::PyObject = mi.traverse(scene)::PyObject
    spp::Int32 = 16
end

function mitsuba_transform(modelparams, object, scale, translation)
    t = mi.Transform4f.translate(translation).scale([scale, scale, scale])
    set!(modelparams.params, object, t)
    println(get(modelparams.params, object))
end

function mitsuba_render(modelparams)
    image = mi.render(modelparams.scene, spp=modelparams.spp)
    bitmap = mi.Bitmap(image).convert(srgb_gamma=true)
end


@gen function room(modelparams::ModelParams)

    # prior over the scale of the left sphere
    s_left ~ uniform(0.1, 1.0)
    # we assume we know a priori where this sphere will appear in the scene
    t_left = [-0.3, -0.5, 0.2]
    mitsuba_transform(modelparams, "left-object.to_world", s_left, t_left)
    
    # prior over the scale of the right sphere
    s_right ~ uniform(0.1, 1.0)
    # we assume we know a priori where this sphere will appear in the scene
    t_right = [0.5, -0.75, -0.2] 
    mitsuba_transform(modelparams, "right-object.to_world", s_right, t_right)

    py"$modelparams.params.update()"o

    # render the scene and get the output in an array
    bitmap = mitsuba_render(modelparams)
    mu = @pycall numpy.array(bitmap)::Array{Float32, 3}

    pred ~ broadcasted_normal(mu, 1)

    return bitmap
    
end


obs_scene = ModelParams(path = "./scenes/cbox.xml", spp=64)
obs_bitmap = mitsuba_render(obs_scene)
obs_image = Gen.choicemap()
obs_image[:pred] = @pycall numpy.array(obs_bitmap)::Array{Float32, 3}
obs_scene = 1

# include the truncated norm distribution
include("truncatednorm.jl")

# proposal distribution for the scale variables
@gen function scale_proposal(current_trace)
    # trunc_norm(mean, std, lower_bound, upper_bound)
    # why do we need a truncated norm, instead of a regular normal distribution?
    s_left ~ trunc_norm(current_trace[:s_left], 0.1, 0.1, 1.0)
    s_right ~ trunc_norm(current_trace[:s_right], 0.1, 0.1, 1.0)
end

function random_walk_mh(tr)
    
    # make a random-walk update on scale variables
    (tr, _) = mh(tr, scale_proposal, ())

    # return the updated trace
    tr
end

modelparams = ModelParams()
t, = generate(room, (modelparams,), obs_image)

scores = Vector{Float64}(undef, 30)
for i in 1:30
    global t
    t = random_walk_mh(t)
    scores[i] = get_score(t)
    println(i)
end;
println(scores)