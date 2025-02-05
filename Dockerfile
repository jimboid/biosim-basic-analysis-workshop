# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM harbor.stfc.ac.uk/biosimulation-cloud/biosim-jupyter-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Install workshop deps
RUN conda install mdtraj matplotlib numpy nglview -y
RUN conda install ipywidgets -c conda-forge -y 


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
