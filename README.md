# IronArch - Arch Linux Installer and useful scripts, services, templates

## Overview

IronArch is a collection of scripts and installer with provisioning (same idea as Ansible, but very small (a short script and service)). The main installer is currently incomplete and needs to be better organized; however, the custom_installs do work (last time I ran them one was years ago for my Ethereum mining ventures). Eventually this could be a one command installer and provisioner for Arch Linux.

## Main installer (/installer)

### Features

- **One script installation**: Get Arch Linux installed and fully setup with just a single script and few edits.
- **Installs an Openbox environment**: Great for anyone wanting to use openbox.
- **Install from a local repository of arch packages** just incase the internet stops working oneday, lol, I have put some effort into writing scripts to install from local repos.

### Getting Started

Ideally, the main installer would function such that all you have to do is:

1. **Download IronArch**: Download the latest version of IronArch from [our repository](#).
2. **Configure the Installer**: Just configure a simple variable list
3. **Run the Installer**: Execute the IronArch script.
4. **Enjoy Arch Linux**: Once the installation completes, you're ready to dive into Arch Linux!

## Custom Installs (custom_installs)

These were different script from the main installer, but I left it in this repo in case I may use some of the code in the main installer.

- **Miner Installer:** This was the setup i was using to mine Ethereum back in the day. I also had a python script that would text me some meterics throughout the day using Twilio, but i believe i have lost that over the years.
- **VM Music Downloader:** This setup i would use because I have always disliked the windows linux subsystem.

## Guides

Just a few notes about how to do somethings on Linux.

## Other Directories of this Repo

- **Pacman_hooks:** Just some pacman configurations.
- **Services:** All the services for main installer and other services configuartions
- **Configs:** All the configurations found in /etc /boot
- **Software_installs:** Scripts to install software that requires extra steps e.g. configuring capabilities for wireshark or the uucp group for Arduino studio
- **System_scripts:** All the useful `/usr/local/{sbin,bin}` scripts I have written or mainly use in my day-to-day use of Arch Linux.

### Contributing

Contributions to IronArch are welcome! Check out our [contribution guidelines](#) for more information.

---

IronArch is not affiliated with or endorsed by Arch Linux.
