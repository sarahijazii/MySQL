UPDATE employees
SET trainer_id = 1
WHERE employment_type = 'p'
  AND NAME LIKE '%John%'
  AND trainer_id IS NULL
  AND employee_id IN (SELECT employee_id FROM employees)
  AND NOT EXISTS (
    SELECT 1
    FROM sales s
    WHERE s.employee_id = employees.employee_id
);
