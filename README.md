# Arch Linux 最小インストール
日本語キーボード読み込み

`loadkeys jp106`

Wi-Fi接続

`iwctl station wlan0 connect TP-Link_079E`

パーティション切り（お好みで）

`gdisk /dev/sda`

フォーマット（例）

```
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
```
