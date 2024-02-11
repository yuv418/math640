# Jan 29 2024 C4.txt
# Alphabet {0, 1, ... q-1}, Fqn(q, n): {0, 1, ..., q-1}^n

Fqn := proc(q,n) local S, a, v:
    if n = 0 then
        return {}:
    fi:

    S := Fqn(q,n-1):

    {seq(seq([op(v), a], a=0..q-1), v in S)}:
end:

#Def (n,M,d) q-ary code is a subset of Fqn(q,n) with M elements with
#minimal Hamming distance d between two members
#
#It can detect up to d-1 errors
#
#If d=2*t+1 correct t errors
#
#HD(u,v): The Hamming distance between two words (of the same length)

HD := proc(u,v) local i,co:
    co:=0:
    for i from 1 to nops(v) do
        if u[i] <> v[i] then
            co++:
        fi:
    end:

    return co:
end:

#RV(q,n) a random word of length n in {0,1...,q-1}
RV := proc(q,n) local x, gen, i1:
    return [seq(rand(0..q-1)(), i1=1..n)]
end:

#RC(q,n,d,K) inputs q,n,d, and K and keeps picking K random vectors
#whenever the new vector is not distance <= d-1 from all the previous ones


RC := proc(q,n,d,K) local C,c,v,i:
    C := {RV(q,n)}:
    for i from 1 to K do
        v := RV(q,n):
        if min(seq(HD(v,c), c in C)) >= d then
            C := C union {v}:
        fi:
    od:
    return C:
end:

# the theoretical max M for (n,d) and q
# sphere packing theory
# d=2*t+1
#
#
# Hamming Sphere with center v and radius d
# 1+(q-1)*binomial(n,1)+
# it's literally just the P(X = j) where X ~ Bin(v,d) or something
#
# Bin

SPB(q, n, d) ----???
