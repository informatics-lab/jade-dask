#cloud-config
runcmd:
    # Ensure terminal supports unicode text
    - 'export LC_ALL=C.UTF-8'
    - 'export LANG=C.UTF-8'
    # Run required commands as non-root user
    - 'sudo -u ubuntu -H sh -c cd && /home/ubuntu/anaconda3/bin/conda install -y dask distributed'
    - 'sudo -u ubuntu -H sh -c cd && /home/ubuntu/anaconda3/bin/conda install -y -c scitools iris'
    - 'sudo -u ubuntu -H sh -c "cd && ${command}"'
