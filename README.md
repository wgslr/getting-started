# Quickstart 3.0

> This page presents you with few scenarios for quickly and easily getting started with Onedata. Scenarios vary in complexity: beginning with simple, preconfigured demos; ending with highly advanced multi-cluster setups. Each scenario is composed of a set of detailed step-by-step instructions and a script installs Onedata services on your machine. All the scripts are available for download from github: https://github.com/onedata/quickstart

### Prerequisites
1. All scenarios are prepared as docker images. A linux system with docker version 1.10.3 or greater is required to run them.
2. Depending on the scenario you might need to create an account on onedata.org.

### Repository structure

1. `run.sh` - interactive script used to run scenarios
2. `scenario{X}` - directories, each containing a `docker-compose.yml` and other scenario specific configuration files
3. `client` - directory, containing instruction on using Onedata client image
1. `env` - definitions of environment variables used in docker-compose.yml files (if you encounter problems, start with looking at that file)


### Accessing Spaces
In each scenario you will deploy a Oneprovider which can be used to support your space. If you are not familiar with the concept of Spaces read the [Overview](a) and [Space support](a) sections in the documentation. After supporting you space you will be able to access them using a web-interface or Oneclient.

#### With Web-interface
Refer to the documentation of [web-iterface](a) for further instructions.

#### With Oneclient
In `oneclient` directory you will find a `oneclient.sh` script that will allow to use Oneclient using a docker image just like regular Oneclient command. Please refer to [oneclient documentation](a) page.

>TODO: Byc moze wspomniec od PROVIDER_HOSTNAME.

### Quickstart Scenarios

The proper installation of Onedata requires one or more public ip addresses in order to properly communicate with onedata.org. Following scenarios are divided into two categories:
- those that does not require public ip addresses, but make it necessary to install all of Onedata components
- those that require public ip addresses and does not require installation of all components

All scenarios are designed to work on a single machine running multiple docker containers. A machine with locally installed docker is recommended. If you want to use docker-machine with remote host running docker please read [here](here).

In order to execute following scenarios please clone the [quickstart repository](https://github.com/onedata/quickstart). Each scenario directory coresponds to one of the described scenarios. In each directory you will find a `docker-compose.yml`, which is a docker-compose configuration specifying the scenario setup.

In order to run any of the scenarion use `run.sh` and follow the script.

In the top directory you will also find a `cleanup.sh` script. That will help you shutdown and remove Onedata containers, images and networks from your system.

In each scenario the credentials needed to login into Onepanel are:
```
user: admin
password: password
```

#### Scenarios Requiring a Public IP
Scenarios in this section require that machine(s) you deploy Onedata on have public ip addresses in order to properly communicated with onedata.org

##### Scenario 1
Fastest setup: Pre-configured Oneprovider
In this scenario you will setup single-node Oneprovider and connect to it with oneclient.
Dedicated docker containers come with pre-installed and pre-configured Oneprovider.

In order to run it execute `run.sh --scenario 1` command.

The configuration of Oneprovider can be tailored to your needs and is located in `scenario1/docker-compose.yml` in section `environment` of Oneprovider service configuration.

##### Scenario 2
Basic setup: Oneprovider
In this scenario you will deploy and configure Oneprovider in a container. Oneprovider will connect to onedata.org.

In order to run it execute `run.sh --scenario 2` command.

###### Oneprovider Installation
Navigate to `https://172.30.1.1:9443` enter Onepanel credentials and proceed with the installation wizard.
After finishing the installation navigate to onedata.org, login into your account and support your space using provider you just installed. After that you will be able to manage your space with web interface via. onedata.org or with oneclient.

#### Localhost Scenarios
Scenarios in this section require you to configure your own OneZone. Oneproviders will communicate with local OneZone instead connecting to onedata.org.


##### Scenario 3
Basic setup: Pre-configured OneZone and Oneprovider.
In this scenario you will setup single-node Oneprovider and connect to it with oneclient.
Dedicated docker containers come with pre-installed and pre-configured Oneprovider.

In this scenario you will setup OneZone and Oneprovider and connect to it with oneclient. Dedicated docker containers come with pre-installed and pre-configured Oneprovider and Onezone services.

In order to run it execute `run.sh --scenario 3` command.

The configurations of Oneprovider and Onezone can be tailored to your needs and are located in `scenario1/docker-compose.yml` in section `environment` of Oneprovider and Onezone services configuration respectively.

##### Scenario 4
Basic setup: OneZone, Oneprovider.
In this scenario you will deploy and configure OneZone and Oneprovider in your local, isolated environment.

In order to run it execute `run.sh --scenario 4` command.
###### Onezone Installation
Navigate to `https://172.30.0.1:9443` enter Onepanel credentials and proceed with the installation wizard.

###### Oneproviders Installation
Navigate to `https://172.30.1.1:9443` enter Onepanel credentials and proceed with the installation wizard.

##### Scenario 5
Complex setup: OneZone, with two single-node Oneproviders.
In this scenario you will deploy and configure OneZone and two single-node Oneproviders in your local, isolated environment.

In order to run it execute `run.sh --scenario 5` command.

###### Onezone Installation
Navigate to `https://172.30.0.1:9443` enter Onepanel credentials and proceed with the installation wizard.

###### Oneproviders Installation
Navigate to `https://172.30.1.1:9443` enter Onepanel credentials and proceed with the installation wizard.
Navigate to `https://172.30.2.1:9443` enter Onepanel credentials and proceed with the installation wizard.


##### Scenario 6
Complex setup: OneZone, with two multi-node Oneproviders clisters.
In this scenario you will deploy and configure OneZone and two multi-node Oneproviders in your local, isolated environment.

In order to run it execute `run.sh --scenario 6` command.

###### Onezone Installation
Navigate to `https://172.30.0.1:9443` enter Onepanel credentials and proceed with the installation wizard.

###### Oneproviders Installation
Navigate to `https://172.30.1.1:9443` enter Onepanel credentials and proceed with the installation wizard. You should see to nodes being detected. You can select each node role. For example: first node CM and worker, second CM and Database.
Navigate to `https://172.30.2.1:9443` enter Onepanel credentials and proceed with the installation wizard. You should see to nodes being detected. You can select each node role. For example: first node CM and worker, second CM and Database.
