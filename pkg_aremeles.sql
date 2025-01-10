CREATE OR REPLACE PACKAGE Treatment_Pricing AS

    PROCEDURE Increase_All_Treatment_Costs(p_percentage IN NUMBER);


    PROCEDURE Increase_Costs_By_Type(
        p_procedure_type IN VARCHAR2,
        p_percentage     IN NUMBER
    );

END Treatment_Pricing;
/
