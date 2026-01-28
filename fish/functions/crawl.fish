function crawl
    echo "🕷️  Starting Deep Index Crawler (Ignoring Permission Errors)..."
    
    set output_file "MASTER_INDEX.md"
    
    echo "# Device Master Index" > $output_file
    echo "Generated on: "(date) >> $output_file
    echo "Scope: Recursive scan (Newest 50 Files)" >> $output_file
    echo "" >> $output_file

    echo "🔍 Scanning for files..."
    
    # THE FIX: '2>/dev/null' silences the "Permission denied" errors so it doesn't stop.
    set files (find . -type f -not -path '*/.*' -not -path './node_modules*' -printf "%T@ %p\n" 2>/dev/null | sort -nr | cut -d' ' -f2- | head -n 50)

    set context_file "temp_crawl_data.txt"
    echo "START_OF_MANIFEST" > $context_file
    
    for f in $files
        echo "--------------------------------------------------" >> $context_file
        echo "FILE: $f" >> $context_file
        echo "LAST_MODIFIED: "(date -r $f "+%Y-%m-%d") >> $context_file
        echo "--- START OF FIRST 10 LINES ---" >> $context_file
        
        # Read first 10 lines. If a specific file is unreadable, ignore error.
        head -n 10 "$f" 2>/dev/null >> $context_file
        
        echo "--- END OF FIRST 10 LINES ---" >> $context_file
        echo "" >> $context_file
    end
    
    echo "END_OF_MANIFEST" >> $context_file

    echo "🧠 Sending data to Gemini..."
    
    gemini "I have provided a file manifest below. For each file, I have included the first 10 lines.
    
    TASK: Create a Markdown Table with these columns:
    1. **Date** (From the manifest)
    2. **File Name** (The path)
    3. **First 10-Line Summary** (Read the snippet. Write a blunt 1-sentence summary of what this file does.)
    4. **AI Instructions** ('YES' if snippet contains system prompts/rules, else 'No'.)

    DATA:
    "(cat $context_file) >> $output_file

    rm $context_file
    echo "✅ Index complete! Saved to: $output_file"
end
