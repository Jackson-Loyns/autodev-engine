![Autodev Engine Banner](screenshots/banner.png)

<div align="center">

# Autodev Engine (Pro Max)
### The Ultimate Autonomous Development Intelligence for AI Agents

[![Release](https://img.shields.io/badge/Release-v1.0.0-blue?style=flat-square)](https://github.com/Jackson-Loyns/autodev-engine/releases)
[![Intelligence](https://img.shields.io/badge/Reasoning_Rules-5_Agents-purple?style=flat-square)](https://github.com/Jackson-Loyns/autodev-engine)
[![Skills](https://img.shields.io/badge/Skills-2_Core-green?style=flat-square)](https://github.com/Jackson-Loyns/autodev-engine)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

[![CLI](https://img.shields.io/badge/CLI-skills.sh-black?style=flat-square&logo=github)](https://skills.sh)
[![Twitter](https://img.shields.io/twitter/follow/JacksonLoyns?style=social)](https://twitter.com/JacksonLoyns)

</div>

---

## ⚡️ Quick Start

**Add Intelligence to Your Agent:**

```bash
npx skills add Jackson-Loyns/autodev-engine
```

That's it. Your agent just gained the ability to plan, implement, test, and review code autonomously.

---

## 🧠 What is Autodev Engine?

**Autodev Engine** is not just a script—it's a **Cognitive Architecture** for AI coding agents. It transforms passive "chatbots" into **Self-Directed Developers** capable of handling complex, multi-file features without constant hand-holding.

Inspired by **Anthropic Effective Harnesses** and **GitHub Spec-Kit**, it enforces a strict **"Orient → Plan → Act → Verify"** loop that eliminates hallucination and context drift.

### Core Intelligence
| Agent | Role | Capabilities |
| :--- | :--- | :--- |
| **Planner** | Principal Architect | Spec-Driven Development, System Design, Phased Execution |
| **Implementer** | Senior Engineer | State-Isolated Coding, Strict Testing, Clean Commits |
| **TDD Guide** | QA Lead | Enforces Red-Green-Refactor, Stops Regression |
| **Reviewer** | Security Auditor | 5-Point Quality Check (Security, Perf, Correctness) |
| **Manager** | Project Manager | Atomic Task Decomposition, Priority Scheduling |

---

## 🛠 Usage Modes

### 1. Skill Mode (Automatic)
The engine runs silently in the background. When you ask for a complex task, the **Decision Matrix** skill automatically routes your request to the appropriate specialized agent (e.g., Planner for new features, Implementer for coding).

### 2. Workflow Mode (Manual)
Take direct control using slash commands:

- `/plan "Build a Stripe integration"` — Architect a full solution.
- `/dev` — Execute the next task in the plan.
- `/claim TASK-001` — Pick a specific ticket.
- `/test` — Run the full verification suite.
- `/review` — Audit the codebase.

---

## 📦 Installation Options

### Option A: Skills.sh (Recommended)
Best for Cursor, Windsurf, and modern agent environments.

```bash
npx skills add Jackson-Loyns/autodev-engine
```

### Option B: Claude Code Plugin
Best for the official Anthropic CLI.

```bash
/plugin marketplace add Jackson-Loyns/autodev-engine
/plugin install autodev-engine@autodev-engine
```

### Option C: Source Code
For contributors and customizers.

```bash
git clone https://github.com/Jackson-Loyns/autodev-engine.git
cd autodev-engine
./install.sh
```

---

## 📂 Project Structure

```
autodev-engine/
├── skills/                # The Core Intelligence (Skills.sh compliant)
│   └── autodev-engine/    # Skill Definitions
├── agents/                # System Prompts (The "Brain")
├── rules/                 # Enforcement Protocols
├── scripts/               # Automation Tools
└── tests/                 # Verification Suite
```

---

<div align="center">
  <sub>Built with ❤️ by Jackson Loyns. Empowering the next generation of AI Developers.</sub>
</div>
