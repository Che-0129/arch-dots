#!/bin/bash
mv -f ./config/* ~/.config/
bash ./xremap-setup.sh
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
