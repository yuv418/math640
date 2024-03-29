#OK to post homework
#Ramesh Balaji,2/17/2024,hw8

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

# Part 1

HammingWeight := proc(v) local i:
    return add([seq(ifelse(i <> 0, 1, 0), i in v)]):
end:

WtEnumerator := proc(q,M,t) local B, C, v:
    # Convert the generating matrix to an array
    B := convert(M, set);
    # Generate the code
    C := LtoC(q, B);

    return add([seq((t^(HammingWeight(v))) mod q, v in C)]):
end:

# Part 2: I would have tried this part, but unfortunately I
# have no time this week.
