[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/tacos-de-datos/tacos-en-jupyter/master)
# Tacos en Jupyter
Una imagen `Docker` para crear un `JupyterHub` bien equipado.

Esta imagen extiende la imagen `Docker` [jupyter/datascience-notebook](https://github.com/jupyter/docker-stacks/tree/master/datascience-notebook) y le agrega:
* `jupyterlab_templates`
* `altair` (con `vega` y `vega_datasets`)
* `jupytext`
