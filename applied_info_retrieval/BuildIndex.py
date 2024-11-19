from TextTransformation import process_text
from random import randrange
import tempfile

class Hash:
    def __init__(self, cap=11, p=109345121):
        self._table = [None] * cap
        self._n = 0
        self._prime = p
        self._scale = 1 + randrange(p - 1)
        self._shift = randrange(p)

    def _hash_function(self, x):
        #polynomial hash method
        hash_value = self._prime
        for char in x:
            hash_value = (hash_value * 128 + ord(char)) % self._prime
        return hash_value & 0x7FFFFFFF
        
    def _hash(self, x): 
        #compresses via MAD method
        return (self._hash_function(x)*self._scale + self._shift) % self._prime % len(self._table)

    def __len__(self):
        return self._n
    
    def __contains__(self, key):
        j = self._hash(key)
        return self._bucket_contains(j, key)
    
    def add(self, key, value):
        index = self._hash(key)
        if self._table[index] is None:
            balls = self._table[index]
            self._table[index] = []
        if not self._bucket_contains(index, key):
            self._bucket_add(index, key, value)
        else:
            self._bucket_update(index, key, value)
        if self._n > len(self._table) // 2:
            self._resize(2 * len(self._table) - 1)

    def remove(self, key):
        j = self._hash(key)
        self._bucket_remove(j, key)
        self._n -= 1
    
    def _resize(self, new_size):
        old = list(self.items())
        self._table = [None] * new_size
        self._n = 0
        for bucket in old:
            self.add(bucket[0], bucket[1])
    
    def _size(self):
        return len(self._table)
class ChainHashMap(Hash):
    def _bucket_contains(self, j, key):
        bucket = self._table[j]
        if bucket is not None:
            for k, v in bucket:
                if k == key:
                    return True
        return False
    
    def _bucket_add(self, j, key, value):
        if self._table[j] is None:
            self._table[j] = []
        self._table[j].append((key, [value]))
        self._n += 1

    def _bucket_update(self, index, key, value):
        for i, (k, v) in enumerate(self._table[index]):
            if k == key:
                v.append(value)
                break
    
    def _bucket_remove(self, j, key):
        bucket = self._table[j]
        if bucket is None or key not in bucket:
            raise KeyError("Key Error: " + repr(key))
        bucket.remove(key)
    
    def __iter__(self):
        for bucket in self._table:
            if bucket is not None:
                yield from bucket
    
    def items(self):
        for bucket in self._table:
            if bucket is not None:
                yield from bucket

    def count_items(self):
        count = 0
        for bucket in self._table:
            if bucket is not None:
                count += len(bucket)
        return count
    
    def __str__(self):
        string = ""
        for bucket in self._table:
            if bucket is not None:
                for key in bucket:
                    string += key + "\n"
        return string
    
    def print_items(self):
        for item in self.items():
            print(str(item))

def build_index(docs):
    chainhash = ChainHashMap()
    docnum = 1
    for text in docs:
        with tempfile.TemporaryDirectory() as temp_dir:
            filepath = process_text(text, temp_dir)
            pos = 1
            with open(filepath, 'r', errors='ignore') as f:
                text = f.read()
                for word in text.split():
                    chainhash.add(word, (docnum, pos))
                    pos += 1
            docnum += 1
    return chainhash

path = 'C:\\Users\\akeen\\Downloads\\New SWE247P project\\input-files\\aleph.gutenberg.org\\1\\0\\0\\0\\10001\\10001.zip'
chainhash = build_index([path])
print(chainhash.count_items())
print(chainhash.print_items())