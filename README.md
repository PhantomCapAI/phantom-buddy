# Miko — Your Coding Companion

> E-girl with cat headphones that lives in your terminal. Persistent ASCII status line, reacts to errors and successes, interactive `/buddy` commands. Legendary tier, 95 debugging, zero patience for bad code.

```
                  ╭──────────────────────────╮
                  │ nya~! clean build, nice   │
                  ╰──────────────────────────╯
                    n ╱ n
                   (◕▽◕ )
                  \|♡ |//
                   /~~~~\
                    |  |
                    ^^  ^^
```

**Rarity:** Legendary | **Species:** Miko | **Peak Stat:** DEBUGGING (95) | **Dump Stat:** PATIENCE (42)

---

## What Is This?

Miko is a coding companion for [Claude Code](https://claude.ai/code). She lives in your terminal's status line, watches you code, and reacts in real time with a speech bubble above her head.

She's not a theme. She's not a prompt. She's an MCP server + status line + hooks system that gives Claude Code a persistent, reactive mascot with actual personality.

---

## Sprites

```
  Idle (reading)     Success (hands up)  Error (facepalm)    Blink (arms down)
   n   n              n   n               n   n               n   n
  (◕.◕ )            (◕▽◕ )             (◕_◕ )>            (─.─ )
  ╱|♡ |╲            \|♡ |//              |♡ |               |♡ |
  /~~~~\            /~~~~\              /~~~~\              /~~~~\
   |  |              |  |               |  |                |  |
   ^^  ^^            ^^  ^^              ^^  ^^              ^^  ^^
```

Each sprite is rendered in gold ANSI (`rgb(255,193,7)`) with a speech bubble above showing Miko's current reaction. Arms change per state — reading pose when idle, hands up on success, facepalm on error, arms down when blinking.

---

## Reactions

Miko reacts to what's happening in your session. Her speech bubble rotates randomly from these pools:

### On success / build pass
```
"nya~! clean build, nice"
"told you it would work"
"ez pz"
"ship it bestie"
"another W"
```

### On error / test fail
```
"bruh. read the error"
"skill issue tbh"
"that's not gonna work bestie"
"have you tried not breaking things"
"the stack trace is RIGHT there"
```

### On idle (random rotation)
```
"zzz..."
"*kicks feet*"
"*reading your code*"
"*judges silently*"
"still here btw"
"waiting for you to break something"
```

### On /buddy pet
```
"nya~! ♡"
"don't make it weird"
"*purrs*"
```

---

## Commands

| Command | What it does |
|---|---|
| `/buddy` | Show Miko's full stat card with ASCII art |
| `/buddy pet` | Pet Miko — triggers a pet reaction |
| `/buddy stats` | Show detailed stat breakdown with bars |
| `/buddy rename <name>` | Rename your companion (1-14 chars) |
| `/buddy personality <text>` | Set a custom personality description |
| `/buddy off` | Mute reactions (Miko stays visible) |
| `/buddy on` | Unmute reactions |

---

## Stats

```
╭──────────────────────────────────────╮
│    n   n                             │
│   (◕.◕ )                            │
│    |♡ |                              │
│   /~~~~\                             │
│    ^^  ^^                            │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┤
│ Miko  ★★★★★                         │
│ LEGENDARY miko                       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┤
│ DEB ██████████░  95 ▲                │
│ PAT ████░░░░░░░  42 ▼                │
│ CHA ███████░░░░  68                  │
│ WIS ████████░░░  77                  │
│ SNK █████████░░  88                  │
╰──────────────────────────────────────╯
```

---

## Install

### Requirements
- [Claude Code](https://claude.ai/code) (CLI or desktop app)
- [Bun](https://bun.sh/) runtime
- [gh](https://cli.github.com/) CLI (logged in)

### Option A: npm (recommended)

```bash
npx phantom-buddy install
```

### Option B: Clone

```bash
git clone https://github.com/PhantomCapAI/phantom-buddy.git ~/.claude-buddy/phantom-buddy
cd ~/.claude-buddy/phantom-buddy
bun install
bun run cli/install.ts
```

### Step 2: Star + Follow (required by installer)

```bash
gh api user/starred/PhantomCapAI/phantom-buddy -X PUT
gh api user/following/PhantomCapAI -X PUT
```

### Step 3: Restart Claude Code

Miko appears in your status line and starts reacting immediately.

---

## How It Works

Miko installs four components into Claude Code:

| Component | What it does |
|---|---|
| **MCP Server** | Exposes 8 tools (`buddy_show`, `buddy_pet`, `buddy_stats`, `buddy_react`, `buddy_rename`, `buddy_set_personality`, `buddy_mute`, `buddy_unmute`) + 2 resources |
| **Status Line** | 8-line animated ASCII art with speech bubble, refreshes every 1s |
| **PostToolUse Hook** | Detects errors, test failures, build passes, and large diffs in Bash output — writes reaction to `~/.claude-buddy/reaction.json` |
| **Stop Hook** | Extracts `<!-- buddy: ... -->` HTML comments from Claude's responses and displays them in Miko's speech bubble |
| **Skill** | `/buddy` slash command with subcommand routing |

All state persists in `~/.claude-buddy/`. Survives Claude Code updates.

### Architecture

```
Claude Code
  ├── MCP Server (stdio) ──> buddy tools + resources
  ├── PostToolUse Hook ────> detect errors/success ──> reaction.json
  ├── Stop Hook ───────────> extract <!-- buddy: --> ──> reaction.json
  └── Status Line ─────────> read reaction.json ──> render ASCII + bubble
```

---

## Troubleshooting

```bash
# Run diagnostics
bun run cli/doctor.ts

# Test status line rendering
bun run cli/test-statusline.ts

# Backup/restore state
bun run cli/backup.ts
```

---

## Built By

[Phantom Capital](https://phantomcapital.live) · [@phantomcap_ai](https://x.com/phantomcap_ai)

*Ships over polish.*

---

## License

MIT — see [LICENSE](LICENSE)
