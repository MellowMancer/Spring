from flask import Flask, render_template, request, redirect, session, url_for
from flask_cors import CORS, cross_origin
#for real-time database
import pyrebase

app=Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

config = {
  'apiKey': "AIzaSyCYe3ASqwa3ahPVYy8uXYfr9K0C6i2zRVw",
  'authDomain': "spring-a-ling.firebaseapp.com",
  'databaseURL': "https://spring-a-ling-default-rtdb.asia-southeast1.firebasedatabase.app",
  'projectId': "spring-a-ling",
  'storageBucket': "spring-a-ling.appspot.com",
  'messagingSenderId': "610922772594",
  'appId': "1:610922772594:web:930b5f7f06a5cfebf82aeb",
  'measurementId': "G-TG5WXBG85W"
}

firebase=pyrebase.initialize_app(config)
auth=firebase.auth()

# for firestore
import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("spring-api\spring-a-ling-firebase-adminsdk-u83lc-a9820c5450.json")
firebase_admin.initialize_app(cred)
db=firestore.client()

# #enter data
# d1={'name':'Tanisha','age':20}
# d2={'name':'Tanisha','age':21}

# #to add data
# doc_ref=db.collection('users').document('user1')
# doc_ref.set(d1)

# #to retrieve data
# docs=db.collection('users').stream()
# for doc in docs:
#     print(doc.id)
#     print(doc.to_dict())

@app.route('/login', methods=['GET','POST'])
@cross_origin()
def index():
    if 'user' in session:
        return render_template('profile.html', user=session['user'])
    if request.method=='POST':
        email=request.form['email']
        password=request.form['password']
        try:
            user=auth.sign_in_with_email_and_password(email,password)
            session['user']=email
            # return redirect(url_for('profile'))
            print(user.uid)
            print()
            return render_template('profile.html',user=session['user'], id=user['idToken'])
        except:
            return 'Please check your credentials'
    return render_template('home.html')

@app.route('/signup', methods=['GET','POST'])
@cross_origin()
def signup():
    # if 'user' in session:
    #     return render_template('profile.html', user=session['user'])
    if request.method=='POST':
        email=request.form['email']
        password=request.form['password']
        try:
            user=auth.create_user_with_email_and_password(email,password)
            user=auth.sign_in_with_email_and_password(email,password)
            # auth.send_email_verification(user['idToken'])
            session['user']=email
            print(user.uid)
            print()
            return render_template('profile.html', user=email)
        except:
            return 'The email already exists'
    return render_template('signup.html')

@app.route('/profile')
@cross_origin()
def profile():
    return render_template('profile.html')

@app.route('/logout')
@cross_origin()
def logout():
    session.pop('user')
    # return redirect(url_for('index'))
    return redirect('/login')

if __name__=='__main__':
    app.run(debug=True)