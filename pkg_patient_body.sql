CREATE OR REPLACE PACKAGE BODY pkg_patient AS
    FUNCTION p_check_duplicate_tajszam(
        p_tajszam IN CHAR
    ) 
    RETURN BOOLEAN
    IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
          INTO v_count
          FROM Patient
         WHERE tajszam = p_tajszam;

        IF v_count > 0 THEN
            RETURN TRUE;  
        ELSE
            RETURN FALSE; 
        END IF;
    END p_check_duplicate_tajszam;


----------------------------------------------------------------------------
----------------------------------------------------------------------------
    PROCEDURE p_create_patient(
        p_tajszam       IN CHAR,
        p_patient_name  IN VARCHAR2,
        p_birth_date    IN DATE,
        p_phone_number  IN VARCHAR2,
        p_address       IN VARCHAR2
    )
    IS
    BEGIN
        IF p_check_duplicate_tajszam(p_tajszam) THEN
            RAISE_APPLICATION_ERROR(
                -20010,
                'Már létezik beteg ezzel a TAJ-számmal: ' || p_tajszam
            );
        END IF;

        INSERT INTO Patient (
            id, 
            tajszam, 
            patient_name,
            birth_date,
            phone_number,
            address
        )
        VALUES (
            seq_patient_id.NEXTVAL, 
            p_tajszam,
            p_patient_name,
            p_birth_date,
            p_phone_number,
            p_address
        );

        COMMIT;
    END p_create_patient;


----------------------------------------------------------------------------
----------------------------------------------------------------------------
    PROCEDURE p_update_patient(
        p_patient_id    IN NUMBER,
        p_tajszam       IN CHAR,
        p_patient_name  IN VARCHAR2,
        p_birth_date    IN DATE,
        p_phone_number  IN VARCHAR2,
        p_address       IN VARCHAR2
    )
    IS
        v_old_tajszam CHAR(9);
    BEGIN
        SELECT tajszam
          INTO v_old_tajszam
          FROM Patient
         WHERE id = p_patient_id;
        IF v_old_tajszam <> p_tajszam THEN
            IF p_check_duplicate_tajszam(p_tajszam) THEN
                RAISE_APPLICATION_ERROR(
                    -20011,
                    'Nem frissíthetõ a TAJ-szám, mert már létezik: ' || p_tajszam
                );
            END IF;
        END IF;

        UPDATE Patient
           SET tajszam      = p_tajszam,
               patient_name = p_patient_name,
               birth_date   = p_birth_date,
               phone_number = p_phone_number,
               address      = p_address
         WHERE id = p_patient_id;

        COMMIT;
    END p_update_patient;

END pkg_patient;
/
