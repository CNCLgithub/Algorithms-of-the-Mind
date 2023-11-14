#* NOTE: This will be slow to load on first start-up, since it needs to install all the
#*   Julia packages!
ENV["EDITOR"] = "nvim"
ENV["PYTHON"] = "/opt/conda/bin/python"
ENV["JUPYTER"] = "/opt/conda/bin/jupyter"

orig_project = Base.active_project()

import Pkg
Pkg.activate()
let
    pkgs = [
        "Revise",
        "OhMyREPL",
        # "DrWatson",
        "Pluto",
        "AbbreviatedStackTraces",
        "JuliaFormatter",
    ]
    for pkg in pkgs
        pkgname = String(split(pkg, "#")[1])
        if Base.find_package(pkgname) === nothing
            Pkg.add(pkg)
        end
    end
end

using OhMyREPL
using AbbreviatedStackTraces

# https://timholy.github.io/Revise.jl/stable/config/#Using-Revise-automatically-within-Jupyter/IJulia-1
try
    @eval using Revise
catch e
    @warn "Error initializing Revise" exception = (e, catch_backtrace())
end

Pkg.activate(orig_project)
