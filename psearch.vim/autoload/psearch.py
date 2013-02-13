# -*- coding: utf-8 -*-
"""
psearch.py
~~~~~~~~~~

Main class for the PSearch plugin.
"""

import os
import re
import sys
import vim
import bisect

sys.path.insert(0, os.path.split(
    vim.eval('fnameescape(globpath(&runtimepath, "autoload/psearch.py"))'))[0])

import psearch.utils.settings
import psearch.utils.misc
import psearch.input


class PSearch:

    def __init__(self):
        self.settings = psearch.utils.settings
        self.misc = psearch.utils.misc

        self.name = 'psearch.launcher'
        self.prompt = self.settings.get('prompt')
        self.input_so_far = ''
        self.launcher_win = None
        self.update_matches = True
        self.curr_pos = None
        self.curr_buf_pos = None
        self.curr_buf = None
        self.curr_buf_win = None
        self.orig_settings = {}
        self.mapper = {}
        self.max_height = self.settings.get('max_height', int)
        self.RE_MATH = re.compile('(\d+|\+|\*|\/|-)')

        # setup highlight groups
        vim.command('hi link PSearchLine String')
        vim.command('hi link PSearchDots Comment')
        vim.command('hi link PsearchMatches Search')

    def restore_old_settings(self):
        """Restore original settings."""
        for sett, val in self.orig_settings.items():
            vim.command('set {0}={1}'.format(sett, val))

    def reset_launcher(self):
        """To reset the launcher state."""
        self.input_so_far = ''
        self.launcher_win = None
        self.curr_pos = None
        self.curr_buf = None
        self.curr_buf_win = None

    def setup_buffer(self):
        """To setup buffer properties of the matches list window."""
        vim.command("setlocal buftype=nofile")
        vim.command("setlocal bufhidden=wipe")
        vim.command("setlocal encoding=utf-8")
        vim.command("setlocal nobuflisted")
        vim.command("setlocal noundofile")
        vim.command("setlocal nobackup")
        vim.command("setlocal noswapfile")
        vim.command("setlocal nowrap")
        vim.command("setlocal nonumber")
        vim.command("setlocal cursorline")
        self.orig_settings['laststatus'] = vim.eval('&laststatus')
        vim.command('setlocal laststatus=0')
        self.orig_settings['guicursor'] = vim.eval('&guicursor')
        vim.command("setlocal guicursor=a:hor5-Cursor-blinkwait100")

    def highlight(self):
        """To setup highlighting."""
        vim.command("syntax clear")
        vim.command('syn match PSearchLine /\%<6vLine:/')
        vim.command('syn match PSearchDots /\%<17v\.\.\./')
        vim.command('syn match PSearchMatches /\%>12v\c{0}/'
            .format(self.input_so_far.strip('\\')))

    def close_launcher(self):
        """To close the matches list window."""
        self.misc.go_to_win(self.launcher_win)
        vim.command('q')
        if self.curr_buf_win:
            self.misc.go_to_win(self.curr_buf_win)
        self.reset_launcher()

    def open_launcher(self):
        """To open the matches list window."""
        vim.command('silent! botright split {0}'.format(self.name))
        self.setup_buffer()
        return self.misc.bufwinnr(self.name)

    def search(self, target):
        """To search in the current buffer the given pattern."""
        matches = []
        if self.curr_buf_win and self.input_so_far:
            self.misc.go_to_win(self.curr_buf_win)
            orig_pos = vim.current.window.cursor
            vim.current.window.cursor = (1, 1)
            while True:
                line, col = vim.eval("searchpos('{0}', 'W')"
                    .format(self.input_so_far))
                line, col = int(line), int(col)
                if line == 0 and col == 0:
                    break
                matches.append((line, col, vim.current.buffer[line - 1]))

            vim.current.window.cursor = orig_pos

        self.misc.go_to_win(self.launcher_win)
        return matches

    def update_launcher(self):
        """To update the matches list content."""
        if not self.launcher_win:
            self.launcher_win = self.open_launcher()

        self.mapper.clear()
        self.misc.go_to_win(self.launcher_win)
        self.misc.set_buffer(None)

        # matches = [(line, col, line), ...]
        matches = self.search(self.input_so_far)

        if matches:
            pos = bisect.bisect_left(matches, self.curr_buf_pos)
            matches.insert(pos, self.curr_buf_pos)
            self.misc.set_buffer(
                [self.render_line(m, i) for i, m in enumerate(matches)])

            if self.update_matches:
                self.curr_pos = pos

            if self.curr_pos is not None:
                vim.current.window.cursor = (self.curr_pos + 1, 1)

            self.render_curr_line()
            self.highlight()

            matchesnr = len(matches)
            if matchesnr > self.max_height:
                vim.current.window.height = self.max_height
            else:
                vim.current.window.height = matchesnr

            vim.command("normal! zz")

        else:
            vim.command('syntax clear')
            self.misc.set_buffer([' nothing found...'])
            vim.current.window.height = 1
            self.curr_pos = 0

    def render_line(self, match, i):
        """To format a match displayed in the matches list window."""
        if len(match) == 2:
            return '  ------ * ------'.format(match[0])
        else:
            self.mapper[i] = match
            return '  Line: {0: <4}  ... {1}'.format(match[0], match[2])

    def render_curr_line(self):
        """To format the current line in the laucher window."""
        if self.curr_pos is None:
            self.curr_pos = len(vim.current.buffer) - 1
        line = vim.current.buffer[self.curr_pos]
        vim.current.buffer[self.curr_pos] = '▸ ' + line[2:]

    def go_to_selected_match(self):
        """To go to the selected match."""
        match = self.mapper.get(self.curr_pos)
        if match:
            if self.curr_buf_win:
                self.misc.go_to_win(self.curr_buf_win)
            vim.current.window.cursor = (match[0], match[1] - 1)
            vim.command("normal! zz")

            return True

    def open(self, word_under_cursor):
        """To open the launcher."""

        if word_under_cursor:
            self.input_so_far = word_under_cursor

        self.curr_buf = vim.current.buffer
        self.curr_buf_win = self.misc.winnr()
        self.curr_buf_pos = vim.current.window.cursor

        # This first call opens the list of matches even though the user
        # didn't give any character as input
        self.update_launcher()
        self.misc.redraw()

        input = psearch.input.Input()
        # Start the input loop
        while True:
            self.update_matches = False

            # Display the prompt and the text the user has been typed so far
            vim.command("echo '{0}{1}'".format(self.prompt, self.input_so_far))

            # Get the next character
            input.reset()
            input.get()

            if input.RETURN or input.CTRL and input.CHAR == 'g':
                if self.go_to_selected_match():
                    self.close_launcher()
                    break

            elif input.BS:
                # This acts just like the normal backspace key
                self.input_so_far = self.input_so_far[:-1]
                self.update_matches = True
                # Reset the position of the selection in the matches list
                # because the list has to be rebuilt
                self.curr_pos = None

            elif input.ESC or input.INTERRUPT:
                # The user want to close the launcher
                self.close_launcher()
                self.misc.redraw()
                break

            elif input.UP or input.CTRL and input.CHAR == 'k':
                # Move up in the matches list
                last_index = len(vim.current.buffer) - 1
                if self.curr_pos == 0:
                    self.curr_pos = last_index
                else:
                    self.curr_pos -= 1

            elif input.DOWN or input.CTRL and input.CHAR == 'j':
                # Move down in the matches list
                last_index = len(vim.current.buffer) - 1
                if self.curr_pos == last_index:
                    self.curr_pos = 0
                else:
                    self.curr_pos += 1

            elif input.CHAR:
                # A printable character has been pressed. We have to remember
                # it so that in the next loop we can display exactly what the
                # user has been typed so far
                self.input_so_far += input.CHAR
                self.update_matches = True

                # Reset the position of the selection in the matches list
                # because the list has to be rebuilt
                self.curr_pos = None

            else:
                self.misc.redraw()
                continue

            self.update_launcher()

            # Clean the command line
            self.misc.redraw()

        self.restore_old_settings()
