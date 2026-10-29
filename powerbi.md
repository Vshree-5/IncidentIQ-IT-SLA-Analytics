# IncidentIQ — Enterprise IT Incident & SLA Analytics

## Project Overview

IncidentIQ is an end-to-end data analytics project that analyses enterprise IT helpdesk tickets, Service Level Agreement (SLA) compliance, support-team workload, and office-level performance.

The goal is to transform raw incident data into actionable insights that help IT operations teams identify SLA breaches, monitor resolution performance, and prioritize areas for service improvement.

## Business Problem

Enterprise IT support teams need visibility into ticket volumes, response times, resolution times, and SLA compliance. Without consolidated reporting, it can be difficult to identify recurring service bottlenecks and compare performance across priorities, support teams, departments, and offices.

IncidentIQ addresses this challenge using SQL-based analysis and an interactive Power BI dashboard.

## Tools & Technologies

- **MySQL:** Data validation, joins, aggregations, CTEs, subqueries, window functions, and SLA analysis.
- **Power BI:** Interactive dashboards, KPI cards, trend analysis, and slicers.
- **DAX:** SLA compliance measures, breach-rate calculations, and context-aware metrics.
- **Data modelling:** Relationships across tickets, employees, departments, offices, engineers, and SLA policies.

## Dataset

The synthetic dataset contains:

| Table | Records |
|---|---:|
| Tickets | 45,000 |
| Employees | 8,000 |
| Assets | 9,000 |
| Engineers | 60 |
| Departments | 10 |
| Offices | 6 |
| SLA Policies | 4 |

The Power BI report uses the six primary analytical tables: tickets, employees, engineers, departments, offices, and SLA policies.

## Methodology

1. Validated source data and examined missing values and ticket statuses.
2. Connected related tables using appropriate keys and relationships.
3. Defined response and resolution SLA calculations using the supplied priority-based targets.
4. Analysed compliance by priority, category, department, office, support team, engineer, and month.
5. Built DAX measures and validated key results against SQL outputs.
6. Developed a three-page interactive Power BI report.

## Key Findings

### Overall SLA Performance

| Metric | Result |
|---|---:|
| Total tickets | 45,000 |
| Response SLA compliance | 75.65% |
| Resolution SLA compliance | 81.03% |
| Tickets with recorded first responses | 44,997 |
| Tickets with recorded resolution timestamps | 43,200 |

### Response SLA Analysis

- P2 had the highest response SLA compliance at 79.30%.
- P3 had the lowest response SLA compliance at 74.98%.
- Pune Annex recorded the highest office-level response SLA breach rate at 30.68%.
- Gurugram Office recorded the lowest at 19.44%, a difference of 11.24 percentage points.

### Resolution SLA Analysis

- P1 had the highest resolution SLA compliance at 82.43%.
- P2 had the lowest at 79.80%.
- Laptop Issues and Password Resets together accounted for approximately 50.13% of resolution SLA breaches by category.
- VPN Failures had the highest category-level resolution breach rate at 21.48%.

### Monthly Trends

- Monthly resolution SLA compliance ranged from 78.54% to 82.88% in the analysed period.
- The highest monthly compliance was recorded in March 2024.
- The lowest was recorded in July 2024.
- July 2025 had the highest resolved-ticket volume among the reported months, at 3,595 tickets.

These are descriptive findings; additional investigation would be required to establish the causes of observed differences.

## Power BI Dashboard

### Page 1 — Executive Overview
Provides a high-level view of ticket volume, overall SLA compliance, monthly ticket trends, and priority-level performance.

### Page 2 — SLA Analysis
Compares response and resolution SLA compliance across priorities and displays monthly resolution compliance trends.

### Page 3 — Team & Office Analysis
Examines support-team resolution compliance, ticket workload by team, office-level response breach rates, and resolved-ticket volume.

Interactive slicers allow users to explore results by priority, status, and office.

## Business Recommendations

1. Investigate the causes of higher response SLA breach rates at Pune Annex and London Office.
2. Review P2 resolution workflows, as P2 had the lowest resolution SLA compliance.
3. Examine Laptop Issue and Password Reset resolution processes to identify recurring sources of SLA breaches.
4. Assess ticket allocation, complexity, staffing, and escalation patterns before making support-team performance decisions.
5. Monitor monthly SLA trends and establish follow-up actions for periods with lower compliance.

## Data Limitations

- The dataset is synthetic; findings are illustrative rather than evidence of real enterprise performance.
- SLA targets are defined by the dataset and should not be interpreted as industry benchmarks.
- Some tickets have missing response or resolution timestamps. SLA calculations use tickets with the relevant timestamps.
- Asset identifiers are missing for many tickets, limiting asset-level analysis.
- Ticket closure time cannot be calculated because a separate closure timestamp is not available.
- Differences across offices, teams, and engineers do not establish causation or indicate individual performance without further context and case-mix adjustment.

## Project Outcome

IncidentIQ demonstrates practical skills in SQL analytics, data modelling, DAX, KPI development, SLA monitoring, and interactive dashboard design. It translates a multi-table incident dataset into a structured reporting solution that supports operational analysis and evidence-based decision-making.

*Note: The dataset and results are synthetic and intended for portfolio and learning purposes.*