Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "opencode"
  config.vm.network "private_network", ip: "192.168.56.120"
  # config.vm.network "public_network", ip: "192.168.1.10"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.name = "opencode-box"
  end

  # Setup directories (must run before the file provisioners below: Vagrant's
  # file provisioner does not create missing destination parent directories)
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    mkdir -p ~/.local/bin ~/.config/opencode
    rm -rf ~/.config/opencode/agents
  SHELL

  # Copy dotfiles
  config.vm.provision "file", source: "dotfiles/.bashrc", destination: "~/.bashrc"
  config.vm.provision "file", source: "dotfiles/.tmux.conf", destination: "~/.tmux.conf"
  config.vm.provision "file", source: "dotfiles/.vimrc", destination: "~/.vimrc"
  config.vm.provision "file", source: "tmux-sessionizer", destination: "~/.local/bin/tmux-sessionizer"

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    chmod +x ~/.local/bin/tmux-sessionizer
  SHELL

  # Install utilities, Node.js, and OpenCode
  config.vm.provision "shell", path: "install.sh"

  # Copy OpenCode skills (trailing slash: copy contents, don't nest "skills/" again)
  config.vm.provision "file", source: "skills/", destination: "~/.config/opencode/skills"

end
