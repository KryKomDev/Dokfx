# Dokfx Repository Agent Guide (AGENTS.md)

Welcome! This document serves as a comprehensive guide to understanding the **Dokfx** repository layout, design system, styling principles, and development workflows. Read this guide to quickly bootstrap your understanding of the codebase.

---

## Project Overview

**Dokfx** is a modern, Material Design 3 (MD3) inspired template for **DocFX** (a static site generator for .NET API documentation). It is designed to be highly customizable, fully responsive, and supportive of dynamic styling features.

### Key Features

1. **Material Design 3 Theme**: Card-based layouts, navigation drawer/rail styles, responsive content flow, and modern typography.
2. **Client-Side Accent Color Generation**: Accepts a primary color and mathematically calculates container, surface, hover, and dark-mode color variations in the client browser.
3. **Customizable Callout Blocks**: Out-of-the-box customization of standard DocFX alerts and registration of completely custom callouts (e.g., `todo` with custom labels, colors, and Material symbols).

---

## Repository Structure

Here is a directory map showing the locations of the key components in the repository:

* **Root Directory Files**:
  * [README.md](file:///C:/Users/krystof/Desktop/projects/Dokfx/README.md) - Project overview, basic installation instructions, and configuration options.
  * [LICENSE](file:///C:/Users/krystof/Desktop/projects/Dokfx/LICENSE) - MIT license file.
  * [AGENTS.md](file:///C:/Users/krystof/Desktop/projects/Dokfx/AGENTS.md) - This file.
* **Source Folder** ([/src/dokfx](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx)):
  * [layout/_master.tmpl](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/layout/_master.tmpl) - The central master template governing site layout. Injects custom JavaScript for accent color mapping, dark mode management, and custom alert customization.
  * [/src/dokfx/partials/](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/partials):
    * [class.header.tmpl.partial](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/partials/class.header.tmpl.partial) - Layout for class header details in API docs.
    * [class.memberpage.tmpl.partial](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/partials/class.memberpage.tmpl.partial) - Layout for individual member details.
    * [namespace.tmpl.partial](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/partials/namespace.tmpl.partial) - Layout for namespaces.
  * [/src/dokfx/public/](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/public):
    * [public/main.css](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/public/main.css) - Central stylesheet defining Material Design 3 color tokens, component layout styling, animations, callout colors, and dark/light modes.
* **Sample / Playground Folder** ([/sample](file:///C:/Users/krystof/Desktop/projects/Dokfx/sample)):
  * [/sample/MyLibrary/](file:///C:/Users/krystof/Desktop/projects/Dokfx/sample/MyLibrary) - A dummy C# project used to test C# API metadata generation.
  * [/sample/sample-docs/](file:///C:/Users/krystof/Desktop/projects/Dokfx/sample/sample-docs):
    * [docfx.json](file:///C:/Users/krystof/Desktop/projects/Dokfx/sample/sample-docs/docfx.json) - DocFX configuration file using the template located at `../../src/dokfx`. Sets accent color (`_accentColor`), app title, logo, and registers custom callout configurations.
    * [index.md](file:///C:/Users/krystof/Desktop/projects/Dokfx/sample/sample-docs/index.md) - Main documentation landing page for testing.
* **Deployment & Setup Scripts** ([/scripts](file:///C:/Users/krystof/Desktop/projects/Dokfx/scripts)):
  * [install.ps1](file:///C:/Users/krystof/Desktop/projects/Dokfx/scripts/install.ps1) - PowerShell script to install or update the Dokfx template from GitHub releases to a target path.
  * [install.sh](file:///C:/Users/krystof/Desktop/projects/Dokfx/scripts/install.sh) - Bash alternative script for template setup.
* **CI/CD Workflows** ([/.github/workflows/](file:///C:/Users/krystof/Desktop/projects/Dokfx/.github/workflows)):
  * [docs.yml](file:///C:/Users/krystof/Desktop/projects/Dokfx/.github/workflows/docs.yml) - GitHub Actions workflow to build and deploy the sample documentation to GitHub Pages. Runs on tag pushes (`v*`) and manual workflow dispatches.
  * [release.yml](file:///C:/Users/krystof/Desktop/projects/Dokfx/.github/workflows/release.yml) - Workflow to package `src/dokfx` into `dokfx-template.zip` and publish to GitHub releases on new version tags.

---

## Styling & Design Principles

### 1. Material Design 3 Architectural Tokens

The stylesheet [main.css](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/public/main.css) uses CSS custom properties to drive layout colors, which adapt dynamically in dark/light modes:

* `--md-primary`: Core accent color.
* `--md-primary-container` & `--md-on-primary-container`: Container background and foreground colors.
* Custom elevations and card borders.

### 2. Client-Side Accent Color Generation

In [_master.tmpl](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/layout/_master.tmpl), if the `_accentColor` property is configured in the DocFX metadata:

1. An inline script parses the accent color (Hex, RGB, or string) and converts it to HSL.
2. It calculates secondary, hover, container, and dark-mode equivalents.
3. It dynamically injects a CSS `<style>` block setting `--md-primary`, `--md-primary-container`, and `--md-on-primary-container` variables.

### 3. Custom Alerts / Callout Blocks

DocFX supports standard alerts like `NOTE`, `TIP`, `IMPORTANT`, `WARNING`, `CAUTION`.

* Header text is overridden if custom headings are specified in metadata (`_calloutNoteHeading`, etc.).
* Additional callouts can be registered through `_customCallouts` metadata, specifying a `name`, `heading`, `color`, and `icon` (from Material Symbols). A JavaScript routine in [_master.tmpl](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/layout/_master.tmpl) intercepts alerts matching the registered names and injects the corresponding heading, colors, and SVG/Symbol representation.

---

## How to Develop, Test, and Deploy

### Local Development & Testing Workflow

1. To modify styling or layouts, edit:
   * [public/main.css](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/public/main.css) (CSS layout & design tokens).
   * [layout/_master.tmpl](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/layout/_master.tmpl) (HTML structure & script logic).
2. Test changes locally by building the sample documentation:
   * Navigate to `/sample/sample-docs/`.
   * Run the command: `docfx docfx.json` (requires the DocFX command-line tool installed on your machine).
   * Preview the built static site located in `sample/sample-docs/_site`.

### Packaging & Installation Scripts

* If making changes to the installation workflow, review [install.ps1](file:///C:/Users/krystof/Desktop/projects/Dokfx/scripts/install.ps1) and [install.sh](file:///C:/Users/krystof/Desktop/projects/Dokfx/scripts/install.sh).
* The templates are distributed as a zipball (`dokfx-template.zip`) compiled by [release.yml](file:///C:/Users/krystof/Desktop/projects/Dokfx/.github/workflows/release.yml). Ensure all required source files are inside `/src/dokfx/` so they are successfully packaged by the zip routine.

---

## Guidelines for AI Coding Agents

* **Preserve Design Language**: Always adhere to Material Design 3 guidelines when adding UI elements (rounded corners, standard padding, semantic color mapping).
* **CSS Precedence**: Avoid using hardcoded styling within templates. Use classes and leverage the CSS custom properties (`--md-*`) defined in [main.css](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/public/main.css).
* **JavaScript Compatibility**: Ensure client-side calculations and script injection in [_master.tmpl](file:///C:/Users/krystof/Desktop/projects/Dokfx/src/dokfx/layout/_master.tmpl) are lightweight and cross-browser compatible (vanilla JS, no external dependencies).
* **Documentation Integrity**: Maintain existing DocFX metadata properties and ensure backward compatibility so users upgrading the template don't experience broken custom configurations.
