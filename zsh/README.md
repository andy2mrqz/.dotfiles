# zsh

## Setup

- Symlink dotfiles

```sh
  ln -s ~/Projects/.dotfiles/zsh/.zshrc ~/.zshrc
  ln -s ~/Projects/.dotfiles/zsh/.zprofile ~/.zprofile
```

## Migrating from oh-my-zsh

If you're using my dotfiles as a reference to save your soul from the slowness of oh-my-zsh (and/or nvm, etc.), here are some useful tips.

First, profile your existing setup using two complementary approaches.

You can get a good baseline for how fast your setup is by running `hyperfine --warmup 5 'zsh -i -c exit'` (hyperfine via brew).
Note this initial number - we are trying to get better than this!

Then, add the following to the top of your ~/.zshrc file to load the zprof profiling tool:

```zsh
zmodload zsh/zprof
```

And at the bottom, add:

```zsh
zprof
```

When you open a new tab or resource your ~/.zshrc, you'll see profiling output in your shell. Analyze that with your brain or
with your favorite coding agent to identify hotspots. It will be most satisfying for you to understand the exact parts of your
former, unoptimized setup that were causing the biggest slowdowns. Then, you can use my dotfiles as a guide for what things
might help you out on your journey. Again, your coding agent should be able to assist identifying optimizing opportunities (or
just doing all of them) if you get stuck and need help. Let me know if you find anything interesting or have suggestions for opportunities
in my setup, too!

## Useful links

- [zshenv vs zshrc vs zprofile vs ...](https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout)
