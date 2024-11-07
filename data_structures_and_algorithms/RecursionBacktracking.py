def check_permutations(string, input_string):
    if input_string == '':
        return True
    for i in range(len(string)):
        if string[i] == input_string[0]:
            size = len(input_string)-1
            first = i-size if i-size >= 0 else 0
            new_string = string[first:i] + string[i+1:i+size+1]
            if check_permutations(new_string, input_string[1:]) == True:
                return True
    return False

small_string = "albb"
large_string = "eidbbalooo"
print('Has permutation:', check_permutations(large_string, small_string))

    
def queenSort(board, inputboard, index=0, changes=0, best=None):
    if best is None:
        best = {'moves': 9, 'board': []}
    def hasDiagonal(board, col, value):
        for i in range(col):
            if board[i] == 0:
                continue
            if abs(board[i] - value) == abs(i - col):
                return True
        return False
    
    if index == 8:
        if changes < best['moves']:
            best['moves'] = changes
            best['board'] = board.copy()
    for val in range(1, 9):
        if val not in board[:index] and not hasDiagonal(board, index, val):
            original_value = inputBoard[index]
            board[index] = val
            changed = (val != original_value)
            queenSort(board, inputboard, index + 1, changes + (1 if changed else 0), best)
            board[index] = original_value
    return best

def ChessQueenSorter(inputBoard):
    best = {'moves': 9, 'board': []}
    queenSort(inputBoard, inputBoard.copy(), best=best)
    return best

 

inputBoard = [1,2,3,4,1,2,3,4]
sorted_board = ChessQueenSorter(inputBoard)
print('Sorted Board:', sorted_board)


    