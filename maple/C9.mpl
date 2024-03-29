#C7.txt, Feb. 8, 2024
Help:=proc(): print(` NN(C,v), DecodeT(q,n,C) , GLC1(q,M,d) , GLC(q,n,d)`):end:


#Feb. 5, 2024, C6.txt#C5.txt, Feb. 1, 2024
Help6:=proc(): print(`LtoC(q,M), MinW(q,M)`):end:


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
SF:=proc(q,M) local k,n,i,j,S,rj,cj,ri:
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

#inputs q and nonempty basis (a list of lists) describing the basis of some
#n=nops(M[1]) M is a k by n matrix and H:=PCM(q,M) is
#linear code of GF(q)^n outputs.
#the (n-k) by  by n
PCM:=proc(q,M) local k,n,i,j,H,idm:
    k:=nops(M);
    n:=nops(M[1]);

    if [seq([seq(M[i][1..k])], i=1..k)] <> [seq([0$(i-1), 1, 0$(k-i)], i=1..k)] then
        print("Not standard form, please use SFde(q,M) first");
        return FAIL;
    fi:

    for i from 1 to n-k do
        for j from 1 to k do
            for j from 1 to k do
                H[i,j] := (-M[j][i+k]) mod q;
            od:
        od:

        for j from k+1 to n do
            if j-k=i then
                H[i,j]:=1;
            else
                H[i,j]:=0;
            fi:
        od:
    od:

    return [seq([seq(H[i,j], j=1..n)], i=1..(n-k))];
end:

DP:=proc(q,u,v) local i:
    n:=nops(u):
   return (add(u[i] + v[i], i=1..nops(u))) mod q;
end:

#Syn(q,H, y) transmitted vector y if the PCM is H
#(a row vector of length n-k)
Syn:=proc(q,H,y) local i:
    [seq(DP(y,H[i]), i=1..nops(H))]:
end:

# SynT(q,M) inputs q and a basis (in standard form), mapping each possible
# syndrome to its corresponding coset leader in its standard array
SynT:=proc(q,M)
    if SFde(q,M)<>M then
        return FAIL:
    fi:
    n:=nops(M[1]):
    A:=SAah(q,n,M):
    H:=PCM(q,M):
    for i from 1 to nops(A) do
        s:=Syn(q,H,A[i])
    end:
end:

# inputs the mod. q and a PCM H, finds the corresponding
# generating matrix M (in standard form)
# n=nops(H[1]) H is n-k by n matrix and H=PCM(q,M) M is a k by n matrix
# describing the basis of some linear code over GF(q)^n outputs of dimension
# k=nops(M) the (n-k) by n
AntiPCM := proc(q,H) local k,n,i,j,H:
    option remember:

    n:=nops(H[1]):
    k:=n-nops(H)
