# Quickstart 3.0

> Zakladamy ze w dokumentacji na innej stronie sa wytlumaczone pojecia takie jak: onezone, oneprovider, oneclient.

> This page presents you with few scenarios for quickly and easily getting started with Onedata. Each scenario is composed of a set of detailed sep-by-step instructions and a script installs onedata services on your machine. All the scripts are aviable for download from github: https://github.com/onedata/quickstart

### Prerequesites 
1) All scenarios are prepared as docker images. A linux system with docker 1.9.1 or greater is required to run them. 
2) Depending on the scenarion you might need to create an account on onedata.org.

### Quickstart Scenarios

The proper installation of Onedata requirers one or more public ip addresses in order to properly communicate with onedata.org. Following scenarios are divided into two categories:
- those that does not require public ip addresses, but make it necessary to installation of all Onedata components
- those that require public ip addresses and allow does not require to install all the components.


#### With Public IP
Scenarios in this section require that machine(s) you deploy Onedata on have public ip addresses in order to properly communicated with onedata.org

##### Scenario 1
Pre-configured Oneprovider with Oneclient
Try Onedata hands on in a couple of minutes.

##### Scenario 2 
Oneprovider with Oneclient
Configure Oneprovider yourself and support your space.

#### Without Public IP

##### Scenario 3
Basic setup: OneZone, Oneprovider and Oneclient
Configure a complete Onedata deployment. 

##### Scenario 4
Complex setup: OneZone, with two single-node Oneproviders and Oneclient
Configure a complete Onedata deployment with two providers supportign your space.

##### Scenario 4
Complex setup: OneZone, with two multi-node Oneproviders clisters and Oneclient
Configure a complete Onedata deployment with two multi-node providers supportign your space.



> Zalozenia:
> User uruchamia to na localhoscie.

> This document intends to help users to get started with Onedata.
> It presents various scenarios of trying out Onedata begining with simple, preconfigured demos; ending with highly advanced multi-cluster setups.



Terminology:
- Oneclient (OC)
- Oneprovider with one worker, one cluster manager, one database (examples 3 noded  provider: OP[w=1,c=1,d=1], OP[w)
- Oneprovider installed in the container OP_R[...]
- Onezone - OZ
- Main Onedata OZ -OOZ



## Instllation and usage of Oneclient image
> Since Oneclient is present in all those cases, its installation and usage should be done separately.

```
docker run -it --privileged --entrypoint bash --link oz:onedata.org —-link op e PROVIDER_HOSTNAME=op docker.onedata.org/oneclient:3.0.0.alpha.16.g616480e
```

## Instllation and usage of Onepanel image


```
docker run -d --name op --hostname onedata.localhost.local --link oz:onedata.org docker.onedata.org/oneprovider:3.0.0.aplha.1.gbd15cdb
```

## Instllation and usage of One Zone image

```
docker run -d --name oz --hostname onedata.org docker.onedata.org/globalregistry:3.0.0.alpha.2.g69d0e5bz
```
 
