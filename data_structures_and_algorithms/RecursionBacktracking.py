def find_permutations(string, input_string):
    for i in range(len(string)):
        if string[i] == input_string[0]:
            size = len(input_string)
            first = i-size if i-size >= 0 else 0
            if check_permutations(string[first:i+size], input_string[1:]) == True:
                return True
    return False

def check_permutations(string, input_string):
    if input_string == '':
        return True
    for i in range(len(string)):
        if string[i] == input_string[0]:
            size = len(input_string)-1
            first = i-size if i-size >= 0 else 0
            if check_permutations(string[first:i+size], input_string[1:]) == True:
                return True
    return False

small_string = "ab"
large_string = "eidbaooo"
print('Has permutation:', find_permutations(large_string, small_string))

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
        # recursively find all solutions
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
        # find the best solution
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