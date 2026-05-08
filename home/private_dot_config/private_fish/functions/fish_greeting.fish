# ~/.config/fish/functions/fish_greeting.fish
# https://fishshell.com/docs/current/cmds/fish_greeting.html

function fish_greeting
    if command --query fastfetch; and __is_ssh
        fastfetch
    end
end
