CREATE DATABASE healthcare_system;

USE healthcare_system;
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255)
);
INSERT INTO roles (role_name, description) VALUES
('admin','System administrator with full access'),
('doctor','Medical professional who manages EHR and prescriptions'),
('receptionist','Handles patient registration and appointments'),
('lab_technician','Manages lab reports');

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_login DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
INSERT INTO users (username,email,password,role_id) VALUES
('admin_rahul','admin@hospital.com','Admin@123',1),
('dr_singh','singh@hospital.com','Doc@123',2),
('dr_mehta','mehta@hospital.com','Doc@456',2),
('rec_priya','priya@hospital.com','Rec@123',3),
('lab_amit','amit@hospital.com','Lab@123',4);

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    
    date_of_birth DATE NOT NULL,
    gender varchar(100) NOT NULL,
     check(gender in('Male','Female','Other')),
    
    
    blood_group varchar(100) ,
    check(blood_group in('A+','A-','B+','B-','O+','O-','AB+','AB-')),
    
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(15),
    
    allergies TEXT,
    medical_history TEXT,
    
    insurance_provider VARCHAR(100),
    insurance_number VARCHAR(50),
    
    is_active BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO patients 
(first_name,last_name,date_of_birth,gender,blood_group,phone,email,city,state)
VALUES
('Amit','Sharma','1995-06-15','Male','B+','9876543210','amit@gmail.com','Delhi','Delhi'),
('Neha','Verma','1998-03-20','Female','O+','9876500000','neha@gmail.com','Noida','UP');
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    
    user_id INT UNIQUE,  
    
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    
    specialization VARCHAR(100) NOT NULL,
    qualification VARCHAR(100),
    experience_years INT CHECK (experience_years >= 0),
    
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    
    consultation_fee DECIMAL(10,2) CHECK (consultation_fee >= 0),
    
    room_number VARCHAR(10),
    
    is_active BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
INSERT INTO doctors 
(user_id,first_name,last_name,specialization,experience_years,consultation_fee)
VALUES
(2,'Raj','Singh','Cardiology',10,800.00),
(3,'Anil','Mehta','Orthopedics',8,600.00);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    created_by INT NULL,   
    
    appointment_datetime DATETIME NOT NULL,
    
    appointment_type VARCHAR(20) 
        DEFAULT 'Consultation'
        CHECK (appointment_type IN ('Consultation','Follow-up','Emergency')),
    
    status VARCHAR(20) 
        DEFAULT 'Scheduled'
        CHECK (status IN ('Scheduled','Completed','Cancelled','No-Show')),
        
    consultation_fee DECIMAL(10,2) CHECK (consultation_fee >= 0),
    
    payment_status ENUM('Pending','Paid','Refunded') DEFAULT 'Pending',
    
    notes TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (consultation_fee) REFERENCES doctors(consultation_fee)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,    
        
    FOREIGN KEY (created_by) REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

INSERT INTO appointments 
(patient_id, doctor_id, created_by, appointment_datetime, appointment_type)
VALUES
(1,1,4,'2026-03-01 10:30:00','Consultation'),
(2,2,4,'2026-03-02 12:00:00','Follow-up');
CREATE TABLE ehr (
    ehr_id INT AUTO_INCREMENT PRIMARY KEY,
    
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    created_by INT ,
    
    chief_complaint TEXT NOT NULL,
    diagnosis TEXT NOT NULL,
    treatment_plan TEXT,
    
    severity_level VARCHAR(20)
        CHECK (severity_level IN ('Low','Moderate','High','Critical')),
    
    prescription_given BOOLEAN DEFAULT FALSE,
    
    follow_up_date DATE,
    
    visit_notes TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    FOREIGN KEY (created_by) REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
INSERT INTO ehr
(appointment_id,patient_id,doctor_id,chief_complaint,diagnosis,severity_level)
VALUES
(1,1,1,'Chest Pain','Mild Cardiac Stress','Moderate'),
(2,2,2,'Knee Pain','Ligament Strain','Low');
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    
    ehr_id INT NOT NULL,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    
    medicine_name VARCHAR(100) NOT NULL,
    medicine_type VARCHAR(50),
    
    dosage VARCHAR(50) NOT NULL,           
    frequency VARCHAR(50) NOT NULL,        
    duration_days INT CHECK (duration_days > 0),
    
    instructions TEXT,
    
    start_date DATE DEFAULT (CURRENT_DATE),
    end_date DATE,
    
    is_active BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (ehr_id) REFERENCES ehr(ehr_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
INSERT INTO prescriptions
(ehr_id,patient_id,doctor_id,medicine_name,dosage,frequency,duration_days)
VALUES
(3,1,1,'Aspirin','75mg','Once Daily',7),
(4,2,2,'Ibuprofen','400mg','Twice Daily',5);
CREATE TABLE lab_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    technician_id INT NULL,
    
    test_name VARCHAR(100) NOT NULL,
    test_category VARCHAR(50),
    
    test_result TEXT NOT NULL,
    normal_range VARCHAR(100),
    result_status VARCHAR(20)
        CHECK (result_status IN ('Normal','Abnormal','Critical')),
    
    test_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    report_file_path VARCHAR(255),
    
    remarks TEXT,
    
    is_verified BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    FOREIGN KEY (technician_id) REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
INSERT INTO lab_reports
(appointment_id,patient_id,doctor_id,technician_id,test_name,test_result,result_status)
VALUES
(1,1,1,5,'ECG','Normal sinus rhythm','Normal'),
(2,2,2,5,'X-Ray Knee','Minor swelling detected','Abnormal');