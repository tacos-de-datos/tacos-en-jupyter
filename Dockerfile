ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="chekos <sergio@cimarron.io>"

USER $NB_UID

# Install other packages
RUN conda install -c conda-forge --quiet --yes \
    'altair' \ 
    'jupytext' \
    'geopandas==0.4.0' \
    'vega' \
    'vega_datasets' \
    'jupyterlab=0.35.*' && \
    conda remove --quiet --yes --force qt pyqt && \
    conda clean -typsy && \
    pip install jupyterlab_templates && \
    # enable jupyterlab_templates extension
    jupyter labextension install jupyterlab_templates && \
    jupyter serverextension enable --py jupyterlab_templates --sys-prefix && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^0.38.0 && \
    jupyter labextension install @jupyterlab/hub-extension@^0.12.0 && \
    # clean installation and build jupyterlab
    jupyter lab build && \
    #jupyter lab clean \
    # create jupyter_notebook_config.py
    jupyter notebook --generate-config -y && \
    # clone templates into template directory
    git clone https://github.com/tacos-de-datos/planillas_jupyter.git /home/$NB_USER/.jupyter/planillas && \
    # add directory path to notebook config file
    echo "c.JupyterLabTemplates.template_dirs = ['/home/$NB_USER/.jupyter/planillas/planillas']" >> /home/$NB_USER/.jupyter/jupyter_notebook_config.py && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER $NB_UID
