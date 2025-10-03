#!/bin/bash

# Website Cloning Script
# Usage: /clone <url>

clone_website() {
    local url="$1"
    
    # Check if URL is provided
    if [ -z "$url" ]; then
        echo "Usage: /clone <url>"
        echo "Example: /clone https://example.com"
        return 1
    fi
    
    # Extract domain name for directory
    domain=$(echo "$url" | sed 's|https\?://||' | sed 's|www\.||' | cut -d'/' -f1)
    
    # Create directory for cloned site
    mkdir -p "cloned_sites/$domain"
    cd "cloned_sites/$domain"
    
    echo "🚀 Cloning website: $url"
    echo "📁 Saving to: $(pwd)"
    
    # Use wget to clone the website
    wget \
        --recursive \
        --no-clobber \
        --page-requisites \
        --html-extension \
        --convert-links \
        --restrict-file-names=windows \
        --domains "$domain" \
        --no-parent \
        --adjust-extension \
        --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
        "$url"
    
    if [ $? -eq 0 ]; then
        echo "✅ Website cloned successfully!"
        echo "📍 Location: $(pwd)"
        echo "🌐 Open index.html to view the cloned site"
        
        # Try to find and display the main index file
        if [ -f "index.html" ]; then
            echo "🔗 Main file: $(pwd)/index.html"
        else
            # Look for index files in subdirectories
            index_file=$(find . -name "index.html" | head -1)
            if [ -n "$index_file" ]; then
                echo "🔗 Main file: $(pwd)/$index_file"
            fi
        fi
    else
        echo "❌ Failed to clone website"
        cd ..
        rmdir "$domain" 2>/dev/null
    fi
    
    cd - > /dev/null
}

# If script is called directly
if [ "$#" -eq 0 ]; then
    echo "Usage: /clone <url>"
    echo "Example: /clone https://example.com"
    exit 1
else
    clone_website "$@"
fi
