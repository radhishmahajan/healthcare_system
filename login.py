import tkinter as tk
from tkinter import messagebox
from db import get_connection
from dashboard import open_dashboard

def login():
    username = entry_user.get()
    password = entry_pass.get()

    conn = get_connection()
    cursor = conn.cursor()

    query = """
    SELECT r.role_name
    FROM users u
    JOIN roles r ON u.role_id = r.role_id
    WHERE u.username=%s AND u.password=%s
    """

    cursor.execute(query, (username, password))
    result = cursor.fetchone()

    if result:
        role = result[0]
        root.destroy()
        open_dashboard(role)
    else:
        messagebox.showerror("Error", "Invalid login")

root = tk.Tk()
root.title("Healthcare System Login")
root.geometry("300x200")

tk.Label(root, text="Username").pack()
entry_user = tk.Entry(root)
entry_user.pack()

tk.Label(root, text="Password").pack()
entry_pass = tk.Entry(root, show="*")
entry_pass.pack()

tk.Button(root, text="Login", command=login).pack(pady=10)

root.mainloop()