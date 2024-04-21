#OK to post homework
#Ramesh Balaji,3/30/2024,hw19

# Part 1:
# I emailed you earlier about the snake-charmer project

# Part 2:
# J'ai essayé de le lire en français !

# Part 3:
p := proc(n):
    return 1 + sum(floor(floor(n/(1 + sum(floor((1 + (j - 1)!)/j - floor((j - 1)!/j)), j = 2 .. m)))^(1/n)), m = 1 .. 2^n);
end:

t := proc(n):
    return 2 + n*floor(1/(1+sum(floor(((n+2)/p) -  floor((n+1)/p)), p=2..n+1)));
end:

pifn := proc(n):
    return floor(sum((sin( (Pi*GAMMA(k))/(2*k)   ))^2, k=1..n));
end:

p(9); # should return 23
p(7); # should return 17
t(41); # returns 43, which is prime (remember t is not in order)
pifn(10); # there are 4 primes from 1 to 10
pifn(14); # there are 6 primes from 1 to 10

# Part 4:
#FindRD(d): finds a random prime with d digits
FindRP:=proc(d):
nextprime(rand(10^(d-1)..10^d-1)()):
end:

#IsPrim(g,P): Is g primitive mod P? {g,g^2,..., g^(p-2)} are all different
#if g^i mod p=1 doesn't happen until i=p-1
IsPrim:=proc(g,P) local i:
for i from 1 to P-2 do
 if g&^i mod P=1 then
    RETURN(false):
 fi:
od:
true:
end:

#FindPrimi(P): given a prime P, finds a primitive g by brute force
FindPrimi:=proc(P) local g:
for g from 2 to P-2 do
  if IsPrim(g,P) then
    RETURN(g):
   fi:
od:

FAIL:
end:
#AliceToBob(P,g): alice picks her secret integer a from 2 to P-2 does not
#tell anyone (not even Bob) and sends Bob g^a mod P
AliceToBob:=proc(P,g) local a:
a:=rand(3..P-3)():
[a,g&^a mod P]:
end:


#BobToAice(P,g): Bob picks his secret integer b from 2 to P-2 does not
#tell anyone (not even Alice) and sends Alice g^b mod P
BobToAlice:=proc(P,g) local b:
b:=rand(3..P-3)():
[b,g&^b mod P]:
end:

for i from 1 to 10 do:
    P := FindRP(3);
    g := FindPrimi(P);

    atob := AliceToBob(P, g);
    btoa := BobToAlice(P, g);

    k1 := atob[2]&^btoa[1] mod P;
    k2 := btoa[2]&^atob[1] mod P;

    if k1 = k2 then:
        print("OK");
    else:
        print("FAIL");
    end:
end:

# they all print ok

# Part 5:
DL := proc(x,P,g) local a:
    for a from 1 to P-1 do:
        if g&^a mod P = x then:
            return a;
        end:
    od:
    return FAIL;
end:


for i from 1 to 3 do:
    P := FindRP(4);
    g := FindPrimi(P);

    if DL(rand(1..P-1)(), P, g) <> FAIL then:
        print("OK");
    else:
        print("FAIL");
    end:
od:


# slower!
#P := FindRP(9);
P:=5899919;
#g := FindPrimi(P);
g:=7;
DL(rand(1..P-1)(), P, g);
