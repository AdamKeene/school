from random import randrange
import re

class Hash:
    def __init__(self, cap=11, p=109345121):
        self._table = [None] * cap
        self._n = 0
        self._prime = p
        self._scale = 1 + randrange(p - 1)
        self._shift = randrange(p)

    def _hash_function(self, x): #hash using polynomial hash method
        hash_value = self._prime
        for char in x:
            hash_value = (hash_value * 128 + ord(char)) % self._prime
        return hash_value & 0x7FFFFFFF
        
    def _hash(self, x): #compresses via MAD method
        return (self._hash_function(x)*self._scale + self._shift) % self._prime % len(self._table)

    def __len__(self):
        return self._n
    
    def __contains__(self, key):
        j = self._hash(key)
        return self._bucket_contains(j, key)
    
    def add(self, key):
        j = self._hash(key)
        self._bucket_add(j, key)
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
        for key in old:
            self.add(key)
    
    def _size(self):
        return len(self._table)

class ChainHashMap(Hash):
    def _bucket_contains(self, j, key):
        bucket = self._table[j]
        if bucket is None:
            return False
        return key in bucket
    
    def _bucket_add(self, j, key):
        if self._table[j] is None:
            self._table[j] = set()
        bucket = self._table[j]
        if key not in bucket:
            bucket.add(key)
            self._n += 1
    
    def _bucket_remove(self, j, key):
        bucket = self._table[j]
        if bucket is None or key not in bucket:
            raise KeyError("Key Error: " + repr(key))
        bucket.remove(key)
    
    def __iter__(self):
        for bucket in self._table:
            if bucket is not None:
                for key in bucket:
                    yield key
    
    def items(self):
        for bucket in self._table:
            if bucket is not None:
                for key in bucket:
                    yield key

    def __str__(self):
        string = ""
        for bucket in self._table:
            if bucket is not None:
                for key in bucket:
                    string += key + "\n"
        return string

# Example usage
p = 109345121
chainhashtest = ChainHashMap(cap=10, p=p)

print(chainhashtest._hash("hello"))

chainhashtest.add("hello")
print(chainhashtest._table)

def find_anagrams(text):
    chainhash = ChainHashMap()
    with open(text, "r") as file:
        print("File opened")
        for line in file:
            words = re.findall(r'\b\w+\b', line)
            for word in words:
                sorted_word = ''.join(sorted(word.lower()))  # Normalize case
                j = chainhash._hash(sorted_word)
                if not chainhash._bucket_contains(j, sorted_word):
                    chainhash.add(sorted_word)
    print("number of anagram roots: ", chainhash._size())
    non_none_count = sum(1 for bucket in chainhash._table if bucket is not None)
    print(f"Number of table objects that are not None: {non_none_count}")

find_anagrams("pride-and-prejudice.txt")