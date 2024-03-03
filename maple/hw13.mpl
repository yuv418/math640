#Feb. 29, 2024 C13.txt
Help:=proc(): print(` CCshop(n,q,x,K), V(a,r) `):end:

with(linalg):

#C12.txt: Feb. 26, 2024
Help12:=proc(): print(`CtoL(n,x,g), AllFactors(n,q,x) `):end:


Help11:=proc(): print(` G24(), G12(), CycS(u) , IsCC(q,M), AllPols(q,d,x) , Mul(q,P1,P2,x,f)`):
print(` MonicPols(q,d,x), Irreds(q,d,x) `):

end:

#old code
#C10.txt, F2b. 19, 2024

Help10:=proc(): print(` TRA(M), Ham2pcm(r) , Ham2(r) , Encode(q,M,u), Decode(q,M,v)  `):end:

#From Gloria Liu
Help10hw:=proc(): print(` Hampc(r,q), Ham(r,q), EncodeHamming(q,r,u),  DecodeHamming(q,r,v), TestDecodeHamming(q,r) `):end:

#old code
#C9.txt, Feb. 15, 2024
Help9:=proc(): print(` SynT(q,M), WtEnumerator(q,M,t), antiPCM(q,H), DecodeLT(q,M) `): end:


#OLD CODE
#C8.txt Feb. 12, 2024
Help8:=proc(): print(` PCM(q,M) `):end:

#C7.txt, Feb. 8, 2024
Help7:=proc(): print(` NN(C,v), DecodeT(q,n,C) , GLC1(q,M,d) , GLC(q,n,d), SAah(q,n,M)`):end:


#Feb. 5, 2024, C6.txt#C5.txt, Feb. 1, 2024
Help6:=proc(): print(`LtoC(q,M), MinW(q,M), SFde(q,M) `):end:


Help5:=proc(): print(`Nei(q,c), SP(q,c,t), GRC(q,n,d), GRCgs(q,n,d) , MinD(C), CV(S,n)`):
print(`BDtoC(BD,n)`):
end:

#Old code
#Jan. 29, 2024 C4.txt
Help4:=proc(): print(`Fqn(q,n), HD(u,v), RV(q,n) , RC(q,n,d,K), SPB(q,n,t), BDfano(), BDex212() `):end:


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

#end of old code

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


#GRCgs(q,n,d): George Spahn's version
GRCgs:=proc(q,n,d) local S,A,v:
print(`Warning: use at your own risk`):
A:=Fqn(q,n):
S:={}:
while A<>{} do:
 v:=A[rand(1..nops(A))()]:
 S:=S union {v}:
 A:=A minus SP(q,v,d-1):
od:
S:
end:

#MinD(C): The minimal (Hamming) distance of the code C
MinD:=proc(C) local i,j:
min( seq(seq(HD(C[i],C[j]),j=i+1..nops(C)), i=1..nops(C))):
 end:

#CV(S,n): the characteristic vector of the subset S of {1,...,n}
CV:=proc(S,n) local v,i:
v:=[]:
for i from 1 to n do
 if member(i,S) then
  v:=[op(v),1]:
 else
  v:=[op(v),0]:
 fi:
od:
v:
end:

BDtoC:=proc(BD,n) local s, C:
C:={seq(CV(s,n),s in BD)}:
C:=C union subs({0=1,1=0},C):
C union {[0$n],[1$n]}:
end:

##end of old stuff
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

#MinW(q,M): The minimal weight of the Linear code generated by M over GF(q)
MinW:=proc(q,M) local n,C,c:
n:=nops(M[1]):
C:=LtoC(q,M):

min( seq(HD(c,[0$n]), c in C minus {[0$n]} )):

end:

####end of old code
#start new code for C7.txt

#NN(C,v), inputs a code C (subset of Fqn(q,n) where n:=nops(v)) finds
#the set of members of C closest to v
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

#GLC1(q,M,d): tries to add a new member to the current basis M out of the other vectors
#that still has min. weight d
GLC1:=proc(q,M,d) local n,A,c,M1:
n:=nops(M[1]):
A:=Fqn(q,n) minus LtoC(q,M):
for c in A do
 M1:=[op(M),c]:
 if MinW(q,M1)=d then
   RETURN(M1):
 fi:
od:
FAIL:
end:




#GLC(q,n,d): inputs q and n and d (for min. distance) greedily and randomly tries to
#get as large a linear code given by a basis as possible)
GLC:=proc(q,n,d) local M,M1:
M:=[[1$d,0$(n-d)]]:
M1:=GLC1(q,M,d):
while M1<>FAIL do
 M:=M1:
 M1:=GLC1(q,M,d):
od:
M:
end:

#SA(q,n,M): inputs a basis M of a linear [n,nops(M),d] code outputs Slepian's Standard Array
#as a matrix of vectors containing all the vectors in GF(q)^n (alas Fqn(q,n)) such that
#the first row is an ordering of the members of the actual code (LtoC(q,M)) with
#[0$n] the first entry and the first columns are the coset reprenatives

SA:=proc(q,n,M) local SL,C,A:
 C:=LtoC(q,M):
 C:=C minus {[0$n]}:
 SL:=[[0$n],op(C)]:
 A:=Fqn(q,n) minus {op(SL[1])}:
  #write a function minW(A) that finds a vector of smallest weight among A
  #choose it as the next coset represntatice a1
  #the next row is a1+SL[1]:

    #keep updating A until you run out of vectors in Fq(q,n)
end:










###start code by Daniel Elwell
# PART 4: SF() PROCEDURE:
# -----------------------

# gets a row from a matrix
GetRow:=proc(M,r) local v,i,n:
    v:=[];
    n:=nops(M[1]);

    for i from 1 to n do:
        v:=[op(v),M[r,i]];
    od;

    return v;
end;

# sets a row in a matrix
SetRow:=proc(M,r,v) local i,M1:
    M1:=copy(M);

    for i from 1 to nops(v) do:
        M1[r,i]:=v[i];
    od;

    return M1;
end;

# gets a column from a matrix
GetCol:=proc(M,c) local v,i,n:
    v:=[];
    n:=nops(M);

    for i from 1 to n do:
        v:=[op(v),M[i,c]];
    od;

    return v;
end;

# sets a column in a matrix
SetCol:=proc(M,c,v) local i,M1:
    M1:=copy(M);

    for i from 1 to nops(v) do:
        M1[i,c]:=v[i];
    od;

    return M1;
end;


# returns matrix M in standard form
SFde:=proc(q,M) local k,n,i,j,S,rj,cj,ri:
    k:=nops(M);
    n:=nops(M[1]);
    S:=copy(M);

    for i from 1 to k do: # algorithm is iterated from 1 to k
        # if S_ii = 0, then we need to perform a swap:
        if S[i,i] = 0 then
            for j from i+1 to k while S[j,i] = 0 do od; # look for available row

            if j<=k then # swap rows
                rj:=GetRow(S,j);
                S:=SetRow(S,j, GetRow(S,i));
                S:=SetRow(S,i,rj);

            else # look to swap columns

                for j from i+1 to n while S[i,j] = 0 do od; # look for available col

                # swap cols
                cj:=GetCol(S,j);
                S:=SetCol(S,j, GetCol(S,i));
                S:=SetCol(S,i,cj);
            fi;
        fi;

        # scale row to have leading entry 1
        ri:=GetRow(S,i);
        ri:=(ri*(ri[i]&^(-1) mod q)) mod q;
        S:=SetRow(S,i,ri);

        for j from 1 to k do:
            if j <> i then
                rj:=GetRow(S,j);
                rj:=(rj - (rj[i] * ri mod q)) mod q;
                S:=SetRow(S,j,rj);
            fi;
        od;
    od;

    return S;
end;

###end code by Daniel Elwell

#start code from Aurora Hiveley
# finds a vector of smallest weight among A (collection of given vectors)
minW := proc(A) local n,v,w,minw,minv:
n:= nops(A[1]):
minw := HD(A[1],[0$n]):
minv := A[1]: # initialize min weight vectors

for v in A do
    w:= HD(v,[0$n]):
    if w < minw then
        minw := w :
        minv := v :
    fi:
od:

minv;
end:


#SAah(q,n,M): inputs a basis M of a linear [n,nops(M),d] code outputs Slepian's Standard Array
#as a matrix of vectors containing all the vectors in GF(q)^n (alas Fqn(q,n)) such that
#the first row is an ordering of the members of the actual code (LtoC(q,M)) with
#[0$n] the first entry and the first columns are the coset reprenatives

SAah:=proc(q,n,M) local SL,C,A,a,r1,r,j:
option remember:
# copied from class
 C:=LtoC(q,M):
 C:=C minus {[0$n]}:


# added
 r1 := [[0$n],op(C)]:
 SL := [r1]:
 A:=Fqn(q,n) minus {op(r1)}: # changed from class

 while A<>{} do
    # find coset representative of min weight
    a := minW(A) :

    # build next row
    r := []:
    for j from 1 to nops(r1) do
        r := [op(r), a + r1[j] mod q]:
    od:
    # add new row to array
    SL := [op(SL), r];

    # print(SL);
    # update available vectors
    A := A minus {op(SL[-1])}:

 od:

SL;
end:
#end  code from Aurora Hiveley

#start new code for C8.txt
#PCM(q,M): inputs the mod. q and a non-empty basis (a list of lists)
#n=nops(M[1]) M is k by n matrix and H=PCM(q,M) is an n-k by n matrix
#describing the basis of some linear code over GF(q)^n outputs of dimension k=nops(M)
#the (n-k) by n
PCM:=proc(q,M) local k,n,i,j,H:
option remember:
k:=nops(M):
n:=nops(M[1]):

if [seq([op(1..k,M[i])],i=1..k)]<>[seq([0$(i-1),1,0$(k-i)],i=1..k)] then
 print(`Not standard form , please use SFde(q,M) first `):
 RETURN(FAIL):
fi:

for i from 1 to n-k do
 for j from 1 to k do
  H[i,j]:=-M[j][i+k]  mod q:
 od:
 for j from k+1 to n do
  if j-k=i then
   H[i,j]:=1:
  else
   H[i,j]:=0:
  fi:
od:
od:

[seq([seq(H[i,j],j=1..n)],i=1..n-k)]:
end:

#DP(q,u,v):
DP:=proc(q,u,v) local i,n:
n:=nops(u):
add(u[i]*v[i],i=1..n) mod q:
end:

#Syn(q,H,y): The syndrom of the transmitted vector y if the PCM is H
#(a row vector of length n-k)
Syn:=proc(q,H,y) local i:
[seq(DP(q,y,H[i]),i=1..nops(H))]:
end:

#END OF OLD CODE

#SynT(q,M): inputs q and a basis (in standard form) M of some linear code over GF(q)
#outputs the syndrom table mapping each possible syndorm to its correponding
#coset leader in its standard array.
SynT:=proc(q,M) local n,T,A,H,S,s,i:
option remember:
#S is the set of syndroms and T is the synrome table
if SFde(q,M)<>M then
 RETURN(FAIL):
fi:
n:=nops(M[1]):
A:=SAah(q,n,M):
H:=PCM(q,M):
S:={}:
for i from 1 to nops(A) do
 s:=Syn(q,H,A[i][1]):
 S:=S union {s}:
 T[s]:=A[i][1]:
od:
op(T),S:
end:


####added after class

#Start Code by Joseph Koutsoutis
#WtEnumerator(q,M,t): The weight-enumerator, in t, of the linear code generated by the basis M over GF(q)
WtEnumerator := proc(q,M,t) local v,C,zero,n:
 n := nops(M[1]):
 zero := [0$n]:
 C := LtoC(q,M):
 add(t^HD(zero,v), v in C):
end:

##end code by Joseph Koutsoutis

#start code by Pablo Blanco
# input q, the modulus and a parity check matrix H in standard form. H:= [-A^T | I_{n-k}] has k rows and n columns.
# outputs M, the corresponding generating matrix. M := [ I_k | A] has n-k rows and n columns. A has k rows and n-k columns.
antiPCM:=proc(q,H) local A,B,M,n,rows,k,co,tempCol:
 rows:=nops(H): # this is n-k
 n:=nops(H[1]): # number of H columns
 k:= n-rows:

 B:=extractMCols(1,k,H):                         # this is -A^T, we wish to return [I_k | A].
 tempCol := extractMCols(1,1,B):                 # take the first column, negate it
 A:= [[seq(op(tempCol[k]), k=1..nops(tempCol))]]:  # make the first column into a row

 for co from 2 to k do:
   tempCol := extractMCols(co,co,B): # take the (co)-th column
   A:= [op(A), [seq(op(tempCol[k]), k=1..nops(tempCol))]]: # add the co-th column as a row
 od:

 A:= -A mod q: # we took the transpose, now we negate.

 co:=1:
 M:=A:
 for co from 1 to k do: #we will append the identity matrix row by row
  M[co] := [0$(co-1), 1, 0$(k-co),op(A[co])]:
 od:

 M:
end:

# a few helper functions:

# extracts rows i through j of matrix M, returns a matrix with those rows
extractMRows := proc(i,j,M) local colN,k:
 colN:=nops(M[1]): # number of columns of M
 [seq(M[k][1..colN] ,k=i..j)]
end:

# extracts columns i through j of matrix M, returns a matrix with those columns
extractMCols := proc(i,j,M) local rowN,k:
 rowN:= nops(M): # number of rows of M
 [seq( M[k][i..j] , k=1..rowN)]:
end:

# DecodeLT(q,M).
DecodeLT := proc(q,M) local T,n,V,S,v,syn,H:
 option remember:
 n:=nops(M[1]):
 T:= SynT(q,M)[1]:
 V:= Fqn(q,n):
 S:=table():
 H:=PCM(q,M):
 for v in V do:
  syn:= Syn(q,H,v):
  S[v]:= v-T[syn] mod q:
 od:
 op(S):
end:

#End code by Pablo Blanco

#TRA(M): inputs a matrix M as a list of lists outputs the transpose matrix
#also as a list of lists
TRA:=proc(M) local i,j:[seq([seq(M[j][i],j=1..nops(M))],i=1..nops(M[1]))]:end:

#Ham2pcm(r): The parity check matrix of the binary Hamming code of order r
Ham2pcm:=proc(r) local M,i:
M:=Fqn(2,r) minus {[0$r], seq([0$(i-1),1,0$(r-i)],i=1..r)}:
TRA([op(M),seq([0$(i-1),1,0$(r-i)],i=1..r)]):
end:



#Ham2(r): The generating matrix of the binary Hamming code of order r
Ham2:=proc(r):antiPCM(2,Ham2pcm(r)): end:

Encode:=proc(q,M,u) local i:
if nops(M)<>nops(u) then
  RETURN(FAIL):
fi:
add(u[i]*M[i] ,i=1..nops(M)) mod q :
end:

#Decode(q,M,v): decodes the received vector v to the most likely original transmitted vector u
Decode:=proc(q,M,v) local H,sy,cl:
H:=PCM(q,M):
sy:=Syn(q,H,v):
cl:=SynT(q,M)[1][sy]:
v-cl mod q:
end:



####start new code for C11.txt (Feb. 22, 2024)

#G24(): The BINARY [24,12,8] Golay code
G24:=proc() local A,i:
A:=
[

[0,1$11],
[1$3,0,1$3,0$3,1,0],
[1$2,0,1$3,0$3,1,0,1],
[1,0,1$3,0$3,1,0,1$2],
[1$4,0$3,1,0,1$2,0],
[1$3,0$3,1,0,1$2,0,1],
[1$2,0$3,1,0,1$2,0,1$2],
[1,0$3,1,0,1$2,0,1$3],
[1,0$2,1,0,1$2,0,1$3,0],
[1,0,1,0,1$2,0,1$3,0$2],
[1$2,0,1$2,0,1$3,0$3],
[1,0,1$2,0,1$3,0$3,1]
]:

[seq([0$(i-1),1,0$(12-i),op(A[i])],i=1..nops(A))]:
end:

#G12(): The  TERNARY [12,6,6] Golay code
G12:=proc() local A,i:
A:=[[0,1,1,1,1,1],
[1,0,1,2,2,1],
[1,1,0,1,2,2],
[1,2,1,0,1,2],
[1,2,2,1,0,1],
[1,1,2,2,1,0]]:

[seq([0$(i-1),1,0$(6-i),op(A[i])],i=1..nops(A))]:
end:


#CycS(u): inputs   a list and outputs the set of all cyclic shift of u
CycS:=proc(u) local i,n:
n:=nops(u):
{seq([op(i..n,u),op(1..i-1,u)],i=1..n)}:
end:

#IsCC(q,M): Is the linear code over GF(q) generated by the basis M cyclic:
IsCC:=proc(q,M) local C,c:
C:=LtoC(q,M):
for c in C do
 if CycS(c) minus C<>{} then
   print(c):
    RETURN(false):
 fi:
od:
true:
end:

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

#Start code from Gloria Liu
#=====================================#
#1. Write a procedure
#Hampcm(r,q) that outputs the parity-check matrix (in standard form) of Ham(r,q),

#HamListHelper(r,q,d) outputs the list of all non-zero r-tuples whose first non-zero entry
#is at the d'th position, and is 1.
HamListHelper:=proc(r,q,d) local i:
#print([op(Fqn(q,r-d))]);
[seq([0$(d-1), 1, op(i)], i in [op(Fqn(q,r-d))])]:
end:

wt:=proc(v) local i, result:
result:=0:
for i in v do
 if i<>0 then
  result:=result + 1:
 fi:
od:
result:
end:

Hampcm:=proc(r,q) local S,i,result,column:
S:=[]:
for i from 1 to r do
 S:=[op(HamListHelper(r,q,i)), op(S)]:
od:
#Permute columns to be in standard form
result:=[]:
for column in S do
 if wt(column) <> 1 then
  result:=[op(result), column]:
 fi:
od:
#append identity at end
result:=[op(result), seq([0$(i-1), 1, 0$(r-i)], i=1..r)]:
TRA(result):
end:

#=====================================#
#2. Write a procedure
#Ham(r,q)
#that outputs a generating matrix for Ham(r,q)
Ham:=proc(r,q)
antiPCM(q,Hampcm(r,q)):
end:

#=====================================#
#3.Using the bottom half of p. 88, write a procedure
#DecodeHamming(q,r,v)
#that decodes a received vector v if Ham(r,q) was used. Experiment with it, by coding a random
#message vector, getting a code-word, randomly changing ONE place, and then decoding it. Did you get
#the same thing?

DecodeHamming:=proc(q,r,v) local S,H,b,j,Ht,result:
H:=Hampcm(r,q):
S:=Syn(q,H,v):
if S=[0$(nops(H))] then
 RETURN(v):
fi:
Ht:=TRA(H):
for j from 1 to nops(Ht) do
 for b from 1 to q-1 do
  if S=b*Ht[j] then
   result:=[op(1..j-1, v), v[j]-b mod q, op(j+1..nops(v),v)]:
   RETURN(result):
  fi:
 od:
od:
end:

#Test DecodeHamming
TestDecodeHamming:=proc(q,r) local M,C,v,c,v1:
M:=Ham(r,q):
C:=LtoC(q,M):
v:=C[rand(1..nops(C))()]:
c:=rand(1..nops(v))():
v1:=v + [0$(c-1), 1, 0$(nops(v)-c)] mod q:
if DecodeHamming(q,r,v1)=v then
 print(Success);
fi:
end:

#end code from Gloria Liu

#start new code for C12.txt: The generator matrix for the cyclic code <g(x)> over R_n (mod x^n-1)
CtoL:=proc(n,x,g) local r,L,i:
r:=degree(g,x):
L:=[seq(coeff(g,x,i),i=0..r)]:
[seq([0$i,op(L), 0$(n-r-1-i)],i=0..n-r-1)]:
end:

with(combinat):
#AllFactors(n,q,x): all the factors of x^n-1 mod q (q is a prime)
AllFactors:=proc(n,q,x) local S,s:
S:=Factor(x^n-1) mod q:
S:=powerset({op(S)}) minus {{},{op(S)}}:

{seq(expand(convert(s,`*`)) mod q,s in S)}:
end:

#start new code for Feb. 29, 2024, C13.txt

#CCshop(n,q,x,K): shopping for codes with codewords of length n over GF(q) Fqn(q,n)
#with at most K code words if M is the basis corresponding to g (q^nops(M)<=K)
CCshop:=proc(n,q,x,K) local C,S,M,g,w:
S:=AllFactors(n,q,x):
C:={}:

for g in S do
    if g <> 0 then:
        M:=CtoL(n,x,g):
        if q^nops(M)<=K then
        w:=MinW(q,M):
        C:=C union {[g,evalf(nops(M)/n),w]}:
        fi:
    fi:
od:
C:
end:

#V(a,r): The r by r Vandermonde matrix whose i,j,entry is a[j]^(i-1)
V:=proc(a,r) local i,j:
[seq([seq(a[j]^(i-1),j=1..r)],i=1..r)]:
end:

#Vd(a,r): the explicit expression for the determinant of V(a,r)
Vd:=proc(a, r) local i, j;
    mul(mul(a[j] - a[i], j = i + 1 .. r), i = 1 .. r);
end:


####
####
#### PART ONE
####
####

CCshopF:=proc(N,q,x,K,R,W) local i:
    out := {};
    for i from 2 to N do
        for j in CCshop(i,q,x,K) do
            if j[2] >= R and j[3] >= W then
                out := out union {j}
            fi:
        od:
    od:
    return out:
end:

####
####
#### PART TWO
####
####

CtoDual:=proc(n,q,x,g):
    # convert to dual code polynomial
    h:=sum(seq(coeff(g,x,k-i)), i=0..k);
    return CtoL(n,x,h);
end:
