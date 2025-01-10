CREATE TABLE Patient (
    id                  NUMBER PRIMARY KEY,
    tajszam             CHAR(9),
    patient_name        VARCHAR2(50),
    birth_date          DATE,
    phone_number        VARCHAR2(12),
    address             VARCHAR2(200)
);


ALTER TABLE Patient
  ADD (
      last_modified_by   VARCHAR2(50),
      last_modified_date DATE
  );

ALTER TABLE Patient
  ADD (
      CONSTRAINT tajszam_format_ck CHECK (REGEXP_LIKE(tajszam, '^[0-9]{9}$')),
      CONSTRAINT tajszam_unique     UNIQUE (tajszam),
      CONSTRAINT phone_number_format_ck_patient CHECK (
          REGEXP_LIKE(phone_number, '^\+36(20|30|70)\d{7}$'))
   );



CREATE TABLE Doctor (
    id           NUMBER PRIMARY KEY,
    doctor_name  VARCHAR2(50),
    phone_number VARCHAR2(12)
);

ALTER TABLE Doctor
  ADD CONSTRAINT phone_number_format_ck_doctor CHECK (
      REGEXP_LIKE(phone_number, '^\+36(20|30|70)\d{7}$'
));
ALTER TABLE Doctor
  ADD (
      last_modified_by   VARCHAR2(50),
      last_modified_date DATE
  );



CREATE TABLE 
Appointment (
    id                NUMBER PRIMARY KEY,
    patient_id        NUMBER NOT NULL,
    doctor_id         NUMBER NOT NULL,
    appointment_date  DATE,
    start_time VARCHAR2(5),
    end_time   VARCHAR2(5),
    room CHAR(1) CHECK (room IN ('A', 'B', 'C')),
    status            VARCHAR2(14)
        CONSTRAINT status_ck
        CHECK (status IN ('Ütemezett', 'Megjelent', 'Lemondott'))
);

ALTER TABLE Appointment
  ADD (
      last_modified_by   VARCHAR2(50),
      last_modified_date DATE
  );

ALTER TABLE Appointment
  ADD (
      CONSTRAINT patient_fk FOREIGN KEY (patient_id) REFERENCES Patient(id),
      CONSTRAINT doctor_fk  FOREIGN KEY (doctor_id)  REFERENCES Doctor(id)
  );





CREATE TABLE Treatment (
    id              NUMBER PRIMARY KEY,
    appointment_id  NUMBER NOT NULL,
    procedure_type  VARCHAR2(50), 
    quantity        NUMBER NOT NULL, 
    cost            NUMBER NOT NULL
);

ALTER TABLE Treatment
  ADD (
      last_modified_by   VARCHAR2(50),
      last_modified_date DATE
  );

ALTER TABLE Treatment
  ADD (
      CONSTRAINT cost_ck CHECK (cost > 0),
      CONSTRAINT appointment_fk FOREIGN KEY (appointment_id) REFERENCES Appointment(id)
  );



CREATE TABLE Bill (
    id              NUMBER PRIMARY KEY,
    bill_date       DATE,
    total_amount    NUMBER NOT NULL,
    appointment_id  NUMBER NOT NULL
);

ALTER TABLE Bill
  ADD (
      last_modified_by   VARCHAR2(50),
      last_modified_date DATE
  );

ALTER TABLE Bill
  ADD CONSTRAINT appointment_fk_forbill FOREIGN KEY (appointment_id)
  REFERENCES Appointment(id);



