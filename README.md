🚀 Mini-C Compiler Front-End with Web Interface

A complete compiler front-end implementation for a Mini-C language using Lex & Yacc, integrated with a Python-based web interface for user interaction.

📌 Project Overview

This project demonstrates core concepts of Compiler Design by implementing:

Lexical Analysis
Syntax Analysis
Semantic Analysis
Intermediate Code Generation
Error Detection & Recovery

Additionally, it includes a web-based frontend to make the compiler easy to use.

🏗️ System Architecture
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
⚙️ Features
🔹 Compiler Modules
✅ Lexical Analysis (token generation using Lex)
✅ Syntax Analysis (grammar parsing using Yacc)
✅ Semantic Analysis (symbol table + type checking)
✅ Intermediate Code Generation:
TAC
AST
DAG
Postfix
🔹 Error Handling
Lexical Errors (invalid tokens, illegal characters)
Syntax Errors (panic mode recovery)
Semantic Errors (type mismatch, scope issues)
Line number tracking for accurate debugging
🔹 Web Interface
Simple UI for inputting code
Displays output/errors directly
Built using:
Python (Flask)
HTML (templates)
CSS (static)
🛠️ Tech Stack
Languages: C, Python
Tools: Lex (Flex), Yacc (Bison)
Backend: Flask
Frontend: HTML, CSS
Environment: MSYS + GCC
📂 Project Structure
compiler-design/
│
├── static/
│   └── style.css              # Styling for web UI
│
├── templates/
│   └── index.html             # Frontend UI
│
├── venv/                      # Python virtual environment
│
├── app.py                     # Flask backend
│
├── lexer.l                    # Lex file (scanner)
├── parser.y                   # Yacc file (parser)
├── lex.yy.c                   # Generated scanner
├── parser.tab.c               # Generated parser
├── parser.tab.h               # Parser header
│
├── master.c / temp.c          # Core logic files
├── compiler                   # Compiled executable
│
├── input.c                    # Sample input
├── test.c / test2.c           # Test cases
├── testlexical.c              # Lexical test cases
├── testmixed.c                # Mixed tests
├── testmixedsem.c             # Semantic tests
│
├── COMPILERreport.pdf         # Project documentation
🚀 How to Run
🔹 Step 1: Setup Environment

Install:

GCC
Flex (Lex)
Bison (Yacc)
Python + Flask
🔹 Step 2: Compile Compiler
flex lexer.l
bison -d parser.y
gcc lex.yy.c parser.tab.c -o compiler
🔹 Step 3: Run Compiler (CLI)
./compiler < input.c
🔹 Step 4: Run Web Interface
python app.py

Then open:

http://localhost:5000
🧪 Testing

Tested using:

Valid Mini-C programs ✅
Invalid syntax ❌
Lexical errors ⚠️
Semantic errors ⚠️
⚠️ Challenges Faced
Setting up Lex & Yacc on Windows (MSYS)
Designing correct regex for tokenization
Handling lexical & syntax error recovery
Integrating multiple compiler phases
Building a frontend for compiler interaction
🔮 Future Improvements
Code Optimization Phase
Target Code Generation
More Grammar Rules
Better UI/UX
Deployment (Web hosting)
👥 Team Members
Ayushi Tomar
Shubham Laur
Prashant Tomar
Yashika Baliyan
📦 Repository

👉 https://github.com/Ayushi-tomar02/compiler-Design

⭐ Highlights
Full compiler front-end pipeline ✅
Lex + Yacc integration ✅
Error handling with recovery ✅
Multiple IR formats ✅
Web-based interface 🔥
