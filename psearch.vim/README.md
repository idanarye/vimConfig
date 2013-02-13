## PSearch.vim

**v0.1.0**


### Overview

This plugin shows a preview of all the lines where your search
pattern matches in the current file. 

![Screenshot](/extra/screenshot.png "A view of the plugin at work")  

To open the preview window use the `PSearch` command. As you start typing into
the special command line you'll see the preview window updating automatically.

Note that you are allowed to use any pattern that would work with the `/` and
`?` vim commands.

Below there is list of all the mappings you can use to interact with the window:

* `UP`, `CTRL+K`: move up in the list.
* `DOWN`, `CTRL+J`: move down in the list.
* `RETURN`, `CTRL+G`: go to the selected match.
* `ESC`, `CTRL+C`: close the matches list.
                              


## Requirements

* Vim 7.2+
* Vim compiled with python 2.6+


## Installation

Extract the content of the folder into the `$HOME/.vim` directory or use your favourite
plugin manager.



## Commands

### PSearch

Opens the preview window. Type something and the window will update
automatically with all the search matches for the current file.

### PSearchw

As the `PSearch` command but uses the word under cursor for the search.
(Equal to the vim `*` mapping)


## Settings

### g:pse_max_height

With this setting you can set the maximum height for the window opened with 
the `PSearch` command.

default: 15


### g:pse_prompt

With this setting you can customize the look of the prompt used by the
`PSearch` command.

default: ' ❯ '


## Changelog

### v0.1.0

* first release
