#C3.txt, Jan. 25, 2024
Help:=proc(): print(` NextPrime1(n),MakeRSAkey(D1), ME1s(a,e,n), ME1(a,e,n) , EA(m,n), EAnew(m,n) `): end:

#NextPrime1(n): inputs a pos. integer n
#and outputs the first prime >=n
NextPrime1:=proc(n) local i:

for i from n while not isprime(i) do od:
i:
end:

#MakeRSAkey: The key [n,e,d]: a->a^e mod n
#n must be a product of two primes
#inputs D1 and outputs an RSA key
#[n,e,d], where n is a product of two primes
#with D1 digits. Try:
#MakeRSAkey(100);
MakeRSAkey:=proc(D1) local n,d,S,m,p,q,e:
p:=NextPrime1(rand(10^(D1-1)..10^D1-1)()):
q:=NextPrime1(rand(10^(D1-1)..10^D1-1)()):
if p=q then
  RETURN(FAIL):
fi:
n:=p*q:
m:=(p-1)*(q-1):
S:=rand(m/2..m-1)():
for e from S to m-1 while gcd(e,m)>1 do od:
d:=e&^(-1) mod m:

[n,e,d]:
end:

#m>n m=n*q+r (r= m mod n)
#gcd(m,n)=gcd(n,r)  
#gcd(n,0)=n
#EA(m,n): inputs m>n and outputs the gcd(m,n)
EA:=proc(m,n) local q,r:
if n=0 then
 RETURN(m):
fi:
r:=m mod n:
EA(n,r):
end:

#ME1s(a,e,n): a^e mod n,the stupid way
ME1s:=proc(a,e,n) local i,s:
s:=1:
for i from 1 to e do
 s:=s*a mod n:
od:
s:
end:

#ME1(a,e,n): a^e mod n,the smart way
ME1:=proc(a,e,n) local i,s:
if e=1 then
 RETURN(a mod n):
fi:
if e mod 2=0 then
 RETURN(ME1(a,e/2,n)^2 mod n):
else
 RETURN(ME1(a,e-1,n)*a mod n):
fi:
end:
                               




#added after class:
#EAnew(m,n): inputs m>n and outputs the gcd(m,n) using iteration rather than recursion
EAnew:=proc(m,n) local m1,n1,m1new:

m1:=m:
n1:=n:

while n1>0 do

m1new:=n1:
n1:=m1 mod n1:
m1:=m1new:
od:

end:
