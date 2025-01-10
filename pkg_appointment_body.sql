DROP PACKAGE BODY pkg_appointment;
CREATE OR REPLACE PACKAGE BODY pkg_appointment AS

    PROCEDURE validate_appointment(
        p_appointment_date  IN DATE,
        p_start_time        IN VARCHAR2,
        p_end_time          IN VARCHAR2,
        p_status            IN VARCHAR2
    )
    IS
    BEGIN
        IF NOT REGEXP_LIKE(p_start_time, '^\d{2}:\d{2}$')
           OR NOT REGEXP_LIKE(p_end_time, '^\d{2}:\d{2}$')
        THEN
            RAISE_APPLICATION_ERROR(-20006,'Idõpont formátum helytelen. Használj "HH:MM" formátumot.');
        END IF;

        
        IF TO_DATE(p_end_time, 'HH24:MI') <= TO_DATE(p_start_time, 'HH24:MI') THEN
            RAISE_APPLICATION_ERROR(-20007,'A végidõnek nagyobbnak kell lennie, mint a kezdõidõ.');
        END IF;

        
        IF p_appointment_date > SYSDATE AND p_status = 'Megjelent' THEN
            RAISE_APPLICATION_ERROR(-20001,'Jövõbeni idõpont nem lehet "Megjelent" státuszú.');
        END IF;

        IF p_appointment_date < SYSDATE AND p_status = 'Ütemezett' THEN
            RAISE_APPLICATION_ERROR(
                -20002,
                'Múltbeli idõpont nem lehet "Ütemezett" státuszú.'
            );
        END IF;

    END validate_appointment;


    PROCEDURE p_create_appointment(
        p_patient_id        IN NUMBER,
        p_doctor_id         IN NUMBER,
        p_appointment_date  IN DATE,
        p_start_time        IN VARCHAR2,
        p_end_time          IN VARCHAR2,
        p_status            IN VARCHAR2,
        p_room              IN CHAR
    )
    IS
        v_count NUMBER;
    BEGIN
        
        SELECT COUNT(*) INTO v_count 
          FROM Patient 
         WHERE id = p_patient_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Nem létezõ beteg azonosító.');
        END IF;

        
        SELECT COUNT(*) INTO v_count 
          FROM Doctor 
         WHERE id = p_doctor_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Nem létezõ orvos azonosító.');
        END IF;

        SELECT COUNT(*) INTO v_count
          FROM Appointment
         WHERE appointment_date = p_appointment_date
           AND (
                 (p_start_time BETWEEN start_time AND end_time)
                 OR (p_end_time BETWEEN start_time AND end_time)
                 OR (start_time BETWEEN p_start_time AND p_end_time)
                 OR (end_time BETWEEN p_start_time AND p_end_time)
               )
           AND (
                 patient_id = p_patient_id
                 OR doctor_id = p_doctor_id
                 OR room = p_room
               );

        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20005,'Az idõintervallum foglalt az orvos, a beteg, vagy a terem számára.');
        END IF;

       
        validate_appointment(
            p_appointment_date,
            p_start_time,
            p_end_time,
            p_status
        );

     
        INSERT INTO Appointment (
            id,
            patient_id,
            doctor_id,
            appointment_date,
            start_time,
            end_time,
            status,
            room
        )
        VALUES (
            seq_appointment_id.NEXTVAL,
            p_patient_id,
            p_doctor_id,
            p_appointment_date,
            p_start_time,
            p_end_time,
            p_status,
            p_room
        );

        COMMIT;
    END p_create_appointment;


    PROCEDURE p_update_appointment_status(
        p_appointment_id    IN NUMBER,
        p_new_status        IN VARCHAR2
    )
    IS
        v_app_date   DATE;
        v_start_time VARCHAR2(5);
        v_end_time   VARCHAR2(5);
    BEGIN
     
        SELECT appointment_date, start_time, end_time
          INTO v_app_date, v_start_time, v_end_time
          FROM Appointment
         WHERE id = p_appointment_id;

      
        validate_appointment(
            v_app_date,
            v_start_time,
            v_end_time,
            p_new_status
        );

      
        UPDATE Appointment
           SET status = p_new_status
         WHERE id = p_appointment_id;

        COMMIT;
    END p_update_appointment_status;


    PROCEDURE p_cancel_appointment(
        p_appointment_id    IN NUMBER
    )
    IS
    BEGIN
        UPDATE Appointment
           SET status = 'Lemondott'
         WHERE id = p_appointment_id;

        COMMIT;
    END p_cancel_appointment;

END pkg_appointment;
/
