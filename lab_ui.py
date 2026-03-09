import tkinter as tk

def open_lab_ui():
    win = tk.Toplevel()
    win.title("Lab Reports")
    win.geometry("300x200")

    tk.Label(win,text="Lab Reports Module").pack(pady=40)