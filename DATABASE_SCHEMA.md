# HSCP-Rota Database Schema Documentation

## Overview

The HSCP-Rota (Healthcare Scheduling and Care Planning Rotation) system is designed to manage staff scheduling, shift assignments, and leave requests for healthcare facilities. This document provides comprehensive documentation of the database schema architecture.

## Schema Version
**Version:** 1.0  
**Last Updated:** October 2025

## Database Architecture

### Entity Relationship Overview

The database consists of 7 main tables organized into the following functional areas:

1. **User Management**: Users, Roles
2. **Organizational Structure**: Units
3. **Shift Management**: ShiftTemplates, RoleShiftTimings
4. **Scheduling**: Rota
5. **Leave Management**: LeaveRequests

---

## Table Specifications

### 1. Users Table

**Purpose:** Central repository for all staff members in the system.

**Key Features:**
- Uses SAP (Systems, Applications, and Products) identifier as the primary key
- Tracks employment status and dates
- Links to roles and organizational units

**Columns:**

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| SAP | VARCHAR(20) | PRIMARY KEY | Unique SAP identifier for each user |
| FirstName | VARCHAR(100) | NOT NULL | User's first name |
| LastName | VARCHAR(100) | NOT NULL | User's last name |
| Email | VARCHAR(255) | NOT NULL, UNIQUE | User's email address |
| PhoneNumber | VARCHAR(20) | - | Contact phone number |
| RoleID | INT | NOT NULL, FK | Reference to Roles table |
| UnitID | INT | FK | Reference to Units table (nullable for non-unit staff) |
| EmploymentStatus | VARCHAR(20) | NOT NULL, DEFAULT 'Active' | Current employment status |
| HireDate | DATE | NOT NULL | Date of hire |
| TerminationDate | DATE | - | Date of termination (if applicable) |
| CreatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| UpdatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

**Valid Employment Statuses:**
- `Active`: Currently employed and working
- `Inactive`: Temporarily inactive
- `OnLeave`: Currently on extended leave
- `Terminated`: Employment ended

**Relationships:**
- Many-to-One with Roles (via RoleID)
- Many-to-One with Units (via UnitID)
- One-to-Many with Rota (as staff member)
- One-to-Many with LeaveRequests (as requester)

---

### 2. Roles Table

**Purpose:** Defines user roles and their system permissions.

**Key Features:**
- Granular permission controls
- Distinguishes between staff and administrative roles
- Supports role-based access control (RBAC)

**Columns:**

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| RoleID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique role identifier |
| RoleName | VARCHAR(100) | NOT NULL, UNIQUE | Name of the role |
| Description | TEXT | - | Detailed role description |
| CanViewSchedule | BOOLEAN | NOT NULL, DEFAULT TRUE | Permission to view schedules |
| CanEditSchedule | BOOLEAN | NOT NULL, DEFAULT FALSE | Permission to modify schedules |
| CanApproveLeave | BOOLEAN | NOT NULL, DEFAULT FALSE | Permission to approve leave requests |
| CanManageUsers | BOOLEAN | NOT NULL, DEFAULT FALSE | Permission to manage user accounts |
| CanManageUnits | BOOLEAN | NOT NULL, DEFAULT FALSE | Permission to manage organizational units |
| IsStaffRole | BOOLEAN | NOT NULL, DEFAULT TRUE | Indicates if role represents clinical staff |
| CreatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| UpdatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

**Example Roles:**
- Nurse (clinical staff)
- Senior Nurse (clinical staff with scheduling rights)
- Ward Manager (full unit management)
- Administrator (system-wide management)
- Healthcare Assistant (clinical support staff)

**Relationships:**
- One-to-Many with Users
- One-to-Many with RoleShiftTimings

---

### 3. Units Table

**Purpose:** Represents organizational units, departments, or wards with their locations and staffing requirements.

**Key Features:**
- Hierarchical organization support
- Staffing requirement tracking
- Physical location information
- Active/inactive status management

**Columns:**

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| UnitID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique unit identifier |
| UnitName | VARCHAR(100) | NOT NULL, UNIQUE | Full name of the unit |
| UnitCode | VARCHAR(20) | NOT NULL, UNIQUE | Short code/abbreviation |
| Description | TEXT | - | Detailed unit description |
| Location | VARCHAR(255) | - | General location description |
| Building | VARCHAR(100) | - | Building name/number |
| Floor | VARCHAR(20) | - | Floor level |
| IsActive | BOOLEAN | NOT NULL, DEFAULT TRUE | Whether unit is currently active |
| MinStaffRequired | INT | NOT NULL, DEFAULT 1 | Minimum staff required per shift |
| MaxStaffCapacity | INT | - | Maximum staff that can be assigned |
| ManagerSAP | VARCHAR(20) | FK | SAP of the unit manager |
| CreatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| UpdatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

**Relationships:**
- One-to-Many with Users (as assigned unit)
- One-to-Many with Rota (as shift location)
- Many-to-One with Users (as unit manager)

---

### 4. ShiftTemplates Table

**Purpose:** Defines shift concepts and patterns that can be reused across the scheduling system.

**Key Features:**
- Template-based shift management
- Visual identification support (color coding)
- Active/inactive status for shift types

**Columns:**

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ShiftTemplateID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique shift template identifier |
| ShiftName | VARCHAR(100) | NOT NULL | Name of the shift (e.g., "Day Shift") |
| ShiftCode | VARCHAR(20) | NOT NULL | Short code for the shift |
| Description | TEXT | - | Detailed shift description |
| IsActive | BOOLEAN | NOT NULL, DEFAULT TRUE | Whether shift template is active |
| Color | VARCHAR(7) | - | Hex color code for UI display |
| CreatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| UpdatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

**Example Shift Templates:**
- Day Shift (07:00 - 15:00)
- Night Shift (23:00 - 07:00)
- Evening Shift (15:00 - 23:00)
- Long Day (07:00 - 19:00)
- On Call (variable hours)

**Relationships:**
- One-to-Many with RoleShiftTimings
- One-to-Many with Rota

---

### 5. RoleShiftTimings Table

**Purpose:** Defines precise start and end times for each role on each shift template, allowing role-specific shift hours.

**Key Features:**
- Role-specific shift timing customization
- Break time tracking
- Overnight shift support
- Unique constraint ensures one timing per role-shift combination

**Columns:**

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| RoleShiftTimingID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique timing identifier |
| RoleID | INT | NOT NULL, FK | Reference to Roles table |
| ShiftTemplateID | INT | NOT NULL, FK | Reference to ShiftTemplates table |
| StartTime | TIME | NOT NULL | Shift start time |
| EndTime | TIME | NOT NULL | Shift end time |
| BreakDurationMinutes | INT | NOT NULL, DEFAULT 0 | Total break time in minutes |
| IsOvernight | BOOLEAN | NOT NULL, DEFAULT FALSE | Indicates if shift spans midnight |
| CreatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| UpdatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

**Use Cases:**
- Nurses might work 07:00-15:00 on a day shift
- Healthcare Assistants might work 08:00-16:00 on the same day shift
- Senior Nurses might have extended hours 07:00-16:00

**Relationships:**
- Many-to-One with Roles
- Many-to-One with ShiftTemplates

---

### 6. Rota Table

**Purpose:** The main schedule/roster table storing actual shift assignments for staff members.

**Key Features:**
- Complete shift assignment tracking
- Status progression support
- Audit trail with creation tracking
- Flexible notes system

**Columns:**

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| RotaID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique rota entry identifier |
| SAP | VARCHAR(20) | NOT NULL, FK | Staff member's SAP identifier |
| UnitID | INT | NOT NULL, FK | Unit where shift is assigned |
| ShiftTemplateID | INT | NOT NULL, FK | Type of shift assigned |
| ShiftDate | DATE | NOT NULL | Date of the shift |
| StartTime | TIME | NOT NULL | Actual start time for this shift |
| EndTime | TIME | NOT NULL | Actual end time for this shift |
| Status | VARCHAR(20) | NOT NULL, DEFAULT 'Scheduled' | Current status of the shift |
| Notes | TEXT | - | Additional notes or comments |
| CreatedBy | VARCHAR(20) | NOT NULL, FK | SAP of user who created the entry |
| CreatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| UpdatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

**Valid Shift Statuses:**
- `Scheduled`: Initial assignment
- `Confirmed`: Staff member has confirmed
- `InProgress`: Shift is currently active
- `Completed`: Shift finished successfully
- `Cancelled`: Shift was cancelled
- `NoShow`: Staff member did not appear

**Relationships:**
- Many-to-One with Users (as assigned staff)
- Many-to-One with Units (as shift location)
- Many-to-One with ShiftTemplates (as shift type)
- Many-to-One with Users (as creator)

---

### 7. LeaveRequests Table

**Purpose:** Complete leave management system for tracking all leave requests from submission to approval.

**Key Features:**
- Comprehensive leave type support
- Full approval workflow tracking
- Date range validation
- Review comment system

**Columns:**

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| LeaveRequestID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique leave request identifier |
| SAP | VARCHAR(20) | NOT NULL, FK | Staff member requesting leave |
| LeaveType | VARCHAR(50) | NOT NULL | Type of leave requested |
| StartDate | DATE | NOT NULL | First day of leave |
| EndDate | DATE | NOT NULL | Last day of leave |
| TotalDays | DECIMAL(5,2) | NOT NULL | Total days requested (supports half days) |
| Reason | TEXT | - | Reason for leave request |
| Status | VARCHAR(20) | NOT NULL, DEFAULT 'Pending' | Current request status |
| RequestedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | When request was submitted |
| ReviewedBy | VARCHAR(20) | FK | SAP of reviewer (if reviewed) |
| ReviewedAt | TIMESTAMP | - | When request was reviewed |
| ReviewComments | TEXT | - | Comments from reviewer |
| CreatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| UpdatedAt | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

**Valid Leave Types:**
- `Annual`: Annual/vacation leave
- `Sick`: Sick leave
- `Maternity`: Maternity leave
- `Paternity`: Paternity leave
- `Compassionate`: Compassionate leave
- `Study`: Study/training leave
- `Unpaid`: Unpaid leave
- `Other`: Other leave types

**Valid Leave Statuses:**
- `Pending`: Awaiting review
- `Approved`: Leave approved
- `Rejected`: Leave rejected
- `Cancelled`: Leave cancelled (by system/manager)
- `Withdrawn`: Leave withdrawn by requester

**Relationships:**
- Many-to-One with Users (as requester)
- Many-to-One with Users (as reviewer)

---

## Data Integrity and Constraints

### Check Constraints

1. **Users.EmploymentStatus**: Must be one of: Active, Inactive, OnLeave, Terminated
2. **Units.MaxStaffCapacity**: Must be greater than or equal to MinStaffRequired
3. **RoleShiftTimings.BreakDurationMinutes**: Must be non-negative
4. **Rota.Status**: Must be one of: Scheduled, Confirmed, InProgress, Completed, Cancelled, NoShow
5. **LeaveRequests.LeaveType**: Must be valid leave type (see list above)
6. **LeaveRequests.Status**: Must be valid leave status (see list above)
7. **LeaveRequests.EndDate**: Must be greater than or equal to StartDate
8. **LeaveRequests.TotalDays**: Must be positive

### Unique Constraints

1. **Users.Email**: Each email must be unique
2. **Roles.RoleName**: Each role name must be unique
3. **Units.UnitName**: Each unit name must be unique
4. **Units.UnitCode**: Each unit code must be unique
5. **ShiftTemplates**: Combination of ShiftName and ShiftCode must be unique
6. **RoleShiftTimings**: Combination of RoleID and ShiftTemplateID must be unique

### Foreign Key Relationships

All foreign key relationships enforce referential integrity with proper cascading rules:

- Users reference Roles and Units
- Units reference Users (for manager)
- RoleShiftTimings reference Roles and ShiftTemplates
- Rota references Users, Units, and ShiftTemplates
- LeaveRequests reference Users (for requester and reviewer)

---

## Indexes for Performance

### Primary Indexes (Automatic)
- All primary keys are automatically indexed

### Secondary Indexes

**Users Table:**
- `idx_users_role`: On RoleID for role-based queries
- `idx_users_unit`: On UnitID for unit-based queries
- `idx_users_email`: On Email for login and lookups
- `idx_users_employment_status`: For filtering by employment status

**Rota Table:**
- `idx_rota_sap`: Staff member lookups
- `idx_rota_unit`: Unit-based schedule queries
- `idx_rota_shift`: Shift template queries
- `idx_rota_date`: Date-based schedule queries
- `idx_rota_status`: Status filtering
- `idx_rota_sap_date`: Composite for staff schedule by date
- `idx_rota_unit_date`: Composite for unit schedule by date

**LeaveRequests Table:**
- `idx_leaverequests_sap`: Staff member leave history
- `idx_leaverequests_status`: Status filtering
- `idx_leaverequests_dates`: Date range queries
- `idx_leaverequests_type`: Leave type filtering
- `idx_leaverequests_reviewer`: Reviewer workload queries

**RoleShiftTimings Table:**
- `idx_roleshifttimings_role`: Role-based timing lookups
- `idx_roleshifttimings_shift`: Shift template timing lookups

**Units Table:**
- `idx_units_manager`: Manager lookup
- `idx_units_active`: Active unit filtering

---

## Usage Examples

### Example 1: Creating a New User

```sql
INSERT INTO Users (SAP, FirstName, LastName, Email, RoleID, UnitID, HireDate)
VALUES ('SAP001234', 'Jane', 'Smith', 'jane.smith@hospital.com', 1, 1, '2024-01-15');
```

### Example 2: Scheduling a Shift

```sql
INSERT INTO Rota (SAP, UnitID, ShiftTemplateID, ShiftDate, StartTime, EndTime, CreatedBy)
VALUES ('SAP001234', 1, 1, '2025-10-15', '07:00:00', '15:00:00', 'SAP999999');
```

### Example 3: Submitting a Leave Request

```sql
INSERT INTO LeaveRequests (SAP, LeaveType, StartDate, EndDate, TotalDays, Reason)
VALUES ('SAP001234', 'Annual', '2025-12-20', '2025-12-27', 6.0, 'Christmas holiday');
```

### Example 4: Querying Staff Schedule

```sql
SELECT 
    u.FirstName,
    u.LastName,
    r.ShiftDate,
    st.ShiftName,
    r.StartTime,
    r.EndTime,
    r.Status
FROM Rota r
JOIN Users u ON r.SAP = u.SAP
JOIN ShiftTemplates st ON r.ShiftTemplateID = st.ShiftTemplateID
WHERE r.UnitID = 1 
    AND r.ShiftDate BETWEEN '2025-10-01' AND '2025-10-31'
ORDER BY r.ShiftDate, r.StartTime;
```

### Example 5: Checking Leave Availability

```sql
SELECT 
    u.FirstName,
    u.LastName,
    lr.LeaveType,
    lr.StartDate,
    lr.EndDate,
    lr.Status
FROM LeaveRequests lr
JOIN Users u ON lr.SAP = u.SAP
WHERE lr.Status = 'Approved'
    AND lr.StartDate <= '2025-10-31'
    AND lr.EndDate >= '2025-10-01';
```

---

## Implementation Notes

### Database Compatibility

This schema is designed to be compatible with:
- MySQL 5.7+
- MariaDB 10.2+
- PostgreSQL 9.6+ (with minor syntax adjustments)
- Microsoft SQL Server 2016+ (with minor syntax adjustments)

### Migration Considerations

When implementing this schema:

1. **Create tables in order**: Ensure parent tables (Roles, Units) are created before child tables (Users, Rota)
2. **Foreign key constraints**: Add after all tables are created to avoid circular dependency issues
3. **Indexes**: Create after initial data load for better performance
4. **Seed data**: Load sample roles and shift templates before user data

### Security Considerations

1. **Personal Data**: SAP, names, emails, and phone numbers are personal data - ensure GDPR compliance
2. **Access Control**: Implement application-level access controls based on role permissions
3. **Audit Trail**: CreatedAt, UpdatedAt, and CreatedBy fields support audit requirements
4. **Data Retention**: Consider implementing data retention policies for terminated employees

### Future Enhancements

Potential schema extensions for future versions:

1. **Shift Swaps**: Table for managing shift swap requests between staff
2. **Skills Matrix**: Track staff qualifications and certifications
3. **Budget Tracking**: Link shifts to cost centers and budget codes
4. **Overtime Tracking**: Monitor and report on overtime hours
5. **Notifications**: System for shift reminders and approvals
6. **Time Off Balances**: Track remaining leave allowances
7. **Recurring Shifts**: Support for repeating shift patterns

---

## Conclusion

This database schema provides a comprehensive foundation for the HSCP-Rota scheduling system. It supports:

✅ User management with role-based permissions  
✅ Organizational structure with units and locations  
✅ Flexible shift template system  
✅ Role-specific shift timing configuration  
✅ Complete schedule/roster management  
✅ Full leave request and approval workflow  

The schema is designed for scalability, data integrity, and performance while maintaining flexibility for future enhancements.

---

## Related Documentation

- 📚 **[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete guide to all project documentation
- 📊 **[ERD.md](ERD.md)** - Visual entity relationship diagrams
- 🚀 **[QUICK_START.md](QUICK_START.md)** - Practical SQL examples and operations
- 💻 **[schema.sql](schema.sql)** - SQL DDL implementation script
- 📖 **[README.md](README.md)** - Project overview

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Maintained by:** HSCP-Rota Development Team
