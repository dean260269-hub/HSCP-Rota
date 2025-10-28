-- ============================================================================
-- HSCP-Rota Database Schema (PostgreSQL Version)
-- ============================================================================
-- Version: 1.0
-- Description: Complete database schema for staff scheduling system including
--              users, roles, units, shifts, rotas, and leave management
-- ============================================================================

-- ============================================================================
-- Table: Roles
-- Description: Defines user roles and their permissions in the system
-- ============================================================================
CREATE TABLE Roles (
    RoleID SERIAL PRIMARY KEY,
    RoleName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    CanViewSchedule BOOLEAN NOT NULL DEFAULT TRUE,
    CanEditSchedule BOOLEAN NOT NULL DEFAULT FALSE,
    CanApproveLeave BOOLEAN NOT NULL DEFAULT FALSE,
    CanManageUsers BOOLEAN NOT NULL DEFAULT FALSE,
    CanManageUnits BOOLEAN NOT NULL DEFAULT FALSE,
    IsStaffRole BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- Table: Users
-- Description: Stores user/staff member information with SAP as primary key
-- ============================================================================
CREATE TABLE Users (
    SAP VARCHAR(20) PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    RoleID INT NOT NULL,
    UnitID INT,
    EmploymentStatus VARCHAR(20) NOT NULL DEFAULT 'Active',
    HireDate DATE NOT NULL,
    TerminationDate DATE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_employment_status CHECK (EmploymentStatus IN ('Active', 'Inactive', 'OnLeave', 'Terminated'))
);

-- ============================================================================
-- Table: Units
-- Description: Defines organizational units/departments with locations and staffing requirements
-- ============================================================================
CREATE TABLE Units (
    UnitID SERIAL PRIMARY KEY,
    UnitName VARCHAR(100) NOT NULL UNIQUE,
    UnitCode VARCHAR(20) NOT NULL UNIQUE,
    Description TEXT,
    Location VARCHAR(255),
    Building VARCHAR(100),
    Floor VARCHAR(20),
    IsActive BOOLEAN NOT NULL DEFAULT TRUE,
    MinStaffRequired INT NOT NULL DEFAULT 1,
    MaxStaffCapacity INT,
    ManagerSAP VARCHAR(20),
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_staff_capacity CHECK (MaxStaffCapacity IS NULL OR MaxStaffCapacity >= MinStaffRequired)
);

-- ============================================================================
-- Table: ShiftTemplates
-- Description: Defines shift concepts and patterns (e.g., "Day Shift", "Night Shift")
-- ============================================================================
CREATE TABLE ShiftTemplates (
    ShiftTemplateID SERIAL PRIMARY KEY,
    ShiftName VARCHAR(100) NOT NULL,
    ShiftCode VARCHAR(20) NOT NULL,
    Description TEXT,
    IsActive BOOLEAN NOT NULL DEFAULT TRUE,
    Color VARCHAR(7), -- For UI display (hex color code)
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (ShiftName, ShiftCode)
);

-- ============================================================================
-- Table: RoleShiftTimings
-- Description: Defines precise start and end times for each role on each shift template
-- ============================================================================
CREATE TABLE RoleShiftTimings (
    RoleShiftTimingID SERIAL PRIMARY KEY,
    RoleID INT NOT NULL,
    ShiftTemplateID INT NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    BreakDurationMinutes INT NOT NULL DEFAULT 0,
    IsOvernight BOOLEAN NOT NULL DEFAULT FALSE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (RoleID, ShiftTemplateID),
    CONSTRAINT chk_break_duration CHECK (BreakDurationMinutes >= 0)
);

-- ============================================================================
-- Table: Rota
-- Description: Main schedule/roster table storing actual shift assignments
-- ============================================================================
CREATE TABLE Rota (
    RotaID SERIAL PRIMARY KEY,
    SAP VARCHAR(20) NOT NULL,
    UnitID INT NOT NULL,
    ShiftTemplateID INT NOT NULL,
    ShiftDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    Notes TEXT,
    CreatedBy VARCHAR(20) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_rota_status CHECK (Status IN ('Scheduled', 'Confirmed', 'InProgress', 'Completed', 'Cancelled', 'NoShow'))
);

-- ============================================================================
-- Table: LeaveRequests
-- Description: Complete leave management system for tracking all leave requests
-- ============================================================================
CREATE TABLE LeaveRequests (
    LeaveRequestID SERIAL PRIMARY KEY,
    SAP VARCHAR(20) NOT NULL,
    LeaveType VARCHAR(50) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    TotalDays DECIMAL(5,2) NOT NULL,
    Reason TEXT,
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    RequestedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ReviewedBy VARCHAR(20),
    ReviewedAt TIMESTAMP,
    ReviewComments TEXT,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_leave_type CHECK (LeaveType IN ('Annual', 'Sick', 'Maternity', 'Paternity', 'Compassionate', 'Study', 'Unpaid', 'Other')),
    CONSTRAINT chk_leave_status CHECK (Status IN ('Pending', 'Approved', 'Rejected', 'Cancelled', 'Withdrawn')),
    CONSTRAINT chk_date_range CHECK (EndDate >= StartDate),
    CONSTRAINT chk_total_days CHECK (TotalDays > 0)
);

-- ============================================================================
-- Foreign Key Constraints
-- ============================================================================

-- Users table foreign keys
ALTER TABLE Users
    ADD CONSTRAINT fk_users_role FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    ADD CONSTRAINT fk_users_unit FOREIGN KEY (UnitID) REFERENCES Units(UnitID);

-- Units table foreign keys
ALTER TABLE Units
    ADD CONSTRAINT fk_units_manager FOREIGN KEY (ManagerSAP) REFERENCES Users(SAP);

-- RoleShiftTimings table foreign keys
ALTER TABLE RoleShiftTimings
    ADD CONSTRAINT fk_roleshifttimings_role FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    ADD CONSTRAINT fk_roleshifttimings_shift FOREIGN KEY (ShiftTemplateID) REFERENCES ShiftTemplates(ShiftTemplateID);

-- Rota table foreign keys
ALTER TABLE Rota
    ADD CONSTRAINT fk_rota_user FOREIGN KEY (SAP) REFERENCES Users(SAP),
    ADD CONSTRAINT fk_rota_unit FOREIGN KEY (UnitID) REFERENCES Units(UnitID),
    ADD CONSTRAINT fk_rota_shift FOREIGN KEY (ShiftTemplateID) REFERENCES ShiftTemplates(ShiftTemplateID),
    ADD CONSTRAINT fk_rota_creator FOREIGN KEY (CreatedBy) REFERENCES Users(SAP);

-- LeaveRequests table foreign keys
ALTER TABLE LeaveRequests
    ADD CONSTRAINT fk_leaverequests_user FOREIGN KEY (SAP) REFERENCES Users(SAP),
    ADD CONSTRAINT fk_leaverequests_reviewer FOREIGN KEY (ReviewedBy) REFERENCES Users(SAP);

-- ============================================================================
-- Indexes for Performance Optimization
-- ============================================================================

-- Users table indexes
CREATE INDEX idx_users_role ON Users(RoleID);
CREATE INDEX idx_users_unit ON Users(UnitID);
CREATE INDEX idx_users_email ON Users(Email);
CREATE INDEX idx_users_employment_status ON Users(EmploymentStatus);

-- Rota table indexes
CREATE INDEX idx_rota_sap ON Rota(SAP);
CREATE INDEX idx_rota_unit ON Rota(UnitID);
CREATE INDEX idx_rota_shift ON Rota(ShiftTemplateID);
CREATE INDEX idx_rota_date ON Rota(ShiftDate);
CREATE INDEX idx_rota_status ON Rota(Status);
CREATE INDEX idx_rota_sap_date ON Rota(SAP, ShiftDate);
CREATE INDEX idx_rota_unit_date ON Rota(UnitID, ShiftDate);

-- LeaveRequests table indexes
CREATE INDEX idx_leaverequests_sap ON LeaveRequests(SAP);
CREATE INDEX idx_leaverequests_status ON LeaveRequests(Status);
CREATE INDEX idx_leaverequests_dates ON LeaveRequests(StartDate, EndDate);
CREATE INDEX idx_leaverequests_type ON LeaveRequests(LeaveType);
CREATE INDEX idx_leaverequests_reviewer ON LeaveRequests(ReviewedBy);

-- RoleShiftTimings table indexes
CREATE INDEX idx_roleshifttimings_role ON RoleShiftTimings(RoleID);
CREATE INDEX idx_roleshifttimings_shift ON RoleShiftTimings(ShiftTemplateID);

-- Units table indexes
CREATE INDEX idx_units_manager ON Units(ManagerSAP);
CREATE INDEX idx_units_active ON Units(IsActive);

-- ============================================================================
-- Initial Data / Seed Data (Optional - for reference)
-- ============================================================================

-- Sample Roles
INSERT INTO Roles (RoleName, Description, CanViewSchedule, CanEditSchedule, CanApproveLeave, CanManageUsers, CanManageUnits, IsStaffRole) VALUES
('Nurse', 'Registered Nurse providing patient care', TRUE, FALSE, FALSE, FALSE, FALSE, TRUE),
('Senior Nurse', 'Senior nursing staff with scheduling responsibilities', TRUE, TRUE, FALSE, FALSE, FALSE, TRUE),
('Ward Manager', 'Ward management with full scheduling and leave approval', TRUE, TRUE, TRUE, TRUE, FALSE, TRUE),
('Administrator', 'System administrator with full access', TRUE, TRUE, TRUE, TRUE, TRUE, FALSE),
('Healthcare Assistant', 'Healthcare support worker', TRUE, FALSE, FALSE, FALSE, FALSE, TRUE);

-- Sample Shift Templates
INSERT INTO ShiftTemplates (ShiftName, ShiftCode, Description, IsActive, Color) VALUES
('Day Shift', 'DAY', 'Standard daytime shift', TRUE, '#FFD700'),
('Night Shift', 'NIGHT', 'Overnight shift', TRUE, '#191970'),
('Evening Shift', 'EVE', 'Evening coverage shift', TRUE, '#FF8C00'),
('Long Day', 'LONG', 'Extended 12-hour day shift', TRUE, '#32CD32'),
('On Call', 'ONCALL', 'On-call availability', TRUE, '#DC143C');

-- ============================================================================
-- End of Schema Definition
-- ============================================================================
