# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM ghcr.io/jimboid/biosim-jupyterhub-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"
LABEL org.opencontainers.image.source=https://github.com/jimboid/biosim-basic-analysis-workshop
LABEL org.opencontainers.image.description="A container environment for the ccpbiosim workshop on basic analysis."
LABEL org.opencontainers.image.licenses=MIT

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Install workshop deps
RUN conda install matplotlib numpy nglview ipywidgets -y
RUN pip install mdtraj 

# Get workshop files and move them to jovyan directory.
RUN git clone https://github.com/CCPBioSim/basic-analysis-workshop.git && \
    mv basic-analysis-workshop/* . && \
    rm -r AUTHORS Dockerfile LICENSE README.md _config.yml basic-analysis-workshop

# Copy lab workspace
COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER
