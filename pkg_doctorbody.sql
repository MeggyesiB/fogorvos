CREATE OR REPLACE PACKAGE BODY pkg_doctor AS

    PROCEDURE p_create_doctor(
        p_doctor_name   IN VARCHAR2,
        p_phone_number  IN VARCHAR2
    )
    IS
    BEGIN
        INSERT INTO Doctor (id, doctor_name, phone_number)
        VALUES (seq_doctor_id.NEXTVAL, p_doctor_name, p_phone_number);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('�j orvos sikeresen l�trehozva.');
    END p_create_doctor;

    PROCEDURE p_update_doctor(
        p_doctor_id     IN NUMBER,
        p_doctor_name   IN VARCHAR2,
        p_phone_number  IN VARCHAR2
    )
    IS
        v_old_name   Doctor.doctor_name%TYPE;
        v_old_phone  Doctor.phone_number%TYPE;
    BEGIN
        SELECT doctor_name, phone_number
        INTO v_old_name, v_old_phone
        FROM Doctor
        WHERE id = p_doctor_id;

       
        IF (v_old_name <> p_doctor_name)
           OR (v_old_phone <> p_phone_number)
        THEN
            UPDATE Doctor
            SET doctor_name = p_doctor_name,
                phone_number = p_phone_number
            WHERE id = p_doctor_id;

            COMMIT;
            
            DBMS_OUTPUT.PUT_LINE('Az orvos adatai sikeresen friss�tve.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nem t�rt�nt v�ltoz�s, az adatok nem lettek friss�tve.');
        END IF;
    END p_update_doctor;

END pkg_doctor;
/
