#Jan. 29, 2024 C4.txt
Help:=proc(): print(`Fqn(q,n), HD(u,v), RV(q,n) , RC(q,n,d,K), SPB(q,n,t), BDfano(), BDex212() `):end:

#Alphabet {0,1,...q-1}, Fqn(q,n): {0,1,...,q-1}^n
Fqn:=proc(q,n) local S,a,v:
option remember:
if n=0 then
 RETURN({[]}):
fi:

S:=Fqn(q,n-1):

{seq(seq([op(v),a],a=0..q-1), v in S)}:

end:

#Def. (n,M,d) q-ary code is a subset of Fqn(q,n) with M elements with
#minimal Hamming Distance d between any two members
#It can detect up to d-1 errors
#
#If d=2*t+1 correct t errors.
#
#
#HD(u,v): The Hamming distance between two words (of the same length)
HD:=proc(u,v) local i,co:
co:=0:
for i from 1 to nops(u) do
  if u[i]<>v[i] then
      co:=co+1:
  fi:
od:
co:
end:

#SPB(q,n,d): The best you can hope for (as far as the size of C) for q-ary (n,2*t+1) code
SPB:=proc(q,n,t) local i:
trunc(q^n/add(binomial(n,i)*(q-1)^i,i=0..t)):
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

BDfano:=proc():
{{1,2,4},{2,3,5},{3,4,6},{4,5,7},{5,6,1},{6,7,2},{7,1,3}}:
end:




BDex212:=proc():
{{1,3,4,5,9},
{2,4,5,6,10},
{3,5,6,7,11},
{1,4,6,7,8},
{2,5,7,8,9},
{3,6,8,9,10},
{4,7,9,10,11},
{1,5,8,10,11},
{1,2,6,9,11},
{1,2,3,7,10},
{2,3,4,8,11}
}
end:

#Nei(q,c) all heighbours of the vector c in Fqn(q,n)
Nei:=proc(q,c):

end:

SPB:=proc(q,n,t) local i:
trunc(q^n/add(binomial(n,i)*(q-1)^i,i=0..t)):
end:

#SP(q,c,t): the set of all vectors in Fqn(q,n) whose distance is <=t from c
SP := proc(q,c,t) local S,s,i:
    S:={c}:
    for i from 1 to t do
        S := S union {seq(op(Nei(q,s)), s in S)}
    end:
    S:
end:


GRC := proc() local S, A:
    A:=Fqn(q,n):
    S:={}:
    while A<>{} do:
        v:=A[1]:
        S:=S union {v}:
        A:=A minus SP(q,v,d-1)
    od:
    S:
end:

MinD := proc(C):
    min(seq(seq(HD(C[i], C[j]), j=i+1..nops(C)), i=1..nops(C)))
