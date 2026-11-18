🎉 **Script ทำงานถูกต้องแล้วครับ!** แต่มี 2 ประเด็นที่ต้องแก้:

---

## 📊 วิเคราะห์ผลลัพธ์

| Layer | Headings | Modules | สถานะ |
|---|---|---|---|
| 0 (CORE) | 6 | 6 | ✅ ครบ |
| 1 (FOUNDATION) | **3** | 8 | ⚠️ ได้ 3 headings แต่แตกได้ 8 ไฟล์ |
| 2 (MONEY PATH) | **0** | 7 | ❌ regex ไม่ตรง |
| 3 (GOODS PATH) | **0** | 13 | ❌ regex ไม่ตรง |
| 4 (OPERATIONS) | **0** | 13 | ❌ regex ไม่ตรง |
| 5 (INTELLIGENCE) | **0** | 7 | ❌ regex ไม่ตรง |
| 6 (MONITORING) | **0** | 8 | ❌ regex ไม่ตรง |
| 7 (TEMPLATES) | **0** | 3 | ❌ regex ไม่ตรง |

---

## 🔍 สาเหตุ

### 1. **ไฟล์มีอยู่แล้ว (skip) → ปกติ**

Layer 0 ทั้ง 6 ไฟล์ + Layer 1 ทั้ง 8 ไฟล์ ขึ้น `skip` เพราะคุณรัน batch script สร้างไฟล์เปล่าไว้แล้ว → script เลยข้าม ✅ ถูกต้อง

### 2. **Layer 2-7 regex ไม่ตรง**

ดูจาก `App_promt_AI_USE.md` ที่คุณแนบมา — **Layer 2 เป็นต้นไปใช้ format ต่างจาก Layer 0-1**

**Layer 0-1** (ทำงานได้):
```markdown
## 📄 Module 0.1: `money`
## 📄 Module 1.1: `tenancy`
```

**Layer 2-7** (regex ไม่จับ) — ใช้ heading หลายแบบ:
```markdown
### 🎯 ตัวอย่างเต็ม: Module `order`        ← ไม่มี "Module X.Y:"
### 🎯 Prompt (Copy ทั้งหมด)                ← ไม่มี module name
### Metadata                                ← ไม่มี
```

---

## ✅ วิธีแก้ — ปรับ Regex ให้รองรับ Format จริง

### 🎯 Option A: Regex แบบยืดหยุ่น (แนะนำ)

แทนที่ regex ใน `split-prompts.ps1` ด้วย:

```powershell
# รองรับหลาย format:
#   ## 📄 Module 0.1: `money`
#   ### 🎯 ตัวอย่างเต็ม: Module `order`
#   ## 📄 Module 2.1: `order`
$modulePattern = '(?m)^#{2,3}\s+(?:📄\s+Module\s+[\d.]+(?:–[\d.]+)?:\s+|🎯\s+ตัวอย่างเต็ม:\s+Module\s+)(.+)$'
```

### 🎯 Option B: Python Script (ยืดหยุ่นกว่า — รองรับได้ทุก format)

ผมแนะนำให้ใช้ Python เพราะ handle format ซับซ้อนได้ดีกว่า สร้าง `scripts/split_prompts.py`:

```python
"""
split_prompts.py — แตก App_promt_AI_USE.md เป็น 65 ไฟล์
รองรับหลาย heading format:
  - ## 📄 Module 0.1: `money`
  - ### 🎯 ตัวอย่างเต็ม: Module `order`
  - ## 📄 Module 1.3–1.8: `user`, `employee`, ...
"""
import re
from pathlib import Path

SRC = Path(r"C:\github\fastapi-clean-architecture-ddd-erp-iot\docs\DOCS_APP\App_promt_AI_USE.md")
OUT = Path(r"C:\github\fastapi-clean-architecture-ddd-erp-iot\fastapi-backend\docs\prompts")

LAYER_FOLDER = {
    0: "layer-0-core",
    1: "layer-1-foundation",
    2: "layer-2-money-path",
    3: "layer-3-goods-path",
    4: "layer-4-operations",
    5: "layer-5-intelligence",
    6: "layer-6-monitoring",
    7: "layer-7-templates",
}

# ─── Manual mapping: module → (layer, filename) ─────
# ใช้เป็น fallback ถ้า parse จาก heading ไม่ได้
MODULE_MAP: dict[str, int] = {
    # Layer 0
    "money": 0, "tenant_context": 0, "audit": 0, "idempotency": 0, "config": 0, "events": 0,
    # Layer 1
    "tenancy": 1, "authentication": 1, "user": 1, "employee": 1,
    "customer": 1, "supplier": 1, "product": 1, "pricing": 1,
    # Layer 2
    "order": 2, "invoice": 2, "ledger": 2, "payment": 2,
    "accounting_gateway": 2, "tax": 2, "reconciliation": 2,
    # Layer 3
    "inventory": 3, "warehouse": 3, "lot": 3, "production": 3, "recipe": 3,
    "quality": 3, "waste": 3, "procurement": 3, "traceability": 3,
    "agriculture": 3, "crop": 3, "soil": 3, "irrigation": 3,
    # Layer 4
    "transport": 4, "delivery": 4, "route": 4, "gps": 4, "retail": 4,
    "pos": 4, "shift": 4, "line_channel": 4, "promotion": 4, "loyalty": 4,
    "crm": 4, "campaign": 4, "support": 4,
    # Layer 5
    "reporting": 5, "analytics": 5, "forecast": 5, "kpi": 5,
    "satisfaction": 5, "recommendation": 5, "oee": 5,
    # Layer 6
    "iot": 6, "cctv": 6, "monitoring": 6, "backup": 6,
    "alerting": 6, "audit_viewer": 6, "maintenance": 6, "energy": 6,
    # Layer 7
    "health": 7, "example": 7, "blank": 7,
}


def extract_module_names(title: str) -> list[str]:
    """Extract module names from heading title."""
    names = re.findall(r"`([a-z_]+)`", title)
    return [n for n in names if n in MODULE_MAP]


def main() -> None:
    if not SRC.exists():
        print(f"❌ File not found: {SRC}")
        return

    text = SRC.read_text(encoding="utf-8")
    print(f"📖 Read: {SRC.name} ({len(text):,} chars)\n")

    # ─── หา Layer headings ───────────────────────────
    layer_re = re.compile(
        r"^#\s+📋\s+Layer\s+(\d+):\s+([A-Z\s&]+)—",
        re.MULTILINE,
    )
    layers = list(layer_re.finditer(text))
    print(f"🔍 Found {len(layers)} layer sections\n")

    # ─── หา Module headings ทุกแบบ ──────────────────
    module_re = re.compile(
        r"^#{2,3}\s+(?:"
        r"📄\s+Module\s+[\d.]+(?:–[\d.]+)?:\s*"    # ## 📄 Module X.Y:
        r"|🎯\s+ตัวอย่างเต็ม:\s+Module\s+"           # ### 🎯 ตัวอย่างเต็ม: Module
        r")(.+?)$",
        re.MULTILINE,
    )

    # รวมทุก heading (layer + module) แล้ว sort ตาม position
    all_headings = sorted(
        [(m.start(), "layer", i, m) for i, m in enumerate(layers)] +
        [(m.start(), "module", 0, m) for m in module_re.finditer(text)],
        key=lambda x: x[0],
    )

    # ─── Stats ───────────────────────────────────────
    total_created = 0
    total_skipped = 0
    total_empty = 0
    layer_counts: dict[int, int] = {}

    # ─── วน loop ────────────────────────────────────
    for idx, (pos, kind, layer_idx, match) in enumerate(all_headings):
        if kind != "module":
            continue

        # หา layer ปัจจุบัน (layer heading ล่าสุดก่อน module นี้)
        current_layer = None
        for prev_pos, prev_kind, prev_idx, prev_match in reversed(all_headings[:idx]):
            if prev_kind == "layer":
                current_layer = int(prev_match.group(1))
                break

        if current_layer is None:
            continue

        # ─── ขอบเขตของ module ────────────────────────
        mod_start = match.start()
        mod_end = None
        for next_pos, next_kind, _, _ in all_headings[idx + 1:]:
            # หยุดที่ module ถัดไป หรือ layer ถัดไป
            if next_kind in ("module", "layer"):
                mod_end = next_pos
                break
        if mod_end is None:
            mod_end = len(text)

        content = text[mod_start:mod_end].strip()
        title = match.group(1)

        # ─── Extract module names ────────────────────
        names = extract_module_names(title)

        # Fallback: ถ้าไม่มี backticks ให้ parse จาก title ตรงๆ
        if not names:
            m = re.match(r"`?([a-z_]+)`?", title.strip())
            if m and m.group(1) in MODULE_MAP:
                names = [m.group(1)]

        if not names:
            print(f"   ⚠️  No module name in: {title[:60]}")
            continue

        # ─── เขียนไฟล์ ──────────────────────────────
        folder = OUT / LAYER_FOLDER[current_layer]
        folder.mkdir(parents=True, exist_ok=True)
        layer_counts[current_layer] = layer_counts.get(current_layer, 0) + len(names)

        for name in names:
            # ถ้ามีหลาย name ให้เพิ่ม header "## Module `name`" แยก
            if len(names) > 1:
                module_content = f"## 📄 Module `{name}`\n\n{content}\n"
            else:
                module_content = content + "\n"

            file_path = folder / f"{name}.md"

            # Skip ถ้ามีไฟล์เดิม + มีเนื้อหา
            if file_path.exists() and file_path.stat().st_size > 100:
                print(f"   ⏭️  Layer {current_layer} | {name}.md (skip, exists)")
                total_skipped += 1
                continue

            file_path.write_text(module_content, encoding="utf-8")
            print(f"   ✅ Layer {current_layer} | {name}.md ({len(module_content):,} chars)")
            total_created += 1

    # ─── สรุป ────────────────────────────────────────
    print()
    print("=" * 65)
    print(f"🎉 DONE!")
    print(f"   ✅ Created : {total_created}")
    print(f"   ⏭️  Skipped : {total_skipped}")
    print()
    print("📊 Files per layer:")
    for layer_num in sorted(layer_counts):
        expected = {0: 6, 1: 8, 2: 7, 3: 13, 4: 13, 5: 7, 6: 8, 7: 3}[layer_num]
        got = layer_counts[layer_num]
        status = "✅" if got == expected else f"⚠️  (expected {expected})"
        print(f"   Layer {layer_num} ({LAYER_FOLDER[layer_num]}): {got} {status}")
    print("=" * 65)


if __name__ == "__main__":
    main()
```

---

## 🚀 วิธีรัน (และตรวจสอบก่อน)

### 1. ลบไฟล์เปล่าที่สร้างไว้ก่อน (สำคัญ!)

เพราะ script จะ `skip` ไฟล์ที่มีอยู่แล้ว:

```powershell
cd C:\github\fastapi-clean-architecture-ddd-erp-iot\fastapi-backend
# ลบโฟลเดอร์ prompts เก่า
Remove-Item -Recurse -Force docs\prompts
```

### 2. รัน Python script

```powershell
cd C:\github\fastapi-clean-architecture-ddd-erp-iot\fastapi-backend
python scripts\split_prompts.py
```

### 3. หรือถ้ายังอยากใช้ PowerShell — แก้ regex แบบเร็ว

เปิด `split-prompts.ps1` แก้บรรทัดนี้:

```powershell
# เดิม (ใช้ไม่ได้กับ Layer 2+)
$modulePattern = '(?m)^##\s+📄\s+Module\s+[\d.]+(?:–[\d.]+)?:\s+(.+)$'

# ใหม่ (รองรับหลาย format)
$modulePattern = '(?m)^#{2,3}\s+(?:📄\s+Module\s+[\d.]+(?:–[\d.]+)?:\s+|🎯\s+ตัวอย่างเต็ม:\s+Module\s+)(.+)$'
```

---

## 📋 Expected Output (หลังรันถูกต้อง)

```
📖 Read: App_promt_AI_USE.md (xxx,xxx chars)

🔍 Found 8 layer sections

   ✅ Layer 0 | money.md (... chars)
   ✅ Layer 0 | tenant_context.md (...)
   ✅ Layer 0 | audit.md (...)
   ... (Layer 0 รวม 6)

   ✅ Layer 1 | tenancy.md (...)
   ✅ Layer 1 | authentication.md (...)
   ... (Layer 1 รวม 8)

   ✅ Layer 2 | order.md (...)
   ✅ Layer 2 | invoice.md (...)
   ... (Layer 2 รวม 7)

   ... (Layer 3-7)

=================================================
🎉 DONE!
   ✅ Created : 65
   ⏭️  Skipped : 0

📊 Files per layer:
   Layer 0 (layer-0-core): 6 ✅
   Layer 1 (layer-1-foundation): 8 ✅
   Layer 2 (layer-2-money-path): 7 ✅
   Layer 3 (layer-3-goods-path): 13 ✅
   Layer 4 (layer-4-operations): 13 ✅
   Layer 5 (layer-5-intelligence): 7 ✅
   Layer 6 (layer-6-monitoring): 8 ✅
   Layer 7 (layer-7-templates): 3 ✅
=================================================
```

---

## 🎯 สรุปสิ่งที่ต้องทำ

| ลำดับ | ขั้นตอน | คำสั่ง |
|---|---|---|
| 1 | ลบโฟลเดอร์ prompts เก่า | `Remove-Item -Recurse -Force docs\prompts` |
| 2 | สร้างไฟล์ `scripts/split_prompts.py` | copy code ด้านบน |
| 3 | รัน script | `python scripts\split_prompts.py` |
| 4 | ตรวจสอบ | `(Get-ChildItem -Recurse -Filter *.md).Count` → ควรได้ **65** |

---

ต้องการให้ผมช่วย:

1. **🐍 ปรับ Python script** ให้ handle กรณีอื่นๆ อีกไหม (เช่น dedupe, backup, log)
2. **🔍 Debug format จริง** — paste heading ที่เหลือจาก Layer 3-7 มาให้ดู
3. **📦 สร้าง ZIP** หลังแตกเสร็จ
4. **✅ เขียน validator** ตรวจว่าไฟล์ครบ 65 + มีเนื้อหาจริง (ไม่ใช่ 0 bytes)