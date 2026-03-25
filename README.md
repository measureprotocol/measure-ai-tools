# measure-ai-tools

Shared AI resources for the Measure team — skills, context documents, and prompt templates designed to be used with AI tools like Claude Code, Claude.ai, and ChatGPT.

## What's in here

### `skills/`
Claude Code slash commands. These are reusable, invokable workflows baked into `.md` files. Copy or symlink them into your local `~/.claude/skills/` directory to use them as `/skill-name` commands in Claude Code.

### `context/`
Reference documents designed to be dropped into an AI conversation to give it accurate knowledge about Measure's systems. Use these when you need an AI to understand our data models, API schemas, component specs, or platform conventions — without having to explain everything from scratch.

### `prompts/`
Reusable prompt templates for recurring tasks that don't rise to the level of a full skill.

---

## Usage by tool

**Claude Code** — symlink `skills/` files into `~/.claude/skills/` for global slash command access. Reference context docs in a project's `CLAUDE.md` using `@path` includes.

**Claude.ai (web/desktop)** — upload context docs to a shared Measure [Claude Project](https://claude.ai) so they're permanently available to the whole team.

**ChatGPT** — paste context docs manually, or bake them into a Custom GPT system prompt.

---

## Adding to this repo

- **New skill?** Add a `.md` file to `skills/` following the existing format. Include what the skill does, what inputs it expects, and any API or system knowledge it needs.
- **New context doc?** Add a `.md` file to `context/`. Keep it focused on a single system or domain. Aim for something an AI can read and immediately use — not a doc written for humans.
- **New prompt template?** Add to `prompts/` with a short description at the top of the file.
