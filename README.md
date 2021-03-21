# Dotfiles

Brendon Smith ([br3ndonland](https://github.com/br3ndonland))

## Table of Contents <!-- omit in toc -->

- [Installation](#installation)
- [Hardware](#hardware)
- [macOS](#macos)
- [Homebrew package management](#homebrew-package-management)
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
  - [ProtonMail](#protonmail)
- [SSH](#ssh)
- [General productivity](#general-productivity)
- [Media](#media)
- [Science](#science)

## Installation

Dotfiles are application configuration and settings files. They frequently begin with a dot, hence the name. This dotfiles repository is meant to be installed by _[bootstrap.sh](bootstrap.sh)_.

_bootstrap.sh_ is a shell script to automate setup of a new macOS development machine. It is _idempotent_, meaning it can be run repeatedly on the same system. To set up a macOS development machine, simply open a terminal, set the environment variables `STRAP_GIT_EMAIL`, `STRAP_GIT_NAME`, and `STRAP_GIT_USER` (GitHub username), and run the following command:

```sh
/usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/br3ndonland/dotfiles/HEAD/bootstrap.sh)"
```

_bootstrap.sh_ will set up macOS and Homebrew, run scripts in the _script/_ directory, and install Homebrew packages and casks from the _[Brewfile](Brewfile)_.

A Brewfile is a list of [Homebrew](https://brew.sh/) packages and casks (applications) that can be installed in a batch by [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle). The Brewfile can even be used to install Mac App Store apps with the `mas` CLI. Note that you must sign in to the App Store ahead of time for `mas` to work.

## Hardware

- [Apple Silicon M1](https://www.apple.com/mac/m1/) Mac mini
- [Dell S3221QS 32" curved 4K monitor](https://www.amazon.com/dp/B08G8WMRRP)
- [Seagate external hard drives](https://www.amazon.com/dp/B07MY44VNM)
- [Microsoft Sculpt](https://www.amazon.com/dp/B00CYX26BC) and [Dygma Raise](https://dygma.com/) keyboards
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

- macOS setup is automated with _[macos.sh](script/macos.sh)_.
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

- [Homebrew](https://brew.sh/) is a package manager that includes [Homebrew-Cask](https://caskroom.github.io/) to manage other macOS applications.
- See the Homebrew [docs](https://docs.brew.sh) for further info.
- My list of Homebrew packages and casks is available in my [homebrew-brewfile repo](https://github.com/br3ndonland/homebrew-brewfile), and engineered for use with [strap](https://github.com/MikeMcQuaid/strap).
- The Brewfile works with [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) to manage all Homebrew packages and casks together.
- Key Brew Bundle commands:

  ```sh
  # Install everything in the Brewfile
  brew bundle install --global
  # Check for programs listed in Brewfile
  brew bundle check --global
  # Remove any Homebrew packages and casks not in Brewfile
  brew bundle cleanup --force --global
  ```

## Shell

- I use Zsh as my shell, which functions like Bash but offers more customization.
- I install with Homebrew to maintain consistent versions across multiple machines. However, note that [Zsh is now the default shell for new macOS users starting with macOS Catalina](https://support.apple.com/en-us/HT208050).
- See the [Wes Bos Command Line Power User course](https://commandlinepoweruser.com/) for an introduction to Zsh.
- For my Zsh prompt, I use either [pure prompt](https://github.com/sindresorhus/pure) or [zsh4humans](https://github.com/romkatv/zsh4humans) with [powerlevel10k](https://github.com/romkatv/powerlevel10k).
- For my terminal application, I use [kitty](https://github.com/kovidgoyal/kitty), a GPU-based terminal emulator.

## Text editors

### VSCode desktop

I write code with [VSCodium](https://github.com/VSCodium/vscodium), an alternate build of [Microsoft Visual Studio Code](https://code.visualstudio.com/) (VSCode) that is free of proprietary features and telemetry. To work on servers via SSH, I use [Pony SSH](https://github.com/thingalon/pony-ssh).

I previously configured VSCode and VSCodium using the [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) extension. I now have my settings, keybindings, and extensions stored here in my dotfiles repo. Extensions can be installed by running _[vscode-extensions.sh](script/vscode-extensions.sh)_ along with the name of the editor, like `vscode-extensions.sh codium`. The shell script was quite easy to write. I based it on _[npm-globals.sh](script/npm-globals.sh)_, and used the [VSCode extension CLI](https://code.visualstudio.com/docs/editor/extension-gallery).

### VSCode browser

#### codespaces

- I have tried GitHub's cloud-hosted VSCode, called [Codespaces](https://docs.github.com/en/free-pro-team@latest/github/developing-online-with-codespaces). So far, I don't like it because:
  - After the beta, I will have to pay GitHub to use it.
  - Keybindings conflict with browser keybindings. I can't open the command palette from the keyboard, because Cmd+shift+p is already in use by the browser.
  - Changing the workbench theme doesn't seem to work. All I get is the blinding light theme. I'm blinded by the light.
  - I don't know how I would approach [GPG](#gpg)-signing Git commits. I might be able to use [SSH agent forwarding](https://docs.github.com/en/free-pro-team@latest/developers/overview/using-ssh-agent-forwarding), but I'm not sure.
  - I don't know if or how persistent file storage is available.
  - I don't know how to install proprietary custom fonts (like [Dank Mono](https://gumroad.com/l/dank-mono))
  - I don't know how to install proprietary extensions (like [Dracula Pro](https://draculatheme.com/pro))

#### code-server

- [code-server](https://github.com/cdr/code-server) is an open-source alternative to codespaces.
- I set up code-server on a Linux cloud server. I prefer to use DigitalOcean, following their [recommended initial setup guide](https://www.digitalocean.com/docs/droplets/tutorials/recommended-setup/) for "droplets" (VMs):
  - Set up [SSH agent forwarding](https://docs.github.com/en/free-pro-team@latest/developers/overview/using-ssh-agent-forwarding) on local machine to avoid having to deposit SSH private keys on droplet
  - Add SSH public key when creating droplet
  - Add a user data script like _[linux-userdata-do.sh](script/linux-userdata-do.sh)_
- [Installation](https://github.com/cdr/code-server/blob/v3.7.2/doc/install.md) and [setup](https://github.com/cdr/code-server/blob/v3.7.2/doc/guide.md) on the server:

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
  - The clipboard doesn't completely work. See [cdr/code-server#1106](https://github.com/cdr/code-server/issues/1106).
  - The font can't yet be customized directly. See [cdr/code-server#1374](https://github.com/cdr/code-server/issues/1374).
  - You can change the color theme, but you may need to re-select the theme each time you open a browser tab.

## Fonts

[Dank Mono](https://gumroad.com/l/dank-mono) is my programming font of choice. The rounded characters are eminently readable, the italics are elegant, and the ligatures are intuitive. [Recursive Mono](https://www.recursive.design/), [Fira Code](https://github.com/tonsky/FiraCode), and [Ubuntu Mono](https://design.ubuntu.com/font/) are decent free alternatives.

## Language-specific setup

### JavaScript

- [node](https://nodejs.org/en/) is a JavaScript runtime used to run JavaScript outside of a web browser.
- [npm](https://www.npmjs.com/) is a package manager written in node.js, included when node is installed.
  - It's difficult to keep track of global npm packages. There's no easy way to do it with the usual _package.json_. As Isaac Schlueter [commented](https://github.com/npm/npm/issues/2949#issuecomment-11408461) in 2012,
    > Yeah, we're never going to do this.
  - Instead, package names can be specified in a text file, _[npm-globals.txt](js/npm-globals.txt)_, and installed with a shell script, _[npm-globals.sh](script/npm-globals.sh)_. Global npm packages will be installed in _/usr/local/lib/node_modules_. Note that `sudo` permissions may be required to run the script.
  - [npm-check](https://www.npmjs.com/package/npm-check) can be used to manage global packages after install, with `npm-check -ug`. If not using npm-check, a list of global npm packages can be seen after installation with `npm list -g --depth=0`.
- I use the [Prettier](https://prettier.io/) autoformatter and the [Prettier VSCode extension](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) to format my web code, including JavaScript and Vue.js. Prettier is an extremely helpful productivity tool, and I highly recommend it. Autoformatters save time and prevent [bikeshedding](https://www.freebsd.org/doc/en/books/faq/misc.html#idp50244984).
- ESLint notes:

  - Compared with Prettier, ESLint formats less code languages, requires complicated setup, and doesn't work well when installed globally. I previously attempted to use a global ESLint installation with the [VSCode ESLint extension](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint), but was getting errors about plugins. As the ESLint docs explain:
    > It is also possible to install ESLint globally rather than locally (using `npm install eslint --global`). However, this is not recommended, and any plugins or shareable configs that you use must be installed locally in either case.
  - The errors persist even after specifying the path to global npm packages:

    ```jsonc
    // VSCode settings.json
    {
      "eslint.nodePath": "/usr/local/lib/node_modules"
    }
    ```

  - If ESLint and plugins are installed in the project directory, the following settings can be added to the VSCode _settings.json_, for use with the [VSCode ESLint extension](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) and [eslint-plugin-vue](https://eslint.vuejs.org/user-guide/). I typically don't use ESLint to auto-fix files, because Pretter is preferred.

    ```jsonc
    // VSCode settings.json
    {
      "eslint.autoFixOnSave": false,
      "eslint.enable": true,
      "eslint.validate": ["javascript", "javascriptreact", "vue"]
    }
    ```

  - I do still retain a global _.eslintrc_ in my dotfiles repo, because it is a useful template for sensible defaults.

- In the past, I also used [JavaScript Standard Style](https://standardjs.com/) (aka StandardJS). Standard Style has also [reportedly](https://changelog.com/podcast/359) been favored by Brendan Eich (creator of JavaScript) and Sir Tim Berners-Lee (creator of the World Wide Web). Prettier provides a similar code style, but with more features, so I use Prettier instead.

### Python

- **I format Python code with [Black](https://black.readthedocs.io/en/stable/).**
  - VSCode provides built-in support for Black. I set VSCode to autoformat on save.
  - Black is still considered a pre-release.
  - If you prefer the less-decisive PEP 8 format, I recommend [autopep8](https://pypi.org/project/autopep8/) for autoformatting. VSCode also has built-in [Python formatting](https://code.visualstudio.com/docs/python/editing#_formatting) support for autopep8.
- See my [template-python](https://github.com/br3ndonland/template-python) repo for useful tooling and additional sensible defaults.

## PGP

- I use [Gnu Privacy Guard](https://www.gnupg.org/) (GPG, the free implementation of Pretty Good Privacy (PGP)), [Keybase](https://keybase.io), and [ProtonMail](https://protonmail.com/) to encrypt and share messages, passwords, and other sensitive info.
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
  - _~/.gnupg/gpg-agent.conf:_ `pinentry-program /opt/homebrew/bin/pinentry`
  - The path apparently has to be absolute, so it may vary by system.
  - See the [GPG agent options docs](https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html) for more.
- [Export the `GPG_TTY` environment variable](https://www.gnupg.org/documentation/manuals/gnupg/Agent-Examples.html): `export GPG_TTY=$(tty)` (can add to shell profile to automatically export). Note that this is not the same thing as `export GPG_TTY=$TTY`, which may raise cryptic `Inappropriate ioctl for device` errors.
- Ensure proper permissions are set on GPG config files:
  ```sh
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/gpg.conf
  ```
- See the [GPG configuration docs](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration.html) for more.

#### Key generation

- Run `gpg --full-generate-key` from the command line to generate a key. Respond to the command-line prompts. The maximum key size of `4096` is recommended.
- View keys with `gpg --list-secret-keys`.
- Run `gpg --send-keys <keynumber>` to share the public key with the GPG database. It takes about 10 minutes for the key to show up in the GPG database.
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

- Restart the agent: `gpgconf --kill gpg-agent` or `gpgconf --kill all`. See the [GPG docs on invoking `gpg-agent`](https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html).
- Verify GPG signing capabilities: `echo "test" | gpg --clearsign`
- Trust GPG keys using the GPG TTY interface:
  - If you see `gpg: WARNING: This key is not certified with a trusted signature!` when examining signed Git commits with `git log --show-signature`, you may want to trust the keys.
  - Enter the GPG key editor from the command line with `gpg --edit-key <PGPkeyid>`.
  - Set trust level for the key by typing `trust`, and entering a trust level.
  - See the [GPG docs](https://www.gnupg.org/gph/en/manual/x334.html) for more info.
- [GitHub GPG instructions](https://help.github.com/articles/signing-commits-with-gpg/)
- [GitLab GPG instructions](https://gitlab.com/help/user/project/repository/gpg_signed_commits/index.md)
- If working on a server, you can use [ssh agent forwarding](https://docs.github.com/en/free-pro-team@latest/developers/overview/using-ssh-agent-forwarding) to access your SSH and GPG keys without having to copy them.

### Keybase

**UPDATE: Keybase was acquired by Zoom, and its future is uncertain.**

- [Zoom Blog 20200507: Zoom acquires Keybase and announces goal of developing the most broadly used enterprise end-to-end encryption offering](https://blog.zoom.us/wordpress/2020/05/07/zoom-acquires-keybase-and-announces-goal-of-developing-the-most-broadly-used-enterprise-end-to-end-encryption-offering/)
- [Keybase Blog 20200507: Keybase joins Zoom](https://keybase.io/blog/keybase-joins-zoom)
- [The Verge 20200507: Zoom buys the identity service Keybase as part of 90-day security push](https://www.theverge.com/2020/5/7/21250418/zoom-keybase-acquisition-encryption-security-messages-services)

#### Useful features

- **PGP key and identity management** (see [below](#keybase-pgp))
- **Chat** (see [below](#keybase-chat))
- **Teams**: see [Keybase Book: Teams](https://book.keybase.io/teams), and blog posts on [teams](https://keybase.io/blog/introducing-keybase-teams) and [updates to teams](https://keybase.io/blog/new-team-features).
- **Encrypted files**: Keybase file system (KBFS). Like an encrypted Dropbox or Google Drive cloud storage system. Integrates with the macOS finder through use of the [FUSE for macOS](https://osxfuse.github.io/) package.
- Git (see [below](#keybase-git))
- See [Keybase docs](https://keybase.io/docs) for more.

#### Keybase PGP

##### Background

- **Keybase solves the key identity problem.**
  - Even if you have someone's public PGP key, you can't verify it actually came from them unless you exchange it in person.
  - Keybase provides a unified identity for verification of PGP keys. Each device gets its own private key, and they share identity.
  - It was previously challenging to move PGP keys among devices, but now it can be accomplished simply by signing in to Keybase.
- [Following](https://book.keybase.io/docs/server) someone is a way of verifying their cryptographic identity, not a way of subscribing to updates from the person like social media. I think calling this "following" is confusing. It's really more like verifying.
- Keybase uses the [NaCl](https://nacl.cr.yp.to/) (salt) library for encryption, which turned out to be a great choice. It's been stable and has avoided vulnerabilities. They also used Go to build many of the features.
- The Keybase database is represented as a merkle tree. See [Keybase docs: server security](https://book.keybase.io/docs/server) and [Wikipedia](http://en.wikipedia.org/wiki/Merkle_tree).
- Keybase doesn't directly run on blockchain, but they do [push the Keybase merkle root to the Bitcoin blockchain](https://book.keybase.io/docs/server) for verification.
- The [Software Engineering Daily podcast episode with Max Krohn from 2017-10-24](https://softwareengineeringdaily.com/2017/10/24/keybase-with-max-krohn/) has more helpful explanation.

##### Info

- To see available commands, run `keybase help pgp` or see the [command-line docs](https://book.keybase.io/docs/cli).
- Manage GPG/PGP keys in Keybase from the command line with `keybase pgp`.
- List keys with `keybase pgp list`.
- Generate a new PGP key with `keybase pgp gen`.

  - If you already have a key, add the `--multi` flag, like `keybase pgp gen --multi`.
  - You will be prompted with several options. I set a password on my key to keep it secure. Storing the private key on the keybase.io servers is a contentious option, because it hypothetically [could put the key at risk](https://github.com/keybase/keybase-issues/issues/160). However, I agree with [this comment](https://github.com/keybase/keybase-issues/issues/160#issuecomment-518472677): if you don't trust Keybase, don't use Keybase. From what I understand, if you select `Push an encrypted copy of your new secret key to the Keybase.io server? [Y/n] Y` during `keybase pgp gen`, it will have the same ultimate effect as `keybase pgp push-private`. Here are the important options for key management:

    ```sh
    # Generate a PGP key (Keybase will automatically export it to GPG)
    keybase pgp gen
    # Sync PGP key with Keybase using Keybase servers
    keybase pgp push-private 16digit_PGPkeyid
    # Export PGP key from Keybase to GPG using Keybase servers
    keybase pgp pull-private 16digit_PGPkeyid
    # Manual export of public key from Keybase to GitHub
    keybase pgp export -q key_id | pbcopy  # then go to GitHub settings and paste
    # Manual export of public key from Keybase to GPG
    keybase pgp export -q 16digit_PGPkeyid | gpg --import
    # Manual export of private key to GPG
    keybase pgp export -q 16digit_PGPkeyid --secret | gpg --allow-secret-key-import --import
    ```

  - If none of the Keybase methods work, try GPG. On the source computer where the GPG private keys are stored, export to a synced directory:

    ```sh
    mkdir -p /path/to/.keys
    gpg -a --export > /path/to/.keys/pubkeys.asc
    gpg -a --export-secret-keys > /path/to/.keys/privatekeys.asc
    # import from the synced directory on the destination computer:
    gpg --import /path/to/.keys/privatekeys.asc
    ```

#### Keybase chat

**Keybase chat looks and feels like Slack, but has several advantages.**

- [Keybase is open-source](https://github.com/keybase/client). Slack is not.
- [Keybase chat is end-to-end encrypted](https://book.keybase.io/chat). Slack is not.
- Keybase chat does not have a free message limit. Slack does. I frequently hit this free message limit when participating in large workspaces for my courses on Udacity, and it negatively impacted my ability to build projects with classmates. We switched to a Keybase team instead.
- Keybase has not leaked passwords. [Slack has been vulnerable to password leaks and other attacks](https://slackhq.com/march-2015-security-incident-and-the-launch-of-two-factor-authentication), and it took Slack four years before they notified users. [The Keybase CEO's Slack credentials were compromised](https://keybase.io/blog/slack-incident).
- Keybase does not use third-party trackers, but Slack is polluted with trackers. Try running slack in the Brave browser. You'll probably see "99+" trackers blocked.

#### Keybase crypto

Keybase provides useful [cryptographic tools](https://keybase.io/blog/crypto) for PGP encrypting and decrypting files. One common use case is storing credentials in encrypted files. Here's how to improve security when [configuring Docker for use with GitHub Packages](https://docs.github.com/en/free-pro-team@latest/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages), by storing the [Personal Access Token (PAT)](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) in an encrypted file:

```sh
# create PAT on GitHub and copy to clipboard

# transfer PAT from clipboard to encrypted file
pbpaste | keybase encrypt -o pat-ghcr.asc $YOUR_USERNAME

# decrypt and log in
keybase decrypt -i pat-ghcr.asc | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# can also use keybase pgp encrypt and keybase pgp decrypt, but must export PGP key

```

#### Keybase Git

- Keybase allows users and teams to create and store end-to-end encrypted Git repositories. See the [Keybase Git docs](https://book.keybase.io/git) and [Keybase Git blog post](https://keybase.io/blog/encrypted-git-for-everyone).
- Treat Keybase Git repos as [remotes](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes) (like GitHub repos). They can be cloned, pushed, and pulled, as you would do for GitHub repos.

  ```sh
  git remote add keybase keybase://$PUBLIC_OR_PRIVATE/$USERNAME/$REPONAME
  git push keybase
  ```

- As of Keybase 5.1.0, [Git LFS](https://git-lfs.github.com/) is also enabled.
- **Keybase can't yet be used to sign Git commits**, as described [above](#signing-git-commits-with-gpg). The best method, as described [here](https://github.com/pstadler/keybase-gpg-github), is to export your PGP key from Keybase to GPG, and then sign Git commits with GPG. Eventually, I would like to set Keybase as the signing program in my _~/.gitconfig_ and skip the export to GPG.

  - _.gitconfig_ for GPG

    ```ini
    ...
    [commit]
    gpgsign = true
    [gpg]
    program = gpg
    ...
    ```

  - _.gitconfig_ for Keybase?

    ```ini
    ...
    [commit]
    pgpsign = true
    [pgp]
    program = keybase
    ...
    ```

- There has been some debate about the need to sign Git commits at all. Linus Torvalds has [recommended](http://git.661346.n2.nabble.com/GPG-signing-for-git-commit-td2582986.html) the use of `git tag -s` to sign with tags instead. The Keybase developers [sign releases with tags, but don't always sign commits](https://github.com/keybase/client/issues/3318) to the Keybase source code. However, in order to sign tags, you still need to set up commit signing, so why not just sign commits also? **Whether you sign all commits or just tags, Keybase should improve this feature.**

### ProtonMail

I use [ProtonMail](https://protonmail.com/) for PGP-encrypted email.

## SSH

- [Generate an SSH key and add it to the SSH agent](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/):

  ```sh
  ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/id_rsa_"$(whoami)"
  eval "$(ssh-agent -s)"
  ssh-add -K ~/.ssh/id_rsa_"$(whoami)"
  ```

- [Connect to GitHub with SSH](https://help.github.com/articles/connecting-to-github-with-ssh/). This allows your computer to send information to GitHub over an SSH connection, so you can push changes without having to provide your username and password every time. These steps will allow your computer to connect to GitHub with SSH, and should only need to be performed once for each machine.
  - [Add SSH key to GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/):
    - `pbcopy < ~/.ssh/id_rsa_"$(whoami)".pub`
    - Go to GitHub and paste the key.
  - [Check SSH connection](https://help.github.com/articles/testing-your-ssh-connection/):
    - `ssh -T git@github.com`
    - Verify output looks similar to output provided in the linked GitHub article, type `yes`, verify username.
- **If working on a server, you can use [ssh agent forwarding](https://docs.github.com/en/free-pro-team@latest/developers/overview/using-ssh-agent-forwarding) to access your SSH and GPG keys without having to copy them.**

  ```
  Host yourserver.com
    ForwardAgent yes
  ```

## General productivity

- [1Password](https://1password.com/) (Mac App Store)
- [Backblaze](https://www.backblaze.com/) (Homebrew Cask or direct download)
- [Bear](https://bear.app) (Mac App Store)
- [Firefox](https://www.mozilla.org/en-US/firefox/) (Homebrew Cask)
  - Firefox account: sync preferences and add-ons
  - 1Password extension for desktop app
  - [DuckDuckGo Privacy Essentials](https://github.com/duckduckgo/duckduckgo-privacy-extension)
  - [Vue.js DevTools](https://github.com/vuejs/vue-devtools)
  - [Dark Reader](https://darkreader.org) ([Mozilla recommended extension](https://support.mozilla.org/en-US/kb/recommended-extensions-program))
  - [Stylus](https://github.com/openstyles/stylus) (alternative to Dark Reader, also a [Mozilla recommended extension](https://support.mozilla.org/en-US/kb/recommended-extensions-program))
    - [GitHub Custom Fonts](https://github.com/StylishThemes/GitHub-Dark)
    - ~~[GitHub Dark](https://github.com/StylishThemes/GitHub-Dark)~~ _(GitHub [finally](https://github.blog/2020-12-08-new-from-universe-2020-dark-mode-github-sponsors-for-companies-and-more/) has a native dark mode!)_
    - [GitLab Dark](https://gitlab.com/maxigaz/gitlab-dark)
    - [Wikipedia Dark](https://github.com/n0x-styles/wikipedia-dark)
- macOS Keynote, Numbers, and Pages
- [ProtonVPN](https://protonvpn.com/) (Homebrew Cask or direct download)

## Media

- [Audacity](https://www.audacityteam.org/)
- [HandBrake](https://handbrake.fr/)
- [Jellyfin](https://jellyfin.org/) media server
- [VLC](https://www.videolan.org/vlc/) media player

## Science

- [Zotero](https://www.zotero.org/)

[(Back to top)](#top)
