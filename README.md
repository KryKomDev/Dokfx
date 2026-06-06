# Custom DocFX Template with API Tables

This custom DocFX template is designed on top of the modern DocFX theme. It includes all the features of the standard template (left sidebar navigation, right-side article TOC, search bar, and automatic light/dark theme switcher) but with two critical enhancements:

1.  **It replaces the default definition lists (`<dl>`) with clean, elegant tables for all API reference pages.**
2.  **It overrides the table layout so tables do not automatically stretch to 100% width, instead wrapping nicely around their content.**

## What Changed?

### 1. API Tables

In the default modern DocFX template, API listings—such as classes in namespaces, and members (methods, properties, constructors) in class member pages—are rendered as definition lists where descriptions are written next to or below names.

This template overrides the following Mustard partials to structure those listings into beautiful **Bootstrap 5 responsive tables**:

- **`partials/namespace.tmpl.partial`**: Lists types (classes, enums, structs, interfaces) in namespaces as tables with `Name` and `Description` columns.
- **`partials/class.memberpage.tmpl.partial`**: Lists class/struct/interface members (methods, properties, constructors, fields, events) as tables with `Name` and `Description` columns (when using separate member pages or split layouts).
- **`partials/class.header.tmpl.partial`**: Lists enum members in a clean table containing the enum names and descriptions/remarks.

### 2. Auto-Sized Tables (`public/main.css`)

By default, Bootstrap styles all tables to have a width of `100%`, which stretches tables with small amounts of text across the entire content bar.

This template introduces a style override in **`public/main.css`**:

```css
article table {
  width: auto !important;
  max-width: 100%;
  margin-bottom: 1rem;
}
```

This forces all tables rendered inside documentation articles or API references to wrap tightly around their contents (width auto) unless they exceed the size of the container, in which case they scale smoothly down (`max-width: 100%`).

---

## How to Use This Template

The template uses DocFX's **stacked template system**, meaning you only need to keep the overridden template files in your repository and tell DocFX to layer them on top of the built-in `modern` template.

### 1. Structure

Place the `dokfx` folder inside your DocFX project (or at the root of your repository):

```text
my-docfx-project/
├── docfx.json
├── src/
│   └── dokfx/
│       ├── public/
│       │   └── main.css
│       └── partials/
│           ├── class.header.tmpl.partial
│           ├── class.memberpage.tmpl.partial
│           └── namespace.tmpl.partial
```

### 2. Configure `docfx.json`

Open your `docfx.json` file and locate the `"build"` block. In the `"template"` array, append your custom template path **after** the default and modern templates:

```json
{
  "build": {
    "template": ["default", "modern", "src/dokfx"]
  }
}
```

> [!NOTE]
> Make sure the path specified in the `"template"` array is relative to the directory containing your `docfx.json` file. For example, if your template is inside a subfolder, use `src/dokfx` or the relative path to it (e.g., `../../src/dokfx`).

### 3. Generate Separate Member Pages (Optional but Recommended)

For large APIs, displaying each member as a separate sub-page keeps the main class pages clean and leverages the `class.memberpage.tmpl.partial` table template. You can enable this by adding `"memberLayout": "separatePages"` under the `metadata` block in your `docfx.json`:

```json
{
  "metadata": [
    {
      "src": [
        {
          "files": ["**/*.csproj"]
        }
      ],
      "dest": "api",
      "memberLayout": "separatePages"
    }
  ]
}
```

---

## Technical Details

### Namespace Table Implementation (`namespace.tmpl.partial`)

```html
{{#children}}
<h3 id="{{id}}">{{>partials/namespaceSubtitle}}</h3>
<table class="table table-bordered table-striped table-condensed">
  <thead>
    <tr>
      <th style="width: 30%">Name</th>
      <th style="width: 70%">Description</th>
    </tr>
  </thead>
  <tbody>
    {{#children}}
    <tr>
      <td>
        <xref uid="{{uid}}" altProperty="fullName" displayProperty="name" />
      </td>
      <td>{{{summary}}}</td>
    </tr>
    {{/children}}
  </tbody>
</table>
{{/children}}
```

### Member Table Implementation (`class.memberpage.tmpl.partial`)

```html
{{#children}}
<h2 class="section" id="{{id}}">{{>partials/classSubtitle}}</h2>
<table class="table table-bordered table-striped table-condensed">
  <thead>
    <tr>
      <th style="width: 30%">Name</th>
      <th style="width: 70%">Description</th>
    </tr>
  </thead>
  <tbody>
    {{#children}}
    <tr>
      <td>
        <xref uid="{{uid}}" altProperty="fullName" displayProperty="name" />
      </td>
      <td>{{{summary}}}</td>
    </tr>
    {{/children}}
  </tbody>
</table>
{{/children}}
```
