# == MY ARCH SETUP INSTALLER == #
#part1
printf '\033c'
echo "Welcome to my fork of bugswriter's arch installer script"

loadkeys pl
timedatectl set-ntp true
lsblk

echo "Enter the drive: "
read drive

cfdisk $drive 
echo "Enter root partition: "
read partition
mkfs.ext4 $partition 
echo "Enter swap partition"
read swappartition
mkswap $swappartition
echo "Enter efi partition"
read efipartition
mkfs.fat -F 32 $efipartition

mount $partition /mnt 
swapon $swappartition
mkdir -p /mnt/boot/efi
mount $efipartition /mnt/boot/efi

pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

sed '1,/^#part2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit 

#part2
printf '\033c'
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=pl" > /etc/vconsole.conf
echo "Hostname: "
read hostname
echo $hostname > /etc/hostname

echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
echo "0.0.0.0         tiktok.com" >> /etc/hosts
passwd

pacman -S grub efibootmgr os-prober

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S xorg-server xorg-xinit \
     noto-fonts noto-fonts-emoji qbittorrent  \
     mpv ffmpeg neofetch thunar flameshot \
     nitrogen picom python-pywal htop \
     zip unzip unrar youtube-dl discord \
     dosfstools ntfs-3g git pipewire pulseaudio \
     vim networkmanager sed i3 kitty firefox nvidia nvidai-settings

systemctl enable NetworkManager.service 
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/bash $username
passwd $username
echo "Pre-Installation Finish Reboot now"
ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit 

#part3
printf '\033c'
cd $HOME
git clone https://github.com/linuxdotexe/nordic-wallpapers
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd
yay -Sy spotify cava
exit
