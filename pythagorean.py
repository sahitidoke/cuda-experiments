from re import X
from numba import jit
import math
@jit
def hypot(x, y):
    # Implementation from https://en.wikipedia.org/wiki/Hypot
    x = abs(x);
    y = abs(y);
    t = min(x, y);
    x = max(x, y);
    t = t / x;
    return x * math.sqrt(1+t*t)
print("Lets do the pythagorean theorem!")
val1 = int(input("Enter your first value: "))
val2 = int(input("Enter your second value: "))
print(hypot(val1, val2))
print("With numba: ")
%timeit hypot(val1, val2)
print("Without numba: ")
%timeit hypot.py_func(val1, val2)
