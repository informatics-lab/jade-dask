#cloud-config
runcmd:
    # Ensure terminal supports unicode text
    - 'export LC_ALL=C.UTF-8'
    - 'export LANG=C.UTF-8'
    # Run required commands as non-root user
    ## Setup s3fs
    - 'apt-get update -y'
    - 'apt-get install -y automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config'
    - 'sudo -u ubuntu -H sh -c cd && git clone https://github.com/s3fs-fuse/s3fs-fuse.git /home/ubuntu/s3fs-fuse'
    - 'chown -R ubuntu:ubuntu /home/ubuntu/s3fs-fuse'
    - 'sudo -u ubuntu -H sh -c "cd /home/ubuntu/s3fs-fuse && ./autogen.sh && ./configure && make && sudo make install"'
    - 'mkdir -p /data/mogreps'
    - 'chown -R ubuntu:ubuntu /data'
    - 'sudo -u ubuntu -H sh -c "cd && s3fs mogreps /data/mogreps -o public_bucket=1,uid=1000,gid=1000,mp_umask=002"'
    ## Setup Distributed
    - 'sudo -u ubuntu -H sh -c cd && /home/ubuntu/anaconda3/bin/conda install -y dask distributed'
    - 'sudo -u ubuntu -H sh -c cd && /home/ubuntu/anaconda3/bin/conda install -y -c scitools iris'
    - 'sudo -u ubuntu -H sh -c "cd && ${command}"'
