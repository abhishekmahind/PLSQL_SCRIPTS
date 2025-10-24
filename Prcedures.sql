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

CREATE OR REPLACE PROCEDURE show_emp_details_in(p_emp_id IN NUMBER)
IS
    v_name VARCHAR2(50);
    v_salary NUMBER;
    v_job_title VARCHAR2(50);
BEGIN
    SELECT emp_name,salary,job_title INTO v_name,v_salary,v_job_title
    FROM employee
    WHERE emp_id = p_emp_id;
    
    DBMS_OUTPUT.PUT_LINE('Employee Name  : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Salary         : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('Job Title      : ' || v_job_title);
    
EXCEPTION
    WHEN  NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee found with ID ' || p_emp_id);
END;

SET SERVEROUTPUT ON
EXEC  show_emp_details_in(101);


CREATE OR REPLACE PROCEDURE get_emp_name_out(p_emp_id IN NUMBER, p_emp_name OUT VARCHAR2)
IS
BEGIN
    SELECT emp_name INTO p_emp_name
    FROM employee
    WHERE emp_id = p_emp_id;
    
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME :'||p_emp_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No employee found with ID ' || p_emp_id);
END;


DECLARE
    V_NAME VARCHAR2(50);
BEGIN
    get_emp_name_out(101,V_NAME);
END;


CREATE OR REPLACE PROCEDURE adjust_salary_inout(p_emp_id IN NUMBER,p_adjust_amt IN OUT NUMBER)
IS
    v_salary NUMBER;
BEGIN
    SELECT salary INTO v_salary
    FROM employee
    where emp_id=p_emp_id;
    
    v_salary:=v_salary+p_adjust_amt;
    
    UPDATE employee
    SET salary = v_salary
    WHERE emp_id = p_emp_id;
    
    p_adjust_amt := v_salary;
    
    DBMS_OUTPUT.PUT_LINE('NEW SALARY :'|| v_salary);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('NO SUCH EMPLOYEE PRESENT ');
END;    
/


DECLARE
    v_new_salary NUMBER := 2000; -- adjustment amount
BEGIN
    adjust_salary_inout(101, v_new_salary);
    DBMS_OUTPUT.PUT_LINE('Returned New Salary = ' || v_new_salary);
END;
/


CREATE OR REPLACE PROCEDURE show_emp_in_dept(p_dept_id IN NUMBER)
IS
    CURSOR emp_cur IS
        SELECT emp_id, emp_name, salary
        FROM employee
        WHERE dept_id = p_dept_id;

    v_emp_id   employee.emp_id%TYPE;
    v_emp_name employee.emp_name%TYPE;
    v_salary   employee.salary%TYPE;
BEGIN
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO v_emp_id, v_emp_name, v_salary;
        EXIT WHEN emp_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp_id || 
                             ' | Name: ' || v_emp_name || 
                             ' | Salary: ' || v_salary);
    END LOOP;
    CLOSE emp_cur;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/