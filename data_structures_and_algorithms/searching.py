example1 = [4,9,10,13,17,17,19,21]
target1 = 17
example2 = [2,4,6,8,10,14,16]
target2 = 12
example3 = []
target = 0

def find_first_last(arr, target):
    left = 0
    right = len(arr) - 1
    while left <= right:
        mid = left + (right - left) // 2
        if arr[mid] == target:
            if arr[mid - 1] == target:
                return [mid - 1, mid]
            elif arr[mid + 1] == target:
                return [mid, mid + 1]
            else:
                return[mid, mid]
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return [-1, -1]

print(example1, '->', find_first_last(example1, target1))
print(example2, '->', find_first_last(example2, target2))
print(example3, '->', find_first_last(example3, target))

matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]]
matrixtest1 = 3
matrixtest2 = 13

def search_matrix(matrix, target):
    left = 0
    right = len(matrix) - 1
    while left <= right:
        mid = left + (right - left) // 2
        if target >= matrix[mid][0] and target <= matrix[mid][-1]:
            return target in matrix[mid]
        elif target < matrix[mid][0]:
            right = mid - 1
        else:
            left = mid + 1
    return False
        

print(f"{matrixtest1} in matrix:", search_matrix(matrix, matrixtest1))
print(f"{matrixtest2} in matrix:", search_matrix(matrix, matrixtest2))