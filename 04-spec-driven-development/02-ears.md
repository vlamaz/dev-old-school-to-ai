# EARS (Easy Approach to Requirements Syntax)

EARS is a structured template for writing clear, concise, and unambiguous requirements in natural language. It was created by Alistair Mavin and colleagues at Rolls-Royce while analysing airworthiness regulations, and first published at the IEEE International Requirements Engineering Conference (RE'09) in 2009. See <https://alistairmavin.com/ears/>.

Every EARS requirement follows the same generic template, with the clauses always in this order:

```text
While <precondition>, when <trigger>, the <system name> shall <system response>
```

Only the system name and the response are mandatory. The keywords at the start decide which pattern you are using.

## The Five Patterns

### 1. Ubiquitous

- Keyword: none (always active).
- When to use: fundamental or continuous system properties.
- Template: `The <system> shall <response>.`
- Example: `The mobile phone shall weigh less than 150 grams.`

### 2. Event-driven

- Keyword: `When`
- When to use: the system reacts to a trigger detected at the system boundary.
- Template: `When <trigger>, the <system> shall <response>.`
- Example: `When the user clicks 'Pay', the website shall generate an invoice.`

### 3. State-driven

- Keyword: `While`
- When to use: behavior that applies only as long as a state or condition holds.
- Template: `While <precondition>, the <system> shall <response>.`
- Example: `While the battery is below 20%, the device shall reduce the screen brightness.`

### 4. Optional Feature

- Keyword: `Where`
- When to use: behavior that applies only if the product includes a specific optional feature.
- Template: `Where <feature is included>, the <system> shall <response>.`
- Example: `Where the hardware includes a fingerprint reader, the app shall offer biometric login.`

### 5. Unwanted Behavior

- Keywords: `If … then`
- When to use: the required response to unwanted situations such as errors, failures, and misuse.
- Template: `If <trigger>, then the <system> shall <response>.`
- Example: `If the uploaded file exceeds 25 MB, then the system shall reject the upload.`

## Complex Requirements

Complex requirements are not a sixth pattern. They combine the five patterns in one sentence, using the same keywords in a fixed order:

```text
Where <feature> → While <precondition> → When <trigger> / If <trigger> then → the <system> shall <response>
```

Example: `While the account is locked, when a login attempt occurs, the system shall log the event.`

## Why Use EARS?

- **Exposes missing conditions:** each requirement has to name its condition, trigger, system, and response, so gaps are easier to spot. EARS constrains structure, not vocabulary: `The system shall be fast` is still valid EARS, so vague terms must still be replaced with measurable values (for example `within 2 seconds`).
- **Test-ready:** the trigger and response map directly to the setup, action, and assertion of a test, so requirements turn easily into acceptance criteria and test cases.
- **AI-friendly:** the fixed structure gives AI coding assistants less room to misread a requirement. It reduces ambiguity in the requirement, but it does not stop the model from making mistakes. The generated code still needs review and tests.

## Example: ATM Cash Dispenser

```markdown
# Requirements Specification: ATM Cash Dispenser

## 1. Ubiquitous Requirements (Always Active)

- The **ATM** shall **display** the bank logo on the home screen.
- The **ATM** shall **encrypt** all user input data during transmission.

## 2. Event-driven Requirements (Triggered by Actions)

- **When** the user inserts a valid debit card, the **ATM** shall **prompt** for the PIN.
- **When** the user selects the "Print Receipt" option, the **ATM** shall **dispense** a paper receipt.

## 3. State-driven Requirements (Active During a Specific State)

- **While** the ATM is out of cash, the **ATM** shall **display** a "Deposit Only" message.
- **While** the network connection is offline, the **ATM** shall **disable** the cash withdrawal feature.

## 4. Optional Feature Requirements (Component Dependent)

- **Where** the ATM includes a contactless NFC reader, the **ATM** shall **allow** tap-to-login.
- **Where** the ATM includes a headphone jack, the **ATM** shall **provide** audio navigation instructions.

## 5. Unwanted Behavior Requirements (Error & Exception Handling)

- **If** the user enters an incorrect PIN three consecutive times, **then** the **ATM** shall **retain** the card.
- **If** the requested withdrawal amount exceeds the user's current account balance, **then** the **ATM** shall **display** an "Insufficient Funds" error message.

## 6. Complex Requirements (Combination of Patterns)

- **While** the system is in maintenance mode, **when** a card is inserted, the **ATM** shall **eject** the card immediately.
- **While** the receipt printer is out of paper, **when** a transaction completes, the **ATM** shall **send** a digital receipt to the user's registered email address.
```

## EARS, Gherkin, and OpenSpec Scenarios

EARS, Gherkin, and OpenSpec scenarios solve related but different problems:

- **EARS** writes the **requirement**: one sentence stating what the system shall do and under which condition.
- **Gherkin** (`Given / When / Then`, used by Cucumber and BDD tools) writes an **example**: a concrete scenario that checks the requirement, often executable as a test.
- **OpenSpec** combines both: a requirement sentence with `SHALL`/`MUST`, followed by one or more `#### Scenario:` blocks written with `GIVEN / WHEN / THEN`. See [OpenSpec](03-openspec.md).

The same rule in each style:

```markdown
EARS:
If the user enters an incorrect PIN three consecutive times, then the ATM shall retain the card.

Gherkin:
Scenario: Card retained after three wrong PINs
  Given a card with PIN 1234 is inserted
  When the user enters a wrong PIN three times
  Then the ATM retains the card

OpenSpec:
### Requirement: Card retention
The ATM SHALL retain the card after three consecutive incorrect PINs.

#### Scenario: Three wrong PINs
- GIVEN a card is inserted
- WHEN the user enters an incorrect PIN three times in a row
- THEN the ATM retains the card
```

A practical approach: write requirements in EARS, then add one or two Given/When/Then scenarios per requirement for the happy path and the main edge case. Kiro, for example, generates `requirements.md` in EARS notation.
