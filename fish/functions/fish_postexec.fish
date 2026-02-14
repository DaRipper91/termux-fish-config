function fish_postexec
    # Check if the last command failed (status code not 0)
    if test $status -ne 0
        echo
        set -l gemi_red FF0000
        
        # An industrial "shrapnel" burst - simplified to just the error message
        set_color -o $gemi_red
        echo " [!] SYSTEM_ERROR: EXECUTION_FAILURE"
        
        set_color normal
        echo " [?] Verify syntax or permissions, Cody. This is a mess."
        echo
    end
end
