# Academic Projects Portfolio

A collection of software development projects demonstrating expertise in data structures, algorithms, neural networks, information retrieval systems, and more. These projects showcase practical implementations of fundamental CS concepts and modern machine learning techniques.

## 🚀 Technologies & Skills Demonstrated

- **Languages**: Python, Java
- **Machine Learning**: TensorFlow/Keras, Deep Learning, CNN, RNN, LSTM
- **Data Structures**: Hash Tables, Trees, Graphs, Heaps, Stacks, Queues
- **Algorithms**: Sorting, Searching, Graph Algorithms, Dynamic Programming
- **NLP**: spaCy, NLTK, Text Processing, TF-IDF, Cosine Similarity
- **Computer Vision**: Image Classification, Data Augmentation
- **Information Retrieval**: Search Engines, Indexing, Scoring Systems

---

## 📊 Data Structures & Algorithms

### Core Implementations

**Hash Table with Chaining**
- Custom hash table implementation using polynomial hashing and MAD compression
- Handles collisions through chaining with dynamic resizing
- Used in information retrieval system for efficient term storage

```python
class Hash:
    def __init__(self, cap=11, p=109345121):
        self._table = [None] * cap
        self._n = 0
        self._prime = p
        self._scale = 1 + randrange(p - 1)
        self._shift = randrange(p)

    def _hash_function(self, x):
        # Polynomial hash method
        hash_value = self._prime
        for char in x:
            hash_value = (hash_value * 128 + ord(char)) % self._prime
        return hash_value & 0x7FFFFFFF
```

**Graph Data Structure**
- Complete graph implementation supporting both directed and undirected graphs
- Vertex and edge management with adjacency list representation
- Used for network analysis and pathfinding algorithms

**Tree Structures**
- Abstract tree implementation with position-based navigation
- Binary tree extensions with height calculation algorithms
- Recursive depth and height computation methods

### Sorting Algorithms

**Multi-Algorithm Sorting Implementation**
- Merge Sort: O(n log n) divide-and-conquer algorithm
- Quick Sort: In-place sorting with pivot selection
- Heap Sort: Using custom heap implementation
- Radix Sort: Non-comparative sorting for strings

```python
def merge_sort(S):
    n = len(S)
    if n < 2:
        return
    mid = n // 2
    S1 = S[0:mid]
    S2 = S[mid:n]
    merge_sort(S1)
    merge_sort(S2)
    merge(S1, S2, S)
```

**Anagram Grouping**
- Applied sorting algorithms to group anagrams efficiently
- Demonstrated practical application of sorting in text processing

### Search Algorithms

**Binary Search Implementation**
- Efficient O(log n) search with first/last occurrence detection
- Applied to sorted arrays for range queries

```python
def binary_search_left(nums, target):
    left, right = 0, len(nums) - 1
    while left <= right:
        mid = (left + right) // 2
        if nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return left
```

---

## 🧠 Neural Networks & Deep Learning

### Computer Vision Projects

**MNIST Digit Classification**
- Convolutional Neural Network for handwritten digit recognition
- Achieved high accuracy on 28x28 grayscale images
- Implemented data preprocessing and normalization

```python
model = keras.Sequential([
    layers.Conv2D(32, (3, 3), activation='relu', input_shape=(28, 28, 1)),
    layers.MaxPooling2D((2, 2)),
    layers.Conv2D(64, (3, 3), activation='relu'),
    layers.MaxPooling2D((2, 2)),
    layers.Conv2D(64, (3, 3), activation='relu'),
    layers.Flatten(),
    layers.Dense(64, activation='relu'),
    layers.Dense(10, activation='softmax')
])
```

**Cats vs Dogs Classification**
- Binary image classification using CNN
- Implemented data augmentation techniques (rotation, flipping, zooming)
- Used dropout regularization to prevent overfitting
- Achieved high accuracy on real-world image dataset

```python
data_augmentation = keras.Sequential([
    layers.RandomFlip("horizontal"),
    layers.RandomRotation(0.1),
    layers.RandomZoom(0.2),
])
```

### Regression & Time Series

**Boston Housing Price Prediction**
- Regression neural network for real estate price prediction
- Implemented K-fold cross-validation for robust model evaluation
- Data normalization and feature scaling
- Achieved low mean absolute error on test data

```python
def build_model():
    model = keras.Sequential([
        layers.Dense(64, activation="relu"),
        layers.Dense(64, activation="relu"),
        layers.Dense(1)
    ])
    model.compile(optimizer="rmsprop", loss="mse", metrics=["mae"])
    return model
```

### Natural Language Processing

**IMDB Sentiment Analysis**
- Binary text classification for movie review sentiment
- Implemented text vectorization and sequence processing
- Used dense layers with ReLU activation and sigmoid output

**Reuters News Classification**
- Multi-class text classification (46 categories)
- One-hot encoding for categorical labels
- Softmax activation for probability distribution output

**Advanced RNNs & LSTMs**
- Sequential data processing with recurrent architectures
- Time series prediction and sequence modeling
- Bidirectional LSTM implementation for improved performance

### Word Embeddings
- Implemented word vector representations
- Applied to text similarity and semantic analysis
- Used pre-trained embeddings for transfer learning

---

## 🔍 Information Retrieval System

### Search Engine Implementation

**Text Processing Pipeline**
- spaCy-based natural language processing
- Porter stemming for term normalization
- Stop word removal and text cleaning

```python
def process_text(inputPath, outputPath):
    nlp = spacy.load('en_core_web_sm')
    stemmer = PorterStemmer()
    
    doc = nlp(exampleIn)
    output_text = ''
    for token in doc:
        if not token.is_stop:
            output_text += stemmer.stem(token.text) + ' '
```

**TF-IDF Scoring System**
- Term Frequency-Inverse Document Frequency implementation
- Document ranking based on relevance scores
- Cosine similarity for query-document matching

```python
def tfidf(data, doc, doc_num, total_docs, query=False):
    tf = doc.count(word) / len(doc)
    idf = (total_docs / term_count) ** 0.5
    return tf * idf

def cosine(d, q):
    dot = sum(d[i] * q[i] for i in range(len(q)))
    mag_1 = sum(d[i] ** 2 for i in range(len(q))) ** 0.5
    mag_2 = sum(q[i] ** 2 for i in range(len(q))) ** 0.5
    return dot / (mag_1 * mag_2)
```

**Index Building & Search**
- Inverted index construction for efficient retrieval
- Hash table-based term storage and lookup
- Real-time search with relevance scoring

### Key Features
- **Efficient Indexing**: Custom hash table implementation for O(1) term lookup
- **Relevance Scoring**: TF-IDF and cosine similarity for document ranking
- **Text Processing**: Advanced NLP preprocessing with spaCy
- **Scalable Architecture**: Handles large document collections efficiently

---

## 🎯 Project Highlights

### Algorithm Analysis
- **Complexity Analysis**: Big-O notation analysis for all algorithms
- **Performance Optimization**: Efficient implementations with optimal time/space complexity
- **Practical Applications**: Real-world problem solving with algorithmic solutions

### Machine Learning Expertise
- **Deep Learning**: CNN, RNN, LSTM architectures
- **Computer Vision**: Image classification and preprocessing
- **Natural Language Processing**: Text classification and sentiment analysis
- **Model Evaluation**: Cross-validation, regularization, and performance metrics

### Software Engineering
- **Clean Code**: Well-structured, documented implementations
- **Object-Oriented Design**: Proper abstraction and encapsulation
- **Data Processing**: Efficient handling of large datasets
- **System Integration**: End-to-end pipeline development

---

## 📁 Project Structure

```
├── data_structures_and_algorithms/
│   ├── Hash table implementation with chaining
│   ├── Graph algorithms and tree structures
│   ├── Sorting algorithms (merge, quick, heap, radix)
│   ├── Search algorithms and complexity analysis
│   └── Stack/Queue implementations
├── neural_networks/
│   ├── Computer vision (MNIST, Cats vs Dogs)
│   ├── NLP (IMDB, Reuters classification)
│   ├── Regression (Boston Housing)
│   ├── Advanced RNNs and LSTMs
│   └── Word embeddings and transfer learning
└── applied_info_retrieval/
    ├── Search engine implementation
    ├── TF-IDF scoring system
    ├── Text processing pipeline
    └── Index building and retrieval
```

---

## 🚀 Getting Started

Each project directory contains:
- **Implementation files** with complete source code
- **Data files** for testing and validation
- **Documentation** explaining algorithms and approaches
- **Performance metrics** and analysis results

### Requirements
- Python 3.7+
- TensorFlow/Keras
- spaCy, NLTK
- NumPy, Matplotlib
- Standard Python libraries

---

*This portfolio demonstrates strong foundations in computer science fundamentals, practical machine learning experience, and the ability to implement complex systems from scratch. Each project showcases both theoretical understanding and practical implementation skills valuable for software engineering and data science roles.*
