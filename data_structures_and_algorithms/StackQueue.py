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
                # pop while operator has precedence then push group
                while (not self.is_empty() and self.peek() in precedence and precedence[self.peek()] >= precedence[token]):
                    output.append(self.pop())
                self.push(token)
            else:
                raise Exception('NaN')
        # pop remaining operators
        while not self.is_empty():
            output.append(self.pop())
        return output
    
    def evaluate_postfix(self, expression):
        stack = Stack()
        for token in expression:
            #push numbers, apply operators
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
postfix_exp = stack.convert_to_postfix(tokens)
result = stack.evaluate_postfix(postfix_exp)
print(str, '=', result)

class Queue:
    default_capacity = 10
    def __init__(self):
        self._data = [None] * Queue.default_capacity
        self._size = 0
        self._front = 0
    
    def enqueue(self, e):
        #double size if full
        if self._size == len(self._data):
            self._resize(2 * len(self._data))
        #index of next available slot
        avail = (self._front + self._size) % len(self._data)
        self._data[avail] = e
        self._size += 1
    
    def dequeue(self):
        if self.is_empty():
            raise Exception('Queue is empty')
        answer = self._data[self._front]
        self._data[self._front] = None
        #index is the next in the queue even if it loops
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
    
    def _resize(self, cap):
        #resize self._data
        old = self._data 
        self._data = [None] * cap
        #walk through existing elements
        walk = self._front
        for k in range(self._size):
            self._data[k] = old[walk]
            walk = (1 + walk) % len(old)
        self._front = 0
    
    def first(self):
        if self.is_empty():
            raise Exception('Queue is empty')
        return self._data[self._front]

class StackWithTwoQs:
    def __init__(self):
        self.q1 = Queue()
        self.q2 = Queue()
    
    def push(self, e):
        self.q1.enqueue(e)
    
    def pop(self):
        if self.q1.is_empty():
            raise Exception('Stack is empty')
        while self.q1.size() > 1:
            self.q2.enqueue(self.q1.dequeue())
        answer = self.q1.dequeue()
        self.q1, self.q2 = self.q2, self.q1
        return answer

    def peek(self):
        if self.q1.is_empty():
            raise Exception('Stack is empty')
        while self.q1.size() > 1:
            self.q2.enqueue(self.q1.dequeue())
        answer = self.q1.poll()
        self.q2.enqueue(self.q1.dequeue())
        self.q1, self.q2 = self.q2, self.q1
        return answer
    
    def size(self):
        return self.q1.size()
    
stack_with_two_qs = StackWithTwoQs()
stack_with_two_qs.push(10)
stack_with_two_qs.push(20)
stack_with_two_qs.push(30)

print("Stack size:", stack_with_two_qs.size())  # Output: Stack size: 3
print("Top element:", stack_with_two_qs.peek())  # Output: Top element: 30

print("Popped element:", stack_with_two_qs.pop())  # Output: Popped element: 30
print("Popped element:", stack_with_two_qs.pop())  # Output: Popped element: 20

print("Stack size:", stack_with_two_qs.size())  # Output: Stack size: 1
print("Top element:", stack_with_two_qs.peek())  # Output: Top element: 10