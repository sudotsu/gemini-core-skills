# Elite Frontend Resilience & Architecture

## 1. Impossible State Prevention
**The Goal**: Eliminate "Boolean Soup" (e.g., `const [loading, setLoading] = useState(false)`).
- **Discriminated Unions**: Use a single `status` string.
  ```typescript
  type State = 
    | { status: 'idle' }
    | { status: 'loading' }
    | { status: 'success'; data: Data }
    | { status: 'error'; error: Error };
  ```
- **FSM Mindset**: Ensure transitions are explicit. You cannot go from `error` to `success` without hitting `loading`.

## 2. Global-Ready Layouts (RTL & Dynamic Length)
**The Goal**: Build once for every language.
- **Logical Properties**: Never use `left`, `right`, `width`, or `height` in a way that breaks directionality.
  - Use `margin-inline-start` instead of `margin-left`.
  - Use `padding-block` instead of `padding-top/bottom`.
  - Use `inset-inline-end` instead of `right`.
- **Text Resilience**: Ensure containers handle text expansion (up to 30% for German) without breaking the layout or overlapping.

## 3. Structural Resilience (First-Class Failure)
**The Goal**: The app must feel stable even when broken.
- **Mandatory Boundaries**: Every major feature block must be wrapped in an `ErrorBoundary` with a specific fallback UI.
- **Content-Aware Skeletons**: Skeletons must match the layout and typography of the final content to prevent "layout jumps" once data arrives.
- **React 19 Actions**: Use `useActionState` to handle server-side errors gracefully in the UI.

## 4. Main Thread Hygiene (INP Optimization)
**The Goal**: Keep the browser responsive to user input.
- **Yielding to the Main Thread**: For heavy computations, use `scheduler.yield()` (or a polyfill) to allow the browser to process clicks/scrolls between tasks.
- **Avoid Layout Thrashing**: Never interleave DOM reads (e.g., `offsetHeight`) and writes (e.g., `style.height`). Group all reads together, then all writes.
- **Passive Listeners**: Use `{ passive: true }` for scroll and touch listeners.

## 5. Frontend Security & UGC
**The Goal**: Zero XSS and strict CSP compliance.
- **Sanitization**: If `dangerouslySetInnerHTML` is required, you MUST use a library like `DOMPurify` (on the server or client) to sanitize user-generated content.
- **CSP Compliance**: Avoid inline styles and scripts. Use Nonces if inline elements are strictly required.
- **Input Validation**: Use `Zod` or `Valibot` to validate external data before it ever touches a component's props.

## 6. Modular File Architecture (Anti-Monolith)
**The Goal**: Prevent "One-File Apps" and ensure maintainability.
- **Single Responsibility Principle (SRP)**: One file = One component, one hook, or one utility.
- **Line Limit**: Any file exceeding 200 lines is a candidate for refactoring.
- **Directory Strategy**:
  - `components/ui`: Presentational components only (no business logic).
  - `components/features`: Composition of UI components with feature-specific logic.
  - `hooks`: Extract ALL complex `useEffect` or `useState` logic into custom hooks.
  - `services`: Centralize all API calls/SDK logic. Never fetch directly inside a component.
- **Barrel Files**: Use `index.ts` in folders to provide clean, public APIs for modules.
