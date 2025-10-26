CREATE OR REPLACE FUNCTION function_name (parameter1 datatype, parameter2 datatype)
RETURN return_datatype
IS
   -- Declaration section
   variable_name datatype;
BEGIN
   -- Executable section
   -- Some logic
   RETURN some_value;
EXCEPTION
   -- Exception handling section
   WHEN others THEN
      RETURN null;
END;


CREATE OR REPLACE PROCEDURE procedure_name (parameter1 datatype, parameter2 datatype)
IS
   -- Declare local variables
BEGIN
   -- Write your logic here
EXCEPTION
   -- Optional error handling
END;


CURSOR cursor_name IS
    SELECT columns FROM table;

OPEN cursor_name;
FETCH cursor_name INTO variables;
CLOSE cursor_name;

DECLARE
    CURSOR cursor_name IS
        SELECT ...;

    v_variable datatype;
BEGIN
    OPEN cursor_name;

    LOOP
        FETCH cursor_name INTO v_variable;
        EXIT WHEN cursor_name%NOTFOUND;
        -- processing
    END LOOP;

    CLOSE cursor_name;
END;
/