permcount = 0
def checkPermutation(input1, input2):
    for i in range(len(input1)):
        if input1[i] in input2:
            newinput2 = input2.replace(input1[i], '', 1)
            newinput1 = input1[i+1:i+1+len(newinput2)]
            if len(newinput2) == 0:
                return True
            else:
                permscheck = checkPermutation(newinput1, newinput2)
                if permscheck:
                    return True

print(checkPermutation('eidbaooo', 'ab'))

# https://www.codeproject.com/Articles/5260339/Recursion-and-Backtracking
def chessQueenSorter(input):
    def hasDiagonal(input, index):
        for i in range(len(input)-1):
            if i == index:
                continue
            if abs(input[i] - input[index]) == abs(i - index):
                return i
        return False
    def hasHorizontal(input, index):
        for i in range(len(input)-1):
            if i == index:
                continue
            if input[i] == input[index]:
                return i
        return False
    
    def candidates(board):
        candidates = []
        for i in range(1, 9):
            if i not in board:
                candidates.append(i)
        return candidates

    def backtrack(board, row, results):
        if row == 8:
            results.append(board[:])
            return
        for candidate in candidates(board):
            board[row] = candidate
            if not hasHorizontal(board, row) and not hasDiagonal(board, row):
                backtrack(board, row + 1, results)
            board[row] = 0
    results = []
    board = [1] * 8
    backtrack(board, 0, results)
    return results

print(chessQueenSorter(8))