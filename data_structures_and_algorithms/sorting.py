from StackQueue import Queue
from Heap import HeapBuilder

strings = ["bucket","rat","mango","tango","ogtan","tar"]

def merge(S1, S2, S):
    i = j = 0
    while i + j < len(S):
        # if S1 is empty or S1[i] < S2[j]
        if j == len(S2) or (i < len(S1) and S1[i] < S2[j]):
            S[i+j] = S1[i]
            i += 1
        else:
            S[i+j] = S2[j]
            j += 1
# O(n1 + n2) time

def merge_sort(S):
    n = len(S)
    new_list = S.copy()
    # if list is sorted
    if n < 2:
        return
    # divide and conquer with recursion 
    mid = n // 2
    S1 = new_list[0:mid]
    S2 = new_list[mid:n]
    merge_sort(S1)
    merge_sort(S2)
    # merge results
    merge(S1, S2, S)

# O(n log n) time

def merge_sort_anagrams(S):
    sorted_strings = {}
    for string in S:
        sorted_string = list(string)
        merge_sort(sorted_string)
        sorted_string = "".join(sorted_string)
        try:
            sorted_strings[str(sorted_string)].append(string)
        except KeyError:
            sorted_strings[str(sorted_string)] = [string]
    anagram_list = list(sorted_strings.values())
    return anagram_list

print('merge sort:', merge_sort_anagrams(strings))

def quick_sort(S):
    n = S.size()
    # if sorted
    if n < 2:
        return
    # divide
    p = S.first()
    L = Queue()
    E = Queue()
    G = Queue()
    while not S.is_empty():
        if S.first() < p:
            L.enqueue(S.dequeue())
        elif p < S.first():
            G.enqueue(S.dequeue())
        else:
            E.enqueue(S.dequeue())
    # conquer (with recursion)
    quick_sort(L)
    quick_sort(G)
    # concatenate results
    sorted_list = []
    while not L.is_empty():
        sorted_list.append(L.first())
        S.enqueue(L.dequeue())
    while not E.is_empty():
        sorted_list.append(E.first())
        S.enqueue(E.dequeue())
    while not G.is_empty():
        sorted_list.append(G.first())
        S.enqueue(G.dequeue())
# O(n^2) time

def quick_sort_anagrams(S):
    sorted_strings = {}
    for string in S:
        #convert to Queue
        Q = Queue()
        for element in string:
            Q.enqueue(element)

        quick_sort(Q)
        sorted_string = ""
        while not Q.is_empty():
            sorted_string += Q.dequeue()
        try:
            sorted_strings[sorted_string].append(string)
        except KeyError:
            sorted_strings[sorted_string] = [string]
    anagram_list = list(sorted_strings.values())
    return anagram_list

print('quick sort:', quick_sort_anagrams(strings))

def heap_sort(arr):
    heap = HeapBuilder()
    heap.create_max_heap(arr)
    sorted_arr = []
    while len(heap) > 0:
        max_item = heap.remove_max()
        sorted_arr.insert(0, max_item[0])
    return sorted_arr

def heap_sort_anagrams(S):
    sorted_strings = {}
    for string in S:
        sorted_string = heap_sort(list(string))
        try:
            sorted_strings[str(sorted_string)].append(string)
        except KeyError:
            sorted_strings[str(sorted_string)] = [string]
    anagram_list = list(sorted_strings.values())
    return anagram_list

print('heap sort:', heap_sort_anagrams(strings))

def radix_sort(S):
    sorted_strings = {}
    for string in S:
        sorted_string = list(string)
        sorted_string = [ord(char) for char in sorted_string]
        sorted_string = heap_sort(sorted_string)
        sorted_string = [chr(char) for char in sorted_string]
        try:
            sorted_strings[str(sorted_string)].append(string)
        except KeyError:
            sorted_strings[str(sorted_string)] = [string]
    anagram_list = list(sorted_strings.values())
    return anagram_list

print('radix sort:', radix_sort(strings))