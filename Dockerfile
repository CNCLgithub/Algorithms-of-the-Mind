# syntax=docker/dockerfile:1
FROM --platform=${TARGETPLATFORM} jupyter/julia-notebook:julia-1.9.2
ARG TARGETPLATFORM

LABEL org.opencontainers.image.title="Algorithms of the Mind"
LABEL org.opencontainers.image.authors="John Muchovej (@jmuchovej), Ilker Yildirim (@iyildirim)"
LABEL org.opencontainers.image.url="https://github.com/cnclgithub/algorithms-of-the-mind/README.md"
LABEL org.opencontainers.image.source="https://github.com/cnclgithub/algorithms-of-the-mind/Dockerfile"

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
      neovim \
      tmux \
    && rm -rf /var/lib/apt/cache/*

RUN groupadd -g ${NB_UID} ${NB_USER} && \
    usermod -g ${NB_USER} -aG users ${NB_USER} && \
    echo ${NB_USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${NB_USER} && \
    chmod 0440 /etc/sudoers.d/${NB_USER}

RUN conda install -n base conda-libmamba-solver && \
    conda config --set solver libmamba

USER ${NB_USER}

ADD --chown=${NB_USER}:${NB_USER} . /algorithms-of-the-mind

WORKDIR /algorithms-of-the-mind

RUN conda env create -f /algorithms-of-the-mind/environment.yml

ENV CONDA_JL_HOME=/opt/conda/envs/algorithms-of-the-mind \
    EDITOR=neovim \
    JULIA_PROJECT=/algorithms-of-the-mind

RUN julia <<EOF
  import Pkg;
  Pkg.activate("/algorithms-of-the-mind")
  Pkg.instantiate()
  Pkg.precompile()
EOF

RUN export JUPYTER_DATA_DIR=/opt/conda/envs/algorithms-of-the-mind/share/jupyter; \
    julia <<EOF
    import IJulia;
    IJulia.installkernel(
      "Julia (AotM)";
      env=Dict(
        "JULIA_PROJECT" => ENV["JULIA_PROJECT"],
        "CONDA_JL_HOME" => ENV["CONDA_JL_HOME"],
        "JULIA_NUM_THREADS" => "auto",
      )
    )
EOF
