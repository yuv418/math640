#OK to post homework
#Ramesh Balaji,2/17/2024,hw9

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

####start code by Daniel Elwell
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

###end code by Daniel Elwell##
HD:=proc(u,v) local i,co:
co:=0:
for i from 1 to nops(u) do
  if u[i]<>v[i] then
      co:=co+1:
  fi:
od:
co:
end:

#Alphabet {0,1,...q-1}, Fqn(q,n): {0,1,...,q-1}^n
Fqn:=proc(q,n) local S,a,v:
option remember:
if n=0 then
 RETURN({[]}):
fi:

S:=Fqn(q,n-1):

{seq(seq([op(v),a],a=0..q-1), v in S)}:

end:

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

SAah:=proc(q,n,M) local SL,C,A,a,r1,r,j:
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

# Part 1: ages

# Gloria Liu: 21
# Himanshu Chandra: 49
# Kaylee Weatherspoon: 22
# Lucy Martinez: 25
# Natalya Ter-Saakov: 24
# Ryan Badi: 20
# Alex Varjabedian: 19
# Aurora Hiveley: 23
# Daniel Elwell: (no Caesar cipher?)
# Isaac Lam: 18
# Nuray Kutlu: 20
# Pablo Blanco: 22
# Ramesh Balaji: 19
# Shaurya Baranwal: 19

# Part 2: AntiPCM

#antiPCM(q,H): inputs the mod. q and a PCM  H, finds the corresponding
#generating matrix M (in standard form)
#n=nops(H[1]) H is n-k by n matrix and H=PCM(q,M) M is a k by n matrix
#describing the basis of some linear code over GF(q)^n outputs of dimension
AntiPCM:=proc(q,H) local k,n,i,j,M:
    option remember:

    n:=nops(H[1]):
    k:=n-nops(H):

    M := [seq( [0$(i-1),1,0$(k-i), seq(H[j][i], j=1..(n-k))], i=1..k )];

    return M;
end:

# Part 3: DecodeLT

VecSub := proc(q, v1, v2) local i:
    return [seq((v1[i] - v2[i]) mod q, i=1..nops(v1))];
end:

DecodeLT := proc(q,M) local T, n, H, V, v:
    n:=nops(M[1]);
    H:=PCM(q,M);

    T:=SynT(q,M);

    V:=Fqn(q,n);

   return table([seq( v=VecSub(q, v, T[1][Syn(q, H, v)]), v in V)]);
end:
