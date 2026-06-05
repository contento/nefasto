# Development Roadmap

## Phase 1: Core Implementation ✅ Complete

### Critical Path - DCG & Generation Engine
- ✅ **Fix phrase/3 integration** - DCG rules executing correctly
  - phrase(story(Lang), Tokens) generates coherent token sequences
  - word_bank/3 clauses properly loaded from YAML profiles
  - Character-driven narrative structure implemented

- ✅ **Add basic narrative generation**
  - generate_narrative/3 working for simple_story, dialogue, description
  - Output: coherent sentences in English and Spanish
  - All three narrative types functional

### TUI Implementation
- ✅ **Fix ANSI color codes** - tested on Linux/macOS
  - color_reset/1, write_colored/2 predicates working
  - Cross-platform color support confirmed

- ✅ **Implement main menu flow**
  - show_main_menu -> handle_choice -> generate_discourse_menu pipeline working
  - read_choice/1 correctly processes user input without blocking
  - Invalid choices handled gracefully

- ✅ **Add configuration loading**
  - YAML dictionary loading fully implemented via dict_loader.pl
  - Profile selection working (--profile argument)
  - Config file loading functional

### State & Tracking
- ✅ **Implement entity tracking**
  - record_entity/2 and retract_current_entities/0 working
  - Entity state properly maintained during narrative generation
  - Prevents immediate repetition

- ✅ **Profile-based discourse** (replaced anaphora)
  - Implemented 12 profiles instead of pronoun resolution
  - Each profile has distinct vocabulary and constraints

### Dictionary & Word Banks
- ✅ **Expand English word banks** (YAML profiles)
  - 12 profiles × 40-60 words per category
  - Organized by profile (political, sales, karen, academic, etc.)
  - Location descriptions and character names included

- ✅ **Expand Spanish word banks** (YAML profiles)
  - Spanish translations for all 12 profiles
  - Gender agreement verified
  - Spanish-specific cultural characters

- ✅ **Implement profile constraints**
  - Each profile has unique vocabulary
  - Spanish article gender mapping implemented

### Configuration
- ✅ **YAML dictionary loading** (dict_loader.pl)
  - Simple YAML parsing implemented
  - 24 dictionary files (12 profiles × 2 languages) loading correctly

- ✅ **Profile-aware word selection** (random_utils.pl)
  - random_select_word/3 uses current profile
  - Fallback error on missing category

### CLI Arguments
- ✅ **Implement --lang argument**
  - --lang es switches to Spanish successfully
  - Both language dictionaries load correctly

- ✅ **Implement --seed argument**
  - --seed 42 produces reproducible output
  - set_random/1 properly integrated

- ✅ **Implement --profile argument**
  - --profile [name] selects discourse profile
  - set_profile/1 working with all 12 profiles

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

## Discourse Profiles Implementation

### All 12 Profiles ✅ Completed

- ✅ Political (EN/ES) - argumentative, policy-focused
- ✅ Sales (EN/ES) - action-oriented, benefit-focused  
- ✅ Karen (EN/ES) - entitled, demanding, complaint-focused
- ✅ Academic (EN/ES) - technical, formal, evidence-based
- ✅ Casual (EN/ES) - friendly, informal, contemporary slang
- ✅ Legal (EN/ES) - precise, technical jargon, adversarial
- ✅ Journalistic (EN/ES) - neutral, informative, fact-based
- ✅ Poetic (EN/ES) - metaphorical, artistic, evocative, emotional
- ✅ Technical (EN/ES) - precise, systematic, optimization-focused
- ✅ Conspiracy (EN/ES) - suspicious, connecting dots, paranoid
- ✅ Motivational (EN/ES) - inspirational, action-oriented, empowering
- ✅ Passive-Aggressive (EN/ES) - sarcastic, backhanded, subtle hostility

Each profile includes:
- 40-60 nouns per language (objects, people, locations)
- 30-40 verbs per language (actions suited to discourse style)
- 30-40 adjectives per language (descriptors matching tone)
- 15-25 locations per language (places appropriate to profile)
- 15-25 characters per language (names matching profile)
- 10-15 statements per language (example utterances for dialogue/description)
- 3-5 features per language (narrative features)

### Implementation Steps (for each profile)
1. Create YAML file with 30-40 words per category (nouns, verbs, adjectives, locations, characters, statements)
2. Register profile in `src/profiles.pl`
3. Load dictionaries in `src/main.pl`
4. Test generation: `swipl -l src/main.pl -- --profile [name]`
5. Regenerate README samples

### Future Enhancements
- [ ] **Profile Blending** - weighted mix of two profiles (Political + Karen = paranoid policy debate)
- [ ] **Semantic Ontologies** - validate noun-verb combinations per profile
- [ ] **Narrative Variety** - 5+ different structures per profile (not just 3-part)
- [ ] **Verb Conjugation** - proper tense agreement across narrative

---

## Known Issues & Fixes

### Critical Issues (FIXED - Mimo Code Review 2026-06-04)
1. ✅ **TUI prompt_continue hang** - replaced read/1 with read_line_to_string/3
2. ✅ **Spanish article heuristic wrong** - implemented proper gender lookup dictionary
3. ✅ **Dead code removal** - deleted state.pl, ontology.pl, narratives.pl
4. ✅ **Duplicate words in YAML** - removed from en_karen.yaml and en_political.yaml
5. ✅ **dict_loader naming collision** - renamed parse_yaml_lines to parse_dict_yaml_lines

### Resolved Issues
- ✅ **DCG phrase/3 not executing** - Now working correctly (character-driven narratives)
- ✅ **TUI menu navigation** - read_choice/1 properly implemented with read_line_to_string
- ✅ **Random seed not working** - set_random/1 correctly integrated
- ✅ **Config file parsing** - YAML dictionary loading fully implemented

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