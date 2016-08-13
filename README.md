# Onedata Quickstart Scenarios

This repository contains a few scenarios for quickly and easily getting started with of Onedata distributed data management platform. The scenarios are intedned for administrators who want to get familiar with Onedata. If you're new to Onedata please have a look at the introductory information in our [documentation](https://onedata.org/docs/doc/getting_started/what_is_onedata.html).

Scenarios vary in complexity: beginning with simple, preconfigured demos and ending with highly advanced multi-cluster setups. The scenarios are implemented using preconfigured Docker images, and can be quickly deployed and tested.

We plan to add more scenarios in the future, if you can't find a scenario that addresses your specific requirements please visit our support [channel](https://onedata.org/support).

Scenarios are divided into 2 groups:

### Entry level scenarios designed to run on `localhost` or a single virtual machine:

- [1.0](#s10): pre-configured Oneprovider that connects to [beta.onedata.org](https://beta.onedata.org) zone (public ip required) <br \>
    **Sources:** [scenarios/1_0_oneprovider_onedata_org/](scenarios/1_0_oneprovider_onedata_org/)
- [2.0](#s20): pre-configured Oneprovider with pre-configured Onezone <br \>
    **Sources:** [scenarios/2_0_oneprovider_onezone/](scenarios/2_0_oneprovider_onezone/)
- [2.1](#s21): Oneprovider with Onezone ready to be configured with Onepanel <br \>
    **Sources:** [scenarios/2_1_oneprovider_onezone_onepanel/](scenarios/2_1_oneprovider_onezone_onepanel/)

### Advanced scenarios designed to run on multiple machines:

- [3.0](#s30): Oneprovider with Onezone on repartee machines, ready to be configured with onepanel <br \>
    **Sources:** [scenarios/3_0_oneprovider_onezone_onepanel_multihost/](scenarios/3_0_oneprovider_onezone_multihost/)

- [3.1](#s31): Oneprovider with Onezone on repartee machines, ready to be configured with onepanel <br \>
    **Sources:** [scenarios/3_0_oneprovider_onezone_onepanel_multihost/](scenarios/3_1_oneprovider_onezone_onepanel_multihost/)

If you are new to Onedata please start with scenario 2.0. 

## Prerequisites

1. All scenarios are prepared as Docker Compose configurations.

    ```
    docker => 1.11
    docker-compose => 1.7
    ```

2. Depending on the scenario, you might need to create an account on [beta.onedata.org](https://beta.onedata.org).

3. Most scenrios require that your machine has a public ip address assigned to it with a number of [open ports](#ports) open and/or registered domain name to configure working OpenId login and make https green. Only scenarios 2.0 and 2.1 are designed to work on localhost. 

## Setup

For each scenario navigate to a scenario directory and execute `./run_onedata.sh` script from there.
Onedata services depend on each other. Maintain the order of starting up services and always wait for a message confirming that the service has successfully started.

`run_onedata.sh` script runs in foreground. To run more complex scenarios, you will need multiple terminal windows or terminal multiplexer such as [screen](https://www.gnu.org/software/screen/manual/screen.html) or [tmux](https://tmux.github.io/).

After completing each scenario, you are encouraged to test your installation according to [these instructions](#testing).

## Scenarios
<a name="s10"></a>
### Scenario 1.0

In this scenario you will run a demo of single node pre-configured Oneprovider instance that will register at [beta.onedata.org](https://beta.onedata.org)zone. The configuration template is stored in the [docker-compose-oneprovider.yml](scenarios/1_0_oneprovider_onedata_org/docker-compose-oneprovider.yml) file and Oneprovider will be automatically installed based on these settings.

You will require a machine with a public IP address and a number of [open ports](#ports) to communicate with [beta.onedata.org](https://beta.onedata.org).

In order to setup and deploy your Oneprovider and connect it to [beta.onedata.org](https://beta.onedata.org) simply run:

```bash
./run_onedata.sh --provider --provider-fqdn <public ip or FQDN of your machine>
```

Now that after Oneprovider is up, you can check it's administration panel at: 

```
https://<public ip or FQDN of your machine>:9443
```

Now you can test you installation by following [these](#testing) instructions.
For further instructions on using Oneprovider refer to documentation on [beta.onedata.org](https://beta.onedata.org).

<a name="s20"></a>
### Scenario 2.0

In this scenario you will run a demo of a fully functional, isolated Onedata deployment that will consist of:
- a single node pre-configured Onezone instance
- a single node pre-configured Oneprovider instance

both running on a single machine.

The configuration templates are placed in the [docker-compose-oneprovider.yml](scenarios/2_0_oneprovider_onezone/docker-compose-oneprovider.yml) and [docker-compose-onezone.yml](scenarios/2_0_oneprovider_onezone/docker-compose-onezone.yml) files respectively. Oneprovider and Onezone will be automatically installed based on these configuration files.

This scenario assumes that both Docker containers: one with Onezone and the other with Oneprovider will be running on the same machine, thus there is no need for public IP address nor you need to open any ports.

To access those services, you will need to able to reach those containers from Docker's private network. If you run this on your laptop/workstation then its as straightforward as copying a container's address to your web browser. However, if you run them on remote VM you will need to be able to access those ports from your laptop/workstation. We prepared few [suggestions](docker-remote.md) how you can reach them.

In order to setup and run your Onedata deployment run:

```bash
./run_onedata.sh --onezone     # In 1st terminal window
./run_onedata.sh --oneprovider # In 2nd terminal window
```

The installation output will provide you with Docker container ip addresses for Onezone and Oneprovider. Detailed information on accessing and using Onedata services can be found [here](#accessing). In order to test your installation please follow [these](#testing) instrcutions.

<!--
Currently, Onedata supports only **OpenID** protocol to authenticate users. In order for authentication to work on an isolated machine, you need to add few entries in `/etc/hosts`. Please refer to this [section](#ecthosts).
-->

<a name="s21"></a>
### Scenario 2.1

In this scenario you will run a demo of fully functional isolated onedata installation that will consist of:
- a single nodded onezone instance
- a single nodded oneprovider instance

both running on a single machine.

This scenario is similar to scenario 2.0. You are adviced to try complete scenario 2.0 before continuing. The only difference is that we did not provide template configuration. So after executing those commands:

```bash
./run_onedata.sh --onezone      # In 1st terminal window
./run_onedata.sh --oneprovider  # In 2nd terminal window
```

You will need to use Onedata web administration tool - Onepanel - to setup Onezone and Oneprovider. You can do that by accessing Onepanel as explained [here](#onepanel).

<!--
You will be able to access Onedata services as described [here](#accessing).
-->

<a name="s30"></a>
### Scenario 3.0

In this scenario you will run a demo of a fully functional isolated onedata deployment that will consist of:
- a single node Onezone instance
- a single node Oneprovider instance

both running on a different machines.


The configuration templates are placed in the [docker-compose-oneprovider.yml](scenarios/3_0_oneprovider_onezone/docker-compose-oneprovider.yml) and [docker-compose-onezone.yml](scenarios/3_0_oneprovider_onezone/docker-compose-onezone.yml) files respectively. Oneprovider and Onezone will be automatically installed based on these configuration files.

You need to make sure that [those ports](#[ports]) are accessible between these machines.

To run Onezone and Oneprovider execute:

```bash
./run_onedata.sh --zone      # On first machine
./run_onedata.sh --provider --provider-fqdn <public ip or FQDN of your machine running provider> --zone-fqdn <public ip or FQDN of your machine running zone>  # On second machine
```

Detailed information on accessing and using Onedata services can be found [here](#accessing). In order to test your installation please follow [these](#testing) instrcutions.

<a name="s31"></a>
### Scenario 3.1

In this scenario you will run a demo of a fully functional isolated onedata deployment that will consist of:
- a single node Onezone instance
- a single node Oneprovider instance

both running on a different machines.

You need to make sure that [those ports](#[ports]) are accessible between those machines.

This scenario is similar to scenario 3.0. You are adviced to try complete scenario 3.0 before continuing. The only difference is that we did not provide template configuration. So after executing those commands:

```bash
./run_onedata.sh --zone      # On first machine
./run_onedata.sh --provider  # On second machine
```

You will need to use Onedata web administration tool - Onepanel - to setup Onezone and Oneprovider. You can do that by accessing Onepanel as explained [here](#onepanel). 

Detailed information on accessing and using Onedata services can be found [here](#accessing). In order to test your installation please follow [these](#testing) instrcutions.

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

<a name="onepanel"></a>
### Configuring Onezone and Oneprovider with Onepanel

Onezone and Oneprovider offer a web based configuration and management web interface - Onepanel that can be accessed via: 

```
https://<onezone machine or container ip>:9443 # for onezone
https://<oneprovider machine or container ip>:9443 # for oneprovider
```

Onepanel plays important function in Oneprovider, as administrators can use it to support users spaces.

The default credentails for accessign onepanel are:

```
user: admin
password: password
```

<a name="accessing"></a>
### Accessing Onedata Services
After you have setup Onedata (depending on the scenario) you will have access to:

Oneprovider Onepanel management interface:

```
https://<ip or domain if your Oneprovider instnce>:9443
```

Onezone Onepanel management interface:

```
https://<ip or domain if your Onezone instnce>:9443
```

Onezone Portal

```
https://<ip or domain if your Onezone instnce>
```

Use a basic auth method to login into Onezone if you haven't configured [OpenID](#openid). The default credentials to Onezone and to Onepanel of Onezone and Oneprovider are:

```
user: admin
password: password
```

<a name="testing"></a>
### Testing your installation
The basic test of your installatin involves:

1. [loging into Onezone](https://onedata.org/docs/doc/getting_started/user_onedata_101.html)
2. getting Space Support token for your home space 
3. loging into Oneprovider managment interface, see [accessing onedata services](#accessing)
4. using a token to support your home space, see [space support](https://onedata.org/docs/doc/administering_onedata/provider_space_support.html)
5. accessing your space in Onezone
6. uploading a file to your space

For more detailed description on, how to performs those steps please refer to official [documentation](https://onedata.org/docs/index.html).

<a name="openid"></a>
### Fixing HTTPS and OpenID authorization

Onedata uses *OpenID* to authenticate with users. However to use that feature you need to:
- register your own domain, see a [short guide](#tkdomain)
- register this domain with *OpenID* providers supported by Onedata, see [short guide](#openid_register)

From every *OpenID* provider you will get a pair of `(app_id, app_secret)`. We prepared an [example config](bin/config/auth.conf.example) for you, where you need to replace those values. 

After creating your onw `auth.conf` file you need to add a line in `volumes` section in your `docker-compose-onezone.yml`. Here is en example:

```
services:
  node1.onezone.localhost:
    image: onedata/onezone:some_version
    hostname: node1.onezone.localhost
    volumes:
        - "<absolute path to your auth.config>:/volumes/persistency/var/lib/oz_worker/auth.config" # this line was added
        - "${ONEZONE_CONFIG_DIR}:/volumes/persistency"
        - "/var/run/docker.sock:/var/run/docker.sock"
```

After that you can navigate to a domain you registered for you Onezone instance and login with *OpenID* providers you registered your domain with.


<a name="customize"></a>
### Customizing your installation

#### Customizing data and config directories locations
In all scenarios Onezoe and Oneprovier services typicaly have two docker volumes exported mounted to host filesystem.

- `/volumes/persistency` - where configuration is stored
- `/volumes/storage` - where Oneprovider stores users' data

Above directorries are present in docker container and are by default mounted under paths:
- `./config_onezone` for Onezone configuration 
- `./config_oneprovider`for Oneprovider configuration 
- `./oneprovider_data` for Oneprovider users' data 

You can modify them directly in docker-compose files or by using a special flags of `onedata_run.sh`
- `--provider-data-dir` to set directory where provider will store users raw data
- `--provider-conf-dir` to set a directory where provider will configuration its files
 
Additionaly we provider a `--set-lat-log` that tries to deduce the lattitude and longtitude of you machine. Those coordinates are used in Onezoen to display your provider on a world map. This flag works with all scenarios except those that use Onepanel for installation process (2.1 and 3.1).

Example do advance setup of Oneprovider:

```bash
onedata_run.sh  --oneprovider --provider-fqdn 'myonedataprovider.tk' --zone-fqdn 'myonezone.tk' --provider-data-dir '/mnt/super_fast_big_storage/' --provider-conf-dir '/etc/oneprovider/' --set-lat-log
```

#### Customizing domain of your service
In all scenarios and well as in internals of `onedata_run.sh` script we use a domain `onedata.example.com`. If you would like to change it, you do not need to modify the `docker-compose-*.yml` files.

Ignore the fact that Onezone and Oneprovider are started using domain `onedata.example.com`. After they are started edit the /etc/hosts file on your VM to map IP of the docker container where Oneprovider or Onezone are running to the domain of your choosing. Example

```bash
# $ cat /etc/hosts
127.0.0.1	localhost
<ip_of_onezone_container> onezone.ki.agh.edu.pl
```

Next you need to pair the VM ip address with domain name `onezone.ki.agh.edu.pl`. That's all. 

<a name="cleaning"></a>
### Cleaning your installation
Onezone and Oneprovider use mount two docker volumes on the host machine. In order to clear your installation (eg. after faild atempt to start the service) you need to remove all contant of those volumes. If you did not alter `docker-compose-*.yml` files this can be done with:

```bash
sudo run_onedata.sh --clean # Docker changes ownership of mounted directories to root, that's why you need use sudo or to run it as a root
```

Also make sure that you have no dandling Onedata containers in your Docker Engine. You can check that using:

```bash
docker ps -a
```

<a name="using"></a>
## Using Onedata

In each scenario you will deploy a Oneprovider which can be used to support your space. If you are not familiar with the concept of Spaces read the Overview and Space support sections in the [documentation](https://https://onedata.org/documentation). After supporting your space you will be able to access them using a web-interface or Oneclient.

#### With Web interface
Refer to the documentation of the web interface for further instructions.

#### With Oneclient
In [oneclient](oneclient) directory you will find [run_oneclient.sh](oneclient/run_oneclient.sh) script that will assist you in using Oneclient binary as a docker container. 

Example invocation:

```bash
./run_oneclient.sh --provider node1.onezone.onedata.example.com --token '_Us_MYaSD80YgPpcKfVSLP-Mz3TIqmN1q1vb3qFJ'
```

For more information on oneclient refer to Onedata  [documentation](https://onedata.org/documentation).

