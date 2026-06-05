#!/bin/bash
# Run graphify with configuration from .env and graphify.toml
# Usage: ./scripts/run-graphify.sh [input-file]

set -e

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
CONFIG_FILE="$SCRIPT_DIR/graphify.toml"

# Load environment variables from .env (secrets only)
if [ -f "$PROJECT_ROOT/.env" ]; then
    export $(cat "$PROJECT_ROOT/.env" | grep -v '^#' | grep -v '^$' | xargs)
    echo "✓ Loaded secrets from .env"
else
    echo "❌ Error: .env file not found"
    echo ""
    echo "Please create .env file with required API key:"
    echo "  cp .env.example .env"
    echo "  # Edit .env and add your OpenRouter API key"
    exit 1
fi

# Load configuration from TOML
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: graphify.toml not found at $CONFIG_FILE"
    echo ""
    echo "Please copy the example config:"
    echo "  cp $SCRIPT_DIR/graphify.toml.example $SCRIPT_DIR/graphify.toml"
    exit 1
fi
echo "✓ Loaded configuration from graphify.toml"

# Validate required LLM API key
if [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$OPENAI_API_KEY" ] && [ -z "$GEMINI_API_KEY" ] && [ -z "$DEEPSEEK_API_KEY" ] && [ -z "$MOONSHOT_API_KEY" ]; then
    echo "❌ Error: No LLM API key found in .env"
    echo ""
    echo "Graphify requires one of these API keys:"
    echo "  - ANTHROPIC_API_KEY (Claude) - https://console.anthropic.com"
    echo "  - OPENAI_API_KEY (GPT) - https://platform.openai.com/api-keys"
    echo "  - GEMINI_API_KEY (Google) - https://ai.google.dev/api"
    echo "  - DEEPSEEK_API_KEY (DeepSeek) - https://platform.deepseek.com"
    echo "  - MOONSHOT_API_KEY (Kimi) - https://platform.moonshot.cn"
    echo ""
    echo "Add one to your .env file, e.g.:"
    echo "  ANTHROPIC_API_KEY=sk-ant-YOUR_KEY"
    exit 1
fi

# Use command-line argument or fall back to current directory
INPUT_FILE="${1:-.}"

if [ -z "$INPUT_FILE" ]; then
    echo "❌ Error: No input file specified"
    echo ""
    echo "Usage: ./scripts/run-graphify.sh [input-file]"
    echo "  or set GRAPHIFY_INPUT in .env"
    exit 1
fi

if [ ! -f "$INPUT_FILE" ] && [ ! -d "$INPUT_FILE" ]; then
    echo "❌ Error: Input file/directory not found: $INPUT_FILE"
    exit 1
fi

# Set defaults
OUTPUT_DIR="${GRAPHIFY_OUTPUT:-graphify-out}"
FORMAT="${GRAPHIFY_FORMAT:-json}"
INPUT_TYPE="${GRAPHIFY_INPUT_TYPE:-auto}"
VERBOSE="${GRAPHIFY_VERBOSE:-false}"
DEBUG="${GRAPHIFY_DEBUG:-false}"

# Check if graphify is installed
if ! command -v graphify &> /dev/null; then
    echo "❌ Error: graphify command not found"
    echo ""
    echo "Install graphify:"
    echo "  npm install -g @anthropic-ai/graphify"
    exit 1
fi

# Build arguments for: graphify extract <path> [options]
ARGS="extract '$INPUT_FILE'"
ARGS="$ARGS --out '$OUTPUT_DIR'"

# Add optional arguments
if [ -n "$GRAPHIFY_MODEL" ]; then
    ARGS="$ARGS --model '$GRAPHIFY_MODEL'"
fi

if [ "$GRAPHIFY_MODE" = "deep" ]; then
    ARGS="$ARGS --mode deep"
fi

if [ -n "$GRAPHIFY_BACKEND" ]; then
    ARGS="$ARGS --backend '$GRAPHIFY_BACKEND'"
fi

if [ -n "$GRAPHIFY_MAX_WORKERS" ]; then
    ARGS="$ARGS --max-workers '$GRAPHIFY_MAX_WORKERS'"
fi

if [ "$GRAPHIFY_NO_CLUSTER" = "true" ]; then
    ARGS="$ARGS --no-cluster"
fi

if [ -n "$OPENROUTER_API_KEY" ]; then
    export OPENROUTER_API_KEY
fi

# Display configuration
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Graphify Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Input:        $INPUT_FILE"
echo "Output:       $OUTPUT_DIR"
echo "Format:       $FORMAT"
echo "Input Type:   $INPUT_TYPE"
[ "$VERBOSE" = "true" ] && echo "Verbose:      ON"
[ "$DEBUG" = "true" ] && echo "Debug:        ON"
[ -n "$GRAPHIFY_MODEL" ] && echo "Model:        $GRAPHIFY_MODEL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Run graphify
echo "Running graphify..."
echo ""

eval "graphify $ARGS"

# Check exit code
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Graphify completed successfully"
    echo "Output saved to: $OUTPUT_DIR"

    # Show output summary
    if [ -d "$OUTPUT_DIR" ]; then
        echo ""
        echo "Output files:"
        ls -lh "$OUTPUT_DIR"
    fi
else
    echo ""
    echo "❌ Graphify failed with exit code $?"
    exit 1
fi
