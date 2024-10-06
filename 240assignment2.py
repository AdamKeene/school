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
    
    def postfix(self, tokens):
        precedence = {'+': 1, '-': 1, '*': 2, '/': 2}
        output = []
        
        for token in tokens:
            if token.isdigit() or token.isnumeric():
                output.append(token)
            elif token in precedence:
                while (not self.is_empty() and self.peek() in precedence and precedence[self.peek()] >= precedence[token]):
                    output.append(self.pop())
                self.push(token)
        
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
print(result)