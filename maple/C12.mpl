CtoL := proc(n,x,g) local r,L,i:
    r:=degree(g,x):
    L:=[seq(coeff(g,x,i), i=0..r)]:
    return [seq([0$i, op(L), 0$(n-r-1-i)], i=0..n-r-1)]
end:


AllFactors:=proc(n,q,x) local S:
    S:=Factor(x^n-1) mod q;
end:
