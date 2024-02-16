# for real-time database
import pyrebase

config={
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
#     print()