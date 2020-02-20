![](logo.png)

# What is mrczlnks?

`mrczlnks` is a featureful, yet simple Arch Linux install script

# Features
- Easy to configure, install and use
- UEFI & classic BIOS boot support
- Automatic disk partitioning
- Customized i3-gaps window manager to fit all your needs
- Preconfigured `firewalld` on 22/80/443 ports
- Specifically targeted at development & productivity tasks

# Support

Due that's software needed for me personally and has no other purpose other than mine, at least for me, I will not **_fuggin'_** provide any dedicated support for this script because that's *my* script, and not directly *yours*, so you're advised! :beers: :kiss:

## So, here is a fun Disclaimer

THIS PIECE OF SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTIES OF ANY KIND. I AM NOT RESPONSIBLE FOR ANY USAGE OF THIS SCRIPT, OR ANY IMPORTANT DISK ACCIDENTALLY FORMATTED BY THIS INSTALL SCRIPT, OR YOUR ENTIRE SYSTEM EXPLODING, OR WHATEVER.

REALLY. USE AT YOUR OWN RISK. xoxo

# Configuration & Installation Procedure

- Download the official Arch Linux .iso file from the [official site download section](https://www.archlinux.org/download/)

- Flash it onto an USB drive with softwares like `dd`, Rufus, balenaEtcher or whatever, stick it in the desired PC and boot the provided live environment, as per the ArchWiki installation page

- Inside this live environment you should now connect to the internet using either ethernet or wifi as you like (use `wifi-menu` or `nmcli` or as your preference), then download the latest script from this repository with the following command:

```bash
wget https://raw.githubusercontent.com/ilbuonmarcio/mrczlnks/master/install.sh
```

- Modify it to fit your own purposes (I suggest you to edit the partition mounts, change hostname, username, purge packages and features you don't need and so on, or do like [zetaemme](https://github.com/zetaemme/zls) and fork this repository as a base for your own Arch Linux install script!)

```bash
vim ./install.sh
```

- Change file permissions to make it executable, of course!

```bash
chmod 700 ./install.sh
```

- Edit `/etc/pacman.conf` file, making sure `[multilib]` repository is enabled or it won't work!

- Execute `install.sh` script and insert the information required when prompted

```bash
./install.sh
```

Once the script prompts you that it finished, you can just `reboot`, remove the USB drive previously inserted and finally start using your new distribution!

## License

This software is released under MIT License.
Read LICENSE for more information.
