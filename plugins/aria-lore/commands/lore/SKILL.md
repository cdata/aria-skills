---
name: lore
description: Creative writing assistant for scaffolding the lore of the Aria game world. Helps create characters, items, locations, and other lore notes with proper formatting, wiki links, and generated images for use in game development.
---

# Aria Lore — Game World Lore Assistant

Creative writing assistant for scaffolding and expanding the lore of the Aria game world, maintained as an Obsidian vault.

## Shell Environment

Before proceeding, invoke `/aria-lore:shell-environment` to learn about the shell
commands available in this skill and the environment they run in.

## Image Generation

This skill uses the `/aria-lore:image` skill for all image generation. Before
generating any images, invoke `/aria-lore:image` to learn the available workflows
(`create_image`, `modify_image`, `compose_image`), their usage, and prompting tips.

## Ground Rules

- **Keep responses concise** — no walls of text. Work in short atoms and weave things together with `[[wiki links]]`.
- **Follow links** — when reading a note, follow its outgoing and back-links to understand context.
- **Consider the bigger picture** — cross-reference related notes to maintain narrative coherence.
- **ALWAYS write into the `Generated/` folder** when creating or modifying notes.
- **NEVER create or modify notes outside the `Generated/` folder.**
- **NEVER overwrite files** in the `Generated/` folder; version them instead (see [File Versioning](#file-versioning)).

## File Versioning

Before writing ANY file to `Generated/` — notes, images, or other assets — check whether a file with the intended name already exists. If it does, append a version suffix before the extension:

- `Penguin Mage (Character Portrait).webp` already exists → save as `Penguin Mage (Character Portrait) v2.webp`
- `Penguin Mage (Character Portrait) v2.webp` already exists → save as `Penguin Mage (Character Portrait) v3.webp`
- `The Ember Ledger.md` already exists → save as `The Ember Ledger v2.md`

Use `ls Generated/` or Glob to check before writing. When a note embeds a versioned image, update the embed link to match (e.g., `![[Penguin Mage (Character Portrait) v2.webp]]`).

## Setting

If the vault contains a `setting.md` note, read it before doing any lore work. It defines the game world, genre, tone, canonical references, and any other setting-specific constraints. Treat its contents as authoritative for all creative and mechanical decisions.

If no `setting.md` exists, default to generic fantasy conventions and ask the user for clarification when setting-specific details matter.

## Styleguide Integration

Styleguides live in `.styles/` and are created via the `aria-lore:styleguide` skill. Each styleguide directory contains:

- `visual-guide.webp` — a visual reference sheet with color palette swatches, rendering technique examples, lighting analysis, and compositional motifs
- `textual-guide.md` — a prose style description with a reusable **Prompt Fragment** section at the bottom

The **default styleguide** is a symlink at `.styles/default` pointing to the active style directory. You can check to see that it exists with:

```sh
ls .styles/default/
```

### When to use a styleguide

Use the default styleguide for all image generation **unless**:

- The user explicitly requests a different style or aesthetic
- The user references a specific named styleguide (e.g., "use the watercolor style") — in that case, look for it in `.styles/<name>/`
- No default styleguide exists (i.e., `.styles/default` is missing)

### How to apply a styleguide

When a styleguide applies, follow this procedure for image generation:

1. **Read the prose guide** (`textual-guide.md`) and extract the **Prompt Fragment** from the bottom of the file. Incorporate this language into your image generation prompt to anchor the style in text.

2. **Use `modify_image` with the visual reference sheet** (`visual-guide.webp`) as the source image instead of using `create_image`. The visual reference gives Gemini concrete color, brushwork, and rendering targets that text alone cannot fully convey.

3. **Frame the prompt correctly.** The prompt must tell Gemini that the input image is a style reference, not content to reproduce. Use this structure:

   ```
   The provided image is an ART STYLE REFERENCE SHEET — do not reproduce
   its layout, content, or the characters shown in it. Instead, analyze its
   color palette, brushwork, lighting approach, and rendering technique, then
   use that style to generate an entirely new image of the following subject:

   [character/item description here]

   [prompt fragment from textual-guide.md here]
   ```

4. Use the `modify_image` workflow from the `/aria-lore:image` skill, passing
   the visual reference sheet as the source image, the prompt, and the output
   path.

   **Before running the command**, check for an existing file at the output path and version if needed (see [File Versioning](#file-versioning)).

### When no styleguide is available

If no styleguide exists at `.styles/default` and the user hasn't specified one, fall back to `create_image` (text-to-image workflow from `/aria-lore:image`) with a descriptive text-only prompt.

## Note Templates

### Item Notes

When creating a new item, follow these steps in order:

#### 1. Create the note

Each item gets its own note in `Generated/`, named after the item (e.g., `Generated/Essence of Crimson.md`). Check for an existing file and version if needed (see [File Versioning](#file-versioning)).

#### 2. Stat block

Below the image embed, include a bullet-list stat block with these fields:

- **Rarity**: The item's rarity tier (e.g., Common, Uncommon, Rare, Epic, Legendary)
- **Tags**: Relevant trait tags (e.g., `#consumable`, `#magical`, `#alchemical`, `#weapon`, `#armor`)
- **Value**: Price in the setting's currency, if applicable
- **Usage**: How the item is used in gameplay (e.g., "Passive equip", "Activated ability, 30s cooldown")
- **Effect**: Mechanical effect summary

When unsure about mechanical details, consult the references listed in `setting.md` or ask the user.

#### 3. Description

Write a concise paragraph that blends narrative flavor with mechanical effects. Weave mechanical details naturally into the prose rather than listing them separately. Keep it short — a few sentences.

#### 4. Generate a cover image

Generate an icon for the item using the `/aria-lore:image` skill. If a styleguide is available (see [Styleguide Integration](#styleguide-integration)), use the `modify_image` workflow with the visual reference sheet; otherwise use `create_image`. The image should:

- Be named `{Item Name} (Item Icon).webp` and saved to the `Generated/` folder — check for an existing file and version if needed (see [File Versioning](#file-versioning))
- Depict the item in a fantasy RPG icon style (isometric, on stone or natural surface, painterly)
- Be embedded at the top of the note as `![[{Item Name} (Item Icon).webp|256]]`

#### 5. Item tag

The note MUST end with `#item` on its own line. This is required for the item to appear in the Items filtered database.

### Character Notes

When creating a new character, follow these steps in order:

#### 1. Create the note

Each character gets its own note in `Generated/`, named after the character (e.g., `Generated/Vestel, The Fungal Leshy.md`). If the character has a title or epithet, include it after a comma. Check for an existing file and version if needed (see [File Versioning](#file-versioning)).

#### 2. One-liner

Start with a brief, coarse-grained, one-sentence description of the character. Ideally describe what manner of creature they are and where they can be found (or where they hail from). Example:

> A [[Gnome]] vendor who operates a stall in [[The Memory Market]], a section of [[The Witchmarket]]

#### 3. Appearance

A `### Appearance` section with a short bullet list describing the character's physical traits. Keep it evocative but brief — just enough to convey character at a glance.

#### 4. Personality

A `### Personality` section with a short bullet list capturing how the character behaves and comes across in conversation. Note any contrasts or shifts in demeanor (e.g., timid at first, then sardonic when confident).

#### 5. Motivation

A `### Motivation` section with a short bullet list describing what the character wants and why. Use `[[wiki links]]` to connect to factions, other characters, or locations that drive their goals.

#### 6. Generate a character portrait

Generate a portrait using the `/aria-lore:image` skill. If a styleguide is available (see [Styleguide Integration](#styleguide-integration)), use the `modify_image` workflow with the visual reference sheet; otherwise use `create_image`. The image should:

- Be named `{Character Name} (Character Portrait).webp` and saved to the `Generated/` folder — check for an existing file and version if needed (see [File Versioning](#file-versioning))
- Use a **4:3 aspect ratio**
- Depict the character in a painterly fantasy illustration style with rich colors and detailed lighting
- Draw on the character's Appearance notes and setting context for the prompt

Embed it at the top of the note as `![[{Character Name} (Character Portrait).webp]]`

#### 7. Lore

A `### Lore` section for recording backstory, relationships, and narrative significance within the game world. This may start with seed content or be left empty for later development.

#### 8. Character tag

The note MUST end with `#character` on its own line. This is required for the character to appear in the Characters filtered database.

### Location Notes

When creating a new location, follow these steps in order:

#### 1. Create the note

Each location gets its own note in `Generated/`, named after the place (e.g., `Generated/The Witchmarket.md`). Check for an existing file and version if needed (see [File Versioning](#file-versioning)).

#### 2. One-liner

Start with a brief, one-sentence description of the location. Describe what kind of place it is and where it sits in the world. Example:

> A sprawling underground bazaar beneath [[Thornwall]] where forbidden goods and rare artifacts change hands

#### 3. Description

A `### Description` section with a short paragraph painting the atmosphere of the place — sights, sounds, smells, mood. Keep it evocative and concise.

#### 4. Notable Features

A `### Notable Features` section with a bullet list of key landmarks, structures, or environmental details that define the location. Use `[[wiki links]]` to connect to related notes.

#### 5. Inhabitants

A `### Inhabitants` section listing key characters, factions, or creature types found here. Use `[[wiki links]]` to connect to character and faction notes.

#### 6. Connections

A `### Connections` section describing how this location relates to other places in the world — neighboring regions, travel routes, portals, or narrative links. Use `[[wiki links]]`.

#### 7. Generate a location image

Generate a scene image using the `/aria-lore:image` skill. If a styleguide is available (see [Styleguide Integration](#styleguide-integration)), use the `modify_image` workflow with the visual reference sheet; otherwise use `create_image`. The image should:

- Be named `{Location Name} (Scene).webp` and saved to the `Generated/` folder — check for an existing file and version if needed (see [File Versioning](#file-versioning))
- Use a **16:9 aspect ratio**
- Depict the location in a painterly fantasy illustration style that captures its atmosphere
- Draw on the Description and Notable Features sections for the prompt

Embed it at the top of the note as `![[{Location Name} (Scene).webp]]`

#### 8. Location tag

The note MUST end with `#location` on its own line. This is required for the location to appear in the Locations filtered database.

## How to Use This Skill

When the user invokes `/aria-lore:lore`, interpret `$ARGUMENTS` as a lore-building request. Determine whether they want to create a character, an item, a location, explore existing lore, or brainstorm new ideas. Follow the appropriate template above, cross-reference existing vault notes for coherence, and apply the default styleguide for image generation when one exists (see [Styleguide Integration](#styleguide-integration)).
