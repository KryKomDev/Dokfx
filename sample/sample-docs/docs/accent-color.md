# Accent Color Customization

You can customize the accent color used across the theme by setting the `_accentColor` property under the `globalMetadata` block in your `docfx.json`:

```json
{
  "build": {
    "globalMetadata": {
      "_accentColor": "#e91e63"
    }
  }
}
```

The template dynamically resolves this color, automatically calculating the full Material Design 3 palette (including container backgrounds, text contrast, and desaturated dark-mode equivalents).

## Color Format Support
You can specify the color as:
* **Hex Code**: e.g., `#e91e63` or `#9c27b0`
* **RGB/RGBA**: e.g., `rgb(156, 39, 176)` or `rgba(156, 39, 176, 0.8)`
* **CSS Named Colors**: e.g., `royalblue`, `forestgreen`, `darkorange`
