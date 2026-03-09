import tkinter as tk

def open_appointment_ui():
    win = tk.Toplevel()
    win.title("Appointments")
    win.geometry("300x200")

    tk.Label(win,text="Appointment Module").pack(pady=40)