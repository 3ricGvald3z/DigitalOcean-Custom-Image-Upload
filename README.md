# :question:How to Use the Script :interrobang::man_shrugging:
## Modify the configuration & open the script. Update the variables at the top:

IMAGE_URL: The direct URL to your custom image file.

IMAGE_NAME: A unique name for your new image in DigitalOcean.

IMAGE_REGION: The slug for the region where you want to store the image (e.g., nyc3, sfo3).

IMAGE_FORMAT: The format of your image file.

### Make the script executable:

```chmod +x upload_image.sh```

### Run the script:

```./upload_image.sh```

**Note**:
The --wait flag in the command is very important. It tells doctl to wait until the upload and processing are complete, which can take several minutes depending on the image size. This ensures the script doesn't finish before the image is actually ready to be used.


### How do I create a custom image with :dragon:Kali Linux:dragon: for DigitalOcean?

Creating a custom Kali Linux image for DigitalOcean is a great way to have a pre-configured penetration testing environment ready to go on a cloud Droplet. The process is a bit more involved than just a simple upload, as the image needs to be prepared to work with DigitalOcean's infrastructure.

Here's a breakdown of the steps, which are based on the official Kali Linux documentation for cloud deployments and DigitalOcean's own custom image requirements.

### Step 1: Create the Virtual Machine
You'll need to create a Kali Linux virtual machine (VM) on your local computer using a hypervisor like VirtualBox, VMware, or Proxmox.

Download the correct ISO: 
Use the official Kali Linux installer [image](https://cdimage.kali.org/kali-2025.2/)

 ``kali-linux*-installer-netinst-amd64``


Install Kali: 
Official Documentation for using [Kali Linux](https://www.kali.org/docs/cloud/digitalocean/) On DigitalOcean.

Partion Disks:
![](https://www.kali.org/docs/cloud/digitalocean/digitalocean-1.png)

This will be different... Uncheck all boxes for no desktop and no default packages:
![](https://www.kali.org/docs/cloud/digitalocean/digitalocean-2.png)
### Step 2: Prepare the Image for DigitalOcean
This is the most critical part. Your Kali image must be prepared to function correctly on the DigitalOcean platform.

### Install cloud-init: DigitalOcean uses cloud-init to configure Droplets on first boot. You must install this package inside your Kali VM.

``sudo apt update
sudo apt install -y cloud-init``

### Configure ``cloud-init`` for DigitalOcean: You need to tell cloud-init to use the DigitalOcean datasource.

``sudo sh -c "echo 'datasource_list: [ ConfigDrive, DigitalOcean, NoCloud, None ]' > /etc/cloud/cloud.cfg.d/99_digitalocean.cfg"``

[](https://www.kali.org/docs/cloud/digitalocean/#prepare-for-ssh)

### Prepare for SSH

Since we will need to use SSH to connect to the system on DigitalOcean, the  openssh-server  package needs to be installed (and enabled) as well:

``sudo  apt  install -y openssh-server``

``sudo systemctl enable ssh --now``


### Disable root password: Droplets created from custom images require SSH keys for authentication, and password authentication is disabled by default. You must remove the root password.

``sudo passwd -d root``

### Create a directory for SSH keys: DigitalOcean will inject your SSH public key into this folder on Droplet creation.

``sudo mkdir -p /root/.ssh/``

### Clean up the image: Before you finalize the image, it's good practice to clean up unnecessary files and logs to reduce the image size.

``sudo apt autoremove``
``sudo apt autoclean``
``sudo rm -rf /var/log/*``
``sudo history -c``

### Power off the VM: Once all the preparation is done, shut down the virtual machine.

``sudo poweroff``

### Step 3: Convert and Compress the Image
Your VM's disk image will be in a format specific to your hypervisor (e.g., .vmdk for VMware, .vdi for VirtualBox). DigitalOcean supports several formats, including qcow2, vmdk, and raw. The qcow2 format is a good choice as it's a common, flexible format.

You can use the qemu-img tool to convert the disk.

If you're on a Linux machine install qemu-utils if not already present

``sudo apt install -y qemu-utils``

Replace virtualbox_image.vdi with your image file

``qemu-img convert -f vdi -O qcow2 virtualbox_image.vdi kali-custom.qcow2``

If you're on Windows or macOS: Use a virtualization software's built-in tools or a separate utility to perform the conversion.

After converting, you should compress the image to speed up the upload process. gzip or bzip2 are good options.

``gzip kali-custom.qcow2``

This will create a file named kali-custom.qcow2.gz

### Step 4: Host the Image for Upload
You can upload the image to DigitalOcean directly, but for large files, it's often more reliable to upload it from a public URL. You can use a service like Amazon S3, Google Cloud Storage, or a simple web server to host the compressed image.

Once you have a publicly accessible URL, you can proceed to the final step.

### Step 5: Upload the Image to DigitalOcean
Now you can use the bash script to upload your image.


### How to add a ssh key for my custom image for Digital Ocean

Adding an SSH key to a custom image for DigitalOcean is a crucial step to ensure secure access to your Droplets. Since DigitalOcean disables password-based authentication for custom images by default, you must rely on SSH keys. The key to this process is using cloud-init, which is the tool DigitalOcean uses to configure Droplets on their first boot.


### Pre-configure Your Image with cloud-init
As mentioned in the previous response, you must have cloud-init installed and configured correctly within your custom image before you upload it. This tool is responsible for injecting your SSH keys when the Droplet is created.

The preparation steps includes:

- Installing the cloud-init package.

- Ensuring the root user has no password.

- Creating the .ssh directory for the root user (/root/.ssh/). cloud-init will place the authorized keys file in this directory.

### Add the SSH Key During Droplet Creation
Generate an SSH key pair on your local machine:

``ssh-keygen -t rsa -b 4096``

This will create a public key (id_rsa.pub) and a private key (id_rsa). You should never share your private key.

Add your public key to your DigitalOcean account:

Log in to the DigitalOcean control panel.

Navigate to Account -> Security.

In the SSH Keys section, click Add SSH Key.

Give your key a descriptive name and paste the entire content of your public key file (id_rsa.pub) into the text box.

Create a new Droplet from your custom image:

When you create a new Droplet, select your custom image from the My Images tab.

During the creation process, under the Authentication section, you will see a list of your saved SSH keys.

Select the key you just added.

When the Droplet boots up, cloud-init will automatically fetch the selected public key from the DigitalOcean metadata service and add it to the /root/.ssh/authorized_keys file on your Droplet. This allows you to log in securely as the root user using your private key.

Attach a New SSH Key to Your Existing Ubuntu Droplet on DigitalOcean

### This :point_right: [video](https://www.youtube.com/watch?v=fUAya7873-c) demonstrates how to add an SSH key to an existing Droplet, which is a similar process to what happens with a custom image.
