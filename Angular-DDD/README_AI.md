การใช้ **TypeScript** ร่วมกับ **Clean Architecture** และ **Domain-Driven Design (DDD)** บน **AngularJS (1.x)** เป็นสิ่งที่ทำได้จริง แม้ AngularJS จะถูกออกแบบมาก่อนยุค TypeScript แต่ด้วย Dependency Injection (DI) ที่แข็งแกร่งของมัน ทำให้เราสามารถแยกชั้น (Layers) ตามหลัก Clean Architecture ได้อย่างสวยงาม

แนวทางนี้จะช่วยให้โค้ดของคุณ **ไม่ผูกติดกับเฟรมเวิร์ก (Framework-agnostic)** สามารถย้ายไป Angular สมัยใหม่หรือ React ได้ง่ายในอนาคต

ด้านล่างคือ **คู่มือการประยุกต์ใช้** แบบ Step-by-step พร้อมโครงสร้างโฟลเดอร์และโค้ดตัวอย่าง โดยใช้บริบท **Chatbot (OpenCode 3 Accounts)** เดิมของเรา

---

### 1. โครงสร้างโปรเจกต์ (Project Structure)

```text
src/
├── domain/                           # ชั้นหลัก (ไม่ขึ้นกับอะไรเลย)
│   ├── entities/                     # Entity หลัก
│   │   └── Message.ts
│   ├── aggregates/                   # Aggregate Root
│   │   └── ChatSession.ts
│   ├── value-objects/                # Value Objects
│   │   └── AccountId.ts
│   └── repositories/                 # Interface สำหรับชั้นนอก
│       └── IChatRepository.ts
│
├── application/                      # Use Cases ( orchestrator )
│   └── usecases/
│       └── SendMessageUseCase.ts
│
├── infrastructure/                   # ชั้นนอก (Implementation)
│   ├── services/
│   │   └── OpenCodeApiRepository.ts  # implements IChatRepository
│   └── config/
│       └── AccountConfig.ts
│
└── presentation/                     # ชั้น UI (AngularJS)
    ├── controllers/
    │   └── ChatController.ts
    └── module/
        └── app.module.ts             # ลงทะเบียน DI ของ AngularJS
```

---

### 2. การตั้งค่า TypeScript (`tsconfig.json`)

ต้องคอมไพล์ TypeScript เป็น JavaScript (ES5) เพื่อให้ AngularJS ทำงานได้

```json
{
  "compilerOptions": {
    "target": "ES5",
    "module": "CommonJS",
    "strict": true,
    "esModuleInterop": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "lib": ["ES6", "DOM"]
  },
  "include": ["src/**/*"]
}
```

---

### 3. ชั้น Domain (ใจกลางระบบ)

ที่นี่จะไม่มี `$http`, `$scope` หรืออะไรที่เกี่ยวกับ AngularJS เลย มีแต่ Business Logic ล้วนๆ

**`domain/entities/Message.ts`** (Entity พื้นฐาน)
```typescript
export class Message {
  constructor(
    public readonly role: 'user' | 'assistant' | 'system',
    public readonly content: string,
    public readonly timestamp: Date = new Date()
  ) {}

  // Business Rule: ข้อความต้องไม่ว่าง
  public isValid(): boolean {
    return this.content.trim().length > 0;
  }
}
```

**`domain/aggregates/ChatSession.ts`** (Aggregate Root - ดูแลความถูกต้องของแชท)
```typescript
import { Message } from '../entities/Message';

export class ChatSession {
  private _messages: Message[] = [];

  constructor(public readonly sessionId: string) {}

  public addMessage(message: Message): void {
    if (!message.isValid()) {
      throw new Error('ไม่สามารถเพิ่มข้อความว่างได้');
    }
    this._messages.push(message);
  }

  public getMessages(): Message[] {
    return [...this._messages]; // ป้องกันการแก้ไขจากภายนอก
  }

  public getLastUserMessage(): Message | undefined {
    return [...this._messages].reverse().find(m => m.role === 'user');
  }
}
```

**`domain/repositories/IChatRepository.ts`** (Interface สำหรับ Infrastructure)
```typescript
import { Message } from '../entities/Message';

export interface IChatRepository {
  // ส่งข้อความประวัติทั้งหมดไปให้ AI แล้วรับคำตอบกลับ
  sendMessage(accountId: string, messages: Message[]): Promise<Message>;
}
```

---

### 4. ชั้น Application (Use Cases)

ชั้นนี้จะสั่งงาน Domain และเรียก Repository ผ่าน Interface (ไม่รู้ว่าข้างนอกเป็นอย่างไร)

**`application/usecases/SendMessageUseCase.ts`**
```typescript
import { IChatRepository } from '../../domain/repositories/IChatRepository';
import { ChatSession } from '../../domain/aggregates/ChatSession';
import { Message } from '../../domain/entities/Message';

export class SendMessageUseCase {
  // รับ Interface มา ไม่รับ Implementation โดยตรง (Dependency Inversion)
  constructor(private chatRepository: IChatRepository) {}

  public async execute(
    accountId: string,
    session: ChatSession,
    userInput: string
  ): Promise<string> {
    // 1. สร้าง Entity ใหม่ตาม Business Logic
    const userMessage = new Message('user', userInput);
    
    // 2. เพิ่มเข้า Aggregate (Domain จะตรวจสอบความถูกต้องเอง)
    session.addMessage(userMessage);

    // 3. ดึงประวัติทั้งหมดเพื่อส่งให้ AI
    const history = session.getMessages();

    // 4. เรียก Repository (Infrastructure) เพื่อส่ง API
    const assistantMessage = await this.chatRepository.sendMessage(accountId, history);

    // 5. บันทึกคำตอบของ AI กลับเข้า Session
    session.addMessage(assistantMessage);

    // 6. ส่งเฉพาะเนื้อหากลับไปแสดงผลที่ UI
    return assistantMessage.content;
  }
}
```

---

### 5. ชั้น Infrastructure (Implementation จริง)

ชั้นนี้จะ Implement Repository ที่ประกาศไว้ใน Domain โดยใช้ `$http` ของ AngularJS

**`infrastructure/config/AccountConfig.ts`** (ข้อมูล 3 บัญชี)
```typescript
export interface IAccount {
  id: string;
  name: string;
  apiKey: string;
}

export const ACCOUNT_LIST: IAccount[] = [
  { id: 'acc-1', name: 'บัญชี A', apiKey: 'sk-aaaa' },
  { id: 'acc-2', name: 'บัญชี B', apiKey: 'sk-bbbb' },
  { id: 'acc-3', name: 'บัญชี C', apiKey: 'sk-cccc' },
];
```

**`infrastructure/services/OpenCodeApiRepository.ts`** (Implement IChatRepository)
```typescript
import { IChatRepository } from '../../domain/repositories/IChatRepository';
import { Message } from '../../domain/entities/Message';
import { IAccount, ACCOUNT_LIST } from '../config/AccountConfig';

// ใช้ Decorator เพื่อบอก AngularJS ว่าให้ Inject อะไรบ้าง (จำเป็น)
export class OpenCodeApiRepository implements IChatRepository {
  // ประกาศ static $inject เพื่อให้ minification ทำงานได้
  public static $inject = ['$http'];

  constructor(private $http: ng.IHttpService) {}

  async sendMessage(accountId: string, messages: Message[]): Promise<Message> {
    // ค้นหา Account
    const account = ACCOUNT_LIST.find(acc => acc.id === accountId);
    if (!account) throw new Error('ไม่พบบัญชีนี้');

    // แปลง Message Entity เป็น JSON Payload
    const payload = {
      model: 'opencode/big-pickle',
      messages: messages.map(m => ({ role: m.role, content: m.content })),
      temperature: 0.7,
    };

    try {
      const response = await this.$http({
        method: 'POST',
        url: 'https://api.opencode.ai/v1/chat/completions', // ปรับ URL จริง
        headers: {
          'Authorization': `Bearer ${account.apiKey}`,
          'Content-Type': 'application/json',
        },
        data: payload,
      }).toPromise(); // แปลง $q Promise เป็น async/await

      const replyContent = response.data.choices[0].message.content;
      
      // สร้าง Entity Message ใหม่สำหรับผู้ช่วย (Assistant)
      return new Message('assistant', replyContent);
    } catch (error) {
      console.error('API Error:', error);
      throw new Error('เรียก API ไม่สำเร็จ');
    }
  }
}
```

---

### 6. ชั้น Presentation (AngularJS Controllers)

Controller จะเหลือแค่รับ Event จาก UI แล้วส่งต่อ Use Case โดยไม่มีการยุ่งกับ Business Logic

**`presentation/controllers/ChatController.ts`**
```typescript
import { SendMessageUseCase } from '../../application/usecases/SendMessageUseCase';
import { ChatSession } from '../../domain/aggregates/ChatSession';
import { ACCOUNT_LIST } from '../../infrastructure/config/AccountConfig';

export class ChatController {
  // ให้ AngularJS DI จัดการ Injection
  public static $inject = ['$scope', 'SendMessageUseCase'];

  public messages: { role: string; content: string }[] = [];
  public userInput: string = '';
  public isLoading: boolean = false;
  public selectedAccountId: string = ACCOUNT_LIST[0].id;
  public accountList = ACCOUNT_LIST;

  private session: ChatSession;

  constructor(
    private $scope: ng.IScope,
    private sendMessageUseCase: SendMessageUseCase
  ) {
    // สร้าง Session ใหม่ (ID อาจจะมาจาก Route)
    this.session = new ChatSession('session-123');
  }

  public async send() {
    if (!this.userInput.trim() || this.isLoading) return;

    // แสดงข้อความผู้ใช้ทันที (Optimistic UI)
    this.messages.push({ role: 'user', content: this.userInput });
    const input = this.userInput;
    this.userInput = '';
    this.isLoading = true;

    try {
      // เรียก Use Case (ไม่ต้องรู้ว่าข้างในเรียก API ยังไง)
      const assistantReply = await this.sendMessageUseCase.execute(
        this.selectedAccountId,
        this.session,
        input
      );

      // แสดงข้อความตอบกลับ
      this.messages.push({ role: 'assistant', content: assistantReply });
    } catch (error: any) {
      alert('เกิดข้อผิดพลาด: ' + error.message);
    } finally {
      this.isLoading = false;
      this.$scope.$applyAsync(); // อัปเดต UI
    }
  }
}
```

---

### 7. การประกอบร่างด้วย AngularJS Module (Inversion of Control)

ขั้นตอนสำคัญคือการนำคลาสต่างๆ ไปจดทะเบียนในระบบ DI ของ AngularJS โดยใช้ Factory Pattern

**`presentation/module/app.module.ts`**
```typescript
import * as angular from 'angular';

// 1. Import ชั้น Infrastructure
import { OpenCodeApiRepository } from '../../infrastructure/services/OpenCodeApiRepository';
// 2. Import ชั้น Application
import { SendMessageUseCase } from '../../application/usecases/SendMessageUseCase';
// 3. Import Controller
import { ChatController } from '../controllers/ChatController';

// สร้าง AngularJS Module
const app = angular.module('chatbotApp', []);

// --- การลงทะเบียน DI (Manual Factory) ---

// ลงทะเบียน Repository (Infrastructure)
app.factory('IChatRepository', ['$http', ($http: ng.IHttpService) => {
  return new OpenCodeApiRepository($http);
}]);

// ลงทะเบียน Use Case (Application) โดย Inject Interface ที่ประกาศไว้
app.factory('SendMessageUseCase', ['IChatRepository', (repo: any) => {
  return new SendMessageUseCase(repo);
}]);

// ลงทะเบียน Controller
app.controller('ChatController', ChatController);

export default app;
```

---

### 8. สรุปข้อดีของแนวทางนี้ (ประโยชน์ที่ได้)

| หลักการ | การประยุกต์ใช้กับโค้ดของเรา |
| :--- | :--- |
| **Domain-Driven Design (DDD)** | เรามี `ChatSession` Aggregate ที่คอยตรวจสอบข้อความว่าง และ `Message` Entity ที่ไม่ขึ้นกับเฟรมเวิร์ก ทำให้ Business Logic อยู่ตรงกลาง |
| **Clean Architecture** | เส้นลูกศร Dependency ชี้เข้าหา **Domain** เสมอ (Controller -> Use Case -> Repository Interface <- Repository Implementation) ทำให้เราสามารถเปลี่ยนจาก `$http` เป็น `Fetch` หรือเปลี่ยนโมเดล AI ได้ โดยไม่ต้องแก้ Use Case หรือ Domain |
| **Separation of Concerns** | UI (Controller) ไม่รู้ว่ามีบัญชี 3 บัญชีอยู่ที่ไหน หรือ API ส่งยังไง มันรู้แค่ว่าต้องเรียก `sendMessageUseCase.execute()` |
| **Testability** | คุณสามารถทดสอบ `SendMessageUseCase` โดยส่ง `Mock` Repository เข้าไป โดยไม่ต้องเปิดเว็บเบราว์เซอร์เลย |

---

### ⚠️ ข้อควรระวังสำหรับ AngularJS + TypeScript

1. **Minification**: ต้องประกาศ `public static $inject` ทุกคลาสที่ต้องการ DI เสมอ (ดังตัวอย่าง)
2. **Build Tool**: ต้องมีตัวแปลง (เช่น Webpack, Gulp) เพื่อรวมไฟล์และแปลง TypeScript เป็น JavaScript ก่อนรันใน Browser
3. **`this` Context**: ใน AngularJS Controller ถ้าใช้ `async/await` หรือ `.then` ต้องระวังการผูก `this` (ใช้ Arrow Function หรือ `bind`)

 