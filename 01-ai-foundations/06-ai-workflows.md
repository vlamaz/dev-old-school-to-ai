# AI Workflows

## AI Assisted Coding

AI-Assisted Coding is the practice of using AI tools to help generate, review, test, document, and maintain software while the developer remains responsible for design, validation, and decision-making.

Instead of writing every line of code manually, developers collaborate with AI to accelerate development and improve productivity.

Common AI Coding Tools:

- GitHub Copilot
- Claude Code
- OpenCode
- Cursor
- ChatGPT
- Gemini Code Assist

### How It Works

```text
Developer
     ↓
Provides Context & Requirements
     ↓
AI Assistant
     ↓
Generates Suggestions
     ↓
Developer Reviews & Refines
     ↓
Final Solution
```

The developer remains responsible for:

- Requirements
- Architecture
- Validation
- Security
- Quality

### Typical Workflow

1. Define the Problem

   ```text
   Create a taxi booking API.
   ```

2. Provide Context

   ```text
   Technology: .NET 9
   Architecture: Hexagonal
   Database: PostgreSQL
   ```

3. AI Generates a Solution

   ```text
   Controllers
   Services
   Repositories
   Tests
   ```

4. Review the Output

   Check:
   - Correctness
   - Security
   - Performance
   - Architecture

5. Refine

   ```text
   Add validation.
   Improve error handling.
   Generate unit tests.
   ```

### Risks

- Hallucinations: Looks correct ≠ Actually correct

- Security Issues:
  Generated code may contain:
  - Vulnerabilities
  - Hardcoded secrets
  - Unsafe practices

- Technical Debt: Blindly accepting AI-generated code can create maintenance problems.

---

## Review Workflows

Review workflows are structured processes that use AI and human expertise to validate requirements, designs, code, tests, and documentation before they reach production.

The goal is not to replace human reviews but to make them faster, more consistent, and more effective.

### Traditional Review Workflow

```text
Developer
    ↓
Pull Request
    ↓
Peer Review
    ↓
Fix Issues
    ↓
Merge
```

### AI-Assisted Review Workflow

```text
Developer
    ↓
AI Review
    ↓
Developer Fixes Issues
    ↓
Human Review
    ↓
Merge
```

1. **Requirements Review**

   Before implementation, review the requirements.

   Ask AI:

   ```text
   Review these requirements and identify:
    
   - Ambiguities
   - Missing acceptance criteria
   - Edge cases
   - Contradictions
   ```

   Example:

   ```text
   Users can cancel bookings.
   ```

   AI might detect:

   ```text
   Missing:
   - Cancellation deadline?
   - Refund rules?
   - User permissions?
   ```

2. **Specification Review**

   In Spec-Driven Development, specifications are reviewed before coding.

   Review checklist:

   Completeness

   ```text
   Are all requirements covered?
   ```

   Consistency

   ```text
   Do requirements conflict?
   ```

   Testability

   ```text
   Can acceptance criteria be tested?
   ```

   Feasibility

   ```text
   Can this realistically be implemented?
   ```

3. **Architecture Review**

   Validate design decisions before implementation.

   Prompt:

   ```text
   Review this architecture.

   Focus on:

   - Scalability
   - Security
   - Maintainability
   - Performance
   - Risks
   ```

   Common findings:
   - Tight coupling
   - Missing error handling
   - Performance bottlenecks
   - Security concerns

4. **Code Review**

   One of the most common AI workflows.

   Prompt:

   ```text
   Review this code.

   Focus on:

   - Bugs
   - Maintainability
   - Performance
   - Security
   - Clean Code principles

   Order findings by severity.
   ```

   Areas to Review:

   _Correctness_

   ```text
   Will it work?
   ```

   _Readability_

   ```text
   Is it easy to understand?
   ```

   _Maintainability_

   ```text
   Can future developers modify it?
   ```

   _Security_

   ```text
   Can it be exploited?
   ```

   _Performance_

   ```text
   Will it scale?
   ```

5. **Pull Request Review**

   Review changes before merging.

   Checklist:
   - Requirements implemented
   - Tests updated
   - Documentation updated
   - No unnecessary complexity
   - No duplicated logic

   AI can perform an initial PR review before human reviewers.

6. **Test Review**

   Review existing tests.

   Prompt:

   ```text
   Analyze these tests.
    
   Identify:
    
   - Missing scenarios
   - Edge cases
   - Untested paths
   ```

   Example findings:

   ```text
   Missing:
    
   - Invalid email
   - Empty password
   - Network failure
   ```

7. **Security Review**

   Use AI as an additional security reviewer.

   Prompt:

   ```text
   Analyze this code for:
    
   - Injection risks
   - Authentication issues
   - Authorization flaws
   - Data exposure
   ```

   Security reviews should always be validated by experienced engineers.

8. **Documentation Review**

   Verify documentation quality.

   Check:
   - Accuracy
   - Completeness
   - Readability
   - Missing examples

   Prompt:

   ```text
   Review this README.
    
   Identify missing information and unclear sections.
   ```

9. **AI Review Loop**

   A common modern workflow:

   ```text
   Implement
       ↓
   Self Review
       ↓
   AI Review
       ↓
   Fix Issues
       ↓
   Human Review
       ↓
   Merge
   ```

   This greatly reduces reviewer effort.

### Review Prompts

**Code Review**

```text
You are a Senior Software Engineer.
 
Review the following code.
 
Focus on:
- Bugs
- Security
- Performance
- Maintainability
 
Classify findings as:
Critical
High
Medium
Low
```

**Architecture Review**

```text
You are a Software Architect.
 
Review this system design.
 
Focus on:
- Scalability
- Reliability
- Security
- Maintainability

```

**Specification Review**

```text
Review this specification.
 
Identify:
- Missing requirements
- Ambiguous statements
- Untestable acceptance criteria
- Edge cases
```

---

## Debugging with AI

Debugging with AI is the practice of using AI tools to identify, analyze, explain, and resolve software issues more efficiently.

AI helps find and explain problems, but developers remain responsible for validating the fix.

### Typical Debugging Workflow

```text
Error
   ↓
Collect Context
   ↓
Ask AI to Analyze
   ↓
Identify Root Cause
   ↓
Propose Fix
   ↓
Validate
   ↓
Deploy
```

**Example**

Problem

```text
NullReferenceException
at BookingService.CreateBooking()
```

AI Prompt

```text
Analyze this exception.
 
Exception:
NullReferenceException
 
Stack Trace:
BookingService.CreateBooking()
 
Code:
[paste code here]
 
Suggest:
- Root cause
- Possible fixes
- Best practices
```

AI Output

```text
Cause:
The customer object can be null before accessing customer.Id.
 
Fix:
Add a null check before using the object.
 
Recommendation:
Use guard clauses to validate inputs.
```

### Common AI Debugging Tasks

**Error Analysis**

```text
Explain this exception.
```

Examples:

- NullReferenceException
- IndexOutOfRangeException
- HTTP 500
- SQL errors
- Build failures

**Stack Trace Analysis**

```text
Analyze this stack trace and identify the most likely root cause.
```

AI can quickly interpret long stack traces and highlight the relevant frames.

**Log Analysis**

Input:

```text
Application logs
Server logs
Container logs
```

Prompt:

```text
Analyze these logs and identify anomalies.
```

**Root Cause Analysis**

Instead of asking:

```text
How do I fix this?
```

Ask:

```text
What is the root cause?
```

This often leads to better solutions.

**Test Failure Analysis**

```text
Analyze why these unit tests are failing.
```

Provide:

- Test code
- Error output
- Production code

**Performance Investigation**

```text
Explain why this API is slow.
```

Include:

- Database queries
- Execution times
- Metrics

### Debugging Patterns

**Explain**

```text
Explain this error message.
```

**Diagnose**

```text
Identify the root cause.
```

**Compare**

```text
Compare expected behavior with actual behavior.
```

**Reproduce**

```text
Describe steps to reproduce this bug.
```

**Fix**

```text
Suggest multiple solutions with pros and cons.
```

### Example: API Failure

Input

```text
POST /bookings

Response:
500 Internal Server Error
```

Prompt:

```text
Analyze this API failure.

Expected:
Booking is created.

Actual:
500 Internal Server Error.

Logs:
[paste logs]

Code:
[paste endpoint]
```

The AI can help narrow down the issue before you start changing code.

---

## Documentation with AI

Documentation with AI is the practice of using AI tools to create, maintain, improve, and review software documentation.

Instead of writing all documentation manually, developers use AI to generate drafts, structure information, and keep documentation up to date.

AI accelerates documentation creation, but developers remain responsible for accuracy and completeness.

Unfortunately, documentation is often outdated because writing it is time-consuming.

AI makes documentation much faster to create and maintain.
