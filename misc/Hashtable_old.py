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
    
    def __getitem__(self, key):
        j = self._hash(key)
        return self._bucket_getitem(j, key)
    
    def __setitem__(self, key, value):
        j = self._hash(key)
        self._bucket_setitem(j, key, value)
        if self._n > len(self._table) // 2:
            self._resize(2 * len(self._table) - 1)

    def __delitem__(self, key):
        j = self._hash(key)
        self._bucket_delitem(j, key)
        self._n -= 1
    
    def _resize(self, new_size):
        old = list(self.items())
        self._table = [None] * new_size
        self._n = 0
        for (key, value) in old:
            self[key] = value
    
    def _size(self):
        return len(self._table)

def find_p(cap): #don't use lol
    isPrime = False
    size = cap
    while isPrime == False:
        size += 1
        isPrime = True
        for i in range(2, size):
            if size % i == 0:
                isPrime = False
    return size

class ChainHashMap(Hash):
    def _bucket_getitem(self, j, key):
        bucket = self._table[j]
        if bucket is None:
            raise KeyError("Key Error: " + repr(key))
        return bucket[key]
    
    def _bucket_setitem(self, j, key, value):
        if self._table[j] is None:
            self._table[j] = UnsortedTableMap()
        old_size = len(self._table[j])
        self._table[j][key] = value
        if len(self._table[j]) > old_size:
            self._n += 1
    
    def _bucket_delitem(self, j, key):
        bucket = self._table[j]
        if bucket is None:
            raise KeyError("Key Error: " + repr(key))
        del bucket[key]
    
    def __iter__(self):
        for bucket in self._table:
            if bucket is not None:
                for key in bucket:
                    yield key
    
    def items(self):
        for bucket in self._table:
            if bucket is not None:
                for key in bucket:
                    yield (key, bucket[key])

    def __str__(self):
        string = ""
        for bucket in self._table:
            if bucket is not None:
                for key in bucket:
                    string += key + " : " + str(bucket[key]) + "\n"
        return string
    
class UnsortedTableMap:
    class _Item:
        def __init__(self, key, value):
            self._key = key
            self._value = value

    def __init__(self):
        self._table = []

    def __getitem__(self, key):
        # Look for the key in the table and return its value
        for item in self._table:
            if key == item._key:
                return item._value
        raise KeyError("Key Error: " + repr(key))
    
    def __setitem__(self, key, value):
        # Check if key exists, update its value if found, otherwise append new key-value pair
        for item in self._table:
            if key == item._key:
                item._value = value
                return
        self._table.append(self._Item(key, value))

    def __delitem__(self, key):
        # Look for the key in the table and remove the item
        for j in range(len(self._table)):
            if key == self._table[j]._key:
                self._table.pop(j)
                return
        raise KeyError("Key Error: " + repr(key))
    
    def __iter__(self):
        # Iterate over the table and yield keys
        for item in self._table:
            yield item._key

    def __len__(self):
        # Return the number of items in the map
        return len(self._table)



p = find_p(10)
hashh = Hash()
chainhash = ChainHashMap()
print(hashh._hash("hello"))
print(chainhash._hash("hello"))
chainhash["hello"] ='world'

print(chainhash._table)

with open("pride-and-prejudice.txt", "r") as file:
    print("File opened")
    for line in file:
        words = re.findall(r'\b\w+\b', line)
        for word in words:
            sorted_word = ''.join(sorted(word.lower()))
            try:
                chainhash[sorted_word].append(word)
            except KeyError:
                chainhash[sorted_word] = [word]
print("number of anagram roots: ", hashh._size())

non_none_count = sum(1 for bucket in chainhash._table if bucket is not None)
print(f"Number of table objects that are not None: {non_none_count}")