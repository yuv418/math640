# Part 1: MakeCubic

BinToIn:=proc(L) local k,i:
    k:=nops(L):
    #[1,0,1]: 1*2^2+0*2^1+1*2^0
    add(L[i]*2^(k-i)  , i=1..k):
end:

MakeCubic := proc(L, n):
    return BinToIn([op(1..5, L)]) + BinToIn([op(1..5, L)])*n + BinToIn([op(1..5, L)])*(n^2) + BinToIn([op(1..5, L)])*(n^3);
end:


# Part 2: EncodeDES
InToBin:=proc(n,k) local i:
	#option remember:
	if ( n>=2^k or n<0)  or not (type(n,integer)) then
	   RETURN(FAIL):
	fi:

	if k=1 then
	 if n=0 then
	    RETURN([0]):
	 else
	   RETURN([1]):
	 fi:
	fi:
    if n<2^(k-1) then
        RETURN([0,op(InToBin(n,k-1))]):
    else
        RETURN([1,op(InToBin(n-2^(k-1),k-1))]):
    fi:
end:
BinFun:=proc(F,L) local k:
k:=nops(L):
 InToBin(F(BinToIn(L)) mod 2^k,k):
end:

#Feistel(LR,F): The Feistel transform that takes [L,R]->[R+F(L) mod 2, L]
#For example Feistel([1,1,0,1],n->n^5+n);
Feistel:=proc(LR,F) local k,L,R:
k:=nops(LR):
 if k mod 2<>0 then
   RETURN(FAIL):
 fi:
L:=[op(1..k/2,LR)]:
R:=[op(k/2+1..k,LR)]:
[op(R+ BinFun(F,L) mod 2)   ,  op(L)  ]:
end:

EncodeDES := proc(M,K,r) local i:
    # Generate the cubic functions
    F := [];
    for i from 0 to r-1 do:
        F := [op(F), MakeCubic(K[( (i*20) + 1 )..( (i+1) * 20 )], n)]
    od:

    data := M;
    for poly in F do:
        fn := proc(x):subs(n=x, poly):end:
        data := Feistel(data, fn);
    od:

    return data;
end:

# TODO: use maple RNG to show this works for random inputs.

# Generate a random 64-bit integer for the message
# and a random 40-bit integer for the ciphertext

M := InToBin(rand(0..(2^63)-1)(), 64);
K := InToBin(rand(0..(2^40)-1)(), 40);

Ciphertext := EncodeDES(M, K, 2);

# Part 3: DecodeDES

revFeistel:=proc(LR,F) local k,L,R:
    k:=nops(LR):
    if k mod 2<>0 then
    RETURN(FAIL):
    fi:
    L:=[op(1..k/2,LR)]:
    R:=[op(k/2+1..k,LR)]:
    [op(R),      op(L+ BinFun(F,R ) mod 2)    ]:
end:

DecodeDES:=proc(M,K,r):
    # Generate the cubic functions, but backwards.
    F := [];
    for i from r-1 to 0 by -1 do:
        F := [op(F), MakeCubic(K[( (i*20) + 1 )..( (i+1) * 20 )], n)]
    end:

    data := M;
    for poly in F do:
        fn := proc(x):subs(n=x, poly):end:
        data := revFeistel(data, fn);
    end:

    return data;
end:

if M = DecodeDES(Ciphertext, K, 2) then:
    print("Success")
end:
