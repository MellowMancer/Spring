from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma




data = "Mental health encompasses an individual's emotional, psychological, and social well-being, influencing how they think, feel, and act in various aspects of life. Organizations dedicated to mental health advancement employ a range of initiatives to support individuals facing mental health challenges. These include appointing professionals like psychologists and counselors to oversee programs and provide support, implementing national mental health programs, and offering telepsychiatry and online counseling services for remote access to mental health professionals. Preventive measures and awareness campaigns are prioritized to reduce stigma and promote early intervention, while community mental health centers ensure localized access to services. Innovation in treatment approaches, such as therapies and interventions, is continuously pursued, along with promoting well-being through activities like mindfulness and physical exercise. Specialized support for specific groups and digital mental health platforms enhance accessibility and cater to diverse needs. Education and research institutes foster expertise and innovation in mental health science, while global collaboration and partnerships facilitate knowledge exchange and comprehensive approaches. Crisis helplines provide immediate support, and technology aids in monitoring and intervention. Workplace mental health programs and advocacy for policy changes further promote mental well-being on societal levels. Overall, the holistic approach to mental health integrates physical, social, and environmental factors, aiming to create a supportive environment and resilient communities for individuals to thrive mentally and emotionally."
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