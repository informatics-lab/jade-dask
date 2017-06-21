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
    ## Set hostname
    - 'hostname dask-$(date +%s | sha256sum | base64 | head -c 8).devel.jupyter.informaticslab.co.uk'
    ## Install and configure telegraf
    - 'wget https://dl.influxdata.com/telegraf/releases/telegraf-1.2.1.x86_64.rpm'
    - 'yum localinstall telegraf-1.2.1.x86_64.rpm -y'
    - 'sed -i "/^  urls = .* # required/c\  urls = [\"http:\/\/monitor.informaticslab.co.uk:8086\"] # required" /etc/telegraf/telegraf.conf'
    - 'sed -i "/^  # username = \".*\"/c\  username = \"ingest\"" /etc/telegraf/telegraf.conf'
    - 'sed -i "/^  # password = \".*\"/c\  password = \"josxyxgyqbulfurg\"" /etc/telegraf/telegraf.conf'
    - 'sed -i "/\[\[inputs.net\]\]/c\  \[\[inputs.net\]\]" /etc/telegraf/telegraf.conf'
    - 'service telegraf start'
    ## Run command
    - '${command}'
