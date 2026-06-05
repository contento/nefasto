# Prolog Discourse Generator - Instructions for Claude Code

## Project Overview
A pure Prolog discourse/narrative generator without LLMs, reviving 1989 Turbo Prolog techniques with modern SWI-Prolog. Generates coherent narratives using DCG (Definite Clause Grammars), profile-based word banks, and simple random selection.

## Core Values
- **Pure Logic Only**: No neural networks, no LLMs, no external ML libraries
- **Historical Awareness**: Note differences between Turbo Prolog (~1989) and modern SWI-Prolog
- **Simplicity First**: Simple random generation, simple dictionaries, simple UI
- **Coherence Over Complexity**: Profile constraints ensure narrative consistency, not complexity
- **Multilingual**: Support both English and Spanish from day one

## Architecture

### Directory Structure
```
src/
  main.pl               # Entry point, CLI arg parsing
  tui.pl                # Terminal UI (cross-platform ANSI)
  generator.pl          # DCG rules, phrase/3 narrative generation
  config.pl             # Config loading (JSON/YAML/TOML)
  profiles.pl           # Discourse profile registry (12 profiles)
  dict_loader.pl        # YAML dictionary loader
  random_utils.pl       # Random selection helpers, profile-aware

data/
  dictionaries/         # Profile-specific word banks (24 YAML files)
    en_political.yaml   # English political discourse
    es_political.yaml   # Spanish political discourse
    en_academic.yaml    # English academic discourse
    es_academic.yaml    # Spanish academic discourse
    ... (12 profiles × 2 languages = 24 files)

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

**12 Implemented Profiles:**
- political, sales, karen, academic, casual, legal, journalistic, poetic, technical, conspiracy, motivational, passive_aggressive

Each profile available in English and Spanish.

**Usage:**

```bash
swipl -l src/main.pl -- --profile political --lang en
swipl -l src/main.pl -- --profile academic --lang es
swipl -l src/main.pl -- --seed 42 --profile karen
```

**Implementation:**

- Profile system in `src/profiles.pl` - registry of available profiles
- Dictionary loader in `src/dict_loader.pl` - loads YAML files at startup
- Profile-specific word banks in `data/dictionaries/` (24 YAML files)
- `random_select_word/3` selects from current profile's word bank
- Data/code separation: word banks are pure data in YAML, not Prolog code
- No fallback: each profile must define all required word categories
- Future: TODO for blending multiple profiles with weighted influence

### Key Design Decisions

1. **DCG over Manual Parsing**: Use phrase/3 and DCG rules exclusively for syntax
2. **Dynamic Predicates for State**: Track entities, recent actions, locations with assert/retract
3. **Profile-Aware Word Banks**: Profile-specific word banks with fallback to generic language
4. **Profile-Based Coherence**: Each profile has consistent vocabulary and style
5. **Cross-Platform TUI**: ANSI colors + simple text menus (no ncurses)
6. **Config is Data**: YAML-based dictionaries for reproducible experiments

## Implementation Guidelines

### When Adding Features
1. Add to appropriate module (generator, profiles, dict_loader, config)
2. Include Turbo Prolog (1989) compatibility notes in comments
3. Highlight SWI-Prolog advantages in comments
4. Update YAML profiles if adding word categories (all EN/ES pairs)
5. Test with both languages and multiple profiles

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
- `random_utils_test.pl` - Profile-aware word selection
- `generator_test.pl` - DCG rules (story, dialogue, description)

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
- Word banks growing organically - 40-60 words per category per profile
- Simple 3-part narrative structure (setup → complication → resolution)
- Profiles are mutually exclusive - no blending yet
- Spanish gender heuristic uses lookup table (not perfect but functional)

## Next Steps (See TODO.md)
1. Expand word banks (150+ per category per profile per language)
2. Add more narrative structures (hero's journey, five-act, dialogue-focused)
3. Implement full config file parsing (JSON/YAML/TOML beyond stubs)
4. Add coherence validation metrics (grammar, repetition, flow)
5. Expand TUI with history, favorites, export formats
6. Profile blending: weighted influence of multiple profiles in one narrative
7. Semantic ontologies: validate noun-verb combinations per profile

## Future Enhancements

### JSON-LD with Ontologies (TODO)
When word bank relationships become complex:
- Migrate from YAML to JSON-LD format for linked data
- Define ontologies: word semantic types, relationships, constraints
- Enable: "senator" isa political-entity, can-debate with political-entity
- Support cross-profile semantic references
- Enable reasoning about narrative coherence at semantic level
- Still maintain simple YAML export for human editing

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
