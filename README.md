# Prolog Discourse Generator: Reviving Nefasto

**English** | **[Español](README.es.md)** 🇨🇴

A pure Prolog narrative generator reviving the original **Nefasto discourse generator**—a real project built at [Universidad de Antioquia](https://www.udea.edu.co/) (Medellín) in the late 1980s using Turbo Prolog.

## The Story Behind the Name

In the late 1980s, Prof. Fabian Rios built a simple discourse generator using Turbo Prolog: 10 columns, each with ~10 random options, concatenated into prose. Each output was "signed" by a fictional author: **Nefasto Bocazza** (originally "Necfardo Bocazza," after NEC—the brand of the [Systems Engineering Department](https://ingenieria.udea.edu.co/)'s first PC).

Prof. Roberto Flores ran the program daily, printed the discourses, and posted them on the faculty bulletin board as a humorous response to the university's verbose professors: "so much discourse and so little action." It worked. The satire became a beloved tradition.

### The Original Code

Prof. Rios recalls the implementation was remarkably simple—10 columns, each picking a random element:

```prolog
% Goal to prove:
P(A) :- p1(rnd(0, 10)),
             p2(rnd(0, 10)),
             p3(rnd(0, 10)),
              ... (7 more columns) ...,
              p10(rnd(0, 10))
```

Where `rnd` was Turbo Prolog's random function. "Unfortunately I don't keep the code. I only remember it was very simple... I don't remember how the concatenate operator or function was." Yet this simple random selection from constrained columns generated discourse coherent enough to fool busy faculty.

**This project revives that spirit**: pure logic, simple rules, and coherent narratives generated without neural networks or statistical models. Just Prolog, just like 1989—but with the advantages of modern SWI-Prolog.

---

## Features

- **Pure Logic**: No ML, no LLMs, no black boxes. Just Prolog.
- **Revived from History**: Based on a real 1989 discourse generator at a Colombian university
- **Coherent Narratives**: Ontologies and state tracking prevent contradictions
- **Simple & Extensible**: Word banks, DCG grammars, narrative templates
- **Multilingual**: English and Spanish support from the ground up
- **Historical Context**: Notes on Turbo Prolog (~1989) vs modern SWI-Prolog
- **Cross-Platform TUI**: Works on Linux, macOS, Windows
- **Flexible Configuration**: JSON, YAML, TOML, and command-line arguments

## Live Examples

### English Story

```bash
swipl -l src/main.pl -- --lang en --seed 42
```

**Output:**

```text
once crown was in the gorge . then crown climbed the shadow . finally crown found .
```

### Spanish Story  

```bash
swipl -l src/main.pl -- --lang es --seed 100
```

**Output:**

```text
Érase bosque fue en el río . luego bosque corrió the ciervo . finalmente bosque huyó .
```

**Status:** Core narrative generation is working! Both English and Spanish generate coherent sentences with actual word selections. Recent fixes:
- Fixed multifile word_bank declaration (English + Spanish coexist properly)
- Fixed DCG subject tracking (subject carries through story)
- Fixed CORS, server port, and critical type errors from code review

## Discourse Profiles

The generator supports multiple **discourse profiles** that change narrative voice and vocabulary. Each profile generates different prose from the same underlying structure.

### Political Profile

Argumentative, policy-focused, persuasive discourse with political vocabulary.

```bash
swipl -l src/main.pl -- --lang en --profile political --seed 42
```

**Sample outputs:**

```text
once Napoleon arrived in the state . then Napoleon amended the clause . finally Napoleon contested with status-quo .
once Napoleon arrived in the chamber . then Napoleon conspired the representative . finally Napoleon betrayed with strategic .
once Lincoln arrived in the territory . then Lincoln declared the rule . finally Lincoln refuted with democratic .
```

**Vocabulary:** senator, parliament, legislation, debate, reform, decree, policy, authority, etc.

### Sales Profile

Action-oriented, benefit-focused, pitch-style discourse with business vocabulary.

```bash
swipl -l src/main.pl -- --lang en --profile sales --seed 42
```

**Sample outputs:**

```text
once Michael arrived in the office . then Michael persuaded the efficiency . finally Michael maximized with outstanding .
once Rockefeller arrived in the network . then Rockefeller revolutionized the agreement . finally Rockefeller exceeded with outstanding .
once Bezos arrived in the space . then Bezos expanded the industry . finally Bezos generated with premium .
```

**Vocabulary:** product, solution, growth, innovation, ROI, synergy, market, revenue, etc.

### Karen Profile

Entitled, demanding, complaint-focused discourse with self-centered vocabulary.

```bash
swipl -l src/main.pl -- --lang en --profile karen --seed 42
```

**Sample outputs:**

```text
once Patricia arrived in the restaurant . then Patricia suggested the refund . finally Patricia cautioned with unprofessional .
once Patricia arrived in the newspaper . then Patricia harmed the investment . finally Patricia threatened with discriminatory .
once Brenda arrived in the television . then Brenda escalated the expectation . finally Brenda cautioned with unfair .
```

**Vocabulary:** manager, complaint, unacceptable, refund, lawsuit, demand, threat, etc.

**See [PROFILES.md](PROFILES.md) for:**

- All current profiles (political, sales, karen)
- 10+ suggested profiles for future implementation
- Implementation guide for adding new profiles

## Quick Start

### Two Interfaces

Choose one:

#### **Simple TUI** (Terminal-based)
```bash
# Requirements: Just SWI-Prolog

swipl -l src/main.pl
```

#### **Advanced Web UI** (Browser-based)
```bash
# Requirements: Node.js + npm + SWI-Prolog

# Terminal 1: Start Prolog backend
swipl -f src/server.pl -t start_server

# Terminal 2: Start React frontend
cd web && npm install && npm run dev
```

### Full Setup Details

See **[RUN.md](RUN.md)** for:
- Step-by-step instructions for both interfaces
- CLI arguments for TUI
- Configuration for Web UI
- Troubleshooting guide
- Architecture comparison

### Requirements
- **SWI-Prolog 8.0+** ([download](https://www.swi-prolog.org/download/stable))
- **Node.js 14+** (only for Web UI) ([download](https://nodejs.org/))
- UTF-8 terminal support (modern by default)

### Installation
```bash
git clone https://github.com/yourusername/prolog-discourse-gen
cd prolog-discourse-gen

# For Web UI, also:
cd web && npm install
```

## Project Structure

```
nefasto/                      # Nefasto Discourse Generator
├── src/                      # Core Prolog modules
│   ├── main.pl              # Entry point & CLI arg parsing
│   ├── tui.pl               # Terminal UI (cross-platform ANSI)
│   ├── generator.pl         # DCG rules & phrase/3 generation
│   ├── ontology.pl          # Entity relationships & constraints
│   ├── state.pl             # Entity tracking & coherence
│   ├── config.pl            # Configuration loader (JSON/YAML/TOML)
│   ├── random_utils.pl      # Random selection & word picking
│   └── server.pl            # HTTP server (REST API)
│
├── data/                     # Lexicons & narrative templates
│   ├── dict_en.pl           # English word banks (34+ nouns)
│   ├── dict_es.pl           # Spanish word banks (34+ sustantivos)
│   └── narratives.pl        # Story templates & narrative structures
│
├── tests/                    # Test suite
│   └── run_tests.pl         # Comprehensive test runner (7 test categories)
│
├── config/                   # Configuration examples
│   ├── default.json         # JSON configuration template
│   ├── default.yaml         # YAML configuration template
│   └── default.toml         # TOML configuration template
│
├── docs/                     # Documentation
│   ├── wiki_en.md           # English wiki (Obsidian-compatible)
│   └── wiki_es.md           # Spanish wiki (Obsidian-compatible)
│
├── web/                      # Web UI (React frontend) [optional]
│   ├── README.md            # Web setup instructions
│   └── package.json         # Node.js dependencies
│
├── CLAUDE.md                # AI assistant instructions (testing required!)
├── README.md                # This file
├── README.es.md             # Spanish README
├── RUN.md                   # Detailed setup & run instructions
├── TODO.md                  # Development roadmap & code review findings
├── HANDOFF.md               # Handoff notes for collaborators
└── .graphifyignore          # Knowledge graph configuration
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

### Quick Start (Nefasto)

```bash
# Clone the repo
git clone https://github.com/contento/nefasto
cd nefasto

# Verify tests pass (56/56)
swipl tests/run_all_tests.pl

# Run the interactive UI
swipl -l src/main.pl

# Or generate a story in Spanish
swipl -l src/main.pl -- --lang es --seed 42

# Generate knowledge graph
cp .env.example .env
# Edit .env and add API keys
./scripts/run-graphify.sh README.md

# See TODO.md for what's next
```

### Generate Knowledge Graph

Analyze code with Claude AI to build knowledge graphs:

```bash
# Bash/zsh/bash
./scripts/run-graphify.sh README.md

# PowerShell (Windows)
.\scripts\run-graphify.ps1 README.md
```

See [scripts/README.md](scripts/README.md) for full documentation on graphify scripts and configuration.

---

**Questions?** Check `CLAUDE.md` for architecture notes, `wiki_en.md` / `wiki_es.md` for detailed explanations, or `HANDOFF.md` for collaboration guidance.
