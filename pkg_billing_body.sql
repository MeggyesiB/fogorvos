CREATE OR REPLACE PACKAGE BODY pkg_billing AS
    PROCEDURE p_generate_bill(
        p_appointment_id IN NUMBER
    )
    IS
        v_total_cost NUMBER := 0;
        v_status     Appointment.status%TYPE;
    BEGIN
        SELECT status
          INTO v_status
          FROM Appointment
         WHERE id = p_appointment_id;

        
        IF v_status <> 'Megjelent' THEN
            RAISE_APPLICATION_ERROR(-20012, 'Számlát csak "Megjelent" státuszú idõponthoz lehet generálni.');
        END IF;

   
        SELECT NVL(SUM(cost * quantity), 0)
          INTO v_total_cost
          FROM Treatment
         WHERE appointment_id = p_appointment_id;

     
        INSERT INTO Bill(
            id,
            bill_date,
            total_amount,
            appointment_id
        )
        VALUES(
            seq_bill_id.NEXTVAL,
            SYSDATE,
            v_total_cost,
            p_appointment_id
        );

        COMMIT;
    END p_generate_bill;

 ----------------------------------------------------------------------------
 ----------------------------------------------------------------------------
    
    PROCEDURE p_update_bill_amount(
        p_bill_id IN NUMBER
    )
    IS
        v_appointment_id NUMBER;
        v_new_total      NUMBER := 0;
    BEGIN
        SELECT appointment_id
          INTO v_appointment_id
          FROM Bill
         WHERE id = p_bill_id;

        SELECT NVL(SUM(cost * quantity), 0)
          INTO v_new_total
          FROM Treatment
         WHERE appointment_id = v_appointment_id;

       
        UPDATE Bill
           SET total_amount = v_new_total
         WHERE id = p_bill_id;

        COMMIT;
    END p_update_bill_amount;

END pkg_billing;
/
