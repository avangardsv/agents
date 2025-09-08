#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"

if [[ -f "$PROJECT_ROOT/lib/log.sh" ]]; then
    source "$PROJECT_ROOT/lib/log.sh"
else
    log_info() { echo "[INFO] $*"; }
    log_error() { echo "[ERROR] $*" >&2; }
    log_success() { echo "[SUCCESS] $*"; }
fi

show_help() {
    cat << 'EOF'
Configuration Validation Tool

Usage:
  ./check-config.sh [options] [files...]

Options:
  --docker            Check Docker configurations
  --yaml              Check YAML files
  --json              Check JSON files  
  --scripts           Check shell scripts
  --all               Check all configuration types
  --help, -h          Show this help

Examples:
  ./check-config.sh --docker docker/compose.yml
  ./check-config.sh --yaml monitoring/*.yml
  ./check-config.sh --all
  ./check-config.sh docker/compose.yml config.json
EOF
}

check_docker_config() {
    local file="$1"
    
    if ! command -v docker >/dev/null 2>&1; then
        log_error "Docker not found, skipping $file"
        return 1
    fi
    
    if docker compose -f "$file" config >/dev/null 2>&1; then
        log_success "Docker config valid: $file"
        return 0
    else
        log_error "Docker config invalid: $file"
        return 1
    fi
}

check_yaml_file() {
    local file="$1"
    
    if command -v yamllint >/dev/null 2>&1; then
        if yamllint "$file" >/dev/null 2>&1; then
            log_success "YAML valid: $file"
            return 0
        else
            log_error "YAML invalid: $file"
            return 1
        fi
    elif command -v python3 >/dev/null 2>&1; then
        if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
            log_success "YAML valid: $file"
            return 0
        else
            log_error "YAML invalid: $file"
            return 1
        fi
    else
        log_error "No YAML validator found (yamllint or python3)"
        return 1
    fi
}

check_json_file() {
    local file="$1"
    
    if command -v jq >/dev/null 2>&1; then
        if jq empty "$file" >/dev/null 2>&1; then
            log_success "JSON valid: $file"
            return 0
        else
            log_error "JSON invalid: $file"
            return 1
        fi
    elif command -v python3 >/dev/null 2>&1; then
        if python3 -c "import json; json.load(open('$file'))" 2>/dev/null; then
            log_success "JSON valid: $file"
            return 0
        else
            log_error "JSON invalid: $file"
            return 1
        fi
    else
        log_error "No JSON validator found (jq or python3)"
        return 1
    fi
}

check_shell_script() {
    local file="$1"
    
    if command -v shellcheck >/dev/null 2>&1; then
        if shellcheck "$file" >/dev/null 2>&1; then
            log_success "Shell script valid: $file"
            return 0
        else
            log_error "Shell script issues: $file"
            shellcheck "$file"
            return 1
        fi
    elif bash -n "$file" 2>/dev/null; then
        log_success "Shell script syntax valid: $file"
        return 0
    else
        log_error "Shell script syntax invalid: $file"
        return 1
    fi
}

check_file() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        log_error "File not found: $file"
        return 1
    fi
    
    case "$file" in
        *.yml|*.yaml)
            if [[ "$file" == *"compose"* ]] || [[ "$file" == *"docker"* ]]; then
                check_docker_config "$file"
            else
                check_yaml_file "$file"
            fi
            ;;
        *.json)
            check_json_file "$file"
            ;;
        *.sh)
            check_shell_script "$file"
            ;;
        *)
            log_error "Unknown file type: $file"
            return 1
            ;;
    esac
}

find_and_check() {
    local type="$1"
    local exit_code=0
    
    case "$type" in
        "docker")
            find "$PROJECT_ROOT" -name "*.yml" -o -name "*.yaml" | grep -E "(compose|docker)" | while read -r file; do
                check_docker_config "$file" || exit_code=1
            done
            ;;
        "yaml")
            find "$PROJECT_ROOT" -name "*.yml" -o -name "*.yaml" | while read -r file; do
                check_yaml_file "$file" || exit_code=1
            done
            ;;
        "json")
            find "$PROJECT_ROOT" -name "*.json" | while read -r file; do
                check_json_file "$file" || exit_code=1
            done
            ;;
        "scripts")
            find "$PROJECT_ROOT" -name "*.sh" | while read -r file; do
                check_shell_script "$file" || exit_code=1
            done
            ;;
        "all")
            find_and_check "docker"
            find_and_check "yaml"
            find_and_check "json" 
            find_and_check "scripts"
            ;;
    esac
    
    return $exit_code
}

CHECK_TYPE=""
FILES=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --docker)
            CHECK_TYPE="docker"
            shift
            ;;
        --yaml)
            CHECK_TYPE="yaml"
            shift
            ;;
        --json)
            CHECK_TYPE="json"
            shift
            ;;
        --scripts)
            CHECK_TYPE="scripts"
            shift
            ;;
        --all)
            CHECK_TYPE="all"
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
        *)
            FILES+=("$1")
            shift
            ;;
    esac
done

if [[ ${#FILES[@]} -gt 0 ]]; then
    exit_code=0
    for file in "${FILES[@]}"; do
        check_file "$file" || exit_code=1
    done
    exit $exit_code
elif [[ -n "$CHECK_TYPE" ]]; then
    find_and_check "$CHECK_TYPE"
else
    echo "No files specified and no check type selected" >&2
    show_help
    exit 1
fi