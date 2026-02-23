# 环境变量
# https://fishshell.com/docs/current/faq#how-do-i-set-or-clear-an-environment-variable

functions --query x # alias already defined
or alias x 'set --global --export'

# Real home directory
if set --query HOME_FAKE # set by ~/.local/bin/fakehome
    set --local user (fallback $SUDO_USER $USER)
    # https://man.archlinux.org/man/getent.1
    # https://man.archlinux.org/man/passwd.5
    set --local home (string split : (getent passwd $user) --fields 6)
    if string length --quiet $home
        x HOME $home
        set --erase HOME_FAKE
    end
end

# Prepend user executables search path (only once when login)
# https://fishshell.com/docs/current/cmds/status?highlight=is-login
# https://fishshell.com/docs/current/cmds/fish_add_path
# https://www.freedesktop.org/software/systemd/man/file-hierarchy#~/.local/bin/
status is-login
and fish_add_path $HOME/.local/bin

# XDG base directory
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest#variables
x XDG_CACHE_HOME  $HOME/.cache
x XDG_CONFIG_HOME $HOME/.config
x XDG_DATA_HOME   $HOME/.local/share
x XDG_STATE_HOME  $HOME/.local/state

# Workarounds for XDG base directory
# https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
x CARGO_HOME                $XDG_DATA_HOME/cargo
x DOTNET_CLI_HOME           $XDG_DATA_HOME/dotnet
x GNUPGHOME                 $XDG_DATA_HOME/gnupg
x GOPATH                    $XDG_DATA_HOME/go
x HISTFILE                  $XDG_STATE_HOME/bash/history
x LESSHISTFILE              $XDG_DATA_HOME/less/history
x NPM_CONFIG_USERCONFIG     $XDG_CONFIG_HOME/npm/npmrc
x WGETRC                    $XDG_CONFIG_HOME/wgetrc
x PYTHON_HISTORY            $XDG_STATE_HOME/python/history
x WINEPREFIX                $XDG_DATA_HOME/wineprefixes/default
x _JAVA_OPTIONS             -Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java
x WINEPREFIX                $XDG_DATA_HOME/wineprefixes/default
x PARALLEL_HOME             $XDG_CONFIG_HOME/parallel

# Terminal
x TERM xterm-256color
x COLORTERM truecolor

# Use helix as default text editor
x EDITOR micro
x VISUAL micro

# https://github.com/zyedidia/micro/blob/master/runtime/help/colors.md#colorschemes
x MICRO_TRUECOLOR 1

# Input method module
# https://wiki.archlinux.org/title/Fcitx5#Integration
x XMODIFIERS @im=fcitx

# https://github.com/danhper/fish-ssh-agent/blob/f10d95775352931796fd17f54e6bf2f910163d1b/conf.d/fish-ssh-agent.fish#L2C20-L2C20
x SSH_ENV $HOME/.ssh/environment

# https://wiki.archlinux.org/title/GnuPG#Configure_pinentry_to_use_the_correct_TTY
x GPG_TTY (tty)

# https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications#Consistent_file_dialog
x GTK_USE_PORTAL 1
