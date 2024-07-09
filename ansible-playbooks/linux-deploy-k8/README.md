<h1> Deploy K8 cluster on linux systems</h1>

<h2>Overview</h2>

Running this script will initiate the downloaded ansible playbooks to deploy kubernetes on linux hosts.

<h2>Downloads</h2>

Get the script and its dependencies: <a href='https://gk-tools.s3.eu-central-1.amazonaws.com/public/ANSB/linux-deploy-k8-cluster.tar.gz' target="_blank">Download</a>

<h2>Prerequisites</h2>

The following items are all prerequisites for the script to execute properly

* A UNIX system with ansible installed to execute the main bash script for the deployment
* Logon access via SSH to the target hosts for the ansible user. Your users will need to be able to become root
* Your target hosts will need internet access to download any necessary content
* You will need all the ansible roled defined in the script. In case you need to download them again, you can find them
	<a href='https://gk-tools.s3.eu-central-1.amazonaws.com/public/ANSB/linux-deploy-k8-cluster.tar.gz' target="_blank">here</a>
* Your target system distributions will need to be either of the ones listd below. This is because for specific actions that are not entirely distribution agnostic, the playbooks have not been properly developed. You will be prompted with this list whenever you exexute an action that is limited to these distros. Supported distros:
	- Oracle Linux 8
	- Oracle Linux 9
	- RedHat 8
	- RedHat 9
	- Ubuntu 22
	- Amazon Linux 2023

<h2>Usage</h2>

Download and extract all components, navigate to the folder containing the script and the roles and execute the script providing the mandatory -r flag

```bash
wget https://gk-tools.s3.eu-central-1.amazonaws.com/public/ANSB/linux-deploy-k8-cluster.tar.gz
tar -xzf linux-deploy-k8-cluster.tar.gz
cd linux-deploy-k8-cluster
# Example: execute all roles by passing "all" to -r option
./00-linux-deploy-k8.sh -r all
```

The -r flag is mandatory and it specifies which actions you need to deploy on the target hosts.

Valid options are:

- os-bootstrap
- create-user
- install-kube
- init-cluster
- all

<h2>Role definition</h2>

<h4>os-bootstrap</h4>

Executes some basic OS bootstraping like setting the hostname and the timezone, modifying some ssh settings. You will be prompted if you want to patch the systems as well during the execution. Before executinmg this job, review its commands to make sure it doesn't mess with configuration in ways you don't want to. To execute:

```bash
./00-linux-deploy-k8.sh -r os-bootstrap
```

<h4>create-user</h4>

Creates a user in all of the target hosts with the purpose of administrating the cluster. Unless you manually modify the variables of the playbook, this user will have elevated access related only to kubernetes items and nothing else. To execute:

```bash
cd /path/to/directory
# Create the defined user on all hosts
./00-linux-deploy-k8.sh -r create-user
```

<h4>install-kube</h4>

Installs kubernetes and its dependencies based on the version you will be prompted to enter. Package locking is configured in order to avoid accidental updated of the related packages. To execute:

```bash
cd /path/to/directory
# Install kubernetes on all hosts
./00-linux-deploy-k8.sh -r install-kube
```

<h4>init-cluster</h4>

Inititializes the cluster having as a control node the host labeled as <u>controlNode1</u> and joins all of the worker nodes in the cluster. It also prompts for a user to populate the kube config to. This is helpful if you execute the playbooks one by one or if you need to execute this seperately because of an eralier failure that took place after the user creation. To execute:

```bash
cd /path/to/directory
# Initilize cluster
./00-linux-deploy-k8.sh -r init-cluster
```

<h4>all</h4>

Executes the above actions in the following sequence:

- os-bootstrap
- create-user
- install-kube
- init-cluster

To execute:

```bash
cd /path/to/directory
# Perform all actions
./00-linux-deploy-k8.sh -r all
```



<h2>Extra Options</h2>

<h4>Inventory file template</h4>

To create a template of the host inventory based on what is needed for the script to execute properly execute the following:

```bash
cd /path/to/directory
# Create template
./00-linux-deploy-k8.sh --create-inventory-template
```

This will create the file <u>01-hosts-ini</u> in the script's directory. This file is the default inventory file.


<h4>Skip review</h4>

Each time you execute the script, some basic user checks about the configuration of the environment and the inventory are executed. You can skip these checks by adding the <i>--skip-review</i> option **before** the <i>-r</i> flag. For example:

```bash
cd /path/to/directory
# Initialize the cluster without the initial user review
./00-linux-deploy-k8.sh --skip-review -r init-cluster
```

Initial checks will still be made to make sure that all the required elements are correctly set up.

<h4>Print usage and help</h4>

Print basic help by using the <i>-h</i> or <i>--help</i> flags. For example:

```bash
cd /path/to/directory
# Print basic help message
./00-linux-deploy-k8.sh --help
```