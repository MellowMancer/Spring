from flask import Flask, render_template, request, redirect, url_for
from login import authenticate_user, app
from config import auth, db, session, app

@app.route('/assessment')
@authenticate_user
def assesment():
    print(session)
    return render_template('assessments.html')

if __name__=='__main__':
    app.run(debug=True)
