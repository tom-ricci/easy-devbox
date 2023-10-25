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
echo "Your environment will be set-up to create simple, reproducible development environments."
sleep 2;
echo "This script assumes you DO NOT have devbox nor direnv installed. Nix may or may not be installed, the script handles that nicely :)"
sleep 2;
echo "This script also provides direnv with the ability to evaluate all .envrc files inside ~/Documents/**/ immediately. THIS IS A SECURITY RISK! Make sure you trust everything you may store in that folder now and in the future!"
sleep 3;
echo "Press any key to begin, or Ctrl+C to exit."
read GO;
echo "Installing direnv...";
sudo apt-get install direnv;
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc;
mkdir -p ~/.config/direnv/direnv;
touch ~/.config/direnv/direnv.toml;
echo "[whitelist]" >> ~/.config/direnv/direnv.toml;
echo -e 'prefix = [ "$HOME/Documents" ]' >> ~/.config/direnv/direnv.toml;
bash
echo "Installing devbox..."
curl -fsSL https://get.jetpack.io/devbox | bash
echo "Everything installed!"
echo "Use 'devbox generate direnv' in an empty directory to generate a new project."
echo "Use 'devbox generate direnv' in an existing project's directory to import it."
