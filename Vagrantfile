Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "opencode"
  config.vm.network "private_network", ip: "192.168.56.120"
  config.vm.network "public_network", bridge: "eth0", ip: "192.168.1.10"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
    vb.name = "opencode"
  end

  # Copy dotfiles
  config.vm.provision "file", source: "dotfiles/.bashrc", destination: "~/.bashrc"
  config.vm.provision "file", source: "dotfiles/.tmux.conf", destination: "~/.tmux.conf"
  config.vm.provision "file", source: "dotfiles/.vimrc", destination: "~/.vimrc"
  config.vm.provision "file", source: "scripts/tmux-sessionizer", destination: "~/.local/bin/tmux-sessionizer"

  # Setup directories
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    mkdir -p ~/.local/bin
    chmod +x ~/.local/bin/tmux-sessionizer
  SHELL

  # Install utilities and Node.js
  config.vm.provision "shell", path: "scripts/setup-utilities.sh"

  # Install OpenCode
  config.vm.provision "shell", privileged: false, path: "scripts/install-opencode.sh"

  # Copy OpenCode agent configs
  config.vm.provision "file", source: "opencode-config/agent", destination: "~/.config/opencode/agent"
end
