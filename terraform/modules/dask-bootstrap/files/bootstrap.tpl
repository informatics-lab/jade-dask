#cloud-config
runcmd:
    # Ensure terminal supports unicode text
    - 'export LC_ALL=C.UTF-8'
    - 'export LANG=C.UTF-8'
    # Run required commands as non-root user
    ## Setup s3fs
    - 'yum update -y'
    - 'yum install -y docker'
    - 'service docker start'
    - '${command}'