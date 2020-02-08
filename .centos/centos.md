# CentOS VM setup

Information for configuring a [CentOS](https://centos.org/) server for software development.

## Networking

### Hostnames

- [How to set or change system hostname in Linux](https://www.tecmint.com/set-hostname-permanently-in-linux/)
  - See current hostname: `hostname`
  - SystemD-based: `sudo hostnamectl set-hostname NEW_HOSTNAME`
  - On RHEL/CentOS: Open `/etc/sysconfig/network`

### SSH

#### Generating SSH keys

Secure Shell ([SSH](https://www.ssh.com/ssh/)) is used for networking connections between your local machine and VM.

- [Connecting to GitHub with SSH](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)
- [GitLab and SSH keys](https://docs.gitlab.com/ee/ssh/)

#### Configuring SSH connections

- Use the _~/.ssh/config_ file.
- [SSH.com - config](https://www.ssh.com/ssh/config/)

#### Copying files back and forth with SCP

- Secure File Copy ([SCP](https://www.ssh.com/ssh/scp/)) can be used to copy files between your local machine and VM.
- As a simple example:

  ```sh
  ~
  ❯ cd ~/Downloads

  ~/Downloads
  ❯ scp $HOST:~/$PATH $LOCAL_PATH
  ```

- Replace `$HOST` with the `HostName` for your VM in your _~/.ssh/config_ file.
- Replace `$PATH` with the path to a file you would like to copy.
- Replace `$LOCAL_PATH` with a path on your local machine, like _~/Downloads_.

#### SSH key credential management

- It is difficult to find a credential manager on CentOS that is like macOS keychain. The goal would be to only enter passwords once per login session, instead of every time the password is needed.
- One option is [funtoo/keychain](https://www.funtoo.org/Keychain), but it hasn't been updated recently, and installation on CentOS is unclear.
- Another option is [HashiCorp Vault](https://www.hashicorp.com/products/vault). It has more capabilities than funtoo/keychain, but it is also complicated and oriented toward enterprise DevOps.
- As a temporary solution, you can also remove the password from your SSH key on the VM with `ssh-keygen -p -f ~/.ssh/id_rsa_root`.

## Package management and tooling

### Package managers

- [centOS uses `yum`](https://wiki.centos.org/PackageManagement/Yum) ("Yellow Dog Updater, Modified") as the default package manager. While `yum` comes as the default package manager with CentOS, the packages can be years out of date. For example, the version of Zsh in `yum` (5.0.2) is from 2012.
- [Linuxbrew](https://docs.brew.sh/Homebrew-on-Linux) can be used, but tends to be slow.

### Dotfiles

- Clone dotfiles:

  ```sh
  ~
  ❯ git clone --branch master https://github.com/br3ndonland/dotfiles.git ~/.dotfiles
  ```

- [Strap](https://github.com/MikeMcQuaid/strap) cannot be used for automated setup like on macOS, but some related code from this dotfiles repo can be used. Run strap-after-setup _after_ installing [software](#software) listed below.

  ```sh
  # After installing software
  ~
  ❯ cd ~/.dotfiles

  ~/.dotfiles
  ❯ bash script/strap-after-setup
  ```

## Software

### Docker

- [Get Docker Engine - Community for CentOS | Docker Documentation](https://docs.docker.com/install/linux/docker-ce/centos)
- [Install Docker Compose | Docker Documentation](https://docs.docker.com/compose/install/#install-compose)

  ```sh
  ~
  ❯ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

  ~
  ❯ sudo chmod +x /usr/local/bin/docker-compose
  ```

### Git

- CentOS ships with Git 1.8, which doesn't have commit signing tools and other newer features of Git 2. Upgrade with [IUS](https://ius.io/).

  ```sh
  ~
  ❯ git --version
  git version 1.8.3.1

  ~
  ❯ sudo yum remove git

  ~
  ❯ sudo yum -y install  https://centos7.iuscommunity.org/ius-release.rpm

  ~
  ❯ sudo yum -y install git2u-all

  ~
  ❯ git --version
  git version 2.16.5
  ```

- A credential helper is also needed for signed commits, because there is no default keychain program like on macOS.

  ```ini
  # ~/.gitconfig
  [credential]
  helper = cache --timeout 9000
  ```

### GPG

- GPG should already be installed on the VM. To transfer a GPG key from your local machine to your VM:

  ```sh
  ~
  ❯ gpg --export-secret-key $KEYID | ssh $HOST gpg --import
  ```

- Replace `$KEYID` with the key id you see when you run `gpg --list-keys`.
- Replace `$HOST` with the `HostName` for your VM in your _~/.ssh/config_ file.
- This command uses a [pipe](https://wiki.bash-hackers.org/howto/redirection_tutorial?s[]=pipe#pipes) to transfer the output of the left side to the input command on the right side.
- The location of the [Pinentry](https://www.gnupg.org/related_software/pinentry/index.en.html) GPG agent may be different from macOS. Edit _~/.gnupg/gpg-agent.conf_:

  ```
  # gpg-agent.conf
  pinentry-program /usr/bin/pinentry
  ```

- The key ID may also show up differently.
- May need to uncomment `export GPG_TTY=$(tty)` in the _.zshrc_ to also allow signed command-line commits.

### Node.js

[GitHub - nodesource/distributions/README.md](https://github.com/nodesource/distributions/blob/master/README.md)

```sh
~
❯ curl -sL https://deb.nodesource.com/test | bash -

~
❯ sudo yum install -y nodejs
```

### Python

```sh
~
❯ sudo -E yum -y install python3.x86_64
```

- The Python version is substantially behind, as all Yum packages are.
- [pipx](https://pypi.org/project/pipx/) can be used to install global packages that would normally be installed with Homebrew, like:
  - [Black](https://black.readthedocs.io/en/stable/)
  - [Flake8](https://flake8.readthedocs.io/en/latest/)
  - [Pipenv](https://pipenv.readthedocs.io/en/latest/)

### Shell

- The Zsh version in yum, 5.02, is from December 2012. It should still work with most prompts and tooling.
- Zsh completions:

  ```sh
  ~
  ❯ sudo yum install zsh

  ~
  ❯ cd /etc/yum.repos.d/

  ~
  ❯ wget https://download.opensuse.org/repositories/shells:zsh-users:zsh-completions/CentOS_7/shells:zsh-users:zsh-completions.repo

  ~
  ❯ sudo yum install zsh-completions
  ```

- Zsh syntax highlighting: use the standard git method described in [zsh-syntax-highlighting/INSTALL.md on GitHub](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md):

  ```sh
  ~
  ❯ git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

  ~
  ❯ echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
  ```

- Update _.zshrc_ for Zsh syntax highlighting:

  ```sh
  ...
  # last line
  source /root/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ```

### Shell prompt

- The [starship](https://github.com/starship/starship) prompt can be used for Bash.
- For the Zsh [pure prompt](https://github.com/sindresorhus/pure), the manual install is required:

  ```sh
  ~
  ❯ mkdir -p "$HOME/.zsh"

  ~
  ❯ git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

  ~
  ❯ fpath+=("$HOME/.zsh/pure")
  ```

- Then in the _.zshrc_:

  ```sh
  ...
  # Pure prompt: https://github.com/sindresorhus/pure
  fpath+=("$HOME/.zsh/pure")
  autoload -U promptinit
  promptinit
  prompt pure
  ...
  ```
