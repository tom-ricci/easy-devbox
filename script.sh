#!/usr/bin/env bash
set -euo pipefail

echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗";
echo "║                                                                                                                                                              ║";
echo "║                                                                                                                                                              ║";
echo "║          ___           ___           ___           ___                    ___           ___           ___           ___           ___           ___          ║";
echo "║         /\  \         /\  \         /\  \         |\__\                  /\  \         /\  \         /\__\         /\  \         /\  \         |\__\         ║";
echo "║        /::\  \       /::\  \       /::\  \        |:|  |                /::\  \       /::\  \       /:/  /        /::\  \       /::\  \        |:|  |        ║";
echo "║       /:/\:\  \     /:/\:\  \     /:/\ \  \       |:|  |               /:/\:\  \     /:/\:\  \     /:/  /        /:/\:\  \     /:/\:\  \       |:|  |        ║";
echo "║      /::\~\:\  \   /::\~\:\  \   _\:\~\ \  \      |:|__|__            /:/  \:\__\   /::\~\:\  \   /:/__/  ___   /::\~\:\__\   /:/  \:\  \      |:|__|__      ║";
echo "║     /:/\:\ \:\__\ /:/\:\ \:\__\ /\ \:\ \ \__\     /::::\__\          /:/__/ \:|__| /:/\:\ \:\__\  |:|  | /\__\ /:/\:\ \:|__| /:/__/ \:\__\ ____/::::\__\     ║";
echo "║     \:\~\:\ \/__/ \/__\:\/:/  / \:\ \:\ \/__/    /:/~~/~             \:\  \ /:/  / \:\~\:\ \/__/  |:|  |/:/  / \:\~\:\/:/  / \:\  \ /:/  / \::::/~~/~        ║";
echo "║      \:\ \:\__\        \::/  /   \:\ \:\__\     /:/  /                \:\  /:/  /   \:\ \:\__\    |:|__/:/  /   \:\ \::/  /   \:\  /:/  /   ~~|:|~~|         ║";
echo "║       \:\ \/__/        /:/  /     \:\/:/  /     \/__/                  \:\/:/  /     \:\ \/__/     \::::/__/     \:\/:/  /     \:\/:/  /      |:|  |         ║";
echo "║        \:\__\         /:/  /       \::/  /                              \::/__/       \:\__\        ~~~~          \::/__/       \::/  /       |:|  |         ║";
echo "║         \/__/         \/__/         \/__/                                ~~            \/__/                       ~~            \/__/         \|__|         ║";
echo "║                                                                                                                                                              ║";
echo "║                                                                                                                                                              ║";
echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝";
echo "";
sleep 1;
echo "Welcome to easy-devbox!";
sleep 1;
echo "Your environment will be set-up to create simple, reproducible development environments.";
sleep 2;
echo "This script assumes you DO NOT have devbox nor direnv installed. Nix may or may not be installed, the script handles that nicely :)";
sleep 2;
echo "Choose your shell to begin, or Ctrl+C to exit.";
path_setup='export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"'
PS3="Shell (1-8): "
select user_shell in Bash Zsh Fish Tcsh Elvish Nushell PowerShell Murex; do
  case "$user_shell" in
    Bash)
      # Bash login shells read a profile instead of .bashrc.
      login_profile="$HOME/.bash_profile"
      for profile in "$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.profile"; do
        if [ -f "$profile" ]; then
          login_profile=$profile
          break
        fi
      done
      shell_configs=("$HOME/.bashrc" "$login_profile")
      hook='if [ -n "${BASH_VERSION:-}" ]; then eval "$(direnv hook bash)"; fi'
      ;;
    Zsh)
      shell_configs=("${ZDOTDIR:-$HOME}/.zshrc")
      hook='eval "$(direnv hook zsh)"'
      ;;
    Fish)
      shell_configs=("${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish")
      path_setup='fish_add_path --path "$HOME/.local/bin" /usr/local/bin'
      hook='direnv hook fish | source'
      ;;
    Tcsh)
      shell_config="$HOME/.cshrc"
      [ ! -f "$HOME/.tcshrc" ] || shell_config="$HOME/.tcshrc"
      shell_configs=("$shell_config")
      path_setup='set path = ( "$HOME/.local/bin" /usr/local/bin $path )'
      hook='eval `direnv hook tcsh`'
      ;;
    Elvish)
      shell_configs=("${XDG_CONFIG_HOME:-$HOME/.config}/elvish/rc.elv")
      path_setup='set paths = [$E:HOME/.local/bin /usr/local/bin $@paths]'
      hook='eval (direnv hook elvish | slurp)'
      ;;
    Nushell)
      shell_config=$(nu --no-config-file -c '$nu.config-path')
      shell_configs=("$shell_config")
      path_setup='$env.PATH = ($env.PATH | prepend [($env.HOME | path join .local bin) /usr/local/bin])'
      # Nushell uses direnv's JSON export instead of a generated shell hook.
      hook=$(cat <<'NU'
$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | append {||
  let changes = (direnv export json | from json | default {})
  for change in ($changes | transpose name value) {
    if $change.value == null {
      hide-env --ignore-errors $change.name
    } else {
      let value = if $change.name == 'PATH' {
        $change.value | split row (char esep)
      } else { $change.value }
      load-env {($change.name): $value}
    }
  }
})
NU
)
      ;;
    PowerShell)
      shell_config=$(pwsh -NoLogo -NoProfile -NonInteractive -Command '$PROFILE.CurrentUserAllHosts')
      shell_configs=("$shell_config")
      path_setup='$env:PATH = "$HOME/.local/bin:/usr/local/bin:$env:PATH"'
      hook='direnv hook pwsh | Out-String | Invoke-Expression'
      ;;
    Murex)
      shell_config="$HOME/.murex_profile"
      [ -z "${MUREX_CONFIG_DIR:-}" ] || shell_config="$MUREX_CONFIG_DIR/profile"
      shell_config="${MUREX_PROFILE:-$shell_config}"
      [ ! -d "$shell_config" ] || shell_config="$shell_config/.murex_profile"
      shell_configs=("$shell_config")
      hook='direnv hook murex -> source'
      ;;
    *) echo "Please enter a number from 1 to 8."; continue ;;
  esac
  break
done </dev/tty
[ -n "${user_shell:-}" ] || exit 1

echo "Installing...";
mkdir -p "$HOME/.local/bin";
curl -fsSL https://direnv.net/install.sh | bin_path="$HOME/.local/bin" bash;
curl -fsSL https://get.jetify.com/devbox | bash;

# Append one block per startup file. The marker makes repeat runs harmless.
for shell_config in "${shell_configs[@]}"; do
  mkdir -p "$(dirname "$shell_config")"
  if ! grep -Fqx '# easy-devbox' "$shell_config" 2>/dev/null; then
    cat >> "$shell_config" <<EOF

# easy-devbox
$path_setup
$hook
EOF
  fi
done

echo "Everything installed!";
echo "Restart your shell to activate direnv.";
echo "Use 'devbox generate direnv' in an empty directory to generate a new project.";
echo "Use 'devbox generate direnv' in an existing project's directory to import it.";
