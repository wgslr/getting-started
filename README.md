# Onedata Quickstart Scenarios

This repository contains a few scenarios for quickly and easily getting started with administration and management of Onedata distributed data management platform. If you're new to Onedata please have a look at the introductory information in our [documentation](https://beta.onedata.org/docs/doc/getting_started/what_is_onedata.html).

Scenarios vary in complexity: beginning with simple, preconfigured demos and ending with highly advanced multi-cluster setups. The scenarios are implemented using preconfigured Docker images, and can be quickly deployed and tested.

We plan to add more scenarios in the future, if you can't find a scenario that addresses your specific requirements or use case please visit our support [channel](https://beta.onedata.org/support).

Scenarios are divided into 2 groups:

###Entry level scenarios designed to run on `localhost` or a single virtual machine:

- [1.0](#s10): pre-configured Oneprovider that connects to [onedata.org](https://beta.onedata.org) zone (public ip required) <br \>
    **Sources:** [scenarios/1_0_oneprovider_onedata_org/](scenarios/1_0_oneprovider_onedata_org/)
- [2.0](#s20): pre-configured Oneprovider with pre-configured Onezone <br \>
    **Sources:** [scenarios/2_0_oneprovider_onezone/](scenarios/2_0_oneprovider_onezone/)
- [2.1](#s21): Oneprovider with Onezone ready to be configured with Onepanel <br \>
    **Sources:** [scenarios/2_1_oneprovider_onezone_onepanel/](scenarios/2_1_oneprovider_onezone_onepanel/)

###Advanced scenarios designed to run on multiple machines:

- [3.0](#s30): Oneprovider with Onezone on repartee machines, ready to be configured with onepanel <br \>
    **Sources:** [scenarios/3_0_oneprovider_onezone_onepanel_multihost/](scenarios/3_0_oneprovider_onezone_onepanel_multihost/)

If you are new to Onedata please start with scenario 2.0. 

## Prerequisites

1. All scenarios are prepared as Docker Compose configurations.

    ```
    docker => 1.11
    docker-compose => 1.7
    ```
2. Depending on the scenario, you might need to create an account on [onedata.org](https://beta.onedata.org).

## Setup

For each scenario navigate to a scenario directory and execute `./run_onedata.sh` script from there.
Onedata services depend on each other. Maintain the order of starting up services and always wait for a message confirming that the service has successfully started.

`run_onedata.sh` script runs in foreground. To run more complex scenarios, you will need multiple terminal windows or terminal multiplexers such as [screen](https://www.gnu.org/software/screen/manual/screen.html) or [tmux](https://tmux.github.io/).

After completing each scenario, you are encouraged to test your installation according to [these instructions](#testing).

## Scenarios
<a name="s10"></a>
### Scenario 1.0

In this scenario you will run a demo of single node pre-configured Oneprovider instance that will register at [onedata.org](https://beta.onedata.org) zone. All the configuration is stored in the [docker-compose-oneprovider.yml](scenarios/1_0_oneprovider_onedata_org/docker-compose-oneprovider.yml) file and Oneprovider will be automatically installed based on these settings.

You will require a machine with a public IP address and a number of [open ports](#ports) to communicate with [onedata.org](https://beta.onedata.org).

You need to replace a line in [docker-compose-oneprovider.yml](scenarios/1_0_oneprovider_onedata_org/docker-compose-oneprovider.yml) with public IP of your machine or hostname so that Onezone at [onedata.org](https://beta.onedata.org) knows how to reach your provider:
```
redirection_point: "https://90.147.170.174" # Change to IP or hostname of your machine!
```

In order to setup and deploy your Oneprovider simply run:

```bash
./run_onedata.sh --oneprovider
```

Now that after Oneprovider is up, you can check it's administration panel at: 

```
https://<your virtual machine ip>:9443
```

Now you can test you installation by following [these](#testing) instructions.
For further instructions on using Oneprovider refer to documentation on [onedata.org](https://beta.onedata.org).

<a name="s20"></a>
### Scenario 2.0

In this scenario you will run a demo of a fully functional, isolated Onedata deployment that will consist of:
- a single node pre-configured Onezone instance
- a single node pre-configured Oneprovider instance
both running on a single machine.

All the configuration is placed in the [docker-compose-oneprovider.yml](scenarios/2_0_oneprovider_onezone/docker-compose-oneprovider.yml) and [docker-compose-onezone.yml](scenarios/2_0_oneprovider_onezone/docker-compose-onezone.yml) files respectively. Oneprovider and Onezone will be automatically installed based on these configuration files.

This scenario assumes that both Docker containers: one with Onezone and the other with Oneprovider will be running on the same machine, thus there is no need for public IP address nor you need to open any ports.

To access those services, you will need to able to reach those containers from Docker's private network. If you run this on your laptop/workstation then its as straightforward as copying a container's address to your web browser. However, if you run them on remote VM you will need to be able to access those ports from your laptop/workstation. We prepared few [suggestions](docker-remote.md) how you can reach them.

In order to setup and run your Onedata deployment run:
```bash
./run_onedata.sh --onezone     # In 1st terminal window
./run_onedata.sh --oneprovider # In 2nd terminal window
```

Currently, Onedata supports only **OpenID** protocol to authenticate users. In order for authentication to work on an isolated machine, you need to add few entries in `/etc/hosts`. Please refer to this [section](#ecthosts).

After fixing `/etc/hosts` you can access you Onedata services with specified domain names. Detailed information on accessing and using Onedata services can be found [here](#accessing).

<a name="s21"></a>
### Scenario 2.1

In this scenario you will run a demo of fully functional isolated onedata installation that will consist of:
- a single nodded onezone instance
- a single nodded oneprovider instance

both running on a single machine.

This scenario is similar to scenario 2.0. You are adviced to try complete scenario 2.0 before continuing. The only difference is that we did not provide example configuration. So after executing those commands:

```bash
./run_onedata.sh --onezone      # In 1st terminal window
./run_onedata.sh --oneprovider  # In 2nd terminal window
```

You will need to use Onedata web administration tool - Onepanel - to setup Onezone and Oneprovider. You can do that by accessing Onepanel as explained [here](#onepanel).

Currently, Onedata supports only **OpenID** protocol to authenticate users. In order for authentication to work on an isolated machine, you need to add few entries in `/etc/hosts`. Please refer to this [section](#ecthosts).

You will be able to access Onedata services as described [here](#accessing).

<a name="s30"></a>
### Scenario 3.0

In this scenario you will run a demo of a fully functional isolated onedata deployment that will consist of:
- a single node Onezone instance
- a single node Oneprovider instance

both running on a different machines.

You need to make sure that [those ports](#[ports]) are accessible between those machines.

To run Onezone and Oneprovider execute:

```bash
./run_onedata.sh --onezone      # On first machine
./run_onedata.sh --oneprovider --onezone_ip <ip of virtual machine running onezone>  # On second machine
```

After you have both containers running:
- setup both services using Onepanel as described [here](#onepanel),
- add entries to `/etc/hosts` as instructed [here](#etchosts),
- read about accessing Onedata services [here](#accessing). 

<a name="configuration"></a>
## Configuration Tips

<a name="ports"></a>
### Opening Ports
If you want (usually you do) your Oneprovider/Onezone to communicate with any Onedata service that is located outside your `localhost`, you need to open a number of ports:

 Port    | Description                         
---------|-------
 53      | dns
 53/udp  | dns
 80      | http web access
 443     | https web access
 5555    | oneclient
 5556    | intra-provider communication
 6665-6666    | rtransfer protocol
 7443 | metadata zone to provider transfer
 8443    | REST (CDMI + custom API)
 8876-8877   | gateway for rtransfera protocol
 9443    | onepanel web interfacr

and make sure that there are no intermediate firewalls blocking those ports between machines running your Onedata services.

<a name="etchosts"></a>
### Fixing HTTPS and OpenID authorization

Onedata uses *OpenID* to authenticate with users. For these scenarios we prepared and registered OpenID setups for domain `onedata.example.com`. However, if you plan at some point to run a complete Onedata deployment, independent of [onedata.org](https://beta.onedata.org), you will need to register your own domain with OpenID providers. 

Because of how OpenID works, in order to be able to login into your isolated Onedata installation you need to add few entries in `/etc/hosts` file your laptop/workstation (a computer where your web browser is running):

```
# Onedata configuration
<onezone_node_1_ip>      onedata.example.com # (required by OpenID)
<onezone_node_1_ip>      node1.onezone.onedata.example.com
<oneprovider_node_1_ip>  node1.oneprovider.onedata.example.com
```

Depending on scenario these will be either private addresses of Docker containers (where you have multiple Onedata services running on a single machine) or addresses of machines where Onedata services are running.

<a name="onepanel"></a>
### Configuring Onezone and Oneprovider with Onepanel

Onezone and Oneprovider offer a web based configuration panel Onepanel that can be accessed via: 

```
https://<onezone machine or container ip>:9443 # for onezone
https://<oneprovider machine or container ip>:9443 # for oneprovider
```

In each scenario, the credentials needed to login into Onepanel are the same:

```
user: admin
password: password
```

<a name="accessing"></a>
### Accessing Onedata Services
After you have setup Onedata you can access (depending on the scenario) you will have access to:

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

<a name="testing"></a>
### Testing your installation
The basic test of your installatin involves:

1. [loging into Onezone](https://beta.onedata.org/docs/doc/getting_started/user_onedata_101.html)
2. getting Space Support token for your home space 
3. loging into Oneprovider managment interface, see [accessing onedata services](#accessing)
4. using a token to support your home space, see [space support](https://beta.onedata.org/docs/doc/administering_onedata/provider_space_support.html)
5. accessing your space in Onezone
6. uploading a file to your space

For more detailed description on, how to performs those steps please refer to official [documentation](https://beta.onedata.org/docs/index.html).


<a name="cleaning"></a>
### Cleaning your installation
TODO

<a name="using"></a>
## Using Onedata

In each scenario you will deploy a Oneprovider which can be used to support your space. If you are not familiar with the concept of Spaces read the Overview and Space support sections in the [documentation](https://https://beta.onedata.org/documentation). After supporting your space you will be able to access them using a web-interface or Oneclient.

#### With Web interface
Refer to the documentation of the web interface for further instructions.

#### With Oneclient
In [oneclient](oneclient) directory you will find [run_oneclient.sh](oneclient/run_oneclient.sh) script that will assist you in using Oneclient binary as a docker container. 

Example invocation:

```bash
./run_oneclient.sh --provider node1.onezone.onedata.example.com --token '_Us_MYaSD80YgPpcKfVSLP-Mz3TIqmN1q1vb3qFJ'
```

For more information on oneclient refer to Onedata  [documentation](https://beta.onedata.org/documentation).

