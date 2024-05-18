Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname ="l3-21T2894.cm"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 1
  end
  config.vm.network "private_network", ip: "192.168.56.50"

  # config.vm.provision "shell", path: "install_apache.sh"

  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p ~/.ssh
    # cat /vagrant/web.pub ~/.ssh/
    # cat ~/.ssh/web.pub > ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
    sudo systemctl restart sshd
    sudo mkdir -p /home/vagrant/mon-site
    echo "192.168.56.50    l3-21T2894.cm" >> /etc/hosts
    # sudo cat /vagrant/l3-21T2894.conf > /etc/apache2/sites-available/l3-21T2894.cm.conf
    # sudo a2ensite l3-21T2894.cm.conf
    # sudo systemctl restart apache2
  SHELL

  config.vm.provision "ansible" do |ansible|
    ansible.inventory_path = "/home/patrice/Desktop/INFOL3/SEM2/INF362/EC1/TPE4-21T2894_NEUSSI/inventaire.ini"
    ansible.playbook = "/home/patrice/Desktop/INFOL3/SEM2/INF362/EC1/TPE4-21T2894_NEUSSI/playbook"
    ansible.limit = "all"
  end

end