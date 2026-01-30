# Deanna Fabric File Colors
# Directories: Neon Pink (Space)
# Symlinks: Cyan (Space)
# Executables/Scripts: Toxic Green (Bats)
# Archives/Zips: Deep Orange (Space)
# Images: Sky Blue (Paisley)
set -x LS_COLORS "di=01;38;2;255;0;102:ln=01;38;2;0;255;204:ex=01;38;2;57;255;20:*.zip=01;38;2;255;153;0:*.jpg=01;38;2;135;206;235:*.png=01;38;2;135;206;235"

# Google_API
set -gx GOOGLE_API_KEY "AIzaSyBT40zUR-cBMLDCCdcifXzIsdZ6wij3S0g"

# Starship Prompt
starship init fish | source

# Gemini Model Switch
   # Updated gswitch for Termux / CachyOS
function gswitch
    set -l settings_file "$HOME/.gemini/settings.json"

    # Ensure jq is installed
    if not command -v jq >/dev/null
        echo "Error: jq is not installed."
        return 1
    end

    # Extract current model name with a fallback
    set -l current_model (jq -r '.name // empty' $settings_file)

    # Multi-model cycle logic
    switch "$current_model"
        case "gemini-3-flash-preview"
            set next_model "gemini-3-pro-preview"
            set color green
            set msg " 🧠 GEMINI 3 PRO (Maximum Intelligence)"
        case "gemini-3-pro-preview"
            set next_model "gemini-1.5-pro-preview"
            set color magenta
            set msg " GEMINI 1.5 PRO (Large Context)"
        case "gemini-1.5-pro-preview"
            set next_model "gemini-2.0-flash"
            set color blue
            set msg " GEMINI 2.0 FLASH (Balanced)"
        case "gemini-2.0-flash"
            set next_model "gemini-2.0-flash-thinking-exp-01-21"
            set color yellow
            set msg "🤔 GEMINI 2.0 THINKING (Deep Logic)"
        case "*"
            set next_model "gemini-3-flash-preview"
            set color cyan
            set msg " GEMINI 3 FLASH (Speed & Logic)"
    end

    # Write safely to JSON
    jq --arg nm "$next_model" '.name = $nm' $settings_file > $settings_file.tmp && mv $settings_file.tmp $settings_file
    
    # Output status
    set_color $color
    echo "Switched to: $msg"
    set_color normal
end

# Google Drive rclone Pull and Push
function gpull
    echo "⬇️ Syncing Drive (Skipping: Videos & linux-tkg)..."
    
    # We sync from root (gdrive:) to local (~/drive)
    # The --exclude flags tell rclone what to IGNORE.
    # Everything else (AI, Scripts, Manuals) will download.
    
    rclone copy gdrive: ~/drive \
        --exclude "Videos From Backups/**" \
        --exclude "linux-tkg/**" \
        --update -P
        
    echo "✅ Sync Complete."
end

# Force gemini-cli to run without waiting for manual input
function gemini-non-int
    set -l prompt $argv
    echo "$prompt" | gemini-cli --quiet
end
