# Prompting

Prompting is the process of providing input to a model. The quality of your output often depends on how well you’re able to prompt the model.

## Anatomy of a Good Prompt

The quality of the output often depends on the quality of the prompt.

A good prompt usually contains:

```text
Role
Context
Task
Constraints and rules
Output format
```

### Role

Defines who the AI should act as.

```text
You are a senior fronted developer.
```

### Context

Background information.

```text
The application uses React, TypeScript and Material UI.
```

### Goal (Task)

What needs to be accomplished. Defines the objective.

```text
Build a React login page.
```

### Constraints and rules

Rules and limitations.

```text
Use functional components.
Do not use Redux.
```

### Output formatting

Desired format.

```text
Return only code.
```

---

## Prompt engineering

Prompt engineering is the process of writing effective instructions for a model, such that it consistently generates content that meets your requirements.

### Prompting patterns

Prompt Patterns are reusable prompting techniques that guide AI models toward more reliable, consistent, and effective outputs for specific types of tasks.

#### 1. Role prompting

Tell the AI who it should be.

Example:

```text
You are a senior software architect.

Design a scalable taxi booking system.
```

Common roles:

- Solution Architect
- Senior Backend Engineer
- Product Owner
- QA Engineer
- Security Specialist

Use when:

- Seeking expert advice
- Requiring domain-specific knowledge
- Needing consistent behavior

#### 2. Task prompting

Task Prompting is the practice of clearly telling an AI what you want it to do.

A task prompt defines the objective, expected outcome, and scope of work.

A clear task:

- Reduces ambiguity
- Produces more accurate results
- Requires fewer follow-up prompts
- Improves consistency

Example:

```markdown
Task:
Create a REST API for taxi bookings.

Requirements:

- CRUD operations
- JWT authentication
- PostgreSQL

Constraints:

- Use Node.js and Express
- Follow Hexagonal Architecture

Output:

- Folder structure
- Source code
- Explanation
```

Use when:

- Requesting deliverables
- Delegating work to AI

#### 3. Structured Prompt Pattern

Organize the prompt into sections.

```text
Role:
Senior React Engineer
 
Context:
Taxi Booking Application
 
Task:
Create booking page
 
Requirements:
- Maps
- Price estimation
 
Output:
React TypeScript code
```

Use when:

- Complex tasks
- Large outputs
- Production work

#### 4. Few-shot prompting

Provide several examples to teach the pattern.

Useful when consistent output formatting is required.

```text
Convert requirements into User Stories.

Example 1

Requirement:
Users can reset their password.

Output:
As a registered user,
I want to reset my password,
So that I can regain access to my account.

Example 2

Requirement:
Users can update their profile.

Output:
As a registered user,
I want to update my profile information,
So that my account details remain current.

Now convert this requirement:

Requirement:
Users can cancel a taxi booking.
```

Use when:

- Format consistency matters
- Teaching a custom style

#### 5. Chain of thought

Break a complex task into logical steps. Ask AI to reason step-by-step.

Instead of:

```text
Design the entire system.
```

Use:

```text
1. Identify requirements
2. Design architecture
3. Define APIs
4. Identify risks
5. Recommend implementation plan
```

Complex problems become easier for the model to solve.

Use when:

- Complex problems
- Planning
- Architecture decisions
- Root-cause analysis

#### 6. Decomposition Pattern

Break a large problem into smaller ones.

```text
Analyze this feature by:

1. Requirements
2. Architecture
3. API Design
4. Database Design
5. Risks
```

Use when:

- Large projects
- Specifications
- Solution design

#### 7. Critic Pattern

Ask AI to review and criticize its own output.

```text
Create a solution.
```

 
Then review the solution and identify weaknesses.

Use when:

- Architecture reviews
- Requirement validation
- Risk analysis

#### 8. Debate Pattern

Generate multiple viewpoints.

```text
Argue both for and against microservices for this project.
```

Use when:

- Decision making
- Trade-off analysis
- Architecture discussions

#### 9. Socratic Pattern

Ask questions instead of providing solutions immediately.

```text
Act as a mentor.
 
Help me design this system by asking questions one at a time.
```

Use when:

- Learning
- Coaching
- Requirements discovery

#### 10. Output Formatting Pattern

Specify the desired response format.

```text
Return the result as:
 
- User Story
- Acceptance Criteria
- EARS Requirements
```

or

```text
Return JSON only.
```

Use when:

- Automation
- Structured outputs
- Agent workflows

#### 11. Planning Pattern

Generate a plan before implementation.

```text
Do not write code.
 
First create an implementation plan.
```

Use when:

- Large features
- Agentic workflows
- Spec Driven Development

#### 12. Specification Pattern

Generate requirements before design or code.

```text
Create:
 
1. User Stories
2. Acceptance Criteria
3. EARS Requirements
4. Functional Requirements
 
Do not provide implementation details.
```

Use when:

- OpenSpec
- Kiro
- BMAD
- Spec Kit
- SDD

#### 13. Reflection Pattern

Ask AI to evaluate its work and improve it.

```text
Generate a solution.
 
Then evaluate it against best practices.
 
Then improve it.
```

Use when:

- High-quality outputs
- Documentation
- Architecture proposals

#### 14. Agent Delegation Pattern

Divide work into specialized roles.

```text
Architecture Agent:
Design the solution.
 
Security Agent:
Review security risks.
 
QA Agent:
Generate test cases.
 
Combine the results.
```

Use when:

- Agentic engineering
- Multi-agent systems
- Complex projects

---

## Context engineering

Prompt Engineering focuses on instructions.

Context Engineering focuses on providing the right information.

Examples:

- Requirements
- API documentation
- README files
- Architecture documents
- Coding standards

Many modern AI workflows rely more on context than prompting.

## Links

- OpenAI Developers Docs - Prompting: https://developers.openai.com/api/docs/guides/prompting
- Prompt Engineering Guide: https://www.promptingguide.ai

```

```
