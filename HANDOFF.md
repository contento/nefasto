# Handoff: Prolog Discourse Generator

**For the next developer or collaborator joining this project.**

---

## What Is This Project?

A pure-Prolog narrative generator that creates coherent stories, dialogues, and descriptions in English and Spanish. It uses:

- **DCG (Definite Clause Grammars)** for syntax
- **Simple word banks** for vocabulary
- **Ontologies** for semantic consistency
- **State tracking** to prevent contradictions
- **Random selection** for variety (no ML, no LLMs)

The codebase revives 1989 Turbo Prolog techniques using modern SWI-Prolog, with documentation about what worked then vs. now.

---

## Core Architecture

### Files to Know (In Order of Importance)

1. **src/main.pl** - Entry point
   - CLI argument parsing (--lang, --seed, --config)
   - Initialization and module loading
   - **Why it matters**: This is where execution starts; if it doesn't load, nothing works

2. **src/generator.pl** - Narrative generation
   - DCG rules (phrase/3) for syntax
   - generate_narrative/3 - the main function
   - **Why it matters**: This is where stories are built

3. **src/tui.pl** - Terminal UI
   - Menu system with ANSI colors
   - User interaction
   - **Why it matters**: Users interact with this; if it breaks, the whole app breaks

4. **data/dict_en.pl** & **data/dict_es.pl** - Lexicons
   - word_bank/3 definitions for words
   - **Why it matters**: More words = better variety; these grow as project grows

5. **src/ontology.pl** - Semantic rules
   - can_perform/2, location_allows_activity/2, etc.
   - **Why it matters**: Ensures narratives are coherent

6. **src/state.pl** - Entity tracking
   - Tracks what's been mentioned
   - Prevents contradictions
   - **Why it matters**: Enables coherent multi-sentence narratives

7. **src/config.pl** - Configuration
   - JSON/YAML/TOML loading
   - **Why it matters**: Makes system reproducible and configurable

8. **src/random_utils.pl** - Random selection
   - random_select_word/3, random_between/3
   - **Why it matters**: Where randomness comes from

---

## How to Get Oriented

### Day 1: Read These (1 hour)
1. This file (HANDOFF.md)
2. README.md - overview and quick start
3. CLAUDE.md - architecture decisions
4. Look at src/main.pl - see what loads

### Day 2: Run It
```bash
cd /Users/contento/projects/prolog-discourse-gen
swipl -l src/main.pl

# Try different commands:
swipl -l src/main.pl -- --lang es
swipl -l src/main.pl -- --seed 42
```

Write down any errors. Check TODO.md to see if they're known issues.

### Day 3: Read the Code
Start with **src/generator.pl**. Read the DCG rules:
```prolog
story(Lang) --> setup(Lang), complication(Lang), resolution(Lang).
```

Understand: `phrase/3` turns these rules into token sequences. Then understand how those get joined into text.

### Day 4: Pick a Task
Start with a **Quick Win** from TODO.md:
- Add 20 nouns to dict_en.pl and dict_es.pl
- Or: Get one DCG rule to execute successfully
- Or: Implement random_select_word/3

---

## Important Design Decisions

### DCG Over Manual Parsing
We use `phrase/3` exclusively:
```prolog
phrase(story(en), Tokens)  % Generates token list
atomic_list_concat(Tokens, ' ', Narrative)  % Join to string
```

**Why**: DCG is Prolog's native grammar syntax. It's clean and lets us focus on semantics, not parsing.

### Simple Random, Not Models
We don't use language models:
```prolog
random_select_word(nouns, en, Word)  % Pick randomly from list
```

**Why**: Transparency. You can trace every word choice. Reproducible with seeds. Extensible by just adding words.

### Word Banks, Not Learning
Vocabularies are static lists in Prolog clauses:
```prolog
word_bank(nouns, en, [wizard, knight, dragon, ...]).
```

**Why**: Simple to extend, understand, and debug. No training data needed.

### State Tracking for Coherence
We track entities mentioned:
```prolog
record_entity(subject, wizard).
get_last_entity(subject, E).
```

**Why**: Prevents contradictions. Enables anaphora ("wizard... he...").

### Ontologies for Constraints
We define what can happen:
```prolog
can_perform(character, speak).
location_allows_activity(forest, [wandered, hunted]).
```

**Why**: Ensures generated narratives are semantically valid.

### Bilingual Architecture
Both EN and ES from day one:
- dict_en.pl and dict_es.pl are always updated together
- All rules support both languages
- Documentation in both languages

**Why**: Prevents retrofitting later. Ensures proper multilingual support.

---

## Common Questions

### Q: Where do I add new words?
**A:** Edit **data/dict_en.pl** and **data/dict_es.pl** at the same time.
```prolog
word_bank(nouns, en, [existing_words..., new_word]).
word_bank(nouns, es, [palabras_existentes..., palabra_nueva]).
```

Then test: `swipl -l src/main.pl -- --lang en` and `--lang es`

### Q: How do I add a new narrative type?
**A:** 
1. Add DCG rule to **src/generator.pl**:
   ```prolog
   my_narrative(Lang) --> [token1], [token2], ...
   ```
2. Add to **data/narratives.pl** as template
3. Add menu option to **src/tui.pl**
4. Update **src/generator.pl** `generate_narrative/3`
5. Test it works for both languages

### Q: Why does generation fail sometimes?
**A:** Common reasons:
- Word bank empty for a category → add more words
- DCG rule doesn't match → check phrase/3 definition
- Random seed issue → check set_random/1 in main.pl
- Config file missing → check config/ directory

See TODO.md "Known Issues" section.

### Q: How do I make narratives longer/shorter?
**A:** 
- Add more rules to DCG in **src/generator.pl**
- Adjust sentence structure templates in **data/narratives.pl**
- Or: Add pacing settings (short/medium/long) in **src/random_utils.pl**

### Q: Where do Turbo Prolog notes go?
**A:** In code comments above the relevant predicate:
```prolog
% Turbo Prolog (~1989) note:
% No findall/3, so you'd manually backtrack through solutions
%
% Modern SWI-Prolog (2024+) advantage:
% - Built-in findall/3 collects all solutions
```

---

## Debugging Tips

### Issue: Nothing generates (DCG fails)
**Check**:
1. Is word_bank/3 defined? `grep -n "word_bank(nouns" data/dict_*.pl`
2. Are data files loaded? Look for `:- consult(...)` in src/main.pl
3. Is phrase/3 being called? Add debug output: `write('Generating...'), nl`

### Issue: Spanish characters appear as gibberish
**Check**:
1. All Prolog files have `:- encoding(utf8).` at top
2. Your terminal supports UTF-8
3. SWI-Prolog UTF-8 mode is on: `set_prolog_flag(encoding, utf8).`

### Issue: Menu doesn't respond to input
**Check**:
1. Is read_choice/1 working? Test: `read(X), write(X).`
2. Terminal echo on? Try `stty echo`
3. Input is atom, not string? Check: `read_choice(Choice)`

### Issue: Random seed doesn't reproduce
**Check**:
1. set_random/1 called before any random_* ? Check src/main.pl
2. Using same Prolog executable? Different SWI versions → different results
3. All randomness goes through random_between/3 or random_select_word/3

---

## Collaboration Workflow

### Before Committing
```bash
# Test with both languages
swipl -l src/main.pl -- --lang en
swipl -l src/main.pl -- --lang es

# Test with different seeds
swipl -l src/main.pl -- --seed 42
swipl -l src/main.pl -- --seed 100

# Check for compilation errors
swipl -c src/main.pl  # Compiles all
```

### Update Both Dictionaries
If you add word types, update both:
```prolog
% In dict_en.pl:
word_bank(emotions, en, [happy, sad, afraid, ...]).

% In dict_es.pl:
word_bank(emotions, es, [feliz, triste, asustado, ...]).
```

### Document Changes
- If adding architecture, update CLAUDE.md
- If adding features, update wiki_en.md and wiki_es.md
- If fixing bugs, update TODO.md (mark as done)

### Turbo Prolog Notes
When you understand how something would have worked in 1989, add a comment:
```prolog
% Turbo Prolog (~1989): Would use assert/retract in a loop to track entities
% Modern SWI-Prolog: Better to use findall/3 and aggregate_all/3
```

---

## What Needs Work (Critical)

From TODO.md, highest priority:

1. **DCG phrase/3 integration** - Currently not working
   - Test: phrase(story(en), X) should produce tokens
   - Debug: word_bank visibility, rule syntax

2. **Expand dictionaries** - Too few words
   - Target: 100+ nouns, 50+ verbs per language
   - Current: ~30-40 each

3. **Fix configuration loading** - JSON/YAML/TOML parsers are stubs
   - Implement actual parsing or use SWI libraries

4. **Implement ontology checking** - Constraints exist but aren't enforced
   - Check can_perform/2 before generating actions

---

## Project Status

**Current**: Early development. Core structure exists, but:
- ✅ Architecture designed
- ✅ Module structure in place
- ✅ TUI framework exists
- ⚠️ DCG generation has bugs
- ⚠️ Dictionaries are small
- ⚠️ Configuration parsing incomplete

**Working**: Module loading, TUI menu navigation (mostly), basic structure

**Not Working**: Actual narrative generation, configuration file parsing, state tracking

**Next**: Fix phrase/3, expand word banks, test end-to-end

---

## Tools & Resources

### SWI-Prolog Documentation
- **DCG syntax**: https://www.swi-prolog.org/pldoc/man?section=grammar
- **List operations**: https://www.swi-prolog.org/pldoc/man?name=append
- **Debugging**: https://www.swi-prolog.org/pldoc/man?section=debugger

### Getting Help
- **SWI Forum**: https://swi-prolog.discourse.group/ (very responsive)
- **Stack Overflow**: Tag `prolog`
- **This codebase**: Check CLAUDE.md for architecture rationale

### Related Projects
- **SWI-Prolog libraries**: https://www.swi-prolog.org/pldoc/doc/_SWI/library.html
- **Learn DCG**: https://www.swi-prolog.org/pldoc/man?section=DCG

---

## Quick Reference: Key Predicates

| Predicate | File | Purpose |
|-----------|------|---------|
| `phrase/3` | generator.pl | Execute DCG rule, get tokens |
| `random_select_word/3` | random_utils.pl | Pick random word from category |
| `record_entity/2` | state.pl | Track mentioned entity |
| `word_bank/3` | dict_*.pl | Word lists by category |
| `can_perform/2` | ontology.pl | Actor-action constraints |
| `generate_narrative/3` | generator.pl | Main generation function |
| `load_config/1` | config.pl | Load JSON/YAML/TOML |
| `show_main_menu/0` | tui.pl | Display main menu |

---

## Final Notes

### For the Next Person
- Start with README.md and CLAUDE.md
- Then read src/main.pl to understand flow
- Then pick a small task from TODO.md and fix it
- Ask questions in code comments if confused

### What Made Sense
- Pure Prolog (no dependencies except SWI)
- Bilingual from the start
- DCG for syntax (natural for Prolog)
- Historical notes on Turbo Prolog (educational)

### What You Might Reconsider
- Simple random selection might feel limited (it's intentional)
- Small word banks (intentionally small, grow as needed)
- Basic narrative templates (start simple, expand later)

### Success Looks Like
- Generates grammatical English & Spanish sentences
- Narratives have no contradictions
- TUI works on Linux/Mac/Windows
- You can add new words without touching code

---

**Good luck! The foundation is here. Time to build on it.**

For specific tasks, see TODO.md. For architectural questions, see CLAUDE.md. For history & philosophy, read the Turbo Prolog notes in the code.
