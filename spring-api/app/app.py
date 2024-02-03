from flask import Flask, render_template, request, redirect, session, url_for
from flask_cors import CORS, cross_origin
from functools import wraps
from flask import jsonify
#for real-time database
import pyrebase

app=Flask(__name__)
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

cred = credentials.Certificate("spring-api\spring-a-ling-firebase-adminsdk-u83lc-a9820c5450.json")
firebase_admin.initialize_app(cred)
db=firestore.client()

app.secret_key='secret'

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

def authenticate_user(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user' in session:
            return f(*args, **kwargs)
        n=request.url
        n=n.split('/')
        print(n)
        print('Decorated function')
        # return redirect(url_for('login', next=n[-1]))
        return render_template('login.html', next=n[-1])
    return decorated_function

@app.route('/login', methods=['GET','POST'])
@cross_origin()
def login():
    n=request.args.get('next')
    # print(n)
    if 'user' in session:
        if type(n)==str:
            return redirect(url_for(n))
        return redirect(url_for('profile'))
    if request.method=='POST':
        email=request.form['email']
        password=request.form['password']
        try:
            user=auth.sign_in_with_email_and_password(email,password)
            session['user']=email
            session['user_id']=user['localId']
            print(session)
            if type(n)==str:
                print('True')
                return redirect(request.url_root+n)
            else:
                return redirect(url_for('profile'))
            # return render_template('profile.html',user=session['user'])
        except:
            return ('Username or password is incorrect')
    return render_template('login.html')

@app.route('/signup', methods=['GET','POST'])
@cross_origin()
def signup():
    n=request.args.get('next')
    print(n)
    if request.method=='POST':
        displayName=request.form['displayName']
        name=request.form['name']
        email=request.form['email']
        password=request.form['password']
        try:
            user=auth.create_user_with_email_and_password(email,password)
            user=auth.sign_in_with_email_and_password(email,password)
            # auth.send_email_verification(user['idToken'])
            user['displayName']=name
            session['user']=email
            session['user_id']=user['localId']
            # ref=db.collection('users').document(user['localId'])
            # ref.set({'name':name,'email':email,'id':user['localId']})
            # if type(n)==str:
            #     print('True')
            #     return redirect(request.url_root+n)
            # else:
            #     return redirect(url_for('profile'))
            return jsonify({'message': 'Signup successful'}), 200
        except Exception as e:
            return jsonify({'error': str(e)}), 400
    return jsonify({'message': 'Signup successful'}), 200

@app.route('/profile')
@cross_origin()
@authenticate_user
def profile():
    return render_template('profile.html', user=session['user'])

@app.route('/logout')
@cross_origin()
@authenticate_user
def logout():
    session.clear()
    # return redirect(url_for('index'))
    return redirect('/login')

@app.route('/assessment')
@cross_origin()
@authenticate_user
def assesment():
    return render_template('assessment.html')

if __name__=='__main__':
    app.run(debug=True)