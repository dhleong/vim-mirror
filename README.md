vim-mirror
==========

*Simple, smart, auto-closing tags*

## What?

vim-mirror is a plugin for Vim, inspired by [vim-closer][1], but designed to be more flexible and extensible.

## Interactions with cmp

If you use [cmp][cmp], you may need to eagerly set the mapping for `<cr>` so that it gets picked up consistently. Simply put:

```vim
imap <CR> <CR><Plug>MirrorClose
```

in your vim config somewhere.

[1]: https://github.com/rstacruz/vim-closer
[cmp]: https://github.com/hrsh7th/nvim-cmp
