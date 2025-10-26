DECLARE
    TYPE t_number IS TABLE OF employee.salary%type;
    l_salaries t_number;
BEGIN
    SELECT salary BULK COLLECT INTO l_salaries
    FROM employee;
    
    FOR i IN 1..l_salaries.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(l_salaries(i));
    END LOOP;
END;

DECLARE 
    TYPE t_ids IS TABLE OF employee.emp_id%type;
    l_ids t_ids;
BEGIN
    SELECT emp_id BULK COLLECT INTO l_ids
    FROM employee;
    
    FOR i IN 1..l_ids.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(l_ids(i));
    END LOOP;
END;