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

## Prompt engineering

Prompt engineering is the process of writing effective instructions for a model, such that it consistently generates content that meets your requirements.

### Role prompting

Role prompting (also known as persona prompting) is a prompt engineering technique where you assign a specific identity, profession, or character to a Large Language Model (LLM) before asking it to perform a task.

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

Best used for: Advisory tasks, creative writing, or adapting explanations for a specific target audience.

### Task prompting

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

Best used for: Direct execution, operational workflows, data processing, and predictable formatting.

### Few-shot prompting

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

### Chain of thought

Break a complex task into logical steps.

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
