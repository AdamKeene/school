# Information Retrieval System Implementation

This project implements a comprehensive information retrieval system with features including text processing, inverted index construction, and advanced search functionality using TF-IDF scoring and cosine similarity.

## System Components

### 1. Text Processing (`TextTransformation.py`)
- **Natural Language Processing** using spaCy
- **Text Normalization** techniques:
  - Stopword removal
  - Stemming using Porter Stemmer
  - Case normalization
- **File handling** for various input formats (ZIP, TXT)
- Persistent storage of processed documents for efficiency

### 2. Index Construction (`BuildIndex.py`)
- **Custom Hash Table Implementation**
  - Chained hash map for collision resolution
  - Dynamic resizing capability
  - Polynomial hashing with MAD (Multiply-Add-Divide) compression
- **Inverted Index Features**
  - Position-based indexing
  - Document-term frequency tracking
  - Memory-efficient sharding for large datasets
- **Persistent Storage**
  - Index serialization to disk
  - Incremental processing support

### 3. Search and Scoring (`SearchingScoring.py`)
- **Advanced Ranking Algorithms**
  - TF-IDF (Term Frequency-Inverse Document Frequency) scoring
  - Cosine similarity for query-document matching
  - Position-based proximity scoring
- **Query Processing**
  - Natural language query support
  - Stop word filtering
  - Term stemming for query terms
- **Results Presentation**
  - Ranked document retrieval
  - Relevance score display
  - Top-K results filtering

## Technical Implementation Details

### Inverted Index Structure
- Maps terms to document occurrences with positions
- Format: `term doc_id:frequency:positions;doc_id:frequency:positions`
- Efficient storage and retrieval of term occurrences

### Search Process
1. Query Preprocessing
   - Tokenization and normalization
   - Stop word removal
   - Term stemming

2. Document Scoring
   - TF-IDF calculation
   - Cosine similarity computation
   - Document ranking based on relevance scores

### Performance Optimizations
- Sharded index construction for memory efficiency
- Cached document processing
- Optimized hash table implementation
- Persistent storage of processed documents

## Usage

### Building the Index
```python
# Using default repository paths
python BuildIndex.py

# Or programmatically
from BuildIndex import main as build_index
build_index(paths, index_path='path/to/output/index.txt')
```

### Searching
```python
# Using existing index
python SearchingScoring.py

# Or programmatically
from SearchingScoring import search_engine
search_engine('path/to/index.txt')
```

## Project Structure
```
applied_info_retrieval/
├── BuildIndex.py          # Index construction
├── SearchingScoring.py    # Search implementation
├── TextTransformation.py  # Text processing
└── input-transform/       # Processed documents
```

## Technologies Used
- Python 3.x
- spaCy for NLP
- NLTK for text processing
- Custom data structures
- File system storage

This implementation demonstrates understanding of:
- Information retrieval concepts
- Data structure optimization
- Text processing techniques
- Search algorithm implementation
- System architecture design