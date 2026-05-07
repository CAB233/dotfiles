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
    echo -n -s (set_color --bold cyan)(prompt_pwd)
end

function _git_status
    if [ "$GIT_BRANCH" ]
        set branch "$GIT_BRANCH"
        echo -n -s (set_color normal)" [ " (set_color --bold magenta)$branch (set_color normal)" ] "
    end

    set -l git_status (git status --porcelain 2>/dev/null)
    if test -n "$git_status"
        set -l conflicted_count 0
        set -l untracked_count 0
        set -l modified_count 0
        set -l renamed_count 0
        set -l deleted_count 0
        set -l ahead (git rev-list --count @{upstream}..HEAD 2>/dev/null)
        set -l behind (git rev-list --count HEAD..@{upstream} 2>/dev/null)

        for line in $git_status
            if string match -rq '^UU|^AA|^DD' -- $line
                set conflicted_count (math $conflicted_count + 1)
            end
            if string match -rq '^\?\?' -- $line
                set untracked_count (math $untracked_count + 1)
            end
            if string match -rq '^R' -- $line
                set renamed_count (math $renamed_count + 1)
            end
            if string match -rq '^ D|^D ' -- $line
                set deleted_count (math $deleted_count + 1)
            end
            if string match -rq '^ M|^M ' -- $line
                set modified_count (math $modified_count + 1)
            end
        end

        if test $conflicted_count -gt 0
            echo -n (set_color red)"≄ $conflicted_count "
        end
        if test $untracked_count -gt 0
            echo -n (set_color green)" $untracked_count "
        end
        if test $renamed_count -gt 0
            echo -n (set_color yellow)" $renamed_count "
        end
        if test $modified_count -gt 0
            echo -n (set_color yellow)" $modified_count "
        end
        if test $deleted_count -gt 0
            echo -n (set_color red)" $deleted_count "
        end
        if test "$ahead" -gt 0
            echo -n (set_color blue)" $ahead "
        end
        if test "$behind" -gt 0
            echo -n (set_color blue)" $behind "
        end
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
