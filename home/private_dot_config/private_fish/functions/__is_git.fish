# https://github.com/adamchristiansen/vertical-fish/blob/main/functions/__vertical_util_is_git.fish
function __is_git
    if not type -q git
        return 1
    end
    command git rev-parse --git-dir >/dev/null 2>/dev/null
end
