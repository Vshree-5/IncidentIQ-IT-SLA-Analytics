# IncidentIQ — Enterprise IT Incident & SLA Analytics

## 1. Project Overview

**Business problem:** Understand IT support performance, identify where SLA breaches are concentrated, and determine which areas require further investigation.

**Dataset:** Synthetic enterprise IT helpdesk data containing 45,000 tickets, 8,000 employees, 9,000 assets, 60 engineers, 10 departments, 6 offices, and 4 SLA policies.

**Tools:** MySQL 8.0, SQL, Power BI (planned).

**Analysis techniques:** Data quality validation, joins, aggregations, conditional logic, CTEs, window functions, ranking, and month-over-month analysis.

## 2. Executive Summary

The analysis identified a response SLA compliance rate of 75.65% among tickets with recorded first responses. There were 10,958 response SLA breaches.

For resolved tickets, 8,197 resolution SLA breaches were recorded. P3 tickets contributed the largest share of resolution breaches, while P2 had the highest resolution breach rate.

Performance also varied across ticket categories, departments, offices, support teams, and shifts. These differences identify opportunities for further investigation, but they do not establish the causes of SLA breaches.

## 3. Key Findings

### Finding 1: Response SLA Performance

- Responded tickets: 44,997.
- Tickets meeting response SLA: 34,039.
- Response SLA breaches: 10,958.
- Overall response SLA compliance: 75.65%.
- P3 had the lowest response compliance at 74.98% and the largest number of response breaches at 5,634.
- P4 response compliance was 75.07%.
- P2 had the highest response compliance at 79.30%.

### Finding 2: Ticket Categories

- VPN Failure had the highest response breach rate at 25.00%.
- Password Reset had the largest response breach count at 2,819.
- Laptop Issue contributed 2,692 response breaches.
- Network Outage had the lowest response breach rate at 21.33%.

### Finding 3: Department Performance

- Legal had the highest response breach rate at 26.09%, based on 621 responded tickets.
- IT followed at 25.62%.
- Engineering had the highest response breach count at 2,648.
- Human Resources had the lowest response breach rate at 22.96%.

### Finding 4: Office Performance

- Pune Annex had the highest response breach rate at 30.68%.
- London Office followed at 30.60%.
- Bengaluru Tech Park had the highest response breach count at 3,010.
- Gurugram Office had the lowest response breach rate at 19.44%.
- The difference between Pune Annex and Gurugram Office was 11.24 percentage points.

### Finding 5: Resolution SLA by Priority

| Priority | Resolved tickets | Breaches | Compliance |
|---|---:|---:|---:|
| P1 | 757 | 133 | 82.43% |
| P2 | 5,692 | 1,150 | 79.80% |
| P3 | 21,649 | 4,159 | 80.79% |
| P4 | 15,102 | 2,755 | 81.76% |

- P2 had the highest resolution breach rate at 20.20%.
- P3 had the highest resolution breach count at 4,159.
- P3 and P4 together contributed 84.35% of all resolution breaches.
- P1 had the highest resolution SLA compliance at 82.43%.

### Finding 6: Resolution SLA by Category

- VPN Failure had the lowest resolution compliance at 78.52%.
- Laptop Issue had the highest resolution breach count at 2,142.
- Password Reset contributed 1,967 resolution breaches.
- Laptop Issue and Password Reset together accounted for 50.13% of resolution breaches.
- VPN Failure had the highest resolution breach rate at 21.48%.

### Finding 7: Team and Shift Analysis

**Resolution SLA by team:**

- L1 Service Desk: 82.09% compliance.
- Hardware Team: 81.53%.
- L2 Desktop Support: 80.60%.
- Network Team: 78.66%.

**Resolution SLA by shift:**

- Morning: 81.49% compliance.
- Afternoon: 80.61%.
- Night: 78.53%.

Night shift compliance was 2.96 percentage points below morning shift compliance. Ticket mix, staffing, and workload would need to be investigated before attributing this difference to the shift itself.

### Finding 8: Monthly Trends

- Highest monthly resolution compliance: March 2024 at 82.88%.
- Lowest monthly resolution compliance: July 2024 at 78.54%.
- Largest month-over-month decline: 3.00 percentage points in July 2024.
- July 2025 had the highest resolved-ticket count at 3,595, with resolution compliance of 80.25%.

These movements identify periods for further investigation; they do not prove that ticket volume caused a change in compliance.

## 4. Recommended Business Actions

1. **Investigate P3 and P4 response breaches.** Examine their category mix, workload distribution, and response-time patterns.
2. **Review high-volume categories.** Prioritise Laptop Issue and Password Reset for resolution breach analysis, while investigating the high breach rates for VPN Failure.
3. **Compare office performance fairly.** Adjust comparisons for ticket priority, category, and volume before drawing conclusions.
4. **Investigate night shift resolution performance.** Compare staffing, ticket complexity, and assignment patterns with other shifts.
5. **Monitor monthly SLA trends.** Identify significant changes and investigate the ticket groups contributing to them.
6. **Build an interactive Power BI dashboard.** Allow management to filter SLA compliance and breaches by priority, category, department, office, team, shift, and month.

## 5. Data and Methodology Limitations

- The dataset is synthetic; findings are not evidence of real-world company performance.
- Response SLA compliance is calculated only for tickets with recorded first-response timestamps.
- Resolution SLA compliance is calculated only for tickets with recorded resolution timestamps.
- The response and resolution metrics use different ticket populations.
- The dataset does not contain a `closed_at` timestamp, so closure latency cannot be measured.
- Network Outage tickets do not have associated asset IDs, preventing reliable router failure-rate analysis from these tickets.
- Engineer comparisons may be affected by differences in ticket volume, priority, and category.
- Office and shift comparisons show associations, not causes.
- SLA targets are those defined in the supplied dataset and should not be presented as universal industry benchmarks.

## 6. Conclusion

IncidentIQ demonstrates how SQL can transform raw helpdesk records into actionable operational analysis. The project combines data validation, SLA calculations, segmentation, ranking, and trend analysis to identify where support performance deserves closer attention.

The next step is to build a Power BI dashboard that communicates these findings through clear KPIs, trends, and interactive breakdowns.