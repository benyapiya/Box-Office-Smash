from textblob import TextBlob
from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route("/exec_ml", methods=['GET','POST'])
def exec_ml():
    input = request.args.get('input')
    out_str = "here is output and here is input" + input
    return out_str


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)