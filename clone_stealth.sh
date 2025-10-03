#!/bin/bash

# Ultimate Website Cloning Script - Research Edition
# Enhanced with stealth features and research capabilities

show_help() {
    echo "🌐 Ultimate Website Cloning Tool - Research Edition"
    echo ""
    echo "Usage: /clone <url> [options]"
    echo ""
    echo "Basic Options:"
    echo "  -d, --depth <num>     Maximum recursion depth (default: infinite)"
    echo "  -f, --fast           Fast mode - only HTML, no images/css/js"
    echo "  -s, --single         Single page only"
    echo "  -o, --output <dir>   Custom output directory"
    echo ""
    echo "Stealth Options:"
    echo "  --stealth            Enable stealth mode (random delays, rotating UA)"
    echo "  --delay <sec>        Delay between requests (default: 0.5 in stealth)"
    echo "  --ua <string>        Custom User-Agent string"
    echo "  --proxy <url>        Use proxy (http://ip:port or socks5://ip:port)"
    echo ""
    echo "Research Options:"
    echo "  --js                 Clone JavaScript files and analyze"
    echo "  --source             Save page source and headers"
    echo "  --robots             Download and analyze robots.txt"
    echo "  --sitemap            Download sitemap.xml if available"
    echo "  --screenshots        Take screenshots (requires wkhtmltopdf)"
    echo ""
    echo "Output Options:"
    echo "  --report             Generate analysis report"
    echo "  --compress           Compress output to tar.gz"
    echo "  -q, --quiet          Quiet mode"
    echo "  -h, --help           Show this help"
    echo ""
    echo "Examples:"
    echo "  /clone https://example.com"
    echo "  /clone https://example.com --stealth --delay 2"
    echo "  /clone https://target.com --js --source --report"
    echo "  /clone https://site.com --proxy http://127.0.0.1:8080"
    echo ""
}

generate_user_agents() {
    local agents=(
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0"
    )
    echo "${agents[$((RANDOM % ${#agents[@]}))]}"
}

analyze_robots_txt() {
    local url="$1"
    local domain="$2"
    local robots_url="${url%/}/robots.txt"
    
    echo "🤖 Checking robots.txt..."
    if wget -q --spider "$robots_url" 2>/dev/null; then
        wget -q -O "robots.txt" "$robots_url"
        echo "✅ robots.txt downloaded"
        
        # Extract interesting paths
        if grep -q "Disallow:" robots.txt; then
            echo "🚫 Disallowed paths found:"
            grep "Disallow:" robots.txt | head -10
        fi
        
        if grep -q "Sitemap:" robots.txt; then
            echo "🗺️  Sitemap found:"
            grep "Sitemap:" robots.txt
        fi
    else
        echo "❌ No robots.txt found"
    fi
}

analyze_sitemap() {
    local url="$1"
    local sitemap_url="${url%/}/sitemap.xml"
    
    echo "🗺️  Checking sitemap.xml..."
    if wget -q --spider "$sitemap_url" 2>/dev/null; then
        wget -q -O "sitemap.xml" "$sitemap_url"
        echo "✅ sitemap.xml downloaded"
        
        # Count URLs in sitemap
        if command -v xmllint >/dev/null 2>&1; then
            url_count=$(xmllint --format sitemap.xml | grep -c "<loc>")
            echo "📊 URLs in sitemap: $url_count"
        fi
    else
        echo "❌ No sitemap.xml found"
    fi
}

generate_report() {
    local url="$1"
    local domain="$2"
    local report_file="analysis_report.md"
    
    echo "📋 Generating analysis report..."
    
    cat > "$report_file" << EOF
# Website Analysis Report

**Target**: $url  
**Domain**: $domain  
**Date**: $(date)  
**Analyst**: Research Tool v2.0

## Overview

EOF

    # File statistics
    if [ -d "." ]; then
        total_files=$(find . -type f | wc -l)
        total_size=$(du -sh . | cut -f1)
        html_files=$(find . -name "*.html" -o -name "*.htm" | wc -l)
        js_files=$(find . -name "*.js" | wc -l)
        css_files=$(find . -name "*.css" | wc -l)
        image_files=$(find . -name "*.jpg" -o -name "*.png" -o -name "*.gif" -o -name "*.svg" | wc -l)
        
        cat >> "$report_file" << EOF
- **Total Files**: $total_files
- **Total Size**: $total_size
- **HTML Files**: $html_files
- **JavaScript Files**: $js_files
- **CSS Files**: $css_files
- **Image Files**: $image_files

## File Structure

\`\`\`
$(find . -type f | head -20)
$([ $(find . -type f | wc -l) -gt 20 ] && echo "... and $((total_files - 20)) more files")
\`\`\`

EOF
    fi

    # Robots.txt analysis
    if [ -f "robots.txt" ]; then
        cat >> "$report_file" << EOF
## Robots.txt Analysis

\`\`\`
$(cat robots.txt)
\`\`\`

EOF
    fi

    # Technology detection
    if [ -f "index.html" ] || [ -f "index.htm" ]; then
        main_file=$([ -f "index.html" ] && echo "index.html" || echo "index.htm")
        
        cat >> "$report_file" << EOF
## Technology Detection

EOF
        
        # Check for common frameworks/technologies
        if grep -qi "jquery" "$main_file" 2>/dev/null; then
            echo "- jQuery detected" >> "$report_file"
        fi
        if grep -qi "bootstrap" "$main_file" 2>/dev/null; then
            echo "- Bootstrap detected" >> "$report_file"
        fi
        if grep -qi "angular" "$main_file" 2>/dev/null; then
            echo "- Angular detected" >> "$report_file"
        fi
        if grep -qi "react" "$main_file" 2>/dev/null; then
            echo "- React detected" >> "$report_file"
        fi
        if grep -qi "vue" "$main_file" 2>/dev/null; then
            echo "- Vue.js detected" >> "$report_file"
        fi
    fi

    echo "✅ Report generated: $(pwd)/$report_file"
}

clone_website() {
    local url=""
    local depth_limit=""
    local fast_mode=false
    local single_page=false
    local output_dir=""
    local stealth_mode=false
    local delay="0"
    local custom_ua=""
    local proxy=""
    local analyze_js=false
    local save_source=false
    local get_robots=false
    local get_sitemap=false
    local take_screenshots=false
    local generate_rep=false
    local compress_output=false
    local quiet_mode=false
    
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
            --stealth)
                stealth_mode=true
                delay="0.5"
                shift
                ;;
            --delay)
                delay="$2"
                shift 2
                ;;
            --ua)
                custom_ua="$2"
                shift 2
                ;;
            --proxy)
                proxy="$2"
                shift 2
                ;;
            --js)
                analyze_js=true
                shift
                ;;
            --source)
                save_source=true
                shift
                ;;
            --robots)
                get_robots=true
                shift
                ;;
            --sitemap)
                get_sitemap=true
                shift
                ;;
            --screenshots)
                take_screenshots=true
                shift
                ;;
            --report)
                generate_rep=true
                shift
                ;;
            --compress)
                compress_output=true
                shift
                ;;
            -q|--quiet)
                quiet_mode=true
                shift
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
        output_dir="cloned_sites/${domain}_$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Create directory for cloned site
    mkdir -p "$output_dir"
    cd "$output_dir"
    
    [ "$quiet_mode" = false ] && echo "🚀 Cloning website: $url"
    [ "$quiet_mode" = false ] && echo "📁 Saving to: $(pwd)"
    
    # Set User-Agent
    if [ "$stealth_mode" = true ]; then
        user_agent=$(generate_user_agents)
        [ "$quiet_mode" = false ] && echo "🥷 Stealth mode: Random UA and delays"
    elif [ -n "$custom_ua" ]; then
        user_agent="$custom_ua"
    else
        user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    fi
    
    # Build wget command
    wget_cmd="wget"
    
    # Basic options
    wget_cmd="$wget_cmd --user-agent=\"$user_agent\""
    wget_cmd="$wget_cmd --restrict-file-names=windows"
    wget_cmd="$wget_cmd --adjust-extension"
    wget_cmd="$wget_cmd --convert-links"
    
    # Add delay if specified
    if [ "$delay" != "0" ]; then
        wget_cmd="$wget_cmd --wait=$delay --random-wait"
    fi
    
    # Add proxy if specified
    if [ -n "$proxy" ]; then
        if [[ "$proxy" == socks5://* ]]; then
            # For SOCKS5, we need to use a different approach
            echo "⚠️  SOCKS5 proxy requires additional configuration"
        else
            wget_cmd="$wget_cmd --proxy=on --http-proxy=$proxy"
        fi
        [ "$quiet_mode" = false ] && echo "🔀 Using proxy: $proxy"
    fi
    
    # Set download mode
    if [ "$single_page" = true ]; then
        [ "$quiet_mode" = false ] && echo "📄 Single page mode"
        wget_cmd="$wget_cmd --page-requisites"
    elif [ "$fast_mode" = true ]; then
        [ "$quiet_mode" = false ] && echo "⚡ Fast mode - HTML only"
        wget_cmd="$wget_cmd --recursive --no-parent"
        wget_cmd="$wget_cmd --accept html,htm,php,asp,jsp"
        wget_cmd="$wget_cmd --domains $domain"
    else
        [ "$quiet_mode" = false ] && echo "🔄 Full recursive mode"
        wget_cmd="$wget_cmd --recursive --no-clobber --page-requisites"
        wget_cmd="$wget_cmd --html-extension --no-parent"
        wget_cmd="$wget_cmd --domains $domain"
        
        # Add JS files if requested
        if [ "$analyze_js" = true ]; then
            wget_cmd="$wget_cmd --accept-regex='.*\.(js|json)$'"
        fi
    fi
    
    # Add depth limit if specified
    if [ -n "$depth_limit" ]; then
        [ "$quiet_mode" = false ] && echo "📏 Depth limit: $depth_limit"
        wget_cmd="$wget_cmd --level=$depth_limit"
    fi
    
    # Add URL
    wget_cmd="$wget_cmd \"$url\""
    
    # Execute preliminary scans
    if [ "$get_robots" = true ]; then
        analyze_robots_txt "$url" "$domain"
    fi
    
    if [ "$get_sitemap" = true ]; then
        analyze_sitemap "$url"
    fi
    
    # Execute the main cloning command
    [ "$quiet_mode" = false ] && echo "🔧 Executing clone operation..."
    eval $wget_cmd
    
    if [ $? -eq 0 ]; then
        [ "$quiet_mode" = false ] && echo "✅ Website cloned successfully!"
        [ "$quiet_mode" = false ] && echo "📍 Location: $(pwd)"
        
        # Try to find and display the main index file
        if [ -f "index.html" ]; then
            [ "$quiet_mode" = false ] && echo "🔗 Main file: $(pwd)/index.html"
        else
            # Look for index files in subdirectories
            index_file=$(find . -name "index.html" -o -name "index.htm" | head -1)
            if [ -n "$index_file" ]; then
                [ "$quiet_mode" = false ] && echo "🔗 Main file: $(pwd)/$index_file"
            fi
        fi
        
        # Show directory size
        size=$(du -sh . | cut -f1)
        [ "$quiet_mode" = false ] && echo "💾 Total size: $size"
        
        # Count files
        file_count=$(find . -type f | wc -l)
        [ "$quiet_mode" = false ] && echo "📊 Files downloaded: $file_count"
        
        # Generate analysis report
        if [ "$generate_rep" = true ]; then
            generate_report "$url" "$domain"
        fi
        
        # Compress output if requested
        if [ "$compress_output" = true ]; then
            cd ..
            tar_name="${domain}_$(date +%Y%m%d_%H%M%S).tar.gz"
            tar -czf "$tar_name" "$(basename "$output_dir")"
            [ "$quiet_mode" = false ] && echo "📦 Compressed to: $(pwd)/$tar_name"
            cd - > /dev/null
        fi
        
    else
        echo "❌ Failed to clone website"
        cd ..
        rmdir "$(basename "$output_dir")" 2>/dev/null
    fi
    
    cd - > /dev/null
}

# If script is called directly
clone_website "$@"