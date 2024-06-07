# Arch Linux 最小インストール
日本語キーボード読み込み

```
# loadkeys jp106
```

Wi-Fi接続

```
# iwctl station wlan0 connect {SSID}
```

パーティション切り(boot, root, homeを作成)

```
# gdisk /dev/nvme0n1
```

フォーマット（例）

```
# mkfs.vfat -F32 /dev/nvme0n1p1
# mkfs.btrfs -f /dev/nvme0n1p2
# mkfs.btrfs -f /dev/nvme0n1p3
```

マウント（例）

```
# mount -o compress=zstd:1 /dev/nvme0n1p2 /mnt
# mount --mkdir /dev/nvme0n1p1 /mnt/boot
# mount -o compress=zstd:1 --mkdir /dev/nvme0n1p3 /mnt/home
```

ベースシステムインストール（カーネルはお好みのものを）

```
# pacstrap /mnt base base-devel linux-zen linux-headers linux-firmware amd-ucode btrfs-progs dosfstools neovim networkmanager fish
```

スワップファイル作成(1GiB)
```
# btrfs subvolume create /mnt/swap
# btrfs filesystem mkswapfile --size 1g --uuid clear /mnt/swap/swapfile
# chmod 600 /mnt/swap/swapfile
# swapon /mnt/swap/swapfile
```

fstab生成

```
# genfstab -U /mnt >> /mnt/etc/fstab
```

pacstrapでインストールしたシステムに入る

```
# arch-chroot /mnt
```

locale.gen編集（en_US.UTF-8とja_JP.UTF-8をアンコメント）

```
# nvim /etc/locale.gen
```

ロケール生成

```
# locale-gen
```

使用言語、キーボードの設定

```
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo KEYMAP=jp106 > /etc/vconsole.conf
```

タイムゾーン設定

```
# ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# hwclock --systohc --utc
```

ホストネーム設定

```
# echo {hostname} > /etc/hostname
```

NetworkManager有効化
```
# systemctl enable NetworkManager
```

systemd-bootをインストール

```
# bootctl install
```

/boot/loader/entries/zen.confに以下を追記

```
title Arch Linux (linux-zen)
linux /vmlinuz-linux-zen
initrd /amd-ucode.img
initrd /initramfs-linux-zen.img
options root=/dev/nvme0n1p2 rw sysrq_always_enabled=1
```

rootユーザーのパスワードを変更

```
# passwd
```

非rootユーザー作成
```
# useradd -m -G wheel -s $(which fish) {username}
# passwd {username}
```

visudoの設定
```
# EDITOR=nvim visudo
```

`# Defaults env_keep += "HOME"`

`# %wheel ALL=(ALL:ALL) NOPASSWD: ALL`

上記２つをアンコメント

`Defaults env_keep += "EDITOR"`

`Defaults env_keep += "VISUAL"`

上記２つを追加

`exit`でchrootを抜け、`poweroff`で電源を落としインストールメディアを抜き再度起動

再起動後ログインし、`nmtui`でネットに接続

ユーザーディレクトリの作成
```
$ sudo pacman -S xdg-user-dirs
$ LC_ALL=C.UTF-8 xdg-user-dirs-update --force
```

yayをインストール
```
$ sudo pacman -S git
$ git clone https://aur.archlinux.org/yay.git
$ cd yay
$ makepkg -si
```

色々インストール
```
$ yay -S ttf-hackgen
$ yay -S swayfx swaybg archlinux-wallpaper xdg-desktop-portal-wlr pulseaudio pavucontrol lxsession-gtk3 mako waybar wofi pcmanfm-gtk3 gvfs foot noto-fonts-{cjk,emoji,extra} ly lsd
```

デスクトップマネージャ有効化
```
$ sudo systemctl enable ly.service
```

/etc/locale.confを`LANG=en_US.UTF-8`から`LANG=ja_JP.UTF-8`に書き換え再起動
