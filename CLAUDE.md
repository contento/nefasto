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
  main.pl           # Entry point, CLI arg parsing
  tui.pl            # Terminal UI (cross-platform ANSI)
  generator.pl      # DCG rules, phrase/3 narrative generation
  ontology.pl       # Entity relationships, semantic constraints
  config.pl         # Config loading (JSON/YAML/TOML)
  random_utils.pl   # Random selection helpers
  state.pl          # Entity tracking, anaphora, coherence

data/
  dict_en.pl        # English lexicon/word banks
  dict_es.pl        # Spanish lexicon/word banks
  narratives.pl     # Story templates, narrative structures

config/
  default.json      # JSON configuration template
  default.yaml      # YAML configuration template
  default.toml      # TOML configuration template

docs/
  wiki_en.md        # English project wiki (Obsidian-compatible)
  wiki_es.md        # Spanish project wiki (Obsidian-compatible)
```

### Key Design Decisions

1. **DCG over Manual Parsing**: Use phrase/3 and DCG rules exclusively for syntax
2. **Dynamic Predicates for State**: Track entities, recent actions, locations with assert/retract
3. **Word Banks, Not Models**: Simple lists, random_select_word/3 for word choice
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

### Testing
- Test narrative generation with `--lang en` and `--lang es`
- Verify coherence: check that entities don't contradict themselves
- Run with different seeds: `--seed 42`, `--seed 123` for variety
- Load each config format: `--config config/default.json` etc.

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

## Current Limitations (Intentional)
- No constraint solving (CLP) yet - keep it simple
- No tabling/memoization - each generation is fresh
- Word banks are small - add to them as needed
- Narrative templates are basic - extend in narratives.pl

## Next Steps (See TODO.md)
1. Fix DCG phrase/3 integration bugs
2. Expand word banks (150+ per category per language)
3. Add more narrative templates (hero's journey, etc.)
4. Implement proper config file parsing
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
