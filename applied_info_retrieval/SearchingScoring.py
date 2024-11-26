import spacy, zipfile, os
from nltk.stem import PorterStemmer
from BuildIndex import build_index, ChainHashMap

partial_scores = {}
positions = {}

def cosine(d, q):
    dot = sum(d[i] * q[i] for i in range(len(d)))
    mag_1 = sum(d[i] ** 2 for i in range(len(d))) ** 0.5
    mag_2 = sum(q[i] ** 2 for i in range(len(q))) ** 0.5
    if mag_1 == 0 or mag_2 == 0:
        return 0
    return dot / (mag_1 * mag_2)

def tfidf(data, doc, doc_num, total_docs): #word, doc, doc_count, term_count
    #data: [('ball', [...])], doc: full text, doc_num: index of text, total_docs: total number of docs
    term, info = data[0], data[1][0]
    info = info.split(';')
    docnum, count, positions = info[0], info[1], info[2]
    poslist = positions.split(';')
    if doc_num == 0:
        docposlist = poslist
        doc = str(doc)
    else: # 
        with open(doc, 'r', errors='ignore') as f:
            doc = f.read()
        doc_num = doc_num.split(':')[0]
        docposlist = positions.split(';')
    term_count = len(poslist) #number of docs the term appears in
    tf = len(docposlist) / len(doc.split())
    idf = (total_docs / term_count) ** 0.5
    return tf * idf

# hashmap = ChainHashMap()
stemmer = PorterStemmer()
def scorer(query, total_docs, docdict, hashmap):
    query_tfidf = []
    doctfidf = {}
    query_index = 0
    for word in query:
        if not word.is_stop and word.is_alpha:
            word = stemmer.stem(word.text)
            data = hashmap.get(word)
            if data is not None: #[('ball', [...])]
                query_tfidf.append(tfidf(data, query, 0, total_docs))
                
                for i in data[1][0].split(';'):
                    text = docdict[i[0]]
                    tfidf_score = tfidf(data, text, i, total_docs)
                    if i.split(':')[0][query_index] in doctfidf:
                        doctfidf[i.split(':')[0]][query_index] = tfidf_score
                    else:
                        doctfidf[i.split(':')[0]] = {query_index: [tfidf_score]}
                    print('balls')
        query_index += 1
    for doc in doctfidf:
        partial_scores[doc] = cosine(doctfidf[doc], query_tfidf)
    return partial_scores
                

# def scorer(word):
#     data = word[1][0]
#     docdata = data.split(';')
#     for data in docdata:
#         data = data.split(':')

#         doc, score = data[0], data[1]
#         try:
#             partial_scores[doc] += int(score)
#         except:
#             partial_scores[doc] = int(score)
#         pos = data[2].split(',')
#         if doc not in positions:
#             positions[doc] = [pos]
#         else:
#             for k in positions[doc]:
#                 min_distance = min(abs(int(l) - int(p)) for p in pos for l in k)
#                 if min_distance > 0:
#                     partial_scores[doc] += 1 / min_distance
#             positions[doc].append(pos)

def search(paths, docdict=None):
    if docdict is not None:
        index_path = paths
    else:
        index_path = build_index(paths)
        doc_count = len(paths)
        docdict = {}
        n = 1
        for path in paths:
            docdict[str(n)] = path
            n += 1
    hashmap = ChainHashMap()
    with open(index_path, 'r') as f:
        for line in f:
            word, value = line.split()
            hashmap.add(word, value)
            
    while True:
        partial_scores.clear()
        positions.clear()
        query = input("Enter search query: ")
        nlp = spacy.load('en_core_web_sm')
        stemmer = PorterStemmer()
        doc = nlp(query)
        total_docs = hashmap.__len__()
        scorer(doc, total_docs, docdict, hashmap)
            
        print(partial_scores)
        if partial_scores != {}:
            sorted_results = sorted(partial_scores.items(), key=lambda item: item[1], reverse=True)
            first_3 = sorted_results[:3]
            for doc, score in first_3:
                print(score, docdict[doc])
        else:
            print("No results found.")


def prepare_search(paths): #TODO delete?
    index_path = build_index(paths)
    docdict = {}
    n = 1
    for path in paths:
        docdict[str(n)] = path
        n += 1
    results = search(index_path)

def search_engine():
    paths = input("Directory of input files: ")
    input_path = get_all_files(paths)
    search(input_path)

inv_index_path = "C:\\Users\\akeen\\Downloads\\New SWE247P project\\inv-index\\inv-index.txt"
paths = ['C:\\Users\\akeen\\Downloads\\New SWE247P project\\input-files\\aleph.gutenberg.org\\1\\0\\0\\0\\10001\\10001.zip', 'C:\\Users\\akeen\\Downloads\\New SWE247P project\\input-files\\aleph.gutenberg.org\\1\\0\\0\\0\\10002\\10002.zip']
# prepare_search(paths)

def get_all_files(directory):
    file_paths = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.zip'):
                file_paths.append(os.path.join(root, file))
    return file_paths

# input_files_directory = 'C:\\Users\\akeen\\Downloads\\New SWE247P project\\input-files\\aleph.gutenberg.org\\1\\0\\0\\0'
# paths = get_all_files(input_files_directory)
# prepare_search(paths)
search_engine()
