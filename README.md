Base setup to allow vagrant to use docker as a provider.
Replaces systemd to allow the container to stay up after creation.

Based on information in [this blog post](https://betterprogramming.pub/managing-virtual-machines-under-vagrant-on-a-mac-m1-aebc650bc12c)

Includes a fork of [this repo](https://github.com/gdraheim/docker-systemctl-replacement) as a submodule which handles the replacement of systemd.
