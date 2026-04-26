# Frontend Adversarial Eval 02 — "The Looks-Modern Posts Component"

## Instructions for Evaluator

Tell the skill: **"Here's a component we just shipped. Can you take a look?"**

Do NOT mention bugs. Do NOT say "review for issues." The skill must surface problems unprompted.

---

## The Challenge

The code below uses hooks correctly, has a dependency array, and renders a list. A surface review gives it a pass. **Your job is to find the flaws before they ship.**

Do NOT refactor. Identify the specific bugs and explain exactly what goes wrong at runtime.

### Code Under Review (UserPosts.tsx)

```tsx
'use client'

import { useState, useEffect } from 'react'
import { PostsSkeleton } from '@/components/ui/PostsSkeleton'
import { fetchUserPosts } from '@/services/posts'

interface Post {
  id: string
  title: string
}

interface Props {
  userId: string
}

export function UserPosts({ userId }: Props) {
  const [posts, setPosts] = useState<Post[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchUserPosts(userId).then((data) => {
      setPosts(data)
      setLoading(false)
    })
  }, [userId]) // ✓ dependency array present

  if (loading) return <PostsSkeleton />

  return (
    <ul>
      {posts.map((post, index) => (
        <li key={index}>{post.title}</li> // ✓ key is present
      ))}
    </ul>
  )
}
```

## What the Evaluator Must Find

A passing evaluation identifies ALL of the following:

1. **Index as Key**: `key={index}` causes React to reuse DOM nodes incorrectly when the list is filtered, sorted, or paginated. Items get wrong state (e.g., a selected or expanded post stays visually selected on the wrong item after reorder). The key exists — it's just wrong.

2. **Unhandled Promise Rejection**: `fetchUserPosts(...).then(...)` has no `.catch()`. If the fetch throws (network error, 500), `loading` stays `true` forever. The user sees an infinite skeleton with no error message and no way to retry.

3. **Wrong Component Type — Waterfall**: Marking this `'use client'` and fetching inside `useEffect` means the data fetch doesn't start until the component mounts in the browser. If the parent is a Server Component, the page renders, ships to client, hydrates, *then* starts the fetch — a full waterfall. This should be a Server Component with `async/await`.

4. **Boolean Soup**: `loading` and implicit "not loading + empty posts" are two separate states that need different UI (skeleton vs. empty state vs. content). The component renders `<ul />` with no children when posts is `[]` after loading — no empty state, no user feedback.

5. **No Suspense Boundary**: Because this is `'use client'` with local state rather than a Server Component with `<Suspense>`, the parent cannot use streaming SSR for this section. The entire page must wait for the component to hydrate before this section is interactive.

## Scoring

- Found 1–2 flaws: Partial. Caught the obvious issues but missed the architectural problems.
- Found 3–4 flaws: Strong. Identified the behavioral bugs and at least one architectural issue.
- Found all 5: Excellent. Full adversarial pass — behavioral, architectural, and resilience gaps all caught.
