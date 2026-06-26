# Reworked API Layout

This theme provides an option to switch to a reworked, namespace-centric API Explorer layout. When enabled, this feature alters the landing page, navbar routing, sidebar Table of Contents (TOC) structure, and layout margins to deliver a more streamlined, flat overview of your classes, structs, and members.

---

## 1. Feature Overview

The reworked API layout introduces the following design and navigation changes:

* **Namespaces Landing Page**: When users click the **API** tab in the main navbar, they land on a clean, full-width **Namespaces explorer** page that lists all available namespaces in a table format.
* **Child Member Metrics**: The namespaces table summarizes the contents of each namespace (e.g., how many classes, structs, interfaces, enums, etc. it contains) using Material Design 3 colored chips.
* **Asynchronous Namespace Descriptions**: If namespace descriptions are defined, the landing page fetches them dynamically in the background to prevent page load delays.
* **Simplified Sidebar TOC**: Instead of showing a deep nested folder hierarchy containing all namespaces, the sidebar TOC is flattened:
  * When viewing the Namespaces overview, all TOC sidebars (left-hand tree view and right-hand "In this article" index) are **disabled** for a clean, full-width presentation.
  * When exploring a single namespace or its members, the left TOC displays **only** the classes, structs, interfaces, and enums belonging to the current active namespace, with the namespace itself prepended as an **Overview** element at the very top of the sidebar.
  * Navigating to another namespace page automatically resets and updates the TOC sidebar content to match that namespace's children.

---

## 2. Enabling the Layout

To enable the reworked API explorer layout, add the `_reworkedApiLayout` property under the `globalMetadata` block in your `docfx.json` configuration file:

```json
{
  "build": {
    "globalMetadata": {
      "_reworkedApiLayout": true
    }
  }
}
```

---

## 3. Adding Namespace Descriptions

Since standard C# compilers do not support documenting namespaces via XML comments, the recommended way to write descriptions/summaries for namespaces in DocFX is by using **Markdown Overwrite Files**:

1. Create a markdown file (e.g., `docs/namespaces.md`).
2. Add a YAML frontmatter block for each namespace matching its unique identifier (`uid`), specify `summary: *content`, and place the description content immediately after the closing `---` block:

```markdown
---
uid: MyNamespace
summary: *content
---
A namespace containing utility calculators and basic arithmetic helper classes.

---
uid: MyLibrary.AVeryVery.LongNamespace
summary: *content
---
A namespace designed to demonstrate layout handling for deep C# hierarchies and long names.
```

3. Exclude the markdown file from standard content compilation to prevent duplicate UID warnings, and register it in the `overwrite` block of your `docfx.json`:

```json
{
  "build": {
    "content": [
      {
        "files": [
          "**/*.{md,yml}"
        ],
        "exclude": [
          "_site/**",
          "docs/namespaces.md"
        ]
      }
    ],
    "overwrite": [
      {
        "files": [
          "docs/namespaces.md"
        ]
      }
    ]
  }
}
```
