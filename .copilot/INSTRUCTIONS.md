# Copilot Instructions for Prolog Discourse Generator

## Context
This is a pure-Prolog discourse generator reviving Turbo Prolog (1989) techniques with SWI-Prolog. No LLMs, only logic.

## What This Project Does
Generates coherent narratives in English and Spanish using:
- DCG (Definite Clause Grammars) for syntax
- Simple word banks (dictionaries)
- Ontologies for semantic coherence
- Random selection for variety
- State tracking to prevent contradictions

## When Suggesting Code

### ✅ DO
- Suggest Prolog code (pure logic, no shell scripts)
- Ask about DCG phrase/3 integration if stuck
- Add Turbo Prolog notes (how it would work in 1989)
- Highlight modern SWI-Prolog advantages
- Keep suggestions simple and focused

### ❌ DON'T
- Suggest machine learning or neural approaches
- Add external LLM APIs
- Recommend heavy dependencies (stick to SWI-Prolog stdlib)
- Simplify the logic away - coherence matters
- Break the multilingual (EN/ES) design

## File Organization
- **src/** - Core Prolog modules
  - `main.pl` - Entry, CLI args, initialization
  - `generator.pl` - DCG rules, phrase/3
  - `tui.pl` - Terminal UI
  - `ontology.pl` - Semantic rules
  - `state.pl` - Entity tracking
  - `config.pl` - Config loading
  - `random_utils.pl` - Random helpers
- **data/** - Lexicons and templates
  - `dict_en.pl` - English word banks
  - `dict_es.pl` - Spanish word banks
  - `narratives.pl` - Story templates
- **config/** - Configuration files (JSON, YAML, TOML)
- **docs/** - Wiki/documentation (EN & ES)

## Common Tasks

### Adding a new narrative type
1. Add DCG rule in `generator.pl` (e.g., `adventure(Lang) --> ...`)
2. Add to `phrase_type/1` in `generator.pl`
3. Add new word categories to both `dict_en.pl` and `dict_es.pl`
4. Update `generate_narrative/3` to handle the new type
5. Add menu option to `tui.pl`

### Adding narrative constraints
1. Define relationship in `ontology.pl` (e.g., `can_perform(actor, action)`)
2. Check constraints before generating in DCG rules
3. Update state tracking in `state.pl` if needed
4. Document in both language wikis

### Fixing coherence issues
1. Check `state.pl` - are entities being tracked?
2. Review `ontology.pl` - are constraints defined?
3. Test with `--seed` for reproducibility
4. Add to word bank if missing vocabulary

### Multilingual changes
- Always update **both** `dict_en.pl` and `dict_es.pl`
- Test with `--lang en` and `--lang es`
- Document in both `wiki_en.md` and `wiki_es.md`
- Use UTF-8 encoding (`:- encoding(utf8).`)

## Turbo Prolog (1989) vs SWI-Prolog (2024+)

### Turbo Prolog constraints
- No modules - keep code flat or use naming conventions
- No findall/bagof/setof - use backtracking loops
- No assert/retract - use cut and choice points
- Limited I/O - file operations are basic
- No Unicode - ASCII only, special chars via code pages

### SWI-Prolog advantages
- Full Unicode support (essential for Spanish)
- Modern list operations (findall, member, append)
- Dynamic predicates (assert/retract) with indexing
- DCG is well-integrated
- Rich standard library
- Better debugging tools

## When Something Feels Wrong
1. Check the Turbo Prolog notes in comments - they explain the "why"
2. Read CLAUDE.md - it has architectural decisions
3. Look at test cases in TODO.md
4. Ask about cross-platform TUI - ANSI codes work everywhere
5. Remember: no LLMs, pure logic only

## Code Review Checklist
- [ ] No external LLM calls or API integrations
- [ ] Both EN and ES dictionaries updated if adding words
- [ ] Turbo Prolog notes included for new features
- [ ] DCG rules use phrase/3, not manual parsing
- [ ] State tracking prevents contradictions
- [ ] Ontology constraints are enforced
- [ ] Configuration stays flexible (JSON/YAML/TOML)
- [ ] TUI works cross-platform (ANSI colors only)
