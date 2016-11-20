# perltidy.vim

Automatically checks the project hierarchy stopping when reaching project indicators looking for a
.perltidyrc to use.

## Usage

Remap `=` to call `PerlTidy` instead of using Vim's builtin alignment.

```vim
au Filetype perl nmap = :PerlTidy<CR>
au Filetype perl vmap = :PerlTidy<CR>
```
