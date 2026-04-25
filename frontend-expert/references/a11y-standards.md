# Radical Accessibility Standards

## Semantic Foundation
- **Heading Hierarchy**: Ensure exactly one `h1`. `h2`-`h6` must follow a logical nested order without skipping levels.
- **Landmarks**: Use `<main>`, `<nav>`, `<aside>`, `<header>`, and `<footer>` to define page structure.
- **Buttons vs. Links**: Use `<button>` for actions (state changes, forms) and `<a>` for navigation. Never use `onclick` on a `<div>`.

## Keyboard Navigation
- **Focus Indicators**: Never use `outline: none` unless providing a clear `:focus-visible` alternative.
- **Focus Order**: Ensure the tab order matches the visual layout.
- **Modals/Overlays**: Must trap focus and return it to the trigger upon closing. Use `Escape` to close.

## React 19 Form Accessibility
- **Error Announcements**: Use `role="alert"` or `aria-live="polite"` for dynamic error messages from `useActionState`.
- **Input Association**: Every input MUST have a `<label htmlFor="...">`.
- **Pending States**: Use `aria-disabled="true"` on buttons during `useFormStatus` pending states instead of `disabled` (to keep them in the tab order for some screen readers).

## Screen Reader Testing
- Use descriptive `aria-label` only when the visual text is insufficient.
- Images: Use `alt=""` for decorative images, or descriptive alt text for informative ones.
- Interactive elements: Ensure they have a minimum touch target of `44x44px`.
