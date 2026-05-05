---
name: write-tests
description: "Write comprehensive, principled tests for code."
when_to_use: "Use when the user asks to write tests, add tests, create a test suite, test a file/function/module, or improve coverage."
argument-hint: "<file, function, or module to test>"
allowed-tools:
  - Bash
  - Read
  - Edit
  - Write
  - Grep
  - Glob
---

# Write Tests

Write comprehensive, principled tests for the specified target: `$ARGUMENTS`

## Step 1: Understand the Target

1. Read the target source code and understand its behavior, inputs, outputs, and side effects.
2. Identify the public interface — these are what tests should exercise.
3. Map dependencies and external interactions (DB, network, filesystem, third-party APIs).
4. Note error conditions, edge cases, and boundary values.

## Step 2: Detect Project Conventions

1. Identify the testing framework already in use (pytest, unittest, Jest, Vitest, Go testing, etc.).
2. Review existing test files for naming conventions, directory structure, and patterns.
3. Check for test configuration files (pytest.ini, conftest.py, jest.config.js, etc.).
4. Match the project's style — don't introduce a new pattern.

## Step 3: Plan Test Cases

Before writing code, list the test cases you will write. Organize by category:

**Happy path** — Normal expected usage with valid inputs.
**Edge cases** — Empty inputs, None/null, zero, single element, maximum/minimum values, unicode, whitespace.
**Error cases** — Invalid inputs, missing required fields, type errors, permission failures.
**Boundary conditions** — Off-by-one, empty collections, very large inputs, concurrent access.
**Integration points** — If the code interacts with external systems, plan integration tests separately from unit tests.

Announce your test plan before writing any tests.

## Step 4: Write Tests

### Principles (Follow These Strictly)

**FIRST:**
- **Fast** — Tests run in milliseconds. No unnecessary I/O or sleeps.
- **Independent** — No test depends on another test's state or execution order.
- **Repeatable** — Same result every time, in any environment. No flakiness.
- **Self-validating** — Pass or fail, no human interpretation needed.
- **Timely** — Written alongside or before the code they test.

**Test behavior, not implementation:**
- Assert on outputs and observable side effects.
- Do NOT assert on which internal methods were called or in what order.
- If a refactor doesn't change behavior, zero tests should break.

**One concept per test:**
- Each test should fail for exactly one reason.
- A test name should describe the behavior being verified, not the method being called.
- Bad: `test_process`, `test_function_works`
- Good: `test_returns_empty_list_when_no_items_match`, `test_raises_value_error_for_negative_amount`

**Arrange-Act-Assert:**
```
# Arrange — set up inputs and dependencies
# Act — call the thing being tested (one action)
# Assert — verify the result
```
One act per test. If you need multiple acts, it's multiple tests.

### Mocking Guidelines

| Mock | Don't Mock |
|------|------------|
| External APIs, network calls | Your own internal functions |
| Databases (in unit tests) | Pure logic and computations |
| Filesystem, time, randomness | Deterministic code |
| Third-party services | Simple data transformations |

- Mock at the boundary, not deep inside the code.
- If a test is mostly mock setup, you're testing the mocks, not the code.
- Prefer real collaborators when feasible. Reserve mocks for true external boundaries.

### What NOT to Test

- Framework behavior (don't test that `json.loads` parses JSON).
- Trivial getters/setters with no logic.
- Third-party library internals.
- Implementation details that could change without affecting behavior.

## Step 5: Verify Tests

1. Run the tests and confirm they pass.
2. If writing tests for new code, verify each test fails when the behavior is removed (sanity check).
3. Check that tests are isolated — run them in a different order if possible.
4. Ensure no test depends on external state (network, specific files, environment variables) unless it's explicitly an integration test.

## Step 6: Review Test Quality

Before finishing, check each test against these criteria:

- [ ] Name describes the behavior, not the method
- [ ] Tests one concept only
- [ ] Follows Arrange-Act-Assert structure
- [ ] No logic in the test (no if/else, loops, or try/catch in test body)
- [ ] Uses meaningful assertion messages where helpful
- [ ] Test data is obvious and minimal — no magic numbers without context
- [ ] Mocks are at boundaries only, not over-used
- [ ] No shared mutable state between tests
- [ ] Deterministic — no randomness, wall-clock time, or network calls (unless integration test)

## Language-Specific Patterns

### Python (pytest)

```python
import pytest

class TestCalculateTax:
    def test_calculates_tax_for_positive_amount(self):
        result = calculate_tax(amount=100, rate=0.08)
        assert result == 8.0

    def test_returns_zero_for_zero_amount(self):
        result = calculate_tax(amount=0, rate=0.08)
        assert result == 0.0

    def test_raises_for_negative_amount(self):
        with pytest.raises(ValueError, match="must be positive"):
            calculate_tax(amount=-100, rate=0.08)

    @pytest.mark.parametrize("amount,rate,expected", [
        (100, 0.10, 10.0),
        (200, 0.05, 10.0),
        (0, 0.10, 0.0),
    ])
    def test_calculates_correctly_for_various_inputs(self, amount, rate, expected):
        assert calculate_tax(amount, rate) == expected
```

**pytest conventions:**
- Use `conftest.py` for shared fixtures. Don't duplicate fixture logic across files.
- Use `@pytest.fixture` for setup, not `setUp`/`tearDown` methods.
- Use `@pytest.mark.parametrize` for data-driven tests instead of copy-pasting.
- Use `tmp_path` fixture for filesystem tests instead of creating real temp directories.
- Use `monkeypatch` for patching instead of `unittest.mock` when possible.
- Group related tests in classes. Use plain functions for standalone tests.

### JavaScript/TypeScript (Jest/Vitest)

```javascript
describe('calculateTax', () => {
  it('calculates tax for positive amount', () => {
    const result = calculateTax(100, 0.08);
    expect(result).toBe(8);
  });

  it('returns zero for zero amount', () => {
    expect(calculateTax(0, 0.08)).toBe(0);
  });

  it('throws for negative amount', () => {
    expect(() => calculateTax(-100, 0.08)).toThrow('must be positive');
  });
});
```

### Go

```go
func TestCalculateTax(t *testing.T) {
    tests := []struct {
        name     string
        amount   float64
        rate     float64
        expected float64
    }{
        {"positive amount", 100, 0.08, 8.0},
        {"zero amount", 0, 0.08, 0.0},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := CalculateTax(tt.amount, tt.rate)
            if got != tt.expected {
                t.Errorf("CalculateTax(%v, %v) = %v, want %v", tt.amount, tt.rate, got, tt.expected)
            }
        })
    }
}
```

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Bad | Do This Instead |
|---|---|---|
| Testing private methods directly | Couples tests to implementation | Test through the public interface |
| Multiple asserts testing different concepts | Unclear what failed and why | One concept per test |
| Copy-paste test code everywhere | Hard to maintain, hides intent | Extract fixtures/helpers, but keep tests readable (DAMP > DRY) |
| Testing the mock instead of the code | Proves nothing about real behavior | Assert on outputs, not on mock call counts |
| Chasing 100% coverage blindly | Wastes time on trivial code | Focus coverage on critical and complex paths |
| Shared mutable state between tests | Order-dependent failures, flakiness | Fresh state per test via setup/fixtures |
| Testing framework behavior | Proves the framework works, not your code | Only test your logic |
| Sleeping in tests | Slow and flaky | Use proper async patterns or mocked time |

## Output

- Place test files following the project's existing conventions.
- Use `describe`/`it` blocks (JS) or test classes/functions (Python) for clear organization.
- Include setup and teardown where appropriate.
- Add brief inline comments only for non-obvious test rationale.
