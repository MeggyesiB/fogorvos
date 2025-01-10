DROP PACKAGE pkg_appointment;
CREATE OR REPLACE PACKAGE pkg_appointment AS

   PROCEDURE p_create_appointment(
       p_patient_id        IN NUMBER,
       p_doctor_id         IN NUMBER,
       p_appointment_date  IN DATE,
       p_start_time        IN VARCHAR2,
       p_end_time          IN VARCHAR2,
       p_status            IN VARCHAR2,
       p_room              IN CHAR
   );

   PROCEDURE p_update_appointment_status(
       p_appointment_id    IN NUMBER,
       p_new_status        IN VARCHAR2
   );

   PROCEDURE p_cancel_appointment(
       p_appointment_id    IN NUMBER
   );

   PROCEDURE validate_appointment(
       p_appointment_date  IN DATE,
       p_start_time        IN VARCHAR2,
       p_end_time          IN VARCHAR2,
       p_status            IN VARCHAR2
   );

END pkg_appointment;
/
