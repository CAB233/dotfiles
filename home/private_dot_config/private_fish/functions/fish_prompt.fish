function _login
    if not __is_ssh
        return
    end

    set --local ssh_color (set_color --bold yellow)
    set --local at_color (set_color --bold white)
    set --local host_color (set_color --reset white)
    if fish_is_root_user
        set user_color (set_color --bold red)
    else
        set user_color (set_color --bold green)
    end

    echo -n -s "$ssh_color(ssh)" "$user_color$USER" "$at_color@" "$host_color$hostname" ' '
end

function _dir_status
    echo -n -s (set_color --bold cyan)(prompt_pwd)' '
end

function _git_branch
    if not __is_git
        return
    end

    set --local branch (command git describe --tags --exact-match 2> /dev/null \
        || command git symbolic-ref -q --short HEAD \
        || command git rev-parse --short HEAD)
    set --local git_status (command git status --porcelain 2>/dev/null)
    set --local has_untracked (string match -r '^\?\?' $git_status | count)
    set --local has_staged (string match -r '^[ MADRC]' $git_status | count)

    if test -z "$git_status"
        set status_color green
    else if test $has_untracked -gt 0 -a $has_staged -eq 0
        set status_color magenta
    else
        set status_color red
    end

    echo -n -s (set_color white)"[ " (set_color --bold $status_color)$branch (set_color white)" ] "
end

function fish_prompt
    set --local last_status $status
    set --local --export fish_prompt_pwd_dir_length 0

    echo
    echo -n -s (_login) (_dir_status) (_git_branch)
    echo
    if test $last_status -eq 0
        echo -n (set_color green)'❯ '
    else
        echo -n (set_color red)'❯ '
    end
    set_color normal
end
