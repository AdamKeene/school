import spacy, zipfile, os
from nltk.stem import PorterStemmer
from BuildIndex import build_index, ChainHashMap

partial_scores = {}
positions = {}
def scorer(word):
    data = word[1][0]
    docdata = data.split(';')
    for data in docdata:
        data = data.split(':')

        doc, score = data[0], data[1]
        try:
            partial_scores[doc] += int(score)
        except:
            partial_scores[doc] = int(score)
        pos = data[2].split(',')
        if doc not in positions:
            positions[doc] = [pos]
        else:
            for k in positions[doc]:
                min_distance = min(abs(int(l) - int(p)) for p in pos for l in k)
                if min_distance > 0:
                    partial_scores[doc] += 1 / min_distance
            positions[doc].append(pos)

def search(paths, docdict=None):
    if docdict is not None:
        index_path = paths
    else:
        index_path = build_index(paths)
        docdict = {}
        n = 1
        for path in paths:
            docdict[str(n)] = path
            n += 1
    while True:
        partial_scores.clear()
        positions.clear()
        query = input("Enter search query: ")
        nlp = spacy.load('en_core_web_sm')
        stemmer = PorterStemmer()
        doc = nlp(query)

        hashmap = ChainHashMap()
        with open(index_path, 'r') as f:
            for line in f:
                word, value = line.split()
                hashmap.add(word, value)

        for word in doc:
            if not word.is_stop and word.is_alpha:
                word = stemmer.stem(word.text)
                data = hashmap.get(word)
                if data is not None: #[('ball', [...])]
                    scorer(data)
        print(partial_scores)
        if partial_scores != {}:
            sorted_results = sorted(partial_scores.items(), key=lambda item: item[1], reverse=True)
            first_3 = sorted_results[:3]
            for doc, score in first_3:
                print(score, docdict[doc])
        else:
            print("No results found.")


def prepare_search(paths):
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
