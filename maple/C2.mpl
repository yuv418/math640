Help:=proc():
    print(` NextPrime1(n),MakeRSAkey(D1),ME1s(a,e,n),ME1(a,e,n) `):
end:

#NextPrime(n): input a positive integer n and outputs the first prime >=n
NextPrime1:=proc(n) local i:
    for i from n while not isprime(i) do od:
    i:
end:

#RSA: The key (n,e): a->a^e mod n
#n must be a product of two primes
#inputs D1 and outputs an RSA key
#[n, e], where is n is a product of two primes
#with D1 digits. Try:
#MakeRSAkey(100);
MakeRSAkey:=proc(D1) local n,p,q:
    n:=NextPrime1(rand(10^(D1)..10^(D1+1))()):
end:

#ME1s(a,e,n): a^e mod n, the stupid way
ME1s:=proc(a,e,n) local i,s:
    s:=1:
    for i from 1 to e do
        s:=s*a mod n:
    od:
    s:
end:

#ME1(a,e,n): a^e mod n, the stupid way
ME1:=proc(a,e,n) local i,s,d:
    if e=1 then
        return (a mod n):
    fi:

    if e mod 2 = 0 then
        d:=ME1(a, iquo(e,2), n):
        return (d*d mod n):
    else
        return ((ME1(a, e-1, n) * a) mod n)
    fi:
end:

#(a+1)^p mod p=a^p + 1^p mod p=a+1
#
#(a+1)^p = a^p + p*a^(p-1) + p*(p-1)*...*(p-k+1)/k!*a(p-k))... + p*a + 1
#
#Euler extension
#
#a^(phi(n))=1 mod n
