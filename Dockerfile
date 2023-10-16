# syntax=docker/dockerfile:1
FROM --platform=${TARGETPLATFORM} jupyter/julia-notebook:julia-1.9.2
ARG TARGETPLATFORM

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
      neovim \
      tmux \
    && rm -rf /var/lib/apt/cache/*

USER ${NB_UID}

RUN conda install -n base conda-libmamba-solver && \
    conda config --set solver libmamba

ADD --chown=${NB_UID}:${NB_GID} . /algorithms-of-the-mind

RUN conda env create -f /algorithms-of-the-mind/env.yaml

ENV CONDA_JL_HOME=/opt/conda/envs/algorithms-of-the-mind \
    EDITOR=neovim \
    JULIA_PROJECT=/algorithms-of-the-mind

RUN julia <<EOF
  import Pkg;
  Pkg.activate("/algorithms-of-the-mind")
  Pkg.instantiate()
  Pkg.precompile()
EOF
