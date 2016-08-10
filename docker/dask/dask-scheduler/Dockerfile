FROM python 

RUN pip install bokeh distributed --upgrade

EXPOSE 8786 9786 8787

CMD dask-scheduler --host 0.0.0.0
