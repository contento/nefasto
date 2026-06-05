# Prolog Discourse Generator - Instructions for Claude Code

## Project Overview
A pure Prolog discourse/narrative generator without LLMs, reviving 1989 Turbo Prolog techniques with modern SWI-Prolog. Generates coherent narratives using DCG (Definite Clause Grammars), ontologies, and simple random selection.

## Core Values
- **Pure Logic Only**: No neural networks, no LLMs, no external ML libraries
- **Historical Awareness**: Note differences between Turbo Prolog (~1989) and modern SWI-Prolog
- **Simplicity First**: Simple random generation, simple dictionaries, simple UI
- **Coherence Over Complexity**: Ontologies ensure semantic consistency, not marketing
- **Multilingual**: Support both English and Spanish from day one

## Architecture

### Directory Structure
```
src/
  main.pl               # Entry point, CLI arg parsing
  tui.pl                # Terminal UI (cross-platform ANSI)
  generator.pl          # DCG rules, phrase/3 narrative generation
  ontology.pl           # Entity relationships, semantic constraints
  config.pl             # Config loading (JSON/YAML/TOML)
  profiles.pl           # Discourse profiles (political, sales)
  random_utils.pl       # Random selection helpers, profile-aware
  state.pl              # Entity tracking, anaphora, coherence

data/
  dict_en.pl            # English fallback lexicon/word banks
  dict_es.pl            # Spanish fallback lexicon/word banks
  narratives.pl         # Story templates, narrative structures
  dictionaries/         # Profile-specific word bank data (YAML)
    en_political.yaml   # English political discourse word banks
    en_sales.yaml       # English sales discourse word banks
    es_political.yaml   # Spanish political discourse word banks
    es_sales.yaml       # Spanish sales discourse word banks

config/
  default.json      # JSON configuration template
  default.yaml      # YAML configuration template
  default.toml      # TOML configuration template

docs/
  wiki_en.md        # English project wiki (Obsidian-compatible)
  wiki_es.md        # Spanish project wiki (Obsidian-compatible)
```

### Discourse Profiles

The generator supports **mutually exclusive discourse profiles** that change narrative voice, word choice, and style:

- **political** (default): Argumentative, policy-focused, persuasive (senators, debates, reform)
- **sales**: Action-oriented, benefit-focused, pitch-style (products, growth, transformation)

**Usage:**

```bash
swipl -l src/main.pl -- --profile political
swipl -l src/main.pl -- --profile sales
```

**Config file:**

```json
{ "profile": "sales" }
```

**Implementation:**

- Profile system in `src/profiles.pl`
- Dictionary loader in `src/dict_loader.pl` (loads YAML files at startup)
- Profile-specific word banks in `data/dictionaries/` (YAML format)
- `random_select_word/3` tries profile-specific word banks first, falls back to generic
- Data/code separation: word banks are data in YAML, not Prolog code
- Future: TODO for blending multiple profiles with weighted influence

### Key Design Decisions

1. **DCG over Manual Parsing**: Use phrase/3 and DCG rules exclusively for syntax
2. **Dynamic Predicates for State**: Track entities, recent actions, locations with assert/retract
3. **Profile-Aware Word Banks**: Profile-specific word banks with fallback to generic language
4. **Ontology-First Coherence**: Ensure actions match entity types before generating
5. **Cross-Platform TUI**: ANSI colors + simple text menus (no ncurses)
6. **Config is Data**: JSON/YAML/TOML loading for reproducible experiments

## Implementation Guidelines

### When Adding Features
1. Add to appropriate module (generator, ontology, state, config)
2. Include Turbo Prolog (1989) compatibility notes in comments
3. Highlight SWI-Prolog advantages in comments
4. Update both EN and ES dictionaries if adding word types
5. Test with both languages

### Code Style
- Predicates: snake_case, descriptive names
- Comments: Explain WHY, not WHAT (code is self-documenting)
- Turbo Prolog notes: Include in dedicated comments for historical context
- No helper abstractions unless used 3+ times

### Testing (REQUIRED) - CI-Only Workflow

**Test Structure:**

- `tests/unit/` - Unit tests using plunit (individual predicates)
- `tests/integration/` - Integration tests (complete narratives)
- `tests/run_all_tests.pl` - Full test suite (unit + integration)
- `tests/run_tests.pl` - Quick smoke test (optional manual verification)

**Continuous Integration (Automatic):**

- Tests run on every push to `main` branch
- Tests run on all pull requests
- CI configuration: `.github/workflows/tests.yml`
- All 56 tests must pass before merging

**Workflow:**

```text
1. Make code changes
2. Commit + push (no local test required)
3. GitHub Actions runs full test suite automatically
4. Check results in Actions tab (must be green)
5. PR/merge only if all tests pass
```

**Optional Manual Testing:**

```bash
# Full test suite (unit + integration) - ~20 seconds
swipl tests/run_all_tests.pl

# Quick smoke test - ~5 seconds (for rapid iteration during development)
swipl tests/run_tests.pl
```

**Unit Tests** (in `tests/unit/`)
- `random_utils_test.pl` - Random selection, weighted_random, pacing
- `generator_test.pl` - DCG rules (space, copula, dialogue, description)
- `state_test.pl` - Entity tracking, advance_line, action recording

**Integration Tests** (in `tests/integration/`)
- `narrative_generation_test.pl` - Full pipeline (EN/ES, all types)
- Tests reproducibility (same seed = same output)
- Tests language switching
- Tests multiple generations in sequence

**When adding features:**

1. **Write unit test first** (TDD):
   ```prolog
   % In tests/unit/mymodule_test.pl
   test(my_feature_works) :-
       my_predicate(Input, Output),
       Output = expected_value.
   ```

2. **Implement feature** in src/

3. **Run full suite**: `swipl tests/run_all_tests.pl`

4. **Commit tests + code** together

5. **Never merge without passing tests**

**Manual testing** (supplementary):
- Test narrative generation with `--lang en` and `--lang es`
- Verify coherence: entities don't contradict themselves
- Run with different seeds: `--seed 42`, `--seed 123` for variety
- Load each config format: `--config config/default.json` etc.
- Test TUI interactively: `swipl -l src/main.pl`

### Turbo Prolog Notes Format
When documenting historical context, use:
```prolog
% Turbo Prolog (~1989) note:
% [What the limitation was]
% [How you worked around it]
%
% Modern SWI-Prolog (2024+) advantages:
% - [Better feature 1]
% - [Better feature 2]
```

## Command Line Interface

```bash
swipl -l src/main.pl

# With arguments:
swipl -l src/main.pl -- --lang es --seed 123 --config config/custom.yaml
```

## Configuration Precedence
1. Command line arguments (--lang, --seed, --config)
2. Config file (JSON/YAML/TOML)
3. Built-in defaults in main.pl

## Documentation Requirements (CRITICAL)

**Keep documentation in sync with code:**

1. **README.md** - Project overview & examples
   - Update example outputs when narrative generation changes
   - Keep project structure accurate (currently: nefasto/)
   - Update feature list if adding/removing capabilities
   - Fix any broken commands or outdated setup instructions

2. **CLAUDE.md** - Instructions for AI assistants (THIS FILE)
   - Update architecture decisions when design changes
   - Add new guidelines when discovering patterns
   - Keep directory structure current
   - Document testing and documentation requirements

3. **TODO.md** - Development roadmap
   - Mark completed tasks with ✅ when finished
   - Update bug lists as issues are fixed
   - Document code review findings with context
   - Reflect current state (fixes, known issues, next priorities)

4. **RUN.md** - Setup & execution instructions
   - Keep CLI examples working
   - Update paths if directory structure changes
   - Document any new command-line arguments
   - Fix broken links or outdated instructions

5. **wiki_en.md / wiki_es.md** - Detailed documentation
   - Explain architectural decisions
   - Document predicate behavior and invariants
   - Include usage examples

**When committing:**
- If code changes behavior → update README examples
- If adding features → update CLAUDE.md guidelines
- If fixing bugs → update TODO.md findings
- If changing commands/paths → update RUN.md

## Current Limitations (Intentional)
- No constraint solving (CLP) yet - keep it simple
- No tabling/memoization - each generation is fresh
- Word banks are small - add to them as needed
- Narrative templates are basic - extend in narratives.pl

## Next Steps (See TODO.md)
1. Expand word banks (150+ per category per language)
2. Add more narrative templates (hero's journey, three-act structure)
3. Implement proper config file parsing (currently stubs)
4. Wire up unused features (anaphora, ontology constraints, narrative templates)
5. Add coherence validation metrics
6. Expand TUI with more options

## Useful SWI-Prolog Predicates
- `phrase/2, phrase/3` - Execute DCG rules
- `random_between/3` - Random integer generation
- `nth1/3` - List element access (1-indexed)
- `findall/3, bagof/3, setof/3` - Collect solutions
- `assertz/1, retract/1` - Dynamic predicates
- `atomic_list_concat/3` - Join atoms/strings
- `atom_string/2` - Atom/string conversion

## When to Ignore This Document
If the user explicitly asks you to deviate from these guidelines, follow their request. This document is a guide, not law. The code is the truth.
