from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'




# app.config['SEND_FILE_MAX_AGE_DEFAULT'] = -1

@app.route('/api', methods=['GET'])
@cross_origin()
def returnascii():
    d = {}
    input = str(request.args['query'])
    # input = 'a'
    output = str(ord(input[0]))
    d['input'] = input
    d['ascii'] = output
    return jsonify(d)               


if __name__ == '__main__':
    app.run(debug=True)
#     host = '0.0.0.0'
#     port = 4000
#     print(f"Starting Flask app. Host: {host}, Port: {port}")
#     app.run(debug=True, host=host, port=port)
#     print("Flask app has started.")



