from langchain_community.vectorstores import Chroma
from create_data import vectordb

import openai

openai.api_key = "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"




def find_match(input):
    docs = vectordb.similarity_search(input,k=5)
    concatenated_document = docs[0] 
    
    return concatenated_document

def query_refiner(conversation, query):

    response = openai.Completion.create(
    model="text-davinci-003",
    prompt=f"Given the following user query and conversation log, formulate a question that would be the most relevant to provide the user with an answer from a knowledge base.\n\nCONVERSATION LOG: \n{conversation}\n\nQuery: {query}\n\nRefined Query:",
    temperature=0.7,
    max_tokens=256,
    top_p=1,
    frequency_penalty=0,
    presence_penalty=0
    )
    return response['choices'][0]['text']
