from flask import Flask, jsonify, request, session
from flask_cors import CORS, cross_origin
import pyrebase
import chat_gemini

# for firestore
import firebase_admin
from firebase_admin import credentials, firestore
from firebase_admin import auth


app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


@app.route("/responseMessage", methods=["GET", "POST"])
@cross_origin()
def responseMessage():
    if request.method == "POST":
        query = request.form["message"]
        response = chat_gemini.get_response(query)
        return jsonify({"response": response}), 200

    return jsonify({"response": "Sorry but there was an error in generating a message"}), 200

# def sentiment():
#     # add diary entry
#     # ref=db.collection('users').document(user['localId'])
#     # d=ref.collection('diary').document()
#     # d.set({'date': str(datetime.now().date()), 'content': 'I am feeling good today'})
#     # print(d.id)
    
#     #fetch diary entry
#     d=ref.collection('diary').document(d.id).get()
#     content=d.get('content')
#     print(sid.polarity_scores(content))
        

if __name__ == '__main__':
    # app.run(debug=True)
    # host = '0.0.0.0'
    host = '127.0.0.1'
    port = 5000
    print(f"Starting Flask app. Host: {host}, Port: {port}")
    app.run(debug=True, host=host, port=port)
    print("Flask app has started.")



