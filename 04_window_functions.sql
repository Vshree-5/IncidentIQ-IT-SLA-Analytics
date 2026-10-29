USE incidentiq;

-- Engineer-level resolution SLA performance
SELECT en.engineer_id, en.engineer_name, en.team, en.shift,
       COUNT(*) AS completed_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS resolution_sla_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
JOIN engineers en ON t.engineer_id=en.engineer_id
WHERE t.resolved_at IS NOT NULL
GROUP BY en.engineer_id,en.engineer_name,en.team,en.shift
ORDER BY resolution_sla_percentage ASC;

-- Resolution SLA by team
SELECT en.team, COUNT(*) AS completed_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS resolution_sla_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
JOIN engineers en ON t.engineer_id=en.engineer_id
WHERE t.resolved_at IS NOT NULL
GROUP BY en.team ORDER BY resolution_sla_percentage ASC;

-- Resolution SLA by shift
SELECT en.shift, COUNT(*) AS completed_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_met,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breached,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS resolution_sla_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
JOIN engineers en ON t.engineer_id=en.engineer_id
WHERE t.resolved_at IS NOT NULL
GROUP BY en.shift ORDER BY resolution_sla_percentage ASC;

-- Rank teams by resolution SLA compliance
WITH team_sla AS (
    SELECT en.team, COUNT(*) AS completed_tickets,
           ROUND(SUM(CASE
               WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0
           END)*100.0/COUNT(*),2) AS resolution_sla_percentage
    FROM tickets t JOIN sla_policies s ON t.priority=s.priority
    JOIN engineers en ON t.engineer_id=en.engineer_id
    WHERE t.resolved_at IS NOT NULL
    GROUP BY en.team
)
SELECT team, completed_tickets, resolution_sla_percentage,
       RANK() OVER (ORDER BY resolution_sla_percentage DESC) AS team_rank
FROM team_sla ORDER BY team_rank;

-- Monthly resolution SLA and month-over-month change
WITH monthly_sla AS (
    SELECT DATE_FORMAT(t.created_at,'%Y-%m') AS ticket_month,
           COUNT(*) AS completed_tickets,
           ROUND(SUM(CASE
               WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0
           END)*100.0/COUNT(*),2) AS resolution_sla_percentage
    FROM tickets t JOIN sla_policies s ON t.priority=s.priority
    WHERE t.resolved_at IS NOT NULL
    GROUP BY DATE_FORMAT(t.created_at,'%Y-%m')
),
monthly_comparison AS (
    SELECT ticket_month, completed_tickets, resolution_sla_percentage,
           LAG(resolution_sla_percentage) OVER (ORDER BY ticket_month) AS previous_month_sla
    FROM monthly_sla
)
SELECT ticket_month, completed_tickets, resolution_sla_percentage, previous_month_sla,
       ROUND(resolution_sla_percentage-previous_month_sla,2) AS month_over_month_change
FROM monthly_comparison ORDER BY ticket_month;

-- Five largest month-over-month declines
WITH monthly_sla AS (
    SELECT DATE_FORMAT(t.created_at,'%Y-%m') AS ticket_month,
           COUNT(*) AS completed_tickets,
           ROUND(SUM(CASE
               WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    <= s.resolution_target_hours*60 THEN 1 ELSE 0
           END)*100.0/COUNT(*),2) AS resolution_sla_percentage
    FROM tickets t JOIN sla_policies s ON t.priority=s.priority
    WHERE t.resolved_at IS NOT NULL
    GROUP BY DATE_FORMAT(t.created_at,'%Y-%m')
),
monthly_changes AS (
    SELECT ticket_month, completed_tickets, resolution_sla_percentage,
           LAG(resolution_sla_percentage) OVER (ORDER BY ticket_month) AS previous_month_sla
    FROM monthly_sla
)
SELECT ticket_month, completed_tickets, resolution_sla_percentage, previous_month_sla,
       ROUND(resolution_sla_percentage-previous_month_sla,2) AS month_over_month_change
FROM monthly_changes
WHERE previous_month_sla IS NOT NULL
ORDER BY month_over_month_change ASC
LIMIT 5;
