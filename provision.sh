VAGRANT_HOME="/home/vagrant"

# PACKAGEs
PKG=$(which dnf || which apt-get || which zypper)

## Update package sources list on Debian OS Family
echo 'PKG: Updating the list of packages...'; $PKG update >/dev/null

echo "PKG: Installing ansible..."
$PKG install -y ansible sshpass wget >/dev/null

# SSH

## Create ssh directory for vagrant user
install -o vagrant -g vagrant  -m 700 -d $VAGRANT_HOME/.ssh

## Suppress banner during ssh login
touch $VAGRANT_HOME/.hushlogin

## Download ssh keys
echo "SSH: Downloading Vagrant insecure key pair..."
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
    -O $VAGRANT_HOME/.ssh/id_rsa.pub >/dev/null
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant \
    -O $VAGRANT_HOME/.ssh/id_rsa >/dev/null
chmod 400 $VAGRANT_HOME/.ssh/id_rsa
echo "SSH: Downloading the Vagrant public key as authorized host..."
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub \
    -O $VAGRANT_HOME/.ssh/authorized_keys >/dev/null
chmod 400 $VAGRANT_HOME/.ssh/authorized_keys

## Write the ssh client configuration for user vagrant
echo "Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    PasswordAuthentication yes
    LogLevel FATAL" > $VAGRANT_HOME/.ssh/config
chmod 644 $VAGRANT_HOME/.ssh/config
## Change the ssh directory owner recursively
chown -R vagrant:vagrant $VAGRANT_HOME/.ssh

## Allow password authentication via SSH
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
