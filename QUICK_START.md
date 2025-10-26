# Quick Start Guide - HSCP-Rota Database

## Installation

### Step 1: Create Database

```sql
-- MySQL/MariaDB
CREATE DATABASE hscp_rota CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hscp_rota;

-- PostgreSQL
CREATE DATABASE hscp_rota WITH ENCODING 'UTF8';
\c hscp_rota
```

### Step 2: Run Schema Script

```bash
# MySQL/MariaDB
mysql -u username -p hscp_rota < schema.sql

# PostgreSQL (may require minor adjustments)
psql -U username -d hscp_rota -f schema.sql
```

### Step 3: Verify Installation

```sql
-- Check tables were created
SHOW TABLES;

-- Check sample data
SELECT RoleName FROM Roles;
SELECT ShiftName FROM ShiftTemplates;
```

## Common Operations

### User Management

#### Create a New User
```sql
INSERT INTO Users (SAP, FirstName, LastName, Email, RoleID, UnitID, HireDate)
VALUES ('SAP123456', 'John', 'Doe', 'john.doe@hospital.com', 1, 1, '2025-01-15');
```

#### Update User Role
```sql
UPDATE Users 
SET RoleID = 2, UpdatedAt = CURRENT_TIMESTAMP 
WHERE SAP = 'SAP123456';
```

#### Deactivate User
```sql
UPDATE Users 
SET EmploymentStatus = 'Inactive', 
    TerminationDate = CURRENT_DATE,
    UpdatedAt = CURRENT_TIMESTAMP
WHERE SAP = 'SAP123456';
```

### Schedule Management

#### Create a Single Shift
```sql
INSERT INTO Rota (SAP, UnitID, ShiftTemplateID, ShiftDate, StartTime, EndTime, CreatedBy)
VALUES ('SAP123456', 1, 1, '2025-10-15', '07:00:00', '15:00:00', 'SAP999999');
```

#### View Weekly Schedule for a Unit
```sql
SELECT 
    r.ShiftDate,
    CONCAT(u.FirstName, ' ', u.LastName) AS StaffName,
    ro.RoleName,
    st.ShiftName,
    r.StartTime,
    r.EndTime,
    r.Status
FROM Rota r
JOIN Users u ON r.SAP = u.SAP
JOIN Roles ro ON u.RoleID = ro.RoleID
JOIN ShiftTemplates st ON r.ShiftTemplateID = st.ShiftTemplateID
WHERE r.UnitID = 1 
    AND r.ShiftDate BETWEEN '2025-10-13' AND '2025-10-19'
ORDER BY r.ShiftDate, r.StartTime;
```

#### View Individual Staff Schedule
```sql
SELECT 
    r.ShiftDate,
    st.ShiftName,
    r.StartTime,
    r.EndTime,
    un.UnitName,
    r.Status
FROM Rota r
JOIN ShiftTemplates st ON r.ShiftTemplateID = st.ShiftTemplateID
JOIN Units un ON r.UnitID = un.UnitID
WHERE r.SAP = 'SAP123456'
    AND r.ShiftDate >= CURRENT_DATE
ORDER BY r.ShiftDate;
```

#### Cancel a Shift
```sql
UPDATE Rota 
SET Status = 'Cancelled', 
    Notes = 'Staff illness',
    UpdatedAt = CURRENT_TIMESTAMP
WHERE RotaID = 123;
```

### Leave Management

#### Submit Leave Request
```sql
INSERT INTO LeaveRequests (SAP, LeaveType, StartDate, EndDate, TotalDays, Reason)
VALUES ('SAP123456', 'Annual', '2025-12-20', '2025-12-27', 6.0, 'Christmas holiday');
```

#### View Pending Leave Requests
```sql
SELECT 
    lr.LeaveRequestID,
    CONCAT(u.FirstName, ' ', u.LastName) AS StaffName,
    u.Email,
    lr.LeaveType,
    lr.StartDate,
    lr.EndDate,
    lr.TotalDays,
    lr.Reason,
    lr.RequestedAt
FROM LeaveRequests lr
JOIN Users u ON lr.SAP = u.SAP
WHERE lr.Status = 'Pending'
ORDER BY lr.RequestedAt;
```

#### Approve Leave Request
```sql
UPDATE LeaveRequests 
SET Status = 'Approved',
    ReviewedBy = 'SAP999999',
    ReviewedAt = CURRENT_TIMESTAMP,
    ReviewComments = 'Approved - adequate coverage available',
    UpdatedAt = CURRENT_TIMESTAMP
WHERE LeaveRequestID = 123;
```

#### Check Staff Availability
```sql
-- Check who is on leave for a specific date range
SELECT 
    CONCAT(u.FirstName, ' ', u.LastName) AS StaffName,
    u.SAP,
    lr.LeaveType,
    lr.StartDate,
    lr.EndDate
FROM LeaveRequests lr
JOIN Users u ON lr.SAP = u.SAP
WHERE lr.Status = 'Approved'
    AND lr.StartDate <= '2025-10-31'
    AND lr.EndDate >= '2025-10-01'
ORDER BY lr.StartDate;
```

### Reporting Queries

#### Daily Staffing Report
```sql
SELECT 
    un.UnitName,
    st.ShiftName,
    COUNT(*) AS StaffCount,
    GROUP_CONCAT(CONCAT(u.FirstName, ' ', u.LastName) SEPARATOR ', ') AS StaffList
FROM Rota r
JOIN Users u ON r.SAP = u.SAP
JOIN Units un ON r.UnitID = un.UnitID
JOIN ShiftTemplates st ON r.ShiftTemplateID = st.ShiftTemplateID
WHERE r.ShiftDate = '2025-10-15'
    AND r.Status IN ('Scheduled', 'Confirmed')
GROUP BY un.UnitName, st.ShiftName
ORDER BY un.UnitName, st.ShiftName;
```

#### Staff Utilization Report
```sql
SELECT 
    u.SAP,
    CONCAT(u.FirstName, ' ', u.LastName) AS StaffName,
    ro.RoleName,
    COUNT(r.RotaID) AS ShiftsScheduled,
    SUM(TIMESTAMPDIFF(HOUR, r.StartTime, r.EndTime)) AS TotalHours
FROM Users u
JOIN Roles ro ON u.RoleID = ro.RoleID
LEFT JOIN Rota r ON u.SAP = r.SAP 
    AND r.ShiftDate BETWEEN '2025-10-01' AND '2025-10-31'
    AND r.Status != 'Cancelled'
WHERE u.EmploymentStatus = 'Active'
GROUP BY u.SAP, u.FirstName, u.LastName, ro.RoleName
ORDER BY TotalHours DESC;
```

#### Leave Balance Report
```sql
SELECT 
    u.SAP,
    CONCAT(u.FirstName, ' ', u.LastName) AS StaffName,
    SUM(CASE WHEN lr.Status = 'Approved' AND lr.LeaveType = 'Annual' 
        THEN lr.TotalDays ELSE 0 END) AS AnnualLeaveTaken,
    SUM(CASE WHEN lr.Status = 'Approved' AND lr.LeaveType = 'Sick' 
        THEN lr.TotalDays ELSE 0 END) AS SickLeaveTaken,
    SUM(CASE WHEN lr.Status = 'Pending' 
        THEN lr.TotalDays ELSE 0 END) AS LeavePending
FROM Users u
LEFT JOIN LeaveRequests lr ON u.SAP = lr.SAP 
    AND YEAR(lr.StartDate) = YEAR(CURRENT_DATE)
WHERE u.EmploymentStatus = 'Active'
GROUP BY u.SAP, u.FirstName, u.LastName
ORDER BY u.LastName, u.FirstName;
```

### Unit Management

#### Create a New Unit
```sql
INSERT INTO Units (UnitName, UnitCode, Description, Location, Building, Floor, MinStaffRequired, MaxStaffCapacity, ManagerSAP)
VALUES ('Cardiology Ward', 'CARD-1', 'Main cardiology ward', 'South Wing', 'Building A', '3rd Floor', 3, 8, 'SAP999999');
```

#### View Unit Details with Manager
```sql
SELECT 
    un.UnitName,
    un.UnitCode,
    un.Location,
    un.Building,
    un.Floor,
    un.MinStaffRequired,
    un.MaxStaffCapacity,
    CONCAT(u.FirstName, ' ', u.LastName) AS ManagerName,
    u.Email AS ManagerEmail
FROM Units un
LEFT JOIN Users u ON un.ManagerSAP = u.SAP
WHERE un.IsActive = TRUE
ORDER BY un.UnitName;
```

#### View Staff Assigned to Unit
```sql
SELECT 
    u.SAP,
    CONCAT(u.FirstName, ' ', u.LastName) AS StaffName,
    r.RoleName,
    u.Email,
    u.PhoneNumber,
    u.EmploymentStatus
FROM Users u
JOIN Roles r ON u.RoleID = r.RoleID
WHERE u.UnitID = 1
    AND u.EmploymentStatus = 'Active'
ORDER BY r.RoleName, u.LastName;
```

## Maintenance Operations

### Backup Database
```bash
# MySQL/MariaDB
mysqldump -u username -p hscp_rota > hscp_rota_backup_$(date +%Y%m%d).sql

# PostgreSQL
pg_dump -U username hscp_rota > hscp_rota_backup_$(date +%Y%m%d).sql
```

### Update Timestamps (if needed)
```sql
-- Update all UpdatedAt timestamps
UPDATE Users SET UpdatedAt = CURRENT_TIMESTAMP WHERE SAP = 'SAP123456';
UPDATE Rota SET UpdatedAt = CURRENT_TIMESTAMP WHERE RotaID = 123;
UPDATE LeaveRequests SET UpdatedAt = CURRENT_TIMESTAMP WHERE LeaveRequestID = 123;
```

### Archive Old Data
```sql
-- Archive completed shifts older than 2 years
CREATE TABLE Rota_Archive LIKE Rota;
INSERT INTO Rota_Archive 
SELECT * FROM Rota 
WHERE ShiftDate < DATE_SUB(CURRENT_DATE, INTERVAL 2 YEAR) 
    AND Status = 'Completed';
```

## Best Practices

### 1. Always Use Transactions for Multiple Changes
```sql
START TRANSACTION;

-- Your INSERT/UPDATE/DELETE statements here
INSERT INTO Rota (...) VALUES (...);
UPDATE Users SET ... WHERE ...;

-- Check if everything looks good
COMMIT;
-- Or if something went wrong: ROLLBACK;
```

### 2. Check for Conflicts Before Scheduling
```sql
-- Check if staff member is already scheduled
SELECT * FROM Rota 
WHERE SAP = 'SAP123456' 
    AND ShiftDate = '2025-10-15'
    AND Status IN ('Scheduled', 'Confirmed');

-- Check if staff member has approved leave
SELECT * FROM LeaveRequests 
WHERE SAP = 'SAP123456' 
    AND Status = 'Approved'
    AND '2025-10-15' BETWEEN StartDate AND EndDate;
```

### 3. Validate Permissions Before Actions
```sql
-- Check if user can edit schedules
SELECT CanEditSchedule FROM Roles r
JOIN Users u ON r.RoleID = u.RoleID
WHERE u.SAP = 'SAP123456';

-- Check if user can approve leave
SELECT CanApproveLeave FROM Roles r
JOIN Users u ON r.RoleID = u.RoleID
WHERE u.SAP = 'SAP123456';
```

### 4. Use Indexes for Performance
```sql
-- Already included in schema.sql
-- Queries on SAP, ShiftDate, UnitID, and Status are optimized
```

## Troubleshooting

### Cannot Delete User - Foreign Key Constraint
```sql
-- Option 1: Deactivate instead of delete
UPDATE Users SET EmploymentStatus = 'Terminated', TerminationDate = CURRENT_DATE WHERE SAP = 'SAP123456';

-- Option 2: Reassign their data first (not recommended)
-- Option 3: Use cascading deletes (modify foreign keys)
```

### Performance Issues
```sql
-- Check if indexes are being used
EXPLAIN SELECT * FROM Rota WHERE ShiftDate = '2025-10-15';

-- Analyze table statistics
ANALYZE TABLE Rota;
ANALYZE TABLE Users;
```

### Data Inconsistencies
```sql
-- Find rotas without valid users
SELECT r.* FROM Rota r
LEFT JOIN Users u ON r.SAP = u.SAP
WHERE u.SAP IS NULL;

-- Find leave requests without valid reviewers (should be NULL if not reviewed)
SELECT lr.* FROM LeaveRequests lr
LEFT JOIN Users u ON lr.ReviewedBy = u.SAP
WHERE lr.ReviewedBy IS NOT NULL AND u.SAP IS NULL;
```

## Related Documentation

For detailed information, refer to:
- 📚 **[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete guide to all project documentation
- 📝 **[DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)** - Complete schema documentation
- 📊 **[ERD.md](ERD.md)** - Entity relationship diagrams
- 💻 **[schema.sql](schema.sql)** - The actual database creation script
- 📖 **[README.md](README.md)** - Project overview

## Notes

- All times are stored in TIME format (HH:MM:SS)
- Dates are stored in DATE format (YYYY-MM-DD)
- Timestamps use TIMESTAMP with automatic timezone handling
- SAP identifiers are case-sensitive strings (use VARCHAR, not numeric)
- Always update the UpdatedAt field when modifying records
