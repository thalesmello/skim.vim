fzf.vim
=======

A set of [fzf][fzf]-based Vim commands.

Rationale
---------

[fzf][fzf] in itself is not a Vim plugin, and the official repository only
provides the [basic wrapper function][run] for Vim and it's up to the users to
write their own Vim commands with it. However, I've learned that many users of
fzf are not familiar with Vimscript and are looking for the "default"
implementation of the features they can find in the alternative Vim plugins.

This repository is a bundle of fzf-based commands extracted from my
[.vimrc][vimrc] to address such needs. The commands are opinionated and not
designed to be extremely flexible or configurable, and they are not guaranteed
to be backward-compatible.

Installation
------------

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
```

List of commands
----------------

| Command        | List                                                                      |
| ---            | ---                                                                       |
| `Buffers`      | Open buffers                                                              |
| `Colors`       | Color schemes                                                             |
| `Ag [PATTERN]` | [ag][ag] search result (`CTRL-A` to select all, `CTRL-D` to deselect all) |
| `Lines`        | Lines in loaded buffers                                                   |
| `Tags`         | Tags in the project (`ctags -R`)                                          |
| `BTags`        | Tags in the current buffer                                                |
| `Locate PATH`  | `locate` command output                                                   |
| `History`      | `v:oldfiles` and open buffers                                             |

- All commands except `Colors` support `CTRL-T` / `CTRL-X` / `CTRL-V` key
  bindings to open in a new tab, a new split, or in a new vertical split.
- Bang-versions of the commands (e.g. `Ag!`) will open fzf in fullscreen

Customization
-------------

```vim
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tabedit',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
```

License
-------

MIT

[fzf]:   https://github.com/junegunn/fzf
[run]:   https://github.com/junegunn/fzf#usage-as-vim-plugin
[vimrc]: https://github.com/junegunn/dotfiles/blob/master/vimrc
[ag]:    https://github.com/ggreer/the_silver_searcher