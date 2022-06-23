import atexit
import os
import readline

histfile = os.environ.get("PYTHONHISTFILE", "")
if histfile == "":
    histfile = os.path.join(os.path.expanduser("~"), ".python_history")

try:
    readline.read_history_file(histfile)
    readline.set_history_length(10000)
except FileNotFoundError:
    pass

readline.set_auto_history(False)

atexit.register(readline.write_history_file, histfile)
