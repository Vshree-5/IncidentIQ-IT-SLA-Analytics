USE incidentiq;

-- Overall metrics
SELECT COUNT(*) AS total_tickets,
       COUNT(DISTINCT employee_id) AS employees_raising_tickets,
       COUNT(DISTINCT engineer_id) AS engineers_handling_tickets,
       COUNT(DISTINCT category) AS ticket_categories
FROM tickets;

-- Status distribution
SELECT status, COUNT(*) AS ticket_count,
       ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM tickets),2) AS percentage
FROM tickets GROUP BY status ORDER BY ticket_count DESC;

-- Priority distribution
SELECT priority, COUNT(*) AS ticket_count,
       ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM tickets),2) AS percentage
FROM tickets GROUP BY priority ORDER BY priority;

-- Category distribution
SELECT category, COUNT(*) AS ticket_count,
       ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM tickets),2) AS percentage
FROM tickets GROUP BY category ORDER BY ticket_count DESC;

-- Department ticket volume
SELECT d.department_name, COUNT(*) AS ticket_count,
       ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM tickets),2) AS percentage
FROM tickets t
JOIN employees e ON t.employee_id=e.employee_id
JOIN departments d ON e.department_id=d.department_id
GROUP BY d.department_name ORDER BY ticket_count DESC;

-- Office ticket volume
SELECT o.office_name, o.region, o.country, COUNT(*) AS ticket_count,
       ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM tickets),2) AS percentage
FROM tickets t
JOIN employees e ON t.employee_id=e.employee_id
JOIN offices o ON e.office_id=o.office_id
GROUP BY o.office_name, o.region, o.country
ORDER BY ticket_count DESC;
