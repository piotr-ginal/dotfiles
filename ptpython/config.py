from prompt_toolkit.styles import Style
from ptpython.repl import PythonRepl

__all__ = ["configure"]
nord_theme_ui = {
    "control-character": "#81A1C1",
    "prompt": "bold #81A1C1",
    "prompt.dots": "noinherit",
    "in": "bold #A3BE8C",
    "in.number": "",
    "out": "#BF616A",
    "out.number": "#BF616A",
    "completion.builtin": "#8FBCBB",
    "completion.param": "#81A1C1 italic",
    "completion.keyword": "fg:#81A1C1",
    "completion.keyword fuzzymatch.inside": "fg:#81A1C1",
    "completion.keyword fuzzymatch.outside": "fg:#88C0D0",
    "separator": "#4C566A",
    "system-toolbar": "#5E81AC noinherit",
    "arg-toolbar": "#5E81AC noinherit",
    "arg-toolbar.text": "noinherit",
    "signature-toolbar": "bg:#8FBCBB #2E3440",
    "signature-toolbar current-name": "bg:#81A1C1 #ECEFF4 bold",
    "signature-toolbar operator": "#2E3440 bold",
    "docstring": "#D8DEE9",
    "validation-toolbar": "bg:#BF616A #D8DEE9",
    "status-toolbar": "bg:#3B4252 #D8DEE9",
    "status-toolbar.title": "underline",
    "status-toolbar.inputmode": "bg:#3B4252 #EBCB8B",
    "status-toolbar.key": "bg:#2E3440 #D8DEE9",
    "status-toolbar key": "bg:#2E3440 #D8DEE9",
    "status-toolbar.pastemodeon": "bg:#BF616A #ECEFF4",
    "status-toolbar.pythonversion": "bg:#3B4252 #ECEFF4 bold",
    "status-toolbar paste-mode-on": "bg:#BF616A #ECEFF4",
    "record": "bg:#B48EAD white",
    "status-toolbar more": "#EBCB8B",
    "status-toolbar.input-mode": "#EBCB8B",
    "sidebar": "bg:#434C5E #ECEFF4",
    "sidebar.title": "bg:#5E81AC #ECEFF4",
    "sidebar.label": "bg:#434C5E #D8DEE9",
    "sidebar.status": "bg:#4C566A #2E3440",
    "sidebar.label selected": "bg:#2E3440 #ECEFF4",
    "sidebar.status selected": "bg:#3B4252 #ECEFF4 bold",
    "sidebar.separator": "underline",
    "sidebar.key": "bg:#A3BE8C #2E3440 bold",
    "sidebar.key.description": "bg:#434C5E #2E3440",
    "sidebar.helptext": "bg:#ECEFF4 #2E3440",
    "window-border": "#4C566A",
    "window-title": "bg:#434C5E #ECEFF4",
    "accept-message": "bg:#EBCB8B #2E3440",
    "exit-confirmation": "bg:#BF616A #ECEFF4",
}


def configure(repl: PythonRepl) -> None:
    repl.use_code_colorscheme("nord")
    repl.vi_mode = True
    repl.cursor_shape_config = "Modal (vi)"
    repl.confirm_exit = False
    repl.show_line_numbers = False
    repl.enable_fuzzy_completion = True
    repl.enable_dictionary_completion = True
    repl.color_depth = "DEPTH_24_BIT"

    repl.install_ui_colorscheme("custom-nord", Style.from_dict(nord_theme_ui))
    repl.use_ui_colorscheme("custom-nord")
