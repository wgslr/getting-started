## Onedata Quickstart On Docker Cloud

Click the button to deploy:

[![Deploy Onedata to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/)

This configuration will start Onezone and Oneprovider services on separate virtual machines. You need to have two Docker Cloud Nodes on your Docker Cloud Account for it to work. Those virtual machines need ports `6783/tcp` and `6783/udp` open in order for the `overlay` networking to work. 

### Deploying to Docker Cloud

[Install the Docker Cloud CLI](https://docs.docker.com/docker-cloud/tutorials/installing-cli/)

    $ docker login
    $ docker-cloud stack up

### Troubleshooting

#### Using `docker-cloud.yml` with Docker Cloud Web Interface

In order to prevent variable interpolation in *yml* file in the `command:` we use double `$` with every *bash* variable, make sure to substitute all `$$` to single `$`. Please use common sense. 

#### Re-running Onedata

Make sure to terminate (it deletes all the containers) the Onedata stack in Docker Cloud before running it again.