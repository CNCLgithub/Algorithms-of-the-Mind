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
      jq \
    && rm -rf /var/lib/apt/cache/*

RUN groupadd -g ${NB_UID} ${NB_USER} && \
    usermod -g ${NB_USER} -aG users ${NB_USER} && \
    echo ${NB_USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${NB_USER} && \
    chmod 0440 /etc/sudoers.d/${NB_USER}

RUN conda install -n base conda-libmamba-solver && \
    conda config --set solver libmamba

ADD --chown=${NB_USER}:${NB_USER} . /algorithms-of-the-mind

WORKDIR /algorithms-of-the-mind

RUN conda env create -f /algorithms-of-the-mind/environment.yml --yes; \
    conda env update -n base -f /algorithms-of-the-mind/environment.yml

ADD .devcontainer/root/ /

ENV JUPYTER_DATA_DIR="${CONDA_DIR}/share/jupyter"
ENV CONDA_JL_HOME="${CONDA_DIR}/envs/algorithms-of-the-mind"
ENV EDITOR="neovim"
ENV CONDA_DEFAULT_ENV="algorithms-of-the-mind"
ENV JULIA_PROJECT="/algorithms-of-the-mind"
ENV NOTEBOOK_ARGS="--config /opt/conda/etc/jupyter/config.py"
EXPOSE 2686

RUN julia <<EOF
  import Pkg;
  Pkg.activate("/algorithms-of-the-mind")
  Pkg.instantiate()
EOF

RUN rm -rf ${JUPYTER_DATA_DIR}/kernels/* ; \
    pkgs=$(conda list -n algorithms-of-the-mind --json); \
    _python="$(echo "${pkgs}" | jq -r '.[] | select(.name == "python")')"; \
    pythonV="$(echo "${_python}" | jq -r ".version" | tr -d '[:space:]')"; \
    conda run -n algorithms-of-the-mind \
      python -m ipykernel install \
        --prefix "${CONDA_DIR}" \
        --name atom-py \
        --display-name "Algorithms of the Mind (Python) ${pythonV}"; \
    juliaV="$(julia --version | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}")"; \
    julia <<EOF
    import IJulia;
    IJulia.installkernel(
      "Algorithms of the Mind (Julia)";
      specname="atom-jl",
      env=Dict(
        "JULIA_PROJECT" => ENV["JULIA_PROJECT"],
        "CONDA_JL_HOME" => ENV["CONDA_JL_HOME"],
        "JULIA_NUM_THREADS" => "auto",
      )
    )
EOF

RUN chown -R ${NB_UID}:${NB_GID} /algorithms-of-the-mind; \
    fix-permissions /algorithms-of-the-mind; \
    chown -R ${NB_UID}:${NB_GID} ${CONDA_DIR}; \
    fix-permissions ${CONDA_DIR}

USER ${NB_USER}
