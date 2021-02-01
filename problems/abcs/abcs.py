numbers = [int(x) for x in input('Enter the list of numbers: ').split()]
numbers.sort()
n1, n2 = numbers[0], numbers[1]
n3 = numbers[-1] - n1 - n2
print(n1, n2, n3)
