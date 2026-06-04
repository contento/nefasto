#!/bin/bash
# Run graphify with environment variables from .env
# Usage: ./scripts/run-graphify.sh [input-file]

set -e

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Load environment variables from .env
if [ -f "$PROJECT_ROOT/.env" ]; then
    export $(cat "$PROJECT_ROOT/.env" | grep -v '^#' | grep -v '^$' | xargs)
    echo "✓ Loaded configuration from .env"
else
    echo "❌ Error: .env file not found"
    echo ""
    echo "Please create .env file with required configuration:"
    echo "  cp .env.example .env"
    echo "  # Edit .env and add your API keys"
    exit 1
fi

# Validate required variables
if [ -z "$GRAPHIFY_API_KEY" ]; then
    echo "❌ Error: GRAPHIFY_API_KEY not set in .env"
    exit 1
fi

# Use command-line argument or fall back to .env
INPUT_FILE="${1:-$GRAPHIFY_INPUT}"

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

# Build graphify command
GRAPHIFY_CMD="/graphify"

# Check if graphify is installed
if ! command -v graphify &> /dev/null; then
    echo "❌ Error: graphify command not found"
    echo ""
    echo "Install graphify:"
    echo "  npm install -g @anthropic-ai/graphify"
    echo "  # or"
    echo "  pip install graphify"
    exit 1
fi

# Build arguments
ARGS="--input '$INPUT_FILE'"
ARGS="$ARGS --output '$OUTPUT_DIR'"
ARGS="$ARGS --format '$FORMAT'"
ARGS="$ARGS --input-type '$INPUT_TYPE'"

# Add optional arguments
if [ "$VERBOSE" = "true" ]; then
    ARGS="$ARGS --verbose"
fi

if [ "$DEBUG" = "true" ]; then
    ARGS="$ARGS --debug"
fi

if [ -n "$GRAPHIFY_MODEL" ]; then
    ARGS="$ARGS --model '$GRAPHIFY_MODEL'"
fi

if [ -n "$GRAPHIFY_TEMPERATURE" ]; then
    ARGS="$ARGS --temperature '$GRAPHIFY_TEMPERATURE'"
fi

if [ -n "$GRAPHIFY_MAX_TOKENS" ]; then
    ARGS="$ARGS --max-tokens '$GRAPHIFY_MAX_TOKENS'"
fi

if [ -n "$ANTHROPIC_API_KEY" ]; then
    export ANTHROPIC_API_KEY
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
