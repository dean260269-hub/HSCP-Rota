# Development Container Configuration

> 📚 **See also:** [DOCUMENTATION_INDEX.md](../DOCUMENTATION_INDEX.md) - Complete guide to all project documentation

This directory contains the configuration for GitHub Codespaces and VS Code Dev Containers.

## What's Included

- **Base Image**: Universal Development Container (includes common development tools)
- **MySQL/MariaDB**: Pre-configured database server for working with the HSCP-Rota schema
- **VS Code Extensions**:
  - SQLTools: Database management and query execution
  - SQLTools MySQL Driver: MySQL/MariaDB connectivity
  - GitHub Copilot: AI-powered code assistance

## Using GitHub Codespaces

1. Click the **Code** button on the GitHub repository
2. Select the **Codespaces** tab
3. Click **Create codespace on main** (or your branch)
4. Wait for the environment to build (first time may take 2-3 minutes)
5. Once ready, you can work with the database schema immediately

## Setting Up the Database

After the Codespace launches, run the following commands in the terminal:

```bash
# Start MySQL service (if not already running)
mysql.server start

# Create the database
mysql -u root -e "CREATE DATABASE hscp_rota CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Load the schema
mysql -u root hscp_rota < schema.sql

# Verify installation
mysql -u root hscp_rota -e "SHOW TABLES;"
```

## Working with the Database

### Using the Terminal

```bash
# Connect to the database
mysql -u root hscp_rota

# Run queries
mysql -u root hscp_rota -e "SELECT * FROM Roles;"
```

### Using SQLTools Extension

1. Open the SQLTools extension (database icon in the sidebar)
2. Click **Add New Connection**
3. Select **MySQL**
4. Configure:
   - Connection name: `HSCP-Rota Local`
   - Server: `localhost`
   - Port: `3306`
   - Database: `hscp_rota`
   - Username: `root`
   - Password: (leave empty)
5. Click **Test Connection** then **Save Connection**
6. Now you can browse tables and run queries with IntelliSense

## Customizing the Environment

You can modify `devcontainer.json` to:
- Add more VS Code extensions
- Install additional tools
- Change the base image
- Add more database services (PostgreSQL, etc.)

See the [Dev Containers documentation](https://containers.dev) for more options.

## Troubleshooting

### MySQL Won't Start
```bash
mysql.server start
# or
brew services start mysql
```

### Port Already in Use
Check if MySQL is already running:
```bash
ps aux | grep mysql
```

### Permission Issues
The default configuration uses `root` with no password, which is fine for development environments. For production, always use strong passwords and proper user accounts.

## Related Documentation

For more information about the HSCP-Rota project:
- 📚 **[DOCUMENTATION_INDEX.md](../DOCUMENTATION_INDEX.md)** - Complete documentation guide
- 🔧 **[CODESPACES_FIX.md](../CODESPACES_FIX.md)** - Troubleshooting Codespaces issues
- 🚀 **[QUICK_START.md](../QUICK_START.md)** - Database setup and operations
- 📖 **[README.md](../README.md)** - Project overview
