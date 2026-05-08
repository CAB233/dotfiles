function _ssh
    if __is_ssh
        echo -n -s (set_color --bold yellow)"(ssh)"
    end
end

function _login
    if not __is_ssh
        return
    end

    if fish_is_root_user
        set_color --bold red
    else
        set_color --bold green
    end
    echo -n -s (prompt_login)' '
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
    echo -n -s (set_color normal)"[ " (set_color --bold magenta)$branch (set_color normal)" ] "
end

function fish_prompt
    set --local last_status $status
    set --local --export fish_prompt_pwd_dir_length 0

    echo
    echo -n -s (_ssh) (_login) (_dir_status) (_git_branch)
    echo
    if test $last_status -eq 0
        echo -n (set_color green)'❯ '
    else
        echo -n (set_color red)'❯ '
    end
    set_color normal
end
