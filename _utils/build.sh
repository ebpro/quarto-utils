#!/bin/bash

# Set strict error handling
set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DRY_RUN=false
VERBOSE=false
SKIP_SLIDES=false
SKIP_NOTES=false

# Help function
show_help() {
    echo -e "${BLUE}Usage:${NC} $(basename $0) [options] [quarto-args]"
    echo
    echo "Options:"
    echo "  -h, --help        Show this help message"
    echo "  -d, --dry-run     Show what would be done without doing it"
    echo "  -v, --verbose     Increase verbosity"
    echo "  --skip-slides     Skip building slides"
    echo "  --skip-notes      Skip building notes"
    echo
    echo "Any additional arguments are passed to quarto render"
}

# Parse command line arguments
QUARTO_ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --skip-slides)
            SKIP_SLIDES=true
            shift
            ;;
        --skip-notes)
            SKIP_NOTES=true
            shift
            ;;
        *)
            QUARTO_ARGS+=("$1")
            shift
            ;;
    esac
done

# Log function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

# Verbose log function
vlog() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[DEBUG]${NC} $1"
    fi
}

# Error function
error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

# Warning function
warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Build function
build_documents() {
    local profile=$1
    local args=("${@:2}")
    
    log "Building documents for profile: ${profile}"
    vlog "Using arguments: ${args[*]}"
    
    if [[ "$DRY_RUN" == true ]]; then
        echo "Would run: quarto render ${args[*]} --profile ${profile}"
    else
        if ! quarto render "${args[@]}" --profile "${profile}"; then
            error "Failed to build documents for profile: ${profile}"
        fi
    fi
}

# Main execution
log "Starting build process..."

# Ensure we're in a safe directory for git operations
vlog "Configuring git safe directory..."
git config --global --add safe.directory /home/jovyan/work/local || warn "Could not set safe.directory"

# Build notes
if [[ "$SKIP_NOTES" == false ]]; then
    build_documents "notes" "${QUARTO_ARGS[@]}"
fi

# Build slides
if [[ "$SKIP_SLIDES" == false ]]; then
    # Remove specific arguments for slides
    SLIDE_ARGS=()
    for arg in "${QUARTO_ARGS[@]}"; do
        if [[ "$arg" != "--execute" && "$arg" != "--no-cache" ]]; then
            SLIDE_ARGS+=("$arg")
        fi
    done
    build_documents "slides" "${SLIDE_ARGS[@]}"
fi

log "Build completed successfully! 🎉"