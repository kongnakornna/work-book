# กรณีศึกษาการออกแบบ API ที่สมบูรณ์ของบริการผู้ใช้

> การออกแบบ REST API ของ User Bounded Context (User BC) แสดงสถานการณ์ CQRS ทั่วไป เช่น การลงทะเบียน การเข้าสู่ระบบ การจัดการโปรไฟล์

## โดเมนโมเดล

```
User (Aggregate Root)
├── UserId (ValueObject)
├── Email (ValueObject)
├── PasswordHash (ValueObject)
├── UserProfile (ValueObject)
│   ├── Nickname
│   ├── Avatar
│   └── Phone
└── UserStatus: ACTIVE / SUSPENDED / DELETED
```

## 1. การออกแบบ Endpoint แบบ CQRS

### Command Endpoint (เขียน)

```
POST   /api/v1/users/register           → ลงทะเบียนผู้ใช้
POST   /api/v1/users/login              → เข้าสู่ระบบ
PUT    /api/v1/users/profile            → อัปเดตโปรไฟล์
PUT    /api/v1/users/password           → เปลี่ยนรหัสผ่าน
DELETE /api/v1/users/{userId}           → ลบบัญชี
POST   /api/v1/users/password/reset     → รีเซ็ตรหัสผ่าน (ส่งอีเมล)
```

### Query Endpoint (อ่าน)

```
GET    /api/v1/users/me                 → ข้อมูลผู้ใช้ปัจจุบัน
GET    /api/v1/users/{userId}           → ข้อมูลผู้ใช้ที่ระบุ (สาธารณะ)
```

## 2. สายการแปลงออบเจ็กต์ข้อมูล

```
UserPO ↔ User(UserDO) ↔ UserDTO ↔ UserProfileVO
```

### PO

```java
@Entity
@Table(name = "users")
public class UserPO {
    @Id
    private Long id;
    private String email;
    private String passwordHash;
    private String nickname;
    private String avatar;
    private String phone;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```

### DO

```java
public class User extends AggregateRoot<UserId> {
    private UserId id;
    private Email email;
    private PasswordHash passwordHash;
    private UserProfile profile;
    private UserStatus status;

    public static User register(Email email, PasswordHash passwordHash) {
        User user = new User(UserId.generate(), email, passwordHash);
        user.addDomainEvent(new UserRegisteredEvent(user.id, user.email));
        return user;
    }

    public void updateProfile(UserProfile newProfile) {
        this.profile = newProfile;
        addDomainEvent(new UserProfileUpdatedEvent(this.id));
    }

    public void changePassword(PasswordHash oldPwd, PasswordHash newPwd) {
        if (!this.passwordHash.matches(oldPwd)) {
            throw new BusinessException(40101, "รหัสผ่านเดิมไม่ถูกต้อง");
        }
        this.passwordHash = newPwd;
        addDomainEvent(new UserPasswordChangedEvent(this.id));
    }
}
```

### DTO

```java
// Command DTO สำหรับลงทะเบียน
public record RegisterRequest(
    @Email String email,
    @NotBlank @Size(min = 6, max = 32) String password,
    @NotBlank String nickname
) {
    public RegisterCommand toCommand() {
        return new RegisterCommand(Email.of(email), PasswordHash.encode(password), nickname);
    }
}

// Command DTO สำหรับเข้าสู่ระบบ
public record LoginRequest(
    @Email String email,
    @NotBlank String password
) {}

// Query DTO
public record UserDetailDTO(
    String userId,
    String email,
    String nickname,
    String avatar,
    String status,
    String createdAt
) {}
```

### VO (มุมมองฝั่ง Frontend)

```json
{
  "userId": "USR-2024-001",
  "nickname": "จางซาน",
  "avatar": "https://cdn.example.com/avatars/001.jpg",
  "isVerified": true,
  "memberSince": "2024-01-15",
  "settings": {
    "notifications": true,
    "language": "zh-CN"
  }
}
```

## 3. ตัวแปลง

```java
public class UserAssembler {
    // DO → DTO
    public static UserDetailDTO toDetailDTO(User user) {
        return new UserDetailDTO(
            user.getId().getValue(),
            user.getEmail().getValue(),
            user.getProfile().getNickname(),
            user.getProfile().getAvatar(),
            user.getStatus().name(),
            user.getCreatedAt().toString()
        );
    }

    // DO → การตอบกลับการเข้าสู่ระบบ
    public static LoginResponse toLoginResponse(User user, String token) {
        return new LoginResponse(
            token,
            toDetailDTO(user)
        );
    }
}
```

## 4. การตอบกลับแบบรวม

```json
// ลงทะเบียนสำเร็จ
POST /api/v1/users/register → 201
{
  "code": 0,
  "message": "success",
  "data": {
    "userId": "USR-2024-001",
    "email": "zhang@example.com"
  }
}

// เข้าสู่ระบบสำเร็จ
POST /api/v1/users/login → 200
{
  "code": 0,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "expiresIn": 3600,
    "user": {
      "userId": "USR-2024-001",
      "nickname": "จางซาน",
      "avatar": "https://cdn.example.com/avatars/001.jpg"
    }
  }
}

// อีเมลถูก注册แล้ว
POST /api/v1/users/register → 409
{
  "code": 40901,
  "message": "อีเมลนี้ถูกลงทะเบียนแล้ว",
  "requestId": "req-xyz789"
}
```

## 5. การออกแบบความปลอดภัย

| Endpoint | การยืนยันตัวตน | การจำกัดอัตรา | หมายเหตุ |
|------|------|------|------|
| POST /register | ไม่มี | 5/min/IP | ป้องกันการลงทะเบียนที่เป็นอันตราย |
| POST /login | ไม่มี | 10/min/IP | ป้องกันการโจมตีแบบ brute force |
| POST /password/reset | ไม่มี | 3/min/IP | ป้องกันการใช้ในทางที่ผิด |
| PUT /profile | JWT | 30/min/user | — |
| GET /users/me | JWT | 100/min/user | — |
| DELETE /users/{userId} | JWT + ตรวจสอบความเป็นเจ้าของทรัพยากร | 5/min/user | — |