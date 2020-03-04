# Luzifer / arch-update

Have you ever looked for an alternative to the `unattended-upgrades` package on Ubuntu in Archlinux to update your server while not moving only one finger? If so you've been told that's a very bad idea as so many things can go wrong. Those people telling you this are right: Much can go wrong.

So if anything goes wrong on your machine when using this: Don't blame me! I've warned you! But in case you don't give a damn about this like me because you have proper backups in place, your provisioning will take like 10 minutes to get everything back up working and are lazy like me this might be something you can use…

## Usage

```console
# arch_update -h
Escalating to root...
Usage: arch_update [-nrs]
    -n  Dry-Run: Do nothing except looking for updates
    -r  Reboot: In case packages flagged for reboot are updated, reboot after update
    -s  Services Restart: Restart all systemd services matching updated package names


# arch_update -nsr
Escalating to root...
[Wed 04 Mar 2020 11:44:35 PM CET] Starting arch_update on workwork02: dry-run enabled, reboot enabled, service-restart enabled
[Wed 04 Mar 2020 11:44:35 PM CET] Collecting packages...
[Wed 04 Mar 2020 11:44:36 PM CET] Nothing to do, exiting now.
```
