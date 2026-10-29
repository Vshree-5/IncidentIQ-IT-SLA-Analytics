USE incidentiq;

-- Additional analysis notes:
-- The detailed category-priority breach query is also in 03_sla_analysis.sql.
-- Use this file for focused investigations and portfolio-specific follow-ups.

-- Compare completed tickets and resolution breaches by category and priority.
SELECT t.category, t.priority, COUNT(*) AS completed_tickets,
       SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END) AS sla_breaches,
       ROUND(SUM(CASE WHEN TIMESTAMPDIFF(MINUTE,t.created_at,t.resolved_at)
                    > s.resolution_target_hours*60 THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
          AS breach_rate_percentage
FROM tickets t JOIN sla_policies s ON t.priority=s.priority
WHERE t.resolved_at IS NOT NULL
GROUP BY t.category,t.priority
ORDER BY t.category,t.priority;

-- Interpretation notes for README:
-- * Dataset is synthetic; describe findings as patterns in the dataset, not real company performance.
-- * Response SLA excludes tickets without first_response_at.
-- * Resolution SLA excludes tickets without resolved_at.
-- * The response and resolution populations differ.
-- * Targets are elapsed hours, not business-hours targets.
-- * created_at and event timestamps originated as UTC strings. Convert to office-local time
--   before any local weekday/hour analysis.
-- * There is no closed_at field, so closure latency cannot be calculated.
-- * The engineers table has no employee_id link; do not join it to employees by name.
-- * Network Outage tickets do not carry asset_id, so ticket data cannot establish router failure rates.
