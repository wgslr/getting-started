# Onedata Quickstart Scenarios

This page presents you with few scenarios for quickly and easily getting started with Onedata. 
Scenarios vary in complexity: beginning with simple, preconfigured demos; ending with highly advanced multi-cluster setups.


Scanarion designed to run on localhost or a single virtual machine:

- `1.0`: pre-configured oneprovider that connects to onedata.org (public ip required) <br \>
    `scenarios/1_0_oneprovider_onedata_org/`
- `2.0`: pre-configured oneprovider with pre-configured onezone <br \>
    `scenarios/2_0_oneprovider_onezone/`
- `3.0`: oneprovider with onezone ready to be configured with onepanel <br \>
    `scenarios/3_0_oneprovider_onezone_onepanel/`

Scenarios designed to run on multiple machines:

- `3.1`: oneprovider with onezone on reparate machines, ready to be configured with onepanel <br \>
    `scenarios/3_1_oneprovider_onezone_onepanel_multihost/`

If you are new to onedata please start with scenario 2.0. 

## Prerequisites

1. All scenarios are prepared as docker-compose configurations.
2. Depending on the scenario you might need to create an account on onedata.org.

`docker => 1.11` <br \>
`docker-compose => 1.7`

## Setup

For each scenario navigate to a scenario directory and `run_onedata.sh` script from there.
Onedata services depend on each other. Respect the order of running services and always wait for a message confirming that the service has successfully started.

`run_onedata.sh` runs in a foreground. To run more complex scenarios, you will need multiple terminal widnows.
### Scenario 1.0

Requires a machine with a public ip address and a number of open ports (refer to docker-compose configuration files) to communicate with `onedata.org.`

```bash
./run_onedata.sh --oneprovider
```

### Scenario 2.0

```bash
./run_onedata.sh --onezone     # In 1st terminal window
./run_onedata.sh --oneprovider # In 2nd terminal window
```

### Scenario 3.0

```bash
./run_onedata.sh --onezone      # In 1st terminal window
./run_onedata.sh --oneprovider  # In 2nd terminal window
```

Use Onepanel to configure Onezone and Oneprovider.

## Configuration

### Fixing HTTPS and Open-id authorization

In order for those scenarios to work properly you need to modify your local (pc from where you use your web browser) `/etc/hosts` file and append lines:

```
# Onedata configuration
<onezone_node_1_ip>      onedata.example.com # (required by OpenID)
<onezone_node_1_ip>      node1.onezone.onedata.example.com
<oneprovider_node_1_ip>  node1.oneprovider.onedata.example.com
```

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
