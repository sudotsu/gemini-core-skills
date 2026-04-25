# Frontend Refactoring Challenge (Eval 01)

## The Challenge: The "Mega-Component" Monolith
Below is a "bad" monolithic component. The goal of this eval is to verify if the Frontend Expert can refactor this into:
1.  **Atomic UI Components** (Button, Input).
2.  **Custom Hooks** (State logic).
3.  **Modular Features** (The layout).

### Bad Code (monolith.tsx)
```tsx
import React, { useState, useEffect } from 'react';

export default function UserDashboard() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);

  useEffect(() => {
    fetch('/api/user').then(res => res.json()).then(data => {
      setUser(data);
      setLoading(false);
    }).catch(() => {
      setError(true);
      setLoading(false);
    });
  }, []);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error!</div>;

  return (
    <div style={{ padding: '20px' }}>
      <h1>Welcome, {user.name}</h1>
      <button onClick={() => setIsModalOpen(true)} style={{ background: 'blue', color: 'white' }}>
        Edit Profile
      </button>
      {isModalOpen && (
        <div className="modal">
          <input type="text" defaultValue={user.name} onChange={(e) => console.log(e.target.value)} />
          <button onClick={() => setIsModalOpen(false)}>Save</button>
        </div>
      )}
      <div className="stats">
        <p>Posts: {user.postsCount}</p>
        <p>Followers: {user.followers}</p>
      </div>
    </div>
  );
}
```

## Success Criteria
1.  **Logic Extraction**: Fetching logic must move to a `useUser` hook.
2.  **UI Atomicism**: The Blue button must become a reusable `Button` component.
3.  **Modular CSS**: Styles must move to CSS Modules or Tailwind (Logical Properties).
4.  **Resilience**: The error state must use a proper `status` union instead of `loading/error` booleans.
