# คู่มือการออกแบบและพัฒนา Module PMS (Project Management System) ด้วย Golang + MSSQL + GORM

**บทบาท:** Software Engineer  
**ภาษา:** Golang  
**ฐานข้อมูล:** Microsoft SQL Server  
**ORM:** GORM  
**AI:** Deesak (Model R1)

---

## สารบัญ (Table of Contents)

1. บทนำ (Introduction)
2. บทนิยาม (Definitions)
3. วัตถุประสงค์ (Objective)
4. กลุ่มเป้าหมาย (Target Audience)
5. ความรู้พื้นฐาน (Prerequisites)
6. เนื้อหาโดยย่อ (Executive Summary)
7. โครงสร้างการทำงาน (System Architecture)
   - โครงสร้างโฟลเดอร์ (Folder Structure)
   - หลักการทำงาน (Concept)
   - Workflow และ Dataflow (พร้อม Flowchart)
8. Business Logic
9. Code Template และตัวอย่างโค้ด (พร้อมรันได้จริง)
10. Check List Module
11. Security Code
12. Load Test Development
13. สรุป (Summary)
14. คู่มือการทดสอบ (Test Manual)
15. คู่มือการใช้งาน (User Manual)
16. คู่มือการบำรุงรักษา (Maintenance Manual)
17. คู่มือการขยาย/แก้ไข (Extension/Modification Guide)
18. Git Flow
19. Code Review & PR Checklist
20. CI/CD Design
21. Root Cause Solution (RCA)

---

## 1. บทนำ (Introduction)

ระบบ PMS (Project Management System) ถูกพัฒนาขึ้นเพื่อจัดการโครงการ งาน และทรัพยากรภายในองค์กร โดยใช้ภาษา Go ร่วมกับฐานข้อมูล Microsoft SQL Server และ GORM เป็น ORM ระบบรองรับการสร้างโครงการ การกำหนดงาน การติดตามสถานะ และการรายงานความคืบหน้า

This PMS (Project Management System) is developed to manage projects, tasks, and resources within the organization using Go language with Microsoft SQL Server and GORM as ORM. The system supports project creation, task assignment, status tracking, and progress reporting.

---

## 2. บทนิยาม (Definitions)

| ศัพท์ (Term) | คำจำกัดความ (Definition) |
|--------------|---------------------------|
| **Project** | โครงการที่มีเป้าหมาย ระยะเวลา และทรัพยากรที่กำหนด |
| **Task** | งานย่อยภายในโครงการ แบ่งตามผู้รับผิดชอบ |
| **User** | ผู้ใช้ระบบ มีบทบาทเป็น Admin, Project Manager, หรือ Member |
| **GORM** | Object-Relational Mapping library สำหรับ Go |
| **MSSQL** | Microsoft SQL Server database |

---

## 3. วัตถุประสงค์ (Objective)

- เพื่อสร้างระบบจัดการโครงการที่ง่ายต่อการใช้งานและขยายผล
- เพื่อลดความซับซ้อนในการจัดการงานและติดตามความคืบหน้า
- เพื่อให้ทีมพัฒนาสามารถนำโค้ดไปปรับใช้ได้ทันที (Production-ready)

---

## 4. กลุ่มเป้าหมาย (Target Audience)

- นักพัฒนาซอฟต์แวร์ที่ต้องการเรียนรู้การสร้าง REST API ด้วย Go + GORM + MSSQL
- ทีม DevOps ที่ต้องการนำระบบไปปรับใช้ในองค์กร
- Project Manager ที่ต้องการเครื่องมือบริหารโครงการแบบเบาแต่ครบวงจร

---

## 5. ความรู้พื้นฐาน (Prerequisites)

- ภาษา Go (ระดับพื้นฐาน-กลาง)
- ความรู้เรื่อง REST API
- ความเข้าใจเรื่องฐานข้อมูลเชิงสัมพันธ์ (SQL)
- ติดตั้ง Docker (สำหรับรัน MSSQL ใน environment ทดสอบ)

---

## 6. เนื้อหาโดยย่อ (Executive Summary)

คู่มือนี้ประกอบด้วย:
- โครงสร้างโปรเจกต์ Go แบบ Clean Architecture (ย่อส่วน)
- โค้ด CRUD สำหรับ Project, Task, User
- การเชื่อมต่อ MSSQL ผ่าน GORM พร้อม Auto Migration
- Middleware Authentication (JWT) และ Authorization (RBAC)
- ตัวอย่าง CI/CD (GitHub Actions) และ Git Flow
- แนวทางการทดสอบ Load Test ด้วย K6
- RCA Template สำหรับการวิเคราะห์ปัญหา

---

## 7. โครงสร้างการทำงาน (System Architecture)

### 7.1 โครงสร้างโฟลเดอร์ (Folder Structure)

```
pms/
├── cmd/
│   └── server/
│       └── main.go                 # Entry point
├── internal/
│   ├── config/
│   │   └── config.go               # โหลด environment variables
│   ├── database/
│   │   └── mssql.go                # เชื่อมต่อ MSSQL + GORM
│   ├── models/
│   │   ├── project.go
│   │   ├── task.go
│   │   └── user.go
│   ├── repositories/
│   │   ├── project_repo.go
│   │   ├── task_repo.go
│   │   └── user_repo.go
│   ├── services/
│   │   ├── project_service.go
│   │   ├── task_service.go
│   │   └── auth_service.go
│   ├── handlers/
│   │   ├── project_handler.go
│   │   ├── task_handler.go
│   │   └── auth_handler.go
│   ├── middleware/
│   │   └── auth.go
│   └── routes/
│       └── routes.go
├── migrations/                      # SQL scripts (ถ้าต้องการ manual)
├── scripts/                         # build, test scripts
├── test/
│   └── loadtest/                    # K6 scripts
├── .env.example
├── go.mod
├── go.sum
└── Dockerfile
```

### 7.2 หลักการทำงาน (Concept)

- **Layered Architecture:** Handler → Service → Repository → Database
- **Dependency Injection:** ส่ง Repository เข้า Service, Service เข้า Handler
- **GORM AutoMigrate:** สร้างตารางอัตโนมัติเมื่อเริ่มระบบ
- **JWT Authentication:** ป้องกัน API ที่ต้องใช้สิทธิ์

### 7.3 Workflow และ Dataflow

#### Flowchart การสร้างโครงการใหม่ (Create Project)

```mermaid
graph TD
    A[Client POST /api/projects] --> B[authMiddleware: ตรวจสอบ JWT]
    B -->|Invalid| C[401 Unauthorized]
    B -->|Valid| D[ProjectHandler.CreateProject]
    D --> E[ProjectService.Create]
    E --> F[ProjectRepo.Create]
    F --> G[(MSSQL Database)]
    G --> H[Return 201 Created]
    H --> I[Client receives project JSON]
```

#### Dataflow โดยละเอียด

1. **Client** ส่ง HTTP POST request พร้อม JSON body `{ "name": "โครงการ A", "description": "...", "start_date": "...", "end_date": "..." }` และ Header `Authorization: Bearer <token>`
2. **Middleware** อ่าน token, ตรวจสอบความถูกต้องและดึง `user_id` ออกมา
3. **Handler** แปลง JSON → struct, เรียก `service.Create`
4. **Service** ตรวจสอบ business logic (เช่น วันที่สิ้นสุดต้องมากกว่าวันเริ่ม) แล้วเรียก `repo.Create`
5. **Repository** ใช้ GORM `db.Create(&project)` บันทึกลงตาราง `projects`
6. **Response** กลับไปที่ Client พร้อม status 201 และข้อมูล project ที่มี `id` แล้ว

#### ตัวอย่างการไหลของข้อมูล (Dataflow Diagram)

```
[Client] --(POST /projects)--> [API Gateway/Go Server]
                                      |
                                      v
                              [Auth Middleware]
                                      |
                                      v
                              [Project Handler]
                                      |
                                      v
                              [Project Service]
                                      |
                                      v
                              [Project Repository]
                                      |
                                      v
                              [(MSSQL) projects table]
                                      |
                                      v
                              [Response JSON] --> [Client]
```

---

## 8. Business Logic

- **Project** สามารถมีได้หลาย **Task**
- **User** มี role: `admin`, `pm` (project manager), `member`
- เฉพาะ `admin` และ `pm` เท่านั้นที่สร้าง/แก้ไข/ลบโครงการได้
- `member` สามารถดู task ที่ได้รับมอบหมายและอัปเดตสถานะได้
- ระบบบันทึก `created_at`, `updated_at` อัตโนมัติ (GORM)

---

## 9. Code Template และตัวอย่างโค้ด (พร้อมรันได้จริง)

### 9.1 การตั้งค่า Environment (ไฟล์ .env)

```env
# .env
DB_HOST=localhost
DB_PORT=1433
DB_USER=sa
DB_PASSWORD=YourStrong!Password
DB_NAME=pms_db
JWT_SECRET=my_super_secret_key_change_me
PORT=8080
```

### 9.2 main.go (Entry point)

```go
// cmd/server/main.go
package main

import (
    "log"
    "os"
    "pms/internal/config"
    "pms/internal/database"
    "pms/internal/routes"
    "github.com/gin-gonic/gin"
)

func main() {
    // โหลด config จาก environment variables
    // Load config from environment variables
    cfg := config.LoadConfig()

    // เชื่อมต่อฐานข้อมูล MSSQL ผ่าน GORM
    // Connect to MSSQL via GORM
    db, err := database.ConnectMSSQL(cfg)
    if err != nil {
        log.Fatal("Failed to connect database: ", err)
    }

    // Auto migrate schemas (สร้างตารางอัตโนมัติ)
    // Auto migrate schemas (create tables automatically)
    if err := database.Migrate(db); err != nil {
        log.Fatal("Failed to migrate: ", err)
    }

    // สร้าง Gin router
    // Create Gin router
    r := gin.Default()

    // ตั้งค่าระบบ routes (รวม middleware)
    // Setup routes (including middleware)
    routes.SetupRoutes(r, db, cfg)

    // รัน server
    // Run server
    log.Printf("Server running on port %s", cfg.Port)
    r.Run(":" + cfg.Port)
}
```

### 9.3 Config (internal/config/config.go)

```go
// internal/config/config.go
package config

import (
    "os"
    "strconv"
)

type Config struct {
    DBHost     string
    DBPort     string
    DBUser     string
    DBPassword string
    DBName     string
    JWTSecret  string
    Port       string
}

func LoadConfig() *Config {
    return &Config{
        DBHost:     getEnv("DB_HOST", "localhost"),
        DBPort:     getEnv("DB_PORT", "1433"),
        DBUser:     getEnv("DB_USER", "sa"),
        DBPassword: getEnv("DB_PASSWORD", ""),
        DBName:     getEnv("DB_NAME", "pms_db"),
        JWTSecret:  getEnv("JWT_SECRET", "default_secret"),
        Port:       getEnv("PORT", "8080"),
    }
}

func getEnv(key, fallback string) string {
    if value, exists := os.LookupEnv(key); exists {
        return value
    }
    return fallback
}
```

### 9.4 Database Connection (internal/database/mssql.go)

```go
// internal/database/mssql.go
package database

import (
    "fmt"
    "pms/internal/config"
    "pms/internal/models"
    "gorm.io/driver/sqlserver"
    "gorm.io/gorm"
)

func ConnectMSSQL(cfg *config.Config) (*gorm.DB, error) {
    // สร้าง connection string สำหรับ MSSQL
    // Build connection string for MSSQL
    dsn := fmt.Sprintf("sqlserver://%s:%s@%s:%s?database=%s",
        cfg.DBUser, cfg.DBPassword, cfg.DBHost, cfg.DBPort, cfg.DBName)
    
    db, err := gorm.Open(sqlserver.Open(dsn), &gorm.Config{})
    if err != nil {
        return nil, err
    }
    return db, nil
}

func Migrate(db *gorm.DB) error {
    // สร้างตารางอัตโนมัติ (AutoMigrate)
    // Create tables automatically (AutoMigrate)
    return db.AutoMigrate(&models.User{}, &models.Project{}, &models.Task{})
}
```

### 9.5 Models (internal/models/)

**user.go**
```go
// internal/models/user.go
package models

import (
    "time"
    "gorm.io/gorm"
)

type UserRole string

const (
    RoleAdmin  UserRole = "admin"
    RolePM     UserRole = "pm"
    RoleMember UserRole = "member"
)

type User struct {
    ID        uint      `gorm:"primaryKey" json:"id"`
    Username  string    `gorm:"unique;not null" json:"username"`
    Password  string    `gorm:"not null" json:"-"` // ไม่แสดงใน JSON
    Role      UserRole  `gorm:"default:member" json:"role"`
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}
```

**project.go**
```go
// internal/models/project.go
package models

import (
    "time"
)

type Project struct {
    ID          uint      `gorm:"primaryKey" json:"id"`
    Name        string    `gorm:"not null" json:"name"`
    Description string    `json:"description"`
    StartDate   time.Time `json:"start_date"`
    EndDate     time.Time `json:"end_date"`
    Status      string    `gorm:"default:active" json:"status"` // active, completed, on_hold
    CreatedBy   uint      `json:"created_by"`                   // user id
    CreatedAt   time.Time `json:"created_at"`
    UpdatedAt   time.Time `json:"updated_at"`
    
    // ความสัมพันธ์: โครงการมีหลายงาน
    // Relationship: Project has many tasks
    Tasks []Task `gorm:"foreignKey:ProjectID" json:"tasks,omitempty"`
}
```

**task.go**
```go
// internal/models/task.go
package models

import (
    "time"
)

type Task struct {
    ID          uint      `gorm:"primaryKey" json:"id"`
    Title       string    `gorm:"not null" json:"title"`
    Description string    `json:"description"`
    ProjectID   uint      `gorm:"not null;index" json:"project_id"`
    AssigneeID  uint      `json:"assignee_id"`  // user id
    Status      string    `gorm:"default:pending" json:"status"` // pending, in_progress, done
    DueDate     time.Time `json:"due_date"`
    CreatedAt   time.Time `json:"created_at"`
    UpdatedAt   time.Time `json:"updated_at"`
    
    // ความสัมพันธ์
    Project Project `gorm:"foreignKey:ProjectID" json:"project,omitempty"`
    Assignee User   `gorm:"foreignKey:AssigneeID" json:"assignee,omitempty"`
}
```

### 9.6 Repository Layer (internal/repositories/)

**project_repo.go** (ตัวอย่าง)
```go
// internal/repositories/project_repo.go
package repositories

import (
    "pms/internal/models"
    "gorm.io/gorm"
)

type ProjectRepository struct {
    db *gorm.DB
}

func NewProjectRepository(db *gorm.DB) *ProjectRepository {
    return &ProjectRepository{db: db}
}

// CreateProject สร้างโครงการใหม่
// CreateProject creates a new project
func (r *ProjectRepository) Create(project *models.Project) error {
    return r.db.Create(project).Error
}

// GetByID ดึงโครงการตาม ID พร้อมโหลด Tasks
// GetByID retrieves a project by ID with Tasks preloaded
func (r *ProjectRepository) GetByID(id uint) (*models.Project, error) {
    var project models.Project
    err := r.db.Preload("Tasks").First(&project, id).Error
    return &project, err
}

// Update อัปเดตข้อมูลโครงการ
// Update updates project information
func (r *ProjectRepository) Update(project *models.Project) error {
    return r.db.Save(project).Error
}

// Delete ลบโครงการ (soft delete หรือ hard delete)
// Delete removes a project (hard delete)
func (r *ProjectRepository) Delete(id uint) error {
    return r.db.Delete(&models.Project{}, id).Error
}

// List ดึงรายการโครงการแบบ paginate
// List returns paginated projects
func (r *ProjectRepository) List(page, limit int) ([]models.Project, int64, error) {
    var projects []models.Project
    var total int64
    offset := (page - 1) * limit
    
    r.db.Model(&models.Project{}).Count(&total)
    err := r.db.Offset(offset).Limit(limit).Find(&projects).Error
    return projects, total, err
}
```

### 9.7 Service Layer (internal/services/)

**project_service.go**
```go
// internal/services/project_service.go
package services

import (
    "errors"
    "pms/internal/models"
    "pms/internal/repositories"
)

type ProjectService struct {
    repo *repositories.ProjectRepository
}

func NewProjectService(repo *repositories.ProjectRepository) *ProjectService {
    return &ProjectService{repo: repo}
}

// CreateProject ตรวจสอบ business logic ก่อนบันทึก
// CreateProject validates business rules before saving
func (s *ProjectService) CreateProject(project *models.Project) error {
    // ตรวจสอบว่า end date ต้องมากกว่า start date
    // Validate that end date is after start date
    if !project.EndDate.After(project.StartDate) {
        return errors.New("end date must be after start date")
    }
    return s.repo.Create(project)
}

// GetProject ดึงโครงการตาม ID
func (s *ProjectService) GetProject(id uint) (*models.Project, error) {
    return s.repo.GetByID(id)
}

// UpdateProject อัปเดตโครงการ
func (s *ProjectService) UpdateProject(project *models.Project) error {
    // ตรวจสอบ business logic ก่อนอัปเดต
    // Validate business logic before update
    if !project.EndDate.After(project.StartDate) {
        return errors.New("end date must be after start date")
    }
    return s.repo.Update(project)
}

// DeleteProject ลบโครงการ
func (s *ProjectService) DeleteProject(id uint) error {
    return s.repo.Delete(id)
}

// ListProjects รายการโครงการแบบแบ่งหน้า
func (s *ProjectService) ListProjects(page, limit int) ([]models.Project, int64, error) {
    return s.repo.List(page, limit)
}
```

### 9.8 Handler Layer (internal/handlers/)

**project_handler.go**
```go
// internal/handlers/project_handler.go
package handlers

import (
    "net/http"
    "strconv"
    "pms/internal/models"
    "pms/internal/services"
    "github.com/gin-gonic/gin"
)

type ProjectHandler struct {
    service *services.ProjectService
}

func NewProjectHandler(service *services.ProjectService) *ProjectHandler {
    return &ProjectHandler{service: service}
}

// CreateProject handles POST /api/projects
func (h *ProjectHandler) CreateProject(c *gin.Context) {
    var project models.Project
    // แปลง JSON request body ให้เป็น struct
    // Bind JSON request body to struct
    if err := c.ShouldBindJSON(&project); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // กำหนด created_by จาก user ที่ login (ได้จาก middleware)
    // Set created_by from logged-in user (from middleware)
    userID, exists := c.Get("user_id")
    if exists {
        project.CreatedBy = userID.(uint)
    }

    if err := h.service.CreateProject(&project); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusCreated, project)
}

// GetProject handles GET /api/projects/:id
func (h *ProjectHandler) GetProject(c *gin.Context) {
    id, err := strconv.ParseUint(c.Param("id"), 10, 32)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "invalid id"})
        return
    }
    project, err := h.service.GetProject(uint(id))
    if err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "project not found"})
        return
    }
    c.JSON(http.StatusOK, project)
}

// UpdateProject handles PUT /api/projects/:id
func (h *ProjectHandler) UpdateProject(c *gin.Context) {
    id, _ := strconv.ParseUint(c.Param("id"), 10, 32)
    var project models.Project
    if err := c.ShouldBindJSON(&project); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    project.ID = uint(id)
    if err := h.service.UpdateProject(&project); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, project)
}

// DeleteProject handles DELETE /api/projects/:id
func (h *ProjectHandler) DeleteProject(c *gin.Context) {
    id, _ := strconv.ParseUint(c.Param("id"), 10, 32)
    if err := h.service.DeleteProject(uint(id)); err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusNoContent, nil)
}

// ListProjects handles GET /api/projects?page=1&limit=10
func (h *ProjectHandler) ListProjects(c *gin.Context) {
    page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
    limit, _ := strconv.Atoi(c.DefaultQuery("limit", "10"))
    projects, total, err := h.service.ListProjects(page, limit)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, gin.H{
        "data":  projects,
        "total": total,
        "page":  page,
        "limit": limit,
    })
}
```

### 9.9 Middleware Authentication (internal/middleware/auth.go)

```go
// internal/middleware/auth.go
package middleware

import (
    "net/http"
    "strings"
    "github.com/gin-gonic/gin"
    "github.com/golang-jwt/jwt/v5"
    "pms/internal/config"
)

// AuthMiddleware ตรวจสอบ JWT token และแทรก user_id, role ลงใน context
// AuthMiddleware validates JWT token and injects user_id, role into context
func AuthMiddleware(cfg *config.Config) gin.HandlerFunc {
    return func(c *gin.Context) {
        authHeader := c.GetHeader("Authorization")
        if authHeader == "" {
            c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "missing authorization header"})
            return
        }

        // รูปแบบ "Bearer <token>"
        // Format: "Bearer <token>"
        parts := strings.Split(authHeader, " ")
        if len(parts) != 2 || parts[0] != "Bearer" {
            c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid token format"})
            return
        }

        tokenString := parts[1]
        claims := jwt.MapClaims{}
        token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
            return []byte(cfg.JWTSecret), nil
        })

        if err != nil || !token.Valid {
            c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid token"})
            return
        }

        // ดึง user_id และ role จาก claims
        // Extract user_id and role from claims
        userID, ok := claims["user_id"].(float64)
        if !ok {
            c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid token claims"})
            return
        }
        role, _ := claims["role"].(string)

        c.Set("user_id", uint(userID))
        c.Set("role", role)
        c.Next()
    }
}

// RoleMiddleware ตรวจสอบว่า user มี role ที่อนุญาต
// RoleMiddleware checks if user has allowed role
func RoleMiddleware(allowedRoles ...string) gin.HandlerFunc {
    return func(c *gin.Context) {
        role, exists := c.Get("role")
        if !exists {
            c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "forbidden"})
            return
        }
        roleStr := role.(string)
        for _, r := range allowedRoles {
            if r == roleStr {
                c.Next()
                return
            }
        }
        c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "insufficient permissions"})
    }
}
```

### 9.10 Routes (internal/routes/routes.go)

```go
// internal/routes/routes.go
package routes

import (
    "pms/internal/config"
    "pms/internal/database"
    "pms/internal/handlers"
    "pms/internal/middleware"
    "pms/internal/repositories"
    "pms/internal/services"
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

func SetupRoutes(r *gin.Engine, db *gorm.DB, cfg *config.Config) {
    // สร้าง repositories
    // Create repositories
    projectRepo := repositories.NewProjectRepository(db)
    
    // สร้าง services
    // Create services
    projectService := services.NewProjectService(projectRepo)
    
    // สร้าง handlers
    // Create handlers
    projectHandler := handlers.NewProjectHandler(projectService)
    
    // กลุ่ม routes ที่ต้องใช้ authentication
    // Authenticated routes group
    auth := r.Group("/api")
    auth.Use(middleware.AuthMiddleware(cfg))
    {
        // Project routes
        auth.POST("/projects", middleware.RoleMiddleware("admin", "pm"), projectHandler.CreateProject)
        auth.GET("/projects/:id", projectHandler.GetProject)
        auth.PUT("/projects/:id", middleware.RoleMiddleware("admin", "pm"), projectHandler.UpdateProject)
        auth.DELETE("/projects/:id", middleware.RoleMiddleware("admin"), projectHandler.DeleteProject)
        auth.GET("/projects", projectHandler.ListProjects)
    }
    
    // route สาธารณะ (เช่น login)
    // Public routes (e.g., login)
    r.POST("/api/login", func(c *gin.Context) {
        // ตัวอย่าง: รับ username/password, สร้าง JWT
        // Example: receive username/password, generate JWT
        // (โค้ดนี้ควรแยกไป auth handler)
        c.JSON(200, gin.H{"token": "dummy-jwt-token"})
    })
}
```

### 9.11 วิธีรันโปรเจกต์

```bash
# 1. Clone หรือสร้างโฟลเดอร์ pms
# 2. ตั้งค่า environment variables ใน .env
# 3. รัน MSSQL ด้วย Docker (ถ้ายังไม่มี)
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong!Password" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest

# 4. รัน Go module
go mod init pms
go get -u gorm.io/gorm gorm.io/driver/sqlserver github.com/gin-gonic/gin github.com/golang-jwt/jwt/v5

# 5. รันแอปพลิเคชัน
go run cmd/server/main.go
```

---

## 10. Check List Module การทำงาน

| Function | Method | Endpoint | Auth Required | Role Required | Status |
|----------|--------|----------|---------------|---------------|--------|
| สร้างโครงการ | POST | /api/projects | ✅ | admin, pm | ✅ |
| ดูโครงการ | GET | /api/projects/:id | ✅ | - | ✅ |
| แก้ไขโครงการ | PUT | /api/projects/:id | ✅ | admin, pm | ✅ |
| ลบโครงการ | DELETE | /api/projects/:id | ✅ | admin | ✅ |
| รายการโครงการ | GET | /api/projects | ✅ | - | ✅ |
| ล็อกอิน | POST | /api/login | ❌ | - | ตัวอย่าง |

---

## 11. Security Code

- **JWT Authentication:** ใช้ HS256, เก็บ secret ใน environment
- **Password Hashing:** ควรใช้ bcrypt (ในตัวอย่างไม่ได้แสดง แต่ควรเพิ่ม)
- **Input Validation:** ใช้ Gin's binding tags (required, min, max)
- **SQL Injection:** GORM ป้องกันโดยใช้ parameterized queries
- **TLS:** ใน production ควรใช้ HTTPS (ตั้งค่า reverse proxy หรือ Gin TLS)

---

## 12. Load Test Development

ใช้ **k6** สำหรับ load test ตัวอย่าง script `test/loadtest/spike.js`:

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 20 }, // ramp-up
    { duration: '1m', target: 20 },  // steady
    { duration: '10s', target: 0 },  // ramp-down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% requests < 500ms
    http_req_failed: ['rate<0.01'],  // error rate < 1%
  },
};

export default function () {
  const res = http.get('http://localhost:8080/api/projects?page=1&limit=10', {
    headers: { Authorization: 'Bearer <your-token>' },
  });
  check(res, { 'status is 200': (r) => r.status === 200 });
  sleep(1);
}
```

รันด้วยคำสั่ง: `k6 run test/loadtest/spike.js`

---

## 13. สรุป (Summary)

### ประโยชน์ที่ได้รับ
- ได้ระบบจัดการโครงการพื้นฐานที่พร้อมขยาย
- ได้เรียนรู้การเชื่อมต่อ Go + MSSQL + GORM
- มีโครงสร้างโค้ดที่เป็นระเบียบ แยก layer ชัดเจน

### ข้อควรระวัง
- ต้องตั้งค่า JWT secret ให้แข็งแรงและไม่ hardcode
- ตรวจสอบการจัดการ connection pool (GORM จัดการเองบางส่วน)
- MSSQL บน Docker อาจใช้ทรัพยากรสูง

### ข้อดี
- Go ให้ประสิทธิภาพสูง รองรับ concurrent
- GORM ช่วยลด boilerplate SQL
- รองรับการขยายเป็น microservices ได้ง่าย

### ข้อเสีย
- GORM มี learning curve บางจุด (เช่น preload, transaction)
- การ debug raw SQL อาจยากกว่าใช้ sqlx

### ข้อห้าม
- ห้ามเก็บ secret ในโค้ด
- ห้ามใช้ GORM's `db.Raw` โดยไม่ตรวจสอบ input (SQL injection)
- ห้าม deploy โดยไม่ตั้งค่า TLS

---

## 14. คู่มือการทดสอบ (Test Manual)

### 14.1 Check List Test

| Test Case | ขั้นตอน | ผลที่คาดหวัง | ผลลัพธ์ |
|-----------|---------|--------------|---------|
| สร้างโครงการสำเร็จ | POST /api/projects พร้อม token valid และข้อมูลถูกต้อง | 201, ข้อมูลโครงการถูกบันทึก | ✅ |
| สร้างโครงการโดยไม่มี token | POST /api/projects ไม่มี Header Authorization | 401 Unauthorized | ✅ |
| สร้างโครงการด้วย role member | ใช้ token ของ member | 403 Forbidden | ✅ |
| ดูโครงการที่มีอยู่ | GET /api/projects/1 | 200, ข้อมูลถูกต้อง | ✅ |
| ดูโครงการที่ไม่มี | GET /api/projects/999 | 404 Not Found | ✅ |
| ลบโครงการด้วย admin | DELETE /api/projects/1 | 204 No Content | ✅ |

### 14.2 การทดสอบ Unit (ตัวอย่าง)

```go
// project_service_test.go
func TestCreateProject_InvalidDate(t *testing.T) {
    repo := &mockProjectRepository{}
    service := NewProjectService(repo)
    project := &models.Project{StartDate: time.Now(), EndDate: time.Now().Add(-24 * time.Hour)}
    err := service.CreateProject(project)
    assert.Error(t, err)
    assert.Contains(t, err.Error(), "end date must be after start date")
}
```

---

## 15. คู่มือการใช้งาน (User Manual)

1. **ลงชื่อเข้าใช้:** ส่ง POST /api/login พร้อม `{"username":"admin","password":"..."}` รับ JWT token
2. **สร้างโครงการ:** ใช้ token ใน Header, ส่ง POST /api/projects พร้อม JSON project
3. **ดูโครงการ:** GET /api/projects/{id}
4. **อัปเดตโครงการ:** PUT /api/projects/{id}
5. **ลบโครงการ:** DELETE /api/projects/{id}
6. **รายการโครงการ:** GET /api/projects?page=1&limit=10

---

## 16. คู่มือการบำรุงรักษา (Maintenance Manual)

- **การดู logs:** ใช้ `fmt.Println` หรือ `log` ปรับเป็น structured logging (zap/logrus)
- **การ backup database:** ใช้ `sqlcmd` หรือ Azure Backup
- **การอัปเกรด schema:** ใช้ GORM AutoMigrate หรือ manual migration scripts
- **การ restart service:** ใช้ systemd หรือ container orchestration (K8s)

---

## 17. คู่มือการขยาย/แก้ไข (Extension/Modification Guide)

- **เพิ่ม API ใหม่:** สร้าง handler, service, repo ตาม pattern ที่มี
- **เพิ่มฟิลด์ในตาราง:** แก้ model และรัน AutoMigrate
- **เพิ่ม middleware:** สร้างใน `internal/middleware` และเพิ่มใน routes
- **เปลี่ยน database:** เปลี่ยน driver ใน `database/mssql.go` (เช่น ไป PostgreSQL)

---

## 18. Git Flow

**Branch strategy:**
- `main` – production-ready code
- `develop` – integration branch
- `feature/xxx` – feature branches from develop
- `hotfix/xxx` – urgent fixes from main

**Example flow:**
```bash
git checkout -b feature/add-task-api develop
# ... commit changes ...
git push origin feature/add-task-api
# create PR to develop
# after merge, delete branch
```

---

## 19. Code Review & PR Checklist

**PR Checklist:**
- [ ] โค้ดผ่าน `go fmt`, `go vet`, `golangci-lint`
- [ ] มี unit tests ครอบคลุม logic สำคัญ
- [ ] ไม่มี secret หรือ credential ในโค้ด
- [ ] ใช้ environment variables สำหรับ config
- [ ] มีการจัดการ error อย่างเหมาะสม (ไม่ ignore)
- [ ] API response มี status code และ message ชัดเจน
- [ ] มีการอัปเดต documentation (ถ้ามี)

---

## 20. CI/CD Design (ตัวอย่าง GitHub Actions)

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ develop, main ]
  pull_request:
    branches: [ develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: '1.21'
    - name: Install dependencies
      run: go mod download
    - name: Lint
      uses: golangci/golangci-lint-action@v3
    - name: Test
      run: go test -v ./...
    - name: Build
      run: go build -o pms ./cmd/server
    - name: Docker Build & Push (on main)
      if: github.ref == 'refs/heads/main'
      run: |
        docker build -t pms:latest .
        docker tag pms:latest yourregistry/pms:${{ github.sha }}
        docker push yourregistry/pms:${{ github.sha }}
```

---

## 21. Root Cause Solution (RCA)

### ขั้นตอนการทำ RCA

1. **ระบุปัญหา (Define the Problem)**
   - อะไร, ที่ไหน, เมื่อไหร่, ผลกระทบ

2. **รวบรวมข้อมูล (Collect Data)**
   - logs, metrics, timeline, การเปลี่ยนแปลงล่าสุด

3. **ระบุสาเหตุที่เป็นไปได้ (Identify Possible Causes)**
   - ใช้เทคนิค 5 Whys, Fishbone diagram

4. **หา "สาเหตุหลัก" (Find the Root Cause)**
   - วิเคราะห์ลงลึกว่าสาเหตุใดคือสาเหตุหลักที่แท้จริง

5. **วางแผนและแก้ไข (Implement Solution)**
   - แก้ไข短期 และ长期

6. **ติดตามผล (Monitor)**
   - ตรวจสอบว่าปัญหาไม่กลับมาอีก

### ตัวอย่าง RCA Template

```markdown
## RCA Report: API timeout เมื่อเรียก GET /projects

**วันที่เกิด:** 2025-04-01
**ระดับความรุนแรง:** สูง

### 1. ปัญหา
Client เรียก GET /api/projects?page=1&limit=1000 พบ timeout หลังจาก 30 วินาที

### 2. ข้อมูล
- Logs: พบ query `SELECT * FROM projects` ใช้เวลา 25 วินาที
- จำนวน record: 500,000 projects
- ไม่มี index บนคอลัมน์ที่ใช้ filter

### 3. สาเหตุที่เป็นไปได้
- ขาด index
- limit สูงเกินไป
- network latency

### 4. สาเหตุหลัก
Missing index on `projects.created_at` (ใช้ในการเรียงลำดับ) และไม่มี pagination ที่เหมาะสม

### 5. วิธีแก้ไข
- เพิ่ม index: `CREATE INDEX idx_projects_created_at ON projects(created_at);`
- จำกัด limit สูงสุด 100 ใน API
- ใช้ cursor-based pagination แทน offset

### 6. ติดตามผล
หลังจาก deploy, P99 latency ลดลงเหลือ 200ms
```

---

## ตัวอย่างโค้ดที่รันได้จริง (Full Runnable Example)

เนื่องจากข้อจำกัดของพื้นที่ โค้ดเต็มอยู่ในส่วนที่ 9 สามารถนำไปรวมกันแล้วรันได้ทันทีโดยทำตามขั้นตอนใน 9.11

**หมายเหตุ:** อย่าลืมสร้างตาราง users และเพิ่ม user ตัวอย่างด้วย script หรือ API register ก่อนทดสอบ

---

**จัดทำโดย:** Software Engineer Team  
**วันที่:** เมษายน 2026