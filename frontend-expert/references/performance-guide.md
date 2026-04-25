# Frontend Performance & Core Web Vitals

## Core Web Vitals (CWV)
### Largest Contentful Paint (LCP)
- **Priority Loading**: Use `priority` attribute on above-the-fold `next/image` components.
- **Self-Host Fonts**: Use `next/font` to optimize font loading and prevent layout shift.
- **Critical CSS**: Ensure styles for the initial viewport are delivered inline or in the first CSS chunk.

### Cumulative Layout Shift (CLS)
- **Aspect Ratio**: Always provide `width` and `height` for images and videos.
- **Dynamic Content**: Reserve space for ads/skeletons to prevent content "jumping".
- **Fonts**: Use `font-display: swap` to avoid FOIT (Flash of Invisible Text).

### Interaction to Next Paint (INP)
- **React 19 Actions**: Use `useOptimistic` to provide immediate visual feedback for user interactions.
- **Debouncing**: Debounce expensive input handlers (search, resize).
- **Web Workers**: Move heavy computational logic out of the main thread.

## Rendering Strategy
- **React Server Components (RSC)**: Fetch data on the server to eliminate waterfall requests and reduce client bundle size.
- **Streaming SSR**: Wrap slow components in `<Suspense>` to enable progressive page loading.
- **Next.js Caching**: Use `revalidatePath` and `revalidateTag` for granular cache invalidation.

## Bundle Optimization
- **Dynamic Imports**: Use `dynamic()` or `React.lazy` for heavy libraries (e.g., charting, editors).
- **Tree Shaking**: Verify imports are not bringing in the entire library (e.g., `import { map } from 'lodash'` vs `import map from 'lodash/map'`).
