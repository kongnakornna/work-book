# เล่ม 7: Automation, Desktop, Mobile, Game, Multimedia, IoT, Robotics และ Embedded
## คู่มือการทำงานฉบับสมบูรณ์ พร้อมตัวอย่างการใช้งานจริง

---

## บทนำเล่ม

หนังสือเล่มนี้พาคุณออกจากโลกของ web/API/Data Science สู่โลกของ **ระบบอัตโนมัติ**, **แอปพลิเคชันเดสก์ท็อป**, **โมบายล์**, **เกม**, **มัลติมีเดีย** และ **IoT/Robotics/Embedded** เนื้อหาครอบคลุมสี่ภาคหลัก:

1. **การเขียนโปรแกรมอัตโนมัติและสคริปต์** — subprocess, scheduling, Excel/PDF/Email automation, RPA, Infrastructure automation
2. **การพัฒนาแอปพลิเคชันเดสก์ท็อป** — Tkinter, PyQt, Kivy, packaging
3. **การพัฒนาโมบายล์ เกม และมัลติมีเดีย** — Kivy, BeeWare, Pygame, Pillow, OpenCV, MoviePy
4. **IoT, Robotics, Embedded** — MicroPython, Raspberry Pi, MQTT, ROS, Edge Computing

ทุกหัวข้อมาพร้อม **ตัวอย่างโค้ดที่รันได้จริง**, **คำสั่ง setup** และ **แนวปฏิบัติจากอุตสาหกรรม**


## ภาค 15: การเขียนโปรแกรมอัตโนมัติและสคริปต์

### 15.1 Shell Scripting ด้วย Python

**คืออะไร:** การใช้ Python แทน bash/shell script สำหรับงาน automation ที่ซับซ้อน

**เปรียบเทียบ Python vs Bash:**

| งาน | Bash | Python |
|-----|------|--------|
| เรียกคำสั่ง | ✅ ง่าย | ✅ ผ่าน subprocess |
| จัดการ JSON | ❌ ต้อง jq | ✅ native |
| Error handling | ❌ จำกัด | ✅ try/except |
| Cross-platform | ❌ | ✅ |
| งานซับซ้อน | ❌ | ✅ |

**ตัวอย่าง script ตรวจสอบ disk space:**

```python
#!/usr/bin/env python3
"""ตรวจสอบ disk space และแจ้งเตือนถ้าเกิน threshold"""
import shutil
import sys
from pathlib import Path

THRESHOLD_PERCENT = 85

def check_disks(paths: list[str]) -> list[dict]:
    results = []
    for path in paths:
        usage = shutil.disk_usage(path)
        percent_used = (usage.used / usage.total) * 100
        results.append({
            "path": path,
            "total_gb": usage.total / (1024**3),
            "used_gb": usage.used / (1024**3),
            "free_gb": usage.free / (1024**3),
            "percent_used": percent_used,
            "critical": percent_used >= THRESHOLD_PERCENT,
        })
    return results

def main():
    disks = check_disks(["/", "/home", "/var"])
    critical = [d for d in disks if d["critical"]]

    for d in disks:
        status = "🔴 CRITICAL" if d["critical"] else "✅ OK"
        print(f"{status}  {d['path']}: {d['percent_used']:.1f}% used, {d['free_gb']:.1f}GB free")

    if critical:
        sys.exit(1)  # exit code 1 สำหรับ monitoring

if __name__ == "__main__":
    main()
```

**การตั้ง cron job:**

```bash
# crontab -e
# ทุก 15 นาที
*/15 * * * * /usr/bin/python3 /opt/scripts/check_disk.py >> /var/log/check_disk.log 2>&1
```

**อ้างอิง:** [Python subprocess](https://docs.python.org/3/library/subprocess.html)


### 15.5 subprocess

**คืออะไร:** Module สำหรับรัน external command และจัดการ input/output/error

**การใช้งานที่ปลอดภัย:**

```python
import subprocess
from pathlib import Path

# ✅ ปลอดภัย — ใช้ list ของ args (ไม่ shell=True)
result = subprocess.run(
    ["git", "status", "--short"],
    capture_output=True,
    text=True,
    timeout=30,
    check=False,
)
print(f"Return code: {result.returncode}")
print(f"Output:\n{result.stdout}")
if result.stderr:
    print(f"Errors:\n{result.stderr}")

# ✅ จัดการ error
def run_command(cmd: list[str], timeout: int = 30) -> str:
    try:
        result = subprocess.run(
            cmd, capture_output=True, text=True,
            timeout=timeout, check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"คำสั่งล้มเหลว ({e.returncode}): {e.stderr}") from e
    except subprocess.TimeoutExpired as e:
        raise TimeoutError(f"คำสั่งใช้เวลาเกิน {timeout}s") from e

# ✅ Pipe input
result = subprocess.run(
    ["grep", "error"],
    input="info\nwarning\nerror\ncritical\n",
    capture_output=True, text=True,
)
print(result.stdout)

# ✅ Real-time output
def stream_command(cmd: list[str]):
    proc = subprocess.Popen(
        cmd, stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT, text=True, bufsize=1,
    )
    for line in proc.stdout:
        print(line, end="")
    proc.wait()
    return proc.returncode

stream_command(["ping", "-c", "4", "google.com"])
```

**ข้อควรระวัง:**
- ❌ อย่าใช้ `shell=True` กับ input จากผู้ใช้ → command injection
- ❌ อย่าใช้ `os.system()` → ไม่มี error handling
- ✅ ใช้ `list` args + `capture_output=True` + `timeout`
- ✅ ใช้ `Path` แทน string concatenation

**อ้างอิง:** [subprocess Documentation](https://docs.python.org/3/library/subprocess.html)


### 15.6 Task Automation & 15.7 cron & 15.8 schedule

**ตัวอย่าง schedule library:**

```bash
pip install schedule
```

```python
import schedule
import time
import logging
from datetime import datetime

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

def backup_database():
    logging.info("เริ่ม backup database")
    # ... logic
    logging.info("backup เสร็จ")

def send_daily_report():
    logging.info("ส่งรายงานประจำวัน")

def check_health():
    logging.info("ตรวจสอบ health")

# ตั้งเวลา
schedule.every(10).minutes.do(check_health)
schedule.every().day.at("02:00").do(backup_database)
schedule.every().monday.at("08:00").do(send_daily_report)
schedule.every().hour.do(lambda: logging.info("tick"))

logging.info("เริ่ม scheduler...")
while True:
    schedule.run_pending()
    time.sleep(1)
```

**APScheduler สำหรับ production:**

```python
from apscheduler.schedulers.blocking import BlockingScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.jobstores.sqlalchemy import SQLAlchemyJobStore
import logging

logging.basicConfig(level=logging.INFO)

jobstores = {
    "default": SQLAlchemyJobStore(url="sqlite:///jobs.sqlite"),
}
scheduler = BlockingScheduler(jobstores=jobstores, timezone="Asia/Bangkok")

@scheduler.scheduled_job(CronTrigger(hour=2, minute=0), id="backup")
def backup():
    print("Backup running...")

scheduler.add_job(
    check_health, "interval", minutes=10,
    id="health", max_instances=1,
    misfire_grace_time=60,
)

try:
    scheduler.start()
except (KeyboardInterrupt, SystemExit):
    scheduler.shutdown()
```

**อ้างอิง:** [APScheduler](https://apscheduler.readthedocs.io/), [schedule](https://schedule.readthedocs.io/)


### 15.14–15.16 Excel Automation

**คืออะไร:** การอ่าน/เขียนไฟล์ Excel อัตโนมัติ

```bash
pip install openpyxl pandas xlsxwriter
```

**อ่าน Excel:**

```python
import pandas as pd
from openpyxl import load_workbook

# อ่านทุก sheet
xl = pd.ExcelFile("sales.xlsx")
print(xl.sheet_names)

df = pd.read_excel("sales.xlsx", sheet_name="Q1", skiprows=2, usecols="A:F")
print(df.head())
```

**เขียน Excel พร้อม format:**

```python
import pandas as pd

df = pd.DataFrame({
    "Product": ["A", "B", "C", "D"],
    "Q1": [100, 200, 150, 300],
    "Q2": [120, 180, 200, 280],
})

df["Total"] = df["Q1"] + df["Q2"]
df["Growth"] = ((df["Q2"] - df["Q1"]) / df["Q1"] * 100).round(1)

with pd.ExcelWriter("report.xlsx", engine="xlsxwriter") as writer:
    df.to_excel(writer, sheet_name="Sales", index=False)

    workbook = writer.book
    worksheet = writer.sheets["Sales"]

    # Format header
    header_fmt = workbook.add_format({
        "bold": True, "bg_color": "#4472C4",
        "font_color": "white", "border": 1,
    })
    for col_num, col_name in enumerate(df.columns):
        worksheet.write(0, col_num, col_name, header_fmt)

    # กำหนดความกว้าง
    worksheet.set_column("A:A", 15)
    worksheet.set_column("B:E", 12)

    # Conditional formatting
    worksheet.conditional_format(
        "B2:C5", {
            "type": "3_color_scale",
            "min_color": "#FFC7CE",
            "mid_color": "#FFEB9C",
            "max_color": "#C6EFCE",
        }
    )

    # Chart
    chart = workbook.add_chart({"type": "column"})
    chart.add_series({
        "name": "Q1",
        "categories": ["Sales", 1, 0, 4, 0],
        "values": ["Sales", 1, 1, 4, 1],
    })
    chart.add_series({
        "name": "Q2",
        "categories": ["Sales", 1, 0, 4, 0],
        "values": ["Sales", 1, 2, 4, 2],
    })
    worksheet.insert_chart("G2", chart)
```

**ประมวลผลหลายไฟล์:**

```python
from pathlib import Path
import pandas as pd

def merge_excel_files(folder: str, output: str):
    files = sorted(Path(folder).glob("*.xlsx"))
    all_dfs = []
    for f in files:
        df = pd.read_excel(f)
        df["source_file"] = f.name
        all_dfs.append(df)

    merged = pd.concat(all_dfs, ignore_index=True)
    merged.to_excel(output, index=False)
    print(f"รวม {len(files)} ไฟล์ → {len(merged)} แถว")

merge_excel_files("./reports", "./merged.xlsx")
```

**อ้างอิง:** [openpyxl](https://openpyxl.readthedocs.io/), [XlsxWriter](https://xlsxwriter.readthedocs.io/)


### 15.17–15.19 PDF Automation

```bash
pip install pypdf pdfplumber reportlab
```

**อ่านข้อความจาก PDF:**

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    print(f"จำนวนหน้า: {len(pdf.pages)}")
    for i, page in enumerate(pdf.pages[:3]):
        text = page.extract_text()
        print(f"--- หน้า {i+1} ---")
        print(text[:500])

        tables = page.extract_tables()
        for table in tables:
            for row in table:
                print(row)
```

**รวม/แยก PDF:**

```python
from pypdf import PdfReader, PdfWriter
from pathlib import Path

# รวม
def merge_pdfs(input_files: list[str], output: str):
    writer = PdfWriter()
    for f in input_files:
        reader = PdfReader(f)
        for page in reader.pages:
            writer.add_page(page)
    with open(output, "wb") as f:
        writer.write(f)

# แยก
def split_pdf(input_file: str, output_dir: str):
    reader = PdfReader(input_file)
    Path(output_dir).mkdir(exist_ok=True)
    for i, page in enumerate(reader.pages):
        writer = PdfWriter()
        writer.add_page(page)
        with open(f"{output_dir}/page_{i+1}.pdf", "wb") as f:
            writer.write(f)

merge_pdfs(["a.pdf", "b.pdf", "c.pdf"], "merged.pdf")
split_pdf("merged.pdf", "./pages")
```

**สร้าง PDF Report:**

```python
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib import colors

def create_report(output: str, title: str, data: list[list]):
    doc = SimpleDocTemplate(output, pagesize=A4)
    styles = getSampleStyleSheet()
    elements = []

    title_style = ParagraphStyle(
        "CustomTitle", parent=styles["Title"],
        fontSize=18, textColor=colors.HexColor("#1f4e79"),
    )
    elements.append(Paragraph(title, title_style))
    elements.append(Spacer(1, 20))

    table = Table(data, colWidths=[100, 100, 100, 100])
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#4472C4")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("ALIGN", (0, 0), (-1, -1), "CENTER"),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, 0), 11),
        ("BOTTOMPADDING", (0, 0), (-1, 0), 12),
        ("BACKGROUND", (0, 1), (-1, -1), colors.beige),
        ("GRID", (0, 0), (-1, -1), 1, colors.black),
    ]))
    elements.append(table)

    doc.build(elements)

create_report("report.pdf", "รายงานยอดขาย", [
    ["สินค้า", "Q1", "Q2", "รวม"],
    ["A", "100", "120", "220"],
    ["B", "200", "180", "380"],
])
```

**อ้างอิง:** [pdfplumber](https://github.com/jsvine/pdfplumber), [ReportLab](https://www.reportlab.com/docs/reportlab-userguide.pdf)


### 15.22–15.24 Email Automation

```python
import smtplib
from email.message import EmailMessage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from pathlib import Path
import os

def send_email(
    to: list[str],
    subject: str,
    body_text: str,
    body_html: str | None = None,
    attachments: list[str] | None = None,
):
    smtp_host = os.environ["SMTP_HOST"]
    smtp_port = int(os.environ.get("SMTP_PORT", 587))
    username = os.environ["SMTP_USER"]
    password = os.environ["SMTP_PASS"]

    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"] = username
    msg["To"] = ", ".join(to)

    msg.attach(MIMEText(body_text, "plain", "utf-8"))
    if body_html:
        msg.attach(MIMEText(body_html, "html", "utf-8"))

    for path in attachments or []:
        p = Path(path)
        with open(p, "rb") as f:
            part = MIMEApplication(f.read(), Name=p.name)
        part["Content-Disposition"] = f'attachment; filename="{p.name}"'
        msg.attach(part)

    with smtplib.SMTP(smtp_host, smtp_port) as server:
        server.starttls()
        server.login(username, password)
        server.send_message(msg)

# ใช้งาน
send_email(
    to=["recipient@example.com"],
    subject="รายงานประจำวัน",
    body_text="แนบรายงานมาในอีเมลนี้",
    body_html="<h1>รายงานประจำวัน</h1><p>ดูไฟล์แนบ</p>",
    attachments=["report.pdf", "data.xlsx"],
)
```

**อ่านอีเมลด้วย IMAP:**

```python
import imaplib
import email
from email.header import decode_header

def fetch_unread(host: str, user: str, password: str) -> list[dict]:
    mail = imaplib.IMAP4_SSL(host)
    mail.login(user, password)
    mail.select("INBOX")

    _, messages = mail.search(None, "UNSEEN")
    results = []

    for num in messages[0].split():
        _, msg_data = mail.fetch(num, "(RFC822)")
        msg = email.message_from_bytes(msg_data[0][1])

        subject, encoding = decode_header(msg["Subject"])[0]
        if isinstance(subject, bytes):
            subject = subject.decode(encoding or "utf-8")

        sender = msg.get("From")
        body = ""
        if msg.is_multipart():
            for part in msg.walk():
                if part.get_content_type() == "text/plain":
                    body = part.get_payload(decode=True).decode("utf-8", errors="ignore")
                    break
        else:
            body = msg.get_payload(decode=True).decode("utf-8", errors="ignore")

        results.append({"subject": subject, "from": sender, "body": body})

    mail.logout()
    return results
```

**ข้อควรระวัง:**
- ใช้ **App Password** สำหรับ Gmail (ไม่ใช่ password หลัก)
- อย่า hardcode credentials — ใช้ env vars
- ระวัง rate limit ของ provider
- ใช้ email ที่ถูกต้องตาม RFC 5322

**อ้างอิง:** [smtplib](https://docs.python.org/3/library/smtplib.html), [imaplib](https://docs.python.org/3/library/imaplib.html)


### 15.27 PyAutoGUI — GUI Automation

```bash
pip install pyautogui
```

```python
import pyautogui
import time

# Safety: ถ้าเมาส์อยู่มุมซ้ายบน จะหยุด
pyautogui.FAILSAFE = True
pyautogui.PAUSE = 0.5

# ข้อมูลหน้าจอ
screen_width, screen_height = pyautogui.size()
print(f"หน้าจอ: {screen_width}x{screen_height}")

# ตำแหน่งเมาส์
x, y = pyautogui.position()
print(f"เมาส์อยู่ที่ ({x}, {y})")

# เคลื่อนเมาส์และคลิก
pyautogui.moveTo(100, 200, duration=0.5)
pyautogui.click()
pyautogui.doubleClick(500, 300)

# พิมพ์ข้อความ
pyautogui.typewrite("Hello, World!", interval=0.05)

# กดปุ่มพิเศษ
pyautogui.hotkey("ctrl", "c")
pyautogui.press("enter")

# หาภาพบนหน้าจอ
location = pyautogui.locateOnScreen("button.png", confidence=0.9)
if location:
    center = pyautogui.center(location)
    pyautogui.click(center)

# Screenshot
screenshot = pyautogui.screenshot()
screenshot.save("screen.png")
```

**ตัวอย่าง RPA จริง — กรอกฟอร์ม:**

```python
import pyautogui
import time

def fill_login_form(username: str, password: str):
    # คลิกช่อง username
    pyautogui.click(500, 300)
    pyautogui.typewrite(username, interval=0.05)

    # Tab ไป password
    pyautogui.press("tab")
    pyautogui.typewrite(password, interval=0.05)

    # กด Enter
    pyautogui.press("enter")
    time.sleep(2)  # รอโหลด
```

**อ้างอิง:** [PyAutoGUI Documentation](https://pyautogui.readthedocs.io/)


### 15.29–15.31 Ansible, Fabric, Paramiko

**Paramiko — SSH client:**

```bash
pip install paramiko
```

```python
import paramiko
from pathlib import Path

def ssh_execute(host: str, user: str, key_path: str, command: str) -> tuple[str, str, int]:
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(hostname=host, username=user, key_filename=key_path)

    stdin, stdout, stderr = client.exec_command(command, timeout=60)
    out = stdout.read().decode()
    err = stderr.read().decode()
    exit_code = stdout.channel.recv_exit_status()

    client.close()
    return out, err, exit_code

out, err, code = ssh_execute(
    "server.example.com", "deploy",
    str(Path.home() / ".ssh/id_rsa"),
    "systemctl status nginx",
)
print(f"Exit: {code}\n{out}")
```

**Fabric — high-level SSH:**

```bash
pip install fabric
```

```python
# fabfile.py
from fabric import Connection, task
from invoke import run

@task
def deploy(c, branch="main"):
    """Deploy ไปยัง production"""
    with Connection("deploy@server.example.com") as conn:
        with conn.cd("/var/www/myapp"):
            conn.run(f"git fetch && git checkout {branch}")
            conn.run("git pull origin " + branch)
            conn.run("source venv/bin/activate && pip install -r requirements.txt")
            conn.run("sudo systemctl restart myapp")
        print("✅ Deploy เสร็จ")

# รัน: fab deploy --branch=main
```

**Ansible Playbook:**

```yaml
# playbook.yml
- name: Setup Python web server
  hosts: webservers
  become: yes
  vars:
    app_dir: /var/www/myapp

  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Install system packages
      apt:
        name:
          - python3
          - python3-pip
          - python3-venv
          - nginx
        state: present

    - name: Create app directory
      file:
        path: "{{ app_dir }}"
        state: directory
        owner: www-data
        group: www-data

    - name: Clone repository
      git:
        repo: https://github.com/user/app.git
        dest: "{{ app_dir }}"
        version: main
      notify: restart nginx

  handlers:
    - name: restart nginx
      service:
        name: nginx
        state: restarted
```

```bash
ansible-playbook -i inventory.ini playbook.yml
```

**อ้างอิง:** [Ansible Documentation](https://docs.ansible.com/), [Fabric](https://www.fabfile.org/), [Paramiko](https://www.paramiko.org/)


### 15.33–15.35 Cloud Automation

**Boto3 — AWS SDK:**

```python
import boto3
from botocore.exceptions import ClientError

# S3
s3 = boto3.client("s3")
s3.upload_file("local.txt", "my-bucket", "remote.txt")
s3.download_file("my-bucket", "remote.txt", "downloaded.txt")

# List objects
response = s3.list_objects_v2(Bucket="my-bucket", Prefix="logs/")
for obj in response.get("Contents", []):
    print(f"{obj['Key']}  {obj['Size']} bytes")

# EC2 — Start/Stop instance
ec2 = boto3.client("ec2")
ec2.start_instances(InstanceIds=["i-1234567890abcdef0"])
ec2.stop_instances(InstanceIds=["i-1234567890abcdef0"])

# Lambda — Invoke
lambda_client = boto3.client("lambda")
response = lambda_client.invoke(
    FunctionName="my-function",
    Payload=b'{"key": "value"}',
)
import json
print(json.loads(response["Payload"].read()))

# DynamoDB
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("users")
table.put_item(Item={"user_id": "1", "name": "สมชาย", "age": 30})

response = table.get_item(Key={"user_id": "1"})
print(response.get("Item"))
```

**Azure SDK:**

```bash
pip install azure-storage-blob azure-identity
```

```python
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

credential = DefaultAzureCredential()
service = BlobServiceClient(
    account_url="https://myaccount.blob.core.windows.net",
    credential=credential,
)

# Upload
blob_client = service.get_blob_client(container="data", blob="file.txt")
with open("local.txt", "rb") as f:
    blob_client.upload_blob(f, overwrite=True)

# Download
with open("downloaded.txt", "wb") as f:
    data = blob_client.download_blob()
    f.write(data.readall())
```

**Google Cloud SDK:**

```bash
pip install google-cloud-storage google-cloud-bigquery
```

```python
from google.cloud import storage, bigquery

# GCS
client = storage.Client()
bucket = client.bucket("my-bucket")
blob = bucket.blob("remote.txt")
blob.upload_from_filename("local.txt")

# BigQuery
bq = bigquery.Client()
query = """
    SELECT country, COUNT(*) as users
    FROM `project.dataset.users`
    GROUP BY country
    ORDER BY users DESC
    LIMIT 10
"""
for row in bq.query(query).result():
    print(f"{row.country}: {row.users}")
```

**อ้างอิง:** [Boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html), [Azure SDK for Python](https://learn.microsoft.com/en-us/azure/developer/python/), [Google Cloud Python](https://cloud.google.com/python/docs)


## ภาค 16: การพัฒนาแอปพลิเคชันเดสก์ท็อป

### 16.1 Tkinter

**คืออะไร:** GUI library มาตรฐานของ Python (มาพร้อม interpreter) เหมาะกับเครื่องมือเล็ก-กลาง

**ตัวอย่างสมบูรณ์ — เครื่องคิดเลข:**

```python
import tkinter as tk
from tkinter import ttk, messagebox

class Calculator(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("เครื่องคิดเลข")
        self.geometry("320x400")
        self.resizable(False, False)

        self.expression = ""
        self._build_ui()

    def _build_ui(self):
        # Display
        self.display_var = tk.StringVar(value="0")
        display = tk.Entry(
            self, textvariable=self.display_var,
            font=("Helvetica", 24), justify="right",
            bd=10, bg="#f0f0f0",
        )
        display.grid(row=0, column=0, columnspan=4, sticky="nsew", padx=5, pady=5)

        # Buttons
        buttons = [
            ("C", 1, 0), ("←", 1, 1), ("%", 1, 2), ("/", 1, 3),
            ("7", 2, 0), ("8", 2, 1), ("9", 2, 2), ("*", 2, 3),
            ("4", 3, 0), ("5", 3, 1), ("6", 3, 2), ("-", 3, 3),
            ("1", 4, 0), ("2", 4, 1), ("3", 4, 2), ("+", 4, 3),
            ("±", 5, 0), ("0", 5, 1), (".", 5, 2), ("=", 5, 3),
        ]

        for text, row, col in buttons:
            btn = tk.Button(
                self, text=text, font=("Helvetica", 18),
                command=lambda t=text: self._on_click(t),
                bg="#e0e0e0", activebackground="#c0c0c0",
            )
            btn.grid(row=row, column=col, sticky="nsew", padx=2, pady=2)

        for i in range(4):
            self.columnconfigure(i, weight=1)
        for i in range(6):
            self.rowconfigure(i, weight=1)

    def _on_click(self, char: str):
        if char == "C":
            self.expression = ""
            self.display_var.set("0")
        elif char == "←":
            self.expression = self.expression[:-1]
            self.display_var.set(self.expression or "0")
        elif char == "=":
            try:
                result = eval(self.expression, {"__builtins__": {}}, {})
                self.display_var.set(str(result))
                self.expression = str(result)
            except Exception:
                messagebox.showerror("ผิดพลาด", "นิพจน์ไม่ถูกต้อง")
                self.expression = ""
                self.display_var.set("0")
        elif char == "±":
            if self.expression.startswith("-"):
                self.expression = self.expression[1:]
            else:
                self.expression = "-" + self.expression
            self.display_var.set(self.expression or "0")
        else:
            self.expression += char
            self.display_var.set(self.expression)

if __name__ == "__main__":
    app = Calculator()
    app.mainloop()
```

**อ้างอิง:** [Tkinter Documentation](https://docs.python.org/3/library/tkinter.html)


### 16.2 PyQt / 16.3 PySide

```bash
pip install PySide6
```

**ตัวอย่าง — Task Manager:**

```python
import sys
from PySide6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QLineEdit, QPushButton, QListWidget, QListWidgetItem, QMessageBox,
)
from PySide6.QtCore import Qt

class TaskManager(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Task Manager")
        self.resize(500, 400)
        self._build_ui()

    def _build_ui(self):
        central = QWidget()
        self.setCentralWidget(central)
        layout = QVBoxLayout(central)

        # Input row
        input_layout = QHBoxLayout()
        self.input = QLineEdit()
        self.input.setPlaceholderText("เพิ่มงานใหม่...")
        self.input.returnPressed.connect(self.add_task)
        add_btn = QPushButton("เพิ่ม")
        add_btn.clicked.connect(self.add_task)

        input_layout.addWidget(self.input)
        input_layout.addWidget(add_btn)
        layout.addLayout(input_layout)

        # Task list
        self.list = QListWidget()
        self.list.itemDoubleClicked.connect(self.toggle_done)
        layout.addWidget(self.list)

        # Delete button
        del_btn = QPushButton("ลบที่เลือก")
        del_btn.clicked.connect(self.delete_selected)
        layout.addWidget(del_btn)

    def add_task(self):
        text = self.input.text().strip()
        if not text:
            return
        item = QListWidgetItem(f"☐ {text}")
        item.setData(Qt.UserRole, False)  # done = False
        self.list.addItem(item)
        self.input.clear()

    def toggle_done(self, item: QListWidgetItem):
        done = item.data(Qt.UserRole)
        text = item.text()[2:]  # strip "☐ " or "☑ "
        if done:
            item.setText(f"☐ {text}")
            item.setData(Qt.UserRole, False)
        else:
            item.setText(f"☑ {text}")
            item.setData(Qt.UserRole, True)

    def delete_selected(self):
        for item in self.list.selectedItems():
            self.list.takeItem(self.list.row(item))

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = TaskManager()
    window.show()
    sys.exit(app.exec())
```

**ข้อควรระวัง:** PyQt ใช้ GPL license (ต้องซื้อ commercial license สำหรับ closed-source), PySide6 ใช้ LGPL (ฟรี)

**อ้างอิง:** [PySide6 Documentation](https://doc.qt.io/qtforpython/)


### 16.9–16.10 Desktop Packaging ด้วย PyInstaller

```bash
pip install pyinstaller
```

```bash
# Single file
pyinstaller --onefile --windowed --name MyApp main.py

# เพิ่ม icon
pyinstaller --onefile --windowed --icon=app.ico main.py

# รวม data files
pyinstaller --onefile --add-data "assets:assets" main.py

# บน Windows ใช้ ; แทน :
pyinstaller --onefile --add-data "assets;assets" main.py

# ซ่อน console (GUI)
pyinstaller --noconsole main.py
```

**Spec file สำหรับ config ซับซ้อน:**

```python
# myapp.spec
# -*- mode: python ; coding: utf-8 -*-
a = Analysis(
    ["main.py"],
    pathex=[],
    binaries=[],
    datas=[("assets", "assets"), ("config.yaml", ".")],
    hiddenimports=["pkg_resources.py2_warn"],
    hookspath=[],
    runtime_hooks=[],
    excludes=["tkinter", "matplotlib"],
)
pyz = PYZ(a.pure)
exe = EXE(
    pyz, a.scripts, a.binaries, a.datas,
    name="MyApp",
    debug=False,
    strip=False,
    upx=True,
    console=False,
    icon="app.ico",
)
```

```bash
pyinstaller myapp.spec
```

**การเข้าถึง resources ที่ bundle ไว้:**

```python
import sys
from pathlib import Path

def resource_path(relative: str) -> Path:
    """หา path ของ resource ทั้งตอน dev และตอน bundle"""
    if hasattr(sys, "_MEIPASS"):
        return Path(sys._MEIPASS) / relative
    return Path(__file__).parent / relative

icon_path = resource_path("assets/icon.png")
```

**ทางเลือกอื่น:**
- **cx_Freeze** — cross-platform, ใช้ setup.py
- **Briefcase** — จาก BeeWare, รองรับ mobile
- **Nuitka** — compile เป็น C, เร็วกว่า
- **PyOxidizer** — single binary ที่ฝัง Python interpreter

**อ้างอิง:** [PyInstaller Documentation](https://pyinstaller.org/)


## ภาค 17: การพัฒนาโมบายล์ เกม และมัลติมีเดีย

### 17.1–17.2 Kivy & BeeWare

**Kivy — Cross-platform GUI:**

```bash
pip install kivy
```

```python
# main.py
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.label import Label
from kivy.uix.textinput import TextInput
from kivy.properties import StringProperty

class CounterApp(App):
    count = StringProperty("0")

    def build(self):
        layout = BoxLayout(orientation="vertical", padding=50, spacing=20)

        self.label = Label(
            text=self.count, font_size=72, bold=True,
            color=(0.2, 0.6, 1, 1),
        )
        layout.add_widget(self.label)

        btn_layout = BoxLayout(size_hint_y=0.3, spacing=20)
        btn_layout.add_widget(Button(
            text="+1", font_size=40,
            background_color=(0.2, 0.8, 0.2, 1),
            on_press=self.increment,
        ))
        btn_layout.add_widget(Button(
            text="-1", font_size=40,
            background_color=(0.8, 0.2, 0.2, 1),
            on_press=self.decrement,
        ))
        layout.add_widget(btn_layout)
        return layout

    def increment(self, *_):
        self.count = str(int(self.count) + 1)
        self.label.text = self.count

    def decrement(self, *_):
        self.count = str(int(self.count) - 1)
        self.label.text = self.count

if __name__ == "__main__":
    CounterApp().run()
```

**Build สำหรับ Android:**

```bash
pip install buildozer
buildozer init
# แก้ buildozer.spec
buildozer android debug
```

**BeeWare — Python to native app:**

```bash
pip install briefcase
briefcase new
briefcase dev          # รันแบบ dev
briefcase build        # build
briefcase run android  # รันบน Android
briefcase package      # สร้าง installer
```

**อ้างอิง:** [Kivy](https://kivy.org/doc/stable/), [BeeWare](https://beeware.org/)


### 17.6 Pygame — Game Development

```bash
pip install pygame
```

**ตัวอย่าง — Space Shooter:**

```python
import pygame
import random
import sys

pygame.init()

WIDTH, HEIGHT = 800, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Space Shooter")
clock = pygame.time.Clock()

# Colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 50, 50)
GREEN = (50, 255, 50)
YELLOW = (255, 255, 50)

# Fonts
font = pygame.font.SysFont("Arial", 24)
big_font = pygame.font.SysFont("Arial", 48)

class Player(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = pygame.Surface((50, 40), pygame.SRCALPHA)
        pygame.draw.polygon(self.image, GREEN, [(25, 0), (0, 40), (50, 40)])
        self.rect = self.image.get_rect(center=(WIDTH // 2, HEIGHT - 60))
        self.speed = 5

    def update(self, keys):
        if keys[pygame.K_LEFT]:
            self.rect.x = max(0, self.rect.x - self.speed)
        if keys[pygame.K_RIGHT]:
            self.rect.x = min(WIDTH - self.rect.width, self.rect.x + self.speed)

class Bullet(pygame.sprite.Sprite):
    def __init__(self, x, y):
        super().__init__()
        self.image = pygame.Surface((4, 12))
        self.image.fill(YELLOW)
        self.rect = self.image.get_rect(center=(x, y))
        self.speed = -10

    def update(self):
        self.rect.y += self.speed
        if self.rect.bottom < 0:
            self.kill()

class Enemy(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        size = random.randint(30, 50)
        self.image = pygame.Surface((size, size), pygame.SRCALPHA)
        pygame.draw.circle(self.image, RED, (size // 2, size // 2), size // 2)
        self.rect = self.image.get_rect(
            center=(random.randint(size, WIDTH - size), -size)
        )
        self.speed = random.randint(2, 5)

    def update(self):
        self.rect.y += self.speed
        if self.rect.top > HEIGHT:
            self.kill()

# Groups
player = Player()
all_sprites = pygame.sprite.Group(player)
bullets = pygame.sprite.Group()
enemies = pygame.sprite.Group()

score = 0
lives = 3
enemy_timer = 0
enemy_interval = 40
game_over = False

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE and not game_over:
                bullets.add(Bullet(player.rect.centerx, player.rect.top))
            if event.key == pygame.K_r and game_over:
                # Restart
                game_over = False
                score = 0
                lives = 3
                enemies.empty()
                bullets.empty()
                player.rect.centerx = WIDTH // 2

    if not game_over:
        keys = pygame.key.get_pressed()
        player.update(keys)

        # Spawn enemies
        enemy_timer += 1
        if enemy_timer >= enemy_interval:
            enemies.add(Enemy())
            enemy_timer = 0

        bullets.update()
        enemies.update()

        # Bullet-Enemy collision
        hits = pygame.sprite.groupcollide(bullets, enemies, True, True)
        score += len(hits) * 10

        # Player-Enemy collision
        if pygame.sprite.spritecollide(player, enemies, True):
            lives -= 1
            if lives <= 0:
                game_over = True

    # Draw
    screen.fill(BLACK)
    for star in range(50):
        x = (star * 73) % WIDTH
        y = (star * 37 + pygame.time.get_ticks() // 20) % HEIGHT
        pygame.draw.circle(screen, WHITE, (x, y), 1)

    all_sprites.draw(screen)
    bullets.draw(screen)
    enemies.draw(screen)

    # HUD
    score_text = font.render(f"Score: {score}", True, WHITE)
    lives_text = font.render(f"Lives: {lives}", True, WHITE)
    screen.blit(score_text, (10, 10))
    screen.blit(lives_text, (WIDTH - 120, 10))

    if game_over:
        over_text = big_font.render("GAME OVER", True, RED)
        restart_text = font.render("กด R เพื่อเริ่มใหม่", True, WHITE)
        screen.blit(over_text, over_text.get_rect(center=(WIDTH // 2, HEIGHT // 2 - 30)))
        screen.blit(restart_text, restart_text.get_rect(center=(WIDTH // 2, HEIGHT // 2 + 30)))

    pygame.display.flip()
    clock.tick(60)
```

**อ้างอิง:** [Pygame Documentation](https://www.pygame.org/docs/)


### 17.12–17.16 Pillow, OpenCV, MoviePy, pydub

**Pillow — Image Processing:**

```bash
pip install Pillow
```

```python
from PIL import Image, ImageFilter, ImageDraw, ImageFont, ImageEnhance

# เปิดและแสดงข้อมูล
img = Image.open("photo.jpg")
print(f"ขนาด: {img.size}, โหมด: {img.mode}, ฟอร์แมต: {img.format}")

# Resize
thumb = img.copy()
thumb.thumbnail((300, 300))
thumb.save("thumb.jpg", quality=85)

# Crop
cropped = img.crop((100, 100, 500, 400))
cropped.save("cropped.jpg")

# Filter
blurred = img.filter(ImageFilter.GaussianBlur(radius=5))
blurred.save("blurred.jpg")

# Enhance
enhancer = ImageEnhance.Contrast(img)
high_contrast = enhancer.enhance(1.5)
enhancer = ImageEnhance.Brightness(img)
brighter = enhancer.enhance(1.2)

# Rotate & flip
rotated = img.rotate(45, expand=True)
flipped = img.transpose(Image.FLIP_LEFT_RIGHT)

# Watermark
watermarked = img.copy()
draw = ImageDraw.Draw(watermarked)
font = ImageFont.truetype("arial.ttf", 36)
text = "© 2026 My Company"
bbox = draw.textbbox((0, 0), text, font=font)
tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
x, y = img.width - tw - 20, img.height - th - 20
draw.text((x, y), text, font=font, fill=(255, 255, 255, 200))
watermarked.save("watermarked.jpg")

# สร้าง collage
def create_collage(images: list[str], output: str, cols: int = 3, thumb_size: int = 300):
    thumbs = []
    for path in images:
        im = Image.open(path).copy()
        im.thumbnail((thumb_size, thumb_size))
        thumbs.append(im)

    rows = (len(thumbs) + cols - 1) // cols
    canvas = Image.new("RGB", (cols * thumb_size, rows * thumb_size), "white")

    for i, thumb in enumerate(thumbs):
        row, col = divmod(i, cols)
        x = col * thumb_size + (thumb_size - thumb.width) // 2
        y = row * thumb_size + (thumb_size - thumb.height) // 2
        canvas.paste(thumb, (x, y))

    canvas.save(output, quality=90)
```

**OpenCV — Computer Vision:**

```bash
pip install opencv-python
```

```python
import cv2
import numpy as np

# อ่านรูป
img = cv2.imread("photo.jpg")
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# Face detection
face_cascade = cv2.CascadeClassifier(
    cv2.data.haarcascades + "haarcascade_frontalface_default.xml"
)
faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)

for (x, y, w, h) in faces:
    cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 3)

cv2.imwrite("detected.jpg", img)
print(f"พบ {len(faces)} ใบหน้า")

# Video processing
def process_video(input_path: str, output_path: str):
    cap = cv2.VideoCapture(input_path)
    fps = cap.get(cv2.CAP_PROP_FPS)
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    out = cv2.VideoWriter(output_path, fourcc, fps, (width, height))

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        # Edge detection
        edges = cv2.Canny(frame, 100, 200)
        edges_bgr = cv2.cvtColor(edges, cv2.COLOR_GRAY2BGR)
        out.write(edges_bgr)

    cap.release()
    out.release()

# Real-time webcam
def webcam_demo():
    cap = cv2.VideoCapture(0)
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        cv2.imshow("Webcam", frame)
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break
    cap.release()
    cv2.destroyAllWindows()
```

**MoviePy — Video Editing:**

```bash
pip install moviepy
```

```python
from moviepy.editor import (
    VideoFileClip, AudioFileClip, concatenate_videoclips,
    CompositeVideoClip, TextClip, ImageClip,
)

# ตัดต่อ
clip = VideoFileClip("input.mp4").subclip(10, 30)  # 10-30 วินาที
clip = clip.resize(height=720)
clip = clip.fx(lambda c: c.volumex(0.5))  # ลดเสียง 50%
clip.write_videofile("output.mp4", codec="libx264", audio_codec="aac")

# รวมคลิป
clips = [VideoFileClip(f"part{i}.mp4") for i in range(1, 4)]
final = concatenate_videoclips(clips, method="compose")
final.write_videofile("merged.mp4")

# เพิ่มข้อความ
video = VideoFileClip("input.mp4")
text = TextClip(
    "Hello World", fontsize=70, color="white",
    font="Arial", stroke_color="black", stroke_width=2,
)
text = text.set_position("center").set_duration(video.duration)
final = CompositeVideoClip([video, text])
final.write_videofile("with_text.mp4")

# เพิ่มเสียง
video = VideoFileClip("silent.mp4")
audio = AudioFileClip("music.mp3").subclip(0, video.duration)
final = video.set_audio(audio)
final.write_videofile("with_audio.mp4")

# สร้าง GIF
clip = VideoFileClip("input.mp4").subclip(0, 3)
clip = clip.resize(0.5)
clip.write_gif("output.gif", fps=15)
```

**pydub — Audio Processing:**

```bash
pip install pydub
# ต้องติดตั้ง ffmpeg ด้วย
```

```python
from pydub import AudioSegment
from pydub.effects import normalize

# โหลด
audio = AudioSegment.from_mp3("song.mp3")
print(f"ความยาว: {len(audio) / 1000:.1f} วินาที")

# ตัดต่อ
segment = audio[30000:60000]  # 30-60 วินาที
segment.export("clip.mp3", format="mp3")

# รวม
combined = audio1 + audio2
combined.export("combined.mp3", format="mp3")

# Fade in/out
faded = audio.fade_in(2000).fade_out(3000)

# เปลี่ยน volume
louder = audio + 6  # +6 dB
quieter = audio - 6

# Normalize
normalized = normalize(audio)

# เปลี่ยน speed
faster = audio.speedup(playback_speed=1.5)

# Split channels
stereo = AudioSegment.from_mp3("stereo.mp3")
left = stereo.split_to_mono()[0]
right = stereo.split_to_mono()[1]

# Convert format
audio.export("output.wav", format="wav")
audio.export("output.ogg", format="ogg")
```

**อ้างอิง:** [Pillow](https://pillow.readthedocs.io/), [OpenCV Python](https://docs.opencv.org/4.x/d6/d00/tutorial_py_root.html), [MoviePy](https://zulko.github.io/moviepy/), [pydub](https://github.com/jiaaro/pydub)


## ภาค 18: IoT, Robotics, Embedded และระบบฝังตัว

### 18.1–18.2 MicroPython & CircuitPython

**คืออะไร:**
- **MicroPython** — Python 3 สำหรับ microcontroller (ESP32, RP2040, STM32)
- **CircuitPython** — fork จาก MicroPython โดย Adafruit เน้นการศึกษา

**ตัวอย่าง — Blink LED (ESP32):**

```python
# main.py บน MicroPython
from machine import Pin
import time

led = Pin(2, Pin.OUT)  # GPIO 2

while True:
    led.value(1)
    time.sleep(1)
    led.value(0)
    time.sleep(1)
```

**อ่าน sensor (DHT22):**

```python
import dht
from machine import Pin
import time

sensor = dht.DHT22(Pin(4))

while True:
    try:
        sensor.measure()
        temp = sensor.temperature()
        hum = sensor.humidity()
        print(f"อุณหภูมิ: {temp:.1f}°C  ความชื้น: {hum:.1f}%")
    except OSError as e:
        print(f"อ่าน sensor ไม่ได้: {e}")
    time.sleep(2)
```

**Wi-Fi + HTTP (ESP32):**

```python
import network
import urequests
import time

# เชื่อม Wi-Fi
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect("SSID", "password")

while not wlan.isconnected():
    time.sleep(0.5)

print("IP:", wlan.ifconfig()[0])

# ส่งข้อมูลไป API
while True:
    response = urequests.post(
        "https://api.example.com/data",
        json={"temperature": 25.5, "humidity": 60},
    )
    print(response.status_code)
    response.close()
    time.sleep(60)
```

**อ้างอิง:** [MicroPython](https://docs.micropython.org/), [CircuitPython](https://docs.circuitpython.org/)


### 18.3–18.5 Raspberry Pi, Arduino, ESP32

**Raspberry Pi — GPIO:**

```bash
pip install RPi.GPIO gpiozero
```

```python
# ใช้ gpiozero (ง่ายกว่า)
from gpiozero import LED, Button, Buzzer, MotionSensor
from signal import pause

led = LED(17)
button = Button(2)
buzzer = Buzzer(27)
pir = MotionSensor(4)

# ควบคุม LED
button.when_pressed = led.on
button.when_released = led.off

# Motion detection
pir.when_motion = lambda: (led.on(), buzzer.beep(0.1, 0.1, 3))
pir.when_no_motion = led.off

print("รอการเคลื่อนไหว...")
pause()
```

**อ่าน sensor แบบ analog (ต้องใช้ ADC เช่น MCP3008):**

```python
from gpiozero import MCP3008
from time import sleep

pot = MCP3008(channel=0)

while True:
    voltage = pot.value * 3.3
    print(f"แรงดัน: {voltage:.2f}V")
    sleep(0.5)
```

**Arduino + Python ผ่าน PySerial:**

```python
import serial
import time

# เชื่อม Arduino
ser = serial.Serial("/dev/ttyUSB0", 9600, timeout=1)
time.sleep(2)  # รอ Arduino reset

# ส่งคำสั่ง
ser.write(b"LED_ON\n")
time.sleep(0.5)

# อ่าน
while ser.in_waiting:
    line = ser.readline().decode("utf-8").strip()
    print(f"Arduino: {line}")

ser.close()
```

**Arduino code ที่สื่อสาร:**

```cpp
// Arduino
void setup() {
    Serial.begin(9600);
    pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
    if (Serial.available()) {
        String cmd = Serial.readStringUntil('\n');
        cmd.trim();
        if (cmd == "LED_ON") {
            digitalWrite(LED_BUILTIN, HIGH);
            Serial.println("LED ON");
        } else if (cmd == "LED_OFF") {
            digitalWrite(LED_BUILTIN, LOW);
            Serial.println("LED OFF");
        }
    }
}
```

**อ้างอิง:** [gpiozero](https://gpiozero.readthedocs.io/), [pySerial](https://pyserial.readthedocs.io/)


### 18.9 MQTT

**คืออะไร:** โปรโตคอล publish/subscribe แบบเบา เหมาะกับ IoT

```bash
pip install paho-mqtt
```

**Publisher:**

```python
import paho.mqtt.client as mqtt
import json
import time
import random

def on_connect(client, userdata, flags, rc):
    print(f"Connected: {rc}")

client = mqtt.Client(client_id="sensor-01")
client.username_pw_set("user", "password")
client.on_connect = on_connect
client.connect("broker.hivemq.com", 1883, 60)
client.loop_start()

try:
    while True:
        payload = {
            "device_id": "sensor-01",
            "temperature": round(random.uniform(20, 30), 2),
            "humidity": round(random.uniform(40, 70), 2),
            "timestamp": int(time.time()),
        }
        client.publish(
            "home/livingroom/sensor",
            json.dumps(payload),
            qos=1,
            retain=True,
        )
        print(f"ส่ง: {payload}")
        time.sleep(5)
finally:
    client.loop_stop()
    client.disconnect()
```

**Subscriber:**

```python
import paho.mqtt.client as mqtt
import json

def on_connect(client, userdata, flags, rc):
    print(f"Connected: {rc}")
    client.subscribe("home/+/sensor", qos=1)

def on_message(client, userdata, msg):
    try:
        data = json.loads(msg.payload)
        print(f"[{msg.topic}] {data}")
    except json.JSONDecodeError:
        print(f"[{msg.topic}] (raw) {msg.payload}")

client = mqtt.Client(client_id="dashboard")
client.on_connect = on_connect
client.on_message = on_message
client.connect("broker.hivemq.com", 1883, 60)
client.loop_forever()
```

**QoS Levels:**

| QoS | ความหมาย | ใช้เมื่อ |
|-----|---------|---------|
| 0 | At most once | ข้อมูล sensor ทั่วไป |
| 1 | At least once | คำสั่งควบคุม |
| 2 | Exactly once | ธุรกรรมสำคัญ |

**อ้างอิง:** [paho-mqtt](https://eclipse.dev/paho/files/paho.mqtt.python/html/index.html)


### 18.10 CoAP

**คืออะไร:** โปรโตคอล UDP-based สำหรับ constrained devices คล้าย HTTP แต่เบามาก

```bash
pip install aiocoap
```

```python
import asyncio
import aiocoap.resource as resource
import aiocoap

class TemperatureResource(resource.Resource):
    def __init__(self):
        super().__init__()
        self.temperature = 25.0

    async def render_get(self, request):
        payload = f"temperature={self.temperature}".encode()
        return aiocoap.Message(payload=payload, code=aiocoap.CONTENT)

    async def render_put(self, request):
        self.temperature = float(request.payload.decode().split("=")[1])
        return aiocoap.Message(code=aiocoap.CHANGED)

async def main():
    root = resource.Site()
    root.add_resource(["temperature"], TemperatureResource())
    await aiocoap.Context.create_server_context(root, bind=("0.0.0.0", 5683))
    await asyncio.get_running_loop().create_future()

if __name__ == "__main__":
    asyncio.run(main())
```

**อ้างอิง:** [aiocoap](https://aiocoap.readthedocs.io/)


### 18.13 ROS (Robot Operating System)

**คืออะไร:** Framework สำหรับหุ่นยนต์ ให้การสื่อสารระหว่าง node แบบ publish/subscribe, service, action

```bash
# ROS 2 Humble
sudo apt install ros-humble-desktop
pip install rclpy
```

**Publisher node:**

```python
#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import time

class MinimalPublisher(Node):
    def __init__(self):
        super().__init__("minimal_publisher")
        self.publisher = self.create_publisher(String, "topic", 10)
        self.timer = self.create_timer(0.5, self.timer_callback)
        self.count = 0

    def timer_callback(self):
        msg = String()
        msg.data = f"Hello ROS 2 #{self.count}"
        self.publisher.publish(msg)
        self.get_logger().info(f'Publishing: "{msg.data}"')
        self.count += 1

def main():
    rclpy.init()
    node = MinimalPublisher()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == "__main__":
    main()
```

**Subscriber node:**

```python
#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class MinimalSubscriber(Node):
    def __init__(self):
        super().__init__("minimal_subscriber")
        self.subscription = self.create_subscription(
            String, "topic", self.listener_callback, 10
        )

    def listener_callback(self, msg):
        self.get_logger().info(f'I heard: "{msg.data}"')

def main():
    rclpy.init()
    node = MinimalSubscriber()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()
```

**อ้างอิง:** [ROS 2 Documentation](https://docs.ros.org/en/humble/)


### 18.16–18.18 Embedded, Real-Time, Edge Computing

**แนวคิด:**

| แนวคิด | ความหมาย | ตัวอย่าง |
|--------|---------|---------|
| Embedded | คอมพิวเตอร์ฝังในอุปกรณ์ | เครื่องซักผ้า, รถยนต์ |
| Real-Time | ต้องตอบสนองภายในเวลาที่กำหนด | ABS เบรก, หุ่นยนต์ |
| Edge Computing | ประมวลผลใกล้แหล่งข้อมูล | กล้อง CCTV วิเคราะห์ในตัว |

**Edge AI ด้วย Raspberry Pi + TensorFlow Lite:**

```bash
pip install tflite-runtime
```

```python
import tflite_runtime.interpreter as tflite
import numpy as np
from PIL import Image
import time

# โหลดโมเดล
interpreter = tflite.Interpreter(model_path="mobilenet_v2.tflite")
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

def preprocess(image_path: str) -> np.ndarray:
    img = Image.open(image_path).resize((224, 224))
    arr = np.array(img, dtype=np.float32) / 255.0
    return np.expand_dims(arr, axis=0)

def classify(image_path: str) -> int:
    input_data = preprocess(image_path)
    interpreter.set_tensor(input_details[0]["index"], input_data)

    start = time.perf_counter()
    interpreter.invoke()
    elapsed = time.perf_counter() - start

    output = interpreter.get_tensor(output_details[0]["index"])
    predicted_class = np.argmax(output)
    confidence = float(output[0][predicted_class])

    print(f"Class: {predicted_class}, Confidence: {confidence:.3f}, Time: {elapsed*1000:.1f}ms")
    return predicted_class

classify("test.jpg")
```

**แนวปฏิบัติ Edge:**
- ใช้ quantization (int8) ลดขนาดโมเดล 4x, เร็วขึ้น 2-3x
- ใช้ hardware acceleration (Coral USB, Jetson)
- Cache ผลลัพธ์ที่คำนวณบ่อย
- ส่งเฉพาะข้อมูลที่สำคัญขึ้น cloud
- ใช้ OTA update สำหรับโมเดล

**อ้างอิง:** [TensorFlow Lite](https://ai.google.dev/edge/litert), [Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/)


## สรุป

หนังสือเล่ม 7 ครอบคลุมการพัฒนา Python นอกเหนือจาก web/data:

**Automation:**
- subprocess, schedule, APScheduler
- Excel (openpyxl, xlsxwriter), PDF (pypdf, pdfplumber, reportlab)
- Email (smtplib, imaplib)
- PyAutoGUI — GUI automation / RPA
- SSH (Paramiko, Fabric), Ansible
- Cloud SDK (Boto3, Azure, GCP)

**Desktop:**
- Tkinter — GUI มาตรฐาน
- PySide6/PyQt — GUI มืออาชีพ
- PyInstaller, cx_Freeze, Briefcase — packaging

**Mobile/Game/Multimedia:**
- Kivy, BeeWare — cross-platform mobile
- Pygame, Arcade — 2D games
- Pillow, OpenCV — image processing
- MoviePy, pydub — video/audio editing

**IoT/Robotics/Embedded:**
- MicroPython, CircuitPython
- Raspberry Pi GPIO (gpiozero)
- Arduino + PySerial
- MQTT, CoAP — IoT protocols
- ROS 2 — robotics
- Edge AI ด้วย TFLite

**หลักการสำคัญ:**
- Automation ต้องมี error handling + logging + idempotency
- Desktop app ต้องคำนึงถึง UX และ packaging
- Game loop ต้องจัดการ frame rate ให้เสถียร
- IoT ต้องคำนึงถึง power, network, security
- Edge computing ต้อง balance ระหว่าง latency และ accuracy

**แหล่งอ้างอิงหลัก:**
- [subprocess](https://docs.python.org/3/library/subprocess.html)
- [PyInstaller](https://pyinstaller.org/)
- [PySide6](https://doc.qt.io/qtforpython/)
- [Pygame](https://www.pygame.org/docs/)
- [Pillow](https://pillow.readthedocs.io/)
- [OpenCV Python](https://docs.opencv.org/4.x/d6/d00/tutorial_py_root.html)
- [MoviePy](https://zulko.github.io/moviepy/)
- [MicroPython](https://docs.micropython.org/)
- [ROS 2](https://docs.ros.org/en/humble/)
- [MQTT](https://mqtt.org/)