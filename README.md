# 🚀 Mini-C Compiler Front-End with Web Interface

A complete compiler front-end implementation for a Mini-C language using **Lex & Yacc**, integrated with a **Python-based web interface** for user interaction.

---

## 📌 Project Overview

This project demonstrates core concepts of Compiler Design by implementing:

- Lexical Analysis  
- Syntax Analysis  
- Semantic Analysis  
- Intermediate Code Generation  
- Error Detection & Recovery  

Additionally, it includes a web-based frontend to make the compiler easy to use.

---

## 🏗️ System Architecture
```
User Input (Web UI / File)
↓
Preprocessing
↓
Lexical Analyzer (Lex)
↓
Syntax Analyzer (Yacc)
↓
Semantic Analyzer
↓
IR Generator (AST / DAG / TAC / Postfix)
↓
Output (Errors / IR)
```

## ⚙️ Features

### 🔹 Compiler Modules
- ✅ Lexical Analysis (token generation using Lex)
- ✅ Syntax Analysis (grammar parsing using Yacc)
- ✅ Semantic Analysis (symbol table + type checking)
- ✅ Intermediate Code Generation:
  - TAC
  - AST
  - DAG
  - Postfix

---

### 🔹 Error Handling
- Lexical Errors (invalid tokens, illegal characters)
- Syntax Errors (panic mode recovery)
- Semantic Errors (type mismatch, scope issues)
- Line number tracking for accurate debugging

---

### 🔹 Web Interface
- Simple UI for inputting code
- Displays output/errors directly
- Built using:
  - Python (Flask)
  - HTML (templates)
  - CSS (static)

---

## 🛠️ Tech Stack

- Language: C, Python  
- Tools: Lex (Flex), Yacc (Bison)  
- Backend: Flask  
- Frontend: HTML, CSS  
- Environment: MSYS + GCC  

---

## 📂 Project Structure

```
compiler-design/
├── static/
│   └── style.css
├── templates/
│   └── index.html
├── venv/
├── app.py
├── lexer.l
├── parser.y
├── lex.yy.c
├── parser.tab.c
├── parser.tab.h
├── master.c
├── temp.c
├── compiler
├── input.c
├── test.c
├── test2.c
├── testlexical.c
├── testmixed.c
├── testmixedsem.c
├── COMPILERreport.pdf
```

## 🚀 How to Run

### 1️⃣ Setup Environment

Install the following:
- GCC  
- Flex (Lex)  
- Bison (Yacc)  
- Python + Flask  

---

### 2️⃣ Compile the Compiler
```
flex lexer.l
bison -d parser.y
gcc lex.yy.c parser.tab.c -o compiler
```
---

### 3️⃣ Run Compiler (CLI)
```
./compiler < input.c
```

---

### 4️⃣ Run Web Interface
```
python app.py
```

Open in browser:
```
http://localhost:5000
```

---

## 🧪 Testing

Tested with:
- Valid Mini-C programs  
- Invalid syntax  
- Lexical errors  
- Semantic errors  

---

## ⚠️ Challenges Faced

- Setting up Lex & Yacc on Windows (MSYS)
- Designing correct regular expressions
- Handling error recovery
- Integrating compiler phases
- Building a frontend interface

---

## 🔮 Future Work

- Code Optimization Phase  
- Target Code Generation  
- More Grammar Rules  
- UI Improvements  

---

## 👥 Team Members

- Ayushi Tomar  
- Shubham Laur  
- Prashant Tomar  
- Yashika Baliyan  

---

## 📦 Repository

https://github.com/Ayushi-tomar02/compiler-Design

---

## ⭐ Highlights

- Full compiler front-end pipeline  
- Lex + Yacc integration  
- Error handling with recovery  
- Multiple IR formats  
- Web-based interface  

---

## 📜 License

This project is developed for academic purposes under Compiler Design (T099).
