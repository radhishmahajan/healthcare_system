import tkinter as tk
from patient_ui import open_patient_ui
from appointment_ui import open_appointment_ui
from ehr_ui import open_ehr_ui
from lab_ui import open_lab_ui

def open_dashboard(role):

    root = tk.Tk()
    root.title("Healthcare Dashboard")
    root.geometry("400x350")

    tk.Label(root,text=f"Dashboard - {role}",font=("Arial",16)).pack(pady=20)

    if role == "admin":
        tk.Button(root,text="Patients",width=25,command=open_patient_ui).pack(pady=5)
        tk.Button(root,text="Appointments",width=25,command=open_appointment_ui).pack(pady=5)
        tk.Button(root,text="EHR Records",width=25,command=open_ehr_ui).pack(pady=5)
        tk.Button(root,text="Lab Reports",width=25,command=open_lab_ui).pack(pady=5)

    elif role == "doctor":
        tk.Button(root,text="Patients",width=25,command=open_patient_ui).pack(pady=5)
        tk.Button(root,text="EHR Records",width=25,command=open_ehr_ui).pack(pady=5)

    elif role == "receptionist":
        tk.Button(root,text="Register Patient",width=25,command=open_patient_ui).pack(pady=5)
        tk.Button(root,text="Appointments",width=25,command=open_appointment_ui).pack(pady=5)

    elif role == "lab_technician":
        tk.Button(root,text="Lab Reports",width=25,command=open_lab_ui).pack(pady=5)

    root.mainloop()