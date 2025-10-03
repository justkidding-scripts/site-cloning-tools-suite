#!/bin/bash

# Website Cloning System Launcher
# Professional launcher with debug features and enhanced interface

# Version and metadata
VERSION="3.0"
SCRIPT_NAME="Clone System Launcher"
SCRIPT_DIR="/home/kali/Desktop"

# Color codes for cool output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Unicode symbols for enhanced display
CHECK="✅"
CROSS="❌"
ARROW="➤"
STAR="⭐"
GEAR="⚙️"
ROCKET="🚀"
SHIELD="🛡️"
GHOST="👻"
MAGNIFY="🔍"
WARNING="⚠️"
INFO="ℹ️"
FIRE="🔥"

# Debug and dry-run flags
DEBUG=false
DRY_RUN=false
VERBOSE=false

# Script paths
BASIC_SCRIPT="$SCRIPT_DIR/clone_website.sh"
ADVANCED_SCRIPT="$SCRIPT_DIR/clone_advanced.sh"
STEALTH_SCRIPT="$SCRIPT_DIR/clone_stealth.sh"

# Print functions
print_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║           🌐 WEBSITE CLONING SYSTEM LAUNCHER 🌐          ║"
    echo "║                      Version $VERSION                         ║"
    echo "║                                                           ║"
    echo "║  ${FIRE} Professional Web Reconnaissance & Research Tool ${FIRE}   ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo
}

print_debug() {
    if [ "$DEBUG" = true ] || [ "$VERBOSE" = true ]; then
        echo -e "${GRAY}[DEBUG] $1${RESET}"
    fi
}

print_info() {
    echo -e "${BLUE}${INFO} $1${RESET}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${RESET}"
}

print_error() {
    echo -e "${RED}${CROSS} $1${RESET}"
}

print_step() {
    echo -e "${CYAN}${ARROW} $1${RESET}"
}

show_help() {
    print_banner
    
    echo -e "${WHITE}${BOLD}USAGE:${RESET}"
    echo -e "  $(basename $0) [MODE] <URL> [OPTIONS]"
    echo
    
    echo -e "${WHITE}${BOLD}MODES:${RESET}"
    echo -e "  ${GREEN}basic${RESET}           ${GRAY}Simple website cloning with wget${RESET}"
    echo -e "  ${YELLOW}advanced${RESET}        ${GRAY}Enhanced cloning with multiple options${RESET}"
    echo -e "  ${MAGENTA}stealth${RESET}         ${GRAY}Ultimate research tool with stealth features${RESET}"
    echo
    
    echo -e "${WHITE}${BOLD}GENERAL OPTIONS:${RESET}"
    echo -e "  ${CYAN}-h, --help${RESET}      ${GRAY}Show this help message${RESET}"
    echo -e "  ${CYAN}-v, --version${RESET}   ${GRAY}Show version information${RESET}"
    echo -e "  ${CYAN}--debug${RESET}         ${GRAY}Enable debug output${RESET}"
    echo -e "  ${CYAN}--dry-run${RESET}       ${GRAY}Show what would be executed without running${RESET}"
    echo -e "  ${CYAN}--verbose${RESET}       ${GRAY}Enable verbose output${RESET}"
    echo -e "  ${CYAN}--list-modes${RESET}    ${GRAY}List available cloning modes${RESET}"
    echo -e "  ${CYAN}--validate${RESET}      ${GRAY}Validate system dependencies and scripts${RESET}"
    echo
    
    echo -e "${WHITE}${BOLD}CLONING OPTIONS (passed to selected script):${RESET}"
    echo -e "  ${CYAN}-d, --depth <num>${RESET}     ${GRAY}Maximum recursion depth${RESET}"
    echo -e "  ${CYAN}-f, --fast${RESET}            ${GRAY}Fast mode - HTML only${RESET}"
    echo -e "  ${CYAN}-s, --single${RESET}          ${GRAY}Single page only${RESET}"
    echo -e "  ${CYAN}-o, --output <dir>${RESET}    ${GRAY}Custom output directory${RESET}"
    echo
    
    echo -e "${WHITE}${BOLD}STEALTH OPTIONS (stealth mode only):${RESET}"
    echo -e "  ${MAGENTA}--stealth${RESET}           ${GRAY}Enable stealth mode${RESET}"
    echo -e "  ${MAGENTA}--delay <sec>${RESET}       ${GRAY}Delay between requests${RESET}"
    echo -e "  ${MAGENTA}--ua <string>${RESET}       ${GRAY}Custom User-Agent${RESET}"
    echo -e "  ${MAGENTA}--proxy <url>${RESET}       ${GRAY}Use proxy${RESET}"
    echo -e "  ${MAGENTA}--js${RESET}                ${GRAY}Clone JavaScript files${RESET}"
    echo -e "  ${MAGENTA}--robots${RESET}            ${GRAY}Analyze robots.txt${RESET}"
    echo -e "  ${MAGENTA}--sitemap${RESET}           ${GRAY}Download sitemap.xml${RESET}"
    echo -e "  ${MAGENTA}--report${RESET}            ${GRAY}Generate analysis report${RESET}"
    echo -e "  ${MAGENTA}--compress${RESET}          ${GRAY}Compress output${RESET}"
    echo -e "  ${MAGENTA}-q, --quiet${RESET}         ${GRAY}Quiet mode${RESET}"
    echo
    
    echo -e "${WHITE}${BOLD}EXAMPLES:${RESET}"
    echo -e "  ${GREEN}Basic cloning:${RESET}"
    echo -e "    $(basename $0) basic https://example.com"
    echo
    echo -e "  ${YELLOW}Advanced with depth limit:${RESET}"
    echo -e "    $(basename $0) advanced https://example.com -d 3 --fast"
    echo
    echo -e "  ${MAGENTA}Stealth research:${RESET}"
    echo -e "    $(basename $0) stealth https://target.com --stealth --robots --report"
    echo
    echo -e "  ${CYAN}Debug mode:${RESET}"
    echo -e "    $(basename $0) --debug stealth https://example.com --stealth"
    echo
    echo -e "  ${CYAN}Dry run:${RESET}"
    echo -e "    $(basename $0) --dry-run basic https://example.com"
    echo
    
    echo -e "${WHITE}${BOLD}SCRIPT LOCATIONS:${RESET}"
    echo -e "  ${GRAY}Basic:    $BASIC_SCRIPT${RESET}"
    echo -e "  ${GRAY}Advanced: $ADVANCED_SCRIPT${RESET}"
    echo -e "  ${GRAY}Stealth:  $STEALTH_SCRIPT${RESET}"
    echo
}

show_version() {
    print_banner
    echo -e "${WHITE}${BOLD}Version Information:${RESET}"
    echo -e "  ${CYAN}Launcher Version:${RESET} $VERSION"
    echo -e "  ${CYAN}Script Directory:${RESET} $SCRIPT_DIR"
    echo -e "  ${CYAN}Available Modes:${RESET} basic, advanced, stealth"
    echo
    validate_system --quiet
}

list_modes() {
    echo -e "${WHITE}${BOLD}${ROCKET} Available Cloning Modes:${RESET}"
    echo
    
    echo -e "${GREEN}${BOLD}📄 BASIC MODE${RESET}"
    echo -e "  ${GRAY}• Simple recursive website downloading${RESET}"
    echo -e "  ${GRAY}• Basic link conversion and cleanup${RESET}"
    echo -e "  ${GRAY}• Minimal resource usage${RESET}"
    echo -e "  ${GRAY}• Best for: Quick website backups${RESET}"
    echo
    
    echo -e "${YELLOW}${BOLD}🔧 ADVANCED MODE${RESET}"
    echo -e "  ${GRAY}• Enhanced options and configurations${RESET}"
    echo -e "  ${GRAY}• Depth control and filtering${RESET}"
    echo -e "  ${GRAY}• File statistics and basic reporting${RESET}"
    echo -e "  ${GRAY}• Best for: Controlled website analysis${RESET}"
    echo
    
    echo -e "${MAGENTA}${BOLD}👻 STEALTH MODE${RESET}"
    echo -e "  ${GRAY}• Advanced evasion and stealth features${RESET}"
    echo -e "  ${GRAY}• Proxy support and User-Agent rotation${RESET}"
    echo -e "  ${GRAY}• Comprehensive research and analysis tools${RESET}"
    echo -e "  ${GRAY}• Technology detection and reporting${RESET}"
    echo -e "  ${GRAY}• Best for: Security research and penetration testing${RESET}"
    echo
}

validate_system() {
    local quiet_mode=false
    if [ "$1" = "--quiet" ]; then
        quiet_mode=true
    fi
    
    [ "$quiet_mode" = false ] && echo -e "${WHITE}${BOLD}${MAGNIFY} System Validation:${RESET}"
    
    local all_good=true
    
    # Check dependencies
    if command -v wget >/dev/null 2>&1; then
        [ "$quiet_mode" = false ] && print_success "wget is installed"
    else
        [ "$quiet_mode" = false ] && print_error "wget is not installed"
        all_good=false
    fi
    
    if command -v tar >/dev/null 2>&1; then
        [ "$quiet_mode" = false ] && print_success "tar is available"
    else
        [ "$quiet_mode" = false ] && print_warning "tar is not available (compression features disabled)"
    fi
    
    if command -v xmllint >/dev/null 2>&1; then
        [ "$quiet_mode" = false ] && print_success "xmllint is available (enhanced sitemap analysis)"
    else
        [ "$quiet_mode" = false ] && print_warning "xmllint not found (basic sitemap analysis only)"
    fi
    
    # Check scripts
    if [ -f "$BASIC_SCRIPT" ] && [ -x "$BASIC_SCRIPT" ]; then
        [ "$quiet_mode" = false ] && print_success "Basic script available and executable"
    else
        [ "$quiet_mode" = false ] && print_error "Basic script missing or not executable: $BASIC_SCRIPT"
        all_good=false
    fi
    
    if [ -f "$ADVANCED_SCRIPT" ] && [ -x "$ADVANCED_SCRIPT" ]; then
        [ "$quiet_mode" = false ] && print_success "Advanced script available and executable"
    else
        [ "$quiet_mode" = false ] && print_error "Advanced script missing or not executable: $ADVANCED_SCRIPT"
        all_good=false
    fi
    
    if [ -f "$STEALTH_SCRIPT" ] && [ -x "$STEALTH_SCRIPT" ]; then
        [ "$quiet_mode" = false ] && print_success "Stealth script available and executable"
    else
        [ "$quiet_mode" = false ] && print_error "Stealth script missing or not executable: $STEALTH_SCRIPT"
        all_good=false
    fi
    
    # Check permissions
    if [ -w "." ]; then
        [ "$quiet_mode" = false ] && print_success "Current directory is writable"
    else
        [ "$quiet_mode" = false ] && print_warning "Current directory may not be writable"
    fi
    
    [ "$quiet_mode" = false ] && echo
    if [ "$all_good" = true ]; then
        [ "$quiet_mode" = false ] && print_success "System validation completed successfully!"
        return 0
    else
        [ "$quiet_mode" = false ] && print_error "System validation failed - some components are missing"
        return 1
    fi
}

validate_url() {
    local url="$1"
    
    if [ -z "$url" ]; then
        print_error "No URL provided"
        return 1
    fi
    
    # Basic URL validation
    if [[ ! "$url" =~ ^https?:// ]]; then
        print_error "Invalid URL format. Must start with http:// or https://"
        return 1
    fi
    
    print_debug "URL validation passed: $url"
    return 0
}

select_script() {
    local mode="$1"
    
    case "$mode" in
        basic)
            echo "$BASIC_SCRIPT"
            ;;
        advanced)
            echo "$ADVANCED_SCRIPT"
            ;;
        stealth)
            echo "$STEALTH_SCRIPT"
            ;;
        *)
            print_error "Unknown mode: $mode"
            echo "Available modes: basic, advanced, stealth"
            return 1
            ;;
    esac
}

execute_clone() {
    local script_path="$1"
    shift
    local args="$@"
    
    if [ ! -f "$script_path" ]; then
        print_error "Script not found: $script_path"
        return 1
    fi
    
    if [ ! -x "$script_path" ]; then
        print_error "Script not executable: $script_path"
        return 1
    fi
    
    local cmd="\"$script_path\" $args"
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}${BOLD}DRY RUN MODE - Command that would be executed:${RESET}"
        echo -e "${CYAN}$cmd${RESET}"
        return 0
    fi
    
    print_step "Executing: $(basename "$script_path")"
    print_debug "Full command: $cmd"
    
    if [ "$VERBOSE" = true ]; then
        print_info "Script path: $script_path"
        print_info "Arguments: $args"
    fi
    
    # Execute the command
    eval "$cmd"
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_success "Cloning operation completed successfully!"
    else
        print_error "Cloning operation failed with exit code: $exit_code"
    fi
    
    return $exit_code
}

# Main execution logic
main() {
    local mode=""
    local url=""
    local clone_args=()
    local show_help_flag=false
    local show_version_flag=false
    local list_modes_flag=false
    local validate_flag=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help_flag=true
                shift
                ;;
            -v|--version)
                show_version_flag=true
                shift
                ;;
            --debug)
                DEBUG=true
                print_debug "Debug mode enabled"
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                print_debug "Dry run mode enabled"
                shift
                ;;
            --verbose)
                VERBOSE=true
                print_debug "Verbose mode enabled"
                shift
                ;;
            --list-modes)
                list_modes_flag=true
                shift
                ;;
            --validate)
                validate_flag=true
                shift
                ;;
            basic|advanced|stealth)
                if [ -n "$mode" ]; then
                    print_error "Multiple modes specified. Use only one mode."
                    return 1
                fi
                mode="$1"
                print_debug "Mode selected: $mode"
                shift
                ;;
            http://*|https://*)
                if [ -n "$url" ]; then
                    print_error "Multiple URLs specified. Use only one URL."
                    return 1
                fi
                url="$1"
                print_debug "URL detected: $url"
                shift
                ;;
            *)
                # Pass all other arguments to the clone script
                clone_args+=("$1")
                print_debug "Adding argument: $1"
                shift
                ;;
        esac
    done
    
    # Handle flags first
    if [ "$show_help_flag" = true ]; then
        show_help
        return 0
    fi
    
    if [ "$show_version_flag" = true ]; then
        show_version
        return 0
    fi
    
    if [ "$list_modes_flag" = true ]; then
        list_modes
        return 0
    fi
    
    if [ "$validate_flag" = true ]; then
        validate_system
        return $?
    fi
    
    # Validate system first
    if ! validate_system --quiet; then
        print_error "System validation failed. Run with --validate for details."
        return 1
    fi
    
    # Check if mode is provided
    if [ -z "$mode" ]; then
        print_error "No mode specified. Use: basic, advanced, or stealth"
        echo
        echo "Run '$(basename $0) --help' for usage information"
        return 1
    fi
    
    # Check if URL is provided
    if [ -z "$url" ]; then
        print_error "No URL specified"
        echo
        echo "Usage: $(basename $0) $mode <URL> [options]"
        return 1
    fi
    
    # Validate URL
    if ! validate_url "$url"; then
        return 1
    fi
    
    # Select appropriate script
    local script_path
    script_path=$(select_script "$mode")
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    print_debug "Selected script: $script_path"
    
    # Show execution banner
    if [ "$DRY_RUN" = false ]; then
        print_banner
        print_step "Mode: $(echo $mode | tr '[:lower:]' '[:upper:]')"
        print_step "Target: $url"
        print_step "Script: $(basename "$script_path")"
        echo
    fi
    
    # Execute the cloning operation
    execute_clone "$script_path" "$url" "${clone_args[@]}"
    
    return $?
}

# Execute main function with all arguments
main "$@"