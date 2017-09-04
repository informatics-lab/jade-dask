#!/bin/bash

# Install deps
conda update -n dask distributed -y
pip install kubernetes

# Start scheduler
dask-scheduler --port 8786 --bokeh-port 8787 --preload /opt/scheduler/adaptive.py
# dask-scheduler --port 8786 --bokeh-port 8787
