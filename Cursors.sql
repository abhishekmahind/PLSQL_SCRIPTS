--IMPICIT CURSOR (Automatic)
DECLARE
    v_salary NUMBER;
BEGIN
    SELECT salary INTO v_salary
    FROM employee
    WHERE emp_id = 101;

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
    END IF;
END;

DECLARE
    CURSOR emp_cursor IS
        SELECT emp_id, emp_name FROM employee;

    v_id employee.emp_id%TYPE;
    v_name employee.emp_name%TYPE;
BEGIN
    OPEN emp_cursor;

    LOOP
        FETCH emp_cursor INTO v_id, v_name;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' NAME: ' || v_name);
    END LOOP;

    CLOSE emp_cursor;
END;


DECLARE CURSOR c_emp
IS
    SELECT emp_name,salary FROM employee;
BEGIN
    FOR i IN c_emp LOOP
        DBMS_OUTPUT.PUT_LINE(i.emp_name || ' --- ' || i.salary);
    END LOOP;
END;

DECLARE CURSOR c_dept(p_dept NUMBER)
IS
    SELECT emp_name,dept_id FROM employee WHERE dept_id = p_dept;
BEGIN
    FOR i IN c_dept(20) LOOP
        DBMS_OUTPUT.PUT_LINE(i.emp_name || '--------'|| i.dept_id);
    END LOOP;
END;

ACCEPT P_DEPT NUMBER PROMPT 'Enter Department ID: ';
set serveroutput on 
DECLARE
    CURSOR c_dept(p_dept NUMBER) IS
        SELECT emp_name, dept_id 
        FROM employee 
        WHERE dept_id = p_dept;
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMPLOYEES IN DEPARTMENT: ' || &P_DEPT);

    FOR i IN c_dept(&P_DEPT) LOOP
        DBMS_OUTPUT.PUT_LINE(i.emp_name);
    END LOOP;
END;
/

DECLARE CURSOR c_dept
IS
    SELECT emp_name,dept_id FROM employee WHERE dept_id = &dept;
BEGIN
    FOR i IN c_dept LOOP
        DBMS_OUTPUT.PUT_LINE(i.emp_name || '--------'|| i.dept_id);
    END LOOP;
END;
/

DECLARE
    TYPE emp_ref IS REF CURSOR;
    c_emp emp_ref;
    v_salary employee.salary%TYPE;
    v_name employee.emp_name%TYPE;
BEGIN
    OPEN c_emp FOR SELECT emp_name,salary FROM employee;
    
    LOOP
        FETCH c_emp INTO v_name,v_salary;
        EXIT WHEN c_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name||'      '||v_salary);
    END LOOP;

    CLOSE c_emp;
END;
/

DECLARE
    CURSOR c1 IS
        SELECT emp_id, salary FROM employee FOR UPDATE;
BEGIN
    FOR rec IN c1 LOOP
        UPDATE employee
        SET salary = rec.salary + 500
        WHERE CURRENT OF c1;
    END LOOP;
END;
/

DECLARE
    TYPE t_salary IS TABLE OF employee.salary%TYPE;
    salaries t_salary;

    CURSOR c1 IS SELECT salary FROM employee;
BEGIN
    OPEN c1;
    FETCH c1 BULK COLLECT INTO salaries;
    CLOSE c1;

    FOR i IN 1..salaries.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(salaries(i));
    END LOOP;
END;


DECLARE 
    v_salary employee.salary%type;
    CURSOR C IS
    SELECT * FROM employee;
BEGIN
    SELECT AVG(salary) INTO v_salary FROM employee;
    FOR i in C LOOP
        IF i.salary>=v_salary THEN
        DBMS_OUTPUT.PUT_LINE(i.emp_name);
        END IF;
    END LOOP;
END;



DECLARE CURSOR C (p_dept_id NUMBER)
IS
SELECT * FROM employee WHERE dept_id = p_dept_id;
BEGIN
    FOR i IN C(10) LOOP
        DBMS_OUTPUT.PUT_LINE(i.emp_name);
    END LOOP;
END;

DECLARE CURSOR C IS
SELECT EMP_ID,SALARY FROM employee WHERE SALARY<50000 FOR UPDATE;
BEGIN
FOR I IN C LOOP
UPDATE employee SET SALARY=SALARY+500 WHERE CURRENT OF C;
DBMS_OUTPUT.PUT_LINE ('New Salary for Emp ' || I.emp_id || ' = ' || (I.salary + 500));
END LOOP;
COMMIT;
END;
/

DECLARE
    TYPE t_salary IS TABLE OF employee.salary%TYPE;
    salaries t_salary;

    CURSOR c1 IS SELECT salary FROM employee;
BEGIN
    OPEN c1;
    FETCH c1 BULK COLLECT INTO salaries;
    CLOSE c1;

    FOR i IN 1..salaries.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(salaries(i));
    END LOOP;
END;

DECLARE 
    TYPE t_salary IS TABLE OF employee.salary%type;
    salaries t_salary;
BEGIN
    SELECT EMP_ID,SALARY BULK COLLECT INTO salaries FROM employee;
    
    FORALL I IN 1..salaries.COUNT
        DBMS_OUT.PUT_LINE('SALARY OF EMP ID'||I.EMP_ID||'-----'||I.SALARY);
        UPDATE employee SET salary=salary+1000 WHERE EMP_ID=I.EMP_ID;
        DBMS_OUT.PUT_LINE(salaries.COUNT);
    END LOOP;
END;
