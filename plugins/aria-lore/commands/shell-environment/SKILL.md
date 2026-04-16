---
name: shell-environment
description: Documents the shell commands available to this plugin's skills. Invoke this skill to learn about available commands before using them.
user-invocable: false
---

# Shell Environment

This plugin provides shell scripts in `${CLAUDE_PLUGIN_ROOT}/scripts/`. All
commands below should be invoked using their full path:

```
${CLAUDE_PLUGIN_ROOT}/scripts/<command>
```

**Always invoke these commands inside the sandbox.** All of them — including the
ones that make network requests — are designed to work within the default sandbox
restrictions. Do not disable the sandbox to run them.

## Environment Requirements

- `GEMINI_API_KEY` must be set in the shell environment (required by the image
  generation commands)
- `curl`, `jq`, `base64` must be on PATH
- `cwebp` (from libwebp) must be on PATH — see the plugin README for install
  instructions

## Commands

### `create_image`

Generate an image from a text prompt.

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/create_image <prompt> <output_image> [aspect_ratio] [image_size]
```

- `output_image` is always WebP format
- `aspect_ratio` defaults to `1:1` — options: `1:1`, `2:3`, `3:2`, `3:4`, `4:3`, `4:5`, `5:4`, `9:16`, `16:9`, `21:9`
- `image_size` defaults to `2K` — options: `1K`, `2K`, `4K`

### `modify_image`

Edit an existing image using a text prompt.

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/modify_image <source_image> <prompt> <output_image> [aspect_ratio]
```

- `source_image` can be PNG, WebP, or JPEG (MIME type is auto-detected)
- `output_image` is always WebP format

### `compose_image`

Combine multiple source images into a new image guided by a text prompt.

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/compose_image <prompt> <output_image> <source_image>...
```

- Supports up to 14 source images in PNG, WebP, or JPEG format
- `output_image` is always WebP format

### `extract_image`

*Internal helper* — extracts a base64 image from a Gemini API JSON response and
writes it to a file. Called automatically by `create_image`, `modify_image`, and
`compose_image`. You do not need to invoke this directly.

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/extract_image <json_response_file> <output_file>
```

### `convert_to_webp`

*Internal helper* — converts a PNG file to WebP format. Called automatically by
`create_image`, `modify_image`, and `compose_image`. You do not need to invoke
this directly.

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/convert_to_webp <input_file> <output_file>
```

## Notes

- All image commands handle API calls, response extraction, and format conversion
  internally. The helper scripts (`extract_image`, `convert_to_webp`) are invoked
  automatically via sibling-script resolution and should not need to be called
  directly.
- Runtime dependencies (`curl`, `jq`, `base64`, `cwebp`) must be available on
  PATH. If using Nix, run `nix develop` in the plugin root to get a shell with
  everything pre-configured. Otherwise, install them manually (see the plugin
  README for platform-specific instructions).
