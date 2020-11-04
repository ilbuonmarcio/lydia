# lydia

![](0.png)

`lydia` is a simple Arch Linux installation script.

It's easy to configure, install and use, has UEFI-only boot support and provides automatic disk partitioning.

It's build upon a very minimal set of useful packages, and features `bspwm` as the window manager of choice.

It's specifically targeted at development & productivity tasks but it's still very easy to customize to fit your own needs!

# Configuration & Installation Procedure

- Download the official Arch Linux .iso file from the [official site download section](https://www.archlinux.org/download/)

- Flash it onto an USB drive, insert it in the desired PC and boot the provided live environment, as per the ArchWiki installation page

- Inside this live environment you should now connect to the internet using either ethernet or wifi as you like (use `wifi-menu` or `nmcli` or as your preference), then download the latest script from this repository with the following command:

```bash
curl -o install.sh https://raw.githubusercontent.com/ilbuonmarcio/lydia/master/install.sh
```

- Modify it to fit your own purposes (I suggest you to edit the partition mounts, change hostname, username, purge packages and features you don't need and so on, or do like [all these people](https://github.com/ilbuonmarcio/lydia/network/members) and fork this repository as a base for your own Arch Linux install script!

```bash
vim ./install.sh
```

- Change file permissions to make it executable, of course!

```bash
chmod +x ./install.sh
```

- Edit `/etc/pacman.conf` file, making sure `[multilib]` repository is enabled or it won't work!

- Execute `install.sh` script and insert the information required when prompted

```bash
./install.sh
```

## Support

This software is semi-frequently updated as per necessity, but I will not provide any dedicated support to users using this piece of software. Still, feel free to open an Issue or submit a Pull Request!

## Here is a fun Disclaimer

THIS PIECE OF SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTIES OF ANY KIND. I AM NOT RESPONSIBLE FOR ANY USAGE OF THIS SCRIPT, OR ANY IMPORTANT DISK ACCIDENTALLY FORMATTED BY THIS INSTALL SCRIPT, OR YOUR ENTIRE SYSTEM EXPLODING, OR WHATEVER.

REALLY. USE AT YOUR OWN RISK.

## License

This software is released under MIT License.
Read LICENSE for more information.
