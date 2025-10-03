#!/bin/bash

# Enhanced Website Cloning Script
# Usage: /clone <url> [options]

show_help() {
    echo "🌐 Website Cloning Tool"
    echo ""
    echo "Usage: /clone <url> [options]"
    echo ""
    echo "Options:"
    echo "  -d, --depth <num>     Maximum recursion depth (default: infinite)"
    echo "  -f, --fast           Fast mode - only HTML, no images/css/js"
    echo "  -s, --single         Single page only"
    echo "  -o, --output <dir>   Custom output directory"
    echo "  -h, --help           Show this help"
    echo ""
    echo "Examples:"
    echo "  /clone https://example.com"
    echo "  /clone https://example.com -d 2"
    echo "  /clone https://example.com --fast"
    echo "  /clone https://example.com -o /tmp/cloned"
    echo ""
}

clone_website() {
    local url=""
    local depth_limit=""
    local fast_mode=false
    local single_page=false
    local output_dir=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                return 0
                ;;
            -d|--depth)
                depth_limit="$2"
                shift 2
                ;;
            -f|--fast)
                fast_mode=true
                shift
                ;;
            -s|--single)
                single_page=true
                shift
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -*)
                echo "❌ Unknown option: $1"
                echo "Use /clone --help for usage information"
                return 1
                ;;
            *)
                if [ -z "$url" ]; then
                    url="$1"
                else
                    echo "❌ Multiple URLs not supported"
                    return 1
                fi
                shift
                ;;
        esac
    done
    
    # Check if URL is provided
    if [ -z "$url" ]; then
        show_help
        return 1
    fi
    
    # Extract domain name for directory
    domain=$(echo "$url" | sed 's|https\?://||' | sed 's|www\.||' | cut -d'/' -f1)
    
    # Set output directory
    if [ -z "$output_dir" ]; then
        output_dir="cloned_sites/$domain"
    fi
    
    # Create directory for cloned site
    mkdir -p "$output_dir"
    cd "$output_dir"
    
    echo "🚀 Cloning website: $url"
    echo "📁 Saving to: $(pwd)"
    
    # Build wget command
    wget_cmd="wget"
    
    # Basic options
    wget_cmd="$wget_cmd --user-agent=\"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36\""
    wget_cmd="$wget_cmd --restrict-file-names=windows"
    wget_cmd="$wget_cmd --adjust-extension"
    wget_cmd="$wget_cmd --convert-links"
    
    if [ "$single_page" = true ]; then
        echo "📄 Single page mode"
        wget_cmd="$wget_cmd --page-requisites"
    elif [ "$fast_mode" = true ]; then
        echo "⚡ Fast mode - HTML only"
        wget_cmd="$wget_cmd --recursive --no-parent"
        wget_cmd="$wget_cmd --accept html,htm,php,asp,jsp"
        wget_cmd="$wget_cmd --domains $domain"
    else
        echo "🔄 Full recursive mode"
        wget_cmd="$wget_cmd --recursive --no-clobber --page-requisites"
        wget_cmd="$wget_cmd --html-extension --no-parent"
        wget_cmd="$wget_cmd --domains $domain"
    fi
    
    # Add depth limit if specified
    if [ -n "$depth_limit" ]; then
        echo "📏 Depth limit: $depth_limit"
        wget_cmd="$wget_cmd --level=$depth_limit"
    fi
    
    # Add URL
    wget_cmd="$wget_cmd \"$url\""
    
    # Execute the command
    echo "🔧 Running: $wget_cmd"
    eval $wget_cmd
    
    if [ $? -eq 0 ]; then
        echo "✅ Website cloned successfully!"
        echo "📍 Location: $(pwd)"
        
        # Try to find and display the main index file
        if [ -f "index.html" ]; then
            echo "🔗 Main file: $(pwd)/index.html"
        else
            # Look for index files in subdirectories
            index_file=$(find . -name "index.html" -o -name "index.htm" | head -1)
            if [ -n "$index_file" ]; then
                echo "🔗 Main file: $(pwd)/$index_file"
            fi
        fi
        
        # Show directory size
        size=$(du -sh . | cut -f1)
        echo "💾 Total size: $size"
        
        # Count files
        file_count=$(find . -type f | wc -l)
        echo "📊 Files downloaded: $file_count"
        
    else
        echo "❌ Failed to clone website"
        cd ..
        rmdir "$(basename "$output_dir")" 2>/dev/null
    fi
    
    cd - > /dev/null
}

# If script is called directly
clone_website "$@"