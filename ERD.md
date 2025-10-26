# Entity Relationship Diagram (ERD)

## HSCP-Rota Database Schema

This document provides a visual representation of the database structure and relationships.

## Visual ERD

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         HSCP-Rota Database Schema                           │
│                     Entity Relationship Diagram (ERD)                       │
└─────────────────────────────────────────────────────────────────────────────┘


                              ┌──────────────────┐
                              │      Roles       │
                              ├──────────────────┤
                              │ PK: RoleID       │
                              │     RoleName     │
                              │     Description  │
                              │     Permissions  │
                              │     IsStaffRole  │
                              └────────┬─────────┘
                                       │
                                       │ 1
                                       │
                                       │ N
                      ┌────────────────┴────────────────┐
                      │                                  │
            ┌─────────▼─────────┐              ┌────────▼──────────┐
            │      Users        │              │ RoleShiftTimings  │
            ├───────────────────┤              ├───────────────────┤
            │ PK: SAP           │              │ PK: RoleShiftID   │
            │     FirstName     │              │ FK: RoleID        │
            │     LastName      │              │ FK: ShiftTemplateID│
            │     Email         │              │     StartTime     │
            │     PhoneNumber   │              │     EndTime       │
            │ FK: RoleID        │              │     BreakDuration │
            │ FK: UnitID        │              │     IsOvernight   │
            │     EmployStatus  │              └─────────┬─────────┘
            │     HireDate      │                        │
            └─────────┬─────────┘                        │ N
                      │                                  │
                      │ N                                │ 1
                      │                          ┌───────▼───────────┐
                      │                          │  ShiftTemplates   │
            ┌─────────┴─────────┐                ├───────────────────┤
            │                   │                │ PK: ShiftTemplateID│
    ┌───────▼────────┐  ┌──────▼───────┐        │     ShiftName     │
    │     Rota       │  │LeaveRequests │        │     ShiftCode     │
    ├────────────────┤  ├──────────────┤        │     Description   │
    │ PK: RotaID     │  │ PK: LeaveID  │        │     IsActive      │
    │ FK: SAP        │  │ FK: SAP      │        │     Color         │
    │ FK: UnitID     │  │     LeaveType│        └─────────┬─────────┘
    │ FK: ShiftTempID│  │     StartDate│                  │
    │     ShiftDate  │  │     EndDate  │                  │ 1
    │     StartTime  │  │     TotalDays│                  │
    │     EndTime    │  │     Reason   │                  │ N
    │     Status     │  │     Status   │          ┌───────▼─────────┐
    │     Notes      │  │ FK: ReviewedBy│         │      Rota       │
    │ FK: CreatedBy  │  │   ReviewedAt │         │  (Reference)    │
    └───────┬────────┘  │   ReviewCmts │         └─────────────────┘
            │           └──────────────┘
            │ N
            │
            │ 1
      ┌─────▼──────┐
      │   Units    │
      ├────────────┤
      │ PK: UnitID │
      │     UnitName│
      │     UnitCode│
      │     Location│
      │     Building│
      │     Floor   │
      │     IsActive│
      │     MinStaff│
      │     MaxStaff│
      │ FK: ManagerSAP│
      └────────────┘


═══════════════════════════════════════════════════════════════════════════════
                            RELATIONSHIP SUMMARY
═══════════════════════════════════════════════════════════════════════════════

┌─────────────────┬────────┬─────────────────┬──────────────────────────────┐
│ Parent Table    │ Rel.   │ Child Table     │ Relationship Description     │
├─────────────────┼────────┼─────────────────┼──────────────────────────────┤
│ Roles           │ 1 : N  │ Users           │ Each role has many users     │
│ Roles           │ 1 : N  │ RoleShiftTimings│ Each role has many timings   │
│ Users           │ 1 : N  │ Rota            │ Each user has many shifts    │
│ Users           │ 1 : N  │ LeaveRequests   │ Each user has many leaves    │
│ Users           │ 1 : N  │ Rota (Creator)  │ User creates many rotas      │
│ Users           │ 1 : N  │ LeaveRequests   │ User reviews many leaves     │
│ Users           │ 1 : N  │ Units (Manager) │ User manages many units      │
│ Units           │ 1 : N  │ Users           │ Each unit has many users     │
│ Units           │ 1 : N  │ Rota            │ Each unit has many shifts    │
│ ShiftTemplates  │ 1 : N  │ RoleShiftTimings│ Each template has many times │
│ ShiftTemplates  │ 1 : N  │ Rota            │ Each template has many shifts│
└─────────────────┴────────┴─────────────────┴──────────────────────────────┘

```

## Detailed Relationship Descriptions

### 1. Roles → Users (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each role can be assigned to multiple users, but each user has exactly one role
- **Foreign Key**: Users.RoleID → Roles.RoleID
- **Business Rule**: Users must have a valid role assignment

### 2. Roles → RoleShiftTimings (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each role can have multiple shift timings (one per shift template)
- **Foreign Key**: RoleShiftTimings.RoleID → Roles.RoleID
- **Business Rule**: Defines when each role works during different shift types

### 3. Units → Users (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each unit can have multiple users assigned, users can be assigned to one unit
- **Foreign Key**: Users.UnitID → Units.UnitID
- **Business Rule**: Optional - some users may not be assigned to a specific unit

### 4. Users → Units (Manager) (1:N)
- **Cardinality**: One-to-Many
- **Description**: A user can manage multiple units, each unit has one manager
- **Foreign Key**: Units.ManagerSAP → Users.SAP
- **Business Rule**: Unit managers must be valid users in the system

### 5. ShiftTemplates → RoleShiftTimings (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each shift template can have multiple role-specific timings
- **Foreign Key**: RoleShiftTimings.ShiftTemplateID → ShiftTemplates.ShiftTemplateID
- **Business Rule**: Defines precise hours for each role on each shift type

### 6. Users → Rota (Staff Assignment) (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each user can have multiple shift assignments
- **Foreign Key**: Rota.SAP → Users.SAP
- **Business Rule**: The assigned staff member must be an active user

### 7. Users → Rota (Creator) (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each user can create multiple rota entries
- **Foreign Key**: Rota.CreatedBy → Users.SAP
- **Business Rule**: Tracks who scheduled each shift for audit purposes

### 8. Units → Rota (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each unit has multiple shift assignments over time
- **Foreign Key**: Rota.UnitID → Units.UnitID
- **Business Rule**: All shifts must be assigned to a valid unit

### 9. ShiftTemplates → Rota (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each shift template is used for multiple actual shifts
- **Foreign Key**: Rota.ShiftTemplateID → ShiftTemplates.ShiftTemplateID
- **Business Rule**: Defines the type of shift being worked

### 10. Users → LeaveRequests (Requester) (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each user can submit multiple leave requests
- **Foreign Key**: LeaveRequests.SAP → Users.SAP
- **Business Rule**: Leave requester must be a valid user

### 11. Users → LeaveRequests (Reviewer) (1:N)
- **Cardinality**: One-to-Many
- **Description**: Each user can review multiple leave requests
- **Foreign Key**: LeaveRequests.ReviewedBy → Users.SAP
- **Business Rule**: Optional - only set when leave is reviewed

## Key Design Patterns

### 1. Template Pattern
**Applied to**: ShiftTemplates and RoleShiftTimings
- Shift templates define reusable shift concepts
- RoleShiftTimings customize templates for specific roles
- Actual shifts in Rota reference templates but can override times

### 2. Audit Trail Pattern
**Applied to**: All tables
- CreatedAt and UpdatedAt timestamps on all tables
- CreatedBy field on Rota table tracks who scheduled shifts
- ReviewedBy and ReviewedAt on LeaveRequests tracks approval workflow

### 3. Soft Delete Pattern
**Applied to**: Units, ShiftTemplates
- IsActive flag allows logical deletion
- Preserves historical data while hiding inactive records
- Maintains referential integrity for historical shifts

### 4. Status Pattern
**Applied to**: Rota, LeaveRequests, Users
- Enumerated status values track entity lifecycle
- Enables workflow management and filtering
- Supports reporting and analytics

### 5. Self-Referencing Pattern
**Applied to**: Users ↔ Units (Manager)
- Users can manage units
- Units reference their manager
- Enables organizational hierarchy

## Cardinality Legend

```
1 : 1  = One-to-One relationship
1 : N  = One-to-Many relationship
N : M  = Many-to-Many relationship (requires junction table)
```

## Referential Integrity Rules

All foreign key relationships enforce the following:

- **ON DELETE**: RESTRICT (default) - Prevents deletion of parent records with children
- **ON UPDATE**: CASCADE - Updates propagate to child records
- **Exceptions**: 
  - Units.ManagerSAP: SET NULL on delete (unit can exist without manager temporarily)
  - Users.UnitID: SET NULL on delete (user can exist without unit assignment)

## Data Flow Examples

### Example 1: Creating a Weekly Schedule

```
1. Scheduler (User) logs in
   └─> Check User.RoleID permissions (CanEditSchedule = TRUE)

2. Select Unit
   └─> Query Units WHERE IsActive = TRUE

3. Select Staff Members
   └─> Query Users WHERE UnitID = [selected unit] AND EmploymentStatus = 'Active'

4. Select Shift Template
   └─> Query ShiftTemplates WHERE IsActive = TRUE

5. Retrieve Role-Specific Timings
   └─> Query RoleShiftTimings WHERE ShiftTemplateID = [template] AND RoleID = [staff role]

6. Create Rota Entry
   └─> INSERT INTO Rota (SAP, UnitID, ShiftTemplateID, ShiftDate, StartTime, EndTime, CreatedBy)
```

### Example 2: Leave Request Approval

```
1. Staff Member submits leave request
   └─> INSERT INTO LeaveRequests (SAP, LeaveType, StartDate, EndDate, TotalDays, Reason)
   └─> Status = 'Pending'

2. Manager reviews request
   └─> Query LeaveRequests WHERE Status = 'Pending' AND SAP IN (SELECT SAP FROM Users WHERE UnitID = [manager's units])

3. Check for conflicts
   └─> Query Rota WHERE SAP = [requester] AND ShiftDate BETWEEN [start] AND [end]

4. Approve or reject
   └─> UPDATE LeaveRequests SET Status = 'Approved', ReviewedBy = [manager SAP], ReviewedAt = NOW()
```

### Example 3: Generating Unit Schedule Report

```
1. Query all shifts for unit and date range
   └─> SELECT * FROM Rota WHERE UnitID = [unit] AND ShiftDate BETWEEN [start] AND [end]

2. Join with user details
   └─> JOIN Users ON Rota.SAP = Users.SAP

3. Join with role information
   └─> JOIN Roles ON Users.RoleID = Roles.RoleID

4. Join with shift template details
   └─> JOIN ShiftTemplates ON Rota.ShiftTemplateID = ShiftTemplates.ShiftTemplateID

5. Check for approved leave
   └─> LEFT JOIN LeaveRequests ON (LeaveRequests.SAP = Rota.SAP AND LeaveRequests.Status = 'Approved')

6. Order and format results
   └─> ORDER BY ShiftDate, StartTime
```

## Database Normalization

### Normalization Level: 3NF (Third Normal Form)

The schema adheres to Third Normal Form principles:

1. **First Normal Form (1NF)**
   - All tables have primary keys
   - All columns contain atomic values
   - No repeating groups

2. **Second Normal Form (2NF)**
   - All non-key attributes depend on the entire primary key
   - No partial dependencies

3. **Third Normal Form (3NF)**
   - No transitive dependencies
   - Non-key attributes depend only on the primary key

### Denormalization Decisions

Minimal denormalization for performance:

1. **Rota.StartTime and EndTime**: Copied from RoleShiftTimings to allow shift-specific adjustments
2. **LeaveRequests.TotalDays**: Calculated field stored for quick reporting
3. **Timestamps**: CreatedAt and UpdatedAt on all tables for audit trail

## Scalability Considerations

### Horizontal Partitioning Opportunities

For large-scale deployments, consider partitioning:

1. **Rota Table**: Partition by ShiftDate (yearly or quarterly partitions)
2. **LeaveRequests Table**: Partition by RequestedAt or StartDate

### Indexing Strategy

Indexes are optimized for common query patterns:
- Date range queries (schedule views)
- Staff member lookups (individual schedules)
- Unit-based queries (department schedules)
- Status filtering (pending approvals)

### Archive Strategy

Consider archiving historical data:
- Rota records older than 2 years
- Completed/rejected leave requests older than 1 year
- Terminated users after retention period

---

## Related Documentation

- 📚 **[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete guide to all project documentation
- 📝 **[DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)** - Detailed schema specifications
- 🚀 **[QUICK_START.md](QUICK_START.md)** - Practical SQL examples and operations
- 💻 **[schema.sql](schema.sql)** - SQL DDL implementation script
- 📖 **[README.md](README.md)** - Project overview

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Related Documents:** DATABASE_SCHEMA.md
