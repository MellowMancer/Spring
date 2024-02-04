from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.vectorstores import Chroma



with open("C:\\Users\\hp\\OneDrive - FCRIT\\Hackathons\\Google Solution Challenge\\Spring\\OpenAI (NOT USING)\\text(1).txt") as f:
    data = f.read()
text_splitter = RecursiveCharacterTextSplitter(
    # Set a really chunk size
    chunk_size = 750,
    chunk_overlap  = 20,
    length_function = len,
    is_separator_regex = False,
)
texts = text_splitter.create_documents([data])

#open ai key


OPENAI_API_KEY = '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'

openai_api_key=OPENAI_API_KEY


embeddings = OpenAIEmbeddings(openai_api_key=OPENAI_API_KEY)



persist_directory = 'docs/chroma/'

# Create the vector store
global vectordb
vectordb = Chroma.from_documents(
    documents=texts,
    embedding=embeddings,
    persist_directory=persist_directory
)

print(vectordb._collection.count())