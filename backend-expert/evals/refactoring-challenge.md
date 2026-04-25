# Backend Refactoring Challenge (Eval 01)

## The Challenge: The "Spaghetti CRUD" Monolith
Refactor this monolithic API handler into a **Clean Architecture** structure:
1.  **Entity**: The `User` business logic.
2.  **Use Case**: The `CreateUser` logic.
3.  **Adapter**: The `UserController` and `DatabaseRepository`.

### Bad Code (app.js)
```javascript
const express = require('express');
const db = require('./db');
const app = express();

app.post('/users', async (req, res) => {
  const { name, email, password } = req.body;
  
  // Validation mixed with logic
  if (!email.includes('@')) return res.status(400).send('Invalid email');
  
  // DB logic mixed with controller
  const existing = await db.query('SELECT * FROM users WHERE email = $1', [email]);
  if (existing.rows.length > 0) return res.status(400).send('User exists');
  
  const hashedPassword = await hash(password); // Imaginary hash function
  const user = await db.query('INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING *', [name, email, hashedPassword]);
  
  // External side effect mixed in
  await sendWelcomeEmail(email); 
  
  res.status(201).json(user.rows[0]);
});
```

## Success Criteria
1.  **Decoupling**: The route handler should only call a Use Case.
2.  **Persistence**: The SQL query must move to a Repository implementation.
3.  **Validation**: Use a schema validator (Zod/Joi).
4.  **Inversion**: The Use Case should depend on an interface for the Repository.
