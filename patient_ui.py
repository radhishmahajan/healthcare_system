import tkinter as tk
from tkinter import ttk,messagebox
from db import get_connection

def open_patient_ui():

    window = tk.Toplevel()
    window.title("Patient Management")
    window.geometry("700x500")

    tk.Label(window,text="First Name").grid(row=0,column=0)
    first_name = tk.Entry(window)
    first_name.grid(row=0,column=1)

    tk.Label(window,text="Last Name").grid(row=1,column=0)
    last_name = tk.Entry(window)
    last_name.grid(row=1,column=1)

    tk.Label(window,text="Phone").grid(row=2,column=0)
    phone = tk.Entry(window)
    phone.grid(row=2,column=1)

    def add_patient():
        conn = get_connection()
        cursor = conn.cursor()

        query = """
        INSERT INTO patients(first_name,last_name,phone)
        VALUES(%s,%s,%s)
        """

        cursor.execute(query,(first_name.get(),last_name.get(),phone.get()))
        conn.commit()

        messagebox.showinfo("Success","Patient Added")

        load_patients()

    tk.Button(window,text="Add Patient",command=add_patient).grid(row=3,column=1,pady=10)

    tree = ttk.Treeview(window)

    tree["columns"]=("ID","First Name","Last Name","Phone")

    tree.column("#0",width=0,stretch=tk.NO)

    tree.heading("ID",text="ID")
    tree.heading("First Name",text="First Name")
    tree.heading("Last Name",text="Last Name")
    tree.heading("Phone",text="Phone")

    tree.grid(row=5,column=0,columnspan=3,pady=20)

    def load_patients():

        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT patient_id,first_name,last_name,phone FROM patients")
        rows = cursor.fetchall()

        for r in tree.get_children():
            tree.delete(r)

        for row in rows:
            tree.insert("",tk.END,values=row)

    load_patients()