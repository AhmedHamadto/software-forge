---
name: code-simplifier
description: Simplify complex code by removing unnecessary abstractions, over-engineering, and cognitive overhead. Use this skill at the end of coding sessions or to clean up complex PRs. Focuses on making code easier to read, understand, and maintain.
---

This skill analyzes code and aggressively simplifies it by removing unnecessary complexity, over-engineering, and cognitive overhead. The goal is code that is immediately understandable by any developer.

## When to Use This Skill

- At the end of a long coding session to clean up accumulated complexity
- When reviewing PRs that feel "heavy" or over-engineered
- When code works but feels harder to understand than it should be
- When you suspect premature abstraction or over-generalization
- After implementing a feature, to strip it down to essentials

## Core Philosophy

**Simple code is not naive code.** Simple code is the result of deep understanding. It takes more effort to write simple code than complex code. The goal is to reduce cognitive load for the next developer (including future you).

> "Perfection is achieved not when there is nothing more to add, but when there is nothing left to take away." - Antoine de Saint-Exupery

## Simplification Targets

### 1. Unnecessary Abstractions

**Remove abstractions that don't earn their keep:**
- Wrapper classes that just delegate to one thing
- Interfaces with only one implementation (and no planned others)
- Abstract base classes that provide no shared behavior
- Factory patterns for objects that are created in one place
- Dependency injection for dependencies that never change
- Service classes that are just function bags

**Before:**
```typescript
interface IUserRepository {
  getUser(id: string): Promise<User>;
}

class UserRepositoryImpl implements IUserRepository {
  async getUser(id: string): Promise<User> {
    return db.users.findOne({ id });
  }
}

class UserService {
  constructor(private repo: IUserRepository) {}

  async getUser(id: string): Promise<User> {
    return this.repo.getUser(id);
  }
}
```

**After:**
```typescript
async function getUser(id: string): Promise<User> {
  return db.users.findOne({ id });
}
```

### 2. Over-Generalization

**Code should solve the actual problem, not hypothetical future problems:**
- Configuration for things that will never be configured
- Plugin systems with one plugin
- Generic type parameters that are always the same type
- Options objects with one option
- Event systems for things that happen once

**Rule of Three:** Don't abstract until you have three concrete examples. Two is a coincidence.

### 3. Premature Optimization

**Remove complexity added for performance without measurement:**
- Caching that wasn't proven necessary
- Memoization of cheap operations
- Lazy loading of small data
- Connection pooling for infrequent operations
- Batch processing that could be sequential

**Keep it simple, profile later.**

### 4. Defensive Over-Coding

**Trust the system more:**
- Null checks for values that can't be null
- Type guards for known types
- Validation at internal boundaries (validate at edges only)
- Error handling for errors that can't happen
- Fallbacks for conditions that won't occur

### 5. Structural Complexity

**Flatten and inline:**
- Deep nesting (prefer early returns)
- Long method chains (break into steps with clear names)
- Callback pyramids (use async/await)
- Excessive file splitting (keep related code together)
- Over-modularization (a 500-line file is fine if it's cohesive)

### 6. Naming and Comments

**Let the code speak:**
- Remove comments that describe what code does (the code already says that)
- Shorten over-verbose variable names (`userThatIsCurrentlyLoggedIn` -> `user`)
- Remove type info from names (`strName` -> `name`)
- Delete commented-out code
- Remove TODO comments for things you'll never do

### 7. Dead Code

**Delete ruthlessly:**
- Unused functions, classes, and variables
- Unreachable code paths
- Feature flags for launched features
- Backwards-compatibility shims for old versions
- Deprecated code with no deprecation timeline

### 8. Unnecessary Indirection

**Direct is better:**
- Getters/setters that just access fields
- Methods that just call another method
- Variables that are used once immediately after assignment
- Constants for values used in one place
- Enums with one member

## Process

### Step 1: Inventory
Use grep, glob, and read tools to understand the code:
- Map out the structure (files, modules, classes)
- Identify entry points and data flow
- Note dependencies and their usage patterns
- Look for repetition and patterns

### Step 2: Identify Targets
For each file/module, ask:
- Can this be deleted entirely? (unused code)
- Can this be merged with something else? (over-splitting)
- Can this be inlined? (unnecessary indirection)
- Can this be simplified? (over-complexity)
- Is this solving a real problem or a hypothetical one?

### Step 3: Propose Changes
For each simplification:
- Show the current code
- Show the simplified version
- Explain what was removed and why it's safe
- Note any behavioral changes (there should be none)

### Step 4: Implement
Make the changes:
- Delete dead code first (safest)
- Inline unnecessary abstractions
- Merge over-split files
- Simplify remaining logic
- Run tests after each significant change

## Output Format

### Summary
- Total lines removed / percentage reduction
- Number of files deleted or merged
- Key abstractions eliminated
- Complexity score before/after (subjective 1-10)

### Changes Made
For each change:
```
## [File/Component Name]

### Removed
- [What was removed and why]

### Simplified
- [What was simplified and how]

### Before (X lines)
[Code snippet]

### After (Y lines)
[Code snippet]
```

### Verification
- Tests still passing
- Functionality preserved
- No regressions introduced

## Anti-Patterns to Watch For

These patterns often indicate over-engineering:
- `AbstractSingletonProxyFactoryBean`
- `IServiceProviderFactory`
- `BaseAbstractHandler`
- Files named `utils.ts`, `helpers.ts`, `common.ts` (often grab bags)
- Directories with single files
- Generics with default types that are always used

## When NOT to Simplify

Keep complexity when:
- It's genuinely needed for correctness
- It measurably improves performance in a hot path
- It's required for backwards compatibility with external consumers
- It reflects real domain complexity
- Removing it would make the code harder to test

## Example Transformations

### Config Object -> Direct Values
```typescript
// Before
const config = {
  apiUrl: 'https://api.example.com',
  timeout: 5000,
};
fetch(config.apiUrl, { timeout: config.timeout });

// After (if these values are only used here)
fetch('https://api.example.com', { timeout: 5000 });
```

### Class -> Function
```typescript
// Before
class EmailValidator {
  validate(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }
}
const validator = new EmailValidator();
validator.validate(email);

// After
function isValidEmail(email: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}
isValidEmail(email);
```

### Nested Callbacks -> Async/Await
```typescript
// Before
getUser(id, (user) => {
  getOrders(user.id, (orders) => {
    getProducts(orders[0].id, (products) => {
      render(products);
    });
  });
});

// After
const user = await getUser(id);
const orders = await getOrders(user.id);
const products = await getProducts(orders[0].id);
render(products);
```

## Remember

The best code is code that doesn't exist. Every line is a liability. Be aggressive about deletion. The goal is not minimal code but maximally understandable code. Sometimes that means more lines (for clarity), but usually it means fewer.
