CREATE OR REPLACE PACKAGE BODY Treatment_Pricing AS

    PROCEDURE Increase_All_Treatment_Costs(p_percentage IN NUMBER) IS
    BEGIN
        UPDATE Treatment
           SET cost = cost * (1 + p_percentage / 100);
        COMMIT;
    END Increase_All_Treatment_Costs;

    PROCEDURE Increase_Costs_By_Type(
        p_procedure_type IN VARCHAR2,
        p_percentage     IN NUMBER
    ) IS
    BEGIN
        UPDATE Treatment
           SET cost = cost * (1 + p_percentage / 100)
         WHERE procedure_type = p_procedure_type;
        COMMIT;
    END Increase_Costs_By_Type;

END Treatment_Pricing;
/


