from flask import Flask, render_template, request
import subprocess
import os

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/compile', methods=['POST'])
def compile_code():
    code = request.form['code']
    choice = request.form['choice']

    # Save code to temp file
    with open("temp.c", "w") as f:
        f.write(code)

    try:
        result = subprocess.run(
            ["./compiler", choice],
            input=code,
            text=True,
            capture_output=True
        )
        output = result.stdout
    except Exception as e:
        output = str(e)

    return output

if __name__ == '__main__':
    app.run(debug=True)