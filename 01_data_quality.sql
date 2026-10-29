USE incidentiq;

-- Core table row counts
SELECT 'departments' AS table_name, COUNT(*) AS row_count FROM departments
UNION ALL SELECT 'offices', COUNT(*) FROM offices
UNION ALL SELECT 'employees', COUNT(*) FROM employees
UNION ALL SELECT 'engineers', COUNT(*) FROM engineers
UNION ALL SELECT 'assets', COUNT(*) FROM assets
UNION ALL SELECT 'sla_policies', COUNT(*) FROM sla_policies
UNION ALL SELECT 'tickets', COUNT(*) FROM tickets;

-- Ticket NULLs and uniqueness
SELECT COUNT(*) AS total_tickets,
       COUNT(DISTINCT ticket_id) AS unique_ticket_ids,
       SUM(employee_id IS NULL) AS missing_employee_id,
       SUM(engineer_id IS NULL) AS missing_engineer_id,
       SUM(asset_id IS NULL) AS missing_asset_id,
       SUM(category IS NULL) AS missing_category,
       SUM(priority IS NULL) AS missing_priority,
       SUM(status IS NULL) AS missing_status,
       SUM(created_at IS NULL) AS missing_created_at,
       SUM(first_response_at IS NULL) AS missing_first_response_at,
       SUM(resolved_at IS NULL) AS missing_resolved_at
FROM tickets;

-- Status distribution
SELECT status, COUNT(*) AS ticket_count
FROM tickets GROUP BY status ORDER BY ticket_count DESC;

-- Foreign-key checks
SELECT COUNT(*) AS invalid_employee_ids
FROM tickets t LEFT JOIN employees e ON t.employee_id=e.employee_id
WHERE e.employee_id IS NULL;

SELECT COUNT(*) AS invalid_engineer_ids
FROM tickets t LEFT JOIN engineers en ON t.engineer_id=en.engineer_id
WHERE en.engineer_id IS NULL;

SELECT COUNT(*) AS invalid_asset_ids
FROM tickets t LEFT JOIN assets a ON t.asset_id=a.asset_id
WHERE t.asset_id IS NOT NULL AND a.asset_id IS NULL;

SELECT COUNT(*) AS invalid_priority_values
FROM tickets t LEFT JOIN sla_policies s ON t.priority=s.priority
WHERE s.priority IS NULL;

SELECT COUNT(*) AS employees_with_invalid_department
FROM employees e LEFT JOIN departments d ON e.department_id=d.department_id
WHERE d.department_id IS NULL;

SELECT COUNT(*) AS employees_with_invalid_office
FROM employees e LEFT JOIN offices o ON e.office_id=o.office_id
WHERE o.office_id IS NULL;

-- NULL asset IDs and unresolved timestamps can be valid data, not errors.
