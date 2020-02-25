## Project Bitscout 
**Author:** Vitaly Kamluk // bitscout[at]kaspersky.com

Bitscout is customizable live OS constructor tool written purely in bash. It's
main purpose is to help you quickly create own remote forensics bootable disk 
image.

This project was created by security researchers for security researchers and 
incident handlers. Do not expect user-friendly interface and if you are not
familiar with Linux commandline, it's wise idea to learn that first. This
constructor can be customized to include your tools, however one of the core
ideas was to remotely assist Law Enforcement investigations as well as incident
responders, which is why Bitscout by default includes a number of forensic
packages and settings. 

### Basic usage:

1. Build new ISO file:
   ```
   $ ./automake.sh
   ```

    After running this command, you may need to answer some questions such as
    location of your VPN server, type of build, etc.

    Hint: if you are not running Linux and want to try Bitscout, you can start
    Ubuntu from LiveCD. It works perfectly fine, but we suggest you to have at least
    2Gb+ RAM in this case. To download Ubuntu LiveCD, please go here:
    https://www.ubuntu.com/download/desktop

    Bitscout build demo from Ubuntu LiveCD (older version of Bitscout):
    https://www.youtube.com/watch?v=knA0NS9tWsY

    Note: the automake.sh script runs some commands as root, such as mounting local
    cache directories and creating new root filesystem permissions. However, all 
    changes shall affect only current directory and subdirectories, unless your 
    system is missing some essential packages to build the ISO (in this 
    case they will be installed).

2. Test new ISO file:
    ```
    $ ./autotest.sh
    ```

    This command shall run tests against freshly build ISO file. It verifies
    components' presence on the ISO and attempts to boot the ISO file using qemu to
    verify that all essential services are running.


    To better understand what Bitscout is, we suggest you read further description
    of users' roles in the process and the FAQ below.

### User roles:
Bitscout relies on at least three components in the process of remote forensics:
1. **The owner**  
   The owner is a user who has physical access to the target system and owns it.
   The owner's role is to download, verify and burn Live ISO image file to a
   removable storage (CD-Rom or USB). After that the target system must be 
   started from this bootable media. In case of LAN DHCP network configuration 
   everything shall work automatically. In case of other setup, the owner has 
   to configure network access using simple management interface that is
   brought up on physical console once Bitscout is loaded.

2. **The expert**  
   The expert is a remote user who connects to the target system over SSH using
   VPN link via the expert's server. Bitscout attempts to find existing VPN
   configuration and SSH keys in ./config directory. If it doesn't exist it
   will get the default config and generate new VPN certificates and SSH keys
   during the build.

   Hint: let Bitscout generate new keys for you and populate ./config
   directory, which you can customize later and rebuild the ISO by running
   [automake.sh](https://github.com/KasperskyLab/bitscout/blob/master/automake.sh) again. 

3. **Expert's server**  
   The expert's server shall be accessible from the network of target system.
   It shall run an instance of OpenVPN server, and recommended to have a Syslog
   server for logging an IRC chat server for communication. Suggested server
   configuration files can be found in the ./exports directory after successful
   build of ISO file.

### Bitscout Features:
1. Transparency
  a. You build your own live disk instead of using someone else's. The build
  process is rather straightforward and detailed. One of the core principles of
  Bitscout is to not use proprietary binary executables during build process.
  Project Bitscout is a plaintext OS constructor.
  b. You may choose what packages you put on Bitscout ISO. This lets you
  decide which binaries you trust.
  b.The owner can monitor what is going on in expert's container live or via
  recorded session, which can be replayed. This is useful for training or
  understanding of forensic process in the court. 

2. Forensics
  a. Bitscout is designed to not modify hard drive data or other
  storage media attached to the system. This is essential for forensic
  analysis.
  b. Bitscout contains most popular tools to acquire and analyze storage drives.
  c. The owner of the system controls which disk devices are accessible to the
  expert in read-only (or read-write) mode.
  d. Even running as root the expert cannot modify or reset access to the
  provided storage devices, which prevents potential data loss from the source
  disk. This is achieved via layers of virtualization.

3. Customisation
  a. The set of tools available on Bitscout can be customized by editing
  respective scripts before running the build. You can add standard packages 
  or your own tools. Make it available to expert, system owner or both.
  b. Both system owner and expert can install additional software packages on
  already running (booted) system. All changes will be done indepently 
  (expert cannot change owner's environment). All installed software will exist
  only in RAM and will be gone when system is restarted.
  c. If certain operations require more memory or large disk which is not
  available on the system, the owner may attach writable external storage device
  (such as fast USB flash memory) to be used for storage or swap by the expert.

4. Compact
  a. Bitscout project is designed to be minimal yet universal tool to access
  remote systems. It contains minimal set of packages, libraries and
  tools to start the system and provide most common forensic tools to the expert
  immediately. Certain optimizations yet to be added to reduce size even
  further. All suggestions and contributions are welcome!
  b. The system uses no graphical interface on purpose. This reduces disk image
  size and RAM consumption.
  c. The expert's runs inside unprivileged LXC container, which saves from 
  overhead of full virtualization. The container relies on the same kernel as 
  the host system, but doesn't allow kernel module manipulation.
  d. The container root filesystems is overlayed from the live CD rootfs. 
  This enables to reuse the system binaries and configuration and avoid data
  duplication. Yet, mapped with copy-on-write access it provides almost unlimited
  modification of the whole OS. The real limit is just the size of available
  memory and swap.
  
    As a matter of fact fully running OS with a child OS inside the container used less than 200Mb of RAM in some of our tests in the past.


### F.A.Q:

**Q: Why was the system created?**  
**A:** There is a lot of commercial and rather expensive forensic software suites 
out there. We tried several most popular of them and always bumped into 
functionality limitations and lack of transparency in the processes. While some
suites provide scriptability, they lack remote analysis features that do not
modify the evidence disk. Most of forensic tools are not designed for remote 
analysis, lacked flexibility and cost a fortune.
We found that there was a niche for a new tool which is
  1. trusted, transparent and opensource (you build your own OS!)
  2. customisable (you put your own tools!)
  3. stable and reliable
  4. optimal and compact
  5. fast and optimal (with low RAM usage)
  6. free of charge
  7. runs on old and new hardware

**Q: How was the project developed?**  
**A:** The project was initially developed as a hobby project. The first variant 
relied on full trust to the remote user, who was provided with root access to 
the live system. Soon we realized that the remote system owner is willing to 
track the progress, communicate with the expert and be able to approve access
to storage media. To increase trust level between system's owner and the remote 
expert we decided to isolate the expert within virtualized container. This 
assured the owner of the system that the source disk information 
will never be tampered (unless it is permitted by the owner in case of 
system remediation request).

**Q: Does the author provide VPN server with this project?**  
**A:** No, you have to use own server. All you need is an OpenVPN instance. It's 
free and open-source, it runs on all platforms.
For more information, see https://openvpn.net

**Q: Will the product be supported?**  
**A:** It will be supported as long as there is need for such tool. We will migrate
to newer LTS versions of Ubuntu as it is released. This is important to upgrade
forensic tools. However, you can always update already running live system from a
newer repository and install more recent versions of certain packages.

**Q: Do I need to re-run `./automake.sh` every time I change anything, i.e. put my
own VPN certificate or SSH key?**  
**A:** No. automake.sh script is just an easy do-everything script to build new ISO
file from scratch in one run. Feel free to copy and modify it. Comment out
stages that you don't want to pass again from top to bottom and run it. Make
sure you run the last stage image_build.sh to rebuild the ISO file. If you
didn't modify the rootfs in chroot directory, you can also use
scripts/image_build-nosquashfs-rebuild.sh to save even more time.

**Q: Is this the best forensic product to save the world?**  
**A:** It is not and was never meant to be so. It serves it's task though and did 
help us in the past in some complicated circumstances and under time pressure. 
If it works for you we will be happy to hear your story. If not, perhaps you 
could suggest a clever patch?

**Q: Is this project used for Kaspersky Lab business?**  
**A:** This project was created independently of Kaspersky Lab product line and
outside of scope of company's business operation. The developed tool is not
limited to particular users and might be useful to researchers, high-tech crime
units of Law Enforcement and educational institutions.


### Credits:
  - Kaspersky Lab
  - INTERPOL Global Complex For Innovation (IGCI)
  - IGCI Digital Forensics Lab

Thanks to
  - Linux kernel developers
  - Canonical Ltd
  - All open-source software developers
  - LXC developers
  - All those awesome authors of Linux forensics tools
