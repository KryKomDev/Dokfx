# Getting Started

Welcome to **Dokfx**! This custom DocFX template is built on top of the modern DocFX theme and brings beautiful **Material Design 3 (M3)** aesthetics, responsive layouts, unified alignment, and support for the **Google Sans Code** monospace typeface.

---

## 1. Prerequisites

Before installing the template, ensure you have the **dotnet docfx** tool installed. You can install or verify it by running:

```bash
# Install DocFX globally
dotnet tool install -g docfx

# Check your installed version (2.70+ recommended)
docfx --version
```

---

## 2. Installation

To install and use the template, copy the `dokfx` directory into your DocFX project root or add it as a git submodule:

```text
my-docfx-project/
├── docfx.json
├── docs/
│   └── ...
└── templates/
    └── dokfx/          <-- Place the template folder here
        ├── public/
        │   └── main.css
        └── partials/
            ├── class.header.tmpl.partial
            ├── class.memberpage.tmpl.partial
            └── namespace.tmpl.partial
```

---

## 3. Configuration

### Step 1: Register the Template in `docfx.json`
Open your `docfx.json` configuration file and locate the `"build"` block. In the `"template"` array, append your custom template path **after** the default templates:

```json
{
  "build": {
    "template": [
      "default",
      "modern",
      "templates/dokfx"
    ]
  }
}
```

> [!NOTE]
> DocFX uses a stacked template system. The paths in `"template"` are layered sequentially, meaning `templates/dokfx` will override specific styles and templates from `modern` and `default` while inheriting everything else.

### Step 2: Configure Split API Layout (Recommended)
To take full advantage of the responsive API tables provided by this template, configure your project to generate separate sub-pages for members by adding `"memberLayout": "separatePages"` under your `metadata` config:

```json
{
  "metadata": [
    {
      "src": [
        {
          "src": "../src",
          "files": ["**/*.csproj"]
        }
      ],
      "dest": "api",
      "memberLayout": "separatePages"
    }
  ]
}
```

### Step 3: Customize the Accent Color (Optional)

You can customize the accent color used across the theme by setting `_accentColor` in `globalMetadata`. The template dynamically parses the color and calculates the full Material Design 3 palette (including container backgrounds, text contrast, and dark-mode desaturated equivalents):

```json
{
  "build": {
    "globalMetadata": {
      "_accentColor": "#e91e63"
    }
  }
}
```

You can specify the color as a hex code (e.g. `#e91e63`), standard rgb `rgb(...)`, or CSS color names (e.g. `royalblue`).

### Step 4: Customize Callout Headings (Optional)

You can customize the heading text of the predefined callout blocks (Note, Tip, Important, Warning, Caution) by defining metadata properties inside `globalMetadata` in `docfx.json`:

```json
{
  "build": {
    "globalMetadata": {
      "_calloutNoteHeading": "Did you know?",
      "_calloutTipHeading": "Pro Tip",
      "_calloutImportantHeading": "Crucial",
      "_calloutWarningHeading": "Attention",
      "_calloutCautionHeading": "Danger"
    }
  }
}
```

### Step 5: Add Custom Callout Blocks (Optional)

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

Properties:

* **`name`**: The CSS class name mapped in step 1 (e.g. `todo`).
* **`heading`**: The heading title text to display on the callout.
* **`color`**: The border, heading, and link accent color.
* **`icon`**: The Google Material Symbols name for the callout icon.

---

## 4. Building and Running

You can compile your documentation site using the following standard commands:

```bash
# 1. Generate API reference metadata from source code
docfx metadata

# 2. Build the static site (output generated under _site/ by default)
docfx build

# 3. Spin up a local server to preview the site with hot-reloading
docfx serve
```

Navigate to `http://localhost:8080` in your web browser to view your newly generated, Material 3 documentation!

---

## 5. Key Template Features

- **Google Sans Code Monospace**: Code blocks and inline elements are styled with Google's high-legibility developer typeface, loaded dynamically from Google Fonts.
- **Material 3 Search & Filters**: Search bars and sidebar filter containers are fully styled with M3 rounded pill contours, focus-indicator rings, and elevation overlays.
- **Zebra-Striped Responsive Tables**: Heavy definition lists (`<dl>`) in API docs are replaced with elegant, table-wrapped lists utilizing subtle 1.5% primary tint rows.
- **Corrected Flex Alignment**: Breadcrumb paths, offcanvas sidebar toggles, and API explorer chevrons align perfectly to their vertical centers without brittle manual pixel offsets.