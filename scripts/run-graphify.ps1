# Run graphify with environment variables from .env
# Usage: .\scripts\run-graphify.ps1 [input-file]

param(
    [Parameter(Mandatory=$false)]
    [string]$InputFile
)

# Set error action to stop on error
$ErrorActionPreference = "Stop"

# Script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir

# Load environment variables from .env
$EnvFile = Join-Path $ProjectRoot ".env"

if (Test-Path $EnvFile) {
    Write-Host "✓ Loading configuration from .env" -ForegroundColor Green

    # Parse .env file
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match '^\s*#' -or $_ -match '^\s*$') {
            # Skip comments and empty lines
        } else {
            if ($_ -match '^([^=]+)=(.*)$') {
                $key = $matches[1].Trim()
                $value = $matches[2].Trim()
                # Remove quotes if present
                $value = $value -replace '^"(.*)"$', '$1'
                $value = $value -replace "^'(.*)'$", '$1'
                [Environment]::SetEnvironmentVariable($key, $value, "Process")
            }
        }
    }
} else {
    Write-Host "❌ Error: .env file not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please create .env file with required configuration:"
    Write-Host "  Copy-Item .env.example .env"
    Write-Host "  # Edit .env and add your API keys"
    exit 1
}

# Validate required variables
if ([string]::IsNullOrEmpty([Environment]::GetEnvironmentVariable("GRAPHIFY_API_KEY"))) {
    Write-Host "❌ Error: GRAPHIFY_API_KEY not set in .env" -ForegroundColor Red
    exit 1
}

# Use command-line argument or fall back to .env
if ([string]::IsNullOrEmpty($InputFile)) {
    $InputFile = [Environment]::GetEnvironmentVariable("GRAPHIFY_INPUT")
}

if ([string]::IsNullOrEmpty($InputFile)) {
    Write-Host "❌ Error: No input file specified" -ForegroundColor Red
    Write-Host ""
    Write-Host "Usage: .\scripts\run-graphify.ps1 [input-file]"
    Write-Host "  or set GRAPHIFY_INPUT in .env"
    exit 1
}

# Resolve path
$InputPath = Join-Path $ProjectRoot $InputFile
if (-not (Test-Path $InputPath)) {
    # Try as absolute path
    if (-not (Test-Path $InputFile)) {
        Write-Host "❌ Error: Input file/directory not found: $InputFile" -ForegroundColor Red
        exit 1
    }
    $InputPath = $InputFile
}

# Get environment variables with defaults
$OutputDir = [Environment]::GetEnvironmentVariable("GRAPHIFY_OUTPUT") -or "graphify-out"
$Format = [Environment]::GetEnvironmentVariable("GRAPHIFY_FORMAT") -or "json"
$InputType = [Environment]::GetEnvironmentVariable("GRAPHIFY_INPUT_TYPE") -or "auto"
$Verbose = [Environment]::GetEnvironmentVariable("GRAPHIFY_VERBOSE") -or "false"
$Debug = [Environment]::GetEnvironmentVariable("GRAPHIFY_DEBUG") -or "false"
$Model = [Environment]::GetEnvironmentVariable("GRAPHIFY_MODEL")
$Temperature = [Environment]::GetEnvironmentVariable("GRAPHIFY_TEMPERATURE")
$MaxTokens = [Environment]::GetEnvironmentVariable("GRAPHIFY_MAX_TOKENS")
$AnthropicKey = [Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY")

# Check if graphify is installed
try {
    $null = Get-Command graphify -ErrorAction Stop
} catch {
    Write-Host "❌ Error: graphify command not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "Install graphify:"
    Write-Host "  npm install -g @anthropic-ai/graphify"
    Write-Host "  # or"
    Write-Host "  pip install graphify"
    exit 1
}

# Build arguments array
$Arguments = @(
    "--input", "'$InputPath'"
    "--output", "'$OutputDir'"
    "--format", "'$Format'"
    "--input-type", "'$InputType'"
)

# Add optional arguments
if ($Verbose -eq "true") {
    $Arguments += "--verbose"
}

if ($Debug -eq "true") {
    $Arguments += "--debug"
}

if (-not [string]::IsNullOrEmpty($Model)) {
    $Arguments += "--model", "'$Model'"
}

if (-not [string]::IsNullOrEmpty($Temperature)) {
    $Arguments += "--temperature", "'$Temperature'"
}

if (-not [string]::IsNullOrEmpty($MaxTokens)) {
    $Arguments += "--max-tokens", "'$MaxTokens'"
}

# Set Anthropic key if available
if (-not [string]::IsNullOrEmpty($AnthropicKey)) {
    [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $AnthropicKey, "Process")
}

# Display configuration
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Graphify Configuration" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Input:        $InputPath"
Write-Host "Output:       $OutputDir"
Write-Host "Format:       $Format"
Write-Host "Input Type:   $InputType"
if ($Verbose -eq "true") { Write-Host "Verbose:      ON" }
if ($Debug -eq "true") { Write-Host "Debug:        ON" }
if (-not [string]::IsNullOrEmpty($Model)) { Write-Host "Model:        $Model" }
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Run graphify
Write-Host "Running graphify..." -ForegroundColor Yellow
Write-Host ""

try {
    & graphify @Arguments

    Write-Host ""
    Write-Host "✅ Graphify completed successfully" -ForegroundColor Green
    Write-Host "Output saved to: $OutputDir"

    # Show output summary
    $OutputPath = Join-Path $ProjectRoot $OutputDir
    if (Test-Path $OutputPath) {
        Write-Host ""
        Write-Host "Output files:"
        Get-ChildItem -Path $OutputPath -File | ForEach-Object {
            $size = "{0:N0} bytes" -f $_.Length
            Write-Host "  - $($_.Name) ($size)"
        }
    }
} catch {
    Write-Host ""
    Write-Host "❌ Graphify failed with error:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
