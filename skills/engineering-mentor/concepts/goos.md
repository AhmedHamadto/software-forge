# Growing Object-Oriented Software, Guided by Tests (Freeman & Pryce) — Teaching Content

## TDD Red-Green-Refactor

### Deep (first exposure)

Most developers learn testing as something you do after the code works — write the feature, then add tests to verify it. Freeman and Pryce argue in Part I of GOOS that this gets the value proposition backwards. The power of TDD is not verification; it is design feedback. Writing the test first forces you to think about how the code will be used before you think about how it will be implemented. The test becomes the first client of your API, and if the test is awkward to write, that is a signal that the API is awkward to use.

The Red-Green-Refactor cycle has three steps, and the order is non-negotiable. **Red:** write a test that describes the behavior you want. Run it. Watch it fail. The failure matters — it confirms the test is actually testing something and that the behavior does not already exist. **Green:** write the absolute minimum code to make the test pass. This means resisting the urge to implement the full feature. If the test expects `add(2, 3)` to return `5`, you might literally return `5`. This feels absurd, but it forces you to write another test that demands more general behavior. **Refactor:** now that the test is green, clean up the implementation. Remove duplication, extract methods, improve names. The tests give you confidence that your refactoring has not broken anything.

Consider building an order discount calculator. You start with a test: "an order with no items has a zero discount." You write the test, it fails (Red). You make it pass by returning 0 (Green). Next test: "an order with total over $100 gets 10% off." It fails (Red). You add a conditional to check the total (Green). Then you notice duplication or a hardcoded threshold and refactor it into a configurable rule (Refactor). Each cycle takes minutes, not hours. You build up complex behavior through a series of small, verified increments.

The discipline of "minimal implementation" is where most people struggle. The temptation is to write a test, then implement the whole feature because "I already know what it needs to do." But Freeman and Pryce warn that this skips the design feedback loop. When you write only what the test demands, gaps in your test coverage become immediately visible — if a behavior is not tested, it does not exist in the code. When you implement ahead of your tests, you end up with untested code paths that you assume work. The refactor step is equally critical and equally skipped. Without it, the code accumulates structural debt with every passing test. The rhythm is Red, Green, Refactor — not Red, Green, Red, Green, Red, Green, then maybe refactor later.

### Refresher (subsequent exposure)

Red-Green-Refactor is a strict cycle: write a failing test, make it pass with minimal code, then clean up the design. The order matters because writing tests first gives you design feedback, minimal implementations reveal coverage gaps, and the refactor step prevents structural debt from accumulating. Do not skip or reorder the steps.

### Socratic Questions

- You are implementing a function that validates email addresses. You write a test for a valid email, make it pass, then immediately implement full RFC 5322 validation because "you know you'll need it." What did you skip in the TDD cycle, and what is the risk?
- A colleague shows you a codebase with 95% test coverage but the tests were all written after the implementation. How might the design of this code differ from code that was written test-first, and what specific problems might you expect to find?
- You have just made your test green with a minimal implementation and are about to write the next test. But you notice the function has three nested if-statements. Should you refactor now or write the next test first? What is Freeman and Pryce's guidance on when to refactor versus when to move on?

---

## Test Pyramid

### Deep (first exposure)

Not all tests are created equal. A unit test that runs in 5 milliseconds and tests a single function gives you fundamentally different feedback from an end-to-end test that spins up a browser, clicks through a UI, hits a real database, and takes 30 seconds. The Test Pyramid, which Freeman and Pryce discuss as part of their testing strategy, describes the ideal proportion: many fast unit tests at the base, fewer integration tests in the middle, and very few end-to-end tests at the top. The shape matters because it directly determines how fast your feedback loop is and how reliably your test suite catches real bugs versus generating false alarms.

Unit tests form the base of the pyramid. They test individual functions, classes, or modules in isolation, mocking or stubbing their dependencies. They run in milliseconds, so you can run hundreds of them after every save. They tell you immediately when you break a calculation, a validation rule, or a state transition. Integration tests sit in the middle. They test that two or more components work together correctly — that your repository actually queries the database correctly, that your API handler correctly serializes responses, that your service layer correctly coordinates between modules. They are slower (seconds each, because they might hit a database or file system) but they catch wiring mistakes that unit tests miss. End-to-end tests sit at the top. They test complete user workflows through the full stack. They are the slowest, the most brittle (sensitive to UI changes, timing issues, external dependencies), and the most expensive to maintain.

The problem with inverting the pyramid — having mostly end-to-end tests and few unit tests — is devastating to development speed. A test suite that takes 45 minutes to run means developers stop running it locally. They push code and wait for CI. CI becomes a bottleneck. When tests fail, the failures are hard to diagnose because an end-to-end test that fails could have broken at any of the 15 layers it touches. Teams start ignoring flaky tests, then ignoring test failures entirely, and the suite becomes a liability rather than a safety net.

Each level of the pyramid has a clear responsibility. Unit tests verify business logic and algorithmic correctness. Integration tests verify that components connect correctly — serialization, database queries, API contracts. End-to-end tests verify that critical user journeys work through the entire system. When you are deciding where a test belongs, ask: "What is the simplest level that can catch this bug?" If a unit test can catch it, do not write an integration test. If an integration test can catch it, do not write an end-to-end test. Push testing down to the lowest level possible, and only go higher when lower levels cannot cover the scenario.

### Refresher (subsequent exposure)

The Test Pyramid says: many fast unit tests, fewer integration tests, very few end-to-end tests. The shape ensures fast feedback and reliable test suites. Inverting the pyramid — heavy on E2E, light on unit tests — makes the suite slow, flaky, and expensive. Push each test to the lowest level that can catch the bug it targets.

### Socratic Questions

- Your project has 20 unit tests and 150 Cypress end-to-end tests. The CI pipeline takes 25 minutes, and tests fail randomly about once a week due to timing issues. What is wrong with this test distribution, and how would you restructure it?
- You are testing that a discount is correctly applied to an order. You could write a unit test for the discount calculation function, an integration test that creates an order through the service layer, or an E2E test that goes through the checkout UI. Which level should this test live at, and why?
- A teammate argues that end-to-end tests are the most valuable because "they test what the user actually does." What is the counterargument from the Test Pyramid perspective, and when are E2E tests genuinely the right choice?
