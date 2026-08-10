## Quick Start

Run OpenCode in a preconfigured Ubuntu 22.04 VM. Install [Vagrant](https://developer.hashicorp.com/vagrant/install) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) first.

```bash
git clone https://github.com/rh33t/opencode-vm.git
cd opencode-vm
mkdir -p projects
vagrant up
vagrant ssh
```

Inside the VM:

```bash
cd /vagrant/projects
opencode auth login # skip if you want to use OpenCode free models.
opencode
```

Put local repositories in `projects/` before starting OpenCode. For example, a host directory at `projects/my-app` is available in the VM at `/vagrant/projects/my-app`.

Start OpenCode from the repository you want it to work on:

```bash
cd /vagrant/projects/my-app
opencode
```

## Bundled skills

OpenCode discovers three bundled skills and loads them when a prompt matches:

```text
Help me decide what to enumerate next on this HTB box.
Turn recon.txt into a concise Obsidian note.
Teach me how tcache poisoning works.
```

These prompts load `box-mentor`, `obsidian-notes`, and `sec-tutor`, respectively.

## VM commands

Run these from this repository on the host:

```bash
vagrant up        # Create or resume the VM
vagrant ssh       # Connect to it
vagrant provision # Apply configuration changes
vagrant halt      # Stop it
vagrant destroy   # Delete it
```

SSH sessions open in tmux automatically. Use `Ctrl-s d` to detach. Press `Ctrl-f` at the shell to select a directory under `/vagrant/projects` and open its tmux session.

## Important notes

- `/vagrant` is shared with the host. OpenCode changes made there also change the host files.
- Files outside `/vagrant` exist only in the VM. `vagrant destroy` removes them, including saved provider credentials.
- Provisioning installs Node.js LTS and terminal utilities.
- The VM uses 2 GB of memory, 2 CPUs, and the private IP `192.168.56.120`.
- The shell and tmux config target `tmux-256color` and assume you're working inside tmux. Terminfo for other terminal emulators (`foot`, `kitty`, etc.) isn't installed on the guest, so if your host terminal forwards a non-standard `TERM` over SSH, tmux can fail to start with a "missing or unsuitable terminal" error. Override it if that happens: `TERM=xterm-256color vagrant ssh`.
