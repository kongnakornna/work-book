# เล่ม 8: เครือข่าย ความปลอดภัย และการเข้ารหัส

## คำนำ

หนังสือเล่มนี้เป็นคู่มือภาคปฏิบัติสำหรับนักพัฒนา Python ที่ต้องการเข้าใจและนำทักษะด้านเครือข่าย ความปลอดภัย และการเข้ารหัสมาใช้ในงานจริง เนื้อหาครอบคลุมตั้งแต่พื้นฐาน Socket Programming ไปจนถึงเทคนิคความปลอดภัยขั้นสูงอย่าง Threat Modeling, DevSecOps และ Blockchain โดยทุกหัวข้อมีตัวอย่างโค้ดที่พร้อมใช้งาน คำอธิบายเชิงลึก และแหล่งอ้างอิงที่เป็นประโยชน์

---

## ภาค 19: เครือข่าย ความปลอดภัย และการเข้ารหัส

### 19.1 Socket Programming

Socket คือจุดสิ้นสุด (endpoint) ของช่องทางการสื่อสารแบบสองทิศทางระหว่างสองโหนดบนเครือข่าย โดยใช้โปรโตคอล TCP/IP เป็นพื้นฐาน

**Socket คืออะไร**
Socket เป็น API ระดับต่ำที่ช่วยให้โปรแกรมสามารถส่งและรับข้อมูลผ่านเครือข่ายได้ โดยไม่ต้องจัดการรายละเอียดของโปรโตคอลเครือข่ายด้วยตนเอง

**Socket ทำงานอย่างไร**
Python มีโมดูล `socket` ใน Standard Library ซึ่งรองรับทั้ง TCP (SOCK_STREAM) และ UDP (SOCK_DGRAM)

**การใช้งาน**

TCP Echo Server:
```python
import socket

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind(('localhost', 12345))
server_socket.listen(5)
print("TCP Server listening on port 12345...")

while True:
    client_socket, addr = server_socket.accept()
    print(f"Connection from {addr}")
    data = client_socket.recv(1024)
    client_socket.sendall(data)  # Echo back
    client_socket.close()
```

TCP Client:
```python
import socket

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(('localhost', 12345))
client_socket.sendall(b'Hello, Server!')
response = client_socket.recv(1024)
print(f"Received: {response.decode()}")
client_socket.close()
```

UDP Sender:
```python
import socket

udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
udp_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
udp_socket.sendto(b'Broadcast message', ('<broadcast>', 9999))
```

**ข้อดี**: ควบคุมได้เต็มที่, เหมาะกับงานที่ต้องการประสิทธิภาพสูง
**ข้อเสีย**: ต้องจัดการรายละเอียดระดับต่ำเอง, ไม่มี built-in encryption

**ข้อควรระวัง**: TCP รับประกันการส่งข้อมูล แต่ UDP ไม่รับประกัน ควรใช้ SSL/TLS ครอบ socket สำหรับข้อมูลสำคัญ

**อ้างอิง**: [Python socket documentation](https://docs.python.org/3/library/socket.html) 

---

### 19.2 TCP/IP

TCP/IP เป็นชุดโปรโตคอลหลักที่ใช้ในการสื่อสารบนอินเทอร์เน็ต TCP รับประกันการส่งข้อมูลถึงปลายทางตามลำดับ ในขณะที่ IP ทำหน้าที่กำหนดเส้นทางแพ็กเก็ต

**TCP vs UDP**

| ลักษณะ | TCP | UDP |
|--------|-----|-----|
| การเชื่อมต่อ | ต้องสร้างก่อน | ไม่ต้อง |
| ความน่าเชื่อถือ | รับประกัน | Best effort |
| ลำดับ | รักษาลำดับ | ไม่รับประกัน |
| Use case | Web, File Transfer | Streaming, Gaming |



**อ้างอิง**: Kurose, J. & Ross, K. *Computer Networking: A Top-Down Approach* 

---

### 19.3 UDP

UDP (User Datagram Protocol) เป็นโปรโตคอลแบบ connectionless ที่ไม่รับประกันการส่งข้อมูล ใช้ `recvfrom()` และ `sendto()` แทน `recv()` และ `send()`

**การใช้งาน UDP Receiver**:
```python
import socket

udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
udp_socket.bind(('0.0.0.0', 9999))
print("UDP Receiver listening...")

while True:
    data, addr = udp_socket.recvfrom(1024)
    print(f"Received from {addr}: {data.decode()}")
```

---

### 19.4 HTTP

HTTP (Hypertext Transfer Protocol) เป็นโปรโตคอลสำหรับการสื่อสารระหว่าง client และ server บนเว็บ

**Python HTTP Clients เปรียบเทียบ**

| Feature | requests | httpx | aiohttp |
|---------|----------|-------|---------|
| Async | ❌ | ✅ | ✅ |
| HTTP/2 | ❌ | ✅ | ❌ |
| Sync | ✅ | ✅ | ❌ |
| Performance | ดี | ดีมาก | ดีมาก |



**การใช้งาน requests**:
```python
import requests

response = requests.get("https://api.example.com/data")
print(response.json())
```

**การใช้งาน httpx (async)**:
```python
import httpx
import asyncio

async def fetch():
    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.example.com/data")
        return response.json()

asyncio.run(fetch())
```



**อ้างอิง**: [HTTPX vs Requests vs AIOHTTP](https://oxylabs.io/blog/httpx-vs-requests-vs-aiohttp) 

---

### 19.5 HTTPS

HTTPS คือ HTTP ที่ทำงานบน SSL/TLS เพื่อเข้ารหัสข้อมูลระหว่างทาง ป้องกันการดักฟังและการแก้ไขข้อมูล

---

### 19.6 Network Protocol

โปรโตคอลเครือข่ายที่สำคัญ ได้แก่:
- **TCP/IP**: โปรโตคอลหลักของอินเทอร์เน็ต
- **HTTP/HTTPS**: สำหรับเว็บ
- **DNS**: แปลงชื่อโดเมนเป็น IP
- **SMTP/IMAP/POP3**: สำหรับอีเมล
- **FTP/SFTP**: สำหรับการถ่ายโอนไฟล์

---

### 19.7 requests

`requests` เป็นไลบรารี HTTP client ที่ได้รับความนิยมสูงสุด ใช้งานง่าย รองรับ session, cookies, authentication, และ file upload

```python
import requests

# Session management
session = requests.Session()
session.headers.update({'Authorization': 'Bearer token123'})

# POST with JSON
response = session.post(
    'https://api.example.com/users',
    json={'name': 'John', 'email': 'john@example.com'}
)
print(response.status_code)
```

**อ้างอิง**: [requests documentation](https://requests.readthedocs.io/)

---

### 19.8 httpx

`httpx` เป็น HTTP client รุ่นใหม่ที่รองรับทั้ง sync และ async พร้อม HTTP/2 และ automatic decoding

```python
import httpx

# HTTP/2 support
client = httpx.Client(http2=True)
response = client.get("https://http2.example.com")
print(response.http_version)  # "HTTP/2"
```

**อ้างอิง**: [HTTPX documentation](https://www.python-httpx.org/) 

---

### 19.9 aiohttp

`aiohttp` เป็น async-first HTTP client ที่เหมาะกับงาน high-concurrency โดยเฉพาะ รองรับทั้ง client และ server

```python
import aiohttp
import asyncio

async def fetch_multiple(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [fetch(session, url) for url in urls]
        return await asyncio.gather(*tasks)

async def fetch(session, url):
    async with session.get(url) as response:
        return await response.text()
```

**อ้างอิง**: [aiohttp documentation](https://docs.aiohttp.org/)

---

### 19.10 Web Security

ความปลอดภัยของเว็บแอปพลิเคชันเป็นสิ่งสำคัญที่นักพัฒนาต้องให้ความสนใจ ตั้งแต่การออกแบบไปจนถึงการ deploy

---

### 19.11 OWASP Top 10

OWASP Top 10 ฉบับปี 2025 ประกอบด้วย:

| ลำดับ | หัวข้อ |
|-------|--------|
| A01 | Broken Access Control |
| A02 | Security Misconfiguration |
| A03 | Software Supply Chain Failures |
| A04 | Cryptographic Failures |
| A05 | Injection |
| A06 | Insecure Design |
| A07 | Authentication Failures |
| A08 | Software or Data Integrity Failures |
| A09 | Security Logging and Alerting Failures |
| A10 | Mishandling of Exceptional Conditions |



**การป้องกัน Injection ใน Python**:
```python
# ❌ อันตราย: SQL Injection
cursor.execute(f"SELECT * FROM users WHERE email = '{email}'")

# ✅ ปลอดภัย: Parameterized Query
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
```



**อ้างอิง**: [OWASP Top 10 2025](https://owasp.org/Top10/2025/) 

---

### 19.12 Cryptography

การเข้ารหัส (Cryptography) เป็นพื้นฐานของความปลอดภัยในระบบสมัยใหม่ ประกอบด้วย Hashing, Symmetric Encryption และ Asymmetric Encryption

**หลักการสำคัญ**:
- **Hashing**: ตรวจสอบความสมบูรณ์ของข้อมูล ใช้ SHA-256
- **Symmetric Encryption (AES-GCM)**: เข้ารหัสและถอดรหัสด้วย key เดียวกัน เร็ว เหมาะกับข้อมูลปริมาณมาก
- **Asymmetric Encryption (RSA)**: ใช้ public key เข้ารหัส private key ถอดรหัส เหมาะกับการแลกเปลี่ยน key

---

### 19.13 cryptography

`cryptography` เป็นไลบรารีมาตรฐานสำหรับงานเข้ารหัสใน Python

**AES-GCM Encryption**:
```python
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os

key = AESGCM.generate_key(bit_length=256)
aesgcm = AESGCM(key)
nonce = os.urandom(12)
ciphertext = aesgcm.encrypt(nonce, b"Secret message", None)
plaintext = aesgcm.decrypt(nonce, ciphertext, None)
```

**RSA Encryption**:
```python
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes

private_key = rsa.generate_private_key(
    public_exponent=65537, key_size=2048
)
public_key = private_key.public_key()

ciphertext = public_key.encrypt(
    b"Secret",
    padding.OAEP(
        mgf=padding.MGF1(algorithm=hashes.SHA256()),
        algorithm=hashes.SHA256(), label=None
    )
)
```



**อ้างอิง**: [Cryptography documentation](https://cryptography.io/)

---

### 19.14 PyCryptodome

`PyCryptodome` เป็นไลบรารีเข้ารหัสทางเลือกที่รองรับ 알고리즘 หลากหลาย

```python
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes

key = get_random_bytes(16)
cipher = AES.new(key, AES.MODE_GCM)
ciphertext, tag = cipher.encrypt_and_digest(b"Secret data")
```

---

### 19.15 Hashing

Hashing คือการแปลงข้อมูลเป็นค่าคงที่ขนาดคงที่ ไม่สามารถย้อนกลับได้ ใช้สำหรับตรวจสอบความสมบูรณ์และเก็บรหัสผ่าน

```python
import hashlib

# SHA-256
hash_value = hashlib.sha256(b"data").hexdigest()

# Password hashing with bcrypt
import bcrypt
hashed = bcrypt.hashpw(b"password", bcrypt.gensalt())
```

**ข้อควรระวัง**: ห้ามใช้ SHA-256 เก็บรหัสผ่านโดยตรง ควรใช้ bcrypt หรือ argon2 

---

### 19.16 Encryption

Encryption คือการแปลงข้อมูลให้อยู่ในรูปแบบที่อ่านไม่ออกโดยไม่ใช้ key

**Symmetric vs Asymmetric**:

| ลักษณะ | Symmetric (AES) | Asymmetric (RSA) |
|--------|-----------------|-------------------|
| Key | เดียวกัน | คู่ public/private |
| ความเร็ว | เร็ว | ช้า |
| Use case | ข้อมูลปริมาณมาก | แลกเปลี่ยน key |

---

### 19.17 TLS / SSL

TLS (Transport Layer Security) เป็นโปรโตคอลที่ให้การเข้ารหัสและการรับรองความถูกต้องสำหรับการสื่อสารบนเครือข่าย

```python
import ssl
import socket

context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
context.check_hostname = True
context.verify_mode = ssl.CERT_REQUIRED
context.load_default_certs()

with socket.create_connection(('example.com', 443)) as sock:
    with context.wrap_socket(sock, server_hostname='example.com') as ssock:
        print(ssock.version())  # TLSv1.3
```

**อ้างอิง**: [Python ssl documentation](https://docs.python.org/3/library/ssl.html) 

---

### 19.18 Authentication

Authentication คือกระบวนการยืนยันตัวตนของผู้ใช้

---

### 19.19 Authorization

Authorization คือกระบวนการตรวจสอบสิทธิ์การเข้าถึงทรัพยากร

---

### 19.20 Secure Coding

Secure Coding คือแนวปฏิบัติในการเขียนโค้ดที่ปลอดภัย

**หลักการสำคัญ**:
- โหลด secrets จาก environment variables ไม่ใช่ source code
- ใช้ parameterized queries เสมอ
- Validate input ด้วย schema (Pydantic)
- ตั้งค่า secure defaults (DEBUG=False, HttpOnly cookies)

```python
import os
from pydantic import BaseModel, EmailStr, Field

# ✅ โหลด secrets จาก environment
API_KEY = os.environ["API_KEY"]

class CreateUserRequest(BaseModel):
    email: EmailStr
    display_name: str = Field(min_length=1, max_length=80)
    age: int = Field(ge=0, le=130)
```



**อ้างอิง**: [Python Security Best Practices](https://github.com/glennguilloux/llm-knowledge-base/blob/main/security/python-security-best-practices.md) 

---

### 19.21 Penetration Testing

Penetration Testing คือการทดสอบเจาะระบบเพื่อค้นหาช่องโหว่ก่อนที่ attacker จะใช้ประโยชน์

---

### 19.22 Scapy

`Scapy` เป็นไลบรารีสำหรับสร้าง จัดส่ง และวิเคราะห์แพ็กเก็ตเครือข่าย

```python
from scapy.all import *

# Packet crafting
packet = IP(dst="192.168.1.1") / ICMP()
response = sr1(packet, timeout=2)

# Packet sniffing
def packet_callback(packet):
    if packet.haslayer(TCP):
        print(f"TCP: {packet[IP].src} -> {packet[IP].dst}")

sniff(filter="tcp port 80", prn=packet_callback, count=10)
```

**อ้างอิง**: [Scapy documentation](https://scapy.readthedocs.io/) 

---

### 19.23 Nmap

`Nmap` เป็นเครื่องมือสแกนเครือข่ายที่ใช้ Python wrapper ผ่าน `python-nmap`

```python
import nmap

scanner = nmap.PortScanner()
scanner.scan('192.168.1.1', '22-443', '-sV')

for host in scanner.all_hosts():
    print(f"Host: {host} ({scanner[host].hostname()})")
    for proto in scanner[host].all_protocols():
        ports = scanner[host][proto].keys()
        for port in ports:
            print(f"Port {port}: {scanner[host][proto][port]['name']}")
```



**อ้างอิง**: [python-nmap documentation](https://pypi.org/project/python-nmap/)

---

### 19.24 Security Scanning

Security Scanning คือการสแกนโค้ดและ dependencies เพื่อหาช่องโหว่

---

### 19.25 Bandit

`Bandit` เป็นเครื่องมือ static analysis สำหรับ Python ที่ตรวจจับช่องโหว่ด้านความปลอดภัย

```bash
pip install bandit
bandit -r ./src
```

**สิ่งที่ Bandit ตรวจจับ**: hardcoded passwords, insecure cryptographic functions, injection vulnerabilities 

**อ้างอิง**: [Bandit documentation](https://bandit.readthedocs.io/) 

---

### 19.26 Safety

`Safety` ตรวจสอบ dependencies ว่ามีช่องโหว่ที่รู้จักหรือไม่

```bash
pip install safety
safety check
```

---

### 19.27 Secrets Management

การจัดการ secrets อย่างปลอดภัยเป็นสิ่งสำคัญสำหรับ production

**หลักการ**:
- ใช้ environment variables สำหรับ development
- ใช้ secrets manager สำหรับ production
- ใช้ `.env` files อย่างปลอดภัย (ห้าม commit)

```python
from dotenv import load_dotenv
import os

load_dotenv()  # โหลดจาก .env
API_KEY = os.environ["API_KEY"]
```

**อ้างอิง**: [Managing Secrets and API Keys in Python](https://www.kdnuggets.com/managing-secrets-and-api-keys-in-python-projects-env-guide) 

---

### 19.28 Vault

HashiCorp Vault เป็นเครื่องมือจัดการ secrets แบบ centralized

```python
import hvac

client = hvac.Client(url='http://localhost:8200', token='my-token')
secret = client.secrets.kv.v2.read_secret_version(path='myapp/config')
db_password = secret['data']['data']['DB_PASSWORD']
```

**อ้างอิง**: [HashiCorp Vault](https://www.vaultproject.io/)

---

### 19.29 Environment Variables

Environment Variables เป็นวิธีพื้นฐานที่สุดในการจัดการ configuration

```python
import os

# ✅ อ่านจาก environment
DATABASE_URL = os.environ.get("DATABASE_URL", "sqlite:///default.db")

# ⚠️ ระวัง: environment variables อาจมองเห็นได้จาก process
```



---

### 19.30 OAuth

OAuth 2.0 เป็น authorization framework ที่อนุญาตให้แอปเข้าถึงทรัพยากรของผู้ใช้โดยไม่ต้องเปิดเผยรหัสผ่าน

```python
import requests

# Client Credentials Grant
response = requests.post(
    'https://oauth.example.com/token',
    data={
        'grant_type': 'client_credentials',
        'client_id': 'my-client',
        'client_secret': 'my-secret',
        'scope': 'read write'
    }
)
access_token = response.json()['access_token']
```

**อ้างอิง**: [OAuth 2.0](https://oauth.net/2/)

---

### 19.31 OpenID Connect

OpenID Connect (OIDC) เป็น layer บน OAuth 2.0 ที่เพิ่ม authentication

```python
from authlib.integrations.flask_client import OAuth

oauth = OAuth(app)
oauth.register(
    name='google',
    server_metadata_url='https://accounts.google.com/.well-known/openid-configuration',
    client_kwargs={'scope': 'openid email profile'}
)
```

**อ้างอิง**: [OpenID Connect](https://openid.net/connect/)

---

### 19.32 SAML

SAML 2.0 เป็นมาตรฐานสำหรับ SSO (Single Sign-On) ในองค์กร

```python
from onelogin.saml2.auth import OneLogin_Saml2_Auth

auth = OneLogin_Saml2_Auth(request_data, settings)
auth.login()
```

---

### 19.33 JWT

JWT (JSON Web Token) เป็นมาตรฐานสำหรับสร้าง token ที่มีข้อมูล claims

```python
import jwt
import time

# สร้าง JWT
payload = {
    'sub': 'user123',
    'iat': int(time.time()),
    'exp': int(time.time()) + 3600
}
token = jwt.encode(payload, 'secret-key', algorithm='HS256')

# ตรวจสอบ JWT
decoded = jwt.decode(token, 'secret-key', algorithms=['HS256'])
print(decoded['sub'])
```

**อ้างอิง**: [PyJWT documentation](https://pyjwt.readthedocs.io/) 

---

### 19.34 CORS

CORS (Cross-Origin Resource Sharing) เป็นกลไกที่อนุญาตให้เว็บเพจเข้าถึงทรัพยากรจาก domain อื่น

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://example.com"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

### 19.35 CSRF

CSRF (Cross-Site Request Forgery) คือการโจมตีที่หลอกให้ผู้ใช้ส่ง request ที่ไม่ต้องการ

```python
from flask_wtf.csrf import CSRFProtect

csrf = CSRFProtect(app)
```

---

### 19.36 XSS

XSS (Cross-Site Scripting) คือการโจมตีที่แทรก script ลงในเว็บเพจ

```python
from markupsafe import escape

# ✅ Escape user input
safe_html = escape(user_input)
```

---

### 19.37 SQL Injection

SQL Injection คือการโจมตีที่แทรก SQL code ผ่าน input ของผู้ใช้

**การป้องกัน**:
```python
# ✅ Parameterized query
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))

# ✅ ใช้ ORM
User.query.filter_by(id=user_id).first()
```



**อ้างอิง**: [SQL Injection Prevention in Python](https://safeguard.sh/sql-injection-prevention-in-python-parameterized-queries) 

---

### 19.38 API Security

API Security ครอบคลุม authentication, authorization, rate limiting, และ input validation

---

### 19.39 Network Automation

Network Automation คือการใช้โปรแกรมจัดการอุปกรณ์เครือข่ายโดยอัตโนมัติ

```python
from netmiko import ConnectHandler

device = {
    'device_type': 'cisco_ios',
    'host': '192.168.1.1',
    'username': 'admin',
    'password': 'password'
}

connection = ConnectHandler(**device)
output = connection.send_command('show ip interface brief')
print(output)
connection.disconnect()
```

**อ้างอิง**: [Netmiko documentation](https://github.com/ktbyers/netmiko) 

---

### 19.40 Blockchain และ Web3

Blockchain คือ distributed ledger ที่บันทึกธุรกรรมอย่างโปร่งใสและไม่สามารถแก้ไขได้

```python
from web3 import Web3

w3 = Web3(Web3.HTTPProvider('https://mainnet.example.com'))
print(w3.is_connected())
print(w3.eth.block_number)
```

**อ้างอิง**: [Web3.py documentation](https://web3py.readthedocs.io/) 

---

### 19.41 web3.py

`web3.py` เป็นไลบรารี Python สำหรับโต้ตอบกับ Ethereum blockchain

**Deploy Smart Contract**:
```python
from web3 import Web3
import json

w3 = Web3(Web3.HTTPProvider(RPC_URL))

# โหลด ABI และ bytecode
with open('Greeter.json') as f:
    contract_data = json.load(f)

# สร้าง contract instance
Greeter = w3.eth.contract(
    abi=contract_data['abi'],
    bytecode=contract_data['bytecode']
)

# Deploy
tx_hash = Greeter.constructor().transact({'from': account.address})
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
contract_address = tx_receipt.contractAddress
```



**อ้างอิง**: [Web3.py documentation](https://web3py.readthedocs.io/en/stable/) 

---

### 19.42 Smart Contract

Smart Contract คือโปรแกรมที่ทำงานบน blockchain โดยอัตโนมัติ

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Greeter {
    string public greeting;
    
    constructor() {
        greeting = "Hello";
    }
    
    function setGreeting(string memory _greeting) public {
        greeting = _greeting;
    }
}
```



---

### 19.43 DeFi

DeFi (Decentralized Finance) คือระบบการเงินที่ทำงานบน blockchain โดยไม่มีตัวกลาง

---

### 19.44 NFT

NFT (Non-Fungible Token) คือ token ที่ไม่สามารถทดแทนได้ ใช้สำหรับแสดงความเป็นเจ้าของสินทรัพย์ดิจิทัล

---

## ภาค 33: ความปลอดภัยขั้นสูง

### 33.1 Threat Modeling

Threat Modeling คือกระบวนการระบุ วิเคราะห์ และจัดการภัยคุกคามต่อระบบ

```python
# ใช้ pytm สำหรับ programmatic threat modeling
from pytm import TM, Server, Dataflow, Boundary, Actor

tm = TM("My App")
user = Actor("User")
web = Server("Web Server")
db = Server("Database")

web_to_db = Dataflow(web, db, "SQL Query")
```

**อ้างอิง**: [pytm documentation](https://github.com/izar/pytm) 

---

### 33.2 STRIDE

STRIDE เป็นกรอบการวิเคราะห์ภัยคุกคาม 6 ประเภท:

| หมวด | ความหมาย | ตัวอย่าง |
|------|----------|----------|
| **S**poofing | ปลอมตัว | ใช้ credential ของผู้อื่น |
| **T**ampering | แก้ไขข้อมูล | แก้ไขข้อมูลใน transit |
| **R**epudiation | ปฏิเสธ | ไม่ยอมรับว่าทำธุรกรรม |
| **I**nformation Disclosure | เปิดเผยข้อมูล | รั่วไหลข้อมูลลับ |
| **D**enial of Service | ทำให้ใช้ไม่ได้ | DoS attack |
| **E**levation of Privilege | ยกระดับสิทธิ์ | ได้สิทธิ์ admin |



---

### 33.3 DREAD

DREAD เป็นวิธีประเมินความเสี่ยง:
- **D**amage: ความเสียหาย
- **R**eproducibility: ความสามารถในการทำซ้ำ
- **E**xploitability: ความง่ายในการโจมตี
- **A**ffected Users: ผู้ใช้ที่ได้รับผลกระทบ
- **D**iscoverability: ความยากในการค้นพบ

---

### 33.4 PASTA

PASTA (Process for Attack Simulation and Threat Analysis) เป็น threat modeling framework ที่เน้น risk-centric

---

### 33.5 SAST

SAST (Static Application Security Testing) คือการวิเคราะห์โค้ดโดยไม่รันโปรแกรม

```bash
# Bandit สำหรับ Python
bandit -r ./src -f json -o report.json
```



---

### 33.6 DAST

DAST (Dynamic Application Security Testing) คือการทดสอบแอปที่กำลังทำงาน

```bash
# ใช้ OWASP ZAP
docker run -t owasp/zap2docker-stable zap-baseline.py -t https://example.com
```

---

### 33.7 IAST

IAST (Interactive Application Security Testing) รวมข้อดีของ SAST และ DAST

---

### 33.8 RASP

RASP (Runtime Application Self-Protection) ตรวจจับและป้องกันการโจมตีขณะรัน

---

### 33.9 SCA

SCA (Software Composition Analysis) วิเคราะห์ dependencies

```bash
# pip-audit
pip-audit

# Safety
safety check
```



---

### 33.10 SBOM

SBOM (Software Bill of Materials) คือรายการส่วนประกอบทั้งหมดของซอฟต์แวร์

```bash
# สร้าง SBOM ด้วย CycloneDX
pip install cyclonedx-bom
cyclonedx-py -o sbom.json
```

**อ้างอิง**: [CycloneDX Python](https://github.com/CycloneDX/cyclonedx-python) 

---

### 33.11 Secret Scanning

Secret Scanning คือการตรวจจับ secrets ที่หลุดเข้าไปใน source code

```bash
# Gitleaks
gitleaks detect --source . --verbose

# TruffleHog
trufflehog filesystem .
```

---

### 33.12 Gitleaks

`Gitleaks` เป็นเครื่องมือ scan หา secrets ใน git repository

```bash
gitleaks detect --source . -v
```

---

### 33.13 TruffleHog

`TruffleHog` ค้นหา secrets ที่มี high entropy

```bash
trufflehog git https://github.com/user/repo
```

---

### 33.14 Dependency Scanning

Dependency Scanning ตรวจสอบช่องโหว่ใน dependencies

---

### 33.15 Safety

```bash
safety check --full-report
```

---

### 33.16 pip-audit

```bash
pip-audit --desc
```

**อ้างอิง**: [pip-audit documentation](https://pypi.org/project/pip-audit/) 

---

### 33.17 OWASP Dependency-Check

```bash
dependency-check --project MyApp --scan ./libs
```

---

### 33.18 Container Security

Container Security ครอบคลุมการสแกน image, runtime protection, และ least privilege

```dockerfile
# ✅ ใช้ non-root user
FROM python:3.12-slim
RUN useradd -m appuser
USER appuser
```

---

### 33.19 Trivy

```bash
trivy image myapp:latest
```

---

### 33.20 Clair

`Clair` เป็น open-source container vulnerability scanner

---

### 33.21 Anchore

`Anchore` เป็น platform สำหรับ container security

---

### 33.22 Kubernetes Security

Kubernetes Security ครอบคลุม RBAC, Network Policy, Pod Security

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

---

### 33.23 RBAC

RBAC (Role-Based Access Control) กำหนดสิทธิ์ตาม role

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

---

### 33.24 Network Policy

กำหนดการสื่อสารระหว่าง pods

---

### 33.25 Pod Security

Pod Security Standards: Privileged, Baseline, Restricted

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
```

---

### 33.26 Zero Trust

Zero Trust คือแนวทางที่ "ไม่เชื่อถือใครเลย" ต้องตรวจสอบทุกครั้ง

---

### 33.27 mTLS

mTLS (mutual TLS) คือ TLS ที่ทั้ง client และ server ต้องแสดง certificate

```python
import ssl

context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
context.load_cert_chain('client-cert.pem', 'client-key.pem')
context.load_verify_locations('ca-cert.pem')
context.verify_mode = ssl.CERT_REQUIRED
```

**อ้างอิง**: [cert-auth-examples](https://github.com/royruiz-dev/cert-auth-examples) 

---

### 33.28 SPIFFE

SPIFFE (Secure Production Identity Framework for Everyone) เป็นมาตรฐาน identity สำหรับ workloads

---

### 33.29 SPIRE

SPIRE เป็น implementation ของ SPIFFE

---

### 33.30 IAM

IAM (Identity and Access Management) จัดการ identity และสิทธิ์การเข้าถึง

```python
import boto3

iam = boto3.client('iam')
users = iam.list_users()
for user in users['Users']:
    print(user['UserName'])
```

---

### 33.31 SSO

SSO (Single Sign-On) อนุญาตให้ผู้ใช้ login ครั้งเดียวเข้าถึงหลายระบบ

---

### 33.32 MFA

MFA (Multi-Factor Authentication) ต้องการหลายปัจจัยในการยืนยันตัวตน

```python
import pyotp

secret = pyotp.random_base32()
totp = pyotp.TOTP(secret)
print(totp.now())  # 6-digit code
```

---

### 33.33 OAuth2

OAuth 2.0 เป็น authorization framework

```python
from authlib.integrations.requests_client import OAuth2Session

client = OAuth2Session(
    'client-id', 'client-secret',
    scope='read write'
)
token = client.fetch_token('https://oauth.example.com/token')
```

---

### 33.34 OIDC

OpenID Connect เพิ่ม authentication layer บน OAuth 2.0

```python
from authlib.integrations.flask_client import OAuth

oauth = OAuth(app)
oauth.register(
    name='oidc',
    server_metadata_url='https://idp.example.com/.well-known/openid-configuration',
    client_kwargs={'scope': 'openid email profile'}
)
```

---

### 33.35 SAML

SAML 2.0 สำหรับ enterprise SSO

---

### 33.36 SCIM

SCIM (System for Cross-domain Identity Management) เป็นมาตรฐานสำหรับจัดการ user provisioning

---

### 33.37 Keycloak

Keycloak เป็น open-source identity and access management solution

```bash
docker run -p 8080:8080 keycloak/keycloak start-dev
```

---

### 33.38 Auth0

Auth0 เป็น identity platform แบบ managed

---

### 33.39 Okta

Okta เป็น enterprise identity platform

---

### 33.40 Azure AD

Azure AD (Microsoft Entra ID) เป็น cloud identity service

```python
from msal import ConfidentialClientApplication

app = ConfidentialClientApplication(
    client_id, authority=f"https://login.microsoftonline.com/{tenant_id}",
    client_credential=client_secret
)
result = app.acquire_token_for_client(scopes=["https://graph.microsoft.com/.default"])
```

---

### 33.41 Cognito

AWS Cognito เป็น identity service สำหรับ web และ mobile apps

```python
import boto3

cognito = boto3.client('cognito-idp')
response = cognito.sign_up(
    ClientId='client-id',
    Username='user@example.com',
    Password='SecurePass123!'
)
```

---

### 33.42 ABAC

ABAC (Attribute-Based Access Control) กำหนดสิทธิ์ตาม attributes

---

### 33.43 ReBAC

ReBAC (Relationship-Based Access Control) กำหนดสิทธิ์ตามความสัมพันธ์

---

### 33.44 OPA

OPA (Open Policy Agent) เป็น policy engine

```rego
package authz

allow {
    input.user == "admin"
}
```

---

### 33.45 Cedar

Cedar เป็น policy language จาก AWS

---

### 33.46 Encryption

การเข้ารหัสข้อมูลทั้ง at rest และ in transit

```python
from cryptography.fernet import Fernet

key = Fernet.generate_key()
f = Fernet(key)
encrypted = f.encrypt(b"Secret data")
decrypted = f.decrypt(encrypted)
```

---

### 33.47 KMS

KMS (Key Management Service) จัดการ encryption keys

```python
import boto3

kms = boto3.client('kms')
response = kms.encrypt(
    KeyId='alias/my-key',
    Plaintext=b'Secret'
)
ciphertext = response['CiphertextBlob']
```

---

### 33.48 HSM

HSM (Hardware Security Module) เป็นอุปกรณ์จัดการ keys แบบ hardware

---

### 33.49 PKI

PKI (Public Key Infrastructure) จัดการ certificates และ keys

---

### 33.50 Certificate Management

จัดการ certificates อย่างปลอดภัย

```python
from cryptography import x509
from cryptography.hazmat.primitives import hashes, serialization

cert = x509.load_pem_x509_certificate(pem_data)
print(cert.subject)
print(cert.not_valid_after_utc)
```

---

### 33.51 Vault

HashiCorp Vault สำหรับ secrets management

```python
import hvac

client = hvac.Client(url='http://vault:8200', token='token')
secret = client.secrets.kv.v2.read_secret_version(path='myapp/config')
```

---

### 33.52 SOPS

SOPS (Secrets OPerationS) เข้ารหัสไฟล์ configuration

```bash
sops -e secrets.yaml > secrets.enc.yaml
sops -d secrets.enc.yaml
```

---

### 33.53 Sealed Secrets

Sealed Secrets สำหรับ Kubernetes

```bash
kubeseal --format yaml < secret.yaml > sealed-secret.yaml
```

---

### 33.54 External Secrets

External Secrets Operator ดึง secrets จาก external providers

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: my-secret
spec:
  secretStoreRef:
    name: vault-backend
```

---

### 33.55 Secure SDLC

Secure SDLC คือการ integrate security เข้าไปในทุกขั้นตอนของ SDLC

---

### 33.56 DevSecOps

DevSecOps คือการ integrate security เข้าไปใน DevOps pipeline

```yaml
# GitHub Actions ตัวอย่าง
- name: Run Bandit
  run: bandit -r ./src

- name: Run Safety
  run: safety check

- name: Run Trivy
  uses: aquasecurity/trivy-action@master
```

---

### 33.57 Shift Left

Shift Left คือการย้าย security ไปทางซ้ายของ development lifecycle

---

### 33.58 Incident Response

Incident Response คือกระบวนการตอบสนองต่อเหตุการณ์ความปลอดภัย

**ขั้นตอน**: Preparation → Identification → Containment → Eradication → Recovery → Lessons Learned

---

### 33.59 Forensics

Digital Forensics คือการรวบรวมและวิเคราะห์หลักฐานดิจิทัล

---

### 33.60 Threat Intelligence

Threat Intelligence คือข้อมูลเกี่ยวกับภัยคุกคาม

---

### 33.61 Red Team

Red Team ทำหน้าที่โจมตีเพื่อทดสอบการป้องกัน

---

### 33.62 Blue Team

Blue Team ทำหน้าที่ป้องกันและตอบสนอง

---

### 33.63 Purple Team

Purple Team รวม Red และ Blue Team เพื่อปรับปรุงความปลอดภัย

---

### 33.64 Bug Bounty

Bug Bounty Program ให้รางวัลผู้ที่ค้นพบช่องโหว่

---

### 33.65 CVE

CVE (Common Vulnerabilities and Exposures) เป็นระบบระบุช่องโหว่

```bash
pip-audit --format json | jq '.[] | {id: .id, fix_versions: .fix_versions}'
```

---

### 33.66 CVSS

CVSS (Common Vulnerability Scoring System) ให้คะแนนความรุนแรง 0-10

---

### 33.67 CWE

CWE (Common Weakness Enumeration) เป็นรายการจุดอ่อนของซอฟต์แวร์

**อ้างอิง**: [CWE](https://cwe.mitre.org/) 

---

### 33.68 OWASP Top 10

OWASP Top 10 เป็นรายการความเสี่ยงด้านความปลอดภัยของเว็บแอปพลิเคชันที่สำคัญที่สุด

**อ้างอิง**: [OWASP Top 10](https://owasp.org/Top10/) 

---

## สรุป

หนังสือเล่ม 8 ครอบคลุมเนื้อหาด้านเครือข่าย ความปลอดภัย และการเข้ารหัสอย่างครบถ้วน ตั้งแต่ Socket Programming พื้นฐาน ไปจนถึงเทคนิคความปลอดภัยขั้นสูงอย่าง DevSecOps, Threat Modeling และ Blockchain นักพัฒนาสามารถนำตัวอย่างโค้ดและแนวปฏิบัติไปใช้ในงานจริงได้ทันที

**แหล่งอ้างอิงหลัก**:
- [Python socket documentation](https://docs.python.org/3/library/socket.html) 
- [OWASP Top 10 2025](https://owasp.org/Top10/2025/) 
- [Cryptography documentation](https://cryptography.io/) 
- [Web3.py documentation](https://web3py.readthedocs.io/) 
- [Bandit documentation](https://bandit.readthedocs.io/) 
- [Python Security Best Practices](https://github.com/glennguilloux/llm-knowledge-base/blob/main/security/python-security-best-practices.md) 
- [SQL Injection Prevention in Python](https://safeguard.sh/sql-injection-prevention-in-python-parameterized-queries) 
- [HTTPX vs Requests vs AIOHTTP](https://oxylabs.io/blog/httpx-vs-requests-vs-aiohttp) 
- [pytm documentation](https://github.com/izar/pytm) 
- [CycloneDX Python](https://github.com/CycloneDX/cyclonedx-python) 
- [Netmiko documentation](https://github.com/ktbyers/netmiko) 
- [PyJWT documentation](https://pyjwt.readthedocs.io/) 
- [cert-auth-examples](https://github.com/royruiz-dev/cert-auth-examples) 