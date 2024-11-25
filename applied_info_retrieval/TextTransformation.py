import spacy, zipfile, os
from nltk.stem import PorterStemmer

inputPath = 'C:\\Users\\akeen\\Downloads\\New SWE247P project\\input-files\\aleph.gutenberg.org\\1\\0\\0\\0\\10001\\10001.zip'
outputPath = 'C:\\Users\\akeen\\Downloads\\New SWE247P project\\input-transform'

nlp = spacy.load('en_core_web_sm')
stemmer = PorterStemmer()
def process_text(inputPath, outputPath):
    #get input file
    if inputPath.endswith('.zip'):
        with zipfile.ZipFile(inputPath, 'r') as zip_ref:
            zip_ref.extractall(os.path.dirname(inputPath))
        f = inputPath.replace('.zip', '.txt')
    else:
        f = inputPath
    with open(f, 'r') as f:
        exampleIn = f.read()

    doc = nlp(exampleIn)

    #process text
    output_text = ''
    for token in doc:
        if not token.is_stop and token.is_alpha:
            output_text += stemmer.stem(token.text) + ' '
    output_text = output_text.strip()

    #create output file
    output_file = os.path.join(outputPath, 'output.txt')
    with open(output_file, 'w', encoding='utf-8') as file:
        file.write(output_text)
    output_zip_path = os.path.join(outputPath, 'output.zip')
    with zipfile.ZipFile(output_zip_path, 'w') as zipf:
        zipf.write(output_file, os.path.basename(output_file))
    os.remove(output_file)
    return output_zip_path

process_text(inputPath, outputPath)