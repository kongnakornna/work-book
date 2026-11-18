# เล่ม 11: หัวข้อเฉพาะทางและโครงการฝึกปฏิบัติ

## คำนำ

หนังสือเล่มนี้เป็นคู่มือภาคปฏิบัติสำหรับนักพัฒนา Python ที่ต้องการนำทักษะไปประยุกต์ใช้ในหลากหลายอุตสาหกรรมและสร้างโครงการจริง เนื้อหาครอบคลุมตั้งแต่ FinTech, Trading Bot, Blockchain, Healthcare, Bioinformatics, Geospatial, Quantum Computing ไปจนถึง AI Engineering, Prompt Engineering, AI Agent, RAG Chatbot, Recommendation System, Search Engine, SaaS และโครงการฝึกปฏิบัติอีกมากมาย โดยทุกหัวข้อมีตัวอย่างโค้ดที่พร้อมใช้งานและแหล่งอ้างอิงที่เป็นประโยชน์

---

## ภาค 24: หัวข้อเฉพาะทางและสาขาประยุกต์

### 24.1 FinTech

FinTech (Financial Technology) คือการนำเทคโนโลยีมาประยุกต์ใช้ในบริการทางการเงิน Python มีบทบาทสำคัญใน FinTech ตั้งแต่การวิเคราะห์ข้อมูลทางการเงิน การสร้างแบบจำลองความเสี่ยง ไปจนถึงการพัฒนาแอปพลิเคชันการชำระเงิน

**การใช้งานหลักใน FinTech**:
- การวิเคราะห์ข้อมูลทางการเงินด้วย Pandas และ NumPy
- การสร้างแบบจำลองความเสี่ยงด้วย scikit-learn
- การสร้าง API สำหรับบริการทางการเงินด้วย FastAPI
- การเชื่อมต่อกับ Blockchain ด้วย Web3.py

```python
import pandas as pd
import numpy as np

# คำนวณผลตอบแทนของหุ้น
def calculate_returns(prices):
    """คำนวณ daily returns"""
    returns = prices.pct_change().dropna()
    return returns

# คำนวณ Sharpe Ratio
def sharpe_ratio(returns, risk_free_rate=0.02):
    """คำนวณ Sharpe Ratio"""
    excess_returns = returns - risk_free_rate / 252
    return np.sqrt(252) * excess_returns.mean() / excess_returns.std()

# ตัวอย่างการใช้
prices = pd.Series([100, 102, 101, 105, 103, 107, 110])
returns = calculate_returns(prices)
print(f"Sharpe Ratio: {sharpe_ratio(returns):.2f}")
```

**ข้อควรระวัง**: ต้องคำนึงถึง regulatory compliance เช่น GDPR, PCI DSS และการป้องกันการฟอกเงิน (AML)

**อ้างอิง**: [Ultimate Python for Fintech Solutions – Bhagvan Kommadi](https://www.perlego.com/book/4424050) 

---

### 24.2 Trading Bot

Trading Bot คือโปรแกรมที่ทำการซื้อขายสินทรัพย์ทางการเงินโดยอัตโนมัติตามกลยุทธ์ที่กำหนดไว้

**Lumibot** เป็นเฟรมเวิร์กสำหรับสร้าง Backtest และรัน Trading Bot ใน Python

```python
from datetime import datetime
from lumibot.strategies import Strategy
from lumibot.backtesting import YahooDataBacktesting

class MyStrategy(Strategy):
    def on_trading_iteration(self):
        if self.first_iteration:
            aapl = self.create_order("AAPL", 10, "buy")
            self.submit_order(aapl)

# Backtest
MyStrategy.backtest(
    YahooDataBacktesting,
    datetime(2023, 1, 1),
    datetime(2024, 1, 1),
)
```

**Paper Trading**:
```python
import os
from lumibot.brokers import Alpaca
from lumibot.traders import Trader

ALPACA_CONFIG = {
    "API_KEY": os.environ["ALPACA_API_KEY"],
    "API_SECRET": os.environ["ALPACA_API_SECRET"],
    "PAPER": True,
}
broker = Alpaca(ALPACA_CONFIG)
strategy = MyStrategy(broker=broker)
trader = Trader()
trader.add_strategy(strategy)
trader.run_all()
```

**อ้างอิง**: [Lumibot documentation](https://pypi.org/project/lumibot/) 

---

### 24.3 Backtesting

Backtesting คือการทดสอบกลยุทธ์การซื้อขายกับข้อมูลในอดีตเพื่อประเมินประสิทธิภาพก่อนนำไปใช้จริง

**เฟรมเวิร์กที่นิยม**: Lumibot, Backtrader, Blankly, PyBroker, Bespoke

```python
# ตัวอย่างการใช้ Backtrader
import backtrader as bt

class SMAStrategy(bt.Strategy):
    params = (('fast', 10), ('slow', 30),)

    def __init__(self):
        self.sma_fast = bt.indicators.SMA(period=self.p.fast)
        self.sma_slow = bt.indicators.SMA(period=self.p.slow)

    def next(self):
        if self.sma_fast[0] > self.sma_slow[0] and not self.position:
            self.buy()
        elif self.sma_fast[0] < self.sma_slow[0] and self.position:
            self.sell()
```

**อ้างอิง**: [Backtrader documentation](https://www.backtrader.com/) 

---

### 24.4 Blockchain

Blockchain คือ distributed ledger ที่บันทึกธุรกรรมอย่างโปร่งใสและไม่สามารถแก้ไขได้

**Python Tools สำหรับ Blockchain**:
- **Web3.py**: โต้ตอบกับ Ethereum
- **Vyper**: ภาษา Smart Contract สไตล์ Python
- **Ape**: เครื่องมือพัฒนา Smart Contract
- **py-evm**: Ethereum Virtual Machine implementation

```python
from web3 import Web3

w3 = Web3(Web3.HTTPProvider('https://mainnet.example.com'))
print(f"Connected: {w3.is_connected()}")
print(f"Block number: {w3.eth.block_number}")
```

**อ้างอิง**: [Python นักพัฒนา Ethereum – ethereum.org](https://ethereum.org/zh-tw/developers/docs/programming-languages/python/) 

---

### 24.5 Web3

Web3 คือยุคถัดไปของอินเทอร์เน็ตที่ขับเคลื่อนด้วย blockchain และ decentralized applications (dApps)

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

**อ้างอิง**: [Web3.py documentation](https://web3py.readthedocs.io/) 

---

### 24.6 Healthcare

Healthcare เป็นอีกหนึ่งอุตสาหกรรมที่ Python เข้ามามีบทบาทสำคัญ ตั้งแต่การวิเคราะห์ข้อมูลทางการแพทย์ การสร้าง AI ช่วยวินิจฉัย ไปจนถึงระบบจัดการข้อมูลผู้ป่วย

```python
# ตัวอย่าง: ระบบตรวจจับ Acute Kidney Injury
import pandas as pd
from xgboost import XGBClassifier

def detect_aki(blood_test_results):
    """ตรวจจับ AKI จากผลตรวจเลือด"""
    features = extract_features(blood_test_results)
    model = XGBClassifier()
    model.load_model('aki_model.json')
    prediction = model.predict(features)
    return prediction
```

**อ้างอิง**: [Acute Kidney Injury Detection System](https://gitlab.doc.ic.ac.uk) 

---

### 24.7 Bioinformatics

Bioinformatics คือการใช้ computational methods เพื่อวิเคราะห์ข้อมูลทางชีววิทยา

**Biopython** เป็นไลบรารีหลักสำหรับงาน Bioinformatics

```python
from Bio.Seq import Seq
from Bio import Entrez

# จัดการลำดับ DNA
dna = Seq("ATCGATCGATCG")
print(f"Complement: {dna.complement()}")
print(f"Reverse complement: {dna.reverse_complement()}")
print(f"Transcription: {dna.transcribe()}")
print(f"Translation: {dna.translate()}")

# ค้นหาจาก NCBI
Entrez.email = "your.email@example.com"
handle = Entrez.efetch(db="nucleotide", id="NM_001301717", rettype="fasta")
record = handle.read()
```

**อ้างอิง**: [Biopython documentation](https://biopython.org/) 

---

### 24.8 Biopython

Biopython เป็นชุดเครื่องมือ Python สำหรับงาน computational biology และ bioinformatics

```python
from Bio import SeqIO

# อ่านไฟล์ FASTA
for record in SeqIO.parse("sequence.fasta", "fasta"):
    print(f"ID: {record.id}")
    print(f"Sequence: {record.seq[:50]}...")
    print(f"Length: {len(record.seq)}")
```

**อ้างอิง**: [Biopython Tutorial](https://biopython.org/DIST/docs/tutorial/Tutorial.html) 

---

### 24.9 GeoPandas

GeoPandas ขยาย Pandas เพื่อรองรับข้อมูลเชิงพื้นที่ (geospatial data) ทำให้สามารถทำงานกับแผนที่และการวิเคราะห์เชิงพื้นที่ได้ง่ายขึ้น

```python
import geopandas as gpd
from geodatasets import get_path

# อ่านข้อมูล
path = get_path("nybb")
gdf = gpd.read_file(path)

print(gdf.head())
print(gdf.crs)  # Coordinate Reference System

# แปลง CRS
gdf_projected = gdf.to_crs(epsg=32618)

# Spatial join
joined = gpd.sjoin(gdf, other_gdf, predicate="within")
```

**อ้างอิง**: [Real Python – GeoPandas Basics](https://realpython.com/geopandas/) 

---

### 24.10 GIS

GIS (Geographic Information System) คือระบบจัดการและวิเคราะห์ข้อมูลเชิงพื้นที่

**การใช้งาน GeoPandas สำหรับ GIS**:
- อ่าน shapefiles, GeoJSON, GeoPackage
- แปลง Coordinate Reference Systems (CRS)
- Spatial joins และ overlays
- สร้างแผนที่ choropleth

```python
# สร้างแผนที่
import matplotlib.pyplot as plt

fig, ax = plt.subplots(1, 1, figsize=(12, 8))
gdf.plot(column='BoroName', ax=ax, legend=True)
plt.title('New York City Boroughs')
plt.show()
```

---

### 24.11 Education Technology

EdTech คือการนำเทคโนโลยีมาประยุกต์ใช้ในการศึกษา Python มีบทบาทในการสร้างแพลตฟอร์มการเรียนรู้ การวิเคราะห์ข้อมูลนักเรียน และระบบจัดการเนื้อหา

---

### 24.12 E-Learning

E-Learning คือระบบการเรียนรู้ผ่านอินเทอร์เน็ต Python ใช้สร้างแพลตฟอร์ม e-learning ด้วย Django, FastAPI และเครื่องมืออื่นๆ

---

### 24.13 E-Commerce

E-Commerce คือการซื้อขายสินค้าออนไลน์ Python ใช้สร้างระบบ e-commerce ตั้งแต่ backend API, payment gateway, ไปจนถึง recommendation engine

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Product(BaseModel):
    name: str
    price: float
    stock: int

@app.post("/products/")
async def create_product(product: Product):
    # บันทึกลงฐานข้อมูล
    return {"message": "Product created", "product": product}
```

---

### 24.14 CMS

CMS (Content Management System) คือระบบจัดการเนื้อหา Python มี CMS ที่นิยมเช่น Django CMS, Wagtail และ Plone

---

### 24.15 ERP

ERP (Enterprise Resource Planning) คือระบบบริหารทรัพยากรองค์กร Python ใช้สร้าง ERP modules สำหรับการเงิน, HR, inventory และอื่นๆ

---

### 24.16 CRM

CRM (Customer Relationship Management) คือระบบจัดการความสัมพันธ์ลูกค้า Python ใช้สร้าง CRM ด้วย Django หรือ FastAPI

---

### 24.17 Logistics

Logistics คือการจัดการขนส่งและห่วงโซ่อุปทาน Python ใช้ในการ optimize เส้นทาง, ติดตามพัสดุ และวิเคราะห์ข้อมูล

---

### 24.18 Supply Chain

Supply Chain Management คือการจัดการห่วงโซ่อุปทาน Python ใช้ในการพยากรณ์ความต้องการ, จัดการสต็อก และวิเคราะห์ความเสี่ยง

---

### 24.19 Government

Government Technology (GovTech) คือการนำเทคโนโลยีมาประยุกต์ใช้ในภาครัฐ Python ใช้ในการเปิดข้อมูล (open data), วิเคราะห์นโยบาย และระบบบริการประชาชน

---

### 24.20 Legal Tech

Legal Tech คือการนำเทคโนโลยีมาประยุกต์ใช้ในงานกฎหมาย Python ใช้ในการวิเคราะห์สัญญา, ค้นหาเอกสารทางกฎหมาย และระบบจัดการคดี

---

### 24.21 AgriTech

AgriTech คือการนำเทคโนโลยีมาประยุกต์ใช้ในเกษตรกรรม Python ใช้ในการวิเคราะห์ภาพถ่ายดาวเทียม, พยากรณ์ผลผลิต และระบบ irrigation อัจฉริยะ

---

### 24.22 Energy

Energy Tech คือการนำเทคโนโลยีมาประยุกต์ใช้ในอุตสาหกรรมพลังงาน Python ใช้ในการวิเคราะห์ข้อมูล smart grid, พยากรณ์ความต้องการไฟฟ้า และ optimize การใช้พลังงาน

---

### 24.23 Manufacturing

Manufacturing Technology คือการนำเทคโนโลยีมาประยุกต์ใช้ในอุตสาหกรรมการผลิต Python ใช้ใน predictive maintenance, quality control และ digital twin

---

### 24.24 Scientific Computing

Scientific Computing คือการใช้คอมพิวเตอร์ในการแก้ปัญหาทางวิทยาศาสตร์ Python มี ecosystem ที่แข็งแกร่งสำหรับงานนี้

```python
import numpy as np
from scipy import optimize, integrate

# แก้สมการ
def equation(x):
    return x**2 - 4

root = optimize.root(equation, x0=1)
print(f"Root: {root.x}")

# อินทิเกรต
result, error = integrate.quad(lambda x: np.exp(-x**2), 0, np.inf)
print(f"Integral: {result}")
```

---

### 24.25 SciPy

SciPy เป็นไลบรารีสำหรับ scientific computing ที่สร้างบน NumPy มี modules สำหรับ optimization, integration, interpolation, signal processing และอื่นๆ

```python
from scipy import stats

# การทดสอบสมมติฐาน
data = [1.2, 1.5, 1.8, 2.1, 2.4, 2.7, 3.0]
t_stat, p_value = stats.ttest_1samp(data, popmean=2.0)
print(f"t-statistic: {t_stat:.4f}, p-value: {p_value:.4f}")
```

---

### 24.26 SymPy

SymPy เป็นไลบรารีสำหรับ symbolic mathematics

```python
import sympy as sp

x = sp.Symbol('x')
expr = x**2 + 2*x + 1

# แยกตัวประกอบ
factored = sp.factor(expr)
print(factored)  # (x + 1)**2

# หาอนุพันธ์
derivative = sp.diff(expr, x)
print(derivative)  # 2*x + 2

# หาปริพันธ์
integral = sp.integrate(expr, x)
print(integral)  # x**3/3 + x**2 + x
```

---

### 24.27 Quantum Computing

Quantum Computing คือการคำนวณโดยใช้หลักการของ quantum mechanics Python มี Qiskit และ Cirq สำหรับงานนี้

---

### 24.28 Qiskit

Qiskit เป็น open-source SDK สำหรับ quantum computing

```python
from qiskit import QuantumCircuit
from qiskit.primitives import StatevectorSampler

# สร้าง Bell state (entangled qubits)
qc = QuantumCircuit(2)
qc.h(0)       # Hadamard on qubit 0
qc.cx(0, 1)   # CNOT: control=0, target=1
qc.measure_all()

# รันบน simulator
sampler = StatevectorSampler()
result = sampler.run([qc]).result()
counts = result[0].data.meas.get_counts()
print(counts)  # {'00': ~0.5, '11': ~0.5}
```

**อ้างอิง**: [Qiskit documentation](https://qiskit.org/) 

---

### 24.29 Cirq

Cirq เป็น framework สำหรับ quantum computing จาก Google

```python
import cirq

# สร้าง qubits
q0, q1 = cirq.LineQubit.range(2)

# สร้าง circuit
circuit = cirq.Circuit(
    cirq.H(q0),
    cirq.CNOT(q0, q1),
    cirq.measure(q0, q1, key='result')
)

# จำลอง
simulator = cirq.Simulator()
result = simulator.run(circuit, repetitions=1000)
print(result.histogram(key='result'))
```

**อ้างอิง**: [Cirq documentation](https://quantumai.google/cirq) 

---

### 24.30 Cloud Native

Cloud Native คือแนวทางสร้างและรันแอปพลิเคชันที่ใช้ประโยชน์จาก cloud computing อย่างเต็มที่

**หลักการ Cloud Native**:
- Containers (Docker)
- Orchestration (Kubernetes)
- Microservices
- CI/CD
- Observability
- Infrastructure as Code

```python
# FastAPI + Docker + Kubernetes
from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "healthy"}
```

**อ้างอิง**: [Cloud Native Computing Foundation](https://www.cncf.io/) 

---

### 24.31 Edge Computing

Edge Computing คือการประมวลผลข้อมูลใกล้แหล่งข้อมูลมากขึ้น เพื่อลด latency และ bandwidth

**ECLYPSE** เป็น Python framework สำหรับ simulate และ emulate Cloud-Edge continuum

```python
# ตัวอย่างแนวคิด Edge Computing
import asyncio

async def process_sensor_data(sensor_id):
    """ประมวลผลข้อมูลที่ edge"""
    data = await read_sensor(sensor_id)
    result = analyze_locally(data)  # ประมวลผลที่ edge
    if result.is_anomaly:
        await send_alert_to_cloud(result)
    return result
```

**อ้างอิง**: [ECLYPSE: A Python Framework for Simulation and Emulation of the Cloud-Edge Continuum](https://onlinelibrary.wiley.com) 

---

### 24.32 Digital Twin

Digital Twin คือแบบจำลองดิจิทัลของวัตถุหรือระบบจริง ที่อัปเดตข้อมูลแบบ real-time

```python
class DigitalTwin:
    """Supply chain digital twin with state management"""
    def __init__(self, name):
        self.name = name
        self.state = {}

    def update_state(self, new_state):
        self.state.update(new_state)

    def simulate(self, scenario):
        # จำลองสถานการณ์
        return self._run_simulation(scenario)

twin = DigitalTwin("SC-Network-v1")
twin.update_state({"inventory": 5000, "demand": 1200})
```

**อ้างอิง**: [Digital Twin GitHub Repository](https://github.com/virbahu/predictive-sc-twin-v2) 

---

### 24.33 Computer Graphics

Computer Graphics คือการสร้างและจัดการภาพด้วยคอมพิวเตอร์ Python มีไลบรารีเช่น Pygame, Panda3D, Blender Python API

```python
# ตัวอย่างการใช้ Pixerise (Python 3D software renderer)
# อ้างอิง: https://github.com/enricostara/pixerise
```

**อ้างอิง**: [Pixerise – Python 3D Renderer](https://github.com/enricostara/pixerise) 

---

### 24.34 Automation Testing

Automation Testing คือการใช้เครื่องมืออัตโนมัติทดสอบซอฟต์แวร์

**Playwright vs Selenium**:
```python
# Playwright
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto("https://example.com")
    assert page.title() == "Example Domain"
    browser.close()
```

```python
# Selenium
from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
driver.get("https://example.com")
assert driver.title == "Example Domain"
driver.quit()
```

**อ้างอิง**: [Playwright Python documentation](https://playwright.dev/python/) 

---

### 24.35 Data Engineering

Data Engineering คือการออกแบบและสร้างระบบจัดการข้อมูล

```python
# ETL Pipeline ด้วย Pandas
import pandas as pd
import os

def extract_data(path):
    df = pd.read_csv(path)
    print("Data Extraction completed.")
    return df

def transform_data(df):
    df_cleaned = df.dropna()
    df_cleaned['date'] = pd.to_datetime(df_cleaned['date'])
    print("Data Transformation completed.")
    return df_cleaned

def load_data(df, output_path):
    df.to_csv(output_path, index=False)
    print("Data Loading completed.")

# รัน pipeline
df = extract_data("/data/Medicaldataset.csv")
df_clean = transform_data(df)
load_data(df_clean, "/data/CleanedMedicalData.csv")
```

**อ้างอิง**: [Build Your Own Simple Data Pipeline with Python and Docker – KDnuggets](https://www.kdnuggets.com/build-your-own-simple-data-pipeline-with-python-and-docker) 

---

### 24.36 Data Science

Data Science คือการสกัดความรู้จากข้อมูล Python เป็นเครื่องมือหลัก

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# โหลดข้อมูล
df = pd.read_csv("data.csv")
X = df.drop("target", axis=1)
y = df["target"]

# แบ่งข้อมูล
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# เทรนโมเดล
model = RandomForestClassifier()
model.fit(X_train, y_train)

# ประเมิน
predictions = model.predict(X_test)
print(f"Accuracy: {accuracy_score(y_test, predictions):.2f}")
```

---

### 24.37 AI Engineering

AI Engineering คือการนำ AI models ไปใช้ใน production

```python
from fastapi import FastAPI
from pydantic import BaseModel
import joblib

app = FastAPI()
model = joblib.load("model.pkl")

class PredictionRequest(BaseModel):
    features: list[float]

@app.post("/predict")
def predict(request: PredictionRequest):
    prediction = model.predict([request.features])
    return {"prediction": prediction.tolist()}
```

**อ้างอิง**: [FastAPI documentation](https://fastapi.tiangolo.com/) 

---

### 24.38 Prompt Engineering

Prompt Engineering คือการออกแบบ prompt อย่างมีประสิทธิภาพเพื่อให้ได้ผลลัพธ์ที่ดีจาก LLM

```python
from langchain_core.prompts import PromptTemplate, FewShotPromptTemplate
from langchain_openai import ChatOpenAI

# Simple template
template = PromptTemplate(
    input_variables=["topic"],
    template="อธิบายเรื่อง {topic} ให้เข้าใจง่ายๆ"
)

# Few-shot template
examples = [
    {"input": "happy", "output": "เศร้า"},
    {"input": "fast", "output": "ช้า"},
]
example_prompt = PromptTemplate(
    input_variables=["input", "output"],
    template="Input: {input}\nOutput: {output}"
)
few_shot = FewShotPromptTemplate(
    examples=examples,
    example_prompt=example_prompt,
    suffix="Input: {input}\nOutput:",
    input_variables=["input"]
)

# ใช้งาน
llm = ChatOpenAI(model="gpt-4o-mini")
prompt = few_shot.format(input="big")
response = llm.invoke(prompt)
print(response.content)
```

**อ้างอิง**: [LangChain Prompt Engineering Examples](https://github.com/ancoleman/ai-design-components) 

---

### 24.39 AI Agent

AI Agent คือระบบที่ใช้ LLM ในการตัดสินใจและดำเนินการ autonomously

```python
from praisonaiagents import Agent, Workflow

# สร้าง agents
researcher = Agent(
    name="Researcher",
    role="Research Analyst",
    goal="Research topics thoroughly",
    instructions="Provide concise, factual information."
)

writer = Agent(
    name="Writer",
    role="Content Writer",
    goal="Write engaging content",
    instructions="Write clear, engaging content based on research."
)

# สร้าง workflow
workflow = Workflow(steps=[researcher, writer])

# รัน
result = workflow.start("What are the benefits of AI agents?")
print(result["output"])
```

**อ้างอิง**: [PraisonAI documentation](https://pypi.org/project/PraisonAI/) 

---

### 24.40 Chatbot

Chatbot คือโปรแกรมที่สนทนากับผู้ใช้ Python มีเฟรมเวิร์กเช่น Rasa, ChatterBot และ LangChain

---

### 24.41 Recommendation System

Recommendation System คือระบบแนะนำสินค้า/เนื้อหา

```python
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

# สร้าง user-item matrix
ratings = pd.DataFrame({
    'user_id': [1, 1, 2, 2, 3, 3],
    'item_id': ['A', 'B', 'A', 'C', 'B', 'C'],
    'rating': [5, 3, 4, 2, 3, 5]
})

user_item = ratings.pivot_table(
    index='user_id', columns='item_id', values='rating'
).fillna(0)

# คำนวณ similarity
similarity = cosine_similarity(user_item)
print(similarity)
```

**อ้างอิง**: [Python Recommendation Systems: Build From Scratch 2026](https://www.guvi.in) 

---

### 24.42 Search Engine

Search Engine คือระบบค้นหาข้อมูล

```python
from whoosh.index import create_in
from whoosh.fields import Schema, TEXT, ID
from whoosh.qparser import QueryParser

# สร้าง schema
schema = Schema(title=TEXT(stored=True), path=ID(stored=True), content=TEXT)

# สร้าง index
import os
if not os.path.exists("indexdir"):
    os.mkdir("indexdir")
ix = create_in("indexdir", schema)

# เพิ่มเอกสาร
writer = ix.writer()
writer.add_document(title="Python", path="/python", content="Python is great")
writer.commit()

# ค้นหา
with ix.searcher() as searcher:
    query = QueryParser("content", ix.schema).parse("Python")
    results = searcher.search(query)
    for result in results:
        print(result['title'])
```

**อ้างอิง**: [Whoosh documentation](https://whoosh.readthedocs.io/) 

---

### 24.43 Social Network

Social Network คือแพลตฟอร์มเชื่อมต่อผู้คน Python ใช้สร้าง social network ด้วย Django หรือ FastAPI พร้อม graph database เช่น Neo4j

---

### 24.44 Content Management

Content Management คือการจัดการเนื้อหา Python มี CMS เช่น Wagtail, Django CMS

---

### 24.45 API Marketplace

API Marketplace คือแพลตฟอร์มรวบรวม APIs Python ใช้สร้าง API gateway และ marketplace

---

### 24.46 SaaS

SaaS (Software as a Service) คือซอฟต์แวร์ที่ให้บริการผ่าน cloud

**Multi-tenant Architecture ด้วย Django**:
```python
# ใช้ django-tenants
# pip install django-tenants

# settings.py
SHARED_APPS = ['django_tenants', 'customers']
TENANT_APPS = ['django.contrib.contenttypes', 'myapp']
TENANT_MODEL = "customers.Client"
TENANT_DOMAIN_MODEL = "customers.Domain"
```

**อ้างอิง**: [Building a Multi-tenant App with Django – testdriven.io](https://testdriven.io) 

---

### 24.47 PaaS

PaaS (Platform as a Service) คือแพลตฟอร์มสำหรับพัฒนาและ deploy แอปพลิเคชัน Python มี Heroku, Render, Railway, Google App Engine

---

### 24.48 IaaS

IaaS (Infrastructure as a Service) คือบริการโครงสร้างพื้นฐาน เช่น AWS EC2, GCP Compute Engine, Azure VM

---

## ภาค 25: โครงการฝึกปฏิบัติและกรณีศึกษา

### 25.1 CLI Tool

CLI Tool คือเครื่องมือที่ทำงานผ่าน command line

```python
import typer

app = typer.Typer()

@app.command()
def hello(name: str, count: int = 1):
    """Say hello to NAME."""
    for _ in range(count):
        typer.echo(f"Hello, {name}!")

@app.command()
def goodbye(name: str):
    """Say goodbye to NAME."""
    typer.echo(f"Goodbye, {name}!")

if __name__ == "__main__":
    app()
```

```bash
python cli.py hello Alice --count 3
python cli.py goodbye Bob
```

**อ้างอิง**: [Typer documentation](https://typer.tiangolo.com/) 

---

### 25.2 Web Application

Web Application คือแอปพลิเคชันที่ทำงานบนเว็บเบราว์เซอร์

```python
from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

@app.get("/")
async def home(request: Request):
    return templates.TemplateResponse(
        "index.html",
        {"request": request, "title": "My App"}
    )
```

---

### 25.3 REST API

REST API คือ API ที่ใช้ HTTP methods และ stateless communication

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional

app = FastAPI()

class Item(BaseModel):
    name: str
    price: float
    description: Optional[str] = None

items = {}

@app.post("/items/", status_code=201)
async def create_item(item: Item):
    item_id = len(items) + 1
    items[item_id] = item
    return {"id": item_id, **item.model_dump()}

@app.get("/items/{item_id}")
async def get_item(item_id: int):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"id": item_id, **items[item_id].model_dump()}

@app.get("/items/")
async def list_items(skip: int = 0, limit: int = 10):
    return list(items.items())[skip:skip+limit]
```

**อ้างอิง**: [FastAPI documentation](https://fastapi.tiangolo.com/) 

---

### 25.4 GraphQL API

GraphQL คือ query language สำหรับ APIs

```python
import strawberry
from fastapi import FastAPI
from strawberry.fastapi import GraphQLRouter

@strawberry.type
class User:
    id: int
    name: str
    email: str

users = [
    User(id=1, name="Alice", email="alice@example.com"),
    User(id=2, name="Bob", email="bob@example.com"),
]

@strawberry.type
class Query:
    @strawberry.field
    def users(self) -> list[User]:
        return users

    @strawberry.field
    def user(self, id: int) -> User | None:
        return next((u for u in users if u.id == id), None)

schema = strawberry.Schema(query=Query)
graphql_app = GraphQLRouter(schema)

app = FastAPI()
app.include_router(graphql_app, prefix="/graphql")
```

**อ้างอิง**: [Strawberry documentation](https://strawberry.rocks/) 

---

### 25.5 Microservices

Microservices คือสถาปัตยกรรมที่แบ่งแอปพลิเคชันเป็นบริการเล็กๆ ที่ทำงานอิสระ

```python
# Order Service
from fastapi import FastAPI
import httpx

app = FastAPI()

@app.post("/orders/")
async def create_order(order: dict):
    # เรียก Payment Service
    async with httpx.AsyncClient() as client:
        payment = await client.post(
            "http://payment-service:8001/payments/",
            json={"order_id": order["id"], "amount": order["total"]}
        )
    return {"order": order, "payment": payment.json()}
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  order-service:
    build: ./order-service
    ports:
      - "8000:8000"
    depends_on:
      - payment-service
      - inventory-service
  
  payment-service:
    build: ./payment-service
    ports:
      - "8001:8001"
  
  inventory-service:
    build: ./inventory-service
    ports:
      - "8002:8002"
```

**อ้างอิง**: [Microservices Architecture – Python Implementation Pattern](https://github.com/phdsystems/software-engineering-labs) 

---

### 25.6 Data Pipeline

Data Pipeline คือระบบเคลื่อนย้ายและแปลงข้อมูล

```python
import pandas as pd
from prefect import flow, task

@task
def extract(path: str) -> pd.DataFrame:
    return pd.read_csv(path)

@task
def transform(df: pd.DataFrame) -> pd.DataFrame:
    return df.dropna().assign(
        processed_at=pd.Timestamp.now()
    )

@task
def load(df: pd.DataFrame, path: str):
    df.to_parquet(path)

@flow
def etl_pipeline():
    df = extract("data/raw.csv")
    transformed = transform(df)
    load(transformed, "data/processed.parquet")

if __name__ == "__main__":
    etl_pipeline()
```

**อ้างอิง**: [Prefect documentation](https://docs.prefect.io/) 

---

### 25.7 ETL Pipeline

ETL (Extract, Transform, Load) Pipeline คือรูปแบบหนึ่งของ Data Pipeline

```python
# ETL ด้วย PySpark
from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder.appName("ETL").getOrCreate()

# Extract
df = spark.read.csv("data.csv", header=True, inferSchema=True)

# Transform
df_clean = df.dropna().filter(col("amount") > 0)

# Load
df_clean.write.parquet("output.parquet")
```

**อ้างอิง**: [Build an ETL Pipeline with PySpark – Pluralsight](https://www.pluralsight.com) 

---

### 25.8 Machine Learning System

ML System คือระบบที่รวม ML model เข้ากับแอปพลิเคชัน

```python
from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import numpy as np

app = FastAPI()
model = joblib.load("model.pkl")

class PredictionRequest(BaseModel):
    features: list[float]

class PredictionResponse(BaseModel):
    prediction: float
    confidence: float

@app.post("/predict", response_model=PredictionResponse)
def predict(request: PredictionRequest):
    features = np.array(request.features).reshape(1, -1)
    prediction = model.predict(features)[0]
    probability = model.predict_proba(features).max()
    return PredictionResponse(
        prediction=float(prediction),
        confidence=float(probability)
    )
```

---

### 25.9 MLOps Pipeline

MLOps Pipeline คือการนำ DevOps มาประยุกต์ใช้กับ ML

```yaml
# GitHub Actions MLOps Pipeline
name: MLOps Pipeline
on:
  push:
    branches: [main]

jobs:
  train:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - run: pip install -r requirements.txt
      - run: python train.py
      - run: python evaluate.py
      - uses: actions/upload-artifact@v4
        with:
          name: model
          path: model.pkl
```

---

### 25.10 Chatbot

Chatbot คือโปรแกรมสนทนา

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.messages import HumanMessage, AIMessage

llm = ChatOpenAI(model="gpt-4o-mini")
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant."),
    MessagesPlaceholder(variable_name="history"),
    ("human", "{input}")
])

chain = prompt | llm
history = []

def chat(user_input):
    response = chain.invoke({
        "history": history,
        "input": user_input
    })
    history.extend([
        HumanMessage(content=user_input),
        AIMessage(content=response.content)
    ])
    return response.content
```

---

### 25.11 Automation Tool

Automation Tool คือเครื่องมือที่ทำงานอัตโนมัติ

```python
import schedule
import time
import subprocess

def backup_database():
    """สำรองฐานข้อมูลอัตโนมัติ"""
    timestamp = time.strftime("%Y%m%d_%H%M%S")
    subprocess.run([
        "pg_dump", "mydb", "-f", f"backup_{timestamp}.sql"
    ])
    print(f"Backup completed at {timestamp}")

# ตั้งเวลา
schedule.every().day.at("02:00").do(backup_database)

while True:
    schedule.run_pending()
    time.sleep(60)
```

**อ้างอิง**: [schedule documentation](https://schedule.readthedocs.io/) 

---

### 25.12 Desktop Application

Desktop Application คือแอปพลิเคชันที่ทำงานบนเครื่องผู้ใช้

```python
import tkinter as tk
from tkinter import ttk, messagebox

class TodoApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Todo App")
        self.tasks = []

        # Input
        self.entry = ttk.Entry(root, width=40)
        self.entry.pack(pady=10)

        # Buttons
        ttk.Button(root, text="Add", command=self.add_task).pack()
        ttk.Button(root, text="Delete", command=self.delete_task).pack()

        # Listbox
        self.listbox = tk.Listbox(root, width=50)
        self.listbox.pack(pady=10)

    def add_task(self):
        task = self.entry.get()
        if task:
            self.tasks.append(task)
            self.listbox.insert(tk.END, task)
            self.entry.delete(0, tk.END)

    def delete_task(self):
        try:
            index = self.listbox.curselection()[0]
            self.listbox.delete(index)
            self.tasks.pop(index)
        except IndexError:
            messagebox.showwarning("Warning", "Select a task first")

root = tk.Tk()
app = TodoApp(root)
root.mainloop()
```

---

### 25.13 Mobile Application

Mobile Application ด้วย Python ใช้ Kivy หรือ BeeWare

```python
from kivy.app import App
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout

class MyApp(App):
    def build(self):
        layout = BoxLayout(orientation='vertical')
        layout.add_widget(Button(text='Hello'))
        layout.add_widget(Button(text='World'))
        return layout

if __name__ == '__main__':
    MyApp().run()
```

**อ้างอิง**: [Kivy documentation](https://kivy.org/) 

---

### 25.14 IoT System

IoT System คือระบบที่เชื่อมต่ออุปกรณ์ผ่านอินเทอร์เน็ต

```python
import paho.mqtt.client as mqtt
import json
import time

client = mqtt.Client()
client.connect("localhost", 1883)

def publish_sensor_data():
    data = {
        "temperature": 25.5,
        "humidity": 60,
        "timestamp": time.time()
    }
    client.publish("sensors/room1", json.dumps(data))

while True:
    publish_sensor_data()
    time.sleep(5)
```

**อ้างอิง**: [paho-mqtt documentation](https://pypi.org/project/paho-mqtt/) 

---

### 25.15 Robotics System

Robotics System ด้วย Python ใช้ ROS (Robot Operating System)

```python
import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class RobotController(Node):
    def __init__(self):
        super().__init__('robot_controller')
        self.publisher = self.create_publisher(String, 'robot_command', 10)
        self.timer = self.create_timer(1.0, self.send_command)

    def send_command(self):
        msg = String()
        msg.data = 'move_forward'
        self.publisher.publish(msg)
        self.get_logger().info(f'Sent: {msg.data}')

def main():
    rclpy.init()
    node = RobotController()
    rclpy.spin(node)
    rclpy.shutdown()
```

**อ้างอิง**: [ROS 2 documentation](https://docs.ros.org/) 

---

### 25.16 Game

Game Development ด้วย Python ใช้ Pygame

```python
import pygame

pygame.init()
screen = pygame.display.set_mode((800, 600))
pygame.display.set_caption("My Game")

player = pygame.Rect(400, 300, 50, 50)
clock = pygame.time.Clock()
running = True

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    keys = pygame.key.get_pressed()
    if keys[pygame.K_LEFT]:
        player.x -= 5
    if keys[pygame.K_RIGHT]:
        player.x += 5

    screen.fill((0, 0, 0))
    pygame.draw.rect(screen, (0, 255, 0), player)
    pygame.display.flip()
    clock.tick(60)

pygame.quit()
```

**อ้างอิง**: [Pygame documentation](https://www.pygame.org/) 

---

### 25.17 E-Commerce

(ดูรายละเอียดในหัวข้อ 24.13)

---

### 25.18 Social Network

(ดูรายละเอียดในหัวข้อ 24.43)

---

### 25.19 CMS

(ดูรายละเอียดในหัวข้อ 24.14)

---

### 25.20 ERP

(ดูรายละเอียดในหัวข้อ 24.15)

---

### 25.21 CRM

(ดูรายละเอียดในหัวข้อ 24.16)

---

### 25.22 FinTech

(ดูรายละเอียดในหัวข้อ 24.1)

---

### 25.23 Healthcare

(ดูรายละเอียดในหัวข้อ 24.6)

---

### 25.24 Education

(ดูรายละเอียดในหัวข้อ 24.11–24.12)

---

### 25.25 Logistics

(ดูรายละเอียดในหัวข้อ 24.17)

---

### 25.26 SaaS

(ดูรายละเอียดในหัวข้อ 24.46)

---

### 25.27 System Design Case Study

Case Study: ออกแบบระบบ URL Shortener

```python
from fastapi import FastAPI
import string
import random
import redis

app = FastAPI()
cache = redis.Redis(host='localhost', port=6379)

def generate_short_code(length=6):
    chars = string.ascii_letters + string.digits
    return ''.join(random.choices(chars, k=length))

@app.post("/shorten")
def shorten_url(long_url: str):
    code = generate_short_code()
    cache.set(code, long_url, ex=86400)  # หมดอายุ 24 ชม.
    return {"short_url": f"https://short.link/{code}"}

@app.get("/{code}")
def redirect(code: str):
    long_url = cache.get(code)
    if long_url:
        return {"redirect": long_url.decode()}
    return {"error": "Not found"}, 404
```

---

### 25.28 Capstone Project

Capstone Project คือโครงการสรุปที่รวมทุกทักษะ

**ตัวอย่าง**: สร้างแพลตฟอร์ม E-Commerce ครบวงจร
- Backend: FastAPI + PostgreSQL + Redis
- Frontend: React + TailwindCSS
- ML: Recommendation System
- DevOps: Docker + Kubernetes + GitHub Actions
- Monitoring: Prometheus + Grafana

---

## ภาค 37: โครงการฝึกปฏิบัติเพิ่มเติม

### 37.1 URL Shortener

(ดูตัวอย่างในหัวข้อ 25.27)

---

### 37.2 Pastebin

```python
from fastapi import FastAPI
import uuid
import redis

app = FastAPI()
cache = redis.Redis(host='localhost', port=6379)

@app.post("/paste")
def create_paste(content: str):
    paste_id = str(uuid.uuid4())[:8]
    cache.set(f"paste:{paste_id}", content, ex=604800)  # 7 วัน
    return {"id": paste_id, "url": f"/paste/{paste_id}"}

@app.get("/paste/{paste_id}")
def get_paste(paste_id: str):
    content = cache.get(f"paste:{paste_id}")
    if content:
        return {"content": content.decode()}
    return {"error": "Paste not found"}, 404
```

---

### 37.3 Todo API

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional

app = FastAPI()

class Todo(BaseModel):
    title: str
    description: Optional[str] = None
    completed: bool = False

todos = {}

@app.post("/todos/")
def create_todo(todo: Todo):
    todo_id = len(todos) + 1
    todos[todo_id] = todo
    return {"id": todo_id, **todo.model_dump()}

@app.get("/todos/")
def list_todos():
    return list(todos.items())

@app.put("/todos/{todo_id}")
def update_todo(todo_id: int, todo: Todo):
    if todo_id not in todos:
        raise HTTPException(status_code=404, detail="Todo not found")
    todos[todo_id] = todo
    return {"id": todo_id, **todo.model_dump()}

@app.delete("/todos/{todo_id}")
def delete_todo(todo_id: int):
    if todo_id not in todos:
        raise HTTPException(status_code=404, detail="Todo not found")
    del todos[todo_id]
    return {"message": "Todo deleted"}
```

---

### 37.4 Blog CMS

```python
from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime

app = FastAPI()

class Post(BaseModel):
    title: str
    content: str
    author: str

posts = []

@app.post("/posts/")
def create_post(post: Post):
    new_post = {
        "id": len(posts) + 1,
        **post.model_dump(),
        "created_at": datetime.now().isoformat()
    }
    posts.append(new_post)
    return new_post

@app.get("/posts/")
def list_posts():
    return posts
```

---

### 37.5 E-commerce API

(ดูตัวอย่างในหัวข้อ 25.5)

---

### 37.6 Chat App

```python
from fastapi import FastAPI, WebSocket
from fastapi.responses import HTMLResponse

app = FastAPI()

html = """
<!DOCTYPE html>
<html>
<head><title>Chat</title></head>
<body>
    <h1>WebSocket Chat</h1>
    <input id="message" type="text" placeholder="Type a message...">
    <button onclick="sendMessage()">Send</button>
    <ul id="messages"></ul>
    <script>
        var ws = new WebSocket("ws://localhost:8000/ws");
        ws.onmessage = function(event) {
            var messages = document.getElementById('messages');
            var message = document.createElement('li');
            message.textContent = event.data;
            messages.appendChild(message);
        };
        function sendMessage() {
            var input = document.getElementById("message");
            ws.send(input.value);
            input.value = '';
        }
    </script>
</body>
</html>
"""

@app.get("/")
async def get():
    return HTMLResponse(html)

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        await websocket.send_text(f"Message: {data}")
```

---

### 37.7 Realtime Collaboration

Realtime Collaboration ด้วย WebSocket และ CRDT

```python
from fastapi import FastAPI, WebSocket
from collections import defaultdict

app = FastAPI()

# เก็บ documents และ connections
documents = defaultdict(str)
connections = defaultdict(list)

@app.websocket("/ws/{doc_id}")
async def websocket_endpoint(websocket: WebSocket, doc_id: str):
    await websocket.accept()
    connections[doc_id].append(websocket)

    # ส่งเนื้อหาปัจจุบัน
    await websocket.send_text(documents[doc_id])

    try:
        while True:
            data = await websocket.receive_text()
            documents[doc_id] = data
            # broadcast ให้ทุกคนใน document
            for conn in connections[doc_id]:
                if conn != websocket:
                    await conn.send_text(data)
    finally:
        connections[doc_id].remove(websocket)
```

---

### 37.8 Notification Service

```python
from fastapi import FastAPI, BackgroundTasks
from pydantic import BaseModel
import smtplib
from email.message import EmailMessage

app = FastAPI()

class Notification(BaseModel):
    recipient: str
    subject: str
    body: str

def send_email(notification: Notification):
    msg = EmailMessage()
    msg.set_content(notification.body)
    msg['Subject'] = notification.subject
    msg['From'] = "noreply@example.com"
    msg['To'] = notification.recipient

    with smtplib.SMTP('localhost', 1025) as server:
        server.send_message(msg)

@app.post("/notify")
def notify(notification: Notification, background_tasks: BackgroundTasks):
    background_tasks.add_task(send_email, notification)
    return {"status": "queued"}
```

---

### 37.9 Payment Service

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uuid

app = FastAPI()

class PaymentRequest(BaseModel):
    order_id: str
    amount: float
    currency: str = "THB"
    method: str = "credit_card"

payments = {}

@app.post("/payments/")
def process_payment(request: PaymentRequest):
    payment_id = str(uuid.uuid4())
    payments[payment_id] = {
        "id": payment_id,
        **request.model_dump(),
        "status": "completed"
    }
    return payments[payment_id]

@app.get("/payments/{payment_id}")
def get_payment(payment_id: str):
    if payment_id not in payments:
        raise HTTPException(status_code=404, detail="Payment not found")
    return payments[payment_id]
```

---

### 37.10 Wallet Service

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from decimal import Decimal

app = FastAPI()

class Wallet:
    def __init__(self, user_id: str):
        self.user_id = user_id
        self.balance = Decimal("0")

wallets = {}

@app.post("/wallets/{user_id}/deposit")
def deposit(user_id: str, amount: float):
    if user_id not in wallets:
        wallets[user_id] = Wallet(user_id)
    wallets[user_id].balance += Decimal(str(amount))
    return {"balance": float(wallets[user_id].balance)}

@app.post("/wallets/{user_id}/withdraw")
def withdraw(user_id: str, amount: float):
    if user_id not in wallets:
        raise HTTPException(status_code=404, detail="Wallet not found")
    if wallets[user_id].balance < Decimal(str(amount)):
        raise HTTPException(status_code=400, detail="Insufficient balance")
    wallets[user_id].balance -= Decimal(str(amount))
    return {"balance": float(wallets[user_id].balance)}
```

---

### 37.11 Recommendation Engine

(ดูตัวอย่างในหัวข้อ 24.41)

---

### 37.12 Search Engine

(ดูตัวอย่างในหัวข้อ 24.42)

---

### 37.13 Log Aggregator

```python
import logging
from logging.handlers import SysLogHandler

# ตั้งค่า log aggregator
logger = logging.getLogger("aggregator")
logger.setLevel(logging.INFO)

# ส่งไปยัง ELK Stack
handler = logging.handlers.SysLogHandler(address=('logstash', 514))
logger.addHandler(handler)

# การใช้งาน
logger.info("User logged in", extra={"user_id": 123, "ip": "192.168.1.1"})
```

---

### 37.14 Metrics Dashboard

```python
from prometheus_client import Counter, Histogram, generate_latest
from fastapi import FastAPI, Response

app = FastAPI()

REQUEST_COUNT = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint']
)
REQUEST_LATENCY = Histogram(
    'http_request_duration_seconds',
    'HTTP request latency'
)

@app.middleware("http")
async def monitor_requests(request, call_next):
    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.url.path
    ).inc()
    return await call_next(request)

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type="text/plain")
```

---

### 37.15 CI/CD Pipeline

(ดูตัวอย่างในหัวข้อ 25.9)

---

### 37.16 Infrastructure as Code

```python
# Pulumi Python
import pulumi
import pulumi_aws as aws

# สร้าง S3 bucket
bucket = aws.s3.Bucket(
    "my-bucket",
    bucket="my-app-data",
    tags={"Environment": "production"}
)

# สร้าง EC2 instance
instance = aws.ec2.Instance(
    "web-server",
    instance_type="t3.micro",
    ami="ami-0c55b159cbfafe1f0",
    tags={"Name": "WebServer"}
)

pulumi.export("bucket_name", bucket.id)
pulumi.export("instance_ip", instance.public_ip)
```

**อ้างอิง**: [Pulumi documentation](https://www.pulumi.com/) 

---

### 37.17 Data Pipeline

(ดูตัวอย่างในหัวข้อ 25.6)

---

### 37.18 ML Pipeline

```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import joblib

# สร้าง pipeline
pipeline = Pipeline([
    ('scaler', StandardScaler()),
    ('classifier', RandomForestClassifier(n_estimators=100))
])

# เทรน
X_train, X_test, y_train, y_test = train_test_split(X, y)
pipeline.fit(X_train, y_train)

# บันทึก
joblib.dump(pipeline, 'ml_pipeline.pkl')

# โหลดและใช้งาน
loaded_pipeline = joblib.load('ml_pipeline.pkl')
predictions = loaded_pipeline.predict(X_test)
```

---

### 37.19 RAG Chatbot

```python
import streamlit as st
import chromadb
from openai import OpenAI
from langchain_community.document_loaders import PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter

openai_client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
chroma_client = chromadb.PersistentClient(path="./chroma_db")

def ingest_pdf(uploaded_file):
    loader = PyPDFLoader(tmp_path)
    pages = loader.load()

    splitter = RecursiveCharacterTextSplitter(
        chunk_size=500,
        chunk_overlap=50,
        separators=["\n\n", "\n", " ", ""]
    )
    chunks = splitter.split_documents(pages)

    collection = chroma_client.create_collection(name="docs")
    batch_size = 50
    for i in range(0, len(chunks), batch_size):
        batch = chunks[i:i+batch_size]
        texts = [chunk.page_content for chunk in batch]
        response = openai_client.embeddings.create(
            model="text-embedding-3-small",
            input=texts
        )
        collection.add(
            ids=[f"chunk_{j}" for j in range(len(batch))],
            embeddings=[item.embedding for item in response.data],
            documents=texts
        )
    return len(chunks)

def get_answer(question):
    question_emb = openai_client.embeddings.create(
        model="text-embedding-3-small",
        input=question
    )
    query_embedding = question_emb.data[0].embedding

    collection = chroma_client.get_collection(name="docs")
    results = collection.query(
        query_embeddings=[query_embedding],
        n_results=3
    )
    context = "\n\n---\n\n".join(results["documents"][0])

    prompt = f"""Answer based on context:
Context: {context}
Question: {question}
Answer:"""

    response = openai_client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.1
    )
    return response.choices[0].message.content
```

**อ้างอิง**: [RAG Chatbot – Hugging Face](https://huggingface.co/spaces/sy77/rag-chatbot) 

---

### 37.20 AI Agent

(ดูตัวอย่างในหัวข้อ 24.39)

---

### 37.21 Computer Vision App

```python
import cv2
import numpy as np
from fastapi import FastAPI, UploadFile
from PIL import Image
import io

app = FastAPI()

@app.post("/detect")
async def detect_objects(file: UploadFile):
    # อ่านภาพ
    contents = await file.read()
    image = Image.open(io.BytesIO(contents))
    img_array = np.array(image)

    # แปลงเป็น grayscale
    gray = cv2.cvtColor(img_array, cv2.COLOR_RGB2GRAY)

    # ตรวจจับขอบ
    edges = cv2.Canny(gray, 100, 200)

    # หา contours
    contours, _ = cv2.findContours(
        edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE
    )

    return {
        "objects_detected": len(contours),
        "image_size": img_array.shape
    }
```

---

### 37.22 IoT Dashboard

```python
import streamlit as st
import pandas as pd
import plotly.express as px
from datetime import datetime, timedelta

st.title("IoT Sensor Dashboard")

# จำลองข้อมูล
@st.cache_data(ttl=5)
def get_sensor_data():
    now = datetime.now()
    data = {
        "timestamp": [now - timedelta(minutes=i) for i in range(60)],
        "temperature": [25 + (i % 10) for i in range(60)],
        "humidity": [60 + (i % 5) for i in range(60)]
    }
    return pd.DataFrame(data)

df = get_sensor_data()

# แสดงกราฟ
fig = px.line(df, x="timestamp", y=["temperature", "humidity"],
              title="Sensor Readings")
st.plotly_chart(fig)

# แสดงค่าล่าสุด
col1, col2 = st.columns(2)
col1.metric("Temperature", f"{df['temperature'].iloc[-1]:.1f}°C")
col2.metric("Humidity", f"{df['humidity'].iloc[-1]:.1f}%")
```

---

### 37.23 Robotics Simulation

```python
import pybullet as p
import pybullet_data
import time

# เชื่อมต่อ physics server
physicsClient = p.connect(p.GUI)
p.setAdditionalSearchPath(pybullet_data.getDataPath())

# โหลด ground plane
p.setGravity(0, 0, -9.8)
planeId = p.loadURDF("plane.urdf")

# โหลดหุ่นยนต์
robotId = p.loadURDF("r2d2.urdf", [0, 0, 1])

# จำลอง
for i in range(1000):
    p.stepSimulation()
    time.sleep(1./240.)

p.disconnect()
```

**อ้างอิง**: [PyBullet documentation](https://pybullet.org/) 

---

### 37.24 Blockchain DApp

```python
from web3 import Web3
from solcx import compile_standard, install_solc
import json

# ติดตั้ง Solidity compiler
install_solc('0.8.0')

# Solidity code
contract_source = """
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 public value;

    function set(uint256 _value) public {
        value = _value;
    }

    function get() public view returns (uint256) {
        return value;
    }
}
"""

# Compile
compiled = compile_standard({
    "language": "Solidity",
    "sources": {"SimpleStorage.sol": {"content": contract_source}},
    "settings": {
        "outputSelection": {
            "*": {"*": ["abi", "evm.bytecode"]}
        }
    }
})

# Deploy
w3 = Web3(Web3.HTTPProvider("http://localhost:8545"))
abi = compiled["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]
bytecode = compiled["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]

SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
tx_hash = SimpleStorage.constructor().transact({"from": w3.eth.accounts[0]})
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
contract = w3.eth.contract(
    address=tx_receipt.contractAddress,
    abi=abi
)

# ใช้งาน
contract.functions.set(42).transact({"from": w3.eth.accounts[0]})
value = contract.functions.get().call()
print(f"Value: {value}")
```

---

### 37.25 Quantum Circuit Simulator

(ดูตัวอย่างในหัวข้อ 24.28)

---

### 37.26 Compiler / Interpreter

```python
# Simple calculator interpreter
import re
from typing import List, Tuple

class Token:
    def __init__(self, type_: str, value: str):
        self.type = type_
        self.value = value

    def __repr__(self):
        return f"Token({self.type}, {self.value})"

def tokenize(expression: str) -> List[Token]:
    tokens = []
    pattern = r'\d+\.?\d*|[+\-*/()]'
    for match in re.finditer(pattern, expression):
        value = match.group()
        if value.isdigit() or '.' in value:
            tokens.append(Token('NUMBER', value))
        elif value in '+-*/':
            tokens.append(Token('OP', value))
        elif value == '(':
            tokens.append(Token('LPAREN', value))
        elif value == ')':
            tokens.append(Token('RPAREN', value))
    return tokens

def evaluate(expression: str) -> float:
    tokens = tokenize(expression)
    # ใช้ eval สำหรับ simplicity (ใน production ควรใช้ parser จริง)
    return eval(expression)

# ทดสอบ
print(evaluate("2 + 3 * 4"))  # 14
print(evaluate("(2 + 3) * 4"))  # 20
```

---

### 37.27 Operating System Shell

```python
import os
import subprocess
import shlex

def shell():
    """Simple Python shell"""
    while True:
        try:
            command = input("$ ")
            if command.strip() == "exit":
                break
            if command.strip() == "cd":
                os.chdir(os.path.expanduser("~"))
                continue
            if command.startswith("cd "):
                os.chdir(command[3:].strip())
                continue

            parts = shlex.split(command)
            result = subprocess.run(
                parts,
                capture_output=True,
                text=True
            )
            print(result.stdout, end="")
            if result.stderr:
                print(result.stderr, end="")

        except KeyboardInterrupt:
            print("\nUse 'exit' to quit")
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    shell()
```

---

### 37.28 Database Engine

```python
import sqlite3

class SimpleDB:
    """Simple database engine using SQLite"""
    def __init__(self, db_path: str = ":memory:"):
        self.conn = sqlite3.connect(db_path)
        self.cursor = self.conn.cursor()

    def create_table(self, name: str, columns: dict):
        cols = ", ".join(f"{col} {dtype}" for col, dtype in columns.items())
        self.cursor.execute(f"CREATE TABLE IF NOT EXISTS {name} ({cols})")
        self.conn.commit()

    def insert(self, table: str, data: dict):
        cols = ", ".join(data.keys())
        placeholders = ", ".join(["?"] * len(data))
        self.cursor.execute(
            f"INSERT INTO {table} ({cols}) VALUES ({placeholders})",
            tuple(data.values())
        )
        self.conn.commit()
        return self.cursor.lastrowid

    def select(self, table: str, where: str = None):
        query = f"SELECT * FROM {table}"
        if where:
            query += f" WHERE {where}"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def close(self):
        self.conn.close()

# การใช้งาน
db = SimpleDB()
db.create_table("users", {"id": "INTEGER PRIMARY KEY", "name": "TEXT", "email": "TEXT"})
db.insert("users", {"name": "Alice", "email": "alice@example.com"})
print(db.select("users"))
db.close()
```

---

### 37.29 Web Framework

```python
# Simple web framework
from http.server import HTTPServer, BaseHTTPRequestHandler
import re

class Router:
    def __init__(self):
        self.routes = []

    def add(self, method: str, path: str, handler):
        self.routes.append((method, re.compile(path), handler))

    def get(self, path: str):
        def decorator(func):
            self.add("GET", path, func)
            return func
        return decorator

    def post(self, path: str):
        def decorator(func):
            self.add("POST", path, func)
            return func
        return decorator

    def resolve(self, method: str, path: str):
        for m, pattern, handler in self.routes:
            if m == method:
                match = pattern.match(path)
                if match:
                    return handler, match.groupdict()
        return None, None

class Request:
    def __init__(self, method, path, headers, body):
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body

class Response:
    def __init__(self, body="", status=200):
        self.body = body
        self.status = status

router = Router()

@router.get(r"^/$")
def index(request):
    return Response("<h1>Welcome!</h1>")

@router.get(r"^/users/(?P<user_id>\d+)$")
def get_user(request, user_id):
    return Response(f"<h1>User {user_id}</h1>")

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        handler, params = router.resolve("GET", self.path)
        if handler:
            response = handler(Request("GET", self.path, self.headers, None), **params)
        else:
            response = Response("Not Found", 404)

        self.send_response(response.status)
        self.send_header("Content-Type", "text/html")
        self.end_headers()
        self.wfile.write(response.body.encode())

if __name__ == "__main__":
    server = HTTPServer(("localhost", 8080), Handler)
    print("Server running on http://localhost:8080")
    server.serve_forever()
```

---

### 37.30 ORM

```python
import sqlite3
from typing import Any, Optional

class Field:
    def __init__(self, dtype: str, primary_key: bool = False):
        self.dtype = dtype
        self.primary_key = primary_key

class Model:
    """Simple ORM"""
    _table_name = None
    _fields = {}

    @classmethod
    def create_table(cls, conn):
        cols = []
        for name, field in cls._fields.items():
            col = f"{name} {field.dtype}"
            if field.primary_key:
                col += " PRIMARY KEY"
            cols.append(col)
        query = f"CREATE TABLE IF NOT EXISTS {cls._table_name} ({', '.join(cols)})"
        conn.execute(query)
        conn.commit()

    def save(self, conn):
        data = {k: v for k, v in self.__dict__.items() if not k.startswith('_')}
        cols = ", ".join(data.keys())
        placeholders = ", ".join(["?"] * len(data))
        conn.execute(
            f"INSERT INTO {self._table_name} ({cols}) VALUES ({placeholders})",
            tuple(data.values())
        )
        conn.commit()

    @classmethod
    def all(cls, conn):
        cursor = conn.execute(f"SELECT * FROM {cls._table_name}")
        columns = [d[0] for d in cursor.description]
        results = []
        for row in cursor.fetchall():
            obj = cls()
            for col, val in zip(columns, row):
                setattr(obj, col, val)
            results.append(obj)
        return results

# การใช้งาน
class User(Model):
    _table_name = "users"
    _fields = {
        "id": Field("INTEGER", primary_key=True),
        "name": Field("TEXT"),
        "email": Field("TEXT")
    }

conn = sqlite3.connect(":memory:")
User.create_table(conn)

user = User()
user.id = 1
user.name = "Alice"
user.email = "alice@example.com"
user.save(conn)

for u in User.all(conn):
    print(f"{u.id}: {u.name} ({u.email})")
```

---

### 37.31 Task Queue

```python
import queue
import threading
import time
from dataclasses import dataclass
from typing import Callable

@dataclass
class Task:
    id: str
    func: Callable
    args: tuple = ()
    kwargs: dict = None

    def __post_init__(self):
        if self.kwargs is None:
            self.kwargs = {}

class TaskQueue:
    """Simple task queue with worker threads"""
    def __init__(self, num_workers: int = 4):
        self.queue = queue.Queue()
        self.workers = []
        self.results = {}
        self._stop = threading.Event()

        for i in range(num_workers):
            worker = threading.Thread(target=self._worker, args=(i,))
            worker.start()
            self.workers.append(worker)

    def _worker(self, worker_id: int):
        while not self._stop.is_set():
            try:
                task = self.queue.get(timeout=1)
                print(f"Worker {worker_id} processing {task.id}")
                try:
                    result = task.func(*task.args, **task.kwargs)
                    self.results[task.id] = {"status": "success", "result": result}
                except Exception as e:
                    self.results[task.id] = {"status": "error", "error": str(e)}
                finally:
                    self.queue.task_done()
            except queue.Empty:
                continue

    def submit(self, task: Task):
        self.queue.put(task)

    def wait(self):
        self.queue.join()

    def stop(self):
        self._stop.set()
        for worker in self.workers:
            worker.join()

# การใช้งาน
tq = TaskQueue(num_workers=2)

def slow_add(a, b):
    time.sleep(0.5)
    return a + b

tq.submit(Task("t1", slow_add, (1, 2)))
tq.submit(Task("t2", slow_add, (3, 4)))
tq.submit(Task("t3", slow_add, (5, 6)))

tq.wait()
print(tq.results)
tq.stop()
```

---

### 37.32 Container Runtime

```python
import subprocess
import os

class ContainerRuntime:
    """Simple container runtime using Docker"""
    def __init__(self):
        self.containers = {}

    def run(self, image: str, command: list = None, name: str = None):
        """รัน container"""
        cmd = ["docker", "run", "-d"]
        if name:
            cmd.extend(["--name", name])
        cmd.append(image)
        if command:
            cmd.extend(command)

        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0:
            container_id = result.stdout.strip()
            self.containers[container_id] = {
                "image": image,
                "name": name,
                "status": "running"
            }
            return container_id
        else:
            raise RuntimeError(f"Failed to run container: {result.stderr}")

    def stop(self, container_id: str):
        subprocess.run(["docker", "stop", container_id])
        if container_id in self.containers:
            self.containers[container_id]["status"] = "stopped"

    def list(self):
        return self.containers

# การใช้งาน
runtime = ContainerRuntime()
# container_id = runtime.run("python:3.12-slim", ["python", "-c", "print('Hello')"])
```

---

### 37.33 Load Balancer

```python
import random
from typing import List

class LoadBalancer:
    """Simple round-robin load balancer"""
    def __init__(self, servers: List[str]):
        self.servers = servers
        self.current = 0

    def get_server(self) -> str:
        server = self.servers[self.current]
        self.current = (self.current + 1) % len(self.servers)
        return server

    def health_check(self) -> dict:
        """ตรวจสอบสถานะ servers"""
        import requests
        status = {}
        for server in self.servers:
            try:
                response = requests.get(f"{server}/health", timeout=5)
                status[server] = response.status_code == 200
            except Exception:
                status[server] = False
        return status

# การใช้งาน
lb = LoadBalancer([
    "http://server1:8000",
    "http://server2:8000",
    "http://server3:8000"
])

for _ in range(6):
    print(lb.get_server())
```

---

### 37.34 Distributed Key-Value Store

```python
import hashlib
from typing import Any, Optional

class ConsistentHash:
    """Consistent hashing for distributed systems"""
    def __init__(self, nodes: List[str] = None, replicas: int = 3):
        self.replicas = replicas
        self.ring = {}
        self.sorted_keys = []
        if nodes:
            for node in nodes:
                self.add_node(node)

    def _hash(self, key: str) -> int:
        return int(hashlib.md5(key.encode()).hexdigest(), 16)

    def add_node(self, node: str):
        for i in range(self.replicas):
            key = self._hash(f"{node}:{i}")
            self.ring[key] = node
            self.sorted_keys.append(key)
        self.sorted_keys.sort()

    def remove_node(self, node: str):
        for i in range(self.replicas):
            key = self._hash(f"{node}:{i}")
            del self.ring[key]
            self.sorted_keys.remove(key)

    def get_node(self, key: str) -> str:
        if not self.ring:
            return None
        hash_key = self._hash(key)
        for ring_key in self.sorted_keys:
            if hash_key <= ring_key:
                return self.ring[ring_key]
        return self.ring[self.sorted_keys[0]]

class DistributedKVStore:
    """Simple distributed key-value store"""
    def __init__(self, nodes: List[str]):
        self.ring = ConsistentHash(nodes)
        self.stores = {node: {} for node in nodes}

    def set(self, key: str, value: Any):
        node = self.ring.get_node(key)
        self.stores[node][key] = value
        return node

    def get(self, key: str) -> Optional[Any]:
        node = self.ring.get_node(key)
        return self.stores[node].get(key)

# การใช้งาน
kv = DistributedKVStore(["node1", "node2", "node3"])
kv.set("user:1", {"name": "Alice"})
kv.set("user:2", {"name": "Bob"})

print(kv.get("user:1"))
print(kv.get("user:2"))
```

---

### 37.35 Consensus Algorithm

```python
import random
import time

class RaftNode:
    """Simplified Raft consensus node"""
    def __init__(self, node_id: int, peers: list):
        self.node_id = node_id
        self.peers = peers
        self.state = "follower"  # follower, candidate, leader
        self.current_term = 0
        self.voted_for = None
        self.log = []
        self.commit_index = 0

    def become_candidate(self):
        self.state = "candidate"
        self.current_term += 1
        self.voted_for = self.node_id
        votes = 1  # vote for self

        for peer in self.peers:
            if random.random() > 0.3:  # จำลองการสื่อสาร
                votes += 1

        if votes > len(self.peers) // 2:
            self.become_leader()
        return votes

    def become_leader(self):
        self.state = "leader"
        print(f"Node {self.node_id} became leader for term {self.current_term}")

    def append_entry(self, command):
        if self.state != "leader":
            return False
        self.log.append({
            "term": self.current_term,
            "command": command
        })
        return True

# การจำลอง
nodes = [RaftNode(i, [j for j in range(5) if j != i]) for i in range(5)]

# เลือก leader
for node in nodes:
    if node.become_candidate() > len(nodes) // 2:
        break

# Leader append entries
leader = next((n for n in nodes if n.state == "leader"), None)
if leader:
    leader.append_entry({"action": "set", "key": "x", "value": 42})
    print(f"Log: {leader.log}")
```

---

### 37.36 Game Engine

```python
import pygame
import math

class GameEngine:
    """Simple 2D game engine"""
    def __init__(self, width=800, height=600):
        pygame.init()
        self.screen = pygame.display.set_mode((width, height))
        pygame.display.set_caption("Game Engine")
        self.clock = pygame.time.Clock()
        self.running = True
        self.entities = []
        self.gravity = 0.5

    def add_entity(self, entity):
        self.entities.append(entity)

    def update(self):
        for entity in self.entities:
            entity.update()

    def render(self):
        self.screen.fill((30, 30, 40))
        for entity in self.entities:
            entity.render(self.screen)
        pygame.display.flip()

    def run(self):
        while self.running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    self.running = False

            self.update()
            self.render()
            self.clock.tick(60)

        pygame.quit()

class Entity:
    def __init__(self, x, y, width, height, color):
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.color = color
        self.vx = 0
        self.vy = 0

    def update(self):
        self.vy += 0.5  # gravity
        self.x += self.vx
        self.y += self.vy

        # ขอบเขต
        if self.y + self.height > 600:
            self.y = 600 - self.height
            self.vy = -self.vy * 0.8

    def render(self, screen):
        pygame.draw.rect(screen, self.color, (self.x, self.y, self.width, self.height))

# การใช้งาน
# engine = GameEngine()
# engine.add_entity(Entity(100, 100, 50, 50, (255, 100, 100)))
# engine.run()
```

---

### 37.37 3D Renderer

(ดูตัวอย่างในหัวข้อ 24.33)

---

### 37.38 Video Streaming Service

```python
from fastapi import FastAPI, UploadFile, File
from fastapi.responses import StreamingResponse
import cv2
import numpy as np
import io

app = FastAPI()

@app.post("/stream/process")
async def process_video(file: UploadFile):
    """ประมวลผลวิดีโอแบบ streaming"""
    contents = await file.read()

    # บันทึกชั่วคราว
    with open("temp_video.mp4", "wb") as f:
        f.write(contents)

    # ประมวลผล
    cap = cv2.VideoCapture("temp_video.mp4")
    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    fps = cap.get(cv2.CAP_PROP_FPS)

    cap.release()

    return {
        "filename": file.filename,
        "frames": frame_count,
        "fps": fps,
        "duration": frame_count / fps if fps > 0 else 0
    }

@app.get("/stream/{video_id}")
async def stream_video(video_id: str):
    """Stream วิดีโอ"""
    def iterfile():
        with open(f"videos/{video_id}.mp4", "rb") as f:
            while chunk := f.read(1024 * 1024):
                yield chunk

    return StreamingResponse(
        iterfile(),
        media_type="video/mp4"
    )
```

---

### 37.39 VoIP Service

```python
import socket
import pyaudio
import threading

class VoIPClient:
    """Simple VoIP client using UDP"""
    def __init__(self, server_host: str, server_port: int):
        self.server = (server_host, server_port)
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.audio = pyaudio.PyAudio()
        self.running = True

    def start(self):
        # Thread สำหรับรับเสียง
        receive_thread = threading.Thread(target=self._receive)
        receive_thread.start()

        # Thread สำหรับส่งเสียง
        send_thread = threading.Thread(target=self._send)
        send_thread.start()

    def _send(self):
        stream = self.audio.open(
            format=pyaudio.paInt16,
            channels=1,
            rate=16000,
            input=True,
            frames_per_buffer=1024
        )

        while self.running:
            data = stream.read(1024)
            self.sock.sendto(data, self.server)

    def _receive(self):
        stream = self.audio.open(
            format=pyaudio.paInt16,
            channels=1,
            rate=16000,
            output=True,
            frames_per_buffer=1024
        )

        while self.running:
            data, _ = self.sock.recvfrom(2048)
            stream.write(data)

    def stop(self):
        self.running = False
        self.sock.close()
        self.audio.terminate()
```

---

### 37.40 Collaborative Editor

(ดูตัวอย่างในหัวข้อ 37.7)

---

## สรุป

หนังสือเล่ม 11 ครอบคลุมหัวข้อเฉพาะทางและโครงการฝึกปฏิบัติอย่างครบถ้วน ตั้งแต่ FinTech, Trading Bot, Blockchain, Healthcare, Bioinformatics, Geospatial, Quantum Computing ไปจนถึง AI Engineering, Prompt Engineering, AI Agent, RAG Chatbot, Recommendation System, Search Engine, SaaS และโครงการฝึกปฏิบัติอีก 40 โครงการ นักพัฒนาสามารถนำตัวอย่างโค้ดและแนวปฏิบัติไปใช้ในการสร้างโครงการจริงได้ทันที

**แหล่งอ้างอิงหลัก**:
- [Ultimate Python for Fintech Solutions – Bhagvan Kommadi](https://www.perlego.com/book/4424050) 
- [Lumibot documentation](https://pypi.org/project/lumibot/) 
- [Python 開發者的以太坊 – ethereum.org](https://ethereum.org/zh-tw/developers/docs/programming-languages/python/) 
- [Biopython documentation](https://biopython.org/) 
- [Real Python – GeoPandas Basics](https://realpython.com/geopandas/) 
- [Qiskit documentation](https://qiskit.org/) 
- [ECLYPSE: A Python Framework for Cloud-Edge Continuum](https://onlinelibrary.wiley.com) 
- [Digital Twin GitHub Repository](https://github.com/virbahu/predictive-sc-twin-v2) 
- [Pixerise – Python 3D Renderer](https://github.com/enricostara/pixerise) 
- [Playwright Python documentation](https://playwright.dev/python/) 
- [Build Your Own Simple Data Pipeline with Python and Docker – KDnuggets](https://www.kdnuggets.com/build-your-own-simple-data-pipeline-with-python-and-docker) 
- [LangChain Prompt Engineering Examples](https://github.com/ancoleman/ai-design-components) 
- [PraisonAI documentation](https://pypi.org/project/PraisonAI/) 
- [Python Recommendation Systems: Build From Scratch 2026](https://www.guvi.in) 
- [Whoosh documentation](https://whoosh.readthedocs.io/) 
- [Building a Multi-tenant App with Django – testdriven.io](https://testdriven.io) 
- [Typer documentation](https://typer.tiangolo.com/) 
- [FastAPI documentation](https://fastapi.tiangolo.com/) 
- [Strawberry documentation](https://strawberry.rocks/) 
- [Microservices Architecture – Python Implementation Pattern](https://github.com/phdsystems/software-engineering-labs) 
- [Prefect documentation](https://docs.prefect.io/) 
- [Build an ETL Pipeline with PySpark – Pluralsight](https://www.pluralsight.com) 
- [schedule documentation](https://schedule.readthedocs.io/) 
- [Kivy documentation](https://kivy.org/) 
- [paho-mqtt documentation](https://pypi.org/project/paho-mqtt/) 
- [ROS 2 documentation](https://docs.ros.org/) 
- [Pygame documentation](https://www.pygame.org/) 
- [PyBullet documentation](https://pybullet.org/) 
- [RAG Chatbot – Hugging Face](https://huggingface.co/spaces/sy77/rag-chatbot) 
- [Pulumi documentation](https://www.pulumi.com/) 
- [Acute Kidney Injury Detection System](https://gitlab.doc.ic.ac.uk)