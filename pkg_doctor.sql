CREATE OR REPLACE PACKAGE pkg_doctor AS
    PROCEDURE p_create_doctor(
        p_doctor_name   IN VARCHAR2,
        p_phone_number  IN VARCHAR2
    );

    PROCEDURE p_update_doctor(
        p_doctor_id     IN NUMBER,
        p_doctor_name   IN VARCHAR2,
        p_phone_number  IN VARCHAR2
    );
END pkg_doctor;
/

