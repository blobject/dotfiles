# qutebrowser config, emacs-like

c.confirm_quit = ['always']
c.history_gap_interval = 30
c.new_instance_open_target = 'tab'
c.session.lazy_restore = True
c.backend = 'webengine'
c.qt.args = ['--enable-gpu-rasterization', 'enable-native-gpu-memory-buffers', 'ignore-gpu-blocklist']
c.qt.force_platform = None
c.qt.process_model = 'process-per-site'
c.qt.low_end_device_mode = 'auto'
c.qt.highdpi = True
c.auto_save.interval = 30000
c.auto_save.session = True
c.content.autoplay = False
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')
c.content.default_encoding = 'utf-8'
c.content.fullscreen.window = True
c.content.fullscreen.overlay_timeout = 2000
c.content.desktop_capture = 'ask'
c.content.geolocation = False
c.content.headers.accept_language = 'en-US,en;q=0.9'
c.content.headers.custom = {
  'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
}
c.content.headers.do_not_track = True
c.content.headers.user_agent = 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {qt_key}/{qt_version} {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}'
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version} Edg/{upstream_browser_version}', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')
config.set('content.media.audio_capture', True, 'https://cuni-cz.zoom.us')
config.set('content.media.audio_capture', True, 'https://us04web.zoom.us')
config.set('content.media.audio_video_capture', True, 'https://cuni-cz.zoom.us')
config.set('content.media.audio_video_capture', True, 'https://us04web.zoom.us')
config.set('content.media.video_capture', True, 'https://cuni-cz.zoom.us')
config.set('content.media.video_capture', True, 'https://us04web.zoom.us')
config.set('content.notifications', True, 'https://mail.google.com')
config.set('content.notifications', True, 'https://us04web.zoom.us')
config.set('content.notifications', True, 'https://www.youtube.com')
c.content.pdfjs = True
c.content.persistent_storage = 'ask'
config.set('content.register_protocol_handler', True, 'https://mail.google.com?extsrc=mailto&url=%25s')
c.completion.show = 'always'
c.completion.shrink = False
c.completion.scrollbar.width = 8
c.completion.scrollbar.padding = 0
c.completion.timestamp_format = '%Y-%m-%d'
c.downloads.location.directory = '/home/b/got/'
c.downloads.position = 'bottom'
c.downloads.remove_finished = -1
c.editor.command = ['emacs', '--file', '{file}']
c.hints.padding = {'bottom': 0, 'left': 2, 'right': 2, 'top': 0}
c.hints.radius = 0
c.hints.chars = 'hsntrieao'
c.hints.prev_regexes = ['\\bprev(ious)?\\b', '\\bback\\b', '\\bolder\\b', '\\b[<←≪]\\b', '\\b(<<|«)\\b']
c.hints.scatter = False
c.hints.uppercase = False
c.input.insert_mode.auto_load = True
c.input.partial_timeout = 8000
c.keyhint.radius = 0
c.keyhint.delay = 500
c.messages.timeout = 5000
c.prompt.radius = 0
c.scrolling.bar = 'overlay'
c.spellcheck.languages = []
c.statusbar.show = 'always'
c.statusbar.padding = {'bottom': 0, 'left': 0, 'right': 0, 'top': 0}
c.statusbar.position = 'top'
c.tabs.background = True
c.tabs.close_mouse_button = 'middle'
c.tabs.close_mouse_button_on_bar = 'new-tab'
c.tabs.favicons.show = 'always'
c.tabs.last_close = 'blank'
c.tabs.mousewheel_switching = False
c.tabs.new_position.related = 'next'
c.tabs.new_position.unrelated = 'next'
c.tabs.padding = {'bottom': 0, 'left': 0, 'right': 2, 'top': 0}
c.tabs.mode_on_change = 'normal'
c.tabs.position = 'top'
c.tabs.select_on_remove = 'last-used'
c.tabs.show = 'always'
c.tabs.show_switching_delay = 1000
c.tabs.title.alignment = 'left'
c.tabs.title.format = '{index}: {audio}{current_title}'
c.tabs.title.format_pinned = '{index}'
c.tabs.width = '10%'
c.tabs.min_width = 135
c.tabs.max_width = -1
c.tabs.indicator.width = 3
c.tabs.indicator.padding = {'bottom': 6, 'left': 0, 'right': 1, 'top': 2}
c.tabs.pinned.shrink = True
c.tabs.pinned.frozen = False
c.tabs.undo_stack_size = 512
c.tabs.wrap = True
c.tabs.focus_stack_size = 64
c.url.searchengines = {
  'DEFAULT': 'https://duckduckgo.com/?q={}',
  'd': 'https://en.wiktionary.org/wiki/{}',
  'e': 'https://www.etymonline.com/search?q={}',
  'g': 'https://www.google.com/search?q={}',
  'i': 'https://www.google.com/search?tbm=isch&q={}',
  'l': 'https://translate.google.com/#view=home&op=translate&sl=auto&tl=auto&text={}',
  'm': 'https://www.google.com/maps/search/{}',
  't': 'https://www.thesaurus.com/browse/{}',
  'u': 'https://www.urbandictionary.com/define.php?term={}',
  'w': 'https://en.wikipedia.org/w/index.php?search={}&title=Special:Search',
  'y': 'https://www.youtube.com/results?search_query={}',
}
c.url.start_pages = 'https://start.duckduckgo.com'
c.url.yank_ignored_parameters = ['ref', 'utm_source', 'utm_medium', 'utm_campaign', 'utm_term', 'utm_content']
c.window.hide_decoration = False
c.window.title_format = '{perc}{current_title}{title_sep}qutebrowser'
c.zoom.default = '100%'
c.zoom.levels = ['25%', '33%', '50%', '67%', '75%', '90%', '100%', '110%', '125%', '150%', '175%', '200%', '250%', '300%', '400%', '500%']
c.zoom.mouse_divider = 512
c.colors.completion.fg = ['#b9bdc5', '#b9bdc5', '#92959d']
c.colors.completion.odd.bg = '#2e3137'
c.colors.completion.even.bg = '#36383f'
c.colors.completion.category.fg = '#b9bdc5'
c.colors.completion.category.bg = '#16161d'
c.colors.completion.category.border.top = '#16161d'
c.colors.completion.category.border.bottom = '#16161d'
c.colors.completion.item.selected.fg = 'white'
c.colors.completion.item.selected.bg = '#3c56aa'
c.colors.completion.item.selected.border.top = '#3c56aa'
c.colors.completion.item.selected.border.bottom = '#3c56aa'
c.colors.completion.item.selected.match.fg = 'lime'
c.colors.completion.match.fg = 'white'
c.colors.completion.scrollbar.fg = '#916814'
c.colors.completion.scrollbar.bg = '#36383f'
c.colors.contextmenu.disabled.bg = None
c.colors.hints.fg = 'black'
c.colors.hints.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 rgba(255, 247, 133, 0.66), stop:1 rgba(255, 197, 66, 0.66))'
c.colors.keyhint.fg = 'white'
c.colors.keyhint.bg = 'rgba(0, 0, 0, 75%)'
c.colors.messages.info.fg = 'white'
c.colors.prompts.fg = 'white'
c.colors.prompts.border = '1px solid grey'
c.colors.prompts.bg = 'black'
c.colors.prompts.selected.bg = 'grey'
c.colors.statusbar.normal.fg = 'white'
c.colors.statusbar.normal.bg = '#36383f'
c.colors.statusbar.insert.fg = 'white'
c.colors.statusbar.insert.bg = '#3c56aa'
c.colors.statusbar.passthrough.fg = '#92959d'
c.colors.statusbar.passthrough.bg = 'black'
c.colors.statusbar.private.fg = 'black'
c.colors.statusbar.private.bg = 'white'
c.colors.statusbar.caret.fg = 'white'
c.colors.statusbar.caret.bg = 'navy'
c.colors.statusbar.url.hover.fg = 'lime'
c.colors.statusbar.url.success.http.fg = '#b9bdc5'
c.colors.statusbar.url.success.https.fg = 'white'
c.colors.statusbar.url.warn.fg = 'yellow'
c.colors.tabs.bar.bg = '#36383f'
c.colors.tabs.indicator.start = '#ddbb00'
c.colors.tabs.indicator.stop = '#00bb00'
c.colors.tabs.indicator.error = '#ff0000'
c.colors.tabs.indicator.system = 'rgb'
c.colors.tabs.odd.fg = '#b9bdc5'
c.colors.tabs.odd.bg = '#36383f'
c.colors.tabs.even.fg = '#b9bdc5'
c.colors.tabs.even.bg = '#36383f'
c.colors.tabs.selected.odd.fg = 'white'
c.colors.tabs.selected.odd.bg = '#3c56aa'
c.colors.tabs.selected.even.fg = 'white'
c.colors.tabs.selected.even.bg = '#3c56aa'
c.colors.tabs.pinned.odd.fg = 'black'
c.colors.tabs.pinned.odd.bg = '#92959d'
c.colors.tabs.pinned.even.fg = 'black'
c.colors.tabs.pinned.even.bg = '#92959d'
c.colors.tabs.pinned.selected.odd.fg = 'white'
c.colors.tabs.pinned.selected.odd.bg = '#3c56aa'
c.colors.tabs.pinned.selected.even.fg = 'white'
c.colors.tabs.pinned.selected.even.bg = '#3c56aa'
c.fonts.default_family = 'monospace'
c.fonts.default_size = '8pt'
c.fonts.downloads = 'default_size default_family'
c.fonts.hints = '700 9pt default_family'
c.fonts.keyhint = '500 default_size default_family'
c.fonts.messages.error = '700 default_size default_family'
c.fonts.messages.info = 'default_size default_family'
c.fonts.messages.warning = '500 default_size default_family'
c.fonts.prompts = 'default_size default_family'
c.fonts.statusbar = '500 6.5pt default_family'
c.fonts.tabs.selected = '700 7pt default_family'
c.fonts.tabs.unselected = '500 7pt default_family'
c.fonts.web.family.standard = 'sans'
c.fonts.web.family.fixed = 'monospace'
c.fonts.web.family.serif = 'serif'
c.fonts.web.family.sans_serif = 'sans'
c.fonts.web.family.cursive = 'serif'
c.fonts.web.family.fantasy = 'serif'
c.fonts.web.size.default = 16
c.bindings.key_mappings = {
  '<Enter>': '<Return>',
  '<Shift+Enter>': '<Shift+Return>',
  '<Ctrl+Enter>': '<Ctrl+Return>',
#  '<Ctrl+6>': '<Ctrl+^>',
#  '<Ctrl+[>': '<Escape>',
#  '<Ctrl+i>': '<Tab>',
#  '<Ctrl+j>': '<Return>',
#  '<Ctrl+m>': '<Return>',
#  '<Shift+Return>': '<Return>'
}
c.bindings.default['normal'] = {}
c.bindings.default['hint'] = {}
c.bindings.default['command'] = {}
c.bindings.default['insert'] = {}
c.bindings.default['caret'] = {}
c.bindings.default['passthrough'] = {}
c.bindings.commands['normal'] = {
  # general
  '<escape>': 'fake-key <Escape> ;; clear-keychain ;; clear-messages ;; search ;; fullscreen --leave',
  '<ctrl-g>': 'fake-key <Escape> ;; clear-keychain ;; clear-messages ;; search ;; fullscreen --leave',
  '<ctrl-x>`':           'repeat-command',
  '<ctrl-x>t':           'config-cycle statusbar.show in-mode always ;; config-cycle tabs.show always switching',
  '<ctrl-x><ctrl-c>':    'quit --save',
  '<ctrl-x><shift-k>':   'close',
  '<alt-x>':             'set-cmd-text :',
  '<ctrl-x>s':           'stop',
  '<ctrl-x>r':           'reload',
  '<ctrl-x>R':           'reload -f',
  'o':                   'set-cmd-text -s :open',
  'O':                   'set-cmd-text -s :open -t',
  '<ctrl-o>':            'set-cmd-text -s :open -w',
  '<ctrl-x>o':           'set-cmd-text :open {url:pretty}',
  '<ctrl-x>O':           'set-cmd-text :open -t {url:pretty}',
  '<ctrl-x><ctrl-o>':    'set-cmd-text :open -w {url:pretty}',
  '<ctrl-x>;':           'set-cmd-text -s :open -b',
  '<ctrl-x>:':           'set-cmd-text :open -b {url:pretty}',
  '<return>':            'follow-selected',
  '<shift-return>':      'follow-selected -t',
  '<ctrl-return>':       'follow-selected -w',
  '<ctrl-shift-return>': 'follow-selected -p',
  # focus
  'i':              'enter-mode insert',
  'I':              'hint inputs',
  '<ctrl-w>v':      'enter-mode caret',
  '<ctrl-w>p':      'enter-mode passthrough',
  '<ctrl-w>o':      'devtools-focus',
  ';':              'hint all',
  ':':              'hint all tab-bg --rapid',
  '<ctrl-;>':       'hint all yank',
  '<ctrl-shift-:>': 'hint all download',
  # meta
  '<ctrl-w>i': 'devtools',
  '<ctrl-w>s': 'view-source',
  '<ctrl-h>a': 'open -t qute://about',
  '<ctrl-h>h': 'open -t qute://history',
  '<ctrl-h>k': 'open -t qute://bindings',
  '<ctrl-h>m': 'open -t qute://bookmarks',
  '<ctrl-h>s': 'open -t qute://settings',
  '<ctrl-h>t': 'open -t qute://tabs',
  '<ctrl-h>v': 'open -t qute://version',
  # bookmark
  '<ctrl-x>m': 'bookmark-add',
  # edit
  '<ctrl-f>':        'fake-key <Right>',
  '<ctrl-b>':        'fake-key <Left>',
  '<alt-f>':         'fake-key <Ctrl-Right>',
  '<alt-b>':         'fake-key <Ctrl-Left>',
  '<ctrl-a>':        'fake-key <Home>',
  '<ctrl-e>':        'fake-key <End>',
  '<ctrl-n>':        'fake-key <Down>',
  '<ctrl-p>':        'fake-key <Up>',
  '<ctrl-d>':        'fake-key <Delete>',
  '<alt-d>':         'fake-key <Ctrl-Delete>',
  '<alt-backspace>': 'fake-key <Ctrl-Backspace>',
  '<ctrl-y>':        'insert-text {primary}',
  #https://github.com/qutebrowser/qutebrowser/issues/4213
  #'1': 'fake-key 1',
  #'2': 'fake-key 2',
  #'3': 'fake-key 3',
  #'4': 'fake-key 4',
  #'5': 'fake-key 5',
  #'6': 'fake-key 6',
  #'7': 'fake-key 7',
  #'8': 'fake-key 8',
  #'9': 'fake-key 9',
  #'0': 'fake-key 0',
  # history
  '<ctrl-x>h':   'back',
  '<ctrl-x>l':   'forward',
  '<alt-left>':  'back',
  '<alt-right>': 'forward',
  # nav
  '<ctrl-v>':            'scroll-page 0 0.9',
  '<alt-v>':             'scroll-page 0 -0.9',
  #https://github.com/qutebrowser/qutebrowser/issues/3736
  #'<alt-shift-less>':    'scroll-to-perc 0',
  #'<alt-shift-greater>': 'scroll-to-perc 100',
  # search
  '<ctrl-s>': 'set-cmd-text /',
  '<ctrl-r>': 'set-cmd-text ?',
  '<alt-s>':  'search-next',
  '<alt-r>':  'search-prev',
  # tab, window
  '<ctrl-/>':         'undo',
  '<ctrl-shift-t>':   'undo',
  '<ctrl-shift-?>':   'undo -w',
  '<ctrl-tab>':       'tab-next',
  '<ctrl-shift-tab>': 'tab-prev',
  '<alt-n>':          'tab-next',
  '<alt-p>':          'tab-prev',
  '<alt-shift-n>':    'tab-move +',
  '<alt-shift-p>':    'tab-move -',
  '<ctrl-x>b':        'set-cmd-text -s :buffer',
  '<ctrl-x>k':        'tab-close',
  '<ctrl-x>x':        'tab-close -n',
  '<ctrl-x>m':        'tab-mute',
  '<ctrl-x>p':        'tab-pin',
  '<alt-1>':          'tab-focus 1',
  '<alt-2>':          'tab-focus 2',
  '<alt-3>':          'tab-focus 3',
  '<alt-4>':          'tab-focus 4',
  '<alt-5>':          'tab-focus 5',
  '<alt-6>':          'tab-focus 6',
  '<alt-7>':          'tab-focus 7',
  '<alt-8>':          'tab-focus 8',
  '<alt-9>':          'tab-focus 9',
  '<alt-0>':          'tab-focus -1',
  # yank
  '<alt-w>':  'yank url',
  '<ctrl-y>': 'open -- {clipboard}',
  # zoom
  '-': 'zoom-out',
  '=': 'zoom 100',
  '+': 'zoom-in',
}
c.bindings.commands['hint'] = {
  '<escape>': 'leave-mode',
  '<ctrl-g>': 'leave-mode',
}
c.bindings.commands['command'] = {
  '<escape>':        'leave-mode',
  '<ctrl-g>':        'leave-mode',
  '<ctrl-n>':        'completion-item-focus next',
  '<ctrl-p>':        'completion-item-focus prev',
  '<alt-n>':         'command-history-next',
  '<alt-p>':         'command-history-prev',
  '<return>':        'command-accept',
  '<tab>':           'completion-item-focus next-category',
  '<shift-tab>':     'completion-item-focus prev-category',
  '<ctrl-f>':        'rl-forward-char',
  '<ctrl-b>':        'rl-backward-char',
  '<alt-f>':         'rl-forward-word',
  '<alt-b>':         'rl-backward-word',
  '<ctrl-a>':        'rl-beginning-of-line',
  '<ctrl-e>':        'rl-end-of-line',
  '<ctrl-d>':        'rl-delete-char',
  '<alt-d>':         'rl-kill-word',
  '<alt-backspace>': 'rl-backward-kill-word',
  '<ctrl-k>':        'rl-kill-line',
  '<ctrl-y>':        'rl-yank',
}
c.bindings.commands['insert'] = {
  '<escape>':        'leave-mode',
  '<ctrl-g>':        'leave-mode',
  '<ctrl-f>':        'fake-key <Right>',
  '<ctrl-b>':        'fake-key <Left>',
  '<ctrl-a>':        'fake-key <Home>',
  '<ctrl-e>':        'fake-key <End>',
  '<ctrl-n>':        'fake-key <Down>',
  '<ctrl-p>':        'fake-key <Up>',
  '<alt-f>':         'fake-key <Ctrl-Right>',
  '<alt-b>':         'fake-key <Ctrl-Left>',
  '<ctrl-d>':        'fake-key <Delete>',
  '<alt-d>':         'fake-key <Ctrl-Delete>',
  '<alt-backspace>': 'fake-key <Ctrl-Backspace>',
  '<ctrl-y>':        'insert-text {primary}',
}
c.bindings.commands['caret'] = {
  '<escape>':           'leave-mode',
  '<ctrl-g>':           'leave-mode',
  '<ctrl-space>':       'toggle-selection',
  '<ctrl-shift-space>': 'toggle-selection --line',
  '<ctrl-f>':           'move-to-next-char',
  '<ctrl-b>':           'move-to-prev-char',
  '<ctrl-a>':           'move-to-start-of-line',
  '<ctrl-e>':           'move-to-end-of-line',
  '<ctrl-n>':           'move-to-next-line',
  '<ctrl-p>':           'move-to-prev-line',
  '<alt-f>':            'move-to-next-word',
  '<alt-b>':            'move-to-prev-word',
  '<ctrl-shift-p>':     'move-to-end-of-document',
  '<ctrl-shift-n>':     'move-to-start-of-document',
}
c.bindings.commands['passthrough'] = {
  '<shift-escape>': 'leave-mode',
}
c.bindings.commands['register'] = {
  '<ctrl-g>': 'leave-mode',
}
c.bindings.commands['yesno'] = {
  '<ctrl-g>': 'leave-mode',
}

