# artiplunk

Automatic system installer for Artix.

Please note that this project has been ABANDONED, but the code is available to fork and use (MIT license) as desired.


## About this Code

This project was started as a way to test the automated deployment of [Artix Linux](https://artixlinux.org) on
university laboratory workstations. Bash shell scripting was used as the implementation language, which was a mistake
in hindsight. However, the design of the installer made it easy to customize individual functions to match
deployment conditions.

The installer script is generated from a set of smaller, more manageable Bash files. Once generated, the script is
capable of packing arbitrary data into itself, including templates and configurations for performing installations.
The basic premise was that the packed installer would be available as a single download from a server, so that it
could be obtained with a single wget/curl operation from inside the installation environment. From there, the
installation would have been completely automatic.

Support for fully encrypted systems and LVM was added, but support for software RAID was never completed. Changes to
laboratory priorities, including a significant reduction in the total number of systems, made it unnecessary to
complete this project.


## Quick Start (with VirtualBox or QEMU VM)

At last check, this process was BROKEN with recent versions of Artix. However, the procedure would have been as
follows:

Download an Artix base ISO from the [Artix Linux Downloads](https://artixlinux.org/download.php) page. Create a
VM with a virtual hard disk of at least 20 GB in size.

On the host system, check out the git repo and run:

```make serve```

Inside the guest, run:

```
sudo su -
curl -o artiplunk http://10.0.2.2:8042/artiplunk
chmod +x artiplunk
./artiplunk -x simple > install.conf

```

Test the configuration by doing a dry run with:

```
./artiplunk -D install.conf
```

If the dry run (-D) succeeds, run the actual installation with:

```./artiplunk -o install.conf```


## Custom Configuration

Inside the guest, run:

```
sudo su -
curl -o artiplunk http://10.0.2.2:8042/artiplunk
chmod +x artiplunk
./artiplunk --proper
./artiplunk -x annotated > install.conf
vim install.conf
./artiplunk -D install.conf
./artiplunk -o install.conf
```

Alternative starting points for the configuration may be found by running ```artiplunk -l example```


## Troubleshooting

Should the installation abort at any step, troubleshoot the problem. You can resume the installation from the failed
step by running:

```./artiplunk -o --resume```

To re-run a previous step, edit /tmp/artiplunk/step, and change the step name to the step that is to be re-run. Note
that, by default, the /tmp/artiplunk directory is removed at the end of a clean installation. The "-o" flag copies
the installation log to /root on the newly installed system.


## Packed Installations

Once we can get an install working, the -O flag will copy Artiplunk, along with a packed configuration, to /root on
the target system. This version of the script can be used to reinstall the target system in the future by running
the built installer with the -P switch.


## More Information

Run ```./artiplunk --help``` for more documentation, although the help system is incomplete.
