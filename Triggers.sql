CREATE OR REPLACE TRIGGER trg_after_insert
AFTER INSERT ON employee
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('New Employee Added: ' || :NEW.emp_name);
END;
/

:NEW — refers to the new values being inserted.
:OLD — refers to the old values before update/delete.

CREATE OR REPLACE TRIGGER trg_prevent_salary_drop
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be decreased!');
    END IF;
END;
/

select get_emp_salary(101) salary from dual;

--update employee set salary=734 where emp_id=101;

CREATE OR REPLACE TRIGGER trg_after_delete
AFTER DELETE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO employee_backup (emp_id, emp_name, salary, dept_id)
    VALUES (:OLD.emp_id, :OLD.emp_name, :OLD.salary, :OLD.dept_id);
END;
/

CREATE OR REPLACE TRIGGER trg_statement_level
AFTER UPDATE ON employee
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee table updated at: ' || SYSDATE);
END;
/

--Create a trigger to print a message whenever a record is inserted into employee.

CREATE OR REPLACE TRIGGER trg_after_insert
AFTER INSERT ON employee
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('New employee added: '||:NEW.emp_name);
END;

INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES 
(116, 'Pratik Sonwane',  10, 'Software Engineer', 40000, sysdate);


ALTER TRIGGER trg_prevent_salary_drop DISABLE;

--Prevent an employee’s salary from decreasing.
CREATE OR REPLACE TRIGGER trg_prevent_salary_drop
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF :NEW.salary<:OLD.salary
        THEN RAISE_APPLICATION_ERROR (-20001, 'Salary cannot be decreased!');
    END IF;
END;
--update employee set salary=734 where emp_id=101;
CREATE TABLE employee_log(
    emp_id       NUMBER,
    emp_name     VARCHAR2(50),
    dept_id      NUMBER,
    job_title    VARCHAR2(50),
    salary       NUMBER(10,2),
    hire_date    DATE
);

ALTER TABLE employee_log ADD (action_type VARCHAR2(20), action_date DATE);

--Log all deleted employee details into a backup table.
CREATE OR REPLACE TRIGGER trg_log_emp_dtl
BEFORE DELETE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO employee_log(
        emp_id, emp_name, dept_id, job_title, salary, hire_date, action_type, action_date
        )
    VALUES(
        :OLD.emp_id, :OLD.emp_name, :OLD.dept_id, :OLD.job_title, :OLD.salary, :OLD.hire_date,
        'DELETE', SYSDATE
    );
END;

delete from employee where emp_id=101;

--Before inserting a record, check if salary > 0, else raise an error.
CREATE OR REPLACE TRIGGER trg_check_emp_salary
BEFORE INSERT OR UPDATE ON employee
FOR EACH ROW
BEGIN 
    IF :NEW.salary<=0 THEN
        RAISE_APPLICATION_ERROR(-20001,'Salary cannot be less than zero');
    END IF;
END;

UPDATE employee SET salary=92000 WHERE emp_id=101;

--Create a statement-level trigger that fires whenever employee data is updated.
CREATE OR REPLACE TRIGGER trg_emp_data_added
AFTER INSERT OR UPDATE ON employee
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee data updated successfully');
END;

