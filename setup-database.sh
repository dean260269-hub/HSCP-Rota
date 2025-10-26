#!/bin/bash
# Complete database setup script for HSCP-Rota
# This script ensures MySQL is running and sets up the database

set -e

echo "🏥 HSCP-Rota Database Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if schema.sql exists
if [ ! -f "schema.sql" ]; then
    echo "❌ Error: schema.sql not found in current directory"
    echo "   Please run this script from the repository root"
    exit 1
fi

# Function to test MySQL connection
test_mysql() {
    mysql -u root -e "SELECT 1;" > /dev/null 2>&1
}

# Check if MySQL is accessible
echo "🔍 Checking MySQL connection..."
if ! test_mysql; then
    echo "⚠️  MySQL is not accessible. Attempting to start..."
    echo ""
    
    # Try to start MySQL
    if [ -f "./start-mysql.sh" ]; then
        bash ./start-mysql.sh
    else
        echo "Starting MySQL with mysql.server..."
        mysql.server start || brew services start mysql
        sleep 3
    fi
    
    # Test again
    if ! test_mysql; then
        echo "❌ Unable to connect to MySQL after starting"
        echo "   Please start MySQL manually and try again"
        exit 1
    fi
fi

echo "✅ MySQL connection successful!"
echo ""

# Check if database already exists
echo "🔍 Checking if hscp_rota database exists..."
if mysql -u root -e "USE hscp_rota;" 2>/dev/null; then
    echo "⚠️  Database 'hscp_rota' already exists!"
    echo ""
    read -p "Do you want to DROP and recreate it? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Dropping existing database..."
        mysql -u root -e "DROP DATABASE hscp_rota;"
        echo "✅ Existing database dropped"
    else
        echo "ℹ️  Keeping existing database. Setup cancelled."
        exit 0
    fi
fi

# Create database
echo ""
echo "📦 Creating database..."
mysql -u root -e "CREATE DATABASE hscp_rota CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
echo "✅ Database 'hscp_rota' created"

# Load schema
echo ""
echo "📋 Loading schema from schema.sql..."
if mysql -u root hscp_rota < schema.sql; then
    echo "✅ Schema loaded successfully"
else
    echo "❌ Failed to load schema"
    exit 1
fi

# Verify installation
echo ""
echo "✅ Verifying installation..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Database Tables:"
mysql -u root hscp_rota -e "SHOW TABLES;" | sed 's/^/  /'

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📈 Sample Data Counts:"
echo ""

# Check for sample data
echo "Roles:"
mysql -u root hscp_rota -e "SELECT RoleID, RoleName FROM Roles;" | sed 's/^/  /'

echo ""
echo "Shift Templates:"
mysql -u root hscp_rota -e "SELECT ShiftTemplateID, ShiftName FROM ShiftTemplates;" | sed 's/^/  /'

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Setup Complete!"
echo ""
echo "Your database is ready to use. You can now:"
echo "  • Connect with: mysql -u root hscp_rota"
echo "  • View tables: SHOW TABLES;"
echo "  • Read the quick start guide: cat QUICK_START.md"
echo ""
echo "Database: hscp_rota"
echo "Host: localhost"
echo "Port: 3306"
echo "User: root"
echo "Password: (none)"
echo ""
