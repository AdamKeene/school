class Stack:
    def __init__(self):
        self._data = []
    
    def push(self, e):
        self._data.append(e)
    
    def peek(self):
        if self.is_empty():
            raise Exception('Stack is empty')
        return self._data[-1]
    
    def pop(self):
        if self.is_empty():
            raise Exception('Stack is empty')
        return self._data.pop()
    
    def is_empty(self):
        return len(self._data) == 0
    
    def convert_to_postfix(self, tokens):
        precedence = {'+': 1, '-': 1, '*': 2, '/': 2}
        output = []
        
        for token in tokens:
            if token.isdigit() or token.isnumeric():
                output.append(token)
            elif token in precedence:
                while (not self.is_empty() and self.peek() in precedence and precedence[self.peek()] >= precedence[token]):
                    output.append(self.pop())
                self.push(token)
            else:
                raise Exception('NaN')
        
        while not self.is_empty():
            output.append(self.pop())
        
        return output
    
    def evaluate_postfix(self, expression):
        stack = Stack()
        for token in expression:
            if token.isnumeric():
                stack.push(int(token))
            else:
                right = stack.pop()
                left = stack.pop()
                if token == '+':
                    stack.push(left + right)
                elif token == '-':
                    stack.push(left - right)
                elif token == '*':
                    stack.push(left * right)
                elif token == '/':
                    stack.push(left / right)
        return stack.pop()
    
str = "10 + 20 * 2"
tokens = str.split()
stack = Stack()
postfix_exp = stack.postfix(tokens)
result = stack.evaluate_postfix(postfix_exp)
print(str + '=' + result)

class Queue:
    default_capacity = 10
    def __init__(self):
        self._data = [None] * Queue.default_capacity
        self._size = 0
        self._front = 0
    
    def enqueue(self, e):
        if self._size == len(self._data):
            self._resize(2 * len(self._data)) # double the array size
        avail = (self._front + self._size) % len(self._data)
        self._data[avail] = e
        self._size += 1
    
    def dequeue(self):
        if self.is_empty():
            raise Exception('Queue is empty')
        answer = self._data[self._front]
        self._data[self._front] = None # help garbage collection
        self._front = (self._front + 1) % len(self._data)
        self._size -= 1
        return answer
    
    def poll(self):
        if self.is_empty():
            raise Exception('Queue is empty')
        return self._data[self._front]
    
    def size(self):
        return self._size

    def is_empty(self):
        return self._size == 0
    
    def _resize(self, cap): # we assume cap >= len(self)
    #Resize to a new list of capacity >= len(self).
        old = self._data # keep track of existing list 
        self._data = [None] * cap # allocate list with new capacity
        walk = self._front
        for k in range(self._size): # only consider existing elements
            self._data[k] = old[walk] # intentionally shift indices
            walk = (1 + walk) % len(old) # use old size as modulus
        self._front = 0