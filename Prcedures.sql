CREATE OR REPLACE PROCEDURE show_emp_details (p_emp_id NUMBER)
IS
    v_name VARCHAR2(50);
    v_salary NUMBER;
BEGIN
    SELECT emp_name,salary INTO v_name,v_salary
    FROM employee WHERE emp_id=p_emp_id;
    
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME - '||v_name);
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE SALARY - '||v_salary);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('NO EMPLOYEE ID FOUND'||p_emp_id);
END;
/

EXEC show_emp_details(102);


CREATE OR REPLACE PROCEDURE show_dept_details(p_dept_id NUMBER)
IS
    v_count NUMBER := 0;
BEGIN
    -- Loop through employees in given department
    FOR i IN (SELECT emp_name FROM employee WHERE dept_id = p_dept_id) LOOP
        DBMS_OUTPUT.PUT_LINE(i.emp_name);
        v_count := v_count + 1;
    END LOOP;
    
    -- If no employees found
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('NO EMPLOYEES FOUND IN THIS DEPARTMENT.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/
    
EXEC show_dept_details(40);

CREATE OR REPLACE PROCEDURE show_emp_salary(p_emp_id IN NUMBER)
IS
    v_salary NUMBER;
BEGIN
    SELECT salary into v_salary from employee
    where emp_id=p_emp_id;
    DBMS_OUTPUT.PUT_LINE('Employee Salary: ' || v_salary);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE NOT FOUND');
END;
    
EXECUTE show_emp_salary(101);

CREATE OR REPLACE PROCEDURE get_emp_salary_IN_OUT(p_emp_id IN NUMBER, p_salary OUT NUMBER)
IS
BEGIN
    SELECT salary INTO p_salary
    FROM employee
    WHERE emp_id = p_emp_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_salary := NULL;
END;

DECLARE
    v_salary NUMBER;
BEGIN
    get_emp_salary_IN_OUT(101, v_salary);
    DBMS_OUTPUT.PUT_LINE('Salary = ' || v_salary);
END;    