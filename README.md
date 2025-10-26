# HSCP-Rota
Healthcare Scheduling and Care Planning Rotation System

## Overview

HSCP-Rota is a comprehensive staff scheduling system designed for healthcare facilities. It manages staff rotas, shift assignments, leave requests, and provides robust organizational structure support.

## Features

- **User Management**: Complete user management with role-based access control (RBAC)
- **Organizational Structure**: Support for multiple units, departments, and locations
- **Flexible Shift Management**: Template-based shift system with role-specific timings
- **Schedule/Roster Management**: Full scheduling capabilities with status tracking
- **Leave Management**: Complete leave request and approval workflow
- **Audit Trail**: Comprehensive tracking of changes and actions

## Database Schema

The system uses a relational database with 7 core tables:

1. **Users** - Staff member information with SAP as primary key
2. **Roles** - Role definitions with granular permissions
3. **Units** - Organizational units with locations and staffing requirements
4. **ShiftTemplates** - Reusable shift concepts (Day Shift, Night Shift, etc.)
5. **RoleShiftTimings** - Precise timing definitions for each role on each shift
6. **Rota** - Main schedule/roster table for shift assignments
7. **LeaveRequests** - Complete leave management system

### Documentation

- **[DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)** - Comprehensive database schema documentation
- **[ERD.md](ERD.md)** - Entity Relationship Diagram and relationship descriptions
- **[schema.sql](schema.sql)** - SQL DDL file to create the database

## Getting Started

### Quick Start with GitHub Codespaces

The fastest way to get started is using GitHub Codespaces:

1. Click the **Code** button above
2. Select **Codespaces** tab
3. Click **Create codespace on main**
4. Wait for the environment to build
5. Run the setup commands in the integrated terminal:

```bash
sudo service mysql start
mysql -u root -e "CREATE DATABASE hscp_rota CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root hscp_rota < schema.sql
```

**Seeing a billing error?** This is usually a quota or spending limit issue, not a configuration problem. See [.devcontainer/TROUBLESHOOTING.md](.devcontainer/TROUBLESHOOTING.md) for solutions.

See [.devcontainer/README.md](.devcontainer/README.md) for more details on using Codespaces.

### Local Database Setup

1. Choose your database platform (MySQL, MariaDB, PostgreSQL, or SQL Server)
2. Create a new database for the application
3. Run the SQL script to create the schema:

```bash
# For MySQL/MariaDB
mysql -u username -p database_name < schema.sql

# For PostgreSQL (with minor adjustments)
psql -U username -d database_name -f schema.sql
```

### Key Concepts

#### SAP Identifier
The system uses SAP (Systems, Applications, and Products) identifiers as the primary key for users. This ensures integration with existing HR systems.

#### Role-Based Access Control
Users are assigned roles that determine their permissions:
- View schedules
- Edit schedules
- Approve leave requests
- Manage users and units

#### Shift Templates
Shifts are defined as reusable templates that can be customized per role:
- A "Day Shift" template might run 7:00-15:00
- Nurses work the full shift
- Healthcare Assistants might work 8:00-16:00 on the same day

#### Leave Workflow
Leave requests follow a complete workflow:
1. Staff member submits request (Pending)
2. Manager reviews and approves/rejects
3. System tracks reviewer, timestamp, and comments
4. Status updates reflect approval state

## Architecture Highlights

### Data Integrity
- Foreign key constraints ensure referential integrity
- Check constraints validate data values
- Unique constraints prevent duplicates
- Indexes optimize query performance

### Audit Trail
- All tables include CreatedAt and UpdatedAt timestamps
- Rota table tracks who created each schedule entry
- Leave requests track reviewer and review timestamp

### Scalability
- Indexes optimized for common query patterns
- Partitioning strategy available for large datasets
- Archive strategy for historical data

## Project Status

✅ **Task 1.3: Database Schema Design - Complete**

The database schema is fully designed and documented, including:
- Complete SQL DDL script
- Comprehensive documentation
- Entity Relationship Diagram
- Example queries and use cases
- Security and scalability considerations

## Next Steps

- Implement application layer (API/backend)
- Create user interface for scheduling
- Add authentication and authorization
- Implement business logic and validation rules
- Add reporting and analytics features

## Technology Compatibility

The database schema is compatible with:
- MySQL 5.7+
- MariaDB 10.2+
- PostgreSQL 9.6+ (with minor syntax adjustments)
- Microsoft SQL Server 2016+ (with minor syntax adjustments)

## Contributing

Please refer to the documentation files for detailed information about the database structure before making contributions.

## License

[To be determined]
