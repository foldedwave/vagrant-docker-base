FROM rockylinux:8
#FROM fedora:latest

ENV container docker
RUN dnf -y update

# Add sshd server so we can 'vagrant ssh' later
ADD https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN dnf -y install openssh-server openssh-clients passwd sudo && \
    mkdir /var/run/sshd && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    useradd --create-home -s /bin/bash vagrant && \
    echo -e "vagrant\nvagrant" | (passwd --stdin vagrant) && \
    echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant && \
    chmod 440 /etc/sudoers.d/vagrant && \
    mkdir -p /home/vagrant/.ssh && \
    chmod 700 /home/vagrant/.ssh && \
    chmod 600 /home/vagrant/.ssh/authorized_keys && \
    chown -R vagrant:vagrant /home/vagrant/.ssh

# Allow public key authentication for 'vagrant ssh' in Fedora 35
#RUN sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/i' /etc/ssh/sshd_config
# This softens a crypto policy that prevents vagrant completing ssh setup
#RUN sed -i 's/^Include \/etc\/crypto-policies\/back-ends\/opensshserver.config/#Include \/etc\/crypto-policies\/back-ends\/opensshserver.config/i' /etc/ssh/sshd_config.d/50-redhat.conf

# As the container isn't normally running systemd, /run/nologin needs to be removed to allow SSH
RUN rm -rf /run/nologin

# Install the replacement systemctl command
RUN yum -y install python3
COPY src/docker-systemctl-replacement/files/docker/systemctl3.py /usr/bin/systemctl
RUN chmod 755 /usr/bin/systemctl

CMD /usr/bin/systemctl
