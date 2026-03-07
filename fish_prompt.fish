function fish_prompt
    # Pick a random palette from your 5 fabric photos
    set -l rng (random 1 5)
    set -l p_char "❯" # The prompt symbol

    switch $rng
        case 1 # SPACE BLOBS (Pink/Cyan/Orange)
            set_color -o FF0066; echo -n (prompt_pwd)
            set_color -o 00FFCC; echo -n " $p_char "
            set_color -o FF9900

        case 2 # PSYCH PAISLEY (HotPink/SkyBlue/Gold)
            set_color -o FF69B4; echo -n (prompt_pwd)
            set_color -o 87CEEB; echo -n " $p_char "
            set_color -o FFD700

        case 3 # RETRO WAVY (Turquoise/Lime/Magenta)
            set_color -o 00CED1; echo -n (prompt_pwd)
            set_color -o ADFF2F; echo -n " $p_char "
            set_color -o FF00FF

        case 4 # SPLATTER (White/Cyan/Magenta)
            set_color -o FFFFFF; echo -n (prompt_pwd)
            set_color -o 00FFFF; echo -n " $p_char "
            set_color -o FF00FF

        case 5 # GOTHIC BATS (Indigo/NeonGreen)
            set_color -o 4B0082; echo -n (prompt_pwd)
            set_color -o 39FF14; echo -n " $p_char "
            set_color -o 9370DB
    end

    set_color normal
end
