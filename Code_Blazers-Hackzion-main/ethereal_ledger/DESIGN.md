# Design System Specification: The Ethereal Authority

## 1. Overview & Creative North Star
**The Creative North Star: "The Ethereal Authority"**

This design system rejects the "boxed-in" nature of traditional fintech. We are moving away from rigid, high-contrast borders and data-dense tables toward a layout that feels curated, editorial, and weightless. The goal is to convey deep institutional trust through "Ethereal Authority"—a visual language where information floats in a pristine, atmospheric space.

We break the "template" look through **Intentional Asymmetry** and **Tonal Depth**. Instead of centering everything, we use generous, offset white space to guide the eye. Components shouldn't look like they are "printed" on the screen; they should look like they are "suspended" within it.

---

## 2. Colors & Surface Architecture

The palette is built on a foundation of "Deep Midnight" and "Atmospheric Gray." 

### The "No-Line" Rule
**Standard 1px solid borders are strictly prohibited for sectioning.** To define boundaries, you must use background color shifts (e.g., a `surface-container-low` card resting on a `surface` background) or subtle tonal transitions. This creates a more organic, premium feel.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the surface-container tiers to create "nested" depth:
- **Base Layer (`surface`):** The canvas.
- **Mid Layer (`surface-container-low`):** Secondary content areas or subtle grouping.
- **Top Layer (`surface-container-lowest` / White):** High-priority interactive cards.

### The "Glass & Gradient" Rule
To achieve the "Airy" personality, use **Glassmorphism** for floating elements (modals, dropdowns, navigation bars):
- **Fill:** `surface-container-lowest` at 70-80% opacity.
- **Backdrop Blur:** 20px - 32px.
- **Signature Texture:** Apply a 15% opacity linear gradient from `primary` to `secondary` on main CTAs to give them "soul" and a soft glow.

---

## 3. Typography: The Editorial Voice

We utilize **Manrope** for its geometric yet approachable character. The hierarchy is designed to feel like a high-end financial magazine.

*   **Display (Large/Medium):** Used for "Hero" moments like total balance or impact statements. These should have a slight negative letter-spacing (-0.02em) to feel tighter and more authoritative.
*   **Headline (Small/Medium):** Used for section starts. Combined with `on-surface-variant` for a muted, sophisticated look.
*   **Title:** For card headings. Always use `on-primary-fixed` to ensure the core data feels "heavy" and secure.
*   **Body:** Optimized for legibility. Never use pure black; use `on-surface` to maintain a soft, premium contrast.
*   **Label:** Smallest tier. Use these sparingly for metadata, often in uppercase with +0.05em tracking for an "architectural" feel.

---

## 4. Elevation & Depth

### The Layering Principle
Depth is achieved by "stacking" the surface tiers. Place a `surface-container-lowest` card on a `surface-container-low` section to create a soft, natural lift without needing a shadow.

### Ambient Shadows
When a component must float (e.g., a primary action card), use an **Ambient Shadow**:
- **X/Y Offset:** 0px 12px
- **Blur:** 40px
- **Color:** `on-primary` at 5% opacity, tinted with a hint of `secondary`. This mimics natural light diffusion rather than a "drop shadow."

### The "Ghost Border" Fallback
If a border is required for accessibility (e.g., in input fields), use the **Ghost Border**:
- **Token:** `outline-variant`
- **Opacity:** 15% - 20%
- **Requirement:** 100% opaque borders are forbidden.

---

## 5. Components

### Buttons: The Tactile Interaction
- **Primary:** Filled with `primary` (#000000 / Deep Blue). Use `xl` (3rem) corner radius. Add a subtle inner-glow on hover.
- **Secondary:** Transparent fill with a `Ghost Border` and `on-primary-fixed` text.
- **Tertiary:** No background. Bold `secondary` text.

### Cards & Lists: The Open Layout
- **Forbid Divider Lines.** Use vertical white space (32px - 48px) to separate list items.
- **Cards:** Utilize `lg` (2rem) or `md` (1.5rem) border radius. Use Glassmorphism (blur + semi-transparent white) for a "frosted" fintech aesthetic.

### Input Fields: The Subtle Guide
- No heavy boxes. Use `surface-container-highest` with a bottom-only `outline-variant` (20% opacity) or a very subtle `md` rounded container that matches the background color.

### Signature Component: The "Fluid Progress Glass"
For fintech tracking (budgets/investments), use a wide-radius progress bar with a `primary` to `secondary` gradient, housed inside a high-blur glass container.

---

## 6. Do’s and Don’ts

### Do:
- **Do** use asymmetrical layouts where one column is significantly wider than the other to create an editorial feel.
- **Do** use `surface-bright` for the main background to keep the interface "Airy."
- **Do** maximize the use of the `xl` (3rem) corner radius for large containers to soften the professional tone.

### Don't:
- **Don't** use 100% black text. Use `on-primary-fixed` or `on-surface` to keep the palette sophisticated.
- **Don't** use "Drop Shadows." Only use "Ambient Glows" that feel like light passing through glass.
- **Don't** crowd the interface. If you think it needs more information, it probably needs more white space instead.
- **Don't** use standard 1px borders. If a section needs to be separated, use a subtle shift from `surface` to `surface-container-low`.

---
*Director’s Note: This design system is not a set of rules, but a philosophy. You are building an environment, not just an interface. Every pixel of white space is a deliberate choice to let the user breathe.*