# Running Prolog Discourse Generator

Two ways to use the Prolog Discourse Generator: **Simple TUI** or **Advanced Web UI**.

---

## Option 1: Simple TUI (Terminal)

Pure Prolog with ANSI colors. No dependencies beyond SWI-Prolog.

### Requirements
- SWI-Prolog 8.0+ ([download](https://www.swi-prolog.org/download/stable))

### Run

```bash
cd /Users/contento/projects/prolog-discourse-gen

# Interactive menu
swipl -l src/main.pl

# With arguments
swipl -l src/main.pl -- --lang es --seed 42 --config config/default.yaml
```

### CLI Arguments

- `--lang en|es` - Language (default: en)
- `--seed N` - Random seed for reproducibility (default: 42)
- `--config FILE` - Load JSON/YAML/TOML config

### Example

```bash
# Generate Spanish stories with fixed seed
swipl -l src/main.pl -- --lang es --seed 100

# Load custom config
swipl -l src/main.pl -- --config config/custom.yaml
```

---

## Option 2: Advanced Web UI (React + Prolog)

Browser-based interface with real-time generation. Client + Backend architecture.

### Requirements
- SWI-Prolog 8.0+
- Node.js 14+ ([download](https://nodejs.org/))
- npm (comes with Node.js)

### Setup (First Time Only)

```bash
cd /Users/contento/projects/prolog-discourse-gen/web

# Install React dependencies
npm install

# Copy environment template
cp .env.example .env
```

### Run (Two Terminals)

**Terminal 1 - Start Prolog Backend**

```bash
cd /Users/contento/projects/prolog-discourse-gen
swipl -f src/server.pl -t start_server
```

You should see:
```
Starting Prolog Discourse Generator Server
Port: 3001
Server running on http://localhost:3001
```

**Terminal 2 - Start React Frontend**

```bash
cd /Users/contento/projects/prolog-discourse-gen/web

# Development mode
npm run dev
```

This opens http://localhost:3000 in your browser automatically.

### Features

- 🎨 Modern web interface
- 🌍 Language switcher (English / Español)
- 🎲 Random seed control
- 📋 Copy to clipboard
- 📱 Responsive design (desktop, tablet, mobile)
- 🌙 Dark mode support

### Build for Production

```bash
cd /Users/contento/projects/prolog-discourse-gen/web
npm run build
```

Creates optimized files in `dist/`. See `web/README.md` for deployment instructions.

---

## Comparison

| Feature | TUI | Web |
|---------|-----|-----|
| **Interface** | Terminal with menus | Modern web UI |
| **Installation** | Just SWI-Prolog | Node.js + npm |
| **Dependencies** | 0 | ~150 (npm packages) |
| **Speed** | Fast startup | Slightly slower (build) |
| **Responsiveness** | Good | Excellent |
| **Mobile** | ❌ | ✅ |
| **Dark mode** | No | ✅ Automatic |
| **Copy/share** | Manual | 1-click copy |
| **Best for** | Quick testing, scripts | Daily use, UI/UX |

---

## Troubleshooting

### TUI: "No word_bank found"
- Check `data/dict_en.pl` and `data/dict_es.pl` exist
- Verify no syntax errors: `swipl -c src/main.pl`

### Web: "Connection refused"
- Is Prolog server running? Check Terminal 1
- Is it on port 3001? Look for "Server running on http://localhost:3001"
- Try `curl http://localhost:3001/api/languages`

### Web: "npm command not found"
- Install Node.js: https://nodejs.org/
- Verify: `npm --version`

### Web: Build fails
- Update npm: `npm install -g npm@latest`
- Clear cache: `rm -rf node_modules package-lock.json && npm install`

---

## Architecture

### TUI (Simple)
```
User Terminal
    ↓ (ANSI colors)
src/main.pl (Prolog)
    ├─ src/tui.pl (menus)
    ├─ src/generator.pl (DCG)
    ├─ src/ontology.pl (rules)
    ├─ data/dict_*.pl (words)
    └─ src/state.pl (tracking)
```

### Web (Advanced)
```
Browser (React)
    ↓ HTTP
http://localhost:3000
    ↓ Fetch API
http://localhost:3001 (Prolog Server)
    ├─ src/server.pl (HTTP endpoints)
    ├─ src/generator.pl (DCG)
    ├─ src/ontology.pl (rules)
    ├─ data/dict_*.pl (words)
    └─ src/state.pl (tracking)
```

---

## Development

### Adding New Words

**For TUI and Web** (both use same backend):

Edit `data/dict_en.pl` and `data/dict_es.pl`:

```prolog
word_bank(nouns, en, [
    wizard, knight, dragon, forest, castle,
    merchant, village, tower  % ← add new words here
]).
```

Changes apply to both TUI and Web immediately (restart for TUI, reload web).

### Adding New Narrative Types

1. Add DCG rule to `src/generator.pl`
2. Add type to `src/server.pl` validation
3. Add to React options in `web/src/App.jsx`
4. Update `data/narratives.pl`

### Testing

```bash
# Test Prolog modules
swipl -c src/main.pl

# Test server endpoints
curl http://localhost:3001/api/generate?lang=en&seed=42&type=simple_story

# Test frontend
npm run lint  # (from web/ directory)
```

---

## Common Tasks

### Generate 10 stories with different seeds (TUI)
```bash
for seed in {1..10}; do
  echo "=== Seed $seed ==="
  swipl -l src/main.pl -- --lang en --seed $seed | head -20
done
```

### Export narrative to file (TUI)
```bash
swipl -l src/main.pl -- --lang es --seed 123 > output.txt
```

### Start web server on custom port
```bash
# Edit web/vite.config.js: change port: 3000 to port: 3000
# Then run: npm run dev

# Or start Prolog on different port:
swipl -f src/server.pl -g "start_server(3002)" -t halt
```

---

## See Also

- `README.md` - Project overview
- `CLAUDE.md` - Architecture decisions
- `TODO.md` - Development roadmap
- `web/README.md` - Web UI details
- `docs/wiki_en.md` - Complete English documentation
- `docs/wiki_es.md` - Complete Spanish documentation

---

**Ready to generate narratives?** Choose your interface above and start! 🚀
