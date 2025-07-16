#!/bin/bash

rm -rf ~/.config/fish
mv $(cd $(dirname $0) && pwd)/configs/* ~/.config/
sudo mv $(cd $(dirname $0) && pwd)/nwg-hello/* /etc/nwg-hello/
bash $(cd $(dirname $0) && pwd)/xremap-setup.sh

sudo cat << 'EOT' | sudo tee /etc/greetd/config.toml
[terminal]
vt = 1

[default_session]
command = "Hyprland -c /etc/nwg-hello/hyprland.conf"
user = "greeter"
EOT

sudo cat << 'EOT' | sudo tee /etc/systemd/system/disable-USB-wakeup.service
[Unit]
Description=Disable USB wakeup triggers in /proc/acpi/wakeup

[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo XHC0 > /proc/acpi/wakeup"
ExecStop=/bin/sh -c "echo XHC0 > /proc/acpi/wakeup"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl enable {disable-USB-wakeup,greetd}.service
systemctl --user enable hypr{paper,polkitagent,idle}.service
ya pkg add {ndtoan96/ouch,yazi-rs/plugins:full-border}
