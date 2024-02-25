#OK to post homework
#Ramesh Balaji,2/24/2024,hw11

# OLD CODE

#AllPols(q,d,x): the set of all the polynomials of degree <=d in x over GF(q) (q is a prime)
AllPols:=proc(q,d,x) local S,s,i:
option remember:
if d=0 then
 RETURN({seq(i,i=0..q-1)}):
fi:
S:=AllPols(q,d-1,x):
{seq(seq(s+i*x^d,i=0..q-1), s in S)}:
end:

#Added after class
#MonicPols(q,d,x): all the monic poynomials of degree d over GF(q). Try:
#MonicPols(3,4,x);
MonicPols:=proc(q,d,x) local S,s:
S:=AllPols(q,d-1,x):
{seq(x^d+s, s in S)}:
end:


#Mul(q,P1,P2,x,f): P1*P2 mod q mod f
Mul:=proc(q,P1,P2,x,f):  rem(P1*P2,  f, x) mod q:end:

#Irreds(q,d,x): all monic  irreducible polynomials in GF(q)[x] of degree d
Irreds:=proc(q,d,x) local d1,S,S1,S2,s1,s2:

S:=MonicPols(q,d,x):

for d1 from 1 to d-1 do
 S1:=MonicPols(q,d1,x):
 S2:=MonicPols(q,d-d1,x):
 S:=S minus {seq(seq(expand(s1*s2) mod q, s1 in S1),s2 in S2)}:
od:
S:
end:


# Part 2:

# OEIS A001037, a(20) = 52377
seq( nops(Irreds(2,i,x)) , i=1..7);
# OEIS A001692, a(20) = 4768371093720
seq( nops(Irreds(5,i,x)) , i=1..5);
# OEIS A001693, a(20) = 3989613300756720
# I had to download PARI/GP to compute this!
seq( nops(Irreds(7,i,x)) , i=1..5);
# OEIS A032166, a(20) = 33637499745331128504
# was given as maple code! which I am using to just compute the answers to all
# of them again!
seq( nops(Irreds(11,i,x)) , i=1..3);

f:= (n, p) -> add(numtheory:-mobius(d)*p^(n/d), d=numtheory:-divisors(n))/n:
f(20, 2);
f(20, 5);
f(20, 7);
f(20, 11);


# Part3: mul table

MulTable := proc(q,f,x) local pols,tbl,i,j:
    # pols to mult
    pols := AllPols(q,degree(f,x)-1,x);

    for i from 1 to nops(pols) do:
        for j from 1 to nops(pols) do:
            tbl[pols[i],pols[j]] := Mul(q,pols[i],pols[j],x,f):
        od:
    od:

    return tbl:
end:

# Part4:
irred:=MulTable(3,x^3  + 2*x + 1,x):
pols := AllPols(3,2,x);
for pol1 in pols do
    inv := 0;
    for pol2 in pols do
        if irred[pol1,pol2] = 1 then
            print(cat(pol1, " times ", pol2,  " equals 1"));
            inv := 1;
        fi:
    od:

    if inv = 0 then:
        # should only be zero if it's a field
        print(cat(pol1, " does not have an inverse!"));
    fi:
od:

# they all have an inverse except 0, so it is a field.

#I don't have time for the challenge this week, unfortunately.
