#OK to post homework
#Ramesh Balaji,2/4/2024,hw5

HD:=proc(u,v) local i,co:
co:=0:
for i from 1 to nops(u) do
  if u[i]<>v[i] then
      co:=co+1:
  fi:
od:
co:
end:

#MinD(C): The minimal (Hamming) distance of the code C
MinD:=proc(C) local i,j:
min( seq(seq(HD(C[i],C[j]),j=i+1..nops(C)), i=1..nops(C))):
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

#
# Part 1: being a human
#

# 2.1
#
# Code of (6,2,6) is (1,1,1,1,1,1) and (0,0,0,0,0,0)
# Code of (3,8,1) is (0, 0, 0) (1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (1, 0, 1),
# (0, 1, 1), (1, 1, 1)
# Code of (4, 8, 2) has minimum Hamming distance 2, so
C:= [[0, 0, 0, 0],
 [1, 1, 0, 0], [0, 0, 1, 1], [0, 1, 0, 1], [1, 0, 1, 0], [1, 0, 0, 1], [1, 1, 1, 1], [0, 1, 1, 0]];
MinD(C);
nops(C);
# Code of (5, 3, 4) is impossible. Assume the zero vector is in the code, then
# the other two vectors must have at least 4 ones. Then the two other vectors
# must have max Hamming distance 2, so (5, 3, 4) is impossible.
# Code of (8, 30, 3) has t = 1 and sphere packing bound is M * 9 <= (2^8), so
# M <= 28, so M cannot equal 30.
sum(binomial(8, k) * (2-1), k=0..1);

# 2.2
#
# Choose the first n-1 bits in the bitvector from the code. If the last bit is
# the same for all chosen bit vectors, then M' = M  >= M/2.
#
# In either case, either the set of all vectors with last bit 0 or the set of all vectors
# with last bit 1 form a set with cardinality at least M/2. Choose the set with
# the last bit whose cardinality forms at least M/2. Since the last bit
# is the same, if you remove the last bit, then you have a code of n-1 length
# with Hamming distance d, and its cardinality is at least M/2.
#
# Then note that A2(n, d) >= M and A2(n-1,d) >= M/2, so A2(n-1,d) >= A2(n,d)/2
# so 2A2(n-1,d) >= A2(n,d).

# 2.3 (this is probably wrong... well, not that formal)
#
# Note that to have a code of n=3 and d=2, then the first two values in the
# vector must not be the same for any of the vectors in the code. There are
# q ways to choose the first value and q ways to choose the second value to
# result in something we can use. The third vector must always be different than
# the first two. If we have a vector (q1, q2, q3), if two vectors have the same
# first or second value or then if q3 = q1 + q2 under
# the field Fq, then note that every vector has Hamming distance 2 because if
# q >= 2, we know that q3 != q1 and q3 != q2.
#
# If the two vectors do not have the same first value or second value, then from the
# first two values itself we know the vectors have Hamming distance 2.

# 2.4
#
# Call the code described C and the code without the last bit the code C'. Every codeword in C'
# either has an even or odd weight. After adding a parity check to every
# codeword in C', we note that every codeword in the code is even by definition
# of the parity check. We can always yield a codeword in E_n by adding a parity
# check to an arbitrary vector in F2^(n-1), and the number of vectors in F2^(n-1)
# is 2^(n-1), so we have that C has 2^(n-1) codewords, so it is a (n,2^(n-1), 2).

#
# Part 3, 4, and 5
#

# d must be odd
SPBoundDistance := proc(q, n, M, d) local t, left, right:
    t := iquo(d-1, 2);

    left:=M*sum(binomial(n, k) * (q-1), k=0..t);
    right:=q^n;

    return [left, right];
end:

# My computer cannot handle n = 20, so I made it smaller.
q2 := [seq([seq(nops(GRC(2, n, d)), n=5..14)], d=[3,5,7])];
d := 3;
for outer in q2 do
    n := 5;
    for innera in outer do
        sp := SPBoundDistance(2, n, innera, d);
        sp_left := sp[1];
        sp_right := sp[2];
        sp_dist := sp_right-sp_left;

        print("GRC(q=2,n=" || n || ",d=" || d || ") M=" || innera || ", sp_left=" || sp_left || ", "
              "sp_right=" || sp_right || ", sp_dist=" || sp_dist);
        n++;
    od:
    d += 2;
od:
q3 := [seq([seq(nops(GRC(3, n, d)), n=5..10)], d=[3,5,7])];
d := 3;
for outer in q2 do
    n := 5;
    for innera in outer do
        sp := SPBoundDistance(2, n, innera, d);
        sp_left := sp[1];
        sp_right := sp[2];
        sp_dist := sp_right-sp_left;

        print("GRC(q=3,n=" || n || ",d=" || d || ") M=" || innera || ", sp_left=" || sp_left || ", "
              "sp_right=" || sp_right || ", sp_dist=" || sp_dist);
        n++;
    od:
    d += 2;
od:

q5 := [seq([seq(nops(GRC(5, n, d)), n=5..7)], d=[3,5,7])];
d := 3;
for outer in q2 do
    n := 5;
    for innera in outer do
        sp := SPBoundDistance(2, n, innera, d);
        sp_left := sp[1];
        sp_right := sp[2];
        sp_dist := sp_right-sp_left;

        print("GRC(q=5,n=" || n || ",d=" || d || ") M=" || innera || ", sp_left=" || sp_left || ", "
              "sp_right=" || sp_right || ", sp_dist=" || sp_dist);
        n++;
    od:
    d += 2;
od:

#
# Part 6
#
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
ParaBD := proc(BD, v) local k, b, lam, r, vec, occ, occ_two, i, j:
    k := nops(BD[1]);
    b := nops(BD);

    for vec in BD do:
        if nops(vec) <> k then:
            return FAIL:
        fi:

        # try to find r
        for i in vec do:
            if whattype(occ[i]) <> integer then:
                occ[i] := 1;
            else
                occ[i]++
            fi:
        od:

        for i from 1 to nops(vec) do:
            for j from i+1 to nops(vec) do:
            if whattype(occ_two[vec[i],vec[j]]) <> integer then:
                occ_two[vec[i],vec[j]] := 1;
            else
                occ_two[vec[i],vec[j]]++
            fi:
            od:
        od:

    end:

    # converts the table into a set, which will have more than one element
    # if each point does not lie in exactly r blocks
    print(op(occ));
    occ := convert(op(occ), set);
    print(op(occ));
    if nops(occ) <> 1 then:
        return FAIL;
    else
        r := occ[1];
    end:

    print(op(occ_two));
    occ_two := convert(op(occ_two), set);
    print(op(occ_two));
    if nops(occ_two) <> 1 then:
        return FAIL;
    else
        lam := occ_two[1];
    end:

    return [b, v, r, k, lam];



end:

#
# Part 7: Plotkin
#

PlotkinBound := proc(n, d):
    if d mod 2 = 0 and n < 2*d then:
        return 2*floor(d/((2*d)-n));
    elif d mod 2 = 1 and n < 2*d + 1 then:
        return 2*floor((d+1)/(2*d+1-n))
    elif d mod 2 = 0 and n = 2*d then:
        return 4*d;
    # we could implement more but also, the requirements of this
    # question don't require it.
    end:
end:

#binary
SpherePackingBound := proc(n, d) local t:
    t := floor((d-1) /2);
    return (2^n)/(sum(binomial(n, k), k=0..t));
end:

for d from 2 to 20 do:
    for n from 2 to 2*d do:
        print("n=" || n || ",d=" || d);
        plotkin := PlotkinBound(n, d);
        sphere := floor(SpherePackingBound(n, d));
        print("Plotkin: " || plotkin || " Sphere: " || sphere);
    od:
od:

#
# Part 8: I wish I had time ):
#
