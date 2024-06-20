def Fun(n):
    if n <=1:
        return n
    else:
        return Fun(n-1) + Fun(n-2)

n = int(input("Enter the number: "))
print("Result: ",Fun(n))