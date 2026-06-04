# Development Roadmap

## Phase 1: Core Implementation (Current)

### Critical Path - DCG & Generation Engine
- [ ] **Fix phrase/3 integration** - DCG rules not executing correctly
  - Debug: test simple phrase(sentence, Tokens) calls
  - Check: module loading order (data files before generator)
  - Verify: word_bank/3 clauses are visible to generator.pl
  - Expected: phrase can build token lists from DCG rules


- [ ] **Add basic narrative generation**
  - Implement generate_narrative/3 in generator.pl
  - Test: generate_narrative(simple_story, en, Narrative)
  - Output should be coherent English sentence(s)

### TUI Implementation
- [ ] **Fix ANSI color codes** - test on Linux/Mac/Windows
  - Verify color_reset/1 predicate definitions
  - Test: write_colored(cyan, 'Test')
  - Fallback to plain text if colors don't work

- [ ] **Implement main menu flow**
  - Test: show_main_menu -> generate_discourse_menu flow
  - Verify read_choice/1 gets user input correctly
  - Handle invalid choices gracefully

- [ ] **Add configuration loading**
  - Test loading JSON from config/default.json
  - Test loading YAML from config/default.yaml
  - Add proper error handling for missing files

### State & Tracking
- [ ] **Implement entity tracking**
  - Test record_entity/2, get_entities_of_type/2
  - Verify mentioned_entity/2 facts accumulate
  - Test retract_current_entities/0 clears state

- [ ] **Add anaphora resolution**
  - Implement get_pronoun_antecedent/2
  - Test: "wizard walked. he slept." -> he = wizard

### Dictionary & Ontology
- [ ] **Expand English word banks** (dict_en.pl)
  - Target: 100+ nouns, 50+ verbs, 50+ adjectives
  - Add location descriptions
  - Add character names (diverse, historic)

- [ ] **Expand Spanish word banks** (dict_es.pl)
  - Match English in size and variety
  - Ensure gender agreement (sustantivos: m/f)
  - Add Spanish-specific characters (historical, cultural)

- [ ] **Implement ontology constraints**
  - Test: can_perform(character, speak) checks
  - Test: location_allows_activity/2 rules
  - Add to narrative generation (don't generate invalid combinations)

### Configuration
- [ ] **Fix JSON parsing** (config.pl)
  - Use proper JSON library if available
  - Or: implement minimal JSON key-value parser
  - Test: load_config('config/default.json')

- [ ] **Fix YAML parsing** (config.pl)
  - Handle simple YAML (key: value pairs)
  - Test: load_config('config/default.yaml')

- [ ] **Fix TOML parsing** (config.pl)
  - Handle [section] and key = value syntax
  - Test: load_config('config/default.toml')

### CLI Arguments
- [ ] **Implement --lang argument**
  - Test: --lang es switches to Spanish
  - Verify: both dictionaries load correctly

- [ ] **Implement --seed argument**
  - Test: --seed 42 produces same output on second run
  - Verify: random_between/3 uses seed

- [ ] **Implement --config argument**
  - Test: --config config/default.yaml loads correctly

---

## Phase 2: Expansion & Quality

### Word Banks & Lexicons
- [ ] **Add 200+ nouns per language**
  - Organize by category (places, people, objects, creatures)
  - Add attributes/descriptions

- [ ] **Add 100+ verbs per language**
  - Organize by aspect (momentary, ongoing, habitual)
  - Note: Spanish verb conjugation (challenge!)

- [ ] **Add emotional vocabulary**
  - Adjectives for feelings, descriptions
  - Adverbs for manner/intensity

- [ ] **Add temporal markers**
  - Before, after, then, suddenly, finally
  - Support narrative flow

### Narrative Templates
- [ ] **Implement Hero's Journey template**
  - Call, crossing threshold, trials, ordeal, reward, return
  - Test with simple_story generation

- [ ] **Implement Three-Act Structure**
  - Act 1: Setup, inciting incident
  - Act 2: Rising action, midpoint
  - Act 3: Climax, resolution

- [ ] **Add dialogue templates**
  - Question-answer exchanges
  - Argument/debate patterns
  - Small talk vs. revelation

- [ ] **Add description templates**
  - Physical description (size, color, texture)
  - Emotional/atmospheric description
  - Temporal/historical context

### Ontology Enhancement
- [ ] **Add conflict types**
  - Person vs. person
  - Person vs. nature
  - Person vs. self
  - Person vs. society
  - Person vs. fate

- [ ] **Add resolution types**
  - Triumph, sacrifice, bittersweet, tragedy, mystery

- [ ] **Add semantic roles**
  - Agent, patient, experiencer, theme, goal, source
  - Ensure narratives respect semantic constraints

### Coherence Validation
- [ ] **Implement coherence scoring**
  - Check entity consistency
  - Check tense consistency
  - Check causal links
  - Rate narrative quality 0-100

- [ ] **Add redundancy checking**
  - Warn if same entity/action appears too often
  - Ensure variety in word choice

---

## Phase 3: Advanced Features

### Performance & Caching
- [ ] **Add tabling for common phrases**
  - Cache noun phrases, verb phrases
  - Reduce re-generation time

- [ ] **Optimize phrase/3 execution**
  - Profile DCG rule generation
  - Identify bottlenecks

### Multi-Document Generation
- [ ] **Generate multi-paragraph narratives**
  - Connect paragraphs with cohesion markers
  - Maintain entity consistency across paragraphs

- [ ] **Generate narrative sequences**
  - Multiple chapters
  - Character arcs across episodes

### Constraint Logic Programming (CLP)
- [ ] **Use CLP(FD) for narrative structure**
  - Ensure story length constraints
  - Balance action/dialogue/description ratio

### Advanced TUI
- [ ] **Add history tracking** (save generated narratives)
- [ ] **Add favorites** (mark good outputs)
- [ ] **Export formats** (TXT, Markdown, JSON)
- [ ] **Reload from seed** (regenerate with same parameters)

---

## Phase 4: Polish & Deployment

### Documentation
- [ ] **Complete wiki_en.md** with tutorials
- [ ] **Complete wiki_es.md** with tutorials
- [ ] **Add example narratives** to README
- [ ] **Create user guide** (getting started, configuration)
- [ ] **Create developer guide** (extending the system)

### Testing
- [ ] **Unit tests for each module**
  - Test random_select_word/3 exhaustively
  - Test phrase/3 with all DCG rules
  - Test state tracking (no contradictions)

- [ ] **Integration tests**
  - Full narrative generation (all types)
  - Language switching (en ↔ es)
  - Configuration loading (JSON, YAML, TOML)

- [ ] **Quality metrics**
  - Generate 100 narratives, manually rate coherence
  - Track: % grammatical, % coherent, % interesting

### Cross-Platform Testing
- [ ] **Linux** - Test on Ubuntu/Fedora
- [ ] **macOS** - Test on Intel/Apple Silicon
- [ ] **Windows** - Test on Windows 10/11 (WSL + native)

### Package Distribution
- [ ] **Create install script** (auto-download SWI-Prolog)
- [ ] **Add to swi-prolog package manager** (if applicable)
- [ ] **Create Docker image** for easy deployment

---

## Known Issues

### High Priority
1. **DCG phrase/3 not executing** - words not being pulled from word_bank/3
2. **TUI menu navigation** - read_choice/1 blocking or failing
3. **Random seed not working** - set_random/1 not taking effect
4. **Config file parsing** - JSON/YAML/TOML parsers are stubs

### Medium Priority
1. Spanish word bank missing gender agreement logic
2. Ontology constraints not enforced during generation
3. State tracking across multiple generations undefined
4. No error handling in phrase/3 failures

### Low Priority
1. Word bank sizes (too small, intentional for now)
2. No narrative pacing variation yet
3. No export formats (text-only currently)

---

## Testing Checklist

Before marking a task ✅:

- [ ] Feature works in isolation (unit test)
- [ ] Feature works with rest of system (integration test)
- [ ] Works with `--lang en` and `--lang es`
- [ ] Works with different `--seed` values
- [ ] No hardcoded paths (use relative paths)
- [ ] Error handling for edge cases
- [ ] Documentation updated
- [ ] No warnings on swipl load

---

## Quick Win Tasks (Do These First!)

- [ ] Add 20 more nouns to dict_en.pl and dict_es.pl
- [ ] Fix one DCG rule to execute successfully
- [ ] Get random_select_word/3 working
- [ ] Implement one complete narrative type
- [ ] Test with --lang en and --lang es

---

## Turbo Prolog (1989) Challenge

As we expand, keep asking: **"How would this work in 1989?"**

- No findall? → Use backtracking loops with assert/retract
- No Unicode? → What would Spanish support look like with ASCII only?
- No modules? → How to organize 5000+ clauses in one file?
- No assert/retract? → Use choice points and cut instead

Document these in code comments. Understanding the constraints teaches you about Prolog.

---

## Success Metrics

- [x] Prolog code executes without errors
- [ ] Generates grammatically correct English sentences
- [ ] Generates grammatically correct Spanish sentences
- [ ] Narratives contain no contradictions (entity consistency)
- [ ] TUI is usable on Linux/Mac/Windows
- [ ] Configuration loads from JSON/YAML/TOML
- [ ] --lang, --seed, --config arguments work
- [ ] Word banks have 100+ entries per language
- [ ] At least 3 narrative types work (story, dialogue, description)
- [ ] Ontology prevents invalid action-entity combinations

---

## Code Review Findings (Mimo — 2026-06-04)

### Critical Bugs
- [x] **Remove custom `random_between/3`** — ✅ Removed custom definition, now uses SWI-Prolog built-in (`random_utils.pl`).
- [x] **Fix server port mismatch** — ✅ Changed to 3001 (`server.pl:146,149`).
- [x] **Fix CORS configuration** — ✅ Fixed syntax, removed wildcard with credentials, set `credentials(false)` (`server.pl:14-18`).
- [x] **Fix `server.pl` relative path** — ✅ Changed to `consult('src/main.pl')` (`server.pl:11`).
- [x] **Fix `advance_line/0` type error** — ✅ Changed initialization from atom `started` to integer `0` (`state.pl:15`).

### Narrative Coherence
- [x] **Wire same subject through story clauses** — ✅ Subject now carries through: `story(Lang) --> setup(Lang, Subj), complication(Lang, Subj), resolution(Lang, Subj)` (`generator.pl:23`).
- [x] **Make `description` DCG language-aware** — ✅ Added `description_opening/1` and `description_possessive/1` rules (`generator.pl:82-92`).
- [x] **Make `dialogue` DCG language-aware** — ✅ Added `dialogue_verb/1` rule with English and Spanish variants (`generator.pl:78-79`).

### Dead Code / Stale Integration
- [ ] **Unify entity tracking** — two independent systems (`generator.pl:172-195` and `state.pl`) never integrated. Pick one, delete the other.
- [ ] **Wire anaphora resolution** — `get_pronoun_antecedent/2` in `state.pl` is never called from generator.
- [ ] **Wire ontology constraints** — `can_perform/2`, `location_allows_activity/2` in `ontology.pl` are never checked during generation.
- [ ] **Wire narrative templates** — `narrative_template/2`, `heros_journey/1`, `three_act_structure/1` in `narratives.pl` are never referenced by generator.
- [x] **Remove or implement `weighted_random/2`** — ✅ Reimplemented properly: now sums weights and selects correctly (`random_utils.pl:32-46`).

### Config & Input
- [x] **Implement config parsers or remove `--config`** — ✅ Added basic JSON parser that extracts key-value pairs from actual files (`config.pl:51-63`).
- [x] **Fix `read_choice/1`** — ✅ Changed to use `read_line_to_string/2` (`tui.pl:185-187`).

### Documentation
- [ ] **Fix fabricated README examples** — "Example Narratives" section shows coherent output that the system doesn't produce. Update with actual output.
- [x] **Update stale TODO items** — ✅ Removed "Implement random_select_word/3" task (already implemented).

See HANDOFF.md for how to collaborate on these tasks.