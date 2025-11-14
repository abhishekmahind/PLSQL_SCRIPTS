CREATE OR REPLACE FUNCTION get_bonus (p_salary NUMBER)
RETURN NUMBER
IS
   v_bonus NUMBER;
BEGIN
   v_bonus := p_salary * 0.10;
   RETURN v_bonus;
END;

SELECT get_bonus(50000) FROM dual;

CREATE OR REPLACE FUNCTION get_square (v_number NUMBER)
RETURN NUMBER
IS
    v_square NUMBER;
BEGIN
    v_square:=v_number*v_number;
    RETURN v_square;
END;

SELECT get_square(10) FROM DUAL;


CREATE OR REPLACE FUNCTION get_emp_salary (p_emp_id NUMBER)
RETURN NUMBER
IS
    v_salary NUMBER;
BEGIN
    SELECT salary
    INTO v_salary
    FROM employee
    WHERE emp_id = p_emp_id;

    RETURN v_salary;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;

select get_emp_salary(101) salary from dual;

CREATE OR REPLACE FUNCTION get_emp_name (p_emp_id NUMBER)
RETURN VARCHAR2
IS
    v_name VARCHAR2(50);
BEGIN
    SELECT emp_name
    INTO v_name
    FROM employee
    where emp_id=p_emp_id;
    
   RETURN v_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'NO DATA FOUND';
END;

SELECT get_emp_name(101) FROM DUAL;

SELECT get_emp_name(999) FROM dual;


CREATE OR REPLACE FUNCTION get_total_salary(p_emp_id NUMBER, p_bonus_per NUMBER)
RETURN NUMBER
IS
    v_salary NUMBER;
    v_total_salary NUMBER;
BEGIN
    SELECT salary into v_salary
    FROM employee
    WHERE emp_id=p_emp_id;
    
    v_total_salary := v_salary+(v_salary*p_bonus_per/100);
    
    RETURN v_total_salary;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;

SELECT get_total_salary(101,5) FROM DUAL;

SELECT get_total_salary(999,6) FROM dual;

CREATE OR REPLACE FUNCTION is_in_department(p_emp_id NUMBER,p_dept_id NUMBER)
RETURN VARCHAR2
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM employee
    WHERE emp_id=p_emp_id and dept_id=p_dept_id;
    
    IF v_count>0 THEN
        RETURN 'YES';
    ELSE
        RETURN 'NO';
    END IF;
END;

SELECT is_in_department(109,50) FROM DUAL;


CREATE OR REPLACE FUNCTION get_avg_salary(p_dept_id NUMBER)
RETURN NUMBER
IS
    v_avg_salary NUMBER;
BEGIN
    SELECT AVG(salary) INTO v_avg_salary
    FROM employee
    WHERE dept_id=p_dept_id;
    
    RETURN v_avg_salary;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;

SELECT get_avg_salary(10) FROM DUAL;

CREATE OR REPLACE FUNCTION get_highest_salary_emp
RETURN VARCHAR2
IS
    v_name varchar2(50);
BEGIN
    SELECT emp_name INTO v_name
    FROM employee
    WHERE salary = (SELECT MAX(salary) FROM employee);
    
    RETURN v_name;
END;


SELECT get_highest_salary_emp FROM DUAL;

CREATE OR REPLACE FUNCTION get_years_of_service(p_emp_id NUMBER)
RETURN NUMBER
IS
    v_hire_date DATE;
    v_years NUMBER;
BEGIN
    SELECT hire_date INTO v_hire_date FROM employee
    WHERE emp_id=p_emp_id;
    
    v_years := TRUNC(MONTHS_BETWEEN(SYSDATE, v_hire_date)/12);
    
    RETURN v_years;
EXCEPTION 
    WHEN NO_DATA_FOUND
    THEN RETURN NULL;
END;

SELECT get_years_of_service(115) FROM DUAL;

SELECT A.*,get_years_of_service(A.emp_id) FROM employee A WHERE get_years_of_service(emp_id)>5 ORDER BY get_years_of_service(emp_id) DESC;

CREATE OR REPLACE FUNCTION get_emp_code(p_emp_id NUMBER, p_dept_id NUMBER)
RETURN VARCHAR2
IS 
    v_code VARCHAR(50);
BEGIN
    SELECT 'DEPT-' || dept_id || ' - EMP-' || emp_id
    INTO v_code
    FROM employee
    WHERE emp_id=p_emp_id AND dept_id=p_dept_id;
    
    RETURN v_code;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN 'NO SUCH DATA PRESENT';
END;
/

SELECT get_emp_code(115,10) FROM DUAL;

SELECT emp_id, dept_id, get_emp_code(emp_id,dept_id) FROM employee;


CREATE OR REPLACE FUNCTION give_raise(p_emp_id NUMBER,p_per NUMBER)
RETURN NUMBER
IS
    v_old_salary NUMBER;
    v_new_salary NUMBER;
    v_per NUMBER;
BEGIN
    SELECT salary INTO v_old_salary FROM employee
    WHERE emp_id=p_emp_id;
    
    UPDATE employee SET salary=salary+(salary*p_per/100)
    WHERE emp_id=p_emp_id
    RETURNING salary INTO v_new_salary;
    
    v_per:=p_per;
    
    RETURN v_new_salary;
    RETURN v_old_salary;
    RETURN v_per;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
/

SET SERVEROUTPUT ON;
DECLARE
    v_new_salary NUMBER;
BEGIN
    v_new_salary := give_raise(108, 10);
    DBMS_OUTPUT.PUT_LINE('New Salary = ' || v_new_salary);
END;