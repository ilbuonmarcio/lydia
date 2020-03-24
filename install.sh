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

# boot partition size, in MB
boot_partition_size=500

# home partition size, in GB
home_partition_size=40

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
selected_disk=$(sudo fdisk -l | grep 'Disk /dev/' | awk '{print $2,$3,$4}' | sed 's/,$//' | fzf | sed -e 's/\/dev\/\(.*\):/\1/' | awk '{print $1}')  

# formatting disk for UEFI install
echo "Formatting disk for UEFI install"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/${selected_disk}
  g # gpt partitioning
  n # new partition
    # default: primary partition
    # default: partition 1
  +${boot_partition_size}M # mb on boot partition
    # default: yes if asked
  n # new partition
    # default: primary partition
    # default: partition 2
  +${home_partition_size}G # gb for home partition
    # default: yes if asked
  n # new partition
    # default: primary partition
    # default: partition 3
    # default: all space left of for root partition
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
mount /dev/${selected_disk}3 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/${selected_disk}1 /mnt/boot
mount /dev/${selected_disk}2 /mnt/home

# pacstrap-ping desired disk
pacstrap /mnt base base-devel vim networkmanager rofi feh linux linux-headers \
os-prober efibootmgr ntfs-3g alacritty git zsh intel-ucode amd-ucode cpupower xf86-video-amdgpu vlc \
xorg-server xorg-xinit ttf-dejavu ttf-liberation ttf-inconsolata noto-fonts \
chromium firefox geckodriver code xf86-video-intel zip unzip unrar obs-studio docker \
pulseaudio pasystray pamixer telegram-desktop go python python-pip wget nginx mariadb \
openssh xorg-xrandr noto-fonts-emoji maim imagemagick xclip pinta light ranger \
ttf-roboto playerctl papirus-icon-theme hwloc p7zip hsetroot docker-compose \
nemo linux-firmware firewalld tree man glances otf-brass-mono darktable fzf \
mesa mesa-demos lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver \
mesa-vdpau lib32-mesa-vdpau zsh-syntax-highlighting xdotool cronie dunst entr \
xf86-video-nouveau xf86-video-vmware python-dbus httpie discord bind-tools \ 
virtualbox python-pywal lutris i3lock dbeaver ccache

# generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

# enabled [multilib] repo on installed system
arch-chroot /mnt zsh -c 'echo "[multilib]" >> /etc/pacman.conf'
arch-chroot /mnt zsh -c 'echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf'

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
arch-chroot /mnt echo "mrczlnks" >> /mnt/etc/hostname

# setting hosts file
arch-chroot /mnt echo "127.0.0.1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "::1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "127.0.1.1 mrczlnks.localdomain mrczlnks" >> /mnt/etc/hosts

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

# installing systemd-boot
bootctl --path=/boot install

# configuring mrczlnks boot entry
arch-chroot /mnt grep "UUID=" /etc/fstab | grep '/ ' | awk '{ print $1 }' | sed -e 's/UUID=//' > .root_disk_uuid
arch-chroot /mnt touch /boot/loader/entries/mrczlnks.conf
arch-chroot /mnt echo "title mrczlnks" >> /boot/loader/entries/mrczlnks.conf
arch-chroot /mnt echo "linux /vmlinuz-linux" >> /boot/loader/entries/mrczlnks.conf
arch-chroot /mnt echo "initrd /amd-ucode.img" >> /boot/loader/entries/mrczlnks.conf
arch-chroot /mnt echo "initrd /initramfs-linux.img" >> /boot/loader/entries/mrczlnks.conf
arch-chroot /mnt echo 'options root="UUID=root_disk_uuid" rw' >> /boot/loader/entries/mrczlnks.conf
arch-chroot /mnt sed -ie "s/root_disk_uuid/$(cat .root_disk_uuid)/g" /boot/loader/entries/mrczlnks.conf
arch-chroot /mnt rm .root_disk_uuid

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

# making i3 default for startx for both root and mrcz
arch-chroot /mnt echo "exec i3" >> /mnt/root/.xinitrc
arch-chroot /mnt echo "exec i3" >> /mnt/home/mrcz/.xinitrc

# installing yay
arch-chroot /mnt sudo -u mrcz git clone https://aur.archlinux.org/yay.git /home/mrcz/yay_tmp_install
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "cd /home/mrcz/yay_tmp_install && yes | makepkg -si"
arch-chroot /mnt rm -rf /home/mrcz/yay_tmp_install

# adding makepkg optimizations
arch-chroot /mnt sed -i -e 's/#MAKEFLAGS="-j2"/MAKEFLAGS=-j'$(nproc --ignore 1)'/' -e 's/-march=x86-64 -mtune=generic/-march=native/' -e 's/xz -c -z/xz -c -z -T '$(nproc --ignore 1)'/' /etc/makepkg.conf
arch-chroot /mnt sed -ie 's/!ccache/ccache/g' /etc/makepkg.conf

# installing various packages from AUR
arch-chroot /mnt sudo -u mrcz yay -S i3-gaps --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S polybar --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S downgrade --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S ncspot --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S corrupter-bin --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S ctop-bin --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S whatsapp-nativefier-dark --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S simplenote-electron-bin --noconfirm
arch-chroot /mnt sudo -u mrcz yay -S picom-tryone-git --noconfirm

# installing oh-my-zsh
arch-chroot /mnt sudo -u mrcz curl -O https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh && chmod +x install.sh && RUNZSH=no ./install.sh && rm ./install.sh

# installing pi theme for zsh
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "wget -O /home/mrcz/.oh-my-zsh/themes/pi.zsh-theme https://raw.githubusercontent.com/tobyjamesthomas/pi/master/pi.zsh-theme"

# installing vundle
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/.vim
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/.vim/bundle
arch-chroot /mnt sudo -u mrcz git clone https://github.com/VundleVim/Vundle.vim.git /home/mrcz/.vim/bundle/Vundle.vim

# installing fonts
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/fonts_tmp_folder
arch-chroot /mnt sudo -u mrcz sudo mkdir /usr/share/fonts/OTF/
# material icons
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "cd /home/mrcz/fonts_tmp_folder && wget -O materialicons.zip https://github.com/google/material-design-icons/releases/download/3.0.1/material-design-icons-3.0.1.zip && unzip materialicons.zip"
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "sudo cp /home/mrcz/fonts_tmp_folder/material-design-icons-3.0.1/iconfont/MaterialIcons-Regular.ttf /usr/share/fonts/TTF/"
# removing fonts tmp folder
arch-chroot /mnt sudo -u mrcz rm -rf /home/mrcz/fonts_tmp_folder

# installing config files
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/GitHub
arch-chroot /mnt sudo -u mrcz git clone https://github.com/ilbuonmarcio/mrczlnks /home/mrcz/GitHub/mrczlnks
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "chmod 700 /home/mrcz/GitHub/mrczlnks/install_configs.sh"
arch-chroot /mnt sudo -u mrcz /bin/zsh -c "cd /home/mrcz/GitHub/mrczlnks && ./install_configs.sh"

# create folder for screenshots
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/Screenshots

# create pictures folder, secrets folder and moving default wallpaper
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/Pictures/
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/.secrets/
arch-chroot /mnt sudo -u mrcz mkdir /home/mrcz/Pictures/wallpapers/

# enable features on /etc/pacman.conf file
arch-chroot /mnt sed -ie 's/#UseSyslog/UseSyslog/g' /etc/pacman.conf
arch-chroot /mnt sed -ie 's/#Color/Color/g' /etc/pacman.conf
arch-chroot /mnt sed -ie 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
arch-chroot /mnt sed -ie 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf

# enabling https, http as per default configuration for public zone for firewalld
arch-chroot /mnt systemctl start firewalld.service
arch-chroot /mnt firewall-cmd --add-service=http --permanent
arch-chroot /mnt firewall-cmd --add-service=https --permanent
arch-chroot /mnt firewall-cmd --change-interface=docker0 --zone=trusted --permanent

# enable firefox accelerated/webrender mode for quantum engine use
arch-chroot /mnt zsh -c 'echo "MOZ_ACCELERATED=1" >> /etc/environment'
arch-chroot /mnt zsh -c 'echo "MOZ_WEBRENDER=1" >> /etc/environment'

# unmounting all mounted partitions
umount -R /mnt

# syncing disks
sync

echo ""
echo "INSTALLATION COMPLETE! enjoy :)"
echo ""

sleep 3
