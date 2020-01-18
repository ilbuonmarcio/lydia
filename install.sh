echo "";
echo "                              _       _        ";
echo "       _ __ ___  _ __ ___ ___| |_ __ | | _____ ";
echo "      | '_ \` _ \| '__/ __|_  / | '_ \| |/ / __|";
echo "      | | | | | | | | (__ / /| | | | |   <\__ \\";
echo "      |_| |_| |_|_|  \___/___|_|_| |_|_|\_\___/";
echo "                                        ";
echo "                                                       ";

echo "     Easy-to-configure archlinux+i3 install script ";
echo "        for maximum comfort and minimum hassles ";
echo "";
echo "";

# checks wheter there is multilib repo enabled properly or not
IS_MULTILIB_REPO_DISABLED=$(cat /etc/pacman.conf | grep "#\[multilib\]" | wc -l)
if [ "$IS_MULTILIB_REPO_DISABLED" == "1" ]
then
    echo "You need to enable [multilib] repository inside /etc/pacman.conf file before running this script, aborting installation"
    exit -1
fi
echo "[multilib] repo correctly enabled, continuing"

# syncing system datetime
timedatectl set-ntp true

# getting latest mirrors for italy and germany
wget -O mirrorlist "https://www.archlinux.org/mirrorlist/?country=DE&country=IT&protocol=https&ip_version=4"
sed -ie 's/^.//g' ./mirrorlist
mv ./mirrorlist /etc/pacman.d/mirrorlist

# updating mirrors
pacman -Syyy

# adding fzf for making disk selection easier
pacman -S fzf --noconfirm

# open dialog for disk selection
sudo fdisk -l | grep 'Disk /dev/' | awk '{print $2,$3,$4}' | sed 's/,$//' | fzf | sed -e 's/\/dev\/\(.*\):/\1/' | awk '{print $1}' | read selected_disk

# formatting disk
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/${selected_disk}
  g # gpt partitioning
  n # new partition
    # default: primary partition
    # default: partition 1
  +500M # 500 mb on boot partition
    # default: yes if asked
  n # new partition
    # default: primary partition
    # default: partition 2
  +120G # 120 gb for root partition
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
fdisk -l /dev/${selected_disk}

# partition filesystem formatting
yes | mkfs.fat -F32 /dev/${selected_disk}1
yes | mkfs.ext4 /dev/${selected_disk}2
yes | mkfs.ext4 /dev/${selected_disk}3

# disk mount
mount /dev/${selected_disk}2 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/${selected_disk}1 /mnt/boot
mount /dev/${selected_disk}3 /mnt/home

# pacstrap-ping desired disk
pacstrap /mnt base base-devel vim grub networkmanager rofi feh linux-headers \
os-prober efibootmgr ntfs-3g kitty git zsh intel-ucode cpupower xf86-video-amdgpu vlc \
xorg-server xorg-xinit ttf-dejavu ttf-liberation ttf-inconsolata noto-fonts \
chromium firefox code xf86-video-intel zip unzip unrar obs-studio docker \
pulseaudio pasystray pamixer telegram-desktop go python python-pip wget \
openssh xorg-xrandr noto-fonts-emoji maim imagemagick xclip pinta light ranger \
ttf-roboto playerctl papirus-icon-theme hwloc p7zip picom hsetroot docker-compose \
nemo linux-firmware firewalld tree man glances ttf-cascadia-code darktable fzf \
mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver \
mesa-vdpau lib32-mesa-vdpau zsh-syntax-highlighting xdotool cronie dunst entr \
xf86-video-nouveau xf86-video-vmware

# generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

# updating repo status
arch-chroot /mnt pacman -Syyy

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
arch-chroot /mnt sudo -u root /bin/zsh -c 'echo "Insert root password: " && read root_password && echo -e "$root_password\n$root_password" | passwd root'

# making user mrcz
arch-chroot /mnt useradd -m -G wheel -s /bin/zsh mrcz

# setting mrcz password
arch-chroot /mnt sudo -u root /bin/zsh -c 'echo "Insert mrcz password: " && read mrcz_password && echo -e "$mrcz_password\n$mrcz_password" | passwd mrcz'

# installing grub bootloader
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot  --bootloader-id=GRUB --removable

# adding proper resolution to grub to make it full screen and properly visible
arch-chroot /mnt sed -ie 's/GRUB_GFXMODE=auto/GRUB_GFXMODE=2560x1440x32,auto/g' /etc/default/grub
arch-chroot /mnt sed -ie 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=15/g' /etc/default/grub

# making grub auto config
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# changing governor to performance
arch-chroot /mnt echo "governor='performance'" >> /mnt/etc/default/cpupower

# making services start at boot
arch-chroot /mnt systemctl enable cpupower.service
arch-chroot /mnt systemctl enable NetworkManager.service
arch-chroot /mnt systemctl enable docker.service
arch-chroot /mnt systemctl enable firewalld.service
arch-chroot /mnt systemctl enable cronie.service
arch-chroot /mnt systemctl enable sshd.service

# enabling and starting DNS resolver via systemd-resolved
arch-chroot /mnt systemctl enable systemd-resolved.service
arch-chroot /mnt systemctl start systemd-resolved.service

# enabling https, http as per default configuration for public zone for firewalld
arch-chroot /mnt firewall-cmd --add-service=http --permanent
arch-chroot /mnt firewall-cmd --add-service=https --permanent

# making i3 default for startx for both root and mrcz
arch-chroot /mnt echo "exec i3" >> /mnt/root/.xinitrc
arch-chroot /mnt echo "exec i3" >> /mnt/home/mrcz/.xinitrc

# installing yay
arch-chroot /mnt sudo -u mrcz git clone https://aur.archlinux.org/yay.git /home/mrcz/yay_tmp_install
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "cd /home/mrcz/yay_tmp_install && yes | makepkg -si"
arch-chroot /mnt rm -rf /home/mrcz/yay_tmp_install

# installing i3-gaps, polybar, spotify, iotop, i3lock-fancy, downgrade
arch-chroot /mnt sudo -u mrcz yay -S i3-gaps --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S polybar --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S spotify --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S iotop --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S i3lock-fancy --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S downgrade --noconfirm

# installing better font rendering packages
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "yes | yay -S freetype2-infinality-remix fontconfig-infinality-remix cairo-infinality-remix"

# installing oh-my-zsh
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# installing pi theme for zsh
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "wget -O /home/mrcz/.oh-my-zsh/themes/pi.zsh-theme https://raw.githubusercontent.com/tobyjamesthomas/pi/master/pi.zsh-theme"

# installing vundle
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/.vim
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/.vim/bundle
arch-chroot /mnt sudo -u mrcz git clone https://github.com/VundleVim/Vundle.vim.git /home/mrcz/.vim/bundle/Vundle.vim

# installing fonts
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/fonts_tmp_folder
arch-chroot /mnt sudo -u mrcz sudo mkdir /usr/share/fonts/OTF/
# font awesome 5 brands
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "cd /home/mrcz/fonts_tmp_folder && wget -O fontawesome.zip https://github.com/FortAwesome/Font-Awesome/releases/download/5.9.0/fontawesome-free-5.9.0-desktop.zip && unzip fontawesome.zip"
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "sudo cp /home/mrcz/fonts_tmp_folder/fontawesome-free-5.9.0-desktop/otfs/Font\ Awesome\ 5\ Brands-Regular-400.otf /usr/share/fonts/OTF/"
# material icons
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "cd /home/mrcz/fonts_tmp_folder && wget -O materialicons.zip https://github.com/google/material-design-icons/releases/download/3.0.1/material-design-icons-3.0.1.zip && unzip materialicons.zip"
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "sudo cp /home/mrcz/fonts_tmp_folder/material-design-icons-3.0.1/iconfont/MaterialIcons-Regular.ttf /usr/share/fonts/TTF/"
# removing fonts tmp folder
arch-chroot /mnt sudo -u mrcz rm -rf /home/mrcz/fonts_tmp_folder

# install atom theme and syntax
arch-chroot /mnt sudo -u mrcz apm install electric-ui electric-syntax

# install dbus-python pip package
arch-chroot /mnt sudo -u mrcz sudo pip3 install dbus-python

# installing config files
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/GitHub
arch-chroot /mnt sudo -u mrcz git clone https://github.com/ilbuonmarcio/mrczlnks /home/mrcz/GitHub/mrczlnks
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "chmod 700 /home/mrcz/GitHub/mrczlnks/install_configs.sh"
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "cd /home/mrcz/GitHub/mrczlnks && ./install_configs.sh"

# create folder for screenshots
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/Screenshots

# create pictures folder, secrets folder and moving default wallpaper
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/Pictures
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/.secrets
arch-chroot /mnt sudo -u mrcz cp -r /home/mrcz/GitHub/mrczlnks/wallpapers/ /home/mrcz/Pictures/

# adding tty personalized header and after-login banner
arch-chroot /mnt cp /home/mrcz/GitHub/mrczlnks/misc/issue /etc/issue
arch-chroot /mnt cp /home/mrcz/GitHub/mrczlnks/misc/motd /etc/motd

# installing plymouth
arch-chroot /mnt sudo -u mrcz yay -S plymouth-git --noconfirm
arch-chroot /mnt sed -ie 's/base udev/base udev plymouth/g' /etc/mkinitcpio.conf
arch-chroot /mnt sed -ie 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0"/g' /etc/default/grub
arch-chroot /mnt sed -ie 's/Theme=spinner/Theme=bgrt/g' /etc/plymouth/plymouthd.conf
arch-chroot /mnt cp /home/mrcz/GitHub/mrczlnks/logo-inverse.png /usr/share/plymouth/themese/spinner/watermark.png
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt mkinitcpio -p linux

# unmounting all mounted partitions
umount -R /mnt

# syncing disks
sync

echo ""
echo "INSTALLATION COMPLETE! enjoy :)"
echo ""

sleep 3
