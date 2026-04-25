# Backend Architecture & System Design

## 1. Clean Architecture (Hexagonal / Ports & Adapters)
**The Goal**: Decouple business logic from external dependencies (DB, Web Framework, Third-party APIs).
- **Entities**: Core business logic and data structures. Independent of everything.
- **Use Cases**: Application-specific business rules. Coordinates data flow to and from entities.
- **Interfaces (Ports)**: Define how the application interacts with the outside world (e.g., `UserRepository` interface).
- **Adapters (Adapters)**: Implementations of ports (e.g., `PostgresUserRepository`, `RestUserController`).

## 2. Domain-Driven Design (DDD)
- **Bounded Contexts**: Explicitly define the boundary where a particular domain model is defined and applicable.
- **Aggregate Roots**: Ensure data consistency within a boundary by controlling access to entities.
- **Value Objects**: Use immutable objects (e.g., `EmailAddress`, `Money`) to encapsulate logic and prevent primitive obsession.

## 3. Anti-Monolith & Modular Monolith
**The Goal**: Prevent "Spaghetti Code" as the project grows.
- **Module Boundaries**: Strictly enforce that modules only communicate through public APIs or events.
- **Internal APIs**: Use internal interfaces to allow a future split into microservices without rewriting core logic.
- **Dependency Inversion**: Always depend on interfaces, never on concrete classes/implementations.

## 4. Communication Patterns
- **Synchronous**: REST/gRPC for immediate requests.
- **Asynchronous**: Message Queues (Redis, RabbitMQ) for background tasks (Email, Processing).
- **Idempotency**: Ensure that repeated requests (e.g., retries) result in the same state without duplicate side effects.
