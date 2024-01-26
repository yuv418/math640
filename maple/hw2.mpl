#
# Part 1:
#

# I feel quite confident with Maple now, so only a few examples are included.


#
# Part 2:
#

# Part 2.1: two examples of problem 16.1


with(NumberTheory):

#ME1(a,e,n): a^e mod n, the not stupid way.
ME1:=proc(a,e,n) local i,s,d:
    if e=1 then
        return (a mod n):
    fi:

    if e mod 2 = 0 then
        d:=ME1(a, iquo(e,2), n):
        return (d*d mod n):
    else
        return ((ME1(a, e-1, n) * a) mod n)
    fi:
end:

# Show that $a^phi(n) mod n = 1$
EulerThmCheck := proc(cprms, n):
    for a in cprms do
        if ME1(a, phi(n), n) <> 1 then
            return false:
        fi:
    od:
    return true:
end:

Coprimes := proc(n) local g, lst:
    lst := []:
    for g from 1 to n do
        if gcd(g, n) = 1 then
            lst := [op(lst), g]
        fi:
    od:
    return lst:
end:

# Question 1: Check Euler's theorem for n = 17268
cpr := Coprimes(17268);
if not EulerThmCheck(cpr, 17268) then
    print("FAIL"):
else
    print("OK"):
fi:

# Question 1: Check Euler's theorem for n = 89373
cpr := Coprimes(89373);
if not EulerThmCheck(cpr, 89373) then
    print("FAIL"):
else
    print("OK"):
fi:



# Part 2.2: two examples of problem 16.2

# Part22(p, q, e, c) given p, q and e and ciphertext c, we
# check if e is valid, find d, then decrypt the ciphertext
Part22 := proc(p, q, e, c) local m, n, d, message:
    n := p * q:
    m := phi(n):

    if gcd(e, m) <> 1 then print("FAIL, gcd(e, m) != 1") else print("Value of e key is OK") fi:

    d := e&^(-1) mod m:
    if d*e mod m <> 1 then print("FAIL, d and e are not multiplicative inverses") else print("OK, d is multiplicative inverse "
                                                    "of e") fi:

    message := c&^d mod n:
    print("Original message was " || message):
end:

# Choose the message as 17247 for both questions
c := 17247:

# Question 1: p = 104761 and q = 312617, and e = 16375034767
p := 104761:
q := 312617:
e := 16375034767:
Part22(p, q, e, c):


# Question 2: p = 1361849 and q = 29761213, and e = 20265123520001
p := 1361849:
p := 29761213:
e := 20265123520001:
Part22(p, q, e, c):

#
# Part 3: Prime factorization.
#

MyIfactor := proc(n): local next_prime:
    if n = 1 then
        return []:
    fi:

    next_prime := 2:
    while irem(n,next_prime) <> 0 do
        next_prime := nextprime(next_prime);
    od:

    return [next_prime, seq(MyIfactor(n/next_prime))]:
end:

# Test our prime factorization algorithm
