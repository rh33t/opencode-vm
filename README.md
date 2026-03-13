# OpenCode VM Setup

Built to make **[OpenCode](https://opencode.ai/)** by [Anomaly](https://github.com/anomalyco) easier to use in daily workflow. The agent feature streamlines tasks like writing cybersecurity notes, analyzing code, or using **[0xdf's HTB AI Mentor](https://gitlab.com/0xdf/htb-ai-mentor)** for Hack The Box — without constantly copy-pasting prompts.

## Why a VM?

AI agents execute arbitrary commands, read/write files, and make network requests — that's the whole point, but it also means **they should never run directly on your host machine**. This setup solves that by spinning up an isolated **Ubuntu VM** with OpenCode pre-configured and a **bind-mounted `projects` folder** for easy file access. Prompts are converted into `agents` for cleaner integration.

The VM is the sandbox. Let it do the dirty work.

## Usage
```bash
vagrant up
vagrant ssh
```
