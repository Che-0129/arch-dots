# Arch Linux 最小インストール
日本語キーボード読み込み

```loadkeys jp106```

Wi-Fi接続

```iwctl station wlan0 connect TP-Link_079E```

パーティション切り（お好みで）

```gdisk /dev/sda```

フォーマット（例）

```
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
```

マウント（例）

```
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot
```

ベースシステムインストール（カーネルはお好みのものを）

```
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode neovim dosfstools networkmanager
```

fstab生成（swapファイルを作りたい場合はこれを実行する前に作ってswaponしておくこと）

```
genfstab -U /mnt >> /mnt/etc/fstab
```
