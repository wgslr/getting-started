# Onedata Quickstart Scenarios

This page presents you with few scenarios for quickly and easily getting started with Onedata. 
Scenarios vary in complexity: beginning with simple, preconfigured demos; ending with highly advanced multi-cluster setups.

Scanarion designed to run on localhost or a single virtual machine:

- [1.0](#s10): pre-configured oneprovider that connects to onedata.org (public ip required) <br \>
    [scenarios/1_0_oneprovider_onedata_org/]
- [2.0](#s20): pre-configured oneprovider with pre-configured onezone <br \>
    [scenarios/2_0_oneprovider_onezone/]
- [2.1](#s30): oneprovider with onezone ready to be configured with onepanel <br \>
    [scenarios/3_0_oneprovider_onezone_onepanel/]

Scenarios designed to run on multiple machines:

- [3.1](#s31): oneprovider with onezone on reparate machines, ready to be configured with onepanel <br \>
    [scenarios/3_1_oneprovider_onezone_onepanel_multihost/]

If you are new to onedata please start with scenario 2.0. 

## Prerequisites

1. All scenarios are prepared as docker-compose configurations.
2. Depending on the scenario you might need to create an account on onedata.org.

`docker => 1.11` <br \>
`docker-compose => 1.7`


## Setup

For each scenario navigate to a scenario directory and `run_onedata.sh` script from there.
Onedata services depend on each other. Respect the order of running services and always wait for a message confirming that the service has successfully started.

`run_onedata.sh` runs in a foreground. To run more complex scenarios, you will need multiple terminal widnows or terminal multiplexers such as [screen](https://www.gnu.org/software/screen/manual/screen.html) or [tmux](https://tmux.github.io/).

<a href="#s10">
### Scenario 1.0

In this scenario you will run a demo of single noded pre-configured oneprovider instance that will connect your oneprovider to [onedata.org] zone. All the configuration is placed in the `docker-compose-oneprovider.yml` file and oneprovider will be automaticaly installed according to it.

You will require a machine with a public ip address and a number of [open ports](#ports) (refer to docker-compose configuration files) to communicate with [onedata.org].

In order to setup and run your provider you just need to run:

```bash
./run_onedata.sh --oneprovider
```

Now that your provider is setup you can login into via web interface using `https://<your virtual machine ip>:9443`. For further instructions on using oneprovider refer to documentation on [onedata.org].

<a href="#s20">
### Scenario 2.0

In this scenario you will run a demo of fully functional isolated onedata installation that will consist of:
- a single noded pre-configured onezone instance
- a single noded pre-configured oneprovider instance

All the configuration is placed in the `docker-compose-oneprovider.yml` and `docker-compose-onezone.yml` files respectively. Oneprovider and onezone will be automaticaly installed according to it.

This scenario assumes that both docker containers running onezone and oneprovider will be running on the same machine, hence there is no need for public ip address nor you need to open any ports.

To access those services you will need to able to reach those containers form docker's private nettwork. If you run this on your laptop/workstation then its as straightforward as copying a container's address to your web browsher. However if you run them on remote VM (and you probably do) you will need to be able to access those ports from your laptop/workstation. We prepared few [suggestions](docker-remote.md) how to reach them.

In order to setup and run your provider you just need to run:

```bash
./run_onedata.sh --onezone     # In 1st terminal window
./run_onedata.sh --oneprovider # In 2nd terminal window
```

Onedata uses `OpenID` to authenticate with users. In order to be able to login into onedata you need to add few entries in `/etc/hosts` file your laptop/workstation (a computer where our web browsher is running). Detailed instructions are [here](#etchosts).

Now that your onezone and oneprovider are setup you can login them by navigating to:
```
# To access onedata:
https://onedata.example.com 

# To access Onepanel managment portal
https://<onezone docker container ip>:9443 # 
https://<oneprovider docker container ip>:9443 # 
```

into via web interface using  For further instructions refer to documentation on [onedata.org].

<a href="#s30">
### Scenario 2.1

In this scenario you will run a demo of fully functional isolated onedata installation that will consist of:
- a single noded onezone instance
- a single noded oneprovider instance

This scenario is similar to scenario 2.0. You are adviced to try complete scenario 2.0 before continuing. The only difference is that we did not provide example configuration. So after executing those commads:

```bash
./run_onedata.sh --onezone      # In 1st terminal window
./run_onedata.sh --oneprovider  # In 2nd terminal window
```

You will need to use Onepanle to setup onezone and oneprovider. You can do that using by accessing Onepanle with:

```
# To access Onepanel managment portal
https://<onezone docker container ip>:9443 # 
https://<oneprovider docker container ip>:9443 # 
```

<a href="#s30">
### Scenario 3.0

In this scenario you will run a demo of fully functional isolated onedata installation that will consist of:
- a single noded onezone instance
- a single noded oneprovider instance

However compared to scenarios 2.*, each service will run on differet machine. You need to make sure that [those ports](#[ports]) are accessible between those machines.

```bash
./run_onedata.sh --onezone      # On first machine
./run_onedata.sh --oneprovider --onezone_ip <ip of virtual machine running onezone>  # On second machine
```

After you have both containers running setup both services using Onepanel:

```
# To access Onepanel managment portal
https://<machine with onezone>:9443 # 
https://<machine with oneprovider>:9443 # 
```

After setup you will need to modify `/etc/hosts` file on your workstation (a computer where our web browsher is running) according to [that](#ecthosts).

Now you will be able to access you onedata installation using:
```
https://onedata.example.com 
```
address.

<a href="#configuration">
## Configuration Tips

<a href="#ports">
### Opening Ports
If you want (usually you do) your oneprovider/onezone to communicate with any onedata service that is located outside your localhost, you need to open a number of ports:

```
53
80
443
5555
8443
8876
8877
9443
```

and make sure that there are no intermedite firewalls blockign those ports between machines running your onedata services.

<a href="#etchosts">
### Fixing HTTPS and Open-id authorization

In order for those scenarios to work properly you need to modify your local (pc from where you use your web browser) `/etc/hosts` file and append lines:

```
# Onedata configuration
<onezone_node_1_ip>      onedata.example.com # (required by OpenID)
<onezone_node_1_ip>      node1.onezone.onedata.example.com
<oneprovider_node_1_ip>  node1.oneprovider.onedata.example.com
```

<a href="#onepanel">
### Configuring Onezone and Oneprovider with Onepanel

Onezone and Oneprovider offer a web based configuration panel Onepanel that can be accessed via: 

```
https://node1.onezone.onedata.example.com:9443 # for onezone
https://node1.oneprovider.onedata.example.com:9443 # for oneprovider
```
In each scenario the credentials needed to login into Onepanel are:

```
user: admin
password: password
```

<a href="#using">
## Using Onedata
In each scenario you will deploy a Oneprovider which can be used to support your space. If you are not familiar with the concept of Spaces read the Overview and Space support sections in the [documentation](https://onedata.org/documentation). After supporting you space you will be able to access them using a web-interface or Oneclient.

#### With Web-interface
Refer to the documentation of web-iterface for further instructions.

#### With Oneclient
In `oneclient` directory you will find `run-oneclient.sh` script that will assist you in using oneclient binary as a docker container. 

Example invocation:

```bash
./run-oneclient.sh --provider node1.onezone.onedata.example.com --token '_Us_MYaSD80YgPpcKfVSLP-Mz3TIqmN1q1vb3qFJ'
```

For more information on oneclient refer to Onedata  [documentation](https://onedata.org/documentation).
