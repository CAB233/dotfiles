function _host
    if set -q SSH_CONNECTION
        echo -n (set_color --bold yellow)"(ssh)"
        if functions -q fish_is_root_user; and fish_is_root_user
            set_color --bold red
        else
            set_color --bold green
        end
        echo -n -s (prompt_login)' '
    end
end

function _dir_status
    echo -n -s (set_color --bold cyan)(prompt_pwd)' '
end

function _git_status
    if [ "$GIT_BRANCH" ]
        set branch "$GIT_BRANCH"
        echo -n -s (set_color normal)"[ " (set_color --bold magenta)$branch (set_color normal)" ] "
    end
end

function fish_prompt
    set -l last_status $status
    set -lx fish_prompt_pwd_dir_length 0
    set -gx GIT_BRANCH (git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')

    echo
    echo -n -s (_host) (_dir_status) (_git_status)
    echo
    if test $last_status -eq 0
        echo -n (set_color green)'❯ '
    else
        echo -n (set_color red)'❯ '
    end
    set_color normal
end
