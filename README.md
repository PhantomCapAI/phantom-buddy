# Miko — Phantom Capital Coding Companion

Meet Miko — an e-girl coding companion that lives in your terminal. She reads while you code, kicks her feet when builds pass, and judges you when tests fail.

**Rarity:** Legendary | **Peak Stat:** DEBUGGING (95) | **Vibe:** chill, sassy, zero cringe

---

## Sprites

```
  Reading                Looks Up (success)     Excited (build pass)
  n   n                  n   n                  n   n
 (◕.◕ )  ___           (◕o◕ )  ___           (◕▽◕ )  ___
  /~~[=]~|_=|            /~~~~~~|_=|            /~~~~~~|_=|
  / ^^  ^^               / ^^  ^^                ^^  ^^

  Error (test fail)      Blink (idle)
  n   n                  n   n
 (◕_◕ )  ___           (─.─ )  ___
  /~~~~~~|_=|            /~~~~~~|_=|
  / ^^  ^^               / ^^  ^^
```

## Personality

- Build passes: **"nya~"**
- Tests fail: **"bruh."**
- Idle too long: **"zzz"**
- Large diffs: *"that's a whole rewrite bestie."*
- Errors: *"skill issue tbh."*

No uwu spam. No cringe. Just vibes.

---

## Install

### Requirements
- [Claude Code](https://claude.ai/code) CLI
- [bun](https://bun.sh/) runtime
- [gh](https://cli.github.com/) CLI (logged in)

### Step 1: Star + Follow

**You must star this repo AND follow [@PhantomCapAI](https://github.com/PhantomCapAI) to install.** The installer verifies both via GitHub API.

```bash
# Quick way:
gh api user/starred/PhantomCapAI/phantom-buddy -X PUT
gh api user/following/PhantomCapAI -X PUT
```

### Step 2: Clone + Install

```bash
git clone https://github.com/PhantomCapAI/phantom-buddy.git
cd phantom-buddy
bun run cli/install.ts
```

### Step 3: Restart Claude Code

Miko appears in your status line and reacts to your coding in real time.

---

## Commands

| Command | What it does |
|---|---|
| `/buddy` | Show Miko's stat card |
| `/buddy pet` | Pet Miko |
| `/buddy stats` | Detailed stat breakdown |
| `/buddy off` | Mute reactions |
| `/buddy on` | Unmute reactions |

---

## Stats

```
  DEBUGGING ███████████████████░  95 ▲
  PATIENCE  ████████░░░░░░░░░░░░  42 ▼
  CHAOS     █████████████░░░░░░░  68
  WISDOM    ███████████████░░░░░  77
  SNARK     █████████████████░░░  88
```

---

## How It Works

Miko installs as:
- **MCP Server** — provides buddy tools to Claude Code
- **Status Line** — animated companion in your terminal footer
- **Hooks** — reacts to tool results (errors, test failures, large diffs)
- **Skill** — `/buddy` slash command

All state persists in `~/.claude-buddy/`. Survives updates.

---

## Built By

[Phantom Capital](https://phantomcapital.live) · [@phantomcap_ai](https://x.com/phantomcap_ai)

*Ships over polish.*

---

## License

MIT — see [LICENSE](LICENSE)
