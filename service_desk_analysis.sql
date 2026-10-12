-- IT Service Desk Analytics: MySQL-compatible queries

-- 1. Monthly ticket volume
SELECT DATE_FORMAT(Created_Date, '%Y-%m') AS Month,
       COUNT(*) AS Total_Tickets
FROM service_desk_tickets
GROUP BY DATE_FORMAT(Created_Date, '%Y-%m')
ORDER BY Month;

-- 2. SLA compliance
SELECT ROUND(100.0 * SUM(SLA_Met) / COUNT(*), 2) AS SLA_Compliance_Pct
FROM service_desk_tickets;

-- 3. Average resolution time by priority
SELECT Priority, ROUND(AVG(Resolution_Hours), 2) AS Avg_Resolution_Hours
FROM service_desk_tickets
GROUP BY Priority
ORDER BY Avg_Resolution_Hours;

-- 4. Agent performance
SELECT Agent,
       COUNT(*) AS Tickets_Handled,
       ROUND(AVG(Resolution_Hours), 2) AS Avg_Resolution_Hours,
       ROUND(100.0 * SUM(SLA_Met) / COUNT(*), 2) AS SLA_Compliance_Pct
FROM service_desk_tickets
GROUP BY Agent
ORDER BY SLA_Compliance_Pct DESC;

-- 5. Ticket category analysis
SELECT Category, COUNT(*) AS Ticket_Count,
       ROUND(AVG(Resolution_Hours), 2) AS Avg_Resolution_Hours
FROM service_desk_tickets
GROUP BY Category
ORDER BY Ticket_Count DESC;

-- 6. SLA breaches
SELECT Ticket_ID, Priority, Category, Agent,
       Resolution_Hours, SLA_Hours
FROM service_desk_tickets
WHERE SLA_Met = 0
ORDER BY Resolution_Hours DESC;

-- 7. Open/pending backlog
SELECT Status, COUNT(*) AS Ticket_Count
FROM service_desk_tickets
WHERE Status IN ('Open','Pending')
GROUP BY Status;


-- 8. Total Ticket Volume & Status Breakdown
SELECT 
    status,
    COUNT(ticket_id) AS total_tickets,
    ROUND(100.0 * COUNT(ticket_id) / SUM(COUNT(ticket_id)) OVER(), 2) AS percentage
FROM service_desk_tickets
GROUP BY status
ORDER BY total_tickets DESC;

-- 9. Tickets by Priority & SLA Compliance
SELECT 
    priority,
    COUNT(ticket_id) AS total_tickets,
    SUM(CASE WHEN sla_status = 'Met' THEN 1 ELSE 0 END) AS sla_met,
    SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) AS sla_breached,
    ROUND(100.0 * SUM(CASE WHEN sla_status = 'Met' THEN 1 ELSE 0 END) / COUNT(ticket_id), 2) AS sla_compliance_rate
FROM service_desk_tickets
GROUP BY priority
ORDER BY total_tickets DESC;

-- 10. Average Resolution Time (in Hours) by Category
SELECT 
    priority,
    COUNT(ticket_id) AS total_tickets,
    SUM(CASE WHEN TIMESTAMPDIFF(HOUR, created_date, resolved_date) <= 24 THEN 1 ELSE 0 END) AS sla_met,
    SUM(CASE WHEN TIMESTAMPDIFF(HOUR, created_date, resolved_date) > 24 OR resolved_date IS NULL THEN 1 ELSE 0 END) AS sla_breached,
    ROUND(100.0 * SUM(CASE WHEN TIMESTAMPDIFF(HOUR, created_date, resolved_date) <= 24 THEN 1 ELSE 0 END) / COUNT(ticket_id), 2) AS sla_compliance_rate
FROM service_desk_tickets
GROUP BY priority
ORDER BY total_tickets DESC;

-- 11. Technician Performance Summary
SELECT 
    assigned_technician,
    COUNT(ticket_id) AS tickets_handled,
    ROUND(AVG(customer_satisfaction), 2) AS avg_csat,
    ROUND(100.0 * SUM(CASE WHEN sla_status = 'Met' THEN 1 ELSE 0 END) / COUNT(ticket_id), 2) AS sla_compliance_pct
FROM service_desk_tickets
WHERE assigned_technician IS NOT NULL
GROUP BY assigned_technician
ORDER BY tickets_handled DESC;