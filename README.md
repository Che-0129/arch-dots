# Arch Linuxインストール
## 日本語キーボード読み込み
```
# loadkeys jp106
```

## Wi-Fi接続
```
# iwctl station wlan0 connect <SSID> -P <password>
```

## パーティション切り
```
# sgdisk -Z /dev/nvme0n1
# sgdisk -n 1::+1G -n 2:: -t 1:ef00 -c 1:"EFI system partition" -c 2:"Linux filesystem" /dev/nvme0n1
```

## フォーマット
```
# mkfs.fat -F 32 /dev/nvme0n1p1
# mkfs.btrfs /dev/nvme0n1p2
```

## サブボリューム作成
```
# mount /dev/nvme0n1p2 /mnt
# btrfs su c /mnt/@{home,root}
# umount /mnt
```

## マウント
```
# mount -o compress=zstd:1,noatime,space_cache=v2,subvol=@root /dev/nvme0n1p2 /mnt
# mount -m -o dmask=0077,fmask=0077 /dev/nvme0n1p1 /mnt/boot
# mount -m -o compress=zstd:1,noatime,space_cache=v2,subvol=@home /dev/nvme0n1p2 /mnt/home
```

## スワップファイル作成
```
# btrfs fi m -s 4g -U clear /mnt/swapfile
# swapon /mnt/swapfile
```

## reflector
```
# reflector -c Japan -a 24 --sort rate --save /etc/pacman.d/mirrorlist
```

## ベースシステムインストール
```
# pacstrap -Ki /mnt amd-ucode base{,-devel} btrfs-progs fish linux-{zen,firmware-{amdgpu,realtek}} neovim iwd
```

## fstab生成
```
# genfstab -U /mnt >> /mnt/etc/fstab
```

## pacstrapでインストールしたシステムに入る
```
# arch-chroot /mnt /bin/fish
```

## タイムゾーン設定
```
# ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# hwclock -w
```

## locale.genのやつ
```
# echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
# echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen
# locale-gen
```

## 使用言語、キーボードの設定
```
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo KEYMAP=jp106 > /etc/vconsole.conf
```

## ホストネーム設定
```
# echo ArchLinux > /etc/hostname
```

## pacmanの設定
```
# nvim /etc/pacman.conf
```
`# Color`と`# VerbosePkgLists`をアンコメントし`ILoveCandy`を追加。`[multilib]`セクションもアンコメント

## makepkgの設定
```
# nvim /etc/makepkg.conf
```
`OPTIONS=(strip ... debug lto)`の`debug`を`!debug`に変更

## mkinitcpioの設定
```
# nvim /etc/mkinitcpio.conf
```
`HOOKS=(...)`を`HOOKS=(base udev autodetect microcode keymap block filesystems)`に書き換える

## mkinitcpio生成
```
# mkinitcpio -P
```

## systemd-bootをインストール
```
# bootctl install
```

## `/boot/loader/entries/zen.conf`を作成し以下を書き込む
```
title Arch Linux (linux-zen)
linux /vmlinuz-linux-zen
initrd /initramfs-linux-zen.img
options root=/dev/nvme0n1p2 rootflags=subvol=@root rw sysrq_always_enabled=1
```

## iwdとsystemd-homed, systemd-resolvedを有効化
```
# systemctl enable iwd systemd-{hom,resolv}ed
```

## visudoの設定
```
# EDITOR=nvim visudo
```
以下２つをアンコメント

`# Defaults env_keep += "HOME"`

`# %wheel ALL=(ALL:ALL) NOPASSWD: ALL`

以下２つを追加

`Defaults env_keep += "EDITOR"`

`Defaults env_keep += "VISUAL"`

## rootのパスワードを作成
```
# passwd
```

## `exit`でchrootを抜け、`poweroff`で電源を落としインストールメディアを抜き、起動したらrootでログイン

## 非rootユーザー作成
```
# homectl -G wheel --shell=$(which fish) --storage=subvolume create <username>
```

## `exit`して、作成したユーザーにログインしたらネットに接続し、resolv.confのシンボリックリンクを作成
```
$ iwctl station wlan0 connect <SSID> -P <password>
$ sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

## パーミッションの問題を防ぐため一度非rootユーザーでNeovimを起動
```
$ nvim
```

## iwdの設定を追加(`/etc/iwd/main.conf`)
```
[General]
EnableNetworkConfiguration=true

[Network]
EnableIPv6=true
NameResolvingService=systemd
```

## systemd-resolvedのDNSサーバーを変更(`/etc/systemd/resolved.conf`)
```
[Resolve]
DNS=8.8.8.8 8.8.4.4
```

## 再起動
```
$ sudo reboot
```

## XDGユーザーディレクトリの作成
```
$ sudo pacman -Syyu xdg-user-dirs
$ xdg-user-dirs-update
```

## yayをインストール
```
$ sudo pacman -S git
$ git clone https://aur.archlinux.org/paru-bin.git
$ cd paru-bin
$ makepkg -si
```

## 色々インストール(Hyprland)
```
$ sudo pacman -S 7zip {firefox,thunderbird}{,-18n-ja} {un,}zip android-tools archlinux-wallpaper aria2 bat eza fcitx5-im foot gimp gopsuinfo hypr{idle,land,lock,paper,polkitagent,shot} less mako noto-fonts-{cjk,emoji,extra} npm nwg-{clipman,drawer,hello,look,panel} ouch pipewire-pulse rustup steam telegram-desktop trash-cli uwsm wqy-zenhei xdg-desktop-portal-hyprland yazi
$ paru -S {payload-dumper-go,proton-ge-custom,xremap-hypr}-bin arc-{gtk,icon}-theme discord_arch_electron fcitx5-{mozc-ut,skin-arc} ttf-hackgen
```

## dotfiles
```
$ git clone https://github.com/Che-0129/arch-dots
$ chmod +x arch-dots/install.sh
$ bash arch-dots/install.sh
```

## 一般ユーザーでNeovimを起動してプラグインをインストール
```
$ nvim
```

## /etc/locale.confを`LANG=en_US.UTF-8`から`LANG=ja_JP.UTF-8`に書き換え再起動

## Hyprland (uwsm)を選択しログイン後Hyprland系のデーモンを有効化
```
$ systemctl --user enable --now hypr{idle,paper,polkitagent}.service
```
