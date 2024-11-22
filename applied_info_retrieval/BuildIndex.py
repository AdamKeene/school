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
    
    def get(self, key):
        j = self._hash(key)
        try:
            result = self._table[j]
            for i in result:
                if i[0] == key:
                    return i
            print("Key not found")
            return None
        except:
            return None
    
    def add(self, key, value):
        index = self._hash(key)
        if self._table[index] is None:
            balls = self._table[index]
            self._table[index] = []
        if not self._bucket_contains(index, key):
            balls = self._table[index]
            self._bucket_add(index, key, value)
        else:
            self._bucket_update(index, key, value)
        if self._n > len(self._table) // 2:
            self._resize(2 * len(self._table) - 1)

    def add_bucket(self, key, values):
            index = self._hash(key)
            if self._table[index] is None:
                self._table[index] = []
            self._table[index].append((key, values))
            self._n += len(values)
    
    def _resize(self, new_size):
        old = list(self.items())
        self._table = [None] * new_size
        self._n = 0
        for key, values in old:
            self.add_bucket(key, values)
    
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
        balls = self._table[j]
        self._table[j].append((key, [value]))
        balls = self._table[j][0]
        sack = self._table[j][0][1][0]
        self._n += 1

    def _bucket_update(self, index, key, value):
        for i, (k, v) in enumerate(self._table[index]):
            if k == key:
                v.append(value)
                break
    
    def __iter__(self):
        for bucket in self._table:
            if bucket is not None:
                yield from bucket
    
    def items(self):
        for bucket in self._table:
            if bucket is not None:
                for key, value in bucket:
                    yield key, value

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
                    string += str(key) + "\n"
        return string
    
    def print_items(self):
        for item in self.items():
            print(str(item))



def build_index(docs):
    chunk_max = 5 * 1024 * 1024
    docnum = 1
    shard_index = 0
    chunk_size = 0
    shards = [ChainHashMap()]

    for text in docs:
        with tempfile.TemporaryDirectory() as temp_dir:
            filepath = process_text(text, temp_dir)
            pos = 1
            print(f'reading doc {docnum}')
            with open(filepath, 'r', errors='ignore') as f:
                text = f.read()
                for word in text.split():
                    chunk_size += len(word) + len(str(docnum)) + len(str(pos)) + 3
                    if chunk_size > chunk_max:
                        shard_index += 1
                        shards.append(ChainHashMap())
                        chunk_size = 0
                    shards[shard_index].add(word, (docnum, pos))
                    pos += 1
                    
            docnum += 1
    #merge shards
    index = ChainHashMap()
    for shard in shards:
        for key, value in shard.items():
            if key in index:
                index._bucket_update(index._hash(key), key, value)
            else:
                index.add_bucket(key, value)
    path = write_index_to_file(index)
    return path

# path = 'C:\\Users\\akeen\\Downloads\\New SWE247P project\\input-files\\aleph.gutenberg.org\\1\\0\\0\\0\\10001\\10001.zip'
# path2 = 'C:\\Users\\akeen\\Downloads\\New SWE247P project\\input-files\\aleph.gutenberg.org\\1\\0\\0\\0\\10002\\10002.zip'
# chainhash = build_index([path, path2])

def write_index_to_file(index):
    inv_index_path = "C:\\Users\\akeen\\Downloads\\New SWE247P project\\inv-index\\inv-index.txt"
    with open(inv_index_path, 'w') as file:
        for key, values in index.items():
            doc_nums = {}
            for doc_id, pos in values:
                if doc_id not in doc_nums:
                    doc_nums[doc_id] = []
                doc_nums[doc_id].append(pos)
            positions_str = ';'.join(f"{doc_id}:{len(pos_list)}:{','.join(map(str, pos_list))}" for doc_id, pos_list in doc_nums.items())
            file.write(f"{key} {positions_str}\n")
    return inv_index_path

# output_filename = 'index_output.txt'
# write_index_to_file(chainhash)