CREATE OR REPLACE TRIGGER AuditPatient
BEFORE INSERT OR UPDATE ON Patient
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        :NEW.last_modified_by := SYS_CONTEXT('USERENV', 'SESSION_USER');
        :NEW.last_modified_date := SYSDATE;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER AuditDoctor
BEFORE INSERT OR UPDATE ON Doctor
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        :NEW.last_modified_by := SYS_CONTEXT('USERENV', 'SESSION_USER');
        :NEW.last_modified_date := SYSDATE;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER AuditAppointment
BEFORE INSERT OR UPDATE ON Appointment
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        :NEW.last_modified_by := SYS_CONTEXT('USERENV', 'SESSION_USER');
        :NEW.last_modified_date := SYSDATE;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER AuditBill
BEFORE INSERT OR UPDATE ON Bill
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        :NEW.last_modified_by := SYS_CONTEXT('USERENV', 'SESSION_USER');
        :NEW.last_modified_date := SYSDATE;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER AuditTreatment
BEFORE INSERT OR UPDATE ON Treatment
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        :NEW.last_modified_by   := SYS_CONTEXT('USERENV', 'SESSION_USER');
        :NEW.last_modified_date := SYSDATE;
    END IF;
END;
/



