DECLARE
    TYPE t_number IS TABLE OF employee.emp_id%type;
    l_e_id t_number;
BEGIN
    SELECT emp_id BULK COLLECT INTO l_e_id
    FROM employee;
    
    FORALL i IN 1..l_e_id.COUNT
        UPDATE employee SET salary=salary-1000
        WHERE emp_id=l_e_id(i);
        
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('SALRIES UPDATED FOR '||l_e_id.COUNT|| ' EMPLOYEES');
END;


DECLARE
    TYPE t_emp_rec IS RECORD (
    emp_id employee.emp_id%type,
    salary employee.salary%type);
    
    TYPE t_emp_table IS TABLE OF t_emp_rec;
    l_employees t_emp_table;
BEGIN
    SELECT emp_id, salary BULK COLLECT INTO l_employees
    FROM employee;
    
    FOR i IN 1..l_employees.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('EMP ID : '||l_employees(i).emp_id||' OLD SALARY : '||l_employees(i).salary);
    END LOOP;
    
    FORALL i IN 1..l_employees.COUNT
    UPDATE employee SET salary=salary-1000 WHERE emp_id=l_employees(i).emp_id;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Salaries Updated For '|| l_employees.COUNT ||' employees.');
END;


DECLARE
    TYPE t_emp_rec IS RECORD(
    emp_id employee.emp_id%type,
    emp_name employee.emp_name%type
    );
    
    TYPE t_emp IS TABLE OF t_emp_rec;
    l_emp t_emp;

BEGIN
    SELECT emp_id,emp_name BULK COLLECT INTO l_emp FROM employee;
    
    FOR i IN 1..l_emp.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('EMP ID : '||l_emp(i).emp_id||', EMP NAME : '||l_emp(i).emp_name);
    END LOOP;
END;


DECLARE
    TYPE t_emp_rec IS RECORD (
        emp_id employee.emp_id%TYPE,
        salary employee.salary%TYPE
    );
    TYPE t_emp_table IS TABLE OF t_emp_rec;
    l_employees t_emp_table;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp BULK COLLECT INTO l_employees LIMIT 100;  -- fetch 100 rows at a time
        EXIT WHEN l_employees.COUNT = 0;

        -- Process rows
        FORALL i IN 1..l_employees.COUNT
            UPDATE employee
            SET salary = salary + 500
            WHERE emp_id = l_employees(i).emp_id;

        COMMIT;
    END LOOP;
    CLOSE c_emp;
END;

1)Fetch all employee names using BULK COLLECT into a collection and print them.

DECLARE
    TYPE t_emp_name IS TABLE OF employee.emp_name%TYPE;
    l_emp_names t_emp_name;
BEGIN
    SELECT emp_name BULK COLLECT INTO l_emp_names
    FROM employee;
    
    FOR i IN 1..l_emp_names.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Employee : '||l_emp_names(i));
    END LOOP;
END;

2)Increase salary by 500 for all employees using BULK COLLECT + FORALL and print total updated rows.


DECLARE
    TYPE t_number IS TABLE OF employee.emp_id%TYPE;
    l_eid t_number;
BEGIN
    SELECT emp_id BULK COLLECT INTO l_eid FROM employee;
    
    FORALL i IN 1..l_eid.COUNT
        UPDATE employee SET salary=salary+500 WHERE emp_id=l_eid(i);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Rows Updated : '||l_eid.COUNT);
END;

3)Bulk collect only employees of Dept 20 and give them 10% salary raise using FORALL.


DECLARE
    TYPE t_number IS TABLE OF employee.emp_id%TYPE;
    l_eid t_number;
BEGIN
    SELECT emp_id BULK COLLECT INTO l_eid FROM employee
    WHERE dept_id=20;
    
    FORALL i IN 1..l_eid.COUNT
        UPDATE employee SET salary=salary+(salary*10/100) WHERE emp_id=l_eid(i);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Rows Updated : '||l_eid.COUNT);
END;

4)Store EMP_ID, SALARY in record collection.
Print both and then increase salary by 2000 using FORALL.

DECLARE
    TYPE t_rec_emp IS RECORD(
    emp_id employee.emp_id%TYPE,
    salary employee.salary%TYPE);
    
    TYPE t_emp IS TABLE OF t_rec_emp;
    l_emp_data t_emp;
BEGIN
    SELECT emp_id,salary BULK COLLECT INTO l_emp_data
    FROM employee;
    
    FOR i IN 1..l_emp_data.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Employee id : '||l_emp_data(i).emp_id||' Employee Salary : '||l_emp_data(i).salary);
    END LOOP;
    
    FORALL i IN 1..l_emp_data.COUNT
    UPDATE employee SET salary=salary+2000 WHERE emp_id=l_emp_data(i).emp_id;
    COMMIT;    
END;

5) Bulk collect employees earning less than 30000, increase salary by 20%.

DECLARE
    TYPE t_empdata IS TABLE OF employee.emp_id%TYPE;
    l_salaries t_empdata;
BEGIN 
    SELECT emp_id BULK COLLECT INTO l_salaries FROM employee
    WHERE salary<30000;
    
    FORALL i IN 1..l_salaries.COUNT
    UPDATE employee SET salary=salary+(salary*20/100) WHERE emp_id=l_salaries(i);
    COMMIT;
END;

6)Use a cursor + BULK COLLECT with LIMIT 50
Increase salary by 1000 in each batch and commit every loop iteration.

DECLARE CURSOR c_emp IS
    SELECT emp_id  FROM employee;
    TYPE t_emp_data IS TABLE OF employee.emp_id%TYPE;
    l_emp_data t_emp_data;
BEGIN
    OPEN c_emp;
    LOOP FETCH c_emp BULK COLLECT INTO l_emp_data LIMIT 50;
    EXIT WHEN l_emp_data.COUNT=0;
    FORALL i IN 1..l_emp_data.COUNT
            UPDATE employee
            SET salary = salary + 1000
            WHERE emp_id = l_emp_data(i);
    COMMIT;
        DBMS_OUTPUT.PUT_LINE('Salaries updated for: ' || l_emp_data.COUNT);
    END LOOP;
    CLOSE c_emp;
END;


7)Delete employees with salary > 500000 using FORALL.

DECLARE
    TYPE t_emp_data IS TABLE OF employee.emp_id%TYPE;
    l_emp_data t_emp_data;
BEGIN
    SELECT emp_id BULK COLLECT INTO l_emp_data
    FROM employee WHERE salary > 500000;
    
     IF l_emp_data.COUNT > 0 THEN
        FORALL i IN 1..l_emp_data.COUNT
            DELETE FROM employee WHERE emp_id = l_emp_data(i);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Deleted Employee Count: ' || l_emp_data.COUNT);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No Employees Found with Salary > 500000');
    END IF;
END;


8)Copy the first 20 employees to a duplicate table employee_backup using BULK COLLECT + FORALL.

DECLARE
    TYPE emp_tab IS TABLE OF employee%ROWTYPE;
    l_emp_tab emp_tab;
BEGIN
    SELECT * BULK COLLECT INTO l_emp_tab
    FROM (
        SELECT * FROM employee ORDER BY emp_id)
    WHERE ROWNUM <= 20;
    
    FORALL i IN 1..l_emp_tab.COUNT
        INSERT INTO employee_backup VALUES l_emp_tab(i);
    
    COMMIT;
END;


9)Bulk update salaries, but if some EMP_ID doesn’t exist, continue execution and later print failed index count.

DECLARE
    TYPE t_empdata IS TABLE OF employee.emp_id%type;
    l_empdata t_empdata;
    v_failed_count NUMBER := 0;
BEGIN
    SELECT emp_id BULK COLLECT INTO l_empdata
    FROM employee;

        FORALL i IN 1..l_empdata.COUNT SAVE EXCEPTIONS
            UPDATE employee SET salary=salary+1 WHERE emp_id=l_empdata(i);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Total Updated Rows: '|| SQL%ROWCOUNT);
EXCEPTION
    WHEN OTHERS THEN
        v_failed_count := SQL%BULK_EXCEPTIONS.COUNT;
        DBMS_OUTPUT.PUT_LINE('Failed Updates: '|| v_failed_count);
        
        FOR i IN 1..v_failed_count LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Index: ' || SQL%BULK_EXCEPTIONS(i).ERROR_INDEX ||
                ', Error Code: ' || SQL%BULK_EXCEPTIONS(i).ERROR_CODE
            );
        END LOOP;
END;

SET SERVEROUTPUT ON;