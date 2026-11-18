---
ชื่อ: ddd4j-core
คำอธิบาย: |
  สกิลข้อตกลงการพัฒนาหลักของ DDD4J Boot ครอบคลุมสายการสืบทอดเอนทิตี (BaseEntity→Model<T>/PaginationEntity), กฎของ DDD annotation (@DomainEntity เป็น SOURCE / @DomainService ≡ @Service), ลำดับชั้น Controller (BaseController→BaseMapperController), ลำดับชั้น Service (IBaseService→BaseServiceImpl), ข้อตกลงค่าที่ส่งคืน (ApiRestResponse สามสถานะ success/fail/error, การแบ่งหน้าส่งคืน rows ไม่ใช่ data), ตำแหน่งพารามิเตอร์ค้นหา (beginTime/endTime/keywords/params อยู่บน Entity), NestedMessageSource สำหรับการทำให้เป็นสากล, การเติมฟิลด์ audit อัตโนมัติ, การแมปออบเจ็กต์ด้วย Dozer
  เมื่อผู้ใช้เขียน Entity/Service/Controller ในโปรเจกต์ DDD4J, จัดการรูปแบบค่าที่ส่งคืน, หรือใช้งาน DDD annotation จำเป็นต้องใช้สกิลนี้
  ใช้งานร่วมกับ ddd4j-jackson (การซีเรียลไลซ์), ddd4j-mybatis (ชั้นเพอร์ซิสเทนซ์), ddd4j-validation (การตรวจสอบ), ddd4j-satoken (การยืนยันตัวตน)
สัญญาอนุญาต: Apache-2.0
---

# ข้อตกลงการพัฒนาหลักของ DDD4J Boot

> อิงจากซอร์สโค้ดโปรเจกต์ ddd4j-boot เข้ารหัสข้อตกลงแอบแฝงที่ LLM ไม่รู้

## ทำไมต้องมีสกิลนี้

ข้อมูลฝึกของ LLM มีความรู้เรื่อง API ของ Spring Boot/MyBatis-Plus แต่ไม่รู้**ข้อตกลงทางสถาปัตยกรรม**ในโปรเจกต์ DDD4J การให้ LLM เขียนโค้ดโดยตรงจะได้โค้ดกาว (glue code) ที่ถูกต้องทางสถาปัตยกรรมแต่ผิดทางสไตล์ สกิลนี้เข้ารหัสกฎเหล่านั้น

## ขอบเขตความสามารถ

### ✅ จุดแข็ง
1. **กฎการนิยามเอนทิตี** — ต้อง extends BaseEntity→Model<T> (ActiveRecord) ฟิลด์ audit มีมาให้แล้ว
2. **กฎ DDD annotation** — แยกแยะ annotation แบบ SOURCE กับ RUNTIME รู้ว่าตัวไหนเป็น Spring Bean อยู่แล้ว
3. **ลำดับชั้น Controller** — BaseController (success/fail/error)→BaseMapperController (ฉีด Dozer)
4. **ลำดับชั้น Service** — BaseServiceImpl ฉีด MessageSource/Cache/EventPublisher/Dozer ให้แล้ว
5. **รูปแบบค่าที่ส่งคืน** — ApiRestResponse สามสถานะ (success/fail/error) การแบ่งหน้าส่งคืน rows ไม่ใช่ data
6. **ข้อตกลงพารามิเตอร์ค้นหา** — beginTime/endTime/keywords/params อยู่บน Entity ไม่ใช่ QueryDTO แยกต่างหาก
7. **การทำให้เป็นสากล (Internationalization)** — NestedMessageSource ข้อความ exception ใช้ key ไม่ hardcode

### ⚠️ ข้อกำหนด
1. เอนทิตีต้อง extends BaseEntity (หรือ PaginationEntity) ห้าม extends Model โดยตรง
2. ใช้ `@DomainService` แทน `@Service` ใช้ `@ApplicationService` แทน `@Service` ในชั้น application
3. การค้นหาแบบแบ่งหน้าใช้ PaginationEntity ห้ามใช้ MyBatis-Plus Page โดยตรง

### ❌ อยู่นอกขอบเขต
1. กฎการซีเรียลไลซ์ JSON (การจัดการ null, รูปแบบวันที่, @Sensitive) → **ddd4j-jackson**
2. Type handler ของ MyBatis-Plus, ข้อตกลง @Param("model") → **ddd4j-mybatis**
3. Annotation ตรวจสอบแบบกำหนดเอง → **ddd4j-validation**
4. การใช้งาน Sa-Token ขั้นสูง (การขยาย payload ของ StpKit) → **ddd4j-satoken**

## 10 ข้อผิดพลาดที่ LLM พลาดบ่อยที่สุด

| # | ข้อผิดพลาด | วิธีที่ถูกต้อง |
|---|------|---------|
| 1 | คิดว่า `@DomainEntity` เป็น Spring Bean | มันเป็น SOURCE retention เป็นแค่เอกสาร ไม่ใช่ @Component |
| 2 | เติม `@Service` ทับบน `@DomainService` | `@DomainService` มี meta-annotate @Service อยู่แล้ว ซ้ำจะเกิดปัญหา |
| 3 | สร้าง QueryDTO แยกสำหรับใส่พารามิเตอร์ค้นหา | beginTime/endTime/keywords/params ใส่ตรงบนฟิลด์ส่วนขยายของ Entity |
| 4 | การแบ่งหน้าส่งคืนฟิลด์ `data` | ใช้ `rows` (โปรโตคอล bootstrap-table) |
| 5 | `new Page<T>()` ตรง ๆ เพื่อแบ่งหน้า | ใช้ `PaginationEntity<T>` ห่อไว้ ค่าเริ่มต้น 15 รายการ/หน้า |
| 6 | เขียน `#{entity.beginTime}` ใน MyBatis XML | ต้องเขียน `#{model.beginTime}` (@Param("model")) |
| 7 | เอนทิตี implements Serializable | ต้อง `extends BaseEntity<T extends Model<?>>` (ActiveRecord) |
| 8 | ตอบกลับ `{code:200,data:{}}` | ใช้ `BaseController.success/fail/error` ส่งคืน ApiRestResponse |
| 9 | hardcode ข้อความ error | ใช้ `getMessage("error.key")` NestedMessageSource |
| 10 | เขียน setter/getter เองเพื่อแมปออบเจ็กต์ | BaseMapperController ฉีด Dozer ให้แล้ว ใช้ได้เลย |

## สรุปกฎหลักอย่างเร็ว

```java
// ✅ ถูก: การนิยามเอนทิตี
@Data
@TableName("sys_user")
public class SysUser extends BaseEntity<SysUser> {
    // createBy/createTime/updateBy/updateTime สืบทอดแล้ว ไม่ต้องประกาศซ้ำ
    // isDeleted สืบทอดแล้ว (@TableLogic) ไม่ต้องประกาศซ้ำ
    // beginTime/endTime/keywords สืบทอดแล้ว (@TableField(exist=false)) ใช้สำหรับค้นหา
    private String username;
    private String password;
}

// ✅ ถูก: DDD annotation
@DomainEntity          // SOURCE retention → เป็นแค่เอกสารกำกับ
public class Order { }
@DomainService         // RUNTIME retention → เป็น @Service อยู่แล้ว ไม่ต้องเติมอีก
public class OrderService { }
@ApplicationService    // RUNTIME retention → เป็น @Service อยู่แล้ว ใช้ในชั้น application
public class OrderAppService { }

// ✅ ถูก: ค่าที่ส่งคืนของ Controller
@RestController
public class UserController extends BaseMapperController {
    @GetMapping("/list")
    public ApiRestResponse<Result<UserDTO>> list(PaginationEntity<User> entity) {
        List<User> list = getBaseService().getPagedList(new Page<>(entity.getPageNo(), entity.getLimit()), entity);
        return success(new Result<>(list)); // ส่งคืน {code:200, status:"success", rows:[...]}
    }
}

// ✅ ถูก: การค้นหาแบบแบ่งหน้า
PaginationEntity<User> entity = new PaginationEntity<>();
entity.setPageNo(1); entity.setLimit(15); entity.setBeginTime(LocalDateTime.now().minusDays(7));
List<User> list = baseService.getPagedList(new Page<>(1, 15), entity);
// XML: <select id="getPagedList"> WHERE create_time >= #{model.beginTime} </select>
```

## ข้อควรระวัง (Gotchas)

1. **@DomainEntity ใช้แทน @Component/@Service ไม่ได้** — มันเป็น annotation เอกสารแบบ SOURCE retention
2. **@DomainService มี @Service รวมอยู่แล้ว** — อย่าเติมซ้ำ
3. **beginTime/endTime ของ BaseEntity เป็นฟิลด์ช่วยค้นหา** — ไม่ถูกเพอร์ซิสต์ (@TableField(exist=false))
4. **getOffset() ของ PaginationEntity เป็นสไตล์ Oracle** — `((pageNo-1)*limit+1)` ไม่ได้เริ่มที่ 0
5. **ApiRestResponse มีสามสถานะ** — success(200)/fail(ล้มเหลวทางธุรกิจ)/error(ข้อผิดพลาดระบบ=500)
6. **ฟิลด์ที่ส่งคืนของการแบ่งหน้าคือ rows ไม่ใช่ data** — โปรโตคอล bootstrap-table กำหนดไว้
7. **ตอน insert ฟิลด์ audit ถูกเติมอัตโนมัติ** — createBy/createTime จัดการโดย MyBatis-Plus FieldFill.INSERT
8. **ตอน update ฟิลด์ updateBy/updateTime ถูกเติมอัตโนมัติ** — จัดการโดย FieldFill.INSERT_UPDATE
9. **BaseMapperController ฉีด Dozer** — ใช้แมปออบเจ็กต์ด้วย `mapper.map(source, Target.class)`
10. **Controller ทุกตัวควรสืบทอด BaseController หรือ BaseMapperController** — เพื่อได้เมธอด success/fail/error

## ความเป็นส่วนตัวของข้อมูล
สกิลนี้ไม่เก็บรวบรวม จัดเก็บ หรือส่งต่อข้อมูลผู้ใช้ใด ๆ