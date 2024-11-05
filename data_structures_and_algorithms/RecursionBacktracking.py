def find_permutations(s):
    if len(s) == 1:
        return [s]
    perms = []
    for i, char in enumerate(s):
        for perm in find_permutations(s[:i] + s[i+1:]):
            perms.append(char + perm)
    return perms

def check_permutation_in_string(small, large):
    permutations = find_permutations(small)
    for perm in permutations:
        if perm in large:
            return True
    return False

# Example usage
small_string = "ab"
large_string = "eidbaooo"
print('Has permutation:', check_permutation_in_string(small_string, large_string))

def chessQueenSorter(inputBoard):
    def hasDiagonal(board, col, value):
        for i in range(len(board)):
            if i == col or board[i] == -1:
                continue
            if abs(board[i] - value) == abs(i - col):
                return True
        return False

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
    
    def queenSort(inputBoard):
        best = {'moves': 8, 'board': [], 'totalSteps': 0}
        for solution in results:
            moves = 0
            totalSteps = 0
            for i in range(8):
                if inputBoard[i] != solution[i]:
                    moves += 1
                    totalSteps += abs(inputBoard[i] - solution[i])
            if moves < best['moves']:
                best = {'moves': moves, 'board': solution, 'totalSteps': totalSteps}
            elif moves == best['moves']:
                if totalSteps < best['totalSteps']:
                    best = {'moves': moves, 'board': solution, 'totalSteps': totalSteps}
        return best
    
    return queenSort(inputBoard)

board = [1, 1, 1, 1, 1, 1, 1, 1]
print('moves:', chessQueenSorter(board)['moves'])