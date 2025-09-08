PROJECT <span style="font-family: monospace; color: #00ff00;">//IMAGE_UPLOAD_UTILITY</span>
PAYLOAD DESCRIPTION
This repository contains a streamlined payload for the rapid deployment of a custom server image to DigitalOcean. The upload_image.sh script automates all core authentication, upload, and registration tasks, preparing your system for a rapid, repeatable build process.

For a full list of mission parameters, refer to the operational guide below.

EXECUTION LOG
>
>      /\_/\
>     ( o.o )
>      > ^ <
>

> // ACCESS GRANTED


OPERATIONAL GUIDE
The upload_image.sh binary is executed from your terminal and must be run with root privileges.

# Make the script executable
chmod +x upload_image.sh

# Run the setup payload with sudo
sudo ./upload_image.sh


Follow the on-screen prompts to define your image path and DigitalOcean credentials. The script will handle all dependencies, configuration, and image registration.

SYSTEM REQUIREMENTS
The conduit is built on core Linux utilities and requires a standard Bash environment. It has been tested on Debian/Ubuntu and CentOS/RHEL systems.

End of transmission.
