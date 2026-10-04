# easy-devbox

`easy-devbox` installs devbox and direnv on linux and macos systems. it also takes care of hooking direnv into your shell, so you can start using it right away! it supports every shell that direnv supports.

### usage

first, you'll need bash and curl. once you have those, run:

```shell
curl -fsSL https://easy-devbox.net | bash
```

the script will prompt you to select a shell to hook into, and then install devbox and direnv. if you don't already have nix, it will be installed for you. otherwise, devbox will use your current nix installation.
