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
# btrfs subvolume create /mnt/@{,var_log,var_pkg,home}
# umount /mnt
```

## マウント

```
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@ /dev/nvme0n1p2 /mnt
# mkdir -p /mnt/{boot,var/log,var/cache/pacman/pkg,home}
# mount /dev/nvme0n1p1 /mnt/boot
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@var_log /dev/nvme0n1p2 /mnt/var/log
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@var_pkg /dev/nvme0n1p2 /mnt/var/cache/pacman/pkg
# mount -o noatime,compress=zstd:1,space_cache=v2,subvol=@home /dev/nvme0n1p2 /mnt/home
```

## ベースシステムインストール

```
# pacstrap -K -P -i /mnt base base-devel linux-{zen,zen-headers,firmware} amd-ucode btrfs-progs dosfstools neovim networkmanager fish
```

## スワップファイル作成(2GiB)
```
# btrfs subvolume create /mnt/@swap
# btrfs filesystem mkswapfile --size 2g --uuid clear /mnt/@swap/swapfile
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

## mkinitcpioの設定を編集(HOOKS=(...)の中の`base udev`を`systemd`に置き換え、`consolefont` `fsck`を削除)
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
$ yay -S  hypr{land,paper,idle,lock}-git  xdg-desktop-portal-hyprland-git
$ sudo pacman -S mako waybar wofi lxsession-gtk3 foot noto-fonts-{cjk,emoji,extra} arc-{gtk,icon}-theme nwg-look ly pipewire-pulse
$ sudo pacman -S ranger zip unzip atool npm eza bat less snapper brightnessctl archlinux-wallpaper
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
### 設定ファイル作成
```
 $ sudo snapper -c root create-config /
 $ sudo snapper -c home create-config /home
```

`/etc/snapper/configs/`配下の`root` `home`を編集
```
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="4"
TIMELINE_LIMIT_DAILY="8"
TIMELINE_LIMIT_WEEKLY="1"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_QUARTERLY="0"
TIMELINE_LIMIT_YEARLY="0"
```

### タイマー有効化
```
$ sudo systemctl enable snapper-cleanup.timer
```

## 入力メソッドインスコ
```
$ yay -S fcitx5-im fcitx5-mozc-ut fcitx5-skin-arc
```
