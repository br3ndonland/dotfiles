# Dotfiles

Brendon Smith ([br3ndonland](https://github.com/br3ndonland))

## Table of Contents <!-- omit in toc -->

- [Overview](#overview)
  - [What](#what)
  - [Why](#why)
  - [How](#how)
- [Hardware](#hardware)
- [macOS](#macos)
- [Homebrew package management](#homebrew-package-management)
- [Git](#git)
- [Shell](#shell)
- [Text editors](#text-editors)
  - [VSCode desktop](#vscode-desktop)
  - [VSCode browser](#vscode-browser)
- [Fonts](#fonts)
- [Language-specific setup](#language-specific-setup)
  - [JavaScript](#javascript)
  - [Python](#python)
- [PGP](#pgp)
  - [GPG](#gpg)
  - [Keybase](#keybase)
  - [Proton Mail](#proton-mail)
- [SSH](#ssh)
  - [Key generation](#key-generation)
  - [Connecting to GitHub](#connecting-to-github)
  - [SSH agent forwarding](#ssh-agent-forwarding)
  - [1Password SSH features](#1password-ssh-features)
- [General productivity](#general-productivity)
- [Media](#media)
- [Science](#science)

## Overview

### What

This repo contains dotfiles, which are application configuration and settings files. They frequently begin with a dot, hence the name. Dotfiles are compatible with Linux and macOS.

### Why

- **Make developer environments automated and disposable**. [Disposability](https://12factor.net/disposability) is an important concept in [infrastructure-as-code DevOps](https://opentofu.org/docs/intro/use-cases/), [serverless computing](https://www.cloudflare.com/learning/serverless/what-is-serverless/), [CI/CD](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions), and more recently, [in-browser development environments](https://docs.github.com/en/codespaces/overview). Why aren't developers applying automation and disposability to their own computers? With an automated disposable developer environment, setup of a new machine is fast and easy. This approach is also liberating - I can purchase a new computer (or wipe an existing one), run _bootstrap.sh_, and be up and running again in no time.
- **Know when and why settings change**. I not only know what tools and settings I'm using, but when and why I chose the tools and settings. This has been particularly important for VSCode, because settings change (and [break](https://github.com/microsoft/vscode/labels/bug)) frequently, and it helps to record troubleshooting info in the Git log.
- **Learn new skills**. I learn skills, like shell scripting, that are useful and don't go out of date quickly. I wouldn't know shell as well if I didn't work on my developer environment. I learn these skills by tinkering a little bit at a time, in an unstructured way. It's time I might not otherwise be writing code.

### How

This dotfiles repository is meant to be installed by _[bootstrap.sh](bootstrap.sh)_.

_bootstrap.sh_ is a shell script to automate setup of a new macOS or Linux development machine. It is _idempotent_, meaning it can be run repeatedly on the same system. To set up a new machine, simply open a terminal and run the following command:

```sh
STRAP_GIT_EMAIL="you@example.com" STRAP_GIT_NAME="Your Name" STRAP_GITHUB_USER="username" \
  /usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/br3ndonland/dotfiles/HEAD/bootstrap.sh)"
```

The following environment variables can be used to configure _bootstrap.sh_, and should be either set before with [`export`](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#export), or inline within the command to run the script:

- `STRAP_GIT_EMAIL`: email address to use for Git configuration. Will error and exit if not set.
- `STRAP_GIT_NAME`: name to use for Git configuration. Will error and exit if not set.
- `STRAP_GITHUB_USER`: username on GitHub or other remote from which dotfiles repo will be cloned. Defaults to my GitHub username, so you should set this if you're not me.
- `STRAP_DOTFILES_URL`: URL from which the dotfiles repo will be cloned. Defaults to `https://github.com/$STRAP_GITHUB_USER/dotfiles`, but any [Git-compatible URL](https://www.git-scm.com/docs/git-clone#_git_urls) can be used, so long as it is accessible at the time the script runs.
- `STRAP_DOTFILES_BRANCH`: Git branch to check out after cloning dotfiles repo. Defaults to `main`.

There are some additional variables for advanced usage. Consult the _[bootstrap.sh](bootstrap.sh)_ script to see all supported variables.

_bootstrap.sh_ will set up macOS and Homebrew, run scripts in the _scripts/_ directory, and install Homebrew packages and casks from the _[Brewfile](Brewfile)_. A Brewfile is a list of [Homebrew](https://brew.sh/) packages and casks (applications) that can be installed in a batch by [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle). The Brewfile can even be used to install Mac App Store apps with the `mas` CLI. Note that you must sign in to the App Store ahead of time for `mas` to work.

The following list is a brief summary of permissions related to _bootstrap.sh_.

- Initial setup of Homebrew itself does not require an admin user account, but does require `sudo`. See the [Homebrew installation docs](https://docs.brew.sh/Installation), [Homebrew/install#312](https://github.com/Homebrew/install/issues/312), and [Homebrew/install#315](https://github.com/Homebrew/install/pull/315/files).
- [After Homebrew setup, use of `sudo` with `brew` commands is discouraged](https://docs.brew.sh/FAQ#why-does-homebrew-say-sudo-is-bad).
- After Homebrew setup, commands such as `brew bundle install --global` should be run from the same user account used for setup. Attempts to run `brew` commands from another user account will result in errors, because directories that need to be updated are owned by the setup account. If access to the setup account is not routinely available, an alternative approach could be to change ownership of Homebrew directories to a group that includes the user account used for Homebrew setup as well as other users that need to run Homebrew commands.
- _bootstrap.sh_ can run with limited functionality on non-admin and non-`sudo` user accounts. A plausible use case could exist in which an admin runs `bootstrap.sh` to configure the system initially, then a non-admin runs `bootstrap.sh` to configure their own account. In this use case, the non-admin user should not need admin or `sudo` privileges, because all the pertinent setup (FileVault disk encryption, XCode developer tools, Homebrew, etc) is already complete.

Users with more complex needs for multi-environment dotfiles management might consider a tool like [`chezmoi`](https://www.chezmoi.io/).

## Hardware

- Apple Silicon [Mac mini](https://www.apple.com/mac-mini/)
- 4K@60 Hz monitor
- [Microsoft Sculpt keyboard](https://www.amazon.com/dp/B00CYX26BC)
- [MOJO silent bluetooth vertical mouse](https://www.amazon.com/dp/B00K05LPIQ)
- [Blue Yeti Blackout](https://www.amazon.com/dp/B00N1YPXW2) microphone
- <details><summary><a href="https://www.fully.com/standing-desks/jarvis.html">Fully Jarvis standing desk</a></summary>

  ![Fully Jarvis standing desk](https://user-images.githubusercontent.com/26674818/102920846-6b6cc280-4459-11eb-90c5-12e38abd16c1.jpeg)

  </details>

- <details><summary>When I first began standing work, I created a DIY standing desk in my kitchen cabinet.</summary>

  ![DIY standing desk](https://user-images.githubusercontent.com/26674818/102920844-6b6cc280-4459-11eb-9248-b16a7da7b5d0.jpg)

  - I used my [Kensington SafeDock](https://www.amazon.com/dp/B008M11X0U) to elevate my MacBook in my kitchen cabinet, and wrapped the cable lock around a pipe near the ceiling.
  - I ran an ethernet cable from my router into the cabinet.
  - I added an [LED light](https://www.amazon.com/dp/B06Y3NWN8R) to the cabinet door.

  </details>

- To improve my posture and endurance, I also use a [SlingShot Hip Circle](https://markbellslingshot.com/collections/hip-circles), Gold Toe compression socks, [Altra](https://www.altrarunning.com/) zero-drop shoes, and a [balance board](https://www.amazon.com/dp/B01MQJO2PQ).

## macOS

- macOS setup is automated with _[macos.sh](scripts/macos.sh)_.
- [Karabiner Elements](https://pqrs.org/osx/karabiner/) is used for keymapping.

  - Settings are stored in _.config/karabiner/karabiner.json_. Note that Karabiner will auto-format the JSON with four spaces. To avoid changing the formatting with the [Prettier](https://prettier.io/) autoformatter, I added _karabiner.json_ to _.prettierignore_.
  - Simple modifications:

    | From key  | To key    |
    | --------- | --------- |
    | caps_lock | escape    |
    | escape    | caps_lock |

  - Complex modifications:
    - Launch Terminal with Cmd+Escape
    - See _karabiner.json_ for more.
  - Devices
    - Disable built-in keyboard when external keyboard is connected

## Homebrew package management

- [Homebrew](https://brew.sh/) is a package manager that includes [Homebrew-Cask](https://github.com/homebrew/homebrew-cask) to manage other macOS applications. See the Homebrew [docs](https://docs.brew.sh) for further info.
- The list of "formulae" (packages), "casks" (apps), and `mas` apps (Mac App Store apps) is stored in _[Brewfile](Brewfile)_. The Brewfile works with [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) to manage all Homebrew packages and casks together.
- Key Brew Bundle commands:

  ```sh
  # Install or update everything in the Brewfile
  brew bundle install --global
  # Check for programs listed in Brewfile
  brew bundle check --global
  # Remove any Homebrew packages and casks not in Brewfile
  brew bundle cleanup --force --global
  # Show cache dir: https://docs.brew.sh/FAQ#where-does-stuff-get-downloaded
  brew --cache
  ```

## Git

- [Git](https://www.git-scm.com/) is the version control system used on GitHub. _[Why use Git?](https://www.git-scm.com/about)_ Git enables creation of multiple versions of a code repository called branches, with the ability to track and undo changes in detail. If you're new to Git, the [Git Book](https://www.git-scm.com/book/en/v2) is helpful.
- I install Git with Homebrew.
- I [configure Git to connect to GitHub with SSH](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).
- I store Git configuration in _[.gitconfig](.gitconfig)_.
- I sign Git commits and tags with [1Password and SSH](#1password-ssh-features). In the past, I have also signed with [GPG](#gpg).
- _Why sign Git commits and tags?_
  - **Signing verifies user identity**. In case you haven't heard, [anyone can use Git to impersonate you](https://blog.1password.com/git-commit-signing/). Signing helps avoid impersonation attacks. The simplest form of signing can be seen when performing Git operations through the GitHub UI with valid credentials (making a commit, merging a PR, etc). As the [GitHub docs](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification) explain, these operations are signed with GitHub's key (signature `4AEE18F83AFDEB23`). Operations signed with this key indicate valid GitHub credentials, so signing with GitHub's key is somewhat like one-factor authentication. To make this more secure, users can use their own keys, which involves generating and maintaining custody of a key, setting up Git to sign commits and tags with the key, and adding the public key to the GitHub account. This can be even more secure, somewhat like two-factor authentication, because it indicates that the user has both valid GitHub credentials and the valid private key used for signing. Signing with a user-generated key also allows attestation. If you navigate to [my GitHub profile](https://github.com/br3ndonland), you can see several SSH and PGP key signatures that I have associated with my identity on GitHub. This means, "I attest that I possess the corresponding private keys and use them for signing." Commits and tags signed with those keys show up as "verified" on GitHub.
  - **Signing verifies changes**. This is especially important for tags because tags are often used to perform releases. Signed tags indicate that the release comes from a trusted source, because the user possessing the signing key has verified the contents of the release.
- See the [GitHub docs](https://docs.github.com/en/authentication/managing-commit-signature-verification) for further info on signing.

## Shell

- I use Zsh as my shell, which functions like Bash but offers more customization.
- I install with Homebrew to maintain consistent versions across multiple machines. However, note that [Zsh is now the default shell for new macOS users starting with macOS Catalina](https://support.apple.com/en-us/HT208050).
- See the [Wes Bos Command Line Power User course](https://commandlinepoweruser.com/) for an introduction to Zsh.
- I use [Starship](https://starship.rs/) for my shell prompt.
- For my terminal application, I use [kitty](https://github.com/kovidgoyal/kitty), a GPU-based terminal emulator.

## Text editors

### VSCode desktop

I write code with [VSCodium](https://github.com/VSCodium/vscodium), an alternate build of [Microsoft Visual Studio Code](https://code.visualstudio.com/) (VSCode) that is free of proprietary features and telemetry.

VSCode settings, keybindings, and extension lists are stored in this repo. Extensions can be installed by running _[vscode-extensions.sh](scripts/vscode-extensions.sh)_ along with the editor command name, like `vscode-extensions.sh codium` for VSCodium. The script uses the [VSCode extension CLI](https://code.visualstudio.com/docs/editor/extension-gallery).

VSCode offers other options for managing settings. The [`Shan.code-settings-sync`](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) extension was popular in the past, and stored settings in a GitHub Gist. [VSCode now offers a built-in settings sync feature](https://code.visualstudio.com/docs/editor/settings-sync) ([introduced in VSCode 1.48 July 2020](https://code.visualstudio.com/updates/v1_48)). This repo uses Git for settings sync instead of VSCode's settings sync feature. _Why not use VSCode settings sync?_

- VSCode settings sync requires a Microsoft or GitHub login. What if you use GitLab?
- Where does VSCode settings sync actually store the data? The `Shan.code-settings-sync` extension stored data in a GitHub Gist, so it was possible to view the synced settings directly. VSCode only allows the synced settings to be viewed from within VSCode. There's no Git repo or Gist where you can go to see line-by-line changes.
- VSCode settings sync uses a "Merge or Replace" dialog box and a pseudo-Git merge conflict resolver. It can be complicated and confusing to use.

[VSCode profiles](https://code.visualstudio.com/docs/editor/profiles) ([introduced in VSCode 1.76 February 2023](https://code.visualstudio.com/updates/v1_76)) assist with switching among different editor environments, like personal and work computers. This repo does not use VSCode profiles, but uses a simple Git branching strategy for managing these environments. _Why not use VSCode profiles?_

- Most settings are the same across all profiles, but VSCode profiles store separate JSON settings for every profile
- Exporting a profile to a file exports the settings as an inline dumped JSON string, making version control and reading difficult
- Exporting a profile to a file includes metadata like `snippets.usageTimestamps`, which is apparently tracking every time snippets are used. Why? Why would you need to track this in a profile? This also makes version control more difficult because it creates a Git diff every time a snippet is used.
- The [VSCode profiles docs describe the use case](https://code.visualstudio.com/docs/editor/profiles#_uses-for-profiles) as, "Since profiles are remembered per workspace, they are a great way to customize VS Code for a specific programming language... Using this approach, you can easily switch between workspaces and always have VS Code configured the right way." There are already workspace and repo settings available that do the same thing.

### VSCode browser

#### codespaces

I have tried GitHub's cloud-hosted VSCode, called [Codespaces](https://docs.github.com/en/codespaces). So far, I don't like it because:

- Keybindings conflict with browser keybindings. The command palette may not be able to be opened with the usual keybindings, because Cmd+shift+p is already in use by the browser. This was partially addressed by the [VSCode extension](https://docs.github.com/en/codespaces/developing-in-codespaces/using-codespaces-in-visual-studio-code), which allows remote development from outside the browser.
- Lag. There's lag between when a character is typed and when it appears. This can be very bothersome.
- Files. It's unclear if or how persistent file storage is available. Local filesystem access is limited.
- GPG commit signing has some limitations. GitHub offers [commit signing with GPG](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-gpg-verification-for-codespaces), but private keys must be in GitHub's custody.
- Customization is complicated.
  - Codespaces doesn't automatically clone or run these dotfiles. They claim that [codespaces will automatically clone your dotfiles and run `bootstrap.sh`](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account#dotfiles), but the repo is not cloned to `~/.dotfiles`, and `bootstrap.sh` is not running, even after enabling the "Automatically install dotfiles" setting in user preferences.
  - Codespaces can't read VSCode settings from dotfiles. The [docs](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account) explain, "Currently, Codespaces does not support personalizing the _User_ settings for the Visual Studio Code editor with your `dotfiles` repository." The separate Settings Sync service is required to sync settings.
  - Extensions have to be managed separately from VSCode desktop. There is a `"github.codespaces.defaultExtensions"` setting that requires its own list of extensions, and it's unclear if Codespaces can install extensions from VSIX (like [Dracula Pro](https://draculatheme.com/pro)).
  - Codespaces may not be able to install and use custom fonts (like [Dank Mono](https://gumroad.com/l/dank-mono)). Font capabilities may be limited by the browser.
  - For further customization, Codespaces supports "[dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-codespaces-for-your-project)," which are created with special Dockerfiles in each project. This adds further complication and maintenance overhead.
- [Codespaces pricing](https://docs.github.com/en/codespaces/codespaces-reference/understanding-billing-for-codespaces) requires enterprises to set up separate spending limits, and is not specified for public repos on free plans. Do you want to pay for your text editor by the minute?

#### code-server

- [code-server](https://github.com/coder/code-server) is an open-source alternative to codespaces.
- I set up code-server on a Linux cloud server. I prefer to use DigitalOcean, following their [recommended initial setup guide](https://www.digitalocean.com/docs/droplets/tutorials/recommended-setup/) for "droplets" (VMs):
  - Set up [SSH agent forwarding](https://docs.github.com/en/free-pro-team@latest/developers/overview/using-ssh-agent-forwarding) on local machine to avoid having to deposit SSH private keys on droplet
  - Add SSH public key when creating droplet
  - Add a user data script like _[linux-userdata.sh](scripts/linux-userdata.sh)_
- [Installation](https://github.com/coder/code-server/blob/v3.7.2/doc/install.md) and [setup](https://github.com/coder/code-server/blob/v3.7.2/doc/guide.md) on the server:

  ```sh
  curl -fsSL https://code-server.dev/install.sh | sh
  sudo systemctl enable --now code-server@$USER
  ```

- Server configuration file: note that `user-data-dir` must be an absolute path if running with the `systemctl` background service.

  ```yaml
  bind-addr: 127.0.0.1:8080
  auth: none
  password: false
  cert: false
  user-data-dir: /home/brendon/.dotfiles/vscode
  ```

- Local machine
  - Forward port from server by running `ssh -N -L 8080:127.0.0.1:8080 code-server` on the local machine.
  - Open http://localhost:8080 in a browser and you should see VSCode!
  - Multiple workspaces can be opened by passing the `?workspace=` query parameter in the URL. Each browser tab can have a workspace open.
  - Proxy ports back to local machine with the `/proxy` endpoint. For example, to hit an API endpoint running on port 1025 on the server, `curl :8080/proxy/1025`. As explained in the [VSCode docs](https://code.visualstudio.com/docs/containers/python-user-rights), if developing on Linux, note that non-root users may not be able to expose ports less than 1024. The port is set to `1025` in the debugger config for this reason.
- Extensions:
  - code-server has its own extension marketplace that is created by scraping GitHub.
  - You can also install extensions with the CLI: `code-server --install-extension`.
- Settings
  - If the shell doesn't look right: Command Palette -> Terminal: Select Default Shell
  - The browser may grab some VSCode keybindings. I prefer to use Safari, because it grabs the least shortcuts.
  - `code-server` can't be used as a Git editor, as far as I can tell. It can open text files from the command-line, but the `--wait` switch is not recognized.
  - The clipboard doesn't completely work. See [coder/code-server#1106](https://github.com/coder/code-server/issues/1106).
  - The font can't yet be customized directly. See [coder/code-server#1374](https://github.com/coder/code-server/issues/1374).
  - You can change the color theme, but you may need to re-select the theme each time you open a browser tab.

## Fonts

I use [Recursive Mono](https://www.recursive.design/). It's available for download [from Homebrew](https://formulae.brew.sh/cask/font-recursive-code) (`brew install --cask font-recursive-code`) or [GitHub](https://github.com/arrowtype/recursive). [Fira Code](https://github.com/tonsky/FiraCode) and [Ubuntu Mono](https://design.ubuntu.com/font/) are decent free alternatives.

I previously used [Dank Mono](https://gumroad.com/l/dank-mono). The rounded characters are eminently readable, the italics are elegant, and the ligatures are intuitive. Unfortunately, it's not correctly monospaced. I reached out to the Dank Mono creator Phil Pluckthun after it stopped working in kitty 0.36:

> Hi Phil,
>
> I've been using Dank Mono for years and love it, but I'm having an issue in which the font is not detected as monospaced on macOS. I can still use Dank Mono in VSCode, but some other terminal applications and text editors only accept monospaced fonts. I've tried modifying the macOS Font Book "Fixed Width" smart collection so it includes Dank Mono, but it's still not picked up as monospaced. Is there something I can do about this?
>
> It may have to do with the ligatures. If I load Dank Mono into a font editor, I can see that the ligatures are not the same width as the other characters. See the attached screenshot.
>
> It may also have to do with spacing. The italic variant lacks a spacing property.
>
> ```sh
> ~
> ❯ fc-list : family style spacing outline scalable | grep Dank
> Dank Mono:style=Bold:spacing=100:outline=True:scalable=True
> Dank Mono:style=Italic:outline=True:scalable=True
> Dank Mono:style=Regular:spacing=100:outline=True:scalable=True
> ```
>
> Related:
>
> - https://github.com/eigilnikolajsen/commit-mono/issues/15
> - https://github.com/IdreesInc/Monocraft/issues/26
> - https://github.com/IdreesInc/Monocraft/issues/77
> - https://github.com/tonsky/FiraCode/issues/1325
> - https://github.com/vercel/geist-font/issues/33
> - https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
>
> Thanks for your help,
>
> Brendon Smith

Phil's reply:

> Hiya,
>
> Some terminal applications require a specific monospace flag to be set in the font file that was only gaining traction after the font was released. Some also just don't support fonts with ligatures. In Dank Mono's case the specific flag that some applications require to select the font as a monospaced one simply isn't set, and a different, older one is set instead.
>
> Cheers & Best,
>
> Phil

## Language-specific setup

### JavaScript

- [node](https://nodejs.org/en/) is a JavaScript runtime used to run JavaScript outside of a web browser.
- [npm](https://www.npmjs.com/) is a package manager written in node.js, included when node is installed.
  - It's difficult to keep track of global npm packages. There's no easy way to do it with the usual _package.json_. As Isaac Schlueter [commented](https://github.com/npm/npm/issues/2949#issuecomment-11408461) in 2012,
    > Yeah, we're never going to do this.
  - Instead, packages can be installed with Homebrew, or with _[npm-globals.sh](scripts/npm-globals.sh)_.
  - [npm-check](https://www.npmjs.com/package/npm-check) can be used to manage global packages after install, with `npm-check -ug`. If not using npm-check, a list of global npm packages can be seen after installation with `npm list -g --depth=0`.
- I use the [Prettier](https://prettier.io/) autoformatter and the [Prettier VSCode extension](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) to format my web code, including JavaScript and Vue.js. Prettier is an extremely helpful productivity tool, and I highly recommend it. Autoformatters save time and prevent [bikeshedding](https://www.freebsd.org/doc/en/books/faq/misc.html#idp50244984).
- Compared with Prettier, ESLint formats less code languages, requires complicated setup, and doesn't work well when installed globally.
- In the past, I also used [JavaScript Standard Style](https://standardjs.com/) (aka StandardJS). Standard Style has also [reportedly](https://changelog.com/podcast/359) been favored by Brendan Eich (creator of JavaScript) and Sir Tim Berners-Lee (creator of the World Wide Web). Prettier provides a similar code style, but with more features, so I use Prettier instead.

### Python

- I lint and format Python code with [Ruff](https://docs.astral.sh/ruff/).
  - The [Ruff VSCode extension](https://open-vsx.org/extension/charliermarsh/ruff) provides support for Ruff in VSCode. I set VSCode to autoformat on save.
  - Ruff is available as a [Homebrew formula](https://formulae.brew.sh/formula/ruff).
- See my [template-python](https://github.com/br3ndonland/template-python) repo for useful tooling and additional sensible defaults.

## PGP

- I use [Gnu Privacy Guard](https://www.gnupg.org/) (GPG, the free implementation of Pretty Good Privacy (PGP)), [Keybase](https://keybase.io), and [Proton Mail](https://protonmail.com/) to encrypt and share messages, passwords, and other sensitive info.
- PGP vs SSL: SSL/TLS/HTTPS encrypts data in transit, but the storage provider like Dropbox, Google, or Slack can still read it. Communications which are end-to-end PGP encrypted can only be read by the sender or recipient, never the provider.

### GPG

GPG is an implementation of [OpenPGP](https://www.openpgp.org).

#### Installation

- Install `gnupg`:
  - macOS: `brew install gnupg`
  - Ubuntu Linux: `sudo apt-get install gnupg`
  - Manually: [Download from GnuPG](https://www.gnupg.org/download/index.html)
- Install `pinentry`:
  - macOS: `brew install pinentry` (terminal) or `brew install pinentry-mac` ([app](https://github.com/GPGTools/pinentry-mac) from [GPGTools suite](https://gpgtools.org/) that enables use of macOS keychain and GUI apps like VSCode)
  - Ubuntu Linux: `apt install pinentry`
  - Manually: On macOS, Apple's command-line tools (`xcode-select`) should have the build prerequisites. [Download](https://www.gnupg.org/download/index.html) `libgpg-error`, `libassuan`, and `pinentry`, then build from source and install in order (`libgpg-error`, then `libassuan`, then `pinentry`):
    ```sh
    cd /path/to/libgpg-error
    ./configure; make; sudo make install
    cd /path/to/libassuan
    ./configure; make; sudo make install
    cd /path/to/pinentry
    ./configure; make; sudo make install
    ```
- Set the `pinentry` program:
  - _~/.gnupg/gpg-agent.conf:_ `pinentry-program /opt/homebrew/bin/pinentry-tty`
  - The path apparently has to be absolute, so it may vary by system.
  - See the [GPG agent options docs](https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html) for more.
  - `pinentry-tty` allows plain-text password entry. `pinentry` may raise confusing "Screen or window too small" errors in some terminals.
- [Export the `GPG_TTY` environment variable](https://www.gnupg.org/documentation/manuals/gnupg/Agent-Examples.html): `export GPG_TTY=$(tty)` (can add to shell profile to automatically export). Note that this is not the same thing as `export GPG_TTY=$TTY`, which may raise cryptic `Inappropriate ioctl for device` errors.
- Ensure proper permissions are set on GPG config files:
  ```sh
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/gpg.conf
  ```
- See the [GPG configuration docs](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration.html) for more.

#### GPG and YubiKey

Resources:

- [`gpg-card` docs](https://gnupg.org/documentation/manuals/gnupg/gpg_002dcard.html)
- [Yubico developers: PGP](https://developers.yubico.com/PGP/)
- [Yubico support: using your YubiKey with OpenPGP](https://support.yubico.com/hc/en-us/articles/360013790259-Using-Your-YubiKey-with-OpenPGP)
- [YubiKey Manager CLI (`ykman`) User Manual](https://docs.yubico.com/software/yubikey/tools/ykman/Using_the_ykman_CLI.html)
- [Okta developer blog: Developers guide to GPG and YubiKey](https://developer.okta.com/blog/2021/07/07/developers-guide-to-gpg)

A YubiKey has admin and non-admin OpenPGP PINs.

- Default OpenPGP admin PIN is 12345678.
- Default OpenPGP non-admin PIN is 123456.
- Change OpenPGP PINs with `gpg --change-pin` or `ykman openpgp access change-admin-pin`/`ykman openpgp access change-pin`.

To use a GPG key on a YubiKey with a new computer, plug in the YubiKey, check the status, and fetch the public keys.

```text
~
❯ gpg --card-status

~
❯ gpg --card-edit

gpg/card> admin
Admin commands are allowed

gpg/card> url
URL to retrieve public key: https://github.com/<YOUR_GITHUB_USERNAME>.gpg

gpg/card> fetch

gpg/card> quit
```

To move a GPG key from a computer to a YubiKey, use `gpg --edit-key` followed by `keytocard`. The `keytocard` command is repeated for each "where to store the key" option. After the two `keytocard` commands, there may be confusing output regarding whether or not to "save" your changes, including `Note: the local copy of the secret key will only be deleted with "save".` As recommended in [Yubico support: using your YubiKey with OpenPGP](https://support.yubico.com/hc/en-us/articles/360013790259-Using-Your-YubiKey-with-OpenPGP), entering "no" at these prompts will avoid deleting the GPG key from the computer (but will still save it to the YubiKey).

```text
~
❯ gpg --edit-key <KEY_ID>

gpg> keytocard
Really move the primary key? (y/N) y
Please select where to store the key:
   (1) Signature key
   (3) Authentication key
Your selection? 1
gpg: pinentry launched (11284 tty 1.2.1 /dev/ttys004 xterm-kitty - 20620/501/4 501/20 0)
Please enter your passphrase, so that the secret key can be unlocked for this session
Passphrase:
gpg: pinentry launched (11285 tty 1.2.1 /dev/ttys004 xterm-kitty - 20620/501/4 501/20 0)
Please enter the Admin PIN

Number: 12 345 678
Holder:
Admin PIN:
gpg: pinentry launched (11287 tty 1.2.1 /dev/ttys004 xterm-kitty - 20620/501/4 501/20 0)
Please enter the Admin PIN

Number: 12 345 678
Holder:
Admin PIN:

sec  ed25519/16digit_PGPkeyid
     created: 1900-01-01  expires: never       usage: SC
     trust: unknown       validity: unknown
ssb  cv25519/16digit_PGPkeyid
     created: 1900-01-01  expires: never       usage: E
[ unknown] (1). you <you@example.com>

Note: the local copy of the secret key will only be deleted with "save".

gpg> keytocard
Really move the primary key? (y/N) y
Please select where to store the key:
   (1) Signature key
   (3) Authentication key
Your selection? 3

gpg: pinentry launched (11284 tty 1.2.1 /dev/ttys004 xterm-kitty - 20620/501/4 501/20 0)
Please enter your passphrase, so that the secret key can be unlocked for this session
Passphrase:
gpg: pinentry launched (11285 tty 1.2.1 /dev/ttys004 xterm-kitty - 20620/501/4 501/20 0)
Please enter the Admin PIN

Number: 12 345 678
Holder:
Admin PIN:
gpg: pinentry launched (11287 tty 1.2.1 /dev/ttys004 xterm-kitty - 20620/501/4 501/20 0)
Please enter the Admin PIN

Number: 12 345 678
Holder:
Admin PIN:

sec  ed25519/16digit_PGPkeyid
     created: 1900-01-01  expires: never       usage: SC
     trust: unknown       validity: unknown
ssb  cv25519/16digit_PGPkeyid
     created: 1900-01-01  expires: never       usage: E
[ unknown] (1). you <you@example.com>

Note: the local copy of the secret key will only be deleted with "save".

gpg> Q
Save changes? (y/N) N
Quit without saving? (y/N) y
```

#### GPG key generation

- Run `gpg --full-generate-key` from the command line to generate a key. Respond to the command-line prompts. The maximum key size of `4096` is recommended.
- View keys with `gpg --list-secret-keys`.
- Run `gpg --send-keys <keynumber>` to share the public key with the GPG database. It takes about 10 minutes for the key to show up in the GPG database.

#### Key import and export

- Import a GPG key from a file: `gpg --import /path/to/privatekey.asc`
- Export your GPG public key:
  - Copy to clipboard (for pasting into GitHub/GitLab): `gpg --armor --export | pbcopy`
  - Export to a file: `gpg --armor --export > public.gpg`

#### Sending messages

- Locate another user's key in the global database with `gpg --search-keys <email>`.
- Encrypting communications
  - Encrypt a message with `echo "Hello, World!" | gpg --encrypt --armor --recipient "<email>"`. Optionally, save the encrypted message in a .gpg file.
  - If the message was saved in a file, send the file over email, Slack, or any other medium.
  - Decrypt the message with `gpg --decrypt`.
    - If copying the encrypted text directly, include it in quotes: `echo "BIG LONG GPG STRING" | gpg --decrypt`.
    - If reading a file, include the filename when decrypting: `gpg --decrypt message.gpg`.
    - Decrypted output can be autosaved to a new file: `gpg --decrypt message.gpg --output file.txt`.

#### Signing Git commits with GPG

Note that SSH can also be used to sign Git commits. See the [SSH section](#ssh) for further details.

- See [Pro Git: Signing your work](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work).
- Install and configure `pinentry` as described above.
- Configure Git to use GPG and your key for commits, using _.gitconfig_:
  - Set `signingkey`: `git config --global user.signingkey 16digit_PGPkeyid` the 16 digit PGP key id is the partial 16 digit number listed on the `sec` line).
    ```ini
    [user]
    name = your name
    email = you@email.com
    signingkey = 16digit_PGPkeyid
    ```
  - Turn on `gpgsign`:
    ```ini
    [commit]
    gpgsign = true
    ```

#### General

- Start the agent: `gpg-connect-agent /bye`
- Reload the agent configuration: `gpg-connect-agent reloadagent /bye`
- Stop the agent: `gpgconf --kill gpg-agent` or `gpgconf --kill all`. See the [GPG docs on invoking `gpg-agent`](https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html).
- Verify GPG signing capabilities: `echo "test" | gpg --clearsign`
- Trust GPG keys using the GPG TTY interface:
  - If you see `gpg: WARNING: This key is not certified with a trusted signature!` when examining signed Git commits with `git log --show-signature`, you may want to trust the keys.
  - Enter the GPG key editor from the command line with `gpg --edit-key <PGPkeyid>`.
  - Set trust level for the key by typing `trust`, hitting enter, and entering a trust level.
  - See the [GPG docs](https://www.gnupg.org/gph/en/manual/x334.html) for more info.
- [GitHub GPG instructions](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification)
- [GitLab GPG instructions](https://gitlab.com/help/user/project/repository/gpg_signed_commits/index.md)
- If working on a server, you can use [ssh agent forwarding](https://docs.github.com/en/free-pro-team@latest/developers/overview/using-ssh-agent-forwarding) to access your SSH and GPG keys without having to copy them.

### Keybase

#### Zoom acquisition

**Keybase was acquired by Zoom, and its future is uncertain.**

- [Zoom Blog 20200507: Zoom acquires Keybase and announces goal of developing the most broadly used enterprise end-to-end encryption offering](https://blog.zoom.us/wordpress/2020/05/07/zoom-acquires-keybase-and-announces-goal-of-developing-the-most-broadly-used-enterprise-end-to-end-encryption-offering/)
- [Keybase Blog 20200507: Keybase joins Zoom](https://keybase.io/blog/keybase-joins-zoom)
- [The Verge 20200507: Zoom buys the identity service Keybase as part of 90-day security push](https://www.theverge.com/2020/5/7/21250418/zoom-keybase-acquisition-encryption-security-messages-services)

#### Useful features

- PGP key and identity management
  - Keybase solves the key identity problem. Even if you have someone's public PGP key, you can't verify it actually came from them unless you exchange it in person. Keybase provides a unified identity for verification of PGP keys. Each device gets its own private key, and they share identity. It was previously challenging to move PGP keys among devices, but now it can be accomplished simply by signing in to Keybase.
  - [Following](https://book.keybase.io/docs/server) someone is a way of verifying their cryptographic identity, not a way of subscribing to updates from the person like social media.
  - PGP key features are available through the CLI with `keybase pgp` commands.
- Chat
  - Keybase chat looks and feels like Slack, but has several advantages:
    - [Keybase is open-source](https://github.com/keybase/client). Slack is not.
    - [Keybase chat is end-to-end encrypted](https://book.keybase.io/chat). Slack is not.
    - Keybase chat does not have a free message limit. Slack does. I frequently hit this free message limit when participating in large workspaces for my courses on Udacity, and it negatively impacted my ability to build projects with classmates. We switched to a Keybase team instead.
    - Keybase has not leaked passwords. [Slack has been vulnerable to password leaks and other attacks](https://slackhq.com/march-2015-security-incident-and-the-launch-of-two-factor-authentication), and it took Slack four years before they notified users. [The Keybase CEO's Slack credentials were compromised](https://keybase.io/blog/slack-incident).
    - Keybase does not use third-party trackers, but Slack is polluted with trackers. Try running slack in the Brave browser. You'll probably see "99+" trackers blocked.
- Teams
- Encrypted files
  - The Keybase file system (KBFS) is like an encrypted Dropbox or Google Drive cloud storage system.
  - Integrates with the macOS finder through use of the [FUSE for macOS](https://osxfuse.github.io/) package.
- Crypto tools
  - Keybase provides useful [cryptographic tools](https://keybase.io/blog/crypto) for PGP encrypting and decrypting files. One common use case is storing credentials in encrypted files. For example, a [GitHub Personal Access Token (PAT)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) can be stored in an encrypted file and used to [authenticate to GitHub Container Registry (GHCR)](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-docker-registry).
    - [Create PAT on GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) and copy to clipboard
    - Transfer PAT from clipboard to encrypted file: `pbpaste | keybase encrypt -o pat-ghcr.asc <KEYBASE_USERNAME>`
    - Decrypt the file and log in to GHCR: `keybase decrypt -i pat-ghcr.asc | docker login ghcr.io -u <GITHUB_USERNAME> --password-stdin`
- Git
  - Keybase allows users and teams to create and store end-to-end encrypted Git repositories. See the [Keybase Git docs](https://book.keybase.io/git) and [Keybase Git blog post](https://keybase.io/blog/encrypted-git-for-everyone).
  - Treat Keybase Git repos as [remotes](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes) (like GitHub repos). They can be cloned, pushed, and pulled, as you would do for GitHub repos. For example: `git remote add keybase keybase://$PUBLIC_OR_PRIVATE/$USERNAME/$REPONAME`.
  - As of Keybase 5.1.0, [Git LFS](https://git-lfs.github.com/) is also enabled.
  - Keybase can't be used to sign Git commits. The best method is to export your PGP key from Keybase to GPG, and then sign Git commits with GPG.
  - There has been some debate about the need to sign Git commits at all. Linus Torvalds has [recommended](http://git.661346.n2.nabble.com/GPG-signing-for-git-commit-td2582986.html) the use of `git tag -s` to sign with tags instead. The Keybase developers [sign releases with tags, but don't always sign commits](https://github.com/keybase/client/issues/3318) to the Keybase source code. However, in order to sign tags, you still need to set up commit signing, so why not just sign commits also? Whether you sign all commits or just tags, Keybase should improve this feature.

### Proton Mail

I use [Proton Mail](https://protonmail.com/) for PGP-encrypted email.

## SSH

### Key generation

To [generate an SSH key](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent):

```sh
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519_"$(id -un)"
```

If you have a FIDO2 security key that supports discoverable credentials (formerly known as resident keys), such as a YubiKey, you can [generate an SSH key that is stored directly on the FIDO2 hardware device](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key-for-a-hardware-security-key).

You'll need `libfido2` and OpenSSH version 8.2 or later.

```sh
brew install libfido2 openssh
```

Next, generate a key with the `-O resident` option. You can additionally set a PIN on the YubiKey, which requires the YubiKey Manager [CLI](https://developers.yubico.com/yubikey-manager/) or [GUI](https://www.yubico.com/support/download/yubikey-manager/), and require PIN verification for use of the SSH key, with the `-O verify-required` option. In this scenario, the SSH key itself does not need a password. The password is replaced by the YubiKey and its PIN.

```sh
ssh-keygen -t ed25519-sk -O resident -O verify-required -C "your_email@example.com" -f ~/.ssh/id_ed25519_"$(id -un)"
```

### Connecting to GitHub

See the [GitHub docs on connecting to GitHub with SSH](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).

- [Add SSH key to GitHub account](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account):
  - Use the [GitHub CLI](https://cli.github.com/manual/gh_ssh-key_add): `gh ssh-key add`
  - Or, run `pbcopy < ~/.ssh/id_ed25519_"$(id -un)".pub`, and go to GitHub in a web browser and paste the key.
- [Check SSH connection](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/testing-your-ssh-connection) with `ssh -T git@github.com`.

GitHub supports use of SSH keys from FIDO2 security key hardware devices like YubiKeys. See the [GitHub docs](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key-for-a-hardware-security-key), [GitHub blog](https://github.blog/2021-05-10-security-keys-supported-ssh-git-operations/), and [Yubico blog](https://www.yubico.com/blog/github-now-supports-ssh-security-keys/).

GitHub also supports use of SSH keys for signing Git commits. See the [GitHub changelog](https://github.blog/changelog/2022-08-23-ssh-commit-verification-now-supported/) and [GitHub docs](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification). See the [1Password section](#1password-ssh-features) for instructions.

### SSH agent forwarding

If working on a server, you can use [ssh agent forwarding](https://docs.github.com/en/free-pro-team@latest/developers/overview/using-ssh-agent-forwarding) to access your SSH and GPG keys without having to copy them.

```text
Host yourserver.com
  ForwardAgent yes
```

### 1Password SSH features

[1Password includes features for managing SSH keys](https://developer.1password.com/docs/ssh). At this time, SSH features are limited to your Personal vault.

To [get started](https://developer.1password.com/docs/ssh/get-started):

- Generate or import an SSH key
- Upload the key to GitHub or any platform to which you connect with SSH
- Turn on the 1Password SSH agent
- Update the [SSH config](https://www.ssh.com/academy/ssh/config) to use the 1Password `IdentityAgent`
- Optionally, simplify the agent path by creating a symlink to `~/.1password/agent.sock`.

1Password also supports Git commit signing with SSH keys. See the [1Password blog](https://blog.1password.com/git-commit-signing/) and [GitHub changelog](https://github.blog/changelog/2022-08-23-ssh-commit-verification-now-supported/).

To [sign Git commits with SSH and 1Password](https://developer.1password.com/docs/ssh/git-commit-signing):

- [Tell GitHub about the SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account):
  - Go to https://github.com/settings/keys
  - Click "New SSH key"
  - Select the key type "signing key"
  - Allow the 1Password browser extension to autofill the "key" input field with an SSH public key. Either generate a new SSH key with 1Password or use an existing one. The same SSH key can be used for both authentication and signing.
- [Tell Git about the SSH key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-ssh-key):
  - Set `git config gpg.format = ssh`
  - Set `git config gpg.ssh.allowedsignersfile=~/.ssh/allowed_signers`
  - Set `git config gpg.ssh.program=/Applications/1Password.app/Contents/MacOS/op-ssh-sign`
  - Set `git config user.signingkey` to the SSH public key
  - Create the file `~/.ssh/allowed_signers` (when using this repo, will be symlinked from `~/.dotfiles/.ssh/allowed_signers`)
  - For each signing key, add a single line to the `~/.ssh/allowed_signers` specifying the combination of `git config user.email` and `git config user.signingkey`, in that order

## General productivity

- [1Password](https://1password.com/) (Mac App Store)
- [Backblaze](https://www.backblaze.com/) (Homebrew Cask or direct download)
- [Bear](https://bear.app) (Mac App Store)
- [Brave](https://brave.com/)
  - Brave profiles for each context (personal/work, different AWS accounts, etc)
  - [Brave sync](https://support.brave.com/hc/en-us/articles/360059793111-Understanding-Brave-Sync)
  - 1Password extension for desktop app
  - [DuckDuckGo Privacy Essentials](https://github.com/duckduckgo/duckduckgo-privacy-extension)
  - [SimpleLogin](https://simplelogin.io/) email alias generator ([SimpleLogin joined Proton](https://proton.me/blog/proton-and-simplelogin-join-forces) and now offers [sign in with Proton](https://proton.me/support/create-simplelogin-account-proton-account))
  - [Vue.js DevTools](https://github.com/vuejs/vue-devtools)
  - [Dark Reader](https://darkreader.org)
  - [Stylus](https://github.com/openstyles/stylus)
    - [Wide GitHub](https://github.com/xthexder/wide-github)
    - [GitHub Custom Fonts](https://github.com/StylishThemes/GitHub-Dark)
    - ~~[GitHub Dark](https://github.com/StylishThemes/GitHub-Dark)~~ _(GitHub [finally](https://github.blog/2020-12-08-new-from-universe-2020-dark-mode-github-sponsors-for-companies-and-more/) has a native dark mode!)_
    - [GitLab Dark](https://gitlab.com/maxigaz/gitlab-dark)
    - [Wikipedia Dark](https://github.com/n0x-styles/wikipedia-dark)
- macOS Keynote, Numbers, and Pages
- [Proton VPN](https://protonvpn.com/) (Homebrew Cask or direct download)

## Media

- [Audacity](https://www.audacityteam.org/)
- [HandBrake](https://handbrake.fr/)
- [Plex](https://www.plex.tv/) media server
- [VLC](https://www.videolan.org/vlc/) media player

## Science

- [Zotero](https://www.zotero.org/)

[(Back to top)](#top)
