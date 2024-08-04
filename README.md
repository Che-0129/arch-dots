# Arch Linux 最小インストール
## 日本語キーボード読み込み

```
# loadkeys jp106
```

## Wi-Fi接続

```
# iwctl station wlan0 connect {SSID}
```

## パーティション切り(boot 512MiB, サブボリューム用 残り全部)

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
# btrfs subvolume create /mnt/@
# btrfs subvolume create /mnt/@{var,home,snapshots}
# umount /mnt
```

## マウント（例）

```
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@ /dev/nvme0n1p2 /mnt
# mkdir /mnt/{boot,var,home,.snapshots}
# mount /dev/nvme0n1p1 /mnt/boot
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@var /dev/nvme0n1p2 /mnt/var
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@home /dev/nvme0n1p2 /mnt/home
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@snapshots /dev/nvme0n1p2 /mnt/.snapshots
```

## ベースシステムインストール（カーネルはお好みのものを）

```
# pacstrap /mnt base base-devel linux-{zen,zen-headers,firmware} amd-ucode btrfs-progs dosfstools neovim networkmanager fish
```

## スワップファイル作成(2GiB)
```
# btrfs filesystem mkswapfile --size 2g --uuid clear /mnt/swapfile
# chmod 600 /mnt/swapfile
# swapon /mnt/swapfile
```

## fstab生成

```
# genfstab -U /mnt >> /mnt/etc/fstab
```

## pacstrapでインストールしたシステムに入る

```
# arch-chroot /mnt /bin/fish
```

## locale.gen編集（en_US.UTF-8とja_JP.UTF-8をアンコメント）

```
# nvim /etc/locale.gen
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
# hwclock --systohc --utc
```

## ホストネーム設定

```
# echo {hostname} > /etc/hostname
```

## NetworkManager有効化
```
# systemctl enable NetworkManager
```

## mkinitcpioの設定を編集(HOOKS=(...)の中の`base udev`を`systemd`に置き換え、`fsck`を削除)
```
# nvim /etc/mkinitcpio.conf
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

## 色々インストール
```
$ yay -S ttf-hackgen xremap-wlroots-bin wlogout ueberzugpp hyprshot clipse batsignal
$ sudo pacman -S hypr{land,paper,idle,lock} xdg-desktop-portal-hyprland brightnessctl archlinux-wallpaper mako waybar wofi lxsession-gtk3 foot noto-fonts-{cjk,emoji,extra} arc-{gtk,icon}-theme nwg-look ly
$ sudo pacman -S pipewire pipewire-pulse wireplumber
$ sudo pacman -S ranger zip unzip atool
$ sudo pacman -S npm eza bat less snapper
```

## dotfiles
```
$ git clone https://github.com/Quasar-0330/arch-dots
$ chmod +x arch-dots/install.sh
$ bash arch-dots/install.sh
```

## ディスプレイマネージャー有効化
```
$ sudo systemctl enable ly.service
```

## /etc/locale.confを`LANG=en_US.UTF-8`から`LANG=ja_JP.UTF-8`に書き換え再起動

## Snapper色々
```
# snapper -c root create-config / (こ↑こ↓はなんか上手くいかなかったから調べてアドリブでやれ)
# snapper -c home create-config /home
# snapper -c var create-config /var
# systemctl enable snapper-{cleanup,timeline}.timer
```

`/etc/snapper/configs/`配下のファイルを編集
```
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="4"
TIMELINE_LIMIT_DAILY="8"
TIMELINE_LIMIT_WEEKLY="1"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"
```

## 更に色々インスコ
```
$ sudo pacman -S firefox firefox-i18n-ja thunderbird thunderbird-i18n-ja
$ sudo pacman -S fcitx5-im
$ yay -S fcitx5-mozc-ut fcitx5-skin-arc
```
