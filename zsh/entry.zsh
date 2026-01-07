ZSH_CONFIG_DIR="${0:a:h}"

fpath=("$ZSH_CONFIG_DIR/zsh_custom/completions" $fpath)

for config_file in "$ZSH_CONFIG_DIR"/zsh_custom/*.zsh; do
    [[ "$config_file" != *".old"* ]] && source "$config_file"
done
unset config_file

source "$ZSH_CONFIG_DIR/zsh_custom/plugins/zsh-ssh/zsh-ssh.zsh"
