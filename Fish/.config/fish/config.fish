set -gx BUNDLE_PATH ~/.local/share/gems
set -gx EDITOR emacs
alias rm="rm -I"
alias lt="ls -t"
alias ffmpreg="ffmpeg"
alias minmacs="emacs -q -nw"
if status is-interactive
    # Commands to run in interactive sessions can go here
end
