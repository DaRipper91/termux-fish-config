function daily_report
    set bat_level (termux-battery-status | jq -r .percentage)
    set clip_content (termux-clipboard-get)

    echo "Analysis Start..."
    g "My battery is at $bat_level%. My clipboard contains: '$clip_content'. Give me a ruthless critique of my clipboard content and suggest one task based on my battery level."
end
