# mrczlnks

mrczlnks is a free to use Arch Linux + i3-wm install script.

It is primarly designed for my own usage but free for you all to use and modify to fit your own purposes.

I will not provide any support for this script because of this, so you're adivsed! :beers:

## Disclaimer

THIS PIECE OF SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTIES OF ANY KIND. I AM NOT RESPONSIBLE FOR ANY USAGE OF THIS SCRIPT, OR ANY IMPORTANT DISK ACCIDENTALLY FORMATTED BY THIS INSTALL SCRIPT, OR YOUR ENTIRE SYSTEM EXPLODING, OR WHATEVER. REALLY. USE AT YOUR OWN RISK.

### Usage

- Download the official Arch Linux .iso file from the official site download section
- Flash it onto an USB drive with softwares like Rufus, balenaEtcher and boot it in the system of choice
- Inside the live environment you should now connect to the internet using either ethernet or wifi as you like (use `wifi-menu`, which is recommended for wireless networks), then download the latest script from this repository with the following command:

```bash
wget https://raw.githubusercontent.com/maaaybe/mrczlnks/master/install.sh
```

- Modify it to fit your own purposes (e.g. disk to format, partitions, hostname, username)

```bash
vim ./install.sh
```

- Change file permissions to make it executable

```bash
chmod 700 ./install.sh
```

- Execute install.sh script and insert data when prompted

```bash
./install.sh
```

Once the script finishes, you can `reboot` the live environment and remove the USB drive previously inserted, and finally start using the new desktop experience you just installed!

### License

This software is released under MIT License.
Read LICENSE for more information.
