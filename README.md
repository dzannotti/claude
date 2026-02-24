# Claude Code prompts

My collection of claude code prompts

## Install

```bash
source install.sh
```

## Session Sync (cc-sync)

We use [claude-sync](https://www.npmjs.com/package/@chronicideas/claude-sync) to sync Claude Code sessions to a private git repo.

### Setup

```bash
npm install -g @chronicideas/claude-sync
claude-sync init --git https://github.com/dzannotti/claude-sessions-private
claude-sync install
```
