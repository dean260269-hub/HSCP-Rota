# HSCP-Rota Documentation Index

Welcome to the HSCP-Rota (Healthcare Scheduling and Care Planning Rotation) documentation. This index provides quick access to all project documentation files.

## 📚 Complete Documentation Guide

### 🚀 Getting Started

1. **[README.md](README.md)** - Main project overview and introduction
   - Project features and capabilities
   - Technology compatibility
   - Quick start guide
   - Project status

2. **[QUICK_START.md](QUICK_START.md)** - Hands-on quick start guide
   - Installation instructions
   - Common operations and SQL examples
   - User management, scheduling, and leave management
   - Reporting queries
   - Maintenance operations
   - Best practices and troubleshooting

### 📊 Database Documentation

3. **[DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)** - Comprehensive database schema documentation
   - Complete table specifications
   - Data integrity and constraints
   - Indexes for performance
   - Usage examples
   - Implementation notes
   - Security considerations

4. **[ERD.md](ERD.md)** - Entity Relationship Diagrams
   - Visual database structure
   - Detailed relationship descriptions
   - Key design patterns
   - Cardinality and referential integrity
   - Data flow examples
   - Scalability considerations

5. **[schema.sql](schema.sql)** - SQL DDL script
   - Actual database creation script
   - Table definitions with constraints
   - Foreign key relationships
   - Indexes
   - Sample seed data

### 🔧 Development Environment

6. **[docker-compose.yml](docker-compose.yml)** - Docker Compose configuration
   - PostgreSQL database setup
   - Container configuration
   - Port mappings

7. **[.devcontainer/devcontainer.json](.devcontainer/devcontainer.json)** - GitHub Codespaces configuration
   - Development container setup
   - MySQL/MariaDB integration
   - VS Code extensions
   - Port forwarding

8. **[.devcontainer/README.md](.devcontainer/README.md)** - Dev Container documentation
   - Using GitHub Codespaces
   - Database setup in Codespaces
   - SQLTools extension guide
   - Troubleshooting

### 🐛 Troubleshooting

9. **[CODESPACES_FIX.md](CODESPACES_FIX.md)** - GitHub Codespaces billing notification fix
   - Common Codespaces issues
   - Resolution steps
   - Billing information
   - Environment setup help

## 📖 Documentation Overview by Purpose

### For New Users
Start with these files in order:
1. [README.md](README.md) - Understand what the project is
2. [QUICK_START.md](QUICK_START.md) - Get up and running quickly
3. [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) - Learn the database structure

### For Developers
Essential reading for development:
1. [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) - Understand the data model
2. [ERD.md](ERD.md) - Visual database relationships
3. [schema.sql](schema.sql) - Actual implementation
4. [.devcontainer/README.md](.devcontainer/README.md) - Set up your development environment

### For Database Administrators
Key resources for DBAs:
1. [schema.sql](schema.sql) - Database creation script
2. [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) - Complete schema documentation
3. [QUICK_START.md](QUICK_START.md) - Maintenance and operations

### For Troubleshooting
When you encounter issues:
1. [CODESPACES_FIX.md](CODESPACES_FIX.md) - Codespaces-specific issues
2. [.devcontainer/README.md](.devcontainer/README.md) - Dev container problems
3. [QUICK_START.md](QUICK_START.md) - See "Troubleshooting" section

## 🗺️ Quick Reference Map

```
HSCP-Rota/
│
├── README.md                    # Start here - Project overview
├── DOCUMENTATION_INDEX.md       # This file - Complete guide to all docs
│
├── Getting Started
│   ├── QUICK_START.md          # Practical guide with SQL examples
│   └── CODESPACES_FIX.md       # Environment setup troubleshooting
│
├── Database Documentation
│   ├── DATABASE_SCHEMA.md      # Detailed schema documentation
│   ├── ERD.md                  # Entity relationship diagrams
│   └── schema.sql              # SQL DDL script
│
└── Development Setup
    ├── docker-compose.yml      # Docker setup
    └── .devcontainer/
        ├── devcontainer.json   # Codespaces config
        └── README.md           # Dev container guide
```

## 🔍 Find Information Quickly

### Want to...

**Understand the project?**
→ Start with [README.md](README.md)

**Set up the database?**
→ See [QUICK_START.md](QUICK_START.md) → Installation section

**Learn about tables and relationships?**
→ Read [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) or [ERD.md](ERD.md)

**Use GitHub Codespaces?**
→ Check [.devcontainer/README.md](.devcontainer/README.md)

**Run SQL queries?**
→ See [QUICK_START.md](QUICK_START.md) → Common Operations

**Deploy with Docker?**
→ Use [docker-compose.yml](docker-compose.yml)

**Fix Codespaces errors?**
→ Read [CODESPACES_FIX.md](CODESPACES_FIX.md)

**Understand permissions and roles?**
→ See [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) → Roles Table

**Manage shifts and schedules?**
→ See [QUICK_START.md](QUICK_START.md) → Schedule Management

**Handle leave requests?**
→ See [QUICK_START.md](QUICK_START.md) → Leave Management

## 📋 Document Summaries

### README.md
The main entry point for the project. Provides an overview of HSCP-Rota, its features, key concepts, architecture highlights, and links to other documentation. Best for understanding what the project does and why.

### QUICK_START.md  
Practical, hands-on guide with real SQL examples. Covers installation, common operations (users, scheduling, leave management), reporting queries, maintenance, and best practices. Best for actually using the database.

### DATABASE_SCHEMA.md
Comprehensive technical documentation of all 7 database tables, including column specifications, constraints, relationships, indexes, and implementation notes. Best for understanding the complete data model.

### ERD.md
Visual representation of the database with Entity Relationship Diagrams, detailed relationship descriptions, design patterns, and data flow examples. Best for understanding how tables relate to each other.

### schema.sql
The actual SQL Data Definition Language (DDL) script to create the database. Includes all tables, constraints, foreign keys, indexes, and sample seed data. Best for implementation and deployment.

### docker-compose.yml
Docker Compose configuration file for setting up a PostgreSQL database in a container. Provides quick database environment setup with proper configuration.

### .devcontainer/devcontainer.json
Configuration for GitHub Codespaces and VS Code Dev Containers. Defines the development environment including MySQL/MariaDB, extensions, and settings.

### .devcontainer/README.md
Guide for using the dev container and GitHub Codespaces. Includes setup instructions, using SQLTools, customization options, and troubleshooting.

### CODESPACES_FIX.md
Explains and resolves a common GitHub Codespaces error message about billing that was actually caused by missing configuration files. Includes setup verification steps.

## 🏗️ Project Structure

The HSCP-Rota system consists of:

- **7 Core Database Tables**: Users, Roles, Units, ShiftTemplates, RoleShiftTimings, Rota, LeaveRequests
- **5 Functional Areas**: User Management, Organizational Structure, Shift Management, Scheduling, Leave Management
- **Multiple Deployment Options**: MySQL, MariaDB, PostgreSQL, SQL Server, Docker, Codespaces

## 🔗 External Resources

- **GitHub Repository**: [dean260269-hub/HSCP-Rota](https://github.com/dean260269-hub/HSCP-Rota)
- **Dev Containers**: [containers.dev](https://containers.dev)
- **GitHub Codespaces**: [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces)

## 📝 Contributing

When contributing to this project, please refer to:
1. The database schema documentation for understanding the data model
2. The ERD for understanding relationships
3. The existing code style in schema.sql

## ⚡ Quick Links Summary

| Purpose | Primary File | Supporting Files |
|---------|-------------|------------------|
| **Overview** | [README.md](README.md) | [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) |
| **Quick Start** | [QUICK_START.md](QUICK_START.md) | [schema.sql](schema.sql) |
| **Schema Details** | [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) | [ERD.md](ERD.md), [schema.sql](schema.sql) |
| **Relationships** | [ERD.md](ERD.md) | [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) |
| **Implementation** | [schema.sql](schema.sql) | [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) |
| **Docker Setup** | [docker-compose.yml](docker-compose.yml) | [README.md](README.md) |
| **Codespaces** | [.devcontainer/README.md](.devcontainer/README.md) | [CODESPACES_FIX.md](CODESPACES_FIX.md) |
| **Troubleshooting** | [CODESPACES_FIX.md](CODESPACES_FIX.md) | [QUICK_START.md](QUICK_START.md) |

---

**Last Updated**: October 2025  
**Version**: 1.0  
**Maintained by**: HSCP-Rota Development Team
