echo "";
echo "  __  __                _     _     _                  ";
echo " |  \/  | __ _ _ __ ___| |__ | |   (_)_ __  _   ___  __";
echo " | |\/| |/ _\` | '__/ __| '_ \| |   | | '_ \| | | \ \/ /";
echo " | |  | | (_| | | | (__| | | | |___| | | | | |_| |>  < ";
echo " |_|  |_|\__,_|_|  \___|_| |_|_____|_|_| |_|\__,_/_/\_\\";
echo "                                                       ";

echo "     Easy-to-configure archlinux+i3 install script ";
echo "        for maximum comfort and minimum hassles ";
echo "";
echo "";

# syncing system datetime
timedatectl set-ntp true

# getting latest mirrors for italy and germany
wget -O mirrorlist "https://www.archlinux.org/mirrorlist/?country=DE&country=IT&protocol=https&ip_version=4"
sed -ie 's/^.//g' ./mirrorlist
mv ./mirrorlist /etc/pacman.d/mirrorlist

# updating mirrors
pacman -Syyy

# formatting disk
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  g # gpt partitioning
  n # new partition
    # default: primary partition
    # default: partition 1
  +500M # 500 mb on boot partition
    # default: yes if asked
  n # new partition
    # default: primary partition
    # default: partition 2
  +80G # 80 gb for root partition
    # default: yes if asked
  n # new partition
    # default: primary partition
    # default: partition 3
    # default: all space left of for home partition
    # default: yes if asked
  t # change partition type
  1 # selecting partition 1
  1 # selecting EFI partition type
  w # writing changes to disk
EOF

# outputting partition changes
fdisk -l /dev/sda

# partition filesystem formatting
yes | mkfs.fat -F32 /dev/sda1
yes | mkfs.ext4 /dev/sda2
yes | mkfs.ext4 /dev/sda3

# disk mount
mount /dev/sda2 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home

# pacstrap-ping desired disk
pacstrap /mnt base base-devel vim grub i3-wm networkmanager i3status rofi feh i3lock \
os-prober efibootmgr ntfs-3g links alacritty neofetch git zsh intel-ucode cpupower \
xorg-server xorg-xinit ttf-dejavu ttf-liberation ttf-inconsolata ttf-fira-code noto-fonts \
chromium firefox code atom nvidia nvidia-settings xf86-video-intel flameshot \
pulseaudio pasystray pamixer telegram-desktop go python wget wine-staging

# generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

# setting right timezone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

# enabling font presets for better font rendering
arch-chroot /mnt ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
arch-chroot /mnt ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
arch-chroot /mnt ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d

# synchronizing timer
arch-chroot /mnt hwclock --systohc

# localizing system
arch-chroot /mnt sed -ie 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt sed -ie 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen

# generating locale
arch-chroot /mnt locale-gen

# setting system language
arch-chroot /mnt echo "LANG=en_US.UTF-8" >> /mnt/etc/locale.conf

# setting machine name
arch-chroot /mnt echo "lenooks" >> /mnt/etc/hostname

# setting hosts file
arch-chroot /mnt echo "127.0.0.1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "::1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "127.0.1.1 lenooks.localdomain lenooks" >> /mnt/etc/hosts

# making sudoers do sudo stuff without requiring password typing
arch-chroot /mnt sed -ie 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

# make initframs
arch-chroot /mnt mkinitcpio -p linux

# setting root password
echo "Insert password for root:"
arch-chroot /mnt passwd

# making user mrcz
arch-chroot /mnt useradd -m -G wheel -s /bin/zsh mrcz

# setting mrcz password
echo "Insert password for mrcz:"
arch-chroot /mnt passwd mrcz

# installing grub bootloader
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot  --bootloader-id=GRUB --removable

# making grub auto config
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# changing governor to performance
arch-chroot /mnt echo "governor='performance'" >> /mnt/etc/default/cpupower

# making services start at boot
arch-chroot /mnt systemctl enable cpupower.service
arch-chroot /mnt systemctl enable NetworkManager.service

# making i3 default for startx for both root and mrcz
arch-chroot /mnt echo "exec i3" >> /mnt/root/.xinitrc
arch-chroot /mnt echo "exec i3" >> /mnt/home/mrcz/.xinitrc

# installing yay
arch-chroot /mnt sudo -u mrcz git clone https://aur.archlinux.org/yay.git /home/mrcz/yay_tmp_install
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "cd /home/mrcz/yay_tmp_install && yes | makepkg -si"
arch-chroot /mnt rm -rf /home/mrcz/yay_tmp_install

# installing polybar
arch-chroot /mnt sudo -u mrcz yay -S polybar --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S spotify --noconfirm

# installing leagueoflegends install/launch wrapper
arch-chroot /mnt sudo -u mrcz yay -S leagueoflegends-git --noconfirm

# installing oh-my-zsh
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# installing pi theme for zsh
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "wget -O $ZSH_CUSTOM/themes/pi.zsh-theme https://raw.githubusercontent.com/tobyjamesthomas/pi/master/pi.zsh-theme"

# installing config files
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/GitHub
arch-chroot /mnt sudo -u mrcz git clone https://github.com/maaaybe/MarchLinux /home/mrcz/GitHub/MarchLinux
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "chmod 700 /home/mrcz/GitHub/MarchLinux/install_configs.sh"
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "cd /home/mrcz/GitHub/MarchLinux && ./install_configs.sh"

# unmounting all mounted partitions
umount -R /mnt

# syncing disks
sync

echo ""
echo "INSTALLATION COMPLETE! enjoy :)"
echo ""

sleep 3
reboot
