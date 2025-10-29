#!/bin/bash
# Helper script to start MySQL server on Mac with Homebrew
# This script tries multiple methods to ensure MySQL starts successfully

set -e

echo "🚀 Starting MySQL Server..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Function to check if MySQL is running
check_mysql_running() {
    if pgrep -x "mysqld" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Function to test MySQL connection
test_mysql_connection() {
    if mysql -u root -e "SELECT 1;" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Check if MySQL is already running
if check_mysql_running; then
    echo "✅ MySQL is already running!"
    
    if test_mysql_connection; then
        echo "✅ MySQL connection test successful!"
        echo ""
        echo "📊 Database Status:"
        mysql -u root -e "SHOW DATABASES;" | grep -E "Database|hscp_rota" || echo "  hscp_rota database not found (run setup script)"
    else
        echo "⚠️  MySQL is running but connection failed. You may need to restart it."
        echo ""
        echo "Try running:"
        echo "  mysql.server restart"
    fi
else
    echo "MySQL is not running. Attempting to start..."
    echo ""
    
    # Method 1: Try mysql.server start
    echo "📌 Method 1: Using mysql.server start..."
    if mysql.server start 2>&1 | tee /tmp/mysql-start.log; then
        echo "✅ MySQL started successfully with mysql.server!"
    else
        echo "⚠️  mysql.server failed. Trying alternative method..."
        echo ""
        
        # Method 2: Try brew services start
        echo "📌 Method 2: Using brew services start mysql..."
        if brew services start mysql 2>&1 | tee -a /tmp/mysql-start.log; then
            echo "⏳ Waiting for MySQL to initialize..."
            sleep 3
            
            if check_mysql_running; then
                echo "✅ MySQL started successfully with brew services!"
            else
                echo "⚠️  brew services started but MySQL process not detected"
            fi
        else
            echo "❌ Both methods failed. Showing diagnostic information..."
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🔍 Diagnostics:"
            echo ""
            
            # Check Homebrew installation
            if command -v brew &> /dev/null; then
                echo "✅ Homebrew is installed"
                echo "   Location: $(which brew)"
            else
                echo "❌ Homebrew not found in PATH"
            fi
            
            # Check MySQL installation
            if brew list mysql &> /dev/null 2>&1; then
                echo "✅ MySQL is installed via Homebrew"
                echo "   Version: $(mysql --version 2>/dev/null || echo 'Unable to determine')"
            else
                echo "❌ MySQL not found in Homebrew packages"
                echo "   Install with: brew install mysql"
            fi
            
            # Check for MySQL processes
            echo ""
            echo "MySQL processes:"
            ps aux | grep mysql | grep -v grep || echo "  No MySQL processes found"
            
            # Check port 3306
            echo ""
            echo "Port 3306 status:"
            lsof -i :3306 2>/dev/null || echo "  Port 3306 is not in use"
            
            # Show recent error logs
            echo ""
            echo "Recent MySQL error logs:"
            if [ -d "$(brew --prefix)/var/mysql" ]; then
                ERROR_LOG=$(find "$(brew --prefix)/var/mysql" -name "*.err" -type f 2>/dev/null | head -1)
                if [ -n "$ERROR_LOG" ]; then
                    echo "  Log file: $ERROR_LOG"
                    echo ""
                    tail -n 20 "$ERROR_LOG" | sed 's/^/  /' || echo "  Unable to read error log"
                else
                    echo "  No error log found"
                fi
            else
                echo "  MySQL data directory not found at $(brew --prefix)/var/mysql"
            fi
            
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "💡 Suggestions:"
            echo "  1. Check the error log above for specific issues"
            echo "  2. Try: brew services restart mysql"
            echo "  3. Check disk space: df -h"
            echo "  4. Fix permissions: sudo chown -R \$(whoami) \$(brew --prefix)/var/mysql"
            echo "  5. Reinitialize MySQL: brew reinstall mysql"
            echo ""
            exit 1
        fi
    fi
    
    # Final connection test
    echo ""
    echo "🔌 Testing MySQL connection..."
    sleep 2
    
    if test_mysql_connection; then
        echo "✅ MySQL connection test successful!"
    else
        echo "⚠️  MySQL is running but connection test failed"
        echo "   Wait a few seconds and try: mysql -u root"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Next Steps:"
echo ""
echo "To set up the HSCP-Rota database, run:"
echo "  mysql -u root -e \"CREATE DATABASE hscp_rota CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;\""
echo "  mysql -u root hscp_rota < schema.sql"
echo "  mysql -u root hscp_rota -e \"SHOW TABLES;\""
echo ""
echo "Or use the setup script:"
echo "  ./setup-database.sh"
echo ""
