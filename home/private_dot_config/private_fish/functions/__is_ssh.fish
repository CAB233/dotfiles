# https://github.com/adamchristiansen/vertical-fish/blob/main/functions/__vertical_util_is_ssh.fish
function __is_ssh
    set --query SSH_CLIENT || set --query SSH_CONNECTION || set --query SSH_TTY
end
