------------------------------------------------
-- Delete
------------------------------------------------

SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM Appointment;
SELECT * FROM Treatment;
SELECT * FROM Bill;

DROP TABLE Patient CASCADE CONSTRAINTS;
DROP TABLE Doctor CASCADE CONSTRAINTS;
DROP TABLE Appointment CASCADE CONSTRAINTS;
DROP TABLE Treatment CASCADE CONSTRAINTS;
DROP TABLE Bill CASCADE CONSTRAINTS;

SELECT sequence_name,
  FROM user_sequences;
  
Drop sequence seq_patient_id;
Drop sequence seq_doctor_id;
Drop sequence seq_appointment_id;
Drop sequence seq_treatment_id;
Drop sequence seq_bill_id;

Drop trigger név;
Drop procedure név;
drop package név;
drop package body név;
------------------------------------------------
-- Módisítás esetén
------------------------------------------------
COMMIT;


  


------------------------------------------------
-- Hozzunk létre idõpontot (jelenleg 50 páciens és 10 doki van.) 
------------------------------------------------
SELECT *
FROM Appointment
WHERE appointment_date = TO_DATE('2025-01-15', 'YYYY-MM-DD')
  AND status = 'Ütemezett';

--D:1 P:1 room: A 09:00-09:30

----hibát dob ha foglalt a doki, a beteg, vagy a terem. (9.30kor még foglalt. 9.31tõl már szabad)

BEGIN   pkg_appointment.p_create_appointment(
        p_patient_id        => 10,
        p_doctor_id         => 3,
        p_appointment_date  => TO_DATE('2025-01-15', 'YYYY-MM-DD'),
        p_start_time        => '09:30',
        p_end_time          => '10:00',
        p_status            => 'Ütemezett',
        p_room              => 'C'
    );
END;

-----------------új státusz: lemondva---------------
BEGIN
    pkg_appointment.p_cancel_appointment(
        p_appointment_id => 23
    );
END;

SELECT *
FROM Appointment
WHERE appointment_date = TO_DATE('2025-01-15', 'YYYY-MM-DD');


------------keressünk egy régebbi idõpontot  id:13 és 14 ütemezett---------
SELECT * FROM Appointment WHERE id IN (13, 14);


BEGIN
    pkg_appointment.p_update_appointment_status(
        p_appointment_id => 13,
        p_new_status => 'Megjelent'
    );
END;


-----------------hozzunk létre uj pácienst, sequence 52el fogja beszurni ----------------------
select * from patient;
BEGIN
    pkg_patient.p_create_patient(
        p_tajszam       => '546789453',
        p_patient_name  => 'John Doe',
        p_birth_date    => TO_DATE('1985-06-15', 'YYYY-MM-DD'),
        p_phone_number  => '+36203843676',
        p_address       => '1011 Budapest, Fõ utca 1.'
    );
END;

----------szurjunk be mást azonos tajszámmal : hiba ---------------------
BEGIN
    pkg_patient.p_create_patient(
        p_tajszam       => '546789453',
        p_patient_name  => 'Horvath Janos',
        p_birth_date    => TO_DATE('1989-06-15', 'YYYY-MM-DD'),
        p_phone_number  => '+36203843678',
        p_address       => '1011 Budapest, Fõ utca 1.'
    );
END;

------------frissités ----------------
BEGIN
    pkg_patient.p_update_patient(
        p_patient_id    => 52,
        p_tajszam       => '546789453',
        p_patient_name  => 'John Doe',
        p_birth_date    => TO_DATE('1985-06-15', 'YYYY-MM-DD'),
        p_phone_number  => '+36203843678',
        p_address       => '1011 Budapest, Módosított utca 2.'
    );
END;

-------tajszam check---------
DECLARE
    v_duplicate BOOLEAN;
BEGIN
    v_duplicate := pkg_patient.p_check_duplicate_tajszam('546789453');
    IF v_duplicate THEN
        DBMS_OUTPUT.PUT_LINE('Duplikált TAJ-szám.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('A TAJ-szám egyedi.');
    END IF;
END;

------doki package tesztelés--------
select * from doctor;

BEGIN
    pkg_doctor.p_create_doctor(
        p_doctor_name   => 'Dr.Meggyesi Balazs',
        p_phone_number  => '+36203845678'
    );
    DBMS_OUTPUT.PUT_LINE('Orvos sikeresen létrehozva.');
END;
/

BEGIN
    pkg_doctor.p_update_doctor(
        p_doctor_id     => 30, 
        p_doctor_name   => 'Dr.Cseresznyesi Balazs',
        p_phone_number  => '+36203845678'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hiba: ' || SQLERRM);
END;
/

-----------bill teszt------------

SELECT * FROM Bill;
select * from appointment;

--- hiba jövõbeni dátum------
BEGIN
    pkg_billing.p_generate_bill(p_appointment_id => 1);
END;
/
---el se jött az ügyfél--------
BEGIN
    pkg_billing.p_generate_bill(p_appointment_id => 2);
END;
/
-------------11 megjelent--------------
BEGIN
    pkg_billing.p_generate_bill(p_appointment_id => 11);
END;
/
SELECT * FROM Bill;
select * from treatment;

BEGIN
    pkg_billing.p_update_bill_amount(p_bill_id => 1);
END;
/


---------------------árak---------
SELECT * FROM Treatment;
BEGIN
    Treatment_Pricing.Increase_All_Treatment_Costs(10);
END;
/
SELECT * FROM Treatment;

BEGIN
    Treatment_Pricing.Increase_Costs_By_Type('Korona', 100);
END;
/
SELECT * FROM Treatment;




  
