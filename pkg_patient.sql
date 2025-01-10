CREATE OR REPLACE PACKAGE pkg_patient AS
    
    PROCEDURE p_create_patient(
        p_tajszam       IN CHAR,
        p_patient_name  IN VARCHAR2,
        p_birth_date    IN DATE, 
        p_phone_number  IN VARCHAR2,
        p_address       IN VARCHAR2
    );

    PROCEDURE p_update_patient(
        p_patient_id    IN NUMBER,
        p_tajszam       IN CHAR,
        p_patient_name  IN VARCHAR2,
        p_birth_date    IN DATE,
        p_phone_number  IN VARCHAR2,
        p_address       IN VARCHAR2
    );

    FUNCTION p_check_duplicate_tajszam(
        p_tajszam IN CHAR
    ) RETURN BOOLEAN;

END pkg_patient;
/
