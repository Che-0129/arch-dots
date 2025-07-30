# Arch Linux 最小インストール
## 日本語キーボード読み込み

```
# loadkeys jp106
```

## Wi-Fi接続

```
# iwctl station wlan0 connect {SSID} -P {password}
```

## パーティション切り(boot 1GiB, サブボリューム用 残り全部)

```
# gdisk /dev/nvme0n1
```

## フォーマット

```
# mkfs.vfat -F32 /dev/nvme0n1p1
# mkfs.btrfs -f /dev/nvme0n1p2
```

## サブボリューム作成
```
# mount /dev/nvme0n1p2 /mnt
# btrfs su c /mnt/@{,home}
# umount /mnt
```

## マウント

```
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@ /dev/nvme0n1p2 /mnt
# mkdir /mnt/{boot,home}
# mount /dev/nvme0n1p1 /mnt/boot
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@home /dev/nvme0n1p2 /mnt/home
```

## pacmanの設定
```
# vim /etc/pacman.conf
```
`# ParallelDownloads = 5`をアンコメント

## reflector
```
# reflector -c Japan -a 24 --sort rate --save /etc/pacman.d/mirrorlist
```

## ベースシステムインストール

```
# pacstrap -Ki /mnt amd-ucode base{,-devel} btrfs-progs dosfstools fish linux-{zen{,-headers},firmware} neovim networkmanager
```

## スワップファイル作成(4GiB)
```
# btrfs su c /mnt/@swap
# btrfs fi m -s 4g -U clear /mnt/@swap/swapfile
# chmod 600 /mnt/@swap/swapfile
# swapon /mnt/@swap/swapfile
```

## fstab生成

```
# genfstab -U /mnt >> /mnt/etc/fstab
```

## pacstrapでインストールしたシステムに入る

```
# arch-chroot /mnt /bin/fish
```

## locale.genのやつ

```
# echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
# echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen
```

## ロケール生成

```
# locale-gen
```

## 使用言語、キーボードの設定

```
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo KEYMAP=jp106 > /etc/vconsole.conf
```

## タイムゾーン設定

```
# ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# hwclock -w
```

## ホストネーム設定

```
# echo {hostname} > /etc/hostname
```

## NetworkManager有効化
```
# systemctl enable NetworkManager
```

## systemd-bootをインストール

```
# bootctl install
```

## /boot/loader/entries/zen.confに以下を追記

```
title Arch Linux (linux-zen)
linux /vmlinuz-linux-zen
initrd /amd-ucode.img
initrd /initramfs-linux-zen.img
options root=/dev/nvme0n1p2 rootflags=subvol=@ rw sysrq_always_enabled=1
```

## /boot/loader/loader.confの`#timeout 3`をコメントアウト
```
# nvim /boot/loader/loader.conf
```

## rootユーザーのパスワードを変更
```
# passwd
```

## 非rootユーザー作成
```
# useradd -m -G wheel -s $(which fish) {username}
# passwd {username}
```

## visudoの設定
```
# EDITOR=nvim visudo
```

`# Defaults env_keep += "HOME"`

`# %wheel ALL=(ALL:ALL) NOPASSWD: ALL`

上記２つをアンコメント

`Defaults env_keep += "EDITOR"`

`Defaults env_keep += "VISUAL"`

上記２つを追加

## pacmanの設定
```
# nvim /etc/pacman.conf
```
`# Color`と`# ParallelDownloads = 5`をアンコメントし`ILoveCandy`を追加。extraリポジトリの部分もアンコメント

## makepkgの設定
```
# nvim /etc/makepkg.conf
```
`OPTIONS=(strip ... debug lto)`の`debug`を`!debug`に変更

## mkinitcpioの設定
```
# nvim /etc/mkinitcpio.conf
```
`HOOKS=(...)`内の`base udev`を`systemd`に置き換え`fsck`を削除

## mkinitcpio生成
```
# mkinitcpio -P
```

## `exit`でchrootを抜け、`poweroff`で電源を落としインストールメディアを抜き再度起動

## 再起動後ログインし、`nmtui`でネットに接続

## ユーザーディレクトリの作成
```
$ sudo pacman -S xdg-user-dirs
$ LC_ALL=C.UTF-8 xdg-user-dirs-update --force
```

## yayをインストール
```
$ sudo pacman -S git
$ git clone https://aur.archlinux.org/yay-bin.git
$ cd yay-bin
$ makepkg -si
```

## 色々インストール(Hyprland)
```
$ sudo pacman -S 7zip {firefox,thunderbird}{,-18n-ja} {un,}zip archlinux-wallpaper bat btop eza fcitx5-im foot gimp gopsuinfo hypr{idle,land,lock,polkitagent,shot} less mako noto-fonts-{cjk,emoji,extra} npm nwg-{clipman,drawer,hello,look,panel} ouch pipewire-pulse rustup steam trash-cli udisks2 uwsm vlc{,-plugin-ffmpeg} wqy-zenhei xdg-desktop-portal-hyprland yazi
$ yay -S arc-{gtk,icon}-theme discord_arch_electron fcitx5-{mozc-ut,skin-arc} proton-ge-custom-bin rtw88-dkms-git ttf-hackgen xremap-hypr-bin
```

## dotfiles
```
$ git clone https://github.com/Che-0129/arch-dots
$ chmod +x arch-dots/install.sh
$ bash arch-dots/install.sh
```

## /etc/locale.confを`LANG=en_US.UTF-8`から`LANG=ja_JP.UTF-8`に書き換え再起動
