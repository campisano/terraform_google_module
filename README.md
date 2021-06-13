# Terraform minimalistic module for Google GCP

From [campisano.org/Gcp (Cloud)](http://www.campisano.org/wiki/en/Gcp_(Cloud)#Setup_a_new_f1-micro_machine_using_Terraform)

This project shows how to use a minimalistic Terraform module (configurable with a custom vars.json file) to create a [free-tier infrastructure](https://cloud.google.com/free/docs/gcp-free-tier) with a free Virtual Private Server (VPS) in the Google Cloud Platform (GCP).



Project Structure
-----------------

```
./
├── modules/google              (module for instance provision)
│   ├── input.ts                  (module input vars)
│   ├── main.ts                   (module resources)
│   └── output.ts                 (module output vars)
│
├── init_script.sh              (optional script to run at first boot)
├── input.ts                    (declare main input vars)
├── main.ts                     (main source file to setup resources)
├── output.ts                   (declare main output vars)
├── provider.tf                 (provider configs)
├── versions.tf                 (terraform versions configs)
├── Makefile                    (make file with a set of useful commands)
└── vars.json                   (json file to define custom variables)
```



Minimum System Requirements
---------------------------

* A GCP [account](https://cloud.google.com/), a [free account](https://cloud.google.com/free) can be used.

* Note: the free tier has [strict limits](https://cloud.google.com/free/docs/gcp-free-tier#free-tier-usage-limits), the first that you must manage is to use a free tier compatible region as place to create your VPSs. In this example we will use `us-east1`.

* Ensure to have enabled the [Compute Engine API](https://console.cloud.google.com/compute) to allow the creation of VPSs via API (Terraform will use that).

* A [new project](https://console.cloud.google.com/projectcreate) inside the GCP Console to easy map the resources that we will create.

* A new JSON Key for the new project in the [Service Account section](https://console.cloud.google.com/iam-admin/serviceaccounts). This will be used by Terraform to create and manage resources e.g. the VPS creation. Follow those steps:

```
go to the Service Account section
create a new Service Account and click continue
select the role Owner and click complete
select the new Service Account, go to Key section and create a new JSON key
save the key in a local folder e.g. ~/.gcp/my-project-key.json
```

* Choose a O.S. image to use in your VPSs. A list is available [here](https://console.cloud.google.com/compute/images). In this example we will use `debian-cloud/debian-10`.

* An SSH Key Pair to have access to the VPS. To create a new keypair, do the following:

```
ssh-keygen -q -t rsa -b 2048 -N '' -f ~/.ssh/gcp-keypair
chmod 400 ~/.ssh/gcp-keypair
```

* The Terraform command. To install, see [the official doc](https://www.terraform.io/downloads.html).

* Install [Make](https://www.gnu.org/software/make/). This tool is used to run predefined Terraform commands.



# Usage



Prepare
-------

Use `make init` command to prepare Terraform local data and to download the Google provider driver.

Create
------

Use `make apply` to create the whole infrastructure.

Destroy
-------

Use `make destroy` to destroy the whole infrastructure.



Example
-------

* Output example for the `make apply` command:

![make apply image](/docs/README.md/make_apply.png?raw=true "make apply command")

* Output example for the `make destroy` command:

![make destroy image](/docs/README.md/make_destroy.png?raw=true "make destroy command")

* Login

You can login in your VPS with the command `ssh -i ~/.ssh/gcp-keypair root@111.22.33.44`. Remember to replace `111.22.33.44` with the static ip of your new machine. It is shown in the output of the `make apply` command.



Customize
---------

This project can create several VPSs. Each machine is configured with a static ip, and an initial script can be defined to customize the machine O.S. so that software can be added or removed programmatically. This is configurable modifying the variables defined in the `vars.json` file.

The following snippet is a sample of a `vars.json` to:
* configure the google provider;
* configure the google module that creates:
  * a machine in the B zone with an initial script;
  * a machine in the C zone without initial script;
  * a machine in the D zone without initial script.

```
{
    "google_provider": {
        "region": "us-east1",
        "project": "my-project-id",
        "credentials_file": "~/.gcp/my-project-key.json"
    },
    "google_module": {
        "my-instance-name-b": {
            "zone": "us-east1-b",
            "keypair_path": "~/.ssh/gcp-keypair.pub",
            "machine_type": "f1-micro",
            "image_name": "debian-cloud/debian-10",
            "boot_disk_size": "10",
            "init_script_path": "init_script.sh"
        },
        "my-instance-name-c": {
            "zone": "us-east1-c",
            "keypair_path": "~/.ssh/gcp-keypair.pub",
            "machine_type": "f1-micro",
            "image_name": "debian-cloud/debian-10",
            "boot_disk_size": "10"
        },
        "my-instance-name-d": {
            "zone": "us-east1-d",
            "keypair_path": "~/.ssh/gcp-keypair.pub",
            "machine_type": "f1-micro",
            "image_name": "debian-cloud/debian-10",
            "boot_disk_size": "10"
        }
    }
}
```
