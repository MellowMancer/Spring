from flask import Flask, jsonify, request, session
from flask_cors import CORS, cross_origin
import pyrebase


app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

config = {
  'apiKey': "AIzaSyCYe3ASqwa3ahPVYy8uXYfr9K0C6i2zRVw",
  'authDomain': "spring-a-ling.firebaseapp.com",
  'projectId': "spring-a-ling",
  'storageBucket': "spring-a-ling.appspot.com",
  'messagingSenderId': "610922772594",
  'appId': "1:610922772594:web:930b5f7f06a5cfebf82aeb",
  'measurementId': "G-TG5WXBG85W",
  'databaseURL': "https://spring-a-ling-default-rtdb.asia-southeast1.firebasedatabase.app",
}

firebase=pyrebase.initialize_app(config)
auth=firebase.auth()

# for firestore
import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("spring-a-ling-firebase-adminsdk-u83lc-a9820c5450.json")
firebase_admin.initialize_app(cred)
db=firestore.client()

app.secret_key='secret'




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

@app.route('/signup', methods=['GET','POST'])
@cross_origin()
def signup():
    n=request.args.get('next')
    if request.method=='POST':
        displayName=request.form['displayName']
        name=request.form['name']
        email=request.form['email']
        password=request.form['password']
        try:
            user=auth.create_user_with_email_and_password(email,password)
            user=auth.sign_in_with_email_and_password(email,password)
            
            user['displayName']=name
            print(user)
            session['user']=email
            session['user_id']=user['localId']


            ref=db.collection('users').document(user['localId'])
            ref.set({'id':user['localId'],'name':name,'email':email,})

            return jsonify({'message': 'Signup successful'}), 200
        except Exception as e:
            return jsonify({'error': str(e)}), 400
    return jsonify({'message': 'Signup successful'}), 200            


if __name__ == '__main__':
    # app.run(debug=True)
    host = '0.0.0.0'
    port = 4000
    print(f"Starting Flask app. Host: {host}, Port: {port}")
    app.run(debug=True, host=host, port=port)
    print("Flask app has started.")



