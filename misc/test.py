# one = [1, 2, 3, 4, 5]
# two = [6, 7, 8, 9, 10]
# balls = min(abs(int(k) - int(p)) for k in one for p in two)


# data = ['market 1:4:3,11,15,25;2:1:4', 'predict 1:2:10,23;2:1:2']
# partial_scores = {}
# positions = {}

# def score(data):
#     for i in data:
#         split = i.split(' ')
#         data = split[1]
#         docdata = data.split(';')
#         for data in docdata:
#             data = data.split(':')

#             doc, score = data[0], data[1]
#             try:
#                 partial_scores[doc] += int(score)
#             except:
#                 partial_scores[doc] = int(score)
#             pos = data[2].split(',')
#             if doc not in positions:
#                 positions[doc] = [pos]
#             else:
#                 for k in positions[doc]:
#                     min_distance = min(abs(int(l) - int(p)) for p in pos for l in k)
#                     print(min_distance)
#                     partial_scores[doc] += 1 / min_distance
#                 positions[doc].append(pos)
#     print(partial_scores)
# score(data)
            
word = ('interpret', ['1:1:3413;2:2:608,21797'])
print(word[1][0])