DOMAIN = "example.net"
# IPs' prefix
PREFIP = "192.168.32"

vms = {
  'almalinux'     => {
      'memory' => '512',
      'cpus' => 1, 
      'ip' =>  "#{PREFIP}.2",
      'box' => 'almalinux/9'
  },
 'debian'   => {
      'memory' => '512',
      'cpus' => 1,
      'ip' => "#{PREFIP}.4",
      'box' => 'debian/buster64'
  },
 'fedora'  => {
      'memory' => '512',
      'cpus' => 1, 
      'ip' => "#{PREFIP}.8",
      'box' => 'generic/fedora32'
  },
 'opensuse'  => {
      'memory' => '512',
      'cpus' => 1, 
      'ip' => "#{PREFIP}.16",
      'box' => 'opensuse/Leap-15.4.x86_64'
  },
  'ubuntu'  => {
      'memory' => '512',
      'cpus' => 1, 
      'ip' => "#{PREFIP}.32",
      'box' => 'ubuntu/focal64'
  },
  'windows'   => {
      'memory' => '2048',
      'cpus' => 1, 
      'ip' => "#{PREFIP}.64",
      'box' => 'gusztavvargadr/windows-10'
  }
}

Vagrant.configure('2') do |config|

  vms.each do |name, conf|
    config.vm.box_check_update = false
    # Issue: https://github.com/hashicorp/vagrant/issues/5186
    config.ssh.insert_key = false
    # Increase timeout due Windows box update during boot
    config.vm.boot_timeout = 1200

    config.vm.define "#{name}" do |k|
      k.vm.hostname = "#{name}" #.#{DOMAIN}", don't append the domain
      k.vm.network 'private_network', ip: "#{conf['ip']}"
      k.vm.box = conf['box']

      k.vm.provider 'virtualbox' do |vb|
        vb.memory = conf['memory']
        vb.cpus = conf['cpus']
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
        if "#{name}" == "windows"
          # See what's happenning with Windows box.
          vb.gui = true
        end
      end

      k.vm.provider 'libvirt' do |lv|
        lv.cpus = conf['cpus']
        lv.memory = conf['memory']
        lv.cputopology :sockets => 1, :cores => conf['cpus'], :threads => 1
      end

      # Common provisioning tasks for Linux boxes
      if "#{name}" != "windows"
        k.vm.provision "shell", path: "provision.sh"
        # Shared Ansible folder with the examples
        k.vm.synced_folder "./", "/home/vagrant/ansible", mount_options: ["dmode=755,fmode=644"]
      end
    end
  end
end
