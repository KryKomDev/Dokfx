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

### Automated Installation (Recommended)

You can run the install script directly from the web without downloading it:

* **PowerShell (Windows)**:
  ```powershell
  irm https://krykomdev.github.io/Dokfx/install.ps1 | iex
  ```
* **Bash (Linux/macOS)**:
  ```bash
  curl -sSL https://krykomdev.github.io/Dokfx/install.sh | bash
  ```

Alternatively, you can download the scripts and run them locally:

* **PowerShell (Windows)**: [install.ps1](../../../scripts/install.ps1)
* **Bash (Linux/macOS)**: [install.sh](../../../scripts/install.sh)

For example, to run the downloaded PowerShell installer and configure your target `templates/dokfx` directory:
```powershell
.\install.ps1 -TargetDirectory "templates/dokfx"
```

### Manual Installation
To manually install and use the template, copy the `dokfx` directory into your DocFX project root or add it as a git submodule:

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

### Step 3: Customize Template Features
You can configure and customize the special features of the Dokfx template by referring to the dedicated guides below:
* **[Accent Color Customization](accent-color.md)**: Customize the color palette of the theme dynamically.
* **[Customizing Callouts](custom-callouts.md)**: Redefine headers or add custom alert/callout blocks.
* **[Responsive Images & Sizing](responsive-images.md)**: Create light/dark mode responsive images and control image dimensions.

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

* **Google Sans Code Monospace**: Code blocks and inline elements are styled with Google's high-legibility developer typeface, loaded dynamically from Google Fonts.
* **Material 3 Search & Filters**: Search bars and sidebar filter containers are fully styled with M3 rounded pill contours, focus-indicator rings, and elevation overlays.
* **Zebra-Striped Responsive Tables**: Heavy definition lists (`<dl>`) in API docs are replaced with elegant, table-wrapped lists utilizing subtle 1.5% primary tint rows.
* **Corrected Flex Alignment**: Breadcrumb paths, offcanvas sidebar toggles, and API explorer chevrons align perfectly to their vertical centers without brittle manual pixel offsets.