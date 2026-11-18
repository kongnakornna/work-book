# เล่ม 12: วิชาชีพ กฎหมาย จริยธรรม ภาคผนวก และแหล่งเรียนรู้

## คำนำ

หนังสือเล่มนี้เป็นคู่มือภาคปฏิบัติสำหรับนักพัฒนา Python ที่ต้องการประสบความสำเร็จในอาชีพการงาน ตั้งแต่การทำงานเป็นทีม การเตรียมตัวสัมภาษณ์ ไปจนถึงการเป็นส่วนหนึ่งของชุมชนโอเพนซอร์ส รวมถึงการเข้าใจประเด็นทางกฎหมาย จริยธรรม และความยั่งยืนในโลกเทคโนโลยี นอกจากนี้ยังมีภาคผนวกที่รวบรวมแหล่งเรียนรู้ แผนการเรียนรู้ และแนวปฏิบัติที่ดีที่สุดสำหรับการพัฒนาตนเองอย่างต่อเนื่อง

---

## ภาค 26: การทำงานจริง การสัมภาษณ์ และชุมชน

### 26.1 การทำงานเป็นทีม

การทำงานเป็นทีมในโครงการ Python สมัยใหม่ต้องอาศัยทั้งทักษะทางเทคนิคและทักษะการสื่อสาร โดยเฉพาะในทีมที่ใช้กระบวนการ Agile

**หลักการสำคัญ**:
- **การสื่อสารที่ชัดเจน**: ใช้ Pull Request descriptions ที่อธิบายเหตุผล ไม่ใช่แค่สิ่งที่เปลี่ยน
- **Code Review ที่สร้างสรรค์**: มุ่งเน้นที่คุณภาพโค้ด ไม่ใช่ตัวบุคคล
- **เอกสารประกอบ**: เขียน README, ADR และ docstrings ให้เพื่อนร่วมทีมเข้าใจได้ง่าย

```python
def calculate_discount(price: float, customer_tier: str) -> float:
    """
    คำนวณส่วนลดตามระดับลูกค้า

    Args:
        price: ราคาสินค้าก่อนหักส่วนลด
        customer_tier: ระดับลูกค้า (bronze, silver, gold, platinum)

    Returns:
        ราคาหลังหักส่วนลด

    Raises:
        ValueError: ถ้าระดับลูกค้าไม่ถูกต้อง

    Examples:
        >>> calculate_discount(1000, "gold")
        850.0
        >>> calculate_discount(1000, "platinum")
        800.0
    """
    discount_rates = {
        "bronze": 0.0,
        "silver": 0.05,
        "gold": 0.15,
        "platinum": 0.20,
    }
    if customer_tier not in discount_rates:
        raise ValueError(f"Unknown tier: {customer_tier}")
    return price * (1 - discount_rates[customer_tier])
```

**อ้างอิง**: [Hands-On Software Engineering with Python](https://www.oreilly.com) 

---

### 26.2 Agile

Agile คือชุดแนวปฏิบัติที่เน้นการส่งมอบคุณค่าให้ลูกค้าอย่างรวดเร็วและต่อเนื่อง

**หลักการ Agile Manifesto**:
1. บุคคลและปฏิสัมพันธ์ สำคัญกว่ากระบวนการและเครื่องมือ
2. ซอฟต์แวร์ที่ทำงานได้ สำคัญกว่าเอกสารที่ครบถ้วน
3. การร่วมมือกับลูกค้า สำคัญกว่าการเจรจาสัญญา
4. การตอบสนองต่อการเปลี่ยนแปลง สำคัญกว่าการทำตามแผน

**การประยุกต์ใช้กับ Python**:
- Sprint cycles 1-4 สัปดาห์
- ใช้ Scrum roles: Product Owner, Scrum Master, Development Team
- Kanban สำหรับ visualizing workflow

```python
# ตัวอย่าง: Automating Kanban Board Updates
from trello import TrelloClient

client = TrelloClient(api_key='your_api_key', token='your_token')
board = client.get_board('board_id')
lists = board.list_lists()

# ย้าย card จาก "In Progress" ไป "Done"
for card in lists[1].list_cards():
    card.change_list(lists[2].id)
```

**อ้างอิง**: [Ultimate Guide for Freelance Python Developers – MoldStud](https://moldstud.com) 

---

### 26.3 Scrum

Scrum เป็น Agile framework ที่นิยมที่สุดในองค์กรซอฟต์แวร์

**Scrum Events**:
| Event | ระยะเวลา | จุดประสงค์ |
|-------|----------|-----------|
| Sprint Planning | 2-4 ชม. | วางแผนงานใน Sprint |
| Daily Standup | 15 นาที | Synchronize |
| Sprint Review | 1-2 ชม. | Demo ให้ stakeholders |
| Sprint Retrospective | 1-1.5 ชม. | ปรับปรุงกระบวนการ |

**Scrum Artifacts**:
- Product Backlog
- Sprint Backlog
- Increment

**อ้างอิง**: [Python for Agile Teams – Medium](https://medium.com) 

---

### 26.4 Kanban

Kanban เป็นวิธีการจัดการงานแบบ visual ที่เน้นการไหลของงาน (flow) และการจำกัดงานที่ทำพร้อมกัน (WIP limits)

**หลักการ Kanban**:
1. Visualize the workflow
2. Limit Work in Progress (WIP)
3. Manage flow
4. Make policies explicit
5. Implement feedback loops
6. Improve collaboratively

**อ้างอิง**: [Kanban methodology – Atlassian](https://www.atlassian.com/agile/kanban) 

---

### 26.5 Git Workflow

Git Workflow คือชุดแนวปฏิบัติในการใช้ Git สำหรับทีม

**Trunk-Based Development**:
```bash
# Feature branch สั้นๆ
git checkout -b feature/add-auth
# ... แก้ไขโค้ด ...
git commit -m "feat: add JWT authentication"
git push origin feature/add-auth
# สร้าง PR แล้ว merge เข้า main
```

**Git Flow**:
```bash
# Branches: main, develop, feature/*, release/*, hotfix/*
git checkout develop
git checkout -b feature/user-profile
# ...
git checkout develop
git merge feature/user-profile
git checkout -b release/1.0.0
# ...
git checkout main
git merge release/1.0.0
git tag -a v1.0.0 -m "Release 1.0.0"
```

**Conventional Commits**:
```
feat: add user authentication
fix: resolve null pointer in payment service
docs: update API documentation
style: format code with black
refactor: extract validation logic
test: add unit tests for user model
chore: update dependencies
```

**อ้างอิง**: [Conventional Commits](https://www.conventionalcommits.org/) 

---

### 26.6 Code Review

Code Review คือกระบวนการตรวจสอบโค้ดโดยเพื่อนร่วมทีม

**Best Practices**:
- Review PR ขนาดเล็ก (< 400 บรรทัด)
- ใช้ automated checks (linters, tests) ก่อน review
- มุ่งเน้นที่ logic, security, performance
- ให้ feedback ที่ actionable และสร้างสรรค์

```python
# Review Checklist
"""
- [ ] Type hints ครบถ้วนหรือไม่?
- [ ] มี error handling ที่เหมาะสม?
- [ ] มี unit tests ครอบคลุม?
- [ ] ชื่อตัวแปร/ฟังก์ชันสื่อความหมาย?
- [ ] ใช้ f-strings แทน % หรือ .format()?
- [ ] ไม่มี mutable default arguments?
- [ ] Docstrings ครบถ้วน?
"""
```

**อ้างอิง**: [Python Code Review Best Practices – GitHub](https://github.com/bitrix24/b24-ai-starter) 

---

### 26.7 Pair Programming

Pair Programming คือการเขียนโค้ดเป็นคู่ โดยมี 2 roles:
- **Driver**: พิมพ์โค้ด
- **Navigator**: ตรวจสอบและคิดเชิงกลยุทธ์

**Best Practices**:
- สลับ roles ทุก 5-10 นาที
- ใช้ screen sharing ใน remote setting
- Driver เท่านั้นที่แตะ keyboard

```python
# ตัวอย่าง Session
"""
Navigator: "เราต้อง validate email ก่อนบันทึก"
Driver: เขียน code ตามที่ Navigator แนะนำ
Navigator: ตรวจสอบ boundary cases
"""
```

**อ้างอิง**: [Pair Programming in Online Computer Labs – University of Edinburgh](https://pairprogramming.ed.ac.uk) 

---

### 26.8 การเขียน Resume

Resume สำหรับ Python Developer ควรเน้นทักษะทางเทคนิคและผลลัพธ์ที่วัดได้

**โครงสร้าง Resume**:
```
JANE DOE
jane.doe@email.com | github.com/janedoe | linkedin.com/in/janedoe

SUMMARY
Python developer with 3 years of experience building web apps with Django and Flask.

SKILLS
Languages: Python, JavaScript, SQL
Frameworks: Django, FastAPI, Flask
Tools: Docker, Kubernetes, CI/CD

EXPERIENCE
Senior Python Developer | TechCorp | 2023-Present
- Built REST API serving 1M+ requests/day
- Reduced deployment time by 60% with CI/CD

PROJECTS
- E-commerce API (FastAPI, PostgreSQL, Redis)
- Real-time Chat (WebSocket, Django Channels)
```

**อ้างอิง**: [How to Create a Python Developer Resume – Entri Blog](https://entri.app) 

---

### 26.9 Portfolio

Portfolio คือแฟ้มสะสมผลงานที่แสดงทักษะและประสบการณ์

**สิ่งที่ควรมีใน Portfolio**:
- **GitHub Repositories**: โครงการที่มี README ชัดเจน, tests, CI/CD
- **Live Demos**: ลิงก์ไปยังแอปที่ deploy จริง
- **Technical Blog**: บทความที่แสดงความเข้าใจเชิงลึก
- **Open Source Contributions**: PRs ที่ merge แล้ว

**อ้างอิง**: [How to Create a Python Developer Resume – Entri Blog](https://entri.app) 

---

### 26.10 GitHub Profile

GitHub Profile คือหน้าต่างแรกที่ recruiter จะดู

**สิ่งที่ควรมี**:
- **Profile README**: แนะนำตัว, ทักษะ, โครงการเด่น
- **Pinned Repositories**: 3-6 โครงการที่ดีที่สุด
- **Contribution Graph**: แสดงความสม่ำเสมอ
- **Organized Repos**: มี description, topics, license

```markdown
# Hi, I'm Jane 👋

## 🔭 Currently working on
- Building a RAG chatbot with LangChain and FastAPI

## 🌱 Currently learning
- Rust and PyO3 for high-performance extensions

## 🛠 Tech Stack
Python • FastAPI • Django • PostgreSQL • Docker • AWS

## 📫 How to reach me
- LinkedIn: /in/janedoe
- Email: jane@example.com
```

**อ้างอิง**: [How to Create a Python Developer Resume – Entri Blog](https://entri.app) 

---

### 26.11 การสัมภาษณ์งาน Python

การสัมภาษณ์ Python Developer มีหลายรูปแบบ:
1. **Coding Interview**: แก้ปัญหา algorithms/data structures
2. **System Design**: ออกแบบระบบ
3. **Take-home Assignment**: โครงการขนาดเล็ก
4. **Behavioral Interview**: ประสบการณ์ทำงาน

**หัวข้อที่พบบ่อย**:
- Python internals (GIL, memory management, decorators)
- Data structures และ algorithms
- OOP และ design patterns
- Async programming
- Testing และ debugging

```python
# ตัวอย่าง Coding Question
"""
เขียนฟังก์ชันที่หา longest substring โดยไม่มีตัวอักษรซ้ำ
Input: "abcabcbb"
Output: 3 ("abc")
"""

def length_of_longest_substring(s: str) -> int:
    char_index = {}
    max_length = 0
    start = 0

    for i, char in enumerate(s):
        if char in char_index and char_index[char] >= start:
            start = char_index[char] + 1
        char_index[char] = i
        max_length = max(max_length, i - start + 1)

    return max_length
```

**อ้างอิง**: [Real-Time Python Interview Questions and Answers 2025](https://www.devopstraininginstitute.com) 

---

### 26.12 การสัมภาษณ์ System Design

System Design Interview ทดสอบความสามารถในการออกแบบระบบขนาดใหญ่

**หัวข้อที่พบบ่อย**:
- Design URL Shortener
- Design Chat Application
- Design Rate Limiter
- Design Notification Service
- Design Data Pipeline

**แนวทางการตอบ**:
1. Clarify requirements (functional/non-functional)
2. Estimate scale (users, requests/sec, storage)
3. High-level design
4. Deep dive into components
5. Discuss trade-offs

```python
# ตัวอย่าง: Rate Limiter Design
class TokenBucket:
    """Token bucket rate limiter"""
    def __init__(self, capacity: int, refill_rate: float):
        self.capacity = capacity
        self.tokens = capacity
        self.refill_rate = refill_rate
        self.last_refill = time.time()

    def allow_request(self) -> bool:
        now = time.time()
        elapsed = now - self.last_refill
        self.tokens = min(
            self.capacity,
            self.tokens + elapsed * self.refill_rate
        )
        self.last_refill = now

        if self.tokens >= 1:
            self.tokens -= 1
            return True
        return False
```

**อ้างอิง**: [Mastering System Design Interview 2025](https://www.oreilly.com) 

---

### 26.13 การสัมภาษณ์ Data Science

การสัมภาษณ์ Data Science ครอบคลุม:
- **Statistics**: hypothesis testing, probability
- **Machine Learning**: algorithms, evaluation metrics
- **Python**: pandas, numpy, scikit-learn
- **SQL**: joins, window functions
- **Case Study**: business problem solving

**อ้างอิง**: [Python Interview Questions 2025: AI-Powered Practice Guide for Data Scientists](https://medium.com) 

---

### 26.14 การสัมภาษณ์ DevOps

การสัมภาษณ์ DevOps ครอบคลุม:
- **Linux**: commands, troubleshooting
- **CI/CD**: pipeline design
- **Cloud**: AWS/Azure/GCP services
- **IaC**: Terraform, CloudFormation
- **Python Scripting**: automation

**อ้างอิง**: [Python Scripting for DevOps Interview Questions 2025](https://www.devopstraininginstitute.com) 

---

### 26.15 Open Source Contribution

การมีส่วนร่วมใน Open Source เป็นวิธีที่ดีที่สุดในการสร้างทักษะและเครือข่าย

**ขั้นตอน**:
1. **หาโครงการ**: ดู labels เช่น "good first issue", "help wanted"
2. **อ่าน Guidelines**: CONTRIBUTING.md, CODE_OF_CONDUCT.md
3. **Fork และ Setup**: Clone, สร้าง branch ใหม่
4. **แก้ไข**: เขียนโค้ดและ tests
5. **ส่ง PR**: อธิบายการเปลี่ยนแปลงอย่างชัดเจน

```bash
# ตัวอย่าง Workflow
git clone https://github.com/your-username/project.git
cd project
git checkout -b fix/issue-123
# ... แก้ไข ...
git commit -m "fix: resolve issue #123"
git push origin fix/issue-123
# สร้าง Pull Request บน GitHub
```

**อ้างอิง**: [How to Contribute to an Open Source Python Project – Educative](https://www.educative.io) 

---

### 26.16 ชุมชน Python

ชุมชน Python มีหลายแหล่งที่สามารถขอความช่วยเหลือและแบ่งปันความรู้:

| แหล่ง | คำอธิบาย |
|-------|----------|
| **Discourse** | discuss.python.org – ถามตอบอย่างเป็นทางการ |
| **Stack Overflow** | ถามปัญหาทางเทคนิค |
| **Real Python** | Tutorials และ community |
| **PyCoder's Weekly** | Newsletter รายสัปดาห์ |
| **Python Discord** | Discord server ขนาดใหญ่ |
| **r/learnpython** | Subreddit สำหรับผู้เริ่มต้น |

**อ้างอิง**: [Where to get help – Python Developer's Guide](https://devguide.python.org) 

---

### 26.17 แหล่งเรียนรู้

**แหล่งเรียนรู้ที่แนะนำ**:
- **Real Python**: บทความเชิงลึกและ video courses
- **Fluent Python** (Ramalho): หนังสือสำหรับ intermediate to advanced
- **Architecture Patterns with Python** (Percival & Gregory): ฟรีออนไลน์
- **Talk Python To Me**: Podcast สัมภาษณ์
- **Python Bytes**: ข่าวรายสัปดาห์

**อ้างอิง**: [Looking for Great Python Learning Resources – GitHub Community](https://github.com) 

---

### 26.18 หนังสือ

**หนังสือที่แนะนำ**:
| ชื่อ | ผู้แต่ง | ระดับ |
|------|---------|-------|
| Fluent Python | Luciano Ramalho | Intermediate-Advanced |
| Architecture Patterns with Python | Percival & Gregory | Advanced |
| Python Cookbook | David Beazley | Intermediate |
| Effective Python | Brett Slatkin | Intermediate |
| Clean Code in Python | Mariano Anaya | Intermediate |
| Hands-On Software Engineering with Python | Various | Intermediate |

**อ้างอิง**: [GitHub – python-education Reading List](https://github.com) 

---

### 26.19 คอร์สออนไลน์

**คอร์สที่แนะนำ**:
- **Python for Everybody** – University of Michigan (Coursera)
- **Introduction to Generative AI** – Google Cloud
- **Google Data Analytics** – Google (Coursera)
- **Foundations of Cybersecurity** – Google (Coursera)
- **Data Science & Generative AI Fundamentals** – IBM

**อ้างอิง**: [Learn From 2025's Most Popular Python Tutorials and Courses – Real Python](https://realpython.com) 

---

### 26.20 Blog และ Podcast

**Blog**:
- Real Python
- PyCoders Weekly
- Ned Batchelder's Blog
- Armin Ronacher's Blog

**Podcast**:
- Talk Python To Me
- Python Bytes
- Real Python Podcast
- Podcast.init (Data Engineering)

**อ้างอิง**: [GitHub – AIRONAXSolutions/python-education](https://github.com) 

---

### 26.21 การติดตามเทคโนโลยีใหม่

**วิธีติดตามเทคโนโลยี**:
- ติดตาม Python Enhancement Proposals (PEPs)
- อ่าน release notes ของ Python เวอร์ชันใหม่
- ติดตาม GitHub Trending
- เข้าร่วม conferences (PyCon, EuroPython)
- Subscribe newsletters (PyCoder's Weekly, Python Weekly)

**อ้างอิง**: [Following Python's development – Python Developer's Guide](https://devguide.python.org) 

---

### 26.22 การพัฒนาตนเองอย่างต่อเนื่อง

**แผนพัฒนาตนเอง**:
1. **รายวัน**: อ่านบทความ 15 นาที
2. **รายสัปดาห์**: เขียนโค้ด 2-3 ชม. ในโครงการส่วนตัว
3. **รายเดือน**: เขียน blog post 1 บทความ
4. **รายไตรมาส**: เรียนคอร์สใหม่ 1 คอร์ส
5. **รายปี**: เข้าร่วม conference 1 ครั้ง

---

## ภาค 35: ทักษะวิชาชีพและองค์กร

### 35.1 Agile

(ดูรายละเอียดในหัวข้อ 26.2)

---

### 35.2 Scrum

(ดูรายละเอียดในหัวข้อ 26.3)

---

### 35.3 Kanban

(ดูรายละเอียดในหัวข้อ 26.4)

---

### 35.4 Lean

Lean คือปรัชญาที่มุ่งลดความสูญเปล่า (waste) ในกระบวนการ

**7 Wastes ใน Software Development**:
1. **Partially Done Work**: งานที่ค้างอยู่
2. **Extra Features**: ฟีเจอร์ที่ไม่จำเป็น
3. **Relearning**: เรียนรู้สิ่งเดิมซ้ำ
4. **Handoffs**: การส่งต่องาน
5. **Delays**: การรอคอย
6. **Defects**: ข้อบกพร่อง
7. **Task Switching**: การสลับงาน

**อ้างอิง**: [Agile Software Development: The Complete Guide](https://www.amazon.co.uk) 

---

### 35.5 XP (Extreme Programming)

XP เน้น technical excellence และ engineering practices

**Core Practices**:
- TDD (Test-Driven Development)
- Pair Programming
- Continuous Integration
- Refactoring
- Small Releases
- Simple Design

**อ้างอิง**: [Choosing the right Agile framework – LinkedIn](https://www.linkedin.com) 

---

### 35.6 SAFe (Scaled Agile Framework)

SAFe เป็น framework สำหรับ scaling Agile ในองค์กรขนาดใหญ่

**Levels**:
1. **Team Level**: Agile Teams
2. **Program Level**: Agile Release Train (ART)
3. **Large Solution Level**: Solution Train
4. **Portfolio Level**: Strategic Themes

**อ้างอิง**: [Choosing the right Agile framework – LinkedIn](https://www.linkedin.com) 

---

### 35.7 LeSS (Large-Scale Scrum)

LeSS เป็น framework ที่ขยาย Scrum ให้เหมาะกับองค์กรขนาดใหญ่ โดยยังคงรักษาความเรียบง่าย

**หลักการ**:
- One Product Backlog
- One Product Owner
- Many Teams
- Sprint Review ร่วมกัน

**อ้างอิง**: [Agile Software Development: The Complete Guide](https://www.amazon.co.uk) 

---

### 35.8 User Story

User Story คือคำอธิบายความต้องการของผู้ใช้ในรูปแบบง่ายๆ

**รูปแบบมาตรฐาน**:
```
As a [role],
I want [goal],
So that [benefit].
```

**INVEST Criteria**:
- **I**ndependent: เป็นอิสระ
- **N**egotiable: เจรจาได้
- **V**aluable: มีคุณค่า
- **E**stimable: ประเมินได้
- **S**mall: ขนาดเล็ก
- **T**estable: ทดสอบได้

**อ้างอิง**: [Agile Planning, Estimation, and Metrics – Open Exam Prep](https://open-exam-prep.com) 

---

### 35.9 Acceptance Criteria

Acceptance Criteria คือเงื่อนไขที่ User Story ต้องผ่านจึงจะถือว่าเสร็จ

**รูปแบบ Gherkin**:
```gherkin
Feature: User Login
  Scenario: Successful login
    Given a registered user
    When they enter valid credentials
    Then they should be redirected to dashboard

  Scenario: Failed login
    Given a registered user
    When they enter invalid credentials
    Then they should see an error message
```

**อ้างอิง**: [User Stories: Managing User Stories in Scrum Framework – Udemy](https://www.udemy.com) 

---

### 35.10 Definition of Done

Definition of Done (DoD) คือรายการตรวจสอบที่ทีมตกลงกันว่างานต้องมีอะไรบ้างจึงจะถือว่าเสร็จ

**ตัวอย่าง DoD**:
- [ ] Code ผ่าน code review
- [ ] Unit tests ผ่าน coverage > 80%
- [ ] Integration tests ผ่าน
- [ ] Documentation อัปเดต
- [ ] Deployed to staging
- [ ] Product Owner ยอมรับ

**อ้างอิง**: [Agile Planning, Estimation, and Metrics – Open Exam Prep](https://open-exam-prep.com) 

---

### 35.11 Definition of Ready

Definition of Ready (DoR) คือรายการตรวจสอบที่ User Story ต้องมีก่อนเริ่มทำ

**ตัวอย่าง DoR**:
- [ ] User story ชัดเจน
- [ ] Acceptance criteria ครบถ้วน
- [ ] ประเมิน story points แล้ว
- [ ] Dependencies ระบุแล้ว
- [ ] Design/mockup พร้อม

**อ้างอิง**: [Agile Planning, Estimation, and Metrics – Open Exam Prep](https://open-exam-prep.com) 

---

### 35.12 Estimation

Estimation คือการประเมินขนาดของงาน

**เทคนิค**:
- **Story Points**: ใช้ Fibonacci sequence (1, 2, 3, 5, 8, 13, 21)
- **T-Shirt Sizing**: XS, S, M, L, XL
- **Planning Poker**: ทีมโหวตพร้อมกัน

**อ้างอิง**: [Agile Planning, Estimation, and Metrics – Open Exam Prep](https://open-exam-prep.com) 

---

### 35.13 Planning Poker

Planning Poker คือเทคนิคการประเมินแบบ consensus

**ขั้นตอน**:
1. Product Owner อ่าน User Story
2. ทีมถามคำถาม
3. ทีมเลือกไพ่ (Fibonacci)
4. เปิดไพ่พร้อมกัน
5. ถ้าต่างกันมาก ให้ discuss
6. ประเมินใหม่จน consensus

**อ้างอิง**: [User Stories: Managing User Stories in Scrum Framework – Udemy](https://www.udemy.com) 

---

### 35.14 Story Point

Story Point คือหน่วยวัดขนาดของงานแบบ relative

**ข้อควรระวัง**:
- ไม่ใช่เวลาจริง
- แต่ละทีมมี scale ของตัวเอง
- ใช้สำหรับ velocity tracking

---

### 35.15 Velocity

Velocity คือจำนวน Story Points ที่ทีมทำได้ต่อ Sprint

**การใช้งาน**:
- พยากรณ์ความสามารถใน Sprint ถัดไป
- วัด improvement ของทีม
- ไม่ควรใช้เปรียบเทียบระหว่างทีม

---

### 35.16 Burndown Chart

Burndown Chart แสดงจำนวนงานที่เหลืออยู่ตลอด Sprint

```
Points
  |
20|*
  |  *
15|    *
  |      *
10|        *
  |          *
 5|            *
  |              *
 0|________________
   Day 1 ... Day 10
```

**อ้างอิง**: [Agile Planning, Estimation, and Metrics – Open Exam Prep](https://open-exam-prep.com) 

---

### 35.17 Roadmap

Roadmap คือแผนระยะยาวที่แสดงทิศทางของผลิตภัณฑ์

**องค์ประกอบ**:
- **Now**: สิ่งที่ทำอยู่
- **Next**: สิ่งที่จะทำต่อไป
- **Later**: สิ่งที่วางแผนไว้

---

### 35.18 OKR

OKR (Objectives and Key Results) คือ framework ตั้งเป้าหมาย

**ตัวอย่าง**:
```
Objective: ปรับปรุง developer experience

Key Results:
- ลด build time จาก 10 นาที เหลือ 3 นาที
- เพิ่ม test coverage จาก 60% เป็น 85%
- ลด onboarding time จาก 2 สัปดาห์ เหลือ 3 วัน
```

**อ้างอิง**: [Information Systems and Transformation Management – University of Duisburg-Essen](https://tm.ris.uni-due.de) 

---

### 35.19 KPI

KPI (Key Performance Indicator) คือตัวชี้วัดผลงาน

**ตัวอย่าง KPI สำหรับ Developer**:
- Lines of code (ไม่แนะนำให้ใช้เดี่ยวๆ)
- Bug fix rate
- Code review turnaround time
- Deployment frequency
- Mean Time to Recovery (MTTR)

---

### 35.20 Metrics

**DORA Metrics**:
1. **Deployment Frequency**: บ่อยแค่ไหน
2. **Lead Time for Changes**: เร็วแค่ไหน
3. **Change Failure Rate**: ล้มเหลวกี่ %
4. **Time to Restore Service**: กู้คืนเร็วแค่ไหน

---

### 35.21 North Star Metric

North Star Metric คือตัวชี้วัดหลักที่สะท้อนคุณค่าที่ส่งมอบให้ลูกค้า

**ตัวอย่าง**:
- Spotify: Time spent listening
- Airbnb: Nights booked
- Slack: Messages sent

---

### 35.22 Product Discovery

Product Discovery คือกระบวนการค้นหาว่าจะสร้างอะไร

**เทคนิค**:
- **User Interviews**: สัมภาษณ์ผู้ใช้
- **Usability Testing**: ทดสอบกับผู้ใช้จริง
- **A/B Testing**: เปรียบเทียบเวอร์ชัน
- **Prototyping**: สร้างต้นแบบ

**อ้างอิง**: [How to Create User Experience Documentation – ClickUp](https://clickup.com) 

---

### 35.23 User Research

User Research คือการทำความเข้าใจผู้ใช้

**Methods**:
- **Qualitative**: interviews, focus groups, usability tests
- **Quantitative**: surveys, analytics, A/B tests
- **Generative**: เปิดโอกาสค้นพบสิ่งใหม่
- **Evaluative**: ประเมิน solution ที่มีอยู่

**อ้างอิง**: [How to Create User Experience Documentation – ClickUp](https://clickup.com) 

---

### 35.24 Persona

Persona คือตัวแทนสมมติของผู้ใช้กลุ่มเป้าหมาย

**ตัวอย่าง Persona**:
```yaml
Name: "Developer Dave"
Age: 32
Role: Senior Backend Developer
Goals:
  - Write clean, maintainable code
  - Automate repetitive tasks
  - Learn new technologies
Pain Points:
  - Slow build times
  - Complex deployment process
  - Unclear requirements
Tech Stack:
  - Python, FastAPI, PostgreSQL
  - Docker, Kubernetes
  - AWS
```

**อ้างอิง**: [How to Create User Experience Documentation – ClickUp](https://clickup.com) 

---

### 35.25 Journey Map

Journey Map แสดงประสบการณ์ของผู้ใช้ตลอดการใช้งาน

**องค์ประกอบ**:
- **Stages**: ระยะของการใช้งาน
- **Actions**: สิ่งที่ผู้ใช้ทำ
- **Thoughts**: สิ่งที่ผู้ใช้คิด
- **Emotions**: ความรู้สึก
- **Pain Points**: จุดที่ติดขัด

**อ้างอิง**: [How to Create User Experience Documentation – ClickUp](https://clickup.com) 

---

### 35.26 UX/UI

UX (User Experience) และ UI (User Interface) เป็นสองด้านของการออกแบบ

| UX | UI |
|----|-----|
| เน้นประสบการณ์ | เน้นหน้าตา |
| Research, testing | Visual design |
| Information architecture | Color, typography |
| Wireframes, prototypes | Design systems |

**อ้างอิง**: [Foundations of UX – Musab Qureshi](https://www.thriftbooks.com) 

---

### 35.27 Wireframe

Wireframe คือภาพร่างโครงสร้างของหน้าจอ

```
+-----------------------------------+
|  LOGO        [Search]    [Profile]|
+-----------------------------------+
|                                   |
|  +-------------+  +-------------+ |
|  |   Card 1    |  |   Card 2    | |
|  |             |  |             | |
|  +-------------+  +-------------+ |
|                                   |
|  +-------------+  +-------------+ |
|  |   Card 3    |  |   Card 4    | |
|  +-------------+  +-------------+ |
|                                   |
+-----------------------------------+
```

**อ้างอิง**: [How to Create User Experience Documentation – ClickUp](https://clickup.com) 

---

### 35.28 Prototype

Prototype คือต้นแบบที่สามารถโต้ตอบได้

**ระดับของ Prototype**:
- **Low-fidelity**: Paper, sketches
- **Mid-fidelity**: Wireframes ที่คลิกได้
- **High-fidelity**: เหมือนจริง มี interaction

**อ้างอิง**: [How to Create User Experience Documentation – ClickUp](https://clickup.com) 

---

### 35.29 Design System

Design System คือชุดมาตรฐานสำหรับการออกแบบ

**องค์ประกอบ**:
- **Design Tokens**: Colors, typography, spacing
- **Components**: Buttons, forms, cards
- **Patterns**: Layouts, navigation
- **Guidelines**: Usage, accessibility

**อ้างอิง**: [How to Create User Experience Documentation – ClickUp](https://clickup.com) 

---

### 35.30 Accessibility

(ดูรายละเอียดในหัวข้อ 36.27)

---

### 35.31 Documentation

Documentation คือสิ่งสำคัญที่ทำให้โครงการประสบความสำเร็จ

**ประเภทของ Documentation**:
| ประเภท | จุดประสงค์ | ตัวอย่าง |
|--------|-----------|----------|
| **README** | แนะนำโครงการ | Overview, setup, usage |
| **API Docs** | อธิบาย API | OpenAPI, docstrings |
| **ADR** | บันทึกการตัดสินใจ | Architecture decisions |
| **Runbook** | ขั้นตอนการดำเนินการ | Deployment, troubleshooting |
| **Playbook** | แนวทางปฏิบัติ | Incident response |

**อ้างอิง**: [How to Create User Experience Documentation – ClickUp](https://clickup.com) 

---

### 35.32 Technical Writing

Technical Writing คือการเขียนเอกสารทางเทคนิค

**หลักการ**:
1. **รู้จักผู้อ่าน**: Developer, end user, หรือ stakeholder?
2. **ชัดเจน**: ใช้ภาษาง่าย หลีกเลี่ยง jargon
3. **มีโครงสร้าง**: ใช้ headings, lists, tables
4. **มีตัวอย่าง**: แสดงโค้ดที่รันได้
5. **อัปเดตเสมอ**: เอกสารเก่าแย่กว่าไม่มีเอกสาร

---

### 35.33 ADR

ADR (Architecture Decision Record) คือเอกสารบันทึกการตัดสินใจทางสถาปัตยกรรม

**รูปแบบ ADR**:
```markdown
# ADR-001: ใช้ FastAPI แทน Flask

## Status
Accepted

## Context
เราต้องการ framework ที่รองรับ async, type hints และ auto-documentation

## Decision
เลือกใช้ FastAPI

## Consequences
### Positive
- Async support
- Pydantic validation
- OpenAPI docs อัตโนมัติ

### Negative
- Ecosystem เล็กกว่า Flask
- ต้องเรียนรู้ Pydantic

## Alternatives Considered
- Flask: ไม่มี async
- Django: หนักเกินไป
```

**อ้างอิง**: [Software Architecture Decision Records](https://adr.github.io/) 

---

### 35.34 RFC

RFC (Request for Comments) คือเอกสารเสนอการเปลี่ยนแปลง

**โครงสร้าง RFC**:
1. **Title**: ชื่อเรื่อง
2. **Summary**: สรุปสั้นๆ
3. **Motivation**: ทำไมต้องเปลี่ยน
4. **Detailed Design**: ออกแบบอย่างไร
5. **Drawbacks**: ข้อเสีย
6. **Alternatives**: ทางเลือกอื่น

---

### 35.35 Runbook

Runbook คือคู่มือการดำเนินการสำหรับงานประจำ

**ตัวอย่าง Runbook**:
```markdown
# Deployment Runbook

## Pre-deployment
1. ตรวจสอบ CI/CD pipeline ผ่าน
2. ตรวจสอบ staging tests ผ่าน
3. แจ้งทีมใน Slack #deployments

## Deployment
1. รัน `kubectl apply -f deployment.yaml`
2. ตรวจสอบ pods: `kubectl get pods`
3. ตรวจสอบ logs: `kubectl logs -f deployment/api`

## Post-deployment
1. ตรวจสอบ metrics ใน Grafana
2. ตรวจสอบ error rate
3. อัปเดต deployment log
```

---

### 35.36 Playbook

Playbook คือชุดขั้นตอนสำหรับสถานการณ์ที่ซับซ้อน

**ตัวอย่าง Playbook**:
- Incident Response Playbook
- Security Breach Playbook
- Disaster Recovery Playbook

---

### 35.37 Code Review

(ดูรายละเอียดในหัวข้อ 26.6)

---

### 35.38 Pair Programming

(ดูรายละเอียดในหัวข้อ 26.7)

---

### 35.39 Mob Programming

Mob Programming คือการเขียนโค้ดทั้งทีมบนหน้าจอเดียว

**Roles**:
- **Driver**: พิมพ์โค้ด (หมุนเวียนทุก 10-15 นาที)
- **Navigator**: แนะนำทิศทาง
- **Observers**: ให้ feedback

**ประโยชน์**:
- Knowledge sharing
- ลด bus factor
- คุณภาพโค้ดสูงขึ้น

---

### 35.40 Mentoring

Mentoring คือการพัฒนานักพัฒนาคนอื่น

**Best Practices**:
- ตั้งเป้าหมายร่วมกัน
- พบปะสม่ำเสมอ (bi-weekly)
- ให้ feedback ที่ actionable
- เป็นแบบอย่างที่ดี

---

### 35.41 Team Topologies

Team Topologies เป็น framework สำหรับออกแบบโครงสร้างทีม

**4 Team Types**:
| ประเภท | หน้าที่ | ตัวอย่าง |
|--------|---------|----------|
| **Stream-aligned** | ส่งมอบคุณค่า end-to-end | Product team |
| **Platform** | สร้าง internal capability | DevOps platform |
| **Enabling** | ให้ความเชี่ยวชาญชั่วคราว | ML, Security |
| **Complicated-subsystem** | เชี่ยวชาญเฉพาะทาง | Payment infra |

**อ้างอิง**: [Team Topologies – Skelton/Pais](https://teamtopologies.com/) 

---

### 35.42 Conway's Law

Conway's Law กล่าวว่า "องค์กรจะออกแบบระบบที่สะท้อนโครงสร้างการสื่อสารของตัวเอง"

**นัยสำคัญ**:
- ถ้าต้องการ microservices ต้องมีทีมที่ autonomous
- ถ้าต้องการ monolithic ต้องมีทีมที่ coordinated
- โครงสร้างองค์กรมีผลโดยตรงต่อสถาปัตยกรรม

**อ้างอิง**: [Scaling Engineering Teams Without Growing Management](https://www.ai-infra-link.com) 

---

### 35.43 Platform Team

Platform Team สร้าง internal platform ที่ developer คนอื่นใช้

**หน้าที่**:
- สร้าง self-service tools
- จัดการ CI/CD pipelines
- ให้ observability
- ลด cognitive load ของ stream-aligned teams

---

### 35.44 Enabling Team

Enabling Team ให้ความเชี่ยวชาญชั่วคราวแก่ทีมอื่น

**ลักษณะ**:
- Temporary engagement
- Knowledge transfer
- ไม่ใช่ permanent dependency

---

### 35.45 Engineering Manager

Engineering Manager (EM) ดูแลทีมวิศวกร

**หน้าที่**:
- People management
- Career development
- Team health
- Delivery accountability

**อ้างอิง**: [Engineering Management and Tech Leads – kindatechnical()](https://kindatechnical.com) 

---

### 35.46 Tech Lead

Tech Lead เป็นทั้ง IC และผู้นำทางเทคนิค

**หน้าที่**:
- Technical direction
- Code quality
- Mentoring
- Architecture decisions

**อ้างอิง**: [Engineering Management and Tech Leads – kindatechnical()](https://kindatechnical.com) 

---

### 35.47 Staff Engineer

Staff Engineer เป็น IC ระดับสูงที่ impact กว้าง

**ลักษณะ**:
- Technical leadership
- Cross-team impact
- Mentoring
- Strategic thinking

**อ้างอิง**: [Scaling Engineering Teams Without Growing Management](https://www.ai-infra-link.com) 

---

### 35.48 Principal Engineer

Principal Engineer เป็น IC ระดับสูงสุด

**ลักษณะ**:
- Organization-wide impact
- Technical strategy
- Industry influence

---

### 35.49 Career Ladder

Career Ladder คือเส้นทางอาชีพ

**ตัวอย่าง Ladder**:
```
Junior → Mid → Senior → Staff → Principal
              ↘ Manager → Senior Manager → Director
```

---

### 35.50 Promotion

Promotion คือการเลื่อนตำแหน่ง

**สิ่งที่ต้องเตรียม**:
- Evidence of impact
- Peer feedback
- Documentation ของผลงาน
- Alignment กับ level expectations

---

### 35.51 Performance Review

Performance Review คือการประเมินผลงาน

**รูปแบบ**:
- Self-review
- Peer review
- Manager review
- Calibration

---

### 35.52 Feedback

Feedback ที่ดีควรเป็น:
- **Specific**: เจาะจง
- **Actionable**: นำไปปฏิบัติได้
- **Timely**: ทันเวลา
- **Constructive**: สร้างสรรค์

**SBI Model**:
- **S**ituation: สถานการณ์
- **B**ehavior: พฤติกรรม
- **I**mpact: ผลกระทบ

---

### 35.53 Remote Work

Remote Work ต้องการวินัยและการสื่อสารที่ดี

**Best Practices**:
- กำหนด working hours ชัดเจน
- ใช้ async communication
- มี video calls สำหรับ 1-on-1
- สร้าง documentation

---

### 35.54 Async Communication

Async Communication คือการสื่อสารที่ไม่ต้องตอบทันที

**เครื่องมือ**:
- Slack/Teams สำหรับ quick questions
- Email สำหรับ formal communication
- GitHub Issues/PRs สำหรับ technical discussions
- Notion/Confluence สำหรับ documentation

---

### 35.55 Time Management

Time Management สำหรับ Developer

**เทคนิค**:
- **Pomodoro**: 25 นาทีทำงาน 5 นาทีพัก
- **Time Blocking**: แบ่งเวลาเป็น blocks
- **Deep Work**: 2-4 ชม. ไม่มี interruption
- **Eisenhower Matrix**: จัดลำดับความสำคัญ

---

### 35.56 Freelance

Freelance Python Developer

**สิ่งที่ต้องเตรียม**:
- Portfolio
- Rate card
- Contract template
- Invoice system
- Tax compliance

**แหล่งงาน**:
- Upwork, Toptal
- Freelancer.com
- LinkedIn
- Referrals

**อ้างอิง**: [Ultimate Guide for Freelance Python Developers – MoldStud](https://moldstud.com) 

---

### 35.57 Consulting

Consulting ต้องการความเชี่ยวชาญเฉพาะทาง

**ประเภท**:
- Technical consulting
- Architecture review
- Training
- Troubleshooting

---

### 35.58 Entrepreneurship

Entrepreneurship สำหรับ Developer

**ขั้นตอน**:
1. หา problem ที่มีค่า
2. สร้าง MVP
3. หา first customers
4. Iterate
5. Scale

---

### 35.59 Startup

Startup คือบริษัทที่เน้นการเติบโตเร็ว

**บทบาทของ Developer ใน Startup**:
- Full-stack
- Wear many hats
- เร็ว  iterate ไว
- Equity compensation

---

### 35.60 Open Source

(ดูรายละเอียดในหัวข้อ 26.15)

---

### 35.61 Community

ชุมชน Python เป็นแหล่งสนับสนุนที่สำคัญ

**การมีส่วนร่วม**:
- เข้าร่วม meetups
- ตอบคำถามใน Stack Overflow
- เขียน blog
- พูดใน conference

---

### 35.62 Conference

Python Conferences ที่สำคัญ:
- **PyCon**: ทั่วโลก
- **EuroPython**: ยุโรป
- **PyCon APAC**: เอเชียแปซิฟิก
- **PyCon Thailand**: ประเทศไทย

---

### 35.63 Speaking

Speaking ที่ Conference

**ขั้นตอน**:
1. เขียน proposal
2. เตรียมสไลด์
3. ฝึกซ้อม
4. Present
5. Q&A

---

### 35.64 Writing

Writing สำหรับ Developer

**ประเภท**:
- Technical blog posts
- Tutorials
- Documentation
- Books

---

### 35.65 Teaching

Teaching เป็นวิธีที่ดีที่สุดในการเรียนรู้

**รูปแบบ**:
- เขียน tutorial
- ทำ video course
- สอนใน bootcamp
- Mentoring

---

### 35.66 Blogging

Blogging สำหรับ Developer

**แพลตฟอร์ม**:
- Dev.to
- Medium
- Hashnode
- Personal blog (Hugo, Jekyll)

---

### 35.67 YouTube

YouTube สำหรับ Developer

**ประเภท Content**:
- Coding tutorials
- Live coding
- Tech reviews
- Career advice

---

### 35.68 Podcast

Podcast สำหรับ Developer

**รูปแบบ**:
- Interview
- Solo
- Panel discussion
- News roundup

---

### 35.69 Newsletter

Newsletter สำหรับ Developer

**แพลตฟอร์ม**:
- Substack
- ConvertKit
- Buttondown
- Revue

---

## ภาค 36: กฎหมาย จริยธรรม และความยั่งยืน

### 36.1 MIT License

MIT License เป็น permissive license ที่อนุญาตให้ใช้ แก้ไข และแจกจ่ายได้อย่างอิสระ

**ข้อกำหนด**:
- ต้องแนบ copyright notice และ license text

```python
# ตัวอย่างการใช้งาน
# MIT License
# Copyright (c) 2026 Your Name
# Permission is hereby granted, free of charge...
```

**อ้างอิง**: [Open Source License Comparison – safeguard.sh](https://safeguard.sh) 

---

### 36.2 Apache License

Apache 2.0 เป็น permissive license ที่เพิ่ม patent grant

**ข้อกำหนด**:
- ต้องแนบ license text
- ต้องระบุการเปลี่ยนแปลง
- มี patent retaliation clause

**อ้างอิง**: [Open Source License Comparison – safeguard.sh](https://safeguard.sh) 

---

### 36.3 GPL

GPL (GNU General Public License) เป็น copyleft license ที่เข้มงวด

**ข้อกำหนด**:
- ต้องเปิด source code ของ derivative works
- ต้องใช้ license เดียวกัน
- ไม่สามารถผสมกับ proprietary code ได้

**อ้างอิง**: [Software licenses explained – DSRPT](https://dsrpt.com.au) 

---

### 36.4 LGPL

LGPL (Lesser GPL) เป็น weak copyleft ที่อนุญาตให้ link กับ proprietary code

**ข้อกำหนด**:
- การแก้ไข LGPL code ต้องเปิด source
- การ link ต้องทำแบบ dynamic

**อ้างอิง**: [Open Source License Comparison – safeguard.sh](https://safeguard.sh) 

---

### 36.5 AGPL

AGPL (Affero GPL) เหมือน GPL แต่ครอบคลุมการใช้งานบน server

**ข้อกำหนด**:
- ถ้ารันบน server ต้องเปิด source
- เหมาะกับ SaaS applications

**อ้างอิง**: [Software licenses explained – DSRPT](https://dsrpt.com.au) 

---

### 36.6 BSD

BSD License มี 2-clause และ 3-clause

**ข้อกำหนด**:
- ต้องแนบ copyright notice
- 3-clause ห้ามใช้ชื่อผู้พัฒนา endorse products

**อ้างอิง**: [Open Source License Comparison – safeguard.sh](https://safeguard.sh) 

---

### 36.7 MPL

MPL (Mozilla Public License) เป็น weak copyleft

**ข้อกำหนด**:
- ไฟล์ที่แก้ไขต้องเปิด source
- ไฟล์ใหม่สามารถเป็น proprietary ได้

**อ้างอิง**: [Open Source License Comparison – safeguard.sh](https://safeguard.sh) 

---

### 36.8 Copyright

Copyright คือสิทธิ์ exclusive ของผู้สร้าง

**ระยะเวลา**: ชีวิต + 70 ปี (ส่วนใหญ่)

**การใช้งานใน Software**:
- Source code ได้รับความคุ้มครองอัตโนมัติ
- ต้องมี copyright notice
- สามารถโอนสิทธิ์ได้

---

### 36.9 Patent

Patent คือสิทธิ์คุ้มครองสิ่งประดิษฐ์

**ใน Software**:
- Algorithm อาจจดสิทธิบัตรได้
- ต้องตรวจสอบ patent infringement
- Apache 2.0 มี patent grant

---

### 36.10 Trademark

Trademark คือเครื่องหมายการค้า

**ใน Software**:
- ชื่อผลิตภัณฑ์
- โลโก้
- ต้องจดทะเบียน

---

### 36.11 Trade Secret

Trade Secret คือความลับทางการค้า

**การป้องกัน**:
- NDAs
- Access control
- Employee agreements

---

### 36.12 GDPR

GDPR (General Data Protection Regulation) เป็นกฎหมายคุ้มครองข้อมูลของ EU

**หลักการสำคัญ**:
- Lawfulness, fairness, transparency
- Purpose limitation
- Data minimization
- Accuracy
- Storage limitation
- Integrity and confidentiality

**สิทธิ์ของเจ้าของข้อมูล**:
- Right to access
- Right to rectification
- Right to erasure
- Right to data portability

**อ้างอิง**: [Compliance Frameworks: 44 Standards in One Hub – QueDCo](https://www.linkedin.com) 

---

### 36.13 PDPA

PDPA (Personal Data Protection Act) เป็นกฎหมายคุ้มครองข้อมูลของไทย

**หลักการ**:
- ต้องขอ consent ก่อนเก็บข้อมูล
- ต้องแจ้งวัตถุประสงค์
- ต้องมีมาตรการรักษาความปลอดภัย

**อ้างอิง**: [Compliance Frameworks: 44 Standards in One Hub – QueDCo](https://www.linkedin.com) 

---

### 36.14 CCPA

CCPA (California Consumer Privacy Act) เป็นกฎหมายคุ้มครองข้อมูลของแคลิฟอร์เนีย

**สิทธิ์**:
- Right to know
- Right to delete
- Right to opt-out
- Right to non-discrimination

**อ้างอิง**: [Compliance Frameworks: 44 Standards in One Hub – QueDCo](https://www.linkedin.com) 

---

### 36.15 HIPAA

HIPAA (Health Insurance Portability and Accountability Act) เป็นกฎหมายคุ้มครองข้อมูลสุขภาพของสหรัฐ

**ข้อกำหนด**:
- Privacy Rule
- Security Rule
- Breach Notification Rule

**อ้างอิง**: [13 Cloud Security Compliance Standards SMBs Need to Know – CMIT Solutions](https://cmitsolutions.com) 

---

### 36.16 PCI DSS

PCI DSS (Payment Card Industry Data Security Standard) เป็นมาตรฐานความปลอดภัยสำหรับการชำระเงิน

**ข้อกำหนด 12 ข้อ**:
1. Firewall configuration
2. ไม่ใช้ default passwords
3. ปกป้อง stored cardholder data
4. เข้ารหัส transmission
5. Antivirus
6. Secure systems
7. Access control
8. Unique IDs
9. Physical access
10. Logging
11. Security testing
12. Security policy

**อ้างอิง**: [13 Cloud Security Compliance Standards SMBs Need to Know – CMIT Solutions](https://cmitsolutions.com) 

---

### 36.17 SOC 2

SOC 2 เป็นมาตรฐานการตรวจสอบสำหรับ service organizations

**Trust Services Criteria**:
- Security
- Availability
- Processing Integrity
- Confidentiality
- Privacy

**อ้างอิง**: [13 Cloud Security Compliance Standards SMBs Need to Know – CMIT Solutions](https://cmitsolutions.com) 

---

### 36.18 ISO 27001

ISO 27001 เป็นมาตรฐานระบบจัดการความปลอดภัยข้อมูล

**ข้อกำหนด**:
- ISMS (Information Security Management System)
- Risk assessment
- Continuous improvement

**อ้างอิง**: [13 Cloud Security Compliance Standards SMBs Need to Know – CMIT Solutions](https://cmitsolutions.com) 

---

### 36.19 ISO 27017

ISO 27017 เป็น extension ของ ISO 27001 สำหรับ cloud services

**เพิ่มเติม**:
- Cloud-specific controls
- Shared responsibility model
- Cloud customer guidance

**อ้างอิง**: [13 Cloud Security Compliance Standards SMBs Need to Know – CMIT Solutions](https://cmitsolutions.com) 

---

### 36.20 ISO 27018

ISO 27018 เป็น extension ของ ISO 27001 สำหรับการปกป้อง PII ใน public cloud

**เพิ่มเติม**:
- PII protection
- Consent management
- Transparency

**อ้างอิง**: [13 Cloud Security Compliance Standards SMBs Need to Know – CMIT Solutions](https://cmitsolutions.com) 

---

### 36.21 FedRAMP

FedRAMP (Federal Risk and Authorization Management Program) เป็นโปรแกรมของรัฐบาลสหรัฐสำหรับ cloud services

**ระดับ**:
- Low
- Moderate
- High

**อ้างอิง**: [13 Cloud Security Compliance Standards SMBs Need to Know – CMIT Solutions](https://cmitsolutions.com) 

---

### 36.22 AI Ethics

AI Ethics คือหลักจริยธรรมในการพัฒนาและใช้ AI

**หลักการสำคัญ**:
- Fairness
- Accountability
- Transparency
- Human-centered design

**อ้างอิง**: [Research Ethics of AI in Digital Transformation Era](https://accesson.kr) 

---

### 36.23 Bias

Bias ใน AI คืออคติที่เกิดจากข้อมูลหรือ algorithm

**ประเภท**:
- **Historical Bias**: ข้อมูลมีอคติอยู่แล้ว
- **Representation Bias**: ข้อมูลไม่เป็นตัวแทน
- **Measurement Bias**: วัดผลผิด
- **Evaluation Bias**: ประเมินผลผิด

**การแก้ไข**:
- ตรวจสอบข้อมูล
- ใช้ fairness metrics
- Diverse teams

**อ้างอิง**: [Promoting Ethical AI: Strategies for Mitigating Bias](https://www.semanticscholar.org) 

---

### 36.24 Fairness

Fairness ใน AI คือความเป็นธรรมของระบบ

**Metrics**:
- Demographic parity
- Equal opportunity
- Equalized odds
- Predictive parity

---

### 36.25 Transparency

Transparency คือความโปร่งใสของระบบ AI

**ระดับ**:
- Model transparency
- Data transparency
- Decision transparency

---

### 36.26 Accountability

Accountability คือความรับผิดชอบต่อผลลัพธ์ของ AI

**หลักการ**:
- ระบุผู้รับผิดชอบ
- มี audit trail
- มีกลไก redress

---

### 36.27 WCAG

WCAG (Web Content Accessibility Guidelines) เป็นมาตรฐานการเข้าถึงสำหรับเว็บ

**หลักการ POUR**:
- **Perceivable**: รับรู้ได้
- **Operable**: ใช้งานได้
- **Understandable**: เข้าใจได้
- **Robust**: ทนทาน

**ระดับ**: A, AA, AAA

**อ้างอิง**: [Accessibility Guidelines – Circuit design system](https://designsystem.dehn.de) 

---

### 36.28 ARIA

ARIA (Accessible Rich Internet Applications) เป็นชุด attributes สำหรับ accessibility

**ตัวอย่าง**:
```html
<button aria-label="Close dialog">×</button>
<nav aria-label="Main navigation">...</nav>
<div role="alert">Error message</div>
```

**อ้างอิง**: [Leveraging LLMs for Sustainable and Inclusive Web Accessibility – MDPI](https://www.mdpi.com) 

---

### 36.29 Screen Reader

Screen Reader เป็นโปรแกรมอ่านหน้าจอสำหรับผู้พิการทางสายตา

**Screen Readers ที่นิยม**:
- NVDA (ฟรี)
- JAWS (เสียค่าใช้จ่าย)
- VoiceOver (macOS)
- TalkBack (Android)

**การทดสอบ**:
- ใช้ semantic HTML
- ใส่ alt text
- ใช้ ARIA labels

**อ้างอิง**: [Accessibility Guidelines – Circuit design system](https://designsystem.dehn.de) 

---

### 36.30 Inclusive Design

Inclusive Design คือการออกแบบที่คำนึงถึงผู้ใช้ทุกกลุ่ม

**หลักการ**:
- เริ่มจากความหลากหลาย
- เปิดโอกาสให้เลือก
- ให้ flexibility
- ลดความซับซ้อน

**อ้างอิง**: [How to Create User Experience Documentation – ClickUp](https://clickup.com) 

---

### 36.31 Green Software

Green Software คือซอฟต์แวร์ที่ลดผลกระทบต่อสิ่งแวดล้อม

**หลักการ**:
- **Energy Efficiency**: ลดการใช้พลังงาน
- **Hardware Efficiency**: ใช้ hardware คุ้มค่า
- **Carbon Awareness**: ใช้พลังงานสะอาด

**อ้างอิง**: [Green Software Foundation – GHG Protocol](https://greensoftware.foundation) 

---

### 36.32 Carbon Aware

Carbon Aware Software ปรับการทำงานตามความเข้มข้นของคาร์บอน

**ตัวอย่าง**:
```python
def schedule_task(task, carbon_intensity):
    """เลื่อนงานไปเวลาที่คาร์บอนต่ำ"""
    if carbon_intensity > threshold:
        return schedule_for_later(task)
    return run_now(task)
```

**อ้างอิง**: [Green Software Foundation – GHG Protocol](https://greensoftware.foundation) 

---

### 36.33 Energy Efficiency

Energy Efficiency ใน Software

**เทคนิค**:
- ใช้ algorithm ที่มีประสิทธิภาพ
- ลด network calls
- ใช้ caching
- Optimize database queries

**อ้างอิง**: [From Code to Carbon: Being Energy Efficient While Coding](https://anguilla.dbs.ifi.lmu.de) 

---

### 36.34 Sustainability

Sustainability ใน Software Development

**แนวทาง**:
- เลือก hardware ที่ประหยัดพลังงาน
- ใช้ cloud ที่มี renewable energy
- ออกแบบ software ให้อายุยาว
- ลด e-waste

**อ้างอิง**: [Green Software Engineering – Pamilerin](https://eprints.umsida.ac.id) 

---

### 36.35 Digital Sovereignty

Digital Sovereignty คืออำนาจอธิปไตยทางดิจิทัล

**ประเด็น**:
- ควบคุมข้อมูลของตัวเอง
- ลดการพึ่งพาต่างประเทศ
- มีกฎหมายรองรับ

**อ้างอิง**: [AI, the Cloud and the Challenge of Data Sovereignty – TLA](https://www.tlaonline.ca) 

---

### 36.36 Data Residency

Data Residency คือที่ตั้งทางภูมิศาสตร์ของข้อมูล

**ข้อกำหนด**:
- ต้องเก็บข้อมูลในประเทศที่กำหนด
- ต้องมี data localization

**อ้างอิง**: [Omdia: Fragmented global regulatory approach to data sovereignty](https://omdia.tech.informa.com) 

---

### 36.37 Data Localization

Data Localization คือการบังคับให้เก็บข้อมูลในประเทศ

**ตัวอย่าง**:
- อินเดีย: ต้องเก็บ payment data ในประเทศ
- รัสเซีย: ต้องเก็บ personal data ในประเทศ
- จีน: ต้องเก็บ data ในประเทศ

**อ้างอิง**: [Omdia: Fragmented global regulatory approach to data sovereignty](https://omdia.tech.informa.com) 

---

### 36.38 Ethical Hacking

Ethical Hacking คือการทดสอบเจาะระบบอย่างถูกกฎหมาย

**หลักการ**:
- ได้รับอนุญาตเป็นลายลักษณ์อักษร
- กำหนดขอบเขตชัดเจน
- รายงานอย่างมีความรับผิดชอบ

**อ้างอิง**: [Responsible Disclosure & Bug Bounty – RackGenius](https://my.rackgenius.com) 

---

### 36.39 Responsible Disclosure

Responsible Disclosure คือการเปิดเผยช่องโหว่อย่างมีความรับผิดชอบ

**ขั้นตอน**:
1. ค้นพบช่องโหว่
2. รายงานผู้พัฒนาเป็นการส่วนตัว
3. ให้เวลาซ่อมแซม
4. เปิดเผยต่อสาธารณะหลังซ่อมแซม

**อ้างอิง**: [Responsible Disclosure & Bug Bounty – RackGenius](https://my.rackgenius.com) 

---

### 36.40 Bug Bounty

Bug Bounty Program ให้รางวัลผู้ค้นพบช่องโหว่

**ตัวอย่าง Program**:
- HackerOne
- Bugcrowd
- Synack

**อ้างอิง**: [CDN77 Bug Bounty Program](https://www.cdn77.com) 

---

### 36.41 Terms of Service

Terms of Service (ToS) คือข้อตกลงการใช้งาน

**องค์ประกอบ**:
- การยอมรับ
- สิทธิ์และหน้าที่
- ข้อจำกัดความรับผิด
- การระงับข้อพิพาท

---

### 36.42 Privacy Policy

Privacy Policy คือประกาศความเป็นส่วนตัว

**องค์ประกอบ**:
- ข้อมูลที่เก็บ
- วัตถุประสงค์
- การแบ่งปัน
- สิทธิ์ของผู้ใช้
- การรักษาความปลอดภัย

---

### 36.43 Cookie Consent

Cookie Consent คือการขอความยินยอมในการใช้ cookies

**ข้อกำหนด GDPR**:
- ต้องขอ consent ก่อน
- ต้องมี option ปฏิเสธ
- ต้องเก็บ record ของ consent

```html
<!-- Cookie Consent Banner -->
<div id="cookie-banner">
  <p>เราใช้ cookies เพื่อปรับปรุงประสบการณ์ของคุณ</p>
  <button onclick="acceptCookies()">ยอมรับ</button>
  <button onclick="rejectCookies()">ปฏิเสธ</button>
</div>
```

---

## ภาคผนวก

### A. คำสั่ง Python ที่ใช้บ่อย

```bash
# Environment
python -m venv venv              # สร้าง virtual environment
source venv/bin/activate         # เปิดใช้งาน (Linux/Mac)
venv\Scripts\activate            # เปิดใช้งาน (Windows)
pip install -r requirements.txt  # ติดตั้ง dependencies
pip freeze > requirements.txt    # บันทึก dependencies

# Testing
pytest                           # รัน tests
pytest --cov=src                 # รันพร้อม coverage
pytest -v                        # verbose output

# Code Quality
ruff check .                     # lint
ruff format .                    # format
mypy src/                        # type checking

# Package Management
pip install package_name         # ติดตั้ง package
pip install --upgrade package    # อัปเดต
pip uninstall package            # ถอนการติดตั้ง
```

**อ้างอิง**: [Real Python – Python Cheat Sheet](https://realpython.com)

---

### B. Built-in Functions

| Function | คำอธิบาย | ตัวอย่าง |
|----------|----------|----------|
| `abs()` | ค่าสัมบูรณ์ | `abs(-5)` → 5 |
| `all()` | True ถ้าทั้งหมดเป็น True | `all([True, True])` → True |
| `any()` | True ถ้ามีตัวใดตัวหนึ่งเป็น True | `any([False, True])` → True |
| `enumerate()` | วนซ้ำพร้อม index | `for i, v in enumerate(['a','b'])` |
| `filter()` | กรอง elements | `filter(lambda x: x>0, [-1,0,1])` |
| `map()` | แปลง elements | `map(str, [1,2,3])` |
| `sorted()` | เรียงลำดับ | `sorted([3,1,2])` |
| `zip()` | รวม iterables | `zip([1,2], ['a','b'])` |

**อ้างอิง**: [Python Built-in Functions](https://docs.python.org/3/library/functions.html)

---

### C. Standard Library ที่ควรรู้

| Module | คำอธิบาย |
|--------|----------|
| `os` | จัดการไฟล์และ directory |
| `sys` | ข้อมูลระบบ |
| `json` | จัดการ JSON |
| `re` | Regular expressions |
| `datetime` | วันที่และเวลา |
| `collections` | โครงสร้างข้อมูลเพิ่มเติม |
| `itertools` | Iterators |
| `functools` | Higher-order functions |
| `pathlib` | จัดการ path |
| `logging` | บันทึก log |

**อ้างอิง**: [Exploring Python's Standard Library: Hidden Gems](https://codesarray.com)

---

### D. Third-Party Library ยอดนิยม

| หมวด | Libraries |
|------|-----------|
| Web | FastAPI, Django, Flask |
| Data | pandas, numpy, polars |
| ML | scikit-learn, PyTorch, TensorFlow |
| Testing | pytest, hypothesis |
| Async | aiohttp, httpx |
| CLI | click, typer |
| Validation | pydantic |
| ORM | SQLAlchemy, Django ORM |

**อ้างอิง**: [Awesome Python](https://github.com/vinta/awesome-python)

---

### E. Cheat Sheet

```python
# List Comprehension
squares = [x**2 for x in range(10)]

# Dictionary Comprehension
word_lengths = {word: len(word) for word in words}

# f-strings
name = "World"
print(f"Hello, {name}!")

# Unpacking
first, *rest = [1, 2, 3, 4]

# Walrus Operator (Python 3.8+)
if (n := len(data)) > 10:
    print(f"Too many: {n}")

# Context Manager
with open("file.txt") as f:
    content = f.read()

# Decorator
@functools.lru_cache(maxsize=128)
def fibonacci(n):
    ...

# Type Hints
def greet(name: str) -> str:
    return f"Hello, {name}"
```

---

### F. แหล่งอ้างอิง

- [Python Official Documentation](https://docs.python.org/3/)
- [Real Python](https://realpython.com/)
- [Python Developer's Guide](https://devguide.python.org/)
- [PEP Index](https://peps.python.org/)
- [Awesome Python](https://github.com/vinta/awesome-python)
- [Full Stack Python](https://www.fullstackpython.com/)
- [PyCoder's Weekly](https://pycoders.com/)

---

### G. แผนการเรียนรู้ 30 วัน

| สัปดาห์ | หัวข้อ | เป้าหมาย |
|----------|-------|----------|
| 1 | พื้นฐาน Python | Syntax, data types, control flow |
| 2 | OOP และ Modules | Classes, inheritance, packages |
| 3 | การจัดการข้อมูล | File I/O, JSON, CSV, APIs |
| 4 | โครงการเล็ก | สร้าง CLI tool หรือ web scraper |

---

### H. แผนการเรียนรู้ 90 วัน

| เดือน | หัวข้อ | เป้าหมาย |
|-------|-------|----------|
| 1 | พื้นฐาน + OOP | เข้าใจ Python core |
| 2 | Web Development | FastAPI/Django, databases |
| 3 | Testing + Deployment | pytest, Docker, CI/CD |

---

### I. แผนการเรียนรู้ 1 ปี

| ไตรมาส | หัวข้อ | เป้าหมาย |
|---------|-------|----------|
| Q1 | Python Fundamentals | Solid foundation |
| Q2 | Web/API Development | สร้าง production API |
| Q3 | Data/ML | Data analysis, ML models |
| Q4 | Advanced + Specialization | Internals, performance, domain expertise |

---

### J. Roadmap สายงานต่าง ๆ

**Backend Developer**:
Python → FastAPI/Django → Databases → Docker → Kubernetes → System Design

**Data Scientist**:
Python → pandas/numpy → Statistics → scikit-learn → Deep Learning → MLOps

**DevOps Engineer**:
Python → Linux → CI/CD → Cloud → Terraform → Kubernetes → Observability

**ML Engineer**:
Python → ML → Deep Learning → MLOps → Model Serving → Feature Stores

---

### K. คำศัพท์ที่ควรรู้

| คำศัพท์ | ความหมาย |
|---------|----------|
| **GIL** | Global Interpreter Lock |
| **ORM** | Object-Relational Mapping |
| **CI/CD** | Continuous Integration/Continuous Deployment |
| **IaC** | Infrastructure as Code |
| **DDD** | Domain-Driven Design |
| **TDD** | Test-Driven Development |
| **SRE** | Site Reliability Engineering |
| **MTTR** | Mean Time to Recovery |

---

### L. ข้อผิดพลาดที่พบบ่อย

| ข้อผิดพลาด | วิธีแก้ไข |
|------------|----------|
| Mutable default arguments | ใช้ `None` เป็น default |
| ไม่จัดการ exceptions | ใช้ try/except |
| ไม่ใช้ type hints | ใส่ type hints |
| ไม่เขียน tests | เขียน unit tests |
| Hardcoded secrets | ใช้ environment variables |

```python
# ❌ ผิด
def add_item(item, items=[]):
    items.append(item)
    return items

# ✅ ถูก
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

---

### M. แนวทาง Debug

1. **อ่าน error message ให้ละเอียด**
2. **ใช้ `print()` หรือ `breakpoint()`**
3. **ใช้ debugger (pdb, VS Code)**
4. **ตรวจสอบ assumptions**
5. **เขียน test ที่ reproduce bug**
6. **ใช้ `git bisect` หา commit ที่ทำให้เกิด bug**

```python
import pdb

def buggy_function(x):
    result = x * 2
    pdb.set_trace()  # หยุดที่นี่
    return result + 1
```

---

### N. แนวทางเขียนโค้ดสะอาด

1. **ชื่อสื่อความหมาย**: `user_count` ไม่ใช่ `uc`
2. **ฟังก์ชันสั้น**: ทำสิ่งเดียว
3. **DRY**: Don't Repeat Yourself
4. **Comments อธิบาย "ทำไม" ไม่ใช่ "อะไร"**
5. **Consistent formatting**: ใช้ Black
6. **Type hints**: ช่วยให้เข้าใจและจับ bugs

```python
# ❌ ไม่ดี
def p(d):
    r = []
    for i in d:
        if i['a'] > 0:
            r.append(i)
    return r

# ✅ ดี
def filter_positive_items(items: list[dict]) -> list[dict]:
    """กรองเฉพาะ items ที่มีค่า a > 0"""
    return [item for item in items if item['a'] > 0]
```

---

### O. แนวทางออกแบบระบบ

1. **Understand requirements**: functional และ non-functional
2. **Estimate scale**: users, requests, storage
3. **Design high-level**: components, data flow
4. **Deep dive**: database, caching, messaging
5. **Consider trade-offs**: consistency vs availability
6. **Document decisions**: ADRs

---

### P. แนวทาง Deployment

1. **Containerize**: Docker
2. **Orchestrate**: Kubernetes
3. **Automate**: CI/CD pipelines
4. **Monitor**: Prometheus + Grafana
5. **Log**: ELK stack
6. **Trace**: OpenTelemetry

---

### Q. แนวทางความปลอดภัย

1. **Validate input**: Pydantic
2. **Parameterized queries**: ป้องกัน SQL injection
3. **Escape output**: ป้องกัน XSS
4. **Use HTTPS**: เข้ารหัสข้อมูล
5. **Hash passwords**: bcrypt/argon2
6. **Rotate secrets**: ใช้ secrets manager

---

### R. แนวทางประสิทธิภาพ

1. **Profile ก่อน optimize**: cProfile, py-spy
2. **ใช้ data structures ที่เหมาะสม**: dict, set
3. **Caching**: lru_cache, Redis
4. **Async I/O**: asyncio, aiohttp
5. **C extensions**: Numba, Cython
6. **Database optimization**: indexes, query tuning

---

### S. แนวทางทดสอบ

1. **Unit tests**: pytest
2. **Integration tests**: ทดสอบ components ร่วมกัน
3. **E2E tests**: ทดสอบทั้งระบบ
4. **Property-based**: Hypothesis
5. **Coverage**: ตั้งเป้า > 80%
6. **CI**: รัน tests ทุก PR

---

### T. แนวทางดูแลระบบระยะยาว

1. **Monitoring**: Prometheus, Grafana
2. **Alerting**: PagerDuty, Opsgenie
3. **Logging**: structured logging
4. **Tracing**: OpenTelemetry
5. **Documentation**: runbooks, ADRs
6. **Postmortems**: blameless

---

## ส่วนเพิ่มเติม

### AI Stack / Agentic AI

**AI Stack สำหรับ Python**:
```
Application Layer
    ↓
Agent Frameworks: LangChain, LlamaIndex, CrewAI
    ↓
LLM APIs: OpenAI, Anthropic, Google
    ↓
Vector Databases: Pinecone, Weaviate, Chroma
    ↓
Embedding Models: text-embedding-3
    ↓
Infrastructure: GPU, vLLM, TGI
```

**Agentic AI Patterns**:
- **ReAct**: Reasoning + Acting
- **Tool Use**: ใช้เครื่องมือ
- **Multi-Agent**: หลาย agents ร่วมมือ
- **Human-in-the-Loop**: มีมนุษย์ตรวจสอบ

---

### Courses You Must Explore

| # | Course | ผู้ให้ |
|---|--------|--------|
| 1 | Python for Everybody | University of Michigan |
| 2 | Introduction to Generative AI | Google Cloud |
| 3 | Generative Adversarial Networks | DeepLearning.AI |
| 4 | Introduction to AI | IBM |
| 5 | Google Data Analytics | Google |
| 6 | Google Project Management | Google |
| 7 | Google IT Support | Google |
| 8 | Foundations of Cybersecurity | Google |
| 9 | Google UX Design | Google |
| 10 | Data Science & Generative AI Fundamentals | IBM |
| 11 | Excel Skills for Business | Macquarie University |

---

## สรุป

หนังสือเล่ม 12 ครอบคลุมทักษะวิชาชีพ กฎหมาย จริยธรรม และแหล่งเรียนรู้อย่างครบถ้วน ตั้งแต่การทำงานเป็นทีม Agile/Scrum/Kanban การเตรียม Resume และ Portfolio การสัมภาษณ์งาน การมีส่วนร่วมใน Open Source ไปจนถึงประเด็นทางกฎหมาย GDPR/PDPA จริยธรรม AI Accessibility Green Software และ Digital Sovereignty พร้อมภาคผนวกที่รวบรวม cheat sheet แผนการเรียนรู้ และแนวปฏิบัติที่ดีที่สุดสำหรับการเป็นนักพัฒนา Python มืออาชีพ

**แหล่งอ้างอิงหลัก**:
- [Python Official Documentation](https://docs.python.org/3/)
- [Real Python](https://realpython.com/)
- [Python Developer's Guide](https://devguide.python.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Team Topologies](https://teamtopologies.com/)
- [Green Software Foundation](https://greensoftware.foundation/)
- [Open Source Guides](https://opensource.guide/)
- [OWASP](https://owasp.org/)
- [GDPR Official](https://gdpr-info.eu/)
- [WCAG Guidelines](https://www.w3.org/WAI/standards-guidelines/wcag/)
- [Awesome Python](https://github.com/vinta/awesome-python)
- [Python Built-in Functions](https://docs.python.org/3/library/functions.html)
- [PyCoder's Weekly](https://pycoders.com/)
- [Talk Python To Me](https://talkpython.fm/)