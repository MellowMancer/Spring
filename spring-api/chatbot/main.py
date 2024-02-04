from flask import Flask, render_template, request, jsonify
from flask_cors import CORS

from langchain.chat_models import ChatOpenAI
from langchain.chains import ConversationChain
from langchain.chains.conversation.memory import ConversationBufferWindowMemory

from langchain.prompts import (
    SystemMessagePromptTemplate,
    HumanMessagePromptTemplate,
    ChatPromptTemplate,
    MessagesPlaceholder
)

import utils

app = Flask(__name__)
CORS(app)

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        query = request.json["query"]

        # Create a conversation chain
        conversation = ConversationChain(
            memory=ConversationBufferWindowMemory(k=3, return_messages=True),
            prompt=ChatPromptTemplate.from_messages([
                SystemMessagePromptTemplate.from_template(template="You are a chatbot for Mental Health Awareness and how to make users feel better and you are going to answer questions mentioned in the text below, if they ask any general question or greeting reply them with greetings. You also know a lot about Mental health issues and their solutions and making anyone feel better, and you have information and you have to fetch information and give me answers. If they greet you, accept the greeting and greet them too. If they ask your name, your name is HealthAi."),
                MessagesPlaceholder(variable_name="history"),
                HumanMessagePromptTemplate.from_template(template="{input}")
            ]),
            llm=ChatOpenAI(model_name="gpt-3.5-turbo", openai_api_key="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")
        )
 
        # Get the response from the conversation chain
        response = conversation.predict(input=f"Context:\n {utils.find_match(query)} \n\n Query:\n{query}")

        return jsonify({"response": response})

    return render_template("test.html")

if __name__ == "__main__":
    app.run(debug=True)