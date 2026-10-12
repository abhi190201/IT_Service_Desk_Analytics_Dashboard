CREATE DATABASE IF NOT EXISTS service_desk_analytics;

USE service_desk_analytics;

CREATE TABLE service_desk_tickets (
    Ticket_ID VARCHAR(20) PRIMARY KEY,
    Created_Date DATETIME,
    Resolved_Date DATETIME,
    Category VARCHAR(50),
    Priority VARCHAR(20),
    Agent VARCHAR(50),
    Status VARCHAR(20),
    Resolution_Hours DECIMAL(10,2),
    SLA_Hours INT,
    SLA_Met INT
);

SHOW TABLES;