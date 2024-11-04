def concorda(iter_a, iter_b):
    iter_a, iter_b = iter(iter_a), iter(iter_b)
    while True:
        try:
            a = next(iter_a)
            b = next(iter_b)
            yield a if a == b else False
        except StopIteration:
            break

a = iter([1, 2, 4, 5, 7, 8, 2, 3, 4, 5])
b = iter([1, 2, 4, 8, 7, 8, 2, 7, 4, 5])

for value in concorda(a, b):
    print(value)
