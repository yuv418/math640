FindRP := proc(n):
	return nextprime(rand(10^(d-1)..10^d-1)());
end:

IsPrim(g, P) := proc(g,P):
	for i from 1 to P-2 do:
		if g^i mod P=1 then
			return false;
		fi:
	od:

	return true;
end:

FindPrim:=proc(P) local  g:
	for g from 2 to P-2 do
		if IsPrim(g,P) then
			return g:
		fi:
	od:
end:

FindSGP := proc(d,K) local Q,i,ra:
	ra := rand(10^(d-1)..10^d-1):
	for i from 1 to K
		Q:=nextprime(ra());
		if isprime(2*Q+1) then
			return 2*Q+1;
		fi:
	od:

	return FAIL;
