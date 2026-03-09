import tkinter as tk

def open_ehr_ui():
    win = tk.Toplevel()
    win.title("EHR Records")
    win.geometry("300x200")

    tk.Label(win,text="EHR Module").pack(pady=40)