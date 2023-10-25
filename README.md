# easy-devbox
`easy-devbox` is an installer for devbox and direnv, designed to run on bash on systems with apt-get. it installs and configures devbox and direnv such that you are able to simply run `devbox generate direnv` in any project and it will "Just Work".

> ### important:
> this script provides direnv access to evaluate all .envrc files in `~/Documents/**/` instantly and whenever they change. this is a security risk and you should only run the script if you're confident everything you store in there and may store in there in the future is safe. the script is very simple; if you need to disable this behavior you can edit the script yourself, or even just copy and paste it into your shell directly (there's actually only 7 necessary lines) and remove the lines that whitelist `~/Documents/**/`.

### usage
first, run:
```shell
bash <(curl -s https://raw.githubusercontent.com/tom-ricci/easy-devbox/master/script.sh)
```
then, just restart your shell. that's it!