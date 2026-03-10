# Commit Message Guidelines

This project uses [Conventional Commits](https://www.conventionalcommits.org/) with commitlint to ensure consistent commit messages.

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Required Format Rules

- **Header**: `<type>(<scope>): <subject>` (max 150 characters)
- **Type**: REQUIRED - Must be one of the allowed types
- **Scope**: OPTIONAL - Can be anything specifying the place of the commit change
- **Subject**: REQUIRED - Brief description of the change
- **Body**: OPTIONAL - Detailed explanation of the change
- **Footer**: OPTIONAL - References to issues, breaking changes, etc.

## Commit Types

Use one of these types for every commit:

- **feat**: A new feature for the user
- **fix**: A bug fix for the user
- **docs**: Documentation changes only
- **style**: Code style changes (formatting, missing semi colons, etc.) that don't affect code meaning
- **refactor**: Code changes that neither fix a bug nor add a feature
- **test**: Adding or updating tests
- **chore**: Changes to build process, auxiliary tools, or libraries
- **perf**: Performance improvements
- **ci**: Changes to CI/CD configuration files and scripts
- **build**: Changes to build system or external dependencies
- **revert**: Reverts a previous commit

## Subject Line Rules

1. **DO NOT** start with uppercase letter (must be lowercase)
2. **DO NOT** end with a period (.)
3. **DO NOT** leave the subject empty
4. Keep the entire header under 150 characters
5. Use imperative mood ("add feature" not "added feature" or "adds feature")
6. Be concise but descriptive

## Examples

### ✅ Good Commit Messages

```
feat(auth): add Google OAuth2 authentication
```

```
fix(dashboard): resolve chart rendering issue on mobile devices
```

```
docs(readme): update installation instructions for Node.js 18+
```

```
refactor(api): simplify user profile data fetching logic
```

```
perf(images): optimize image loading with lazy loading
```

```
chore(deps): upgrade next.js to version 14.0.0
```

```
style(components): format button component with prettier
```

```
test(auth): add unit tests for login validation
```

### ❌ Bad Commit Messages

```
Feat(auth): Add Google OAuth  ❌ Type should be lowercase
```

```
feat(auth): add google oauth.  ❌ No period at the end
```

```
feat(auth):  ❌ Subject cannot be empty
```

```
feat(auth): Add Google OAuth  ❌ Subject should be lowercase
```

```
added new feature  ❌ Missing type and wrong tense
```

```
fix: bug  ❌ Too vague, not descriptive enough
```

## Scopes (Examples)

Use scopes to specify what part of the codebase is affected:

- **auth**: Authentication and authorization
- **dashboard**: Dashboard components
- **api**: API integrations
- **ui**: UI components
- **profile**: User profile features
- **settings**: Settings pages
- **database**: Database related changes
- **deps**: Dependencies
- **config**: Configuration files

## Breaking Changes

If your commit introduces breaking changes, use `!` after the type/scope:

```
feat(api)!: change authentication endpoint structure
```

## Validation

All commits are automatically validated against these rules using commitlint. If your commit message doesn't follow the format, the commit will be rejected.
