ARG BASE_CONTAINER=jupyter/datascience-notebook:7f1482f5a136 
FROM $BASE_CONTAINER

LABEL maintainer="chekos <sergio@cimarron.io>"

USER $NB_UID

# Install python packages
RUN conda install -yq -c conda-forge nbrsessionproxy 
RUN conda install -c conda-forge --quiet --yes 'osmnx' 'gdal' 'poppler' 'numpy' 'scipy' 'fiona'
RUN conda install -c conda-forge --quiet --yes \
    'jupyterlab=0.35.*' \
    'altair' \ 
    'jupytext' \
    'geopandas==0.4.0' \
    'gdal' \
    'fiona' \
    'h5py' \
    'psycopg2' \
    'vega' \
    'vega_datasets' && \
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
    echo "c.JupyterLabTemplates.include_default = True" >> /home/$NB_USER/.jupyter/jupyter_notebook_config.py && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


# Agrega esto de https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues/990
# instala nbrsessionproxy extension

# instala rstudio-server
USER root
RUN apt install wget
RUN apt-get update && \
    apt-get -y install libssl1.0.0 libssl-dev && \
    curl --silent -L --fail https://download2.rstudio.org/rstudio-server-1.1.419-amd64.deb > /tmp/rstudio.deb && \
    echo '24cd11f0405d8372b4168fc9956e0386 /tmp/rstudio.deb' | md5sum -c - && \
    apt-get install -y /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean
ENV PATH=$PATH:/usr/lib/rstudio-server/bin

USER $NB_UID
