# Customizing Callouts

Dokfx supports custom callout/alert blocks, allowing you to edit the headings of standard callout panels or define entirely new callouts with customized colors and icons.

## Predefined Callouts Heading Customization

You can customize the heading text of the predefined callout blocks (Note, Tip, Important, Warning, Caution) by defining metadata properties inside `globalMetadata` in your `docfx.json`:

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

## Adding Custom Callout Blocks

You can define entirely new, custom callout blocks by mapping the block keyword to CSS classes in `markdownEngineProperties.alerts`, and styling it via `globalMetadata._customCallouts`:

### 1. Map the custom alert keyword inside `docfx.json`
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

### 2. Configure style properties under `globalMetadata._customCallouts` in `docfx.json`
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

### Callout Properties
Each entry in the `_customCallouts` array supports the following properties:
* **`name`**: The CSS class name mapped in step 1 (e.g. `todo`).
* **`heading`**: The heading title text to display on the callout.
* **`color`**: The border, heading, and link accent color.
* **`icon`**: The Google Material Symbols name for the callout icon.
