from random import randrange
from StackQueue import Stack, Queue

class Hash:
    def __init__(self, cap, p):
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
    
    def __getitem__(self, k):
        j = self._hash(k)
        return self._bucket_getitem(j, k)
    
    def __setitem__(self, k, v):
        j = self._hash(k)
        self._bucket_setitem(j, k, v)
        if self._n > len(self._table) // 2:
            self._resize(2 * len(self._table) - 1)

    def __delitem__(self, k):
        j = self._hash(k)
        self._bucket_delitem(j, k)
        self._n -= 1
    
    def _resize(self, c):
        old = list(self.items())
        self._table = [None] * c
        self._n = 0
        for (k, v) in old:
            self[k] = v

def find_p(cap):
    isPrime = False
    size = cap
    while isPrime == False:
        size += 1
        isPrime = True
        for i in range(2, size):
            if size % i == 0:
                isPrime = False
    return size
p = find_p(10)
hashh = Hash(cap=10, p=p)
print(hashh._hash("hello"))
hashh.__setitem__("hello")
print(hashh._table)
