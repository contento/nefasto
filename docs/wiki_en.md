# Prolog Discourse Generator - English Wiki

*A pure-Prolog narrative generator reviving 1989 Turbo Prolog with modern SWI-Prolog. Created for Obsidian vault compatibility.*

---

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Core Concepts](#core-concepts)
- [DCG & Grammar](#dcg--grammar)
- [Word Banks & Dictionaries](#word-banks--dictionaries)
- [Ontology & Coherence](#ontology--coherence)
- [State Tracking](#state-tracking)
- [Configuration](#configuration)
- [TUI Usage](#tui-usage)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Turbo Prolog History](#turbo-prolog-history)

---

## Overview

### What Problem Does This Solve?

Traditional narrative generation relies on:
- Statistical language models (Markov chains, n-grams)
- Neural language models (transformers, LLMs)
- Hand-written story templates

This project asks: **What if we only used pure logic?**

No neural networks. No machine learning. No external APIs. Just Prolog's unification, backtracking, and pattern matching—the same techniques available in 1989's Turbo Prolog.

### Key Features

- **Pure Logic**: Only Prolog. No dependencies beyond SWI-Prolog.
- **Coherent Output**: Ontologies and state tracking prevent contradictions.
- **Reproducible**: Same seed produces same narrative every time.
- **Transparent**: Trace every decision from word choice to sentence structure.
- **Extensible**: Add words to dictionaries, new rules to grammar, new templates.
- **Bilingual**: English and Spanish from the ground up.
- **Cross-Platform**: Works on Linux, macOS, Windows.

### Design Philosophy

**Simplicity Over Sophistication**

- Random word selection, not n-gram prediction
- Handwritten rules, not learned patterns
- Small dictionaries, grown intentionally
- Basic narrative templates, understood completely

This approach trades raw fluency for clarity, reproducibility, and educational value.

---

## Getting Started

### Installation

```bash
# 1. Install SWI-Prolog
# macOS: brew install swi-prolog
# Linux: sudo apt install swi-prolog
# Windows: Download from swi-prolog.org

# 2. Clone or extract this repository
cd prolog-discourse-gen

# 3. Run the interactive menu
swipl -l src/main.pl
```

### First Run

```bash
# Generate a random English story
swipl -l src/main.pl -- --lang en

# Generate a Spanish story with a fixed seed
swipl -l src/main.pl -- --lang es --seed 42

# Load custom configuration
swipl -l src/main.pl -- --config config/default.yaml
```

### Typical Workflow

1. Start TUI: `swipl -l src/main.pl`
2. Select "Generate Discourse"
3. Choose narrative type (Story, Dialogue, Description)
4. Read output
5. Adjust language/seed in settings
6. Repeat

---

## Core Concepts

### 1. DCG (Definite Clause Grammar)

**What it is**: Prolog's built-in notation for writing grammars.

**How it works**:
```prolog
story(Lang) --> setup(Lang), complication(Lang), resolution(Lang).
setup(Lang) --> [Once], subject(Lang, S), copula(Lang), location(Lang, L), ['.'].
```

**Why we use it**: Natural syntax for describing language structure. Prolog handles parsing and backtracking automatically.

**Key function**: `phrase/3`
```prolog
?- phrase(story(en), Tokens).
% Generates: [Once, wizard, was, forest, ...]
```

### 2. Word Banks (Lexicons)

**What they are**: Lists of words organized by category and language.

```prolog
word_bank(nouns, en, [wizard, knight, dragon, forest, castle, ...]).
word_bank(verbs, en, [walked, flew, discovered, spoke, ...]).
word_bank(adjectives, en, [ancient, bright, mysterious, ...]).
```

**Why organized this way**: Makes generation deterministic and extensible. Add words by editing lists.

**Random selection**:
```prolog
random_select_word(nouns, en, Word).  % Picks random noun in English
```

### 3. Ontology (Semantic Rules)

**What it is**: Definitions of what entities can do and where.

```prolog
can_perform(character, speak).
can_perform(creature, roam).
location_allows_activity(forest, [wandered, hunted, found]).
```

**Why it matters**: Prevents generating "the forest spoke" or "the character roamed like a beast."

**How generation uses it**:
```prolog
% Before choosing action for subject, check: can_perform(Subject, Action)
```

### 4. State Tracking (Entity Memory)

**What it does**: Remembers what's been said in current narrative.

```prolog
record_entity(subject, wizard).        % Remember: wizard was mentioned
get_last_entity(subject, E).           % Get most recent subject
can_use_entity(wizard).                % Check: can we mention wizard again?
```

**Why it matters**: Enables pronouns ("the wizard... he...") and prevents repetition.

### 5. Configuration

**Formats supported**: JSON, YAML, TOML

```json
{ "language": "en", "seed": 42, "pacing": "medium" }
```

```yaml
language: en
seed: 42
pacing: medium
```

```toml
[core]
language = "en"
seed = 42
```

**Why flexible**: Reproducible experiments, team workflows, automation.

---

## DCG & Grammar

### DCG Syntax Crash Course

DCG is sugar for difference lists. This:
```prolog
noun --> [cat].
```

Is equivalent to:
```prolog
noun(S0, S) :- S0 = [cat | S].
```

### Common Patterns

#### Terminal (literal words)
```prolog
sentence --> [the], noun, [ran].
```
Outputs: `[the, cat, ran]` (if noun = `[cat]`)

#### Non-terminal (reference another rule)
```prolog
sentence --> subject, verb, object.
subject --> [the], noun.
```

#### Recursion
```prolog
list --> [].                % Base case
list --> item, list.        % Recursive case
```

#### Parameterization
```prolog
noun(Lang) --> noun_en(Lang) | noun_es(Lang).
noun_en(en) --> [cat] | [dog] | [mouse].
noun_es(es) --> [gato] | [perro] | [ratón].
```

### Our Grammar Structure

```
story(Lang)
  ├── setup(Lang)
  ├── complication(Lang)
  └── resolution(Lang)

setup(Lang)
  ├── [Once upon a time]
  ├── subject(Lang, S)
  ├── copula(Lang)
  ├── location(Lang, L)
  └── ['.']
```

### Phrase/3: The Magic Function

```prolog
?- phrase(story(en), Tokens).
Tokens = [Once, wizard, was, forest, Then, wizard, found, treasure, ...]

?- phrase(story(es), Tokens).
Tokens = ['Érase una vez', mago, fue, bosque, ...]
```

This is where grammar rules → actual output.

### Debugging DCG

If phrase/3 fails:
1. Check word_bank/3 is defined
2. Check noun/1 references actual words
3. Add trace: `trace.` then `phrase(...)`
4. Look for missing or misspelled categories

---

## Word Banks & Dictionaries

### Structure

```prolog
% file: data/dict_en.pl
word_bank(Category, Language, WordList).

word_bank(nouns, en, [wizard, knight, dragon, forest, ...]).
word_bank(verbs, en, [walked, flew, discovered, ...]).
word_bank(adjectives, en, [ancient, bright, mysterious, ...]).
```

### Categories Defined

| Category | Purpose | Example |
|----------|---------|---------|
| nouns | Subjects and objects | wizard, castle, dragon |
| verbs | Actions | walked, discovered, spoke |
| adjectives | Descriptions | ancient, bright, magical |
| locations | Places | forest, mountain, village |
| characters | Named entities | Arthur, Merlin, Eleanor |
| features | Properties | color, texture, age |

### Adding Words

**For English** (edit `data/dict_en.pl`):
```prolog
word_bank(nouns, en, [
    % Existing...
    wizard, knight, dragon, forest, castle,
    % New...
    merchant, village, tower
]).
```

**For Spanish** (edit `data/dict_es.pl`):
```prolog
word_bank(nouns, es, [
    % Existentes...
    mago, caballero, dragón, bosque, castillo,
    % Nuevos...
    comerciante, pueblo, torre
]).
```

**Always update both languages together.**

### Word Selection Algorithm

```prolog
random_select_word(Category, Lang, Word) :-
    word_bank(Category, Lang, Words),
    length(Words, Len),
    random_between(1, Len, Idx),
    nth1(Idx, Words, Word).
```

This picks randomly with uniform distribution (each word equally likely).

### Size Guidelines

- **Minimum**: 30 words per category
- **Good**: 100+ words per category
- **Excellent**: 300+ words per category

Current state: ~40 per category (intentionally small to start).

---

## Ontology & Coherence

### What Is Ontology?

An ontology defines:
- What things exist (entities)
- What properties they have
- What actions they can perform
- What constraints apply

### Our Ontologies

#### Actor-Action Compatibility
```prolog
can_perform(character, speak).
can_perform(character, walk).
can_perform(creature, roam).
can_perform(creature, hunt).
can_perform(object, fall).
```

**Usage**: Before generating "X verbed", check `can_perform(X, verb)`.

#### Location-Activity Compatibility
```prolog
location_allows_activity(castle, [lived, ruled, defended]).
location_allows_activity(forest, [wandered, hunted, found]).
location_allows_activity(village, [lived, spoke, visited]).
```

**Usage**: If location is forest, only generate actions from [wandered, hunted, found].

#### Semantic Roles
```prolog
semantic_role(character, agent).      % Can do things
semantic_role(creature, agent).       % Can do things
semantic_role(object, patient).       % Things are done to it
semantic_role(location, location).    % Where things happen
```

#### Narrative Causality
```prolog
causes_consequence(found_treasure, [happy, wealthy, famous]).
causes_consequence(lost_item, [sad, desperate, searching]).
```

**Usage**: Track what action happened, add consequences to narrative.

### Adding Ontologies

1. **Identify constraint**: "Character can X but creature cannot"
2. **Add rule to ontology.pl**:
   ```prolog
   can_perform(character, write).
   ```
3. **Use in generator.pl**:
   ```prolog
   action(Lang, Action) -->
       { can_perform(SubjectType, Action) },
       [Action].
   ```

### Coherence Checking

*Note: Currently stub. Implementation is next.*

```prolog
is_coherent(Narrative) :-
    check_entity_consistency(Narrative),
    check_tense_consistency(Narrative),
    check_causal_links(Narrative).
```

---

## State Tracking

### Why Track State?

Without state tracking:
- "Wizard walked. He sat." → "He" could be anyone
- "Wizard fought dragon. Wizard fled." → Repetition feels clunky
- "Flew to castle. Swam across river." → No entity performing actions

With state tracking:
- Most recent wizard is tracked → "He" resolves correctly
- Can avoid repeating same entity
- Can track narrative flow

### Implementation

```prolog
% Record mention
record_entity(Type, Entity) :-
    assertz(mentioned_entity(Type, Entity)).

% Get all mentions
get_entities_of_type(Type, Entities) :-
    findall(E, mentioned_entity(Type, E), Entities).

% Get most recent
get_last_entity(Entity) :-
    mentioned_entity(_, Entity),
    \+ (mentioned_entity(_, E2), E2 \== Entity).

% Clear state
retract_current_entities :-
    retractall(mentioned_entity(_, _)).
```

### Anaphora Resolution

Pronouns refer back to most recently mentioned entity:

```prolog
get_pronoun_antecedent(he, Subject) :-
    get_last_entity(Subject),
    entity_history(character, Subject, _).
```

**Example**:
1. Generate: "Wizard walked to forest."
2. Record: entity_history(character, wizard, 1)
3. Generate: "He discovered treasure."
4. Resolve "he" → wizard (most recent character)

---

## Configuration

### File Formats

#### JSON (`config/default.json`)
```json
{
  "language": "en",
  "seed": 42,
  "pacing": "medium",
  "enable_state_tracking": true,
  "enable_coherence_check": true
}
```

#### YAML (`config/default.yaml`)
```yaml
language: en
seed: 42
pacing: medium
enable_state_tracking: true
enable_coherence_check: true
```

#### TOML (`config/default.toml`)
```toml
[core]
language = "en"
seed = 42
pacing = "medium"

[features]
enable_state_tracking = true
enable_coherence_check = true
```

### Loading Configuration

```prolog
% From file
load_config('config/default.json').

% Via CLI
swipl -l src/main.pl -- --config config/custom.yaml

% Via code
get_config(language, Lang).
```

### Configuration Precedence

1. **CLI arguments** (`--lang es --seed 123`)
2. **Config file** (JSON/YAML/TOML)
3. **Built-in defaults** (fallback in code)

---

## TUI Usage

### Main Menu

```
╔════════════════════════════════════════════╗
║   Prolog Discourse Generator v0.1         ║
║   ~1989 Turbo Prolog Revival               ║
║   Simple. Pure Logic. Coherent Narratives. ║
╚════════════════════════════════════════════╝

[1] Generate Discourse
[2] Settings
[3] About
[q] Quit

Enter choice: _
```

### Generate Discourse

```
=== Generate Discourse ===

Select narrative type:

[1] Simple Story
[2] Dialogue
[3] Description
[b] Back

Enter choice: _
```

Each narrative type produces different output:
- **Story**: Beginning-middle-end arc
- **Dialogue**: Exchange between two speakers
- **Description**: Atmospheric description of place/person

### Settings

```
=== Settings ===

Current Language: en

[1] Change Language
[2] Set Random Seed
[b] Back

Enter choice: _
```

**Change Language**: Switch between en and es dynamically.

**Set Random Seed**: Any integer 0-1000000 for reproducible generation.

### Output Example

```
--- Generated Story ---

Once upon a time a wizard was in the forest.
Then the wizard discovered the ancient sword.
Finally the wizard became famous.

Press ENTER to continue...
```

---

## Examples

### Example 1: Simple Story in English

**Settings**: en, seed=42
**Output**:
```
Once upon a time a knight was in the castle.
Then the knight found the precious ring.
Finally the knight was brave.
```

### Example 2: Diálogo en Español

**Settings**: es, seed=100
**Output**:
```
Arturo said: "He viajado muy lejos"
Merlin said: "La verdad está a menudo oculta"
```

### Example 3: Description

**Settings**: en, seed=123
**Output**:
```
There is a mysterious forest.
Its color is golden, its texture is soft.
To those who know it, it feels magical.
```

### Example 4: Reproducibility

Run twice with same seed:
```bash
swipl -l src/main.pl -- --lang en --seed 42
# Output A...

swipl -l src/main.pl -- --lang en --seed 42
# Output A... (identical)
```

Different seed:
```bash
swipl -l src/main.pl -- --lang en --seed 43
# Output B (different)
```

---

## Troubleshooting

### Problem: "No word_bank found"

**Cause**: Data files not loading.

**Fix**:
1. Check `data/dict_en.pl` and `data/dict_es.pl` exist
2. Check `src/main.pl` has `:- consult('../data/dict_en.pl').`
3. Check no syntax errors: `swipl -c src/main.pl`

### Problem: Generation doesn't produce output

**Cause**: DCG phrase/3 failing.

**Debug**:
```prolog
?- phrase(story(en), X).
% Should produce token list
% If fails, check word_bank definitions
```

### Problem: Spanish characters show as ???

**Cause**: UTF-8 encoding not set.

**Fix**:
1. Ensure `:- encoding(utf8).` at top of each file
2. Terminal must support UTF-8 (most modern do)
3. Test: `write('español'), nl.` should print correctly

### Problem: Seed doesn't produce same result

**Cause**: Random initialization not using set_random/1.

**Debug**:
```prolog
?- set_random(seed(42)), random_between(1, 100, X).
% Try again, should get same X
```

### Problem: Menu doesn't respond to input

**Cause**: read/1 waiting for period.

**Note**: Prolog's read/1 expects a Prolog term ending with `.`
```
?- read(X).
hello.        % Must end with period
X = hello.
```

---

## Turbo Prolog History

### 1989: Turbo Prolog

**What was it**: Commercial IDE and compiler for Prolog, by Borland.

**Capabilities**:
- ✅ Unification and backtracking (core Prolog)
- ✅ Definite Clause Grammars (DCG)
- ✅ assert/retract (dynamic predicates)
- ✅ Operator definitions
- ✅ File I/O (basic)
- ✅ Debugging: trace, spy, nospy

**Limitations**:
- ❌ No modules (keep predicates in one file or use naming conventions)
- ❌ No findall/bagof/setof (use backtracking loops with assert/retract)
- ❌ No Unicode (ASCII only; no Spanish ñ, accents)
- ❌ No standard library (everything hand-coded)
- ❌ No strings (only atoms; harder to manipulate text)
- ❌ Slow I/O
- ❌ Expensive assert/retract (no indexing)

### How You'd Code Around It

**Problem**: Need to collect all solutions (Turbo Prolog has no findall)

**Turbo Prolog solution**:
```prolog
collect_solutions :-
    retractall(collected(_)),
    solution(X),
    assertz(collected(X)),
    fail.
collect_solutions.
```

**Modern SWI-Prolog**:
```prolog
findall(X, solution(X), List).
```

**Problem**: Need to handle Spanish (Turbo Prolog has no Unicode)

**Turbo Prolog solution**:
```prolog
% Use ASCII transliteration
noun(castillo).      % castle
noun(bosque).        % forest (no ô)
% Or use code pages (complex, fragile)
```

**Modern SWI-Prolog**:
```prolog
:- encoding(utf8).
noun(castillo).
noun(bosque).        % Works perfectly
```

### Modern SWI-Prolog (2024+)

**What is it**: Open-source, actively maintained, widely used for education and research.

**Advantages**:
- ✅ Full Unicode (UTF-8 native)
- ✅ Modules for organization
- ✅ Rich standard library (300+ predicates)
- ✅ Tabling/memoization (performance)
- ✅ Constraint Logic Programming (CLP)
- ✅ Web server (pengines)
- ✅ Database access
- ✅ Great documentation
- ✅ Active community

**Current State**: Turns Turbo Prolog's limitations into learning opportunities. Understanding what was hard in 1989 makes you appreciate modern advantages.

---

## See Also

- **README.md** - Quick start and feature overview
- **CLAUDE.md** - Architecture and design decisions
- **HANDOFF.md** - Guide for collaborators
- **TODO.md** - Development roadmap and known issues
- **wiki_es.md** - Spanish version of this wiki

---

*Last updated: 2026*
