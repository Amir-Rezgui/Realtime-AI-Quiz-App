# Design System Strategy: The Vibrant Intellect

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Kinetic Gallery."** 

Moving beyond the static, boxy nature of traditional quiz applications, this system treats each question and interaction as a curated exhibit. We replace the rigid "app-like" feel with a high-end editorial experience. By leveraging intentional asymmetry, expansive negative space, and a sophisticated interplay between the violet primary and tonal surfaces, we create an environment that feels intellectually stimulating yet approachable. 

The "template" look is dismantled through **Tonal Fluidity**: elements are not "placed on top" of a background; they emerge from it through subtle shifts in luminosity and generous, breath-like spacing.

---

## 2. Colors & Surface Philosophy
The palette utilizes a sophisticated violet core, supported by deep plums and soft lavender surfaces to provide a "vibrant but professional" atmosphere.

### The "No-Line" Rule
**Strict Mandate:** Designers are prohibited from using 1px solid borders to define sections or containers. 
Structure must be achieved through **Chroma-Separation**. A card does not need a line if it is `surface-container-lowest` sitting on a `surface-container-low` background. This creates a high-end, seamless "molded" look rather than a "constructed" one.

### Surface Hierarchy & Nesting
Treat the UI as a series of nested physical layers. 
- **Base Level:** `surface` (#fdf3ff)
- **Primary Content Areas:** `surface-container-low` (#f9ecff)
- **Active Interactive Elements:** `surface-container-highest` (#ebd4ff)
- **Floating Modal/Elevated Elements:** `surface-container-lowest` (#ffffff)

### The "Glass & Gradient" Rule
To inject "soul" into the quiz experience, use **Tonal Gradients** for high-impact moments (e.g., Progress Bars or Hero CTAs). Transition from `primary` (#644da1) to `primary-container` (#bba2fd). For floating overlays, apply a `backdrop-blur` of 12px to a 60% opaque `surface` color to create a frosted-glass effect that maintains context.

---

## 3. Typography: Editorial Authority
We utilize two distinct typefaces to balance character with readability.

*   **Display & Headlines (Plus Jakarta Sans):** Used for question headers and scores. The generous x-height and geometric curves feel modern and confident.
    *   `display-lg`: 3.5rem (The "Hero" score or countdown).
    *   `headline-lg`: 2rem (The primary quiz question).
*   **Body & Labels (Manrope):** A high-legibility sans-serif for options and metadata.
    *   `body-lg`: 1rem (Answer choices).
    *   `label-md`: 0.75rem (Category tags).

**Editorial Hint:** Use `display-sm` for question numbers (e.g., "01") and place them with intentional asymmetry—slightly overlapping the edge of a container—to break the grid.

---

## 4. Elevation & Depth
In this system, depth is felt, not seen. We abandon traditional Material shadows for **Tonal Layering**.

*   **The Layering Principle:** To "lift" an element, shift its background color one step toward white (Lowest). For example, an active answer choice should transition from `surface-container-low` to `surface-container-lowest`.
*   **Ambient Shadows:** If a floating element (like a snackbar or FAB) requires a shadow, it must be an **Ambient Tinted Shadow**. Use the `on-surface` color (#38264c) at 6% opacity with a `48px` blur and `12px` Y-offset. This mimics a soft purple glow rather than a muddy grey drop-shadow.
*   **The "Ghost Border" Fallback:** In high-density screens where tonal shifts are insufficient, use a "Ghost Border": `outline-variant` (#bba4d2) at **15% opacity**. This provides a hint of structure without interrupting the visual flow.

---

## 5. Components

### Cards (The "Extra-Large" Core)
The centerpiece of the quiz app. 
- **Corner Radius:** Must use `xl` (3rem) for parent containers and `lg` (2rem) for nested answer cards.
- **Separation:** Never use dividers. Use `spacing-8` (2rem) to create clear air between content blocks.

### Buttons (The Kinetic Trigger)
- **Primary:** `primary` (#644da1) with `on-primary` text. No shadow.
- **Secondary (The Quiz Option):** `surface-container-high` (#efdbff) with `on-surface` text. When selected, animate to `primary-container` (#bba2fd) with a `px` ghost border.
- **Padding:** Vertical `spacing-4`, Horizontal `spacing-8`.

### Inputs & Text Fields
- **Container:** Use a "molded" look. `surface-container-highest` (#ebd4ff) with a bottom-only `outline` (#836e99) at 20% opacity. 
- **Active State:** The bottom line expands to 2px and takes the `primary` color.

### Quiz Progress Bar
- **Track:** `surface-container-highest`.
- **Indicator:** A linear gradient from `primary` to `secondary`.
- **Effect:** Suble `primary-fixed-dim` outer glow to indicate "energy."

---

## 6. Do’s and Don’ts

### Do
- **Do** use `surface-dim` (#e5caff) for "disabled" or "inactive" states to maintain the purple tonal harmony.
- **Do** allow headlines to "breathe" with at least `spacing-12` (3rem) of top margin.
- **Do** use standard M3 icons, but always in the `on-surface-variant` color to keep them secondary to the text.

### Don't
- **Don’t** use pure black (#000000) or pure grey. Use `on-background` (#38264c) for all dark text to keep the palette rich.
- **Don’t** use 1px dividers between quiz questions. Use a background color shift from `surface` to `surface-container-low`.
- **Don’t** use "Small" or "Medium" corners for cards. The "extra large" `xl` (3rem) radius is mandatory for the signature look.