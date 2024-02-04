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
        try:
            a=auth.get_account_info(session['idToken'])
            return f(*args, **kwargs)
        except:
            if 'user' in session:
                ref=db.collection('users').document(session['localId']).delete()
                session.clear()

        n=request.url
        n=n.split('/')
        return render_template('login.html', next=n[-1])
    return decorated_function

@app.route('/login', methods=['GET','POST'])
@cross_origin()
def login():
    n=request.args.get('next')

    if 'user' in session:
        if type(n)==str:
            return redirect(request.url_root+n)
        return redirect(url_for('profile'))
    
    if request.method=='POST':
        email=request.form['email']
        password=request.form['password']
        try:
            user=auth.sign_in_with_email_and_password(email,password)
            a=auth.get_account_info(user['idToken'])
            print('login')
            print(a)
            if a['users'][0]['emailVerified']==False:
                if type(n)==str:
                    return "Email not verified. Please verify your email to <a href='/login?next="+n+"'>login</a>."
                else:
                    return "Email not verified. Please verify your email to <a href='/login'>login</a>."
            else :
                session['user']=email
                session['localId']=user['localId']
                session['idToken']=user['idToken']
                ref=db.collection('users').document(user['localId'])
                ref.set({'id':user['localId'], 'name':session['username'],'email':email})
                if type(n)==str:
                    return redirect(request.url_root+n)
                else:
                    return redirect(url_for('profile'))
        except:
            return "Couldn't login please check your credentials or signup"
    return render_template('login.html', next=n)

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
            auth.send_email_verification(user['idToken'])
            session['username']=name
            if type(n)==str:
                return "Email not verified. Please verify your email to <a href='/login?next="+n+"'>login</a>."
            else:
                # return redirect(url_for('profile'))
                return "Email not verified. Please verify your email to <a href='/login'>login</a>."
        except:
            return 'The email already exists'
    return render_template('signup.html', next=n)

<<<<<<< HEAD
=======
@app.route('/profile')
@cross_origin()
@authenticate_user
def profile():
    return render_template('profile.html', user=session['user'])

>>>>>>> 3972b8e848a981889ff1548946f96d5ffbddb70f
@app.route('/logout')
@cross_origin()
@authenticate_user
def logout():
    print('logout')
    a=auth.get_account_info(session['idToken'])
    print(a)
    session.clear()
    return redirect('/login')

@app.route('/forgot', methods=['GET','POST'])
def forgot_password():
    email=request.args.get('email')
    if 'user' not in session:
        auth.send_password_reset_email(email)
        return 'Password reset email sent'
    else:
        return 'You are already logged in'

@app.route('/profile')
@authenticate_user
def profile():
    data=db.collection('users').document(session['localId']).get()
    data=data.to_dict()
    print(data)
    return render_template('profile.html', name=data['name'], email=data['email'])

@app.route('/edit-profile', methods=['GET','POST'])
@authenticate_user
def editProfile():
    name=request.form['name']
    email=request.form['email']
    ref=db.collection('users').document(session['localId'])
    ref.update({'name':name, 'email':email})
    return {'name':name, 'email':email}

@app.route('/delete-user', methods=['GET','POST'])
@authenticate_user
def deleteUser():
    auth.delete_user(session['idToken'])
    a=auth.get_account_info(session['idToken'])
    print('delete')
    print(a)
    # ref=db.collection('users').document(session['localId']).delete()
    # session.clear()
    return redirect(url_for('login'))   

@app.route('/assessment')
@cross_origin()
@authenticate_user
def assesment():
    return render_template('assessments.html')

if __name__=='__main__':
    app.run(debug=True)