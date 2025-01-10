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

Drop trigger n�v;
Drop procedure n�v;
drop package n�v;
drop package body n�v;
------------------------------------------------
-- M�dis�t�s eset�n
------------------------------------------------
COMMIT;


  


------------------------------------------------
-- Hozzunk l�tre id�pontot (jelenleg 50 p�ciens �s 10 doki van.) 
------------------------------------------------
SELECT *
FROM Appointment
WHERE appointment_date = TO_DATE('2025-01-15', 'YYYY-MM-DD')
  AND status = '�temezett';

--D:1 P:1 room: A 09:00-09:30

----hib�t dob ha foglalt a doki, a beteg, vagy a terem. (9.30kor m�g foglalt. 9.31t�l m�r szabad)

BEGIN   pkg_appointment.p_create_appointment(
        p_patient_id        => 10,
        p_doctor_id         => 3,
        p_appointment_date  => TO_DATE('2025-01-15', 'YYYY-MM-DD'),
        p_start_time        => '09:30',
        p_end_time          => '10:00',
        p_status            => '�temezett',
        p_room              => 'C'
    );
END;

-----------------�j st�tusz: lemondva---------------
BEGIN
    pkg_appointment.p_cancel_appointment(
        p_appointment_id => 23
    );
END;

SELECT *
FROM Appointment
WHERE appointment_date = TO_DATE('2025-01-15', 'YYYY-MM-DD');


------------keress�nk egy r�gebbi id�pontot  id:13 �s 14 �temezett---------
SELECT * FROM Appointment WHERE id IN (13, 14);


BEGIN
    pkg_appointment.p_update_appointment_status(
        p_appointment_id => 13,
        p_new_status => 'Megjelent'
    );
END;


-----------------hozzunk l�tre uj p�cienst, sequence 52el fogja beszurni ----------------------
select * from patient;
BEGIN
    pkg_patient.p_create_patient(
        p_tajszam       => '546789453',
        p_patient_name  => 'John Doe',
        p_birth_date    => TO_DATE('1985-06-15', 'YYYY-MM-DD'),
        p_phone_number  => '+36203843676',
        p_address       => '1011 Budapest, F� utca 1.'
    );
END;

----------szurjunk be m�st azonos tajsz�mmal : hiba ---------------------
BEGIN
    pkg_patient.p_create_patient(
        p_tajszam       => '546789453',
        p_patient_name  => 'Horvath Janos',
        p_birth_date    => TO_DATE('1989-06-15', 'YYYY-MM-DD'),
        p_phone_number  => '+36203843678',
        p_address       => '1011 Budapest, F� utca 1.'
    );
END;

------------frissit�s ----------------
BEGIN
    pkg_patient.p_update_patient(
        p_patient_id    => 52,
        p_tajszam       => '546789453',
        p_patient_name  => 'John Doe',
        p_birth_date    => TO_DATE('1985-06-15', 'YYYY-MM-DD'),
        p_phone_number  => '+36203843678',
        p_address       => '1011 Budapest, M�dos�tott utca 2.'
    );
END;

-------tajszam check---------
DECLARE
    v_duplicate BOOLEAN;
BEGIN
    v_duplicate := pkg_patient.p_check_duplicate_tajszam('546789453');
    IF v_duplicate THEN
        DBMS_OUTPUT.PUT_LINE('Duplik�lt TAJ-sz�m.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('A TAJ-sz�m egyedi.');
    END IF;
END;

------doki package tesztel�s--------
select * from doctor;

BEGIN
    pkg_doctor.p_create_doctor(
        p_doctor_name   => 'Dr.Meggyesi Balazs',
        p_phone_number  => '+36203845678'
    );
    DBMS_OUTPUT.PUT_LINE('Orvos sikeresen l�trehozva.');
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

--- hiba j�v�beni d�tum------
BEGIN
    pkg_billing.p_generate_bill(p_appointment_id => 1);
END;
/
---el se j�tt az �gyf�l--------
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


---------------------�rak---------
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




  
