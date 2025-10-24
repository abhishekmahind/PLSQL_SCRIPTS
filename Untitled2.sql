CREATE TABLE employee (
    emp_id       NUMBER PRIMARY KEY,
    emp_name     VARCHAR2(50),
    dept_id      NUMBER,
    job_title    VARCHAR2(50),
    salary       NUMBER(10,2),
    hire_date    DATE
);

INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (101, 'Amit Sharma',     10, 'Software Engineer', 55000, TO_DATE('2020-02-15','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (102, 'Priya Nair',      20, 'HR Manager',        65000, TO_DATE('2018-07-20','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (103, 'Rohit Mehta',     10, 'Senior Developer',  72000, TO_DATE('2017-05-10','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (104, 'Sneha Gupta',     30, 'Data Analyst',      58000, TO_DATE('2021-09-01','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (105, 'Vikram Singh',    40, 'Team Lead',         90000, TO_DATE('2016-01-25','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (106, 'Neha Verma',      10, 'Software Engineer', 56000, TO_DATE('2020-06-18','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (107, 'Suresh Iyer',     20, 'Recruiter',         40000, TO_DATE('2022-04-05','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (108, 'Anjali Patel',    30, 'Business Analyst',  62000, TO_DATE('2019-03-15','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (109, 'Rahul Das',       40, 'Project Manager',   95000, TO_DATE('2015-08-09','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (110, 'Deepa Menon',     20, 'HR Executive',      45000, TO_DATE('2021-11-12','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (111, 'Karan Patel',     10, 'Tester',            48000, TO_DATE('2019-12-01','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (112, 'Manish Reddy',    30, 'Data Engineer',     70000, TO_DATE('2020-08-10','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (113, 'Shweta Joshi',    20, 'HR Assistant',      38000, TO_DATE('2023-01-20','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (114, 'Ravi Kumar',      40, 'Scrum Master',      87000, TO_DATE('2017-09-18','YYYY-MM-DD'));
INSERT INTO employee (emp_id, emp_name, dept_id, job_title, salary, hire_date) VALUES (115, 'Pooja Deshmukh',  10, 'Software Engineer', 53000, TO_DATE('2022-05-22','YYYY-MM-DD'));

COMMIT;



select emp_id,emp_name,dept_id, ROW_NUMBER()over (partition by dept_id order by salary) as rn from employee;

SELECT emp_name FROM employee e WHERE EXISTS (SELECT 1 FROM department d WHERE e.dept_id = d.dept_id);

EXPLAIN PLAN FOR 
SELECT emp_name, salary
FROM employee
WHERE dept_id = 10
ORDER BY salary DESC;


SELECT * FROM TABLE(DBMS_XPLAN.display)

CREATE INDEX idx_employee_deptid ON employee(dept_id);
