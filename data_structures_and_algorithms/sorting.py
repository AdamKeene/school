from StackQueue import Queue
from Heap import HeapBuilder

strings = ["bucket","rat","mango","tango","ogtan","tar"]

def merge(S1, S2, S):
    """Merge two sorted Python lists S1 and S2 into properly sized list S."""
    i = j = 0
    while i + j < len(S):
        if j == len(S2) or (i < len(S1) and S1[i] < S2[j]):
            S[i+j] = S1[i]  # copy ith element of S1 as next item of S
            i += 1
        else:
            S[i+j] = S2[j]  # copy jth element of S2 as next item of S
            j += 1
# O(n1 + n2) time

def merge_sort(S):
    """Sort the elements of Python list S using the merge-sort algorithm."""
    n = len(S)
    new_list = S.copy()
    if n < 2:
        return  # list is already sorted
    # divide
    mid = n // 2
    S1 = new_list[0:mid]  # copy of first half
    S2 = new_list[mid:n]  # copy of second half
    # conquer (with recursion)
    merge_sort(S1)  # sort copy of first half
    merge_sort(S2)  # sort copy of second half
    # merge results
    merge(S1, S2, S)  # merge sorted halves back into S

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

print(merge_sort_anagrams(strings))

def quick_sort(S):
    """Sort the elements of Python list S using the quick-sort algorithm."""
    n = S.size()
    if n < 2:
        return  # list is already sorted
    # divide
    p = S.first()  # using first as arbitrary pivot
    L = Queue()
    E = Queue()
    G = Queue()
    while not S.is_empty():  # divide S into L, E, and G
        if S.first() < p:
            L.enqueue(S.dequeue())
        elif p < S.first():
            G.enqueue(S.dequeue())
        else:  # S.first() must be equal to p
            E.enqueue(S.dequeue())
    # conquer (with recursion)
    quick_sort(L)  # sort elements less than p
    quick_sort(G)  # sort elements greater than p
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

print(quick_sort_anagrams(strings))

def heap_sort(arr):
    heap = HeapBuilder()
    heap.create_max_heap(arr)
    sorted_arr = []
    while len(heap) > 0:
        max_item = heap.remove_max()
        sorted_arr.insert(0, max_item[0])  # Insert at the beginning to maintain sorted order
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

print(heap_sort_anagrams(strings))

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