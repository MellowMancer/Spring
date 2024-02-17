from flask import Flask, jsonify, request, session
from flask_cors import CORS, cross_origin
import pyrebase

# for firestore
import firebase_admin
from firebase_admin import credentials, firestore
from firebase_admin import auth

from langchain_openai import ChatOpenAI
from langchain.chains import ConversationChain
from langchain.chains.conversation.memory import ConversationBufferWindowMemory

from langchain.prompts import (
    SystemMessagePromptTemplate,
    HumanMessagePromptTemplate,
    ChatPromptTemplate,
    MessagesPlaceholder
)

import spacy
nlp=spacy.load('en_core_web_sm')
import nltk
nltk.download('vader_lexicon')
from nltk.sentiment.vader import SentimentIntensityAnalyzer
sid=SentimentIntensityAnalyzer()
from datetime import datetime

import utils


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



cred = credentials.Certificate("spring-api\spring-a-ling-firebase-adminsdk-u83lc-a9820c5450.json")
firebase_admin.initialize_app(cred)
db=firestore.client()

app.secret_key='secret'


# @app.route('/api', methods=['GET'])
# @cross_origin()
# def returnascii():
#     d = {}
#     input = str(request.args['query'])
#     # input = 'a'
#     output = str(ord(input[0]))
#     d['input'] = input
#     d['ascii'] = output
#     return jsonify(d)   

# @app.route('/signup', methods=['GET','POST'])
# @cross_origin()
# def signup():
#     n=request.args.get('next')
#     if request.method=='POST':
#         print(request.form)
#         displayName=request.form['displayName']
#         name=request.form['name']
#         email=request.form['email']
#         password=request.form['password']
#         try:
#             user=auth.create_user_with_email_and_password(email,password)
#             user=auth.sign_in_with_email_and_password(email,password)
            
#             user['name']=name
#             user['email']=email
#             user['displayName']=displayName
#             session['user']=email
#             session['user_id']=user['localId']


#             # ref=db.collection('users').document(user['localId'])
#             # ref.set({'id':user['localId'],'name':name,'email':email,})

#             return jsonify({'message': 'Signup successful'}), 200
#         except Exception as e:
#             return jsonify({'error': str(e)}), 400
#     return jsonify({'message': 'Signup successful'}), 200      

# @app.route('/login', methods=['GET','POST'])
# @cross_origin()
# def login():
#     n=request.args.get('next')
#     # print(n)
#     if 'user' in session:
#         return jsonify({'message': 'Already logged in'}), 200
#     if request.method=='POST':
#         email=request.form['email']
#         password=request.form['password']
#         try:
#             user=auth.sign_in_with_email_and_password(email,password)
#             session['user']=email
#             session['user_id']=user['localId']
#             print(session)
            
#             return jsonify({'message': 'Login successful'}), 200
#         except:
#             return jsonify({'error': 'Invalid credentials'}), 400
#     return jsonify({'message': 'Login successful'}), 200    

# @app.route('/editProfile', methods=['GET','POST'])
# @cross_origin()
# def update():
#     authorization = request.form["authorization"]
#     idToken = authorization.split('Bearer ')[1]
#     name=request.form['name']
#     displayName=request.form['displayName']
#     email=request.form['email']
#     print("HELLO")
#     try:
#         user=auth.get_account_info(idToken)
#         # print(session['localId'])
#         user['name']=name
#         user['displayName']=displayName
#         user['email']=email
#         # user=auth.update_user_info(idToken, user)
#         ref.update({'name':name, 'email':email, 'displayName':displayName})
#         return jsonify({'message': 'Update Successful'}), 200
#     except Exception as e:
#         return jsonify({'error': e}), 400


@app.route("/responseMessage", methods=["GET", "POST"])
@cross_origin()
def responseMessage():
    if request.method == "POST":
        query = request.form["message"]
        # Create a conversation chain
        conversation = ConversationChain(
            memory=ConversationBufferWindowMemory(k=3, return_messages=True),
            prompt=ChatPromptTemplate.from_messages([
                SystemMessagePromptTemplate.from_template(template="You are a chatbot for Mental Health Awareness and how to make users feel better and you are going to answer questions mentioned in the text below. You also know a lot about Mental health issues and their solutions and making anyone feel better, and you have information and you have to fetch information and give me answers. If they ask your name, your name is Springy. Do not give any medical advice, just general information and make them feel better. Dont respond in more than 30 words unless the user asks for advice"),
                MessagesPlaceholder(variable_name="history"),
                HumanMessagePromptTemplate.from_template(template="{input}")
            ]),
            llm=ChatOpenAI(model_name="gpt-3.5-turbo", openai_api_key="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")
        )
 
        # Get the response from the conversation chain
        response = conversation.predict(input=f"Context:\n {utils.find_match(query)} \n\n Query:\n{query}")
        return jsonify({"response": response}), 200

    return jsonify({"response": "Sorry but there was an error in generating a message"}), 200

def sentiment():
    # add diary entry
    # ref=db.collection('users').document(user['localId'])
    # d=ref.collection('diary').document()
    # d.set({'date': str(datetime.now().date()), 'content': 'I am feeling good today'})
    # print(d.id)
    
    #fetch diary entry
    d=ref.collection('diary').document(d.id).get()
    content=d.get('content')
    print(sid.polarity_scores(content))
        

if __name__ == '__main__':
    # app.run(debug=True)
    host = '127.0.0.1'
    port = 5000
    print(f"Starting Flask app. Host: {host}, Port: {port}")
    app.run(debug=True, host=host, port=port)
    print("Flask app has started.")



