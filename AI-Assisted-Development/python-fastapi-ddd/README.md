# python-fastapi-ddd-skill

ชุดรวม [Agent Skills](https://agentskills.io/) สำหรับออกแบบแบ็กเอนด์ **FastAPI** ใน Python โดยใช้รูปแบบ **Domain-Driven Design (DDD)** และ **Onion Architecture**

skill นี้สร้างจาก reference implementation:

- `dddpy`: https://github.com/iktakahiro/dddpy

## Skills

| Skill | คำอธิบาย |
| ----- | ----------- |
| `python-fastapi-ddd-skill` | สถาปัตยกรรม + รูปแบบ DDD หลัก (Entities, Value Objects, Repositories, UseCases) |
| `python-fastapi-ddd-presentation-skill` | FastAPI handlers, Pydantic schemas, การ map error |
| `python-fastapi-ddd-testing-skill` | รูปแบบ pytest สำหรับเลเยอร์ Domain / UseCase |
| `python-fastapi-ddd-tooling-skill` | เทมเพลต uv / ruff / mypy / pytest / CI |

## การติดตั้ง

### Claude Code (แนะนำ)

ลงทะเบียนที่เก็บนี้เป็น plugin marketplace แล้วติดตั้ง:

```bash
# 1. ลงทะเบียน marketplace
/plugin marketplace add iktakahiro/python-fastapi-ddd-skill

# 2. ติดตั้ง skill ทั้งหมดในครั้งเดียว
/plugin install python-fastapi-ddd@python-fastapi-ddd-skills
```

หรือเรียกดูและติดตั้งแบบอินเทอร์แอกทีฟ:

```bash
/plugin
# → "Browse and install plugins"
# → "python-fastapi-ddd-skills"
# → "python-fastapi-ddd"
# → "Install now"
```

### OpenAI Codex

#### ผ่าน skill installer

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo iktakahiro/python-fastapi-ddd-skill \
  --path skills/python-fastapi-ddd-skill
```

ติดตั้ง skill อื่น ๆ โดยเปลี่ยน `--path` เป็นหนึ่งใน:

- `skills/python-fastapi-ddd-presentation-skill`
- `skills/python-fastapi-ddd-testing-skill`
- `skills/python-fastapi-ddd-tooling-skill`

จากนั้นรีสตาร์ท Codex เพื่อให้ระบบรับรู้ skill ใหม่

#### ติดตั้งเอง (คัดลอกโฟลเดอร์)

```bash
dest="${CODEX_HOME:-$HOME/.codex}/skills"
mkdir -p "$dest"
cp -R skills/python-fastapi-ddd-skill "$dest/"
```

คุณยังสามารถคัดลอกหนึ่งใน:

- `skills/python-fastapi-ddd-presentation-skill`
- `skills/python-fastapi-ddd-testing-skill`
- `skills/python-fastapi-ddd-tooling-skill`

จากนั้นรีสตาร์ท Codex เพื่อให้ระบบรับรู้ skill ใหม่

## การใช้งาน

เมื่อติดตั้งแล้ว ให้กล่าวถึง skill ในพรอมป์ของคุณ:

> ออกแบบบริการ FastAPI + SQLAlchemy ด้วย DDD และ Onion Architecture

> Implement FastAPI handlers/schemas ที่เรียก UseCases และ map Domain error ไปเป็น HTTP response

> เพิ่ม pytest unit test สำหรับ Value Objects และ UseCases (mock repository interface)

> ตั้งค่า uv + Makefile + ruff/mypy/pytest + GitHub Actions CI สำหรับโปรเจกต์นี้

## สัญญาอนุญาต

Apache-2.0