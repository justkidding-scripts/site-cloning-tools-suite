#!/bin/bash

# Clone Tool Manager - Switch between different cloning tools

show_help() {
    echo "🛠️  Clone Tool Manager"
    echo ""
    echo "Usage: /clone-manager [command]"
    echo ""
    echo "Commands:"
    echo "  basic        Use basic cloning script"
    echo "  advanced     Use advanced cloning script"
    echo "  stealth      Use stealth/research cloning script"
    echo "  status       Show current active version"
    echo "  help         Show this help"
    echo ""
    echo "Current versions available:"
    echo "  📄 Basic: /home/kali/Desktop/clone_website.sh"
    echo "  🔧 Advanced: /home/kali/Desktop/clone_advanced.sh"
    echo "  🥷 Stealth: /home/kali/Desktop/clone_stealth.sh"
    echo ""
}

update_alias() {
    local script_path="$1"
    local version_name="$2"
    
    # Update the alias in .zshrc
    sed -i "s|alias /clone=\".*\"|alias /clone=\"$script_path\"|" ~/.zshrc
    
    # Source the updated configuration
    source ~/.zshrc
    
    echo "✅ Switched to $version_name version"
    echo "🔗 Active script: $script_path"
    echo ""
    echo "Test with: /clone --help"
}

show_status() {
    echo "🔍 Current /clone alias status:"
    alias /clone 2>/dev/null || echo "❌ /clone alias not found"
    echo ""
    
    echo "📊 Available scripts:"
    [ -x "/home/kali/Desktop/clone_website.sh" ] && echo "✅ Basic version available" || echo "❌ Basic version missing"
    [ -x "/home/kali/Desktop/clone_advanced.sh" ] && echo "✅ Advanced version available" || echo "❌ Advanced version missing"
    [ -x "/home/kali/Desktop/clone_stealth.sh" ] && echo "✅ Stealth version available" || echo "❌ Stealth version missing"
}

case "$1" in
    basic)
        update_alias "/home/kali/Desktop/clone_website.sh" "basic"
        ;;
    advanced)
        update_alias "/home/kali/Desktop/clone_advanced.sh" "advanced"
        ;;
    stealth)
        update_alias "/home/kali/Desktop/clone_stealth.sh" "stealth"
        ;;
    status)
        show_status
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo "Use '/clone-manager help' for usage information"
        exit 1
        ;;
esac