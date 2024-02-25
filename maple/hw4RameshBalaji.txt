#OK to post homework
#Ramesh Balaji,2/4/2024,hw4

# Part 1: Maple

with(linalg):

A:=matrix(3, 4, [1, 1, 3, -3, 5, 5, 13, -7, 3, 1, 7, -11]);
gausselim(A);
B:=matrix(2, 2, [1, 2, 0, 4]);
eigenvals(B);
eigenvects(B);


C:=randmatrix(3, 3);

if 2>1 then
    print("greater than")
else
    print("less than");
fi:

for i from 2 by 7 to 29 do
    print("i is " || i);
od:

g := proc(x) global m:
    m := 1+x;
    return x*2;
end:

g(1);
print(m);
g(22);
print(m);

latex(randmatrix(7, 7));


# Part 2: Exercise 1.1

# I used
# https://www.piskelapp.com/p/create/sprite
#
# And then exported it as a C array, and used that machine representation to
# generate this.

initials := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

nops(initials);
ifactor(%);

#
# Part 3
#

HD:=proc(u,v) local i,co:
co:=0:
for i from 1 to nops(u) do
  if u[i]<>v[i] then
      co:=co+1:
  fi:
od:
co:
end:

#RV(q,n): A random word of length n in {0,1,..,q-1}
RV:=proc(q,n) local ra,i:
ra:=rand(0..q-1):
[seq( ra(), i=1..n)]:
end:

#RC(q,n,d,K): inputs q,n,d, and K and keeps picking K+1 (thanks to Nuray) random vectors
#whenver the new vector is not distance <=d-1 from all the previous one
RC:=proc(q,n,d,K) local C,v,i,c:
C:={RV(q,n)}:
for i from 1 to K do
 v:=RV(q,n):
  if min(seq(HD(v,c), c in C))>=d then
   C:=C union {v}:
  fi:
od:
C:
end:

# WARNING: This is expensive!

for nn from 5 to 16 do
    for dd in [3,5,7] do
        max_code_len := max( seq( nops( RC(2, nn, dd, iquo(30000,nn)) ), i=1..7 ) );
        table24[n=nn][d=dd] := max_code_len;
    od:
    print("Finished n = " || nn)
od:

op(table24);

# The general obersvation is,
# for example:
#
# op(table24[n=15][d=3]); outputs 326, which is a far cry from the 2048
# op(table24[n=15][d=5]); outputs 51, which is a far cry from the 256
# op(table24[n=15][d=7]); outputs 11, which is a far cry from the 32
#
# But for lower numbers, like
# op(table24[n=5][d=3]);, outputs the accurate 4.

#
# Part 4: Do math with maple
#

# Note that since d=3, we have that 3=2t+1 and t = 1
# Every sum element is just 2^r - 1 because (q-1) equals 1 as q=2 (binary code).

q:=2;
t:=1;
n:=2^r - 1;

sphere_packing_bound := M*sum(binomial(n, k) * (q-1), k=0..t) = q^n;
M_soln := simplify(solve(sphere_packing_bound, M));

# Thus we have M = 2^(2^r - 1 - r).
