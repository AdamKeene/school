#Q: add to id queue and check every time or add all ids to queue and always take from queue?
# better way than ignoring first node every time?

class Accounts:
    class _Node:
        __slots__ = '_id', '_prev', '_next', '_name', '_address', '_ssn', '_balance'
        def __init__(self, name, ID, prev_node, next_node, address, ssn, initial_balance):
            self._id = ID
            self._prev = prev_node
            self._next = next_node
            self._name = name
            self._address = address
            self._ssn = ssn
            self._balance = initial_balance

    def __init__(self):
        self._head = self._Node(None, None, None, None, None, None, None)
        self._tail = self._Node(None, None, None, None, None, None, None)
        self._head._next = self._tail
        self._tail._prev = self._head
        self._size = 0

    def addUser(self, name, predecessor, successor, address, ssn, initial_balance):
        #get next available ID
        if not id_queue.is_empty():
            ID = id_queue.dequeue()
        else:
            ID = self._size
        #create new node and link
        newest = self._Node(name, ID, predecessor, successor, address, ssn, initial_balance)
        predecessor._next = newest
        successor._prev = newest
        self._size += 1
        return newest

    def deleteUser(self, ID):
        if self.is_empty():
            raise Exception('Stack is empty')
        #find user matching ID
        current = self._head
        while current._id != ID:
            current = current._next
        #link previous and next nodes
        current._prev._next = current._next
        current._next._prev = current._prev
        #add ID to queue for reuse
        id_queue.enqueue(ID)
        self._size -= 1
        return current
    
    def payUserToUser(self, payerID, payeeID, amount):
        #find user nodes
        payer = self._head
        payee = self._head
        while payer._id != payerID:
            payer = payer._next
        while payee._id != payeeID:
            payee = payee._next
        #transfer funds
        if payer._balance < amount:
            raise 'declined: insufficient funds'
        payer._balance -= amount
        payee._balance += amount
    
    def getMedianID(self):
        if self.is_empty():
            raise Exception('Stack is empty')\
        #find middle and first node
        count = self._size // 2
        current = self._head._next
        #return middle node
        if self._size % 2 != 0:
            while count > 0:
                current = current._next
                count -= 1
            return current._id
        #return average and first of two middle nodes in even sized stacks
        else:
            while count > 1:
                current = current._next
                count -= 1
            return "first middle node:", current._id, "middle node average:", (current._id + current._next._id) / 2

    def mergeAccounts(self, ID1, ID2):
        #find user nodes
        user1 = self._head
        user2 = self._head
        while user1._id != ID1:
            user1 = user1._next
        while user2._id != ID2:
            user2 = user2._next
        #check accounts match
        if user1._ssn != user2._ssn:
            raise Exception('declined: accounts do not match')
        #transfer funds
        if user1._id > user2._id:
            newAcc = user1
            oldAcc = user2
        else:
            newAcc = user2
            oldAcc = user1
        newAcc._balance += oldAcc._balance
        self.deleteUser(oldAcc._id)


    def __len__(self):
        return self._size
    
    def is_empty(self):
        return self._size == 0
    
    def top(self):
        if self.is_empty():
            raise Exception('Stack is empty')
        return self._head._id
    
 
class _id_queue:
    class _Node:
        __slots__ = '_id', '_next'
        def __init__(self, ID, next):
            self._id = ID
            self._next = next

    def __init__(self):
        self._head = None
        self._tail = None
        self._size = 0

    def is_empty(self):
        return self._size == 0
    
    def first(self):
        if self.is_empty():
            raise Exception('Queue is empty')
        return self._head._id
    
    def enqueue(self, ID): #add to end of queue
        newest = self._Node(ID, None)
        if self.is_empty():
            self._head = newest
        else:
            self._tail._next = newest
        self._tail = newest
        self._size += 1

    def dequeue(self): #return and remove from start of queue
        if self.is_empty():
            raise Exception('Queue is empty')
        answer = self._head._id
        self._head = self._head._next
        self._size -= 1
        if self.is_empty():
            self._tail = None
        return answer
            
accounts = Accounts()
id_queue = _id_queue()

accounts.addUser(name='John Foo', predecessor=accounts._head, successor=accounts._head._next, address='123 Main St', ssn='123-45-6789', initial_balance=1000)
accounts.addUser(name='John Bar', predecessor=accounts._head, successor=accounts._head._next, address='123 Main St', ssn='123-45-6789', initial_balance=1000)
print("added users:", accounts._head._next._name, ',', accounts._head._next._next._name)
accounts.payUserToUser(0, 1, 500)
print("paid between users:", accounts._head._next._balance, accounts._head._next._next._balance)
print("Median ID:",accounts.getMedianID())
accounts.deleteUser(0)
print("deleted user 0:", accounts._head._next._name, ',', accounts._head._next._next._name)
print("ID queue:",id_queue.first())
accounts.addUser(name='John Foo', predecessor=accounts._head, successor=accounts._head._next, address='123 Main St', ssn='123-45-6789', initial_balance=1000)
accounts.mergeAccounts(0,1)
print('Added and merged accounts:', accounts._head._next._name, accounts._head._next._balance, ',', accounts._head._next._next._name)