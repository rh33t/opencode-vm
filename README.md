# OpenCode VM Setup

I built this to make **[OpenCode](https://opencode.ai/)** by [Anomaly](https://github.com/anomalyco) easier to use in my daily workflow. The tool's agent feature helps me streamline tasks like writing cybersecurity notes, analyzing code, or using **[0xdf's HTB AI Mentor](https://gitlab.com/0xdf/htb-ai-mentor)** for Hack The Box—without constantly copy-pasting prompts.

This spins up an **Ubuntu VM** with OpenCode pre-configured and a **bind-mounted `projects` folder** for easy file access. I converted my prompts into `agents` for cleaner integration.

The VM keeps everything isolated—no mess on the host system, no risk of breaking stuff.


## Usage

```bash
vagrant up
vagrant ssh
```