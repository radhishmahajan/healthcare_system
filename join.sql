SELECT 
a.appointment_id,
p.first_name AS patient_name,
d.first_name AS doctor_name,
a.appointment_datetime,
a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;


SELECT 
p.first_name AS patient,
a.appointment_datetime,
e.diagnosis,
pr.medicine_name,
pr.dosage,
pr.frequency
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN ehr e ON a.appointment_id = e.appointment_id
JOIN prescriptions pr ON e.ehr_id = pr.ehr_id
WHERE p.patient_id = 1;


SELECT 
p.first_name AS patient,
d.first_name AS doctor,
u.username AS technician,
l.test_name,
l.test_result,
l.result_status
FROM lab_reports l
JOIN patients p ON l.patient_id = p.patient_id
JOIN doctors d ON l.doctor_id = d.doctor_id
LEFT JOIN users u ON l.technician_id = u.user_id;


SELECT 
p.first_name,
a.appointment_datetime,
a.consultation_fee,
a.payment_status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id;

SELECT 
d.first_name AS doctor,
COUNT(a.appointment_id) AS total_appointments
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id;

SELECT 
p.first_name,
d.first_name,
a.appointment_datetime
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_datetime > NOW();


SELECT 
d.first_name,
d.specialization,
COUNT(a.appointment_id) AS total_patients
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id;


SELECT 
p.first_name AS patient,
d.first_name AS doctor,
a.appointment_datetime,
e.diagnosis,
l.test_name,
pr.medicine_name
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
LEFT JOIN ehr e ON a.appointment_id = e.appointment_id
LEFT JOIN lab_reports l ON a.appointment_id = l.appointment_id
LEFT JOIN prescriptions pr ON e.ehr_id = pr.ehr_id;
UPDATE ehr
SET
created_by = 3,
treatment_plan = 'Rest, physiotherapy, anti-inflammatory medication',
prescription_given = TRUE,
follow_up_date = '2026-03-20',
visit_notes = 'Advised knee brace support and limited physical activity.'
WHERE ehr_id = 4;

select * from users;
select * from patients;
select * from doctors;
select * from appointments;
select * from ehr;
select * from prescriptions;
select * from lab_reports;

