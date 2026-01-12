function update_completions_and_inits() {
    (zoxide init zsh > ~/.config/zsh/source/zoxide.zsh) || echo "Failed to update zoxide init"
    (starship init zsh > ~/.config/zsh/source/starship_prompt.zsh) || echo "Failed to update starship init"

    (rustup completions zsh rustup > ~/.config/zsh/my_fpath/_rustup) || echo "Failed to update rustup shell completions"
    (rustup completions zsh cargo > ~/.config/zsh/my_fpath/_cargo) || echo "Failed to update cargo shell completions"
}
