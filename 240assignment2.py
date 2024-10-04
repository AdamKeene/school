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
        print(len(self._data) == 0)
        return len(self._data) == 0
    
str = "10 + 20 * 2"
str = str.split()
stack = Stack()
for item in str:
    stack.push(item)
