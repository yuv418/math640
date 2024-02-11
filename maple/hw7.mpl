# NOTE BEFORE SUBMIT: REMOVE COMMENTS AROUND EXPENSIVE THINGS

#Alphabet {0,1,...q-1}, Fqn(q,n): {0,1,...,q-1}^n
Fqn:=proc(q,n) local S,a,v:
option remember:
if n=0 then
 RETURN({[]}):
fi:
S:=Fqn(q,n-1):

{seq(seq([op(v),a],a=0..q-1), v in S)}:
end:

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

NN:=proc(C,v) local i,rec,cha:
cha:={C[1]}:
rec:=HD(v,C[1]):
for i from 2 to nops(C) do
 if HD(v,C[i])<rec then
  cha:={C[i]}:
  rec:=HD(v,C[i]):
 elif HD(v,C[i])=rec then
   cha:=cha union {C[i]}:
 fi:
od:

cha:
end:

#Constructs once and for all a table that sends every member of Fqn(q,n) to one of
#its nearest neighbor
DecodeT:=proc(q,n,C) local S,v,T:
S:=Fqn(q,n):

for v in S do
  T[v]:=NN(C,v)[1]:
od:
op(T):
end:

#Nei(q,c): all the neighbors of the vector c in Fqn(q,n)
Nei:=proc(q,c) local n,i,a:
n:=nops(c):
{seq(seq([op(1..i-1,c),a,op(i+1..n,c)], a=0..q-1) , i=1..n)}:
end:

#SP(q,c,t): the set of all vectors in Fqn(q,n) whose distance is <=t from c
SP:=proc(q,c,t) local S,s,i:
S:={c}:
for i from 1 to t do
 S:=S union {seq(op(Nei(q,s)),s in S)}:
od:
S:
end:

#LtoC(q,M): inputs a list of basis vectors for our linear code over GF(q)
#outputs all the codewords (the actual subset of GF(q)^n with q^k elements
LtoC:=proc(q,M) local n,k,C,c,i,M1:
option remember:
k:=nops(M):
n:=nops(M[1]):
if k=1 then
 RETURN({seq(i*M[1] mod q,i=0..q-1) }):
fi:
M1:=M[1..k-1]:
C:=LtoC(q,M1):
{seq(seq(c+i*M[k] mod q,i=0..q-1),c in C)}:
end:

#MinW(q,C): The minimal weight of the given code.
#MODIFIED to return index
MinW:=proc(q,M) local n,C,c:
n:=nops(M[1]):

M[min[index]( [seq(HD(c,[0$n]), c in M minus {[0$n]} )] )]:

end:


GRC:=proc(q,n,d) local S,A,v:
A:=Fqn(q,n):
S:={}:
while A<>{} do:
 v:=A[1]:
 S:=S union {v}:
 A:=A minus SP(q,v,d-1):
od:
S:
end:

# Part 2: line 7 --> part a should have that the received vector is

# 0011. Then the decoded word should be 0011 - 1000 = 1011. Since
# I think the code repeats the first two bits the received message
# should be 10, not 01?

# Part 3: LC(N)
# Simulating a binary symmetric channel??

LC := proc(N) local x:
    x := rand(1..N)();
    if x = 1 then:
        return 1;
    else
        return 0;
    fi:
end:

# add(x[LC(10)],i=1..10000);


# Part 4

TestCode := proc(q,n,C,N,K) local vec_chooser, T, orig_vec, rand_vec, co, i:
    T:=DecodeT(q,n,C):
    vec_chooser:=rand(1..n);
    co:=0;
    for i from 1 to K do:
        orig_vec:=C[vec_chooser()];
        rand_vec:=[seq((orig_vec[i] + LC(N)) mod q,i=1..n)];
        if T[rand_vec] <> orig_vec then
            co++;
        fi:
    end:

    # print("co="||co||",K="||K);
    return evalf(co/K);
end:

# Part 5

(*C:=GRC(2,7,3);
for N in [2,3,4,5,6,7,8,9,10,15,20,30] do
    fail_rate:=TestCode(2,7,C,N,10000);
    print("N="||N||",fail_rate="||fail_rate);
od:
N:='N';
C:='C';*)

# Part 6

#as a matrix of vectors containing all the vectors in GF(q)^n (alas Fqn(q,n)) such that
#the first row is an ordering of the members of the actual code (LtoC(q,M)) with
#[0$n] the first entry and the first columns are the coset reprenatives

SA:=proc(q,n,M) local SL,C,A,coset_next:
 C:=LtoC(q,M):
 C:=C minus {[0$n]}:
 SL:=[[[0$n],op(C)]]:
 A:=Fqn(q,n) minus {seq(SL[1])}:
 #write a function minW(A) that finds a vector of smallest weight among A
 #choose it as the next coset represntatice a1
 #the next row is a1+SL[1]:

 #keep updating A until you run out of vectors in Fq(q,n)

 while nops(A) <> 0 do:
     coset_next := MinW(q,A);
     CC:={seq([seq((C[i][j] + coset_next[j]) mod q, j=1..nops(coset_next))], i=1..nops(C))};
     ins:=[coset_next, op(CC)];
     SL:=[op(SL), ins]:
     A:=A minus {seq(ins)};
 end:
 return SL:
end:

p:=SA(2,4,[[1,0,1,1], [0,1,0,1]]);
nops(p);
# the output is [
# [[0, 0, 0, 0], [0, 1, 0, 1], [1, 0, 1, 1], [1, 1, 1, 0]],
# [[0, 0, 0, 1], [0, 1, 0, 0], [1, 0, 1, 0], [1, 1, 1, 1]],
# [[0, 0, 1, 0], [0, 1, 1, 1], [1, 0, 0, 1], [1, 1, 0, 0]],
# [[1, 0, 0, 0], [0, 0, 1, 1], [0, 1, 1, 0], [1, 1, 0, 1]]
# ]
# note this is not the same as the one in the textbook. That is because LtoC
# outputs the span of the basis in a different order, and the coset leaders are
# chosen in a different order. However, every row has the same vectors.
#
#Note since [0,0,0,1] and [0,0,1,0] have both weight one, we can use either one
#as the coset leader.
