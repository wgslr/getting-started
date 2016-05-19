# Onedata Quickstart Scenarios

This page presents you with few scenarios for quickly and easily getting started with Onedata. 
Scenarios vary in complexity: beginning with simple, preconfigured demos; ending with highly advanced multi-cluster setups.

We plan to add more scenarios in the future, if you can't find a scenario that interests you please visit our support [channel](onedata.org/support).

Scenarios are divided into 2 groups:

Entry level scenarios designed to run on localhost or a single virtual machine:

- [1.0](#s10): pre-configured oneprovider that connects to onedata.org (public ip required) <br \>
    [scenarios/1_0_oneprovider_onedata_org/](scenarios/1_0_oneprovider_onedata_org/)
- [2.0](#s20): pre-configured oneprovider with pre-configured onezone <br \>
    [scenarios/2_0_oneprovider_onezone/](scenarios/2_0_oneprovider_onezone/)
- [2.1](#s21): oneprovider with onezone ready to be configured with onepanel <br \>
    [scenarios/3_0_oneprovider_onezone_onepanel/](scenarios/3_0_oneprovider_onezone_onepanel/)

Advanced scenarios designed to run on multiple machines:

- [3.0](#s30): oneprovider with onezone on repartee machines, ready to be configured with onepanel <br \>
    [scenarios/3_1_oneprovider_onezone_onepanel_multihost/](scenarios/3_1_oneprovider_onezone_onepanel_multihost/)

If you are new to onedata please start with scenario 2.0. 

## Prerequisites

1. All scenarios are prepared as docker-compose configurations.
2. Depending on the scenario you might need to create an account on onedata.org.

`docker => 1.11` <br \>
`docker-compose => 1.7`

## Setup

For each scenario navigate to a scenario directory and `run_onedata.sh` script from there.
Onedata services depend on each other. Respect the order of running services and always wait for a message confirming that the service has successfully started.

`run_onedata.sh` runs in a foreground. To run more complex scenarios, you will need multiple terminal windows or terminal multiplexers such as [screen](https://www.gnu.org/software/screen/manual/screen.html) or [tmux](https://tmux.github.io/).

After completing each scenario, you are encouraged to test your installation according to [these instructions](#testing).

## Scenarios
<a name="s10"></a>
### Scenario 1.0

In this scenario you will run a demo of single nodded pre-configured oneprovider instance that will connect your oneprovider to [onedata.org](onedata.org) zone. All the configuration is placed in the `docker-compose-oneprovider.yml` file and oneprovider will be automatically installed according to it.

You will require a machine with a public ip address and a number of [open ports](#ports) to communicate with [onedata.org](onedata.org).

In order to setup and run your provider you just need to run:

```bash
./run_onedata.sh --oneprovider
```

Now that your provider is setup you can login via web interface using: 

```
https://<your virtual machine ip>:9443
```

For further instructions on using oneprovider refer to documentation on [onedata.org](onedata.org).

<a name="s20"></a>
### Scenario 2.0

In this scenario you will run a demo of fully functional isolated onedata installation that will consist of:

- a single nodded pre-configured onezone instance
- a single nodded pre-configured oneprovider instance

All the configuration is placed in the `docker-compose-oneprovider.yml` and `docker-compose-onezone.yml` files respectively. Oneprovider and onezone will be automatically installed according to it.

This scenario assumes that both docker containers: one with onezone and the other with oneprovider will be running on the same machine, hence there is no need for public ip address nor you need to open any ports.

To access those services, you will need to able to reach those containers form docker's private network. If you run this on your laptop/workstation then its as straightforward as copying a container's address to your web browser. However, if you run them on remote VM (and you probably do) you will need to be able to access those ports from your laptop/workstation. We prepared few [suggestions](docker-remote.md) how you can reach them.

In order to setup and run your provider you just need to run:

```bash
./run_onedata.sh --onezone     # In 1st terminal window
./run_onedata.sh --oneprovider # In 2nd terminal window
```

Onedata uses `OpenID` to authenticate with users. In order to be able to login into onedata you need to add few entries in `/etc/hosts`. Please refer to this [section](#ecthosts).

After fixing `/etc/hosts` you can access you onedata services with specified domain names. Detailed information on accessing and using onedata services can be found [here](#accessing).

<a name="s21"></a>
### Scenario 2.1

In this scenario you will run a demo of fully functional isolated onedata installation that will consist of:
- a single nodded onezone instance
- a single nodded oneprovider instance

This scenario is similar to scenario 2.0. You are advice to try complete scenario 2.0 before continuing. The only difference is that we did not provide example configuration. So after executing those commands:

```bash
./run_onedata.sh --onezone      # In 1st terminal window
./run_onedata.sh --oneprovider  # In 2nd terminal window
```

You will need to use Onepanle to setup onezone and oneprovider. You can do that by accessing Onepanle as instructed [here](#onepanel).

After that you need to add `/etc/hosts` entries on your workstation. See detailed [instructions](#etchosts).

You will be able to access onedata services as described [here](#accessing).

<a name="s30"></a>
### Scenario 3.0

In this scenario you will run a demo of fully functional isolated onedata installation that will consist of:
- a single nodded onezone instance
- a single nodded oneprovider instance

However, compared to scenarios 2.*, each service will run on differed machine. You need to make sure that [those ports](#[ports]) are accessible between those machines.

To run onezone and oneprovider execute:

```bash
./run_onedata.sh --onezone      # On first machine
./run_onedata.sh --oneprovider --onezone_ip <ip of virtual machine running onezone>  # On second machine
```

After you have both containers running:

- setup both services using Onepanel as described [here](#onepanel),
- add entries to `/etc/hosts` as instructed [here][#etchosts],
- read about accessing onedata services [here](#accessing). 


<a name="configuration"></a>
## Configuration Tips

<a name="ports"></a>
### Opening Ports
If you want (usually you do) your oneprovider/onezone to communicate with any onedata service that is located outside your localhost, you need to open a number of ports:

```
53
53/udp
80
443
5555
5556
6665
6666
8443
8876
8877
9443
```

and make sure that there are no intermediate firewalls blocking those ports between machines running your onedata services.

<a name="etchosts"></a>
### Fixing HTTPS and Open-id authorization

Onedata uses *OpenID* to authenticate with users. For there scenarios we prepared and registered OpenID setups for domain `onedata.example.com`. However, if you plan at some point to run onedata in production mode, you will need to register your own domain with OpenID providers. 

Because of how OpenID works in order to be able to login into your isolated onedata installation you need to add few entries in `/etc/hosts` file your laptop/workstation (a computer where your web browser is running):

```
# Onedata configuration
<onezone_node_1_ip>      onedata.example.com # (required by OpenID)
<onezone_node_1_ip>      node1.onezone.onedata.example.com
<oneprovider_node_1_ip>  node1.oneprovider.onedata.example.com
```

Depending on scenario these will be either private addressed of docker containers (where you have more then one onedata service running on a single machine) or addresses of machines where onedata services are running.

<a name="onepanel"></a>
### Configuring Onezone and Oneprovider with Onepanel

Onezone and Oneprovider offer a web based configuration panel Onepanel that can be accessed via: 

```
https://<onezone machine or container ip>:9443 # for onezone
https://<oneprovider machine or container ip>:9443 # for oneprovider
```

In each scenario the credentials needed to login into Onepanel are:

```
user: admin
password: password
```

<a name="accessing"></a>
### Accessing Onedata Services
After you have setup onedata you can access (depending on the scenario) you will have access to:

Onezone Portal

```
https://onedata.example.com 
```

Onezone Onepanel management interface:

```
https://onedata.example.com:9443 # OR
https://<onezone machine or container ip>:9443
```

Oneprovider Onepanel management interface:

```
https://node1.oneprovider.onedata.example.com:9443 # OR
https://<oneprovider machine or container ip>:9443
```

<a name="accessing"></a>
### Testing your installation
TOOD

<a name="using"></a>
## Using Onedata

In each scenario you will deploy a Oneprovider which can be used to support your space. If you are not familiar with the concept of Spaces read the Overview and Space support sections in the [documentation](https://onedata.org/documentation). After supporting you space you will be able to access them using a web-interface or Oneclient.

#### With Web-interface
Refer to the documentation of web-interface for further instructions.

#### With Oneclient
In `oneclient` directory you will find `run-oneclient.sh` script that will assist you in using oneclient binary as a docker container. 

Example invocation:

```bash
./run-oneclient.sh --provider node1.onezone.onedata.example.com --token '_Us_MYaSD80YgPpcKfVSLP-Mz3TIqmN1q1vb3qFJ'
```

For more information on oneclient refer to Onedata  [documentation](https://onedata.org/documentation).

