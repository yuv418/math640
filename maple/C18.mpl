
# Random binary word of length k
RW := proc(k) local ra, i:
	ra := rand(0..1);
	return [seq(ra(), i=1..k)];
end:

BinToInL := proc(L) local k:
	k := nops(L)
	return sum(L[i] * 2^(i-1), i=1..k);
end:

InToBin := proc(n,k) local i:
	if ( n >= 2^k or n < 0 ) then	
		return FAIL;
	fi:

	if k = 1 then:
		if n = 0 then:
			return [0];
		else:
			return [1];
		fi:
	end:

	if n < 2^(k-1) then
		return [0, op(InToBin(n, k-1))];
	else
		return [1, op(InToBin(n-2^(k-1), k-1))];
	end:
end:

BinFun := proc(F,L) local k:
	k := nops(L);
	return InToBin(F(BinToIn(L)) mod 2^k,k);
end:

Feistel:=proc(LR, F) locak k:
	k := nops(LR);
	if k mod 2 <> 0 then
		return FAIL;
	fi:

	L := [op(1..k/2,LR)];
	R := [op((k/2)+1..k,LR)];

	return [op(R + BinFun(F,L) mod 2), op(L)];
end:
