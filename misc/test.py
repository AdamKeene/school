balls = [(1, [(2, 3)]), (4, [(5, 6)])]
for i, j in balls:
    j.append((7, 8))
print(balls)