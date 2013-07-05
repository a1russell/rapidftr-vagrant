# This file is for running the RapidFTR Rails development virtual machine.
# For instructions, see
# https://github.com/rapidftr/RapidFTR/wiki/Using-a-VM-for-development
# For documentation on this file format, see
# http://vagrantup.com/docs/vagrantfile.html
Vagrant::Config.run do |config|
  config.vm.box = "rapid_ftr_rails"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

  config.vm.provision :puppet do |puppet|
    puppet.facter = {
      'osfamily' => 'debian'
    }
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "base.pp"
    puppet.module_path = "modules"
    puppet.options = %w[ --libdir=\\$modulepath/rbenv/lib ]
  end
end
