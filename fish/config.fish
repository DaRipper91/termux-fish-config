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
function gswitch
    set config ~/.gemini/settings.json
    set current (jq -r '.model.name // .model' $config)

    # Logic: Toggle between Gemini 3 Flash and Gemini 3 Pro
    if string match -q "gemini-3-flash-preview" $current
        set new_model "gemini-3-pro-preview"
        set mode_name "🧠 GEMINI 3 PRO (Maximum Intelligence)"
    else
        set new_model "gemini-3-flash-preview"
        set mode_name "⚡ GEMINI 3 FLASH (Speed & Logic)"
    end
    
    # Write safely to JSON
    jq --arg nm "$new_model" '.model = { "name": $nm }' $config > $config.tmp && mv $config.tmp $config
    
    echo -e "Gemini CLI switched to: $mode_name"
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


