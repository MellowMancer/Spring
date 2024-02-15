from flask import render_template, request, redirect, url_for
from login import authenticate_user, app, session
from config import auth, db

@app.route('/assessment')
@authenticate_user
def assesment():
    print(session)
    return render_template('assessments.html')

if __name__=='__main__':
    app.run(debug=True)