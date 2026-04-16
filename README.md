# aria-skills

A Claude Code plugin marketplace for Aria, a video game set in an original fantasy world. Contains plugins that provide skills, agents, and tools to support game development workflows.

## Plugins

- **[aria-lore](plugins/aria-lore)** — Image generation and lore production tools. Helps scaffold characters, items, locations, and visual style guides.
- **[unity-claude-skills](plugins/unity-claude-skills)** — Unity development skills for working with Unity 6 and C#.

## Prerequisites

Some plugins require external tools. See each plugin's own documentation for specific setup instructions.

### aria-lore

The image generation scripts require the following tools on your PATH:

- **curl** — HTTP requests to the Gemini API
- **jq** — JSON processing
- **base64** — encoding images for API payloads (part of coreutils)
- **cwebp** — PNG to WebP conversion (part of libwebp)

You also need a `GEMINI_API_KEY` environment variable set to a billing-enabled Google AI API key.

#### Linux

If you have Nix installed, run `nix develop` from this directory to get a shell with all dependencies available, including `cwebp` and the plugin scripts on your PATH:

```sh
nix develop github:cdata/agent-skills/main
```

#### macOS

```sh
brew install curl jq coreutils webp
```

#### Windows (WSL)

These scripts require a bash environment. On Windows, use WSL (Windows Subsystem for Linux).

From within your WSL distribution:

```sh
sudo apt update
sudo apt install curl jq coreutils webp
```

Verify everything is available:

```sh
curl --version
jq --version
cwebp -version
echo "ok" | base64
```
