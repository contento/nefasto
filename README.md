# Prolog Discourse Generator

A pure Prolog narrative generator reviving 1989 Turbo Prolog techniques with modern SWI-Prolog. Generates coherent stories, dialogues, and descriptions in English and Spanish—no LLMs, no neural networks, just pure logic.

## Features

- **Pure Logic**: No ML, no LLMs, no black boxes. Just Prolog.
- **Coherent Narratives**: Ontologies and state tracking prevent contradictions
- **Simple & Extensible**: Word banks, DCG grammars, narrative templates
- **Multilingual**: English and Spanish support from the ground up
- **Historical Context**: Notes on Turbo Prolog (~1989) vs modern SWI-Prolog
- **Cross-Platform TUI**: Works on Linux, macOS, Windows
- **Flexible Configuration**: JSON, YAML, TOML, and command-line arguments

## Quick Start

### Requirements
- SWI-Prolog 8.0+ ([download](https://www.swi-prolog.org/download/stable))
- UTF-8 terminal support (modern by default)

### Installation
```bash
git clone https://github.com/yourusername/prolog-discourse-gen
cd prolog-discourse-gen
```

### Run the Interactive TUI
```bash
swipl -l src/main.pl
```

### Run with Arguments
```bash
# Generate in Spanish
swipl -l src/main.pl -- --lang es

# Set random seed for reproducibility
swipl -l src/main.pl -- --seed 42

# Load custom configuration
swipl -l src/main.pl -- --config config/custom.yaml

# Combine arguments
swipl -l src/main.pl -- --lang es --seed 123 --config config/default.toml
```

## Project Structure

```
prolog-discourse-gen/
├── src/                    # Core Prolog modules
│   ├── main.pl            # Entry point & CLI
│   ├── tui.pl             # Terminal UI
│   ├── generator.pl       # DCG rules & phrase generation
│   ├── ontology.pl        # Semantic rules & relationships
│   ├── state.pl           # Entity tracking & consistency
│   ├── config.pl          # Configuration loader
│   └── random_utils.pl    # Random selection utilities
├── data/                  # Lexicons & templates
│   ├── dict_en.pl         # English word banks
│   ├── dict_es.pl         # Spanish word banks
│   └── narratives.pl      # Story templates
├── config/                # Configuration files
│   ├── default.json       # JSON format
│   ├── default.yaml       # YAML format
│   └── default.toml       # TOML format
├── docs/                  # Documentation
│   ├── wiki_en.md         # English wiki (Obsidian)
│   └── wiki_es.md         # Spanish wiki (Obsidian)
├── CLAUDE.md              # Instructions for Claude Code
├── .copilot-instructions.md
├── README.md              # This file
├── TODO.md                # Development roadmap
├── HANDOFF.md             # Handoff notes for collaborators
└── .graphifyignore        # Knowledge graph configuration

```

## How It Works

### 1. Discourse Generation with DCG
Narratives are generated using Prolog's Definite Clause Grammars (phrase/3):

```prolog
story(Lang) --> setup(Lang), complication(Lang), resolution(Lang).
setup(Lang) --> [Once], subject(Lang, S), copula(Lang), location(Lang, L), ['.'].
```

### 2. Word Selection from Dictionaries
Simple word banks provide vocabulary:

```prolog
word_bank(nouns, en, [wizard, knight, dragon, forest, castle, ...]).
word_bank(verbs, en, [walked, flew, discovered, spoke, ...]).
```

Random selection:
```prolog
random_select_word(nouns, en, Word).  % Randomly picks from list
```

### 3. Ontological Constraints
Semantic rules ensure coherence:

```prolog
can_perform(character, speak).
can_perform(creature, roam).
location_allows_activity(forest, [wandered, hunted, found]).
```

### 4. State Tracking
Entity tracking prevents contradictions:

```prolog
record_entity(subject, wizard).
get_last_entity(subject, wizard).
can_use_entity(wizard).  % Check: have we used this recently?
```

## Configuration

### Via Command Line
```bash
swipl -l src/main.pl -- --lang es --seed 100 --config config/default.yaml
```

### Via JSON
```json
{
  "language": "en",
  "seed": 42,
  "pacing": "medium",
  "narrative_type": "simple_story"
}
```

### Via YAML
```yaml
language: en
seed: 42
pacing: medium
narrative_type: simple_story
```

### Via TOML
```toml
[core]
language = "en"
seed = 42
pacing = "medium"
```

## Architecture Decisions

### Why DCG and Not Manual Parsing?
DCG (phrase/3) is Prolog's native grammar notation. It's clean, composable, and lets us focus on semantics, not parsing.

### Why Simple Random Selection?
No Markov chains, no neural language models. Just uniform random selection from word banks. This keeps the system:
- Transparent (you can trace every decision)
- Reproducible (same seed = same narrative)
- Extensible (add words to dictionaries)

### Why State Tracking?
Ontologies + state = coherence. We track what we've said to avoid:
- Mentioning the same entity twice in one sentence
- Using incompatible actions (wizard can't roam like a creature)
- Breaking narrative continuity

### Why Both EN and ES?
Multilingual from day one ensures the architecture supports it properly. No retrofitting needed later.

## Limitations (Intentional)

- **Small dictionaries**: Start small, grow as needed
- **Simple narratives**: No complex plots yet—templates are basic
- **No constraint solving**: CLP(FD) could help but adds complexity
- **No caching**: Each generation is fresh (could add tabling later)

## Turbo Prolog History (~1989)

### Capabilities
- ✅ Unification, backtracking, cut
- ✅ Definite Clause Grammars (DCG)
- ✅ assert/retract (dynamic predicates)
- ✅ Operator definitions
- ✅ File I/O (basic)
- ✅ Debugging tools (trace, spy, nospy)

### Limitations
- ❌ No modules
- ❌ No findall/bagof/setof
- ❌ No Unicode (ASCII only)
- ❌ No standard library
- ❌ Limited string manipulation
- ❌ Slow I/O operations

### How We Honor This
This codebase includes **Turbo Prolog notes** in comments throughout, showing how you'd code around those limitations. Modern SWI-Prolog lets us do better, but understanding the constraints teaches you about the language itself.

## Modern SWI-Prolog Advantages

- **Unicode**: Full UTF-8 support (essential for Spanish diacritics)
- **List operations**: findall/3, member/2, append/3 built-in
- **Modules**: Organize code without naming hacks
- **Tabling**: Memoization for performance
- **Constraint Logic Programming**: CLP(FD), CLP(R) for complex problems
- **Rich standard library**: JSON, HTTP, regex, more
- **Better DCG support**: phrase/2, phrase/3 with cleaner semantics
- **Faster unification**: Indexed first argument
- **Community**: Excellent documentation and packages

## Example Narratives

### Simple Story (English)
```
Once upon a time a wizard was in the forest.
Then the wizard discovered the ancient sword.
Finally the wizard became famous.
```

### Diálogo (Spanish)
```
Arthur said: "He viajado muy lejos"
Merlin said: "La esperanza es el mayor tesoro"
```

### Description
```
There is a mysterious castle.
Its colors are golden, its features are magnificent.
To those who know it, it feels magical.
```

## Development

### Adding a New Word Bank Category
1. Add to `dict_en.pl`:
   ```prolog
   word_bank(emotions, en, [happy, sad, angry, afraid, ...]).
   ```

2. Add to `dict_es.pl`:
   ```prolog
   word_bank(emotions, es, [feliz, triste, enojado, asustado, ...]).
   ```

3. Use in DCG rules in `generator.pl`:
   ```prolog
   emotion(Lang, E) --> { random_select_word(emotions, Lang, E) }, [E].
   ```

### Adding a New Narrative Type
1. Define template in `narratives.pl`
2. Add DCG rule in `generator.pl`
3. Add menu option in `tui.pl`
4. Update `generate_narrative/3`

### Running Tests
Currently: manual testing via TUI. See TODO.md for automated test plan.

## Contributing

1. Update **both** `dict_en.pl` and `dict_es.pl` for word additions
2. Add Turbo Prolog notes in comments for new code
3. Test with both languages: `--lang en` and `--lang es`
4. Update wikis (EN and ES) for significant changes
5. See HANDOFF.md for collaboration guidelines

## Documentation

- **CLAUDE.md** - Instructions for Claude Code (AI assistant)
- **wiki_en.md** - English project wiki (Obsidian-compatible)
- **wiki_es.md** - Spanish project wiki (Obsidian-compatible)
- **TODO.md** - Development roadmap
- **HANDOFF.md** - Handoff notes for next developer

## Licenses & Attribution

- This project is inspired by Turbo Prolog (1989) and modern SWI-Prolog
- Written in pure Prolog (no dependencies except SWI-Prolog runtime)

## Status

**Early Development** – Basic narrative generation works. Next: expand word banks, fix DCG integration issues, add more templates.

## Get Started

```bash
# Clone the repo
git clone <url>
cd prolog-discourse-gen

# Install SWI-Prolog if needed
# (macOS: brew install swi-prolog)
# (Linux: sudo apt install swi-prolog)
# (Windows: download from swi-prolog.org)

# Run the interactive UI
swipl -l src/main.pl

# Or generate a story in Spanish
swipl -l src/main.pl -- --lang es --seed 42

# See TODO.md for what's next
```

---

**Questions?** Check `CLAUDE.md` for architecture notes, `wiki_en.md` / `wiki_es.md` for detailed explanations, or `HANDOFF.md` for collaboration guidance.
