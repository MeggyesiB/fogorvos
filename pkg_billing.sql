CREATE OR REPLACE PACKAGE pkg_billing AS
    PROCEDURE p_generate_bill(
        p_appointment_id IN NUMBER
    );
    
    PROCEDURE p_update_bill_amount(
        p_bill_id IN NUMBER
    );
END pkg_billing;
/
