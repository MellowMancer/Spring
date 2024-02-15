from flask import Flask, render_template, request, redirect, url_for, session
from google.cloud.firestore_v1 import FieldFilter
from functools import wraps
from config import auth, db, firebase_admin

app=Flask(__name__)
app.secret_key='secret'

def authenticate_user(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        try:
            a=auth.get_account_info(session['idToken'])
            print('Returning function')
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
            else:
                session['user']=email
                session['localId']=user['localId']
                session['idToken']=user['idToken']
                ref=db.collection('users').document(session['localId'])
                ref.set({'id':user['localId'], 'name':session['username'],'email':email})
                print(ref.get().to_dict())
                print('saved')
                if type(n)==str:
                    return redirect(request.url_root+n)
                else:
                    return redirect(url_for('profile'))
        except:
            return "Couldn't login please check your credentials or signup"
    return render_template('login.html', next=n)

@app.route('/signup', methods=['GET','POST'])
def signup():
    n=request.args.get('next')
    if request.method=='POST':
        name=request.form['name']
        email=request.form['email']
        password=request.form['password']
        try:
            user=auth.create_user_with_email_and_password(email,password)
            auth.send_email_verification(user['idToken'])
            # user=auth.sign_in_with_email_and_password(email,password)
            session['username']=name
            # print(user)
            if type(n)==str:
                return "Email not verified. Please verify your email to <a href='/login?next="+n+"'>login</a>."
            else:
                # return redirect(url_for('profile'))
                return "Email not verified. Please verify your email to <a href='/login'>login</a>."
        except:
            return 'The email already exists'
    return render_template('signup.html', next=n)

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
    print('profile')
    print(data)
    return render_template('profile.html', name=data['name'], email=data['email'])
    return render_template('profile.html')

@app.route('/logout')
@authenticate_user
def logout():
    session.clear()
    return redirect('/login')

@app.route('/delete-user')
@authenticate_user
def delete_user():
    firebase_admin.auth.delete_user(session['idToken'])
    ref=db.collection('users').document(session['localId']).delete()
    session.clear()
    return redirect('/login')

@app.route('/current-user')
def current_user():
    if 'user' in session:
        return session['localId']
    return None