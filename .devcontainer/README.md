# Development Container Configuration

This directory contains the configuration for GitHub Codespaces and VS Code Dev Containers.

## What's Included

- **Base Image**: Lightweight Ubuntu-based development container
- **MySQL**: Official MySQL feature from devcontainers
- **VS Code Extensions**:
  - SQLTools: Database management and query execution
  - SQLTools MySQL Driver: MySQL/MariaDB connectivity
  - GitHub Copilot: AI-powered code assistance

This configuration is optimized to minimize resource usage and reduce the chance of hitting Codespaces quota limits.

## Using GitHub Codespaces

1. Click the **Code** button on the GitHub repository
2. Select the **Codespaces** tab
3. Click **Create codespace on main** (or your branch)
4. Wait for the environment to build (first time may take 2-3 minutes)
5. Once ready, you can work with the database schema immediately

## Setting Up the Database

After the Codespace launches, you have two options:

### Option A: Automated Setup (Recommended)

Use the provided setup script for automatic database initialization:

```bash
./setup-database.sh
```

This script will:
- Check if MySQL is running (and start it if needed)
- Create the hscp_rota database
- Load the schema from schema.sql
- Verify the installation
- Show you the available tables and sample data

### Option B: Manual Setup

Run the following commands in the terminal:

```bash
# Start MySQL service (if not already running)
./start-mysql.sh

# Or use the direct command:
# mysql.server start

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

### Getting "Billing Issue" Error?

**This is NOT a devcontainer problem!** The billing error is almost always caused by:
- Exceeding monthly quota (120-180 core-hours/month on free tier)
- Codespaces spending limit set to $0
- Old codespaces not deleted (counting toward storage quota)

**See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for complete solutions to billing errors.**

### MySQL Won't Start

If you encounter issues starting MySQL, try these solutions in order:

#### Solution 1: Standard Startup Command
```bash
mysql.server start
```

#### Solution 2: Use Homebrew Services
```bash
brew services start mysql
```

#### Solution 3: Check if MySQL is Already Running
```bash
# Check for MySQL processes
ps aux | grep mysql

# If running, connect directly without starting
mysql -u root
```

#### Solution 4: Check MySQL Status
```bash
# Check service status
brew services list | grep mysql

# View MySQL error logs
tail -n 50 $(brew --prefix)/var/mysql/*.err
```

#### Solution 5: Restart MySQL Service
```bash
# Stop any existing MySQL process
mysql.server stop
# or
brew services stop mysql

# Wait a moment, then start again
sleep 2
mysql.server start
```

#### Solution 6: Fix Permissions
```bash
# Fix ownership of MySQL data directory
sudo chown -R $(whoami) $(brew --prefix)/var/mysql

# Try starting again
mysql.server start
```

### Port Already in Use
If port 3306 is already in use by another service:

```bash
# Find what's using port 3306
lsof -i :3306

# Kill the process if needed (use the PID from above)
kill -9 <PID>

# Or change MySQL port in my.cnf
# echo "port = 3307" >> $(brew --prefix)/etc/my.cnf
```

### Connection Refused Errors
```bash
# Ensure MySQL socket file exists
ls -la /tmp/mysql.sock

# If missing, create symbolic link
ln -s $(brew --prefix)/var/mysql/mysql.sock /tmp/mysql.sock
```

### Command Not Found: mysql.server
```bash
# Add Homebrew MySQL to PATH
echo 'export PATH="$(brew --prefix)/opt/mysql/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Or use full path
$(brew --prefix)/opt/mysql/bin/mysql.server start
```

### Database Initialization Failed
```bash
# Reinitialize MySQL data directory
rm -rf $(brew --prefix)/var/mysql
mysqld --initialize-insecure --user=$(whoami) --basedir=$(brew --prefix)/opt/mysql --datadir=$(brew --prefix)/var/mysql

# Start MySQL
mysql.server start
```

### Permission Issues
The default configuration uses `root` with no password, which is fine for development environments. For production, always use strong passwords and proper user accounts.

### Getting Help
If none of these solutions work:
1. Check the MySQL error log: `tail -f $(brew --prefix)/var/mysql/*.err`
2. Verify Homebrew installation: `brew doctor`
3. Reinstall MySQL: `brew reinstall mysql`
4. Check system resources: Ensure you have enough disk space and memory

### Quick Troubleshooting with Helper Scripts

The repository includes helper scripts that automate troubleshooting:

```bash
# Automatically diagnose and start MySQL
./start-mysql.sh

# Complete database setup with error checking
./setup-database.sh
```

These scripts provide detailed diagnostics and attempt multiple methods to resolve common issues.
