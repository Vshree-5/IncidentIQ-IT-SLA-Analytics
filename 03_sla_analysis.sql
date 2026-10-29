USE incidentiq;

-- SLA policy reference
SELECT priority, response_target_hours, resolution_target_hours
FROM sla_policies ORDER BY priority;

-- Sample response time in minutes
SELECT ticket_id, priority, created_at, first_response_at,
       TIMESTAMPDIFF(MINUTE,created_at,first_response_at) AS response_time_minutes
FROM tickets WHERE first_response_at IS NOT NULL LIMIT 10;

-- Overall response SLA (only tickets with a recorded first response)
SELECT COUNT(*) AS responded_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    > s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS response_sla_compliance_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
WHERE t.first_response_at IS NOT NULL;

-- Response SLA by priority
SELECT t.priority, COUNT(*) AS responded_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    > s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS response_sla_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
WHERE t.first_response_at IS NOT NULL
GROUP BY t.priority ORDER BY t.priority;

-- Response SLA by category
SELECT t.category, COUNT(*) AS responded_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    > s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS response_sla_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
WHERE t.first_response_at IS NOT NULL
GROUP BY t.category ORDER BY response_sla_percentage ASC;

-- Response SLA by department
SELECT d.department_name, COUNT(*) AS responded_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    > s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS response_sla_percentage
FROM tickets t
JOIN sla_policies s ON t.priority=s.priority
JOIN employees e ON t.employee_id=e.employee_id
JOIN departments d ON e.department_id=d.department_id
WHERE t.first_response_at IS NOT NULL
GROUP BY d.department_name ORDER BY response_sla_percentage ASC;

-- Response SLA by office
SELECT o.office_name, o.region, COUNT(*) AS responded_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    > s.response_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
                    <= s.response_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS response_sla_percentage
FROM tickets t
JOIN sla_policies s ON t.priority=s.priority
JOIN employees e ON t.employee_id=e.employee_id
JOIN offices o ON e.office_id=o.office_id
WHERE t.first_response_at IS NOT NULL
GROUP BY o.office_name,o.region ORDER BY response_sla_percentage ASC;

-- Overall resolution SLA (only tickets with recorded resolution)
SELECT COUNT(*) AS completed_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS resolution_sla_compliance_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
WHERE t.resolved_at IS NOT NULL;

-- Resolution SLA by priority
SELECT t.priority, COUNT(*) AS completed_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS resolution_sla_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
WHERE t.resolved_at IS NOT NULL
GROUP BY t.priority ORDER BY t.priority;

-- Response versus resolution compliance by priority (denominators differ)
SELECT t.priority,
       ROUND(SUM(CASE WHEN t.first_response_at IS NOT NULL
          AND TIMESTAMPDIFF(MINUTE,t.created_at,t.first_response_at)
              <= s.response_target_hours*60 THEN 1 ELSE 0 END)*100.0
          / SUM(t.first_response_at IS NOT NULL),2) AS response_sla_percentage,
       ROUND(SUM(CASE WHEN t.resolved_at IS NOT NULL
          AND TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
              <= s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0
          / SUM(t.resolved_at IS NOT NULL),2) AS resolution_sla_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
GROUP BY t.priority ORDER BY t.priority;

-- Resolution SLA by category
SELECT t.category, COUNT(*) AS completed_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS resolution_sla_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
WHERE t.resolved_at IS NOT NULL
GROUP BY t.category ORDER BY resolution_sla_percentage ASC;

-- Resolution SLA by department
SELECT d.department_name, COUNT(*) AS completed_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS resolution_sla_percentage
FROM tickets t
JOIN sla_policies s ON t.priority=s.priority
JOIN employees e ON t.employee_id=e.employee_id
JOIN departments d ON e.department_id=d.department_id
WHERE t.resolved_at IS NOT NULL
GROUP BY d.department_name ORDER BY resolution_sla_percentage ASC;

-- Resolution breaches by category: breach rate and share of all breaches
WITH category_breaches AS (
    SELECT t.category, COUNT(*) AS completed_tickets,
           SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breaches
    FROM tickets t JOIN sla_policies s ON t.priority=s.priority
    WHERE t.resolved_at IS NOT NULL
    GROUP BY t.category
)
SELECT category, completed_tickets, sla_breaches,
       ROUND(sla_breaches*100.0/completed_tickets,2) AS breach_rate_percentage,
       ROUND(sla_breaches*100.0/SUM(sla_breaches) OVER (),2) AS share_of_all_breaches
FROM category_breaches ORDER BY sla_breaches DESC;

-- Resolution breach rate by category and priority
SELECT t.category, t.priority, COUNT(*) AS completed_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breaches,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS breach_rate_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
WHERE t.resolved_at IS NOT NULL
GROUP BY t.category,t.priority ORDER BY t.category,t.priority;

-- Resolution breaches by priority and share of all breaches
WITH priority_breaches AS (
    SELECT t.priority, COUNT(*) AS completed_tickets,
           SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breaches
    FROM tickets t JOIN sla_policies s ON t.priority=s.priority
    WHERE t.resolved_at IS NOT NULL
    GROUP BY t.priority
)
SELECT priority, completed_tickets, sla_breaches,
       ROUND(sla_breaches*100.0/completed_tickets,2) AS breach_rate_percentage,
       ROUND(sla_breaches*100.0/SUM(sla_breaches) OVER (),2) AS share_of_all_breaches
FROM priority_breaches ORDER BY sla_breaches DESC;
