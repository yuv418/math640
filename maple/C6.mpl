# Linear code generated by generating matrix M=[v1, v2, ... vd]
# over GF(q) if the set of all linear combinations
# a1*v1A + ... + ad*vd
#
# q-ary (n,M,d) code n:=length of each code word
# M:=size of the code (a code is a subset of Fqn(q,n) GF(q)^n (it has q^n elements))
# d:=minimal distance
# q-ary linear [n,k,d] coe is (n, q^k, d)
# Hamming Code (2^r-1, 2^(2^r-r-1), 3)
# (7, 16, 3)
# (15, 2048, 3),

CV:=proc(S, n) local v,i:
    v:=[]:
    for i from 1 to n do
        if member(i, S) then
            v:=[op(v),1]
        else
            v:=[op(v),0]
        fi:
    od:
    return v:
end:

BDtoC := proc(VD, n) local s, C:
    C:={seq(CV(s, n), s in BD)}:
    C:=C union subs({0=1, 1=0}, C):
    C union {[0$n]}:
end:

# Given a list of basis vectors it
LToC := proc(q, M) local n, k, C, i:
    k:=nops(M):
    n:=nops(M[1]):
    if k=1 then
        return {seq(i*M[1] mod q, i=0..q-1)}:
    fi:
    M1 := M[1..k-1]
    C:=LtoC(q,M1):
    {seq(seq(c+(i*M[k] mod q,i=0..q-1),c in C)}
end:

# minimal weight
MinW:=proc(q,M)
    n:=nops(M[1]):
    c:=LtoC(q,M):
    min(seq(HD(c,[0$n], c in C minus {[0$n]})))
end:

# greedly linear code for GF(q)^n and large distance d
# uses greedy random to get as large as possible basis with
# minimal distance d
GLC:=proc(q,n,d)