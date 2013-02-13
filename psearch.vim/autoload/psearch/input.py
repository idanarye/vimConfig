# -*- coding: utf-8 -*-
"""
psearch.input
~~~~~~~~~~~~~

This module defines the class responsible for handling the input coming
from the user.
"""

import vim


class Input:

    def __init__(self):
        self.reset()

    def reset(self):
        self.LEFT = self.RIGHT = self.UP = self.DOWN = self.BS = None
        self.RETURN = self.ESC = self.TAB = None
        self.MOUSE = self.CTRL = self.INTERRUPT = None
        self.CHAR = None
        vim.command("let g:pse_launcher_char = ''")
        vim.command("let g:pse_launcher_interrupt = 0")

    def get(self):
        """To read the key pressed by the user."""
         # FIX: not so cool, but the usual try/except python statement
         # seems not catching the KeyboardInterrupt exception. This is the
         # only way to get the laucher closed with ctrl+c.
        vim.command("""
            try |
             let g:pse_launcher_char = getchar() |
            catch |
             let g:pse_launcher_interrupt = 1 |
            endtry
        """)

        if vim.eval('g:pse_launcher_interrupt') == '1':
            self.INTERRUPT = True  # Ctrl + c
            return
        else:
            raw_char = vim.eval('g:pse_launcher_char')

        nr = int(vim.eval("str2nr('{0}')".format(raw_char)))
        if nr != 0:
            if nr == 13:
                self.RETURN = True
            elif nr == 27:
                self.ESC = True
            elif nr == 9:
                self.TAB = True
            elif 1 <= nr <= 26:
                self.CTRL = True
                self.CHAR = vim.eval("nr2char({0})".format(nr + 96))
            else:
                self.CHAR = vim.eval("nr2char({0})".format(nr))
        else:
            # Remove the first character 0x80
            c = vim.eval("strpart('{0}', 1)".format(raw_char))
            if c == 'kl':
                self.LEFT = True
            elif c == 'kr':
                self.RIGHT = True
            elif c == 'ku':
                self.UP = True
            elif c == 'kd':
                self.DOWN = True
            elif c == 'kb':  # backspace
                self.BS = True
            elif c == 'k1':
                self.F1 = True
            elif c == 'k2':
                self.F2 = True
            elif c == 'k3':
                self.F3 = True
            elif c == 'k4':
                self.F4 = True
            elif c == 'k5':
                self.F5 = True
            elif c == 'k6':
                self.F6 = True
            elif c == 'k7':
                self.F7 = True
            elif c == 'k8':
                self.F8 = True
            elif c == 'k9':
                self.F9 = True
            elif c == 'k10':
                self.F10 = True
            elif c == 'k11':
                self.F11 = True
            elif c == 'k12':
                self.F12 = True
            else:
                # mouse clicks or scrolls
                self.MOUSE = True
