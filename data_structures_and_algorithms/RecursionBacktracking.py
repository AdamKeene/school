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
def chessQueenSorter():
    def hasDiagonal(board, col, value):
        #col -= 1
        for i in range(len(board)):
            if i == col or board[i] == -1:
                continue
            if abs(board[i] - value) == abs(i - col):
                return True
        return False
    
    def get_candidates(board):
        candidates = []
        for i in range(1, 9):
            if i not in board:
                candidates.append(i)
        return candidates

    results = []
    def find_solutions(board, col, results):
        if col == 8:
            results.append(board[:])
            return
        for val in range(1,9):
            if val not in board and not hasDiagonal(board, col, val):
                board[col] = val
                find_solutions(board,col+1,results)
                board[col] = -1

    board = [-1] * 8
    find_solutions(board, 0, results)
    
    def queenSort(board):
        for solution in results:


print(chessQueenSorter())