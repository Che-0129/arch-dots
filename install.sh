#!/bin/bash

rm -rf ~/.config/fish
mv $(cd $(dirname $0) && pwd)/configs/* ~/.config/
bash $(cd $(dirname $0) && pwd)/xremap-setup.sh

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

sudo systemctl enable {disable-USB-wakeup,ly}.service
ya pkg add {ndtoan96/ouch,yazi-rs/plugins:full-border}
