# Scripts

Helper scripts for running tools with the Nefasto project.

## Graphify

Generate a knowledge graph from project files using Claude AI.

### Setup

#### 1. Get free OpenRouter API key
- Visit https://openrouter.ai
- Sign up (free - no credit card required)
- Get your API key from https://openrouter.ai/keys
- Free tier: 5M tokens/month

#### 2. Setup secrets (.env)
```bash
cp .env.example .env
# Edit .env and add your OpenRouter key:
#   OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE
```

#### 3. Setup configuration (graphify.toml)
```bash
cp scripts/graphify.toml.example scripts/graphify.toml
# Edit scripts/graphify.toml to customize:
#   - input source (file/directory)
#   - output format (json, yaml)
#   - model selection
#   - temperature, max tokens
#   - verbose/debug mode
```

#### 4. Make script executable (Linux/macOS)
```bash
chmod +x scripts/run-graphify.sh
```

### Usage

#### Linux / macOS

```bash
# Use default input from .env
./scripts/run-graphify.sh

# Specify input file
./scripts/run-graphify.sh README.md

# Generate graph from entire src/ directory
./scripts/run-graphify.sh src/
```

#### Windows (PowerShell)

```powershell
# Use default input from .env
.\scripts\run-graphify.ps1

# Specify input file
.\scripts\run-graphify.ps1 README.md

# Generate graph from entire src/ directory
.\scripts\run-graphify.ps1 src/
```

### Configuration (.env file)

Create a `.env` file from `.env.example`:

```bash
# Required
OPENROUTER_API_KEY=sk-or-v1-YOUR_KEY            # OpenRouter free API key
GRAPHIFY_INPUT=README.md                         # Input file/directory

# Model selection (free tier options)
GRAPHIFY_MODEL=mistralai/mistral-7b-instruct:free  # Fast & good quality
# Alternative free models:
#   meta-llama/llama-2-7b-chat:free
#   gryphe/mythomist-7b:free
#   openchat/openchat-7b:free

# Optional
GRAPHIFY_OUTPUT=graphify-out                     # Output directory
GRAPHIFY_FORMAT=json                             # Output format (json, yaml)
GRAPHIFY_INPUT_TYPE=auto                         # Input type (auto, code, markdown, text)
GRAPHIFY_TEMPERATURE=0.7                         # Generation temperature (0-1)
GRAPHIFY_MAX_TOKENS=2000                         # Max response tokens
GRAPHIFY_VERBOSE=false                           # Verbose logging
GRAPHIFY_DEBUG=false                             # Debug mode
```

**OpenRouter Free Tier:**
- Sign up: https://openrouter.ai (no credit card)
- Get key: https://openrouter.ai/keys
- Free: 5M tokens/month
- Multiple free models available

### Security

- **`.env` file is in `.gitignore`** - Never commit it
- **API keys are secrets** - Keep them safe
- **Environment variables** are loaded from `.env` file
- **Parameters can be overridden** via command-line arguments

### Examples

**Generate knowledge graph of README:**
```bash
./scripts/run-graphify.sh README.md
```

**Analyze all Prolog source code:**
```bash
./scripts/run-graphify.sh src/
```

**Generate with custom model and output:**
```bash
# Edit .env first:
GRAPHIFY_MODEL=claude-sonnet-4-6
GRAPHIFY_OUTPUT=docs/knowledge-graph

./scripts/run-graphify.sh
```

**Verbose output with debug:**
```bash
# Edit .env:
GRAPHIFY_VERBOSE=true
GRAPHIFY_DEBUG=true

./scripts/run-graphify.sh README.md
```

### Output

By default, output is saved to `graphify-out/` directory:

```
graphify-out/
├── knowledge-graph.json       # Graph in JSON format
├── entities.json              # Extracted entities
├── relationships.json         # Relationships between entities
└── summary.md                 # Text summary
```

### Troubleshooting

**Error: graphify command not found**
```bash
# Install graphify globally
npm install -g @anthropic-ai/graphify
# or with pip
pip install graphify
```

**Error: GRAPHIFY_API_KEY not set**
```bash
# Create .env file with API key
cp .env.example .env
# Then edit and add your key
```

**Error: Input file not found**
```bash
# Check file exists
ls README.md

# Use correct relative path
./scripts/run-graphify.sh README.md
```

### Integration with CI/CD

Scripts can be run in GitHub Actions or other CI systems:

```yaml
# Example: GitHub Actions
- name: Generate knowledge graph
  env:
    GRAPHIFY_API_KEY: ${{ secrets.GRAPHIFY_API_KEY }}
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
  run: |
    cp .env.example .env
    ./scripts/run-graphify.sh README.md
```

Note: Use GitHub Secrets or your CI system's secret management for API keys.
