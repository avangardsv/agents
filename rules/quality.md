# Quality Standards and Testing Guidelines

## Testing Requirements

### Unit Testing Standards
- **Coverage**: ≥ **80%** - CI fails below threshold
- **Test Framework**: Use project-appropriate testing framework (Jest, pytest, Go test, etc.)
- **Integration Tests**: Test API endpoints and database interactions with appropriate tools
- **Database Testing**: Use deterministic seeds; isolate test data where feasible

### Test Patterns
- **State Tests**: MUST cover loading, error, empty states and conditional branches
- **Mocks**: Use realistic test data; spy only to verify behavior, not implementation
- **Component Tests**: Verify error handling, user interactions, and edge cases
- **API Tests**: Test authentication, validation, error responses, and success paths

### Static Analysis
- **Linting**: Use language-appropriate linters with zero errors policy
- **Formatting**: Enforce consistent code formatting across the project
- **Type Checking**: If using typed language, type checker must pass without errors
- **Security Scanning**: Run static analysis for security vulnerabilities

## CI/CD Pipeline

### Required Stages
```bash
lint → [type-check] → test → build
```
- PR blocked on any failure
- All stages must pass before merge
- Type checking stage only applies to typed languages

### Pre-commit Hooks
- Format and lint staged files
- Prevent commits with linting errors
- Validate commit message format (conventional commits preferred)
- Run security checks on sensitive files

## Code Quality Gates

### Component/Module Standards
- Follow project's architectural patterns consistently
- Use appropriate naming conventions for the language/framework
- Ensure proper separation of concerns
- Follow dependency injection patterns where applicable

### Error Handling
- Never swallow errors silently
- Use consistent error handling patterns
- Provide meaningful error messages to users
- Log errors with sufficient context (no PII)
- Implement proper error recovery where possible

### Performance Standards
- Measure performance before optimizing
- Profile code to identify actual bottlenecks
- Use appropriate caching strategies
- Optimize resource usage (memory, CPU, network)
- Avoid premature optimization

## Security Requirements

### Environment Management
- Use environment schema validation appropriate for your platform
- Never log secrets, tokens, or PII
- Pin dependency versions for reproducible builds
- Avoid unnecessary build-time scripts and hooks
- Run security audits regularly using platform tools

### Code Security
- Validate and sanitize all external inputs
- Use parameterized queries or prepared statements for databases
- Follow security best practices for your technology stack
- Implement proper authentication and authorization
- Keep dependencies up to date with security patches

## Accessibility Standards (Web Projects)

### Basic Requirements
- Use semantic markup and proper document structure
- Ensure keyboard navigation works throughout the application
- Implement proper focus management for interactive elements
- Use accessibility attributes only when semantic markup isn't sufficient

### Internationalization (When Required)
- Externalize user-facing strings for translation
- Support right-to-left layouts if needed
- Use locale-appropriate date/time/number formatting
- Consider cultural differences in UI patterns

## Documentation Standards

### Code Documentation
- Write self-documenting code that doesn't need comments
- Document public APIs using language-appropriate conventions
- Avoid redundant or noisy comments
- Keep documentation synchronized with code changes

### README Requirements
- Installation and setup instructions
- Usage examples with working commands
- API documentation for libraries
- Contributing guidelines for team projects

## Dependency Management

### Dependency Standards
- Pin exact versions in production
- Regular security audit reviews
- Minimize dependency count
- Prefer well-maintained packages
- Document any security overrides

### Update Process
- Test updates in development first
- Review changelogs for breaking changes
- Update lockfiles consistently
- Monitor for security vulnerabilities

## Enforcement

### Automated Enforcement
- Pre-commit hooks block bad commits
- CI pipeline enforces all quality gates
- Automated dependency vulnerability scanning
- Code coverage tracking and reporting

### Manual Review
- All PRs require at least one approval
- Code review checklist includes quality standards
- Architecture decisions documented
- Security considerations reviewed for sensitive changes