# Introduction to Dokfx

Welcome to the **Dokfx Template Showcase**. This document serves as a comprehensive showcase of all the supported Markdown elements, styling rules, and layout structures available in this Material 3 inspired theme.

---

## 1. Typography & Text Formatting

Here is a quick demonstration of basic inline text formatting:

* **Bold text** using `**bold**` or `__bold__`
* *Italic text* using `*italic*` or `_italic_`
* ***Bold and Italic*** using `***bold & italic***`
* ~~Strikethrough text~~ using `~~strikethrough~~`
* `Inline Code Blocks` which are styled with fully rounded side borders and semi-transparent backgrounds to fit seamlessly into text lines.

### Subheadings Demo (H3)

#### Level 4 Heading (H4)

##### Level 5 Heading (H5)

###### Level 6 Heading (H6)

### Subheading with a `code block` (H3)

#### Level 4 heading with a `code block` (H4)

##### Level 5 heading with a `code block` (H5)

###### Level 6 heading with a `code block` (H6)

---

## 2. Lists

### Unordered List

* Material Design 3 tokens and grids
* Bootstrap 5 layout foundations
* Custom template override system
  * Sub-item A with nested bullets
  * Sub-item B with nested bullets
    * Deeply nested bullet point

### Ordered List

1. Initialize your DocFX project.
2. Configure your `docfx.json` to include the `dokfx` template path.
3. Run the build command to generate files.
    1. Verify output in the `_site` directory.
    2. Check console logs for compilation issues.

### Task List

* [x] Create a custom template stacked on top of `modern`
* [x] Replace definition lists with beautiful responsive tables
* [ ] Add support for custom custom-styling search results page
* [ ] Implement color themes customization

---

## 3. Alerts & Callouts

DocFX supports GitHub-flavored markdown alerts to emphasize critical information:

> [!NOTE]
> This is a standard **Note** callout. Use it to provide background context, additional explanations, or helpful tips.

> [!TIP]
> This is a **Tip** callout. Use it to suggest performance optimizations, shortcuts, or best practices.

> [!IMPORTANT]
> This is an **Important** callout. Use it to highlight essential instructions or steps that the user must follow.

> [!WARNING]
> This is a **Warning** callout. Use it to warn the user about breaking changes, potential errors, or configuration hazards.

> [!CAUTION]
> This is a **Caution** callout. Use for high-risk actions that could cause data loss, build failures, or security issues.

> [!TODO]
> This is a custom alert/callout block configured dynamically under `markdownEngineProperties.alerts` and `_customCallouts` metadata!

### Callout Heading Customization

You can customize the heading text of the predefined callouts inside the `docfx.json` configuration file.
This site has edited `Note` and `Tip` callouts:

```json
{
  "build": {
    "globalMetadata": {
      "_calloutNoteHeading": "Did you know?",
      "_calloutTipHeading": "Pro Tip"
    }
  }
}
```

You can customize the other blocks too:

```json
{
  "build": {
    "globalMetadata": {
      "_calloutNoteHeading": "Note heading",
      "_calloutTipHeading": "Tip heading",
      "_calloutImportantHeading": "Important heading",
      "_calloutWarningHeading": "Warning heading",
      "_calloutCautionHeading": "Caution heading"
    }
  }
}
```

### Adding Custom Callouts

You can define entirely new, custom callout blocks by mapping the block keyword to CSS classes in `markdownEngineProperties.alerts`, and then styling it via `globalMetadata._customCallouts`:

1. Map the custom alert keyword inside `docfx.json`:

```json
{
  "build": {
    "markdownEngineProperties": {
      "alerts": {
        "todo": "alert alert-todo todo"
      }
    }
  }
}
```

2. Configure style properties under `globalMetadata._customCallouts` in `docfx.json`:

```json
{
  "build": {
    "globalMetadata": {
      "_customCallouts": [
        {
          "name": "todo",
          "heading": "Things to Do",
          "color": "#e91e63",
          "icon": "checklist"
        }
      ]
    }
  }
}
```

---

## 4. Tables

Below is an auto-sized table styled with a Bootstrap striped and bordered design. Under our styling, tables wrap tightly to their content and do not expand to 100% width unless they overflow the container width.

| Feature | Support Status | Description |
| :--- | :---: | :--- |
| **Material 3 Palette** | Supported | Adapts dynamically to light and dark modes. |
| **Responsive Sidebar** | Supported | Collapses to offcanvas drawer on tablet/mobile views. |
| **Pill-shaped Code** | Supported | Inline code is capsule-shaped and semi-transparent. |
| **Card Tables** | Supported | Tables are rounded and elevated. |

---

## 5. Code Blocks

### Inline Code in Sentence

To configure the template, append your custom template path inside the `"template"` array within your `docfx.json` configuration file, ensuring it is ordered after `"modern"`.

### Syntax Highlighted Code Blocks

#### C# Example

```csharp
using System;

namespace MyLibrary
{
    /// <summary>
    /// Represents a sample calculator.
    /// </summary>
    public class Calculator
    {
        public int Add(int a, int b)
        {
            // Return sum of inputs
            return a + b;
        }
    }
}
```

#### CSS Override Example

```css
/* Custom CSS override for active links */
.toc li.active > a {
  color: var(--md-primary) !important;
  font-weight: 600;
}
```

---

## 6. Blockquotes

> "Simplicity is the ultimate sophistication."
> — *Leonardo da Vinci*

> Blockquotes can also be nested:
>
> > This is a nested blockquote level.
>
> Back to the first level blockquote.

---

## 7. Links and Images

### Links

* **External Link**: Learn more on the [Official DocFX Website](https://dotnet.github.io/docfx/).
* **Auto-Linked URL**: https://dotnet.github.io/docfx/

### Images

Below is a demonstration of how image assets are styled, sized down, and toggled responsively for light/dark themes in the template:

#### 1. Standard Image (Auto-scaled)

By default, images adapt to fill their parent container width.
![Visual Graphic Asset](../images/KRYKOM-oneline-masked-b-test.png)

#### 2. Sized-down Image (Max Width)

You can size down images using the custom curly brace attribute syntax immediately following the image:
`![<alt-text>](<image-url>){width=<width> height=<height>}`

For example:
`![Sized Down Logo](../images/Gen17.png){width=150px}`

This renders as:

![Sized Down Logo](../images/Gen17.png){width=150px}


#### 3. Responsive Light / Dark Theme Showcase

##### HTML Utility Classes Method

Using the template's custom theme-specific helper utility classes (`.light-theme-only` and `.dark-theme-only`), you can display different images depending on the user's selected color theme (light or dark):

<div class="p-4 rounded-4 shadow-sm border mb-4 text-center" style="background-color: var(--md-surface-container-low); border-color: var(--md-outline-variant) !important;">
  <p class="mb-3 text-muted small">The logo below changes color dynamically when you toggle the site theme:</p>
  
  <!-- Displays on Light Theme -->
  <img src="../images/KRYKOM-oneline-masked-b.png" class="light-theme-only img-fluid" style="max-width: 300px; margin: 0 auto;" alt="KryKom Logo for Light Theme" />
  
  <!-- Displays on Dark Theme -->
  <img src="../images/KRYKOM-oneline-masked-w.png" class="dark-theme-only img-fluid" style="max-width: 300px; margin: 0 auto;" alt="KryKom Logo for Dark Theme" />
</div>

##### Custom Markdown Syntax Method

Alternatively, you can use our custom markdown syntax for theme responsive images:

```md
?[ <alt-text> ]( <light-theme-img-url> )( <dark-theme-img-url> )
```

For example:

```md
?[KryKom Logo](../images/KRYKOM-oneline-masked-b.png)(../images/KRYKOM-oneline-masked-w.png)
```

This renders as:

?[KryKom Logo](../images/KRYKOM-oneline-masked-b.png)(../images/KRYKOM-oneline-masked-w.png)

##### Image Sizing with Responsive Images
The sizing syntax also works seamlessly with theme responsive images:
`?[alt-text](light-url)(dark-url){width=<width>}`

For example:
`?[KryKom Logo](../images/KRYKOM-oneline-masked-b.png)(../images/KRYKOM-oneline-masked-w.png){width=200px}`

This renders as:

?[KryKom Logo](../images/KRYKOM-oneline-masked-b.png)(../images/KRYKOM-oneline-masked-w.png){width=200px}
