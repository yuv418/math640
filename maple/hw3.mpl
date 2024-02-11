#OK to post homework
#Ramesh Balaji,1/28/2024,hw3

with(Statistics):
with(plots):
with(linalg):

#
# Part 1:
#

# I feel quite confident with Maple now, so only a few examples (of things I am
# a little confused/want more practice with) are included.

# Solve a differential equation.
# y'' + 6y' + 9 = 0

y := f(t):
dy := diff(y, t):
ddy := diff(dy, t):

diff_eq := ddy + 6*dy + 9 = 0:
dsolve(diff_eq, y);

y := 'y':

pdf := 3*exp(-3*x);
plot(pdf);

circle := [sin(t), cos(t), t=0..2*Pi];
plot(circle);

polarplot(cos(6*t), t=0..2*Pi);

# Plot a plane
plot3d(x/20 + y/20 - 3);

animatecurve(sin(exp(x)), x = -2*Pi .. 2*Pi);

# A little linear algebra

f := (i, j) -> i + j;
B := matrix(3, 3, f);
# entermatrix(B);

f := (i, j) -> exp(i*j);
A := matrix(3, 3, f);
evalf(det(A));
evalm(A &* B);

f := 'f':
A := 'A':
B := 'B':

#
# Part 2:
#
# The reason why EAnew is better is because it implements the euclidean
# algorithm using iteration instead of recursion. Recursion uses stack space,
# which means that at some point the recursive function will fail, when the
# iterative one will not use as much memory and not fail. Furthermore,
# the recursive function will use far more memory than the iterative function.
#

EAnew:=proc(m,n) local m1,n1,m1new:
    m1:=m:
    n1:=n:

    while n1>0 do

    m1new:=n1:
    n1:=m1 mod n1:
    m1:=m1new:
    od:
end:

a:=rand(10^50000..10^50001)(): b:=rand(10^50000..10^50001)():
gcd_time := time(gcd(a,b));
eanew_time := time(EAnew(a,b));

print("gcd time is " || gcd_time);
print("EAnew time is " || eanew_time);

# Note that the builtin function took something around 0.005 seconds, whereas
# EAnew took 2.556s (or something around), which is pretty bad!
#
# The igcd function in Maple is interpreted in the Maple runtime, which is C code.
#
# I was curious, so I put the $MAPLE_INSTALL/bin.x86_64_LINUX/libmrt.so (mrt
# standing for Maple RunTime) shared object file into a reverse engineering software (IDA Pro).
# It can give "psuedo-C" code that we can easily read, as opposed to the assembly code
# (also, there are no crazy optimization tricks in the assembly as far as I can see,
# [I can read assembly if I really try]).
#
# unsigned __int64 __fastcall mrt_igcd(__int64 a1, __int64 a2)
# {
#  __int64 v2; // rax
#
#  for ( ; a2; a2 = v2 % a2 )
#  {
#    v2 = a1;
#    a1 = a2;
#  }
#  return abs64(a1);
# }
#
# So it does the same iterative Euclidean algorithm. My guess as to why
# our EAnew is so much slower is because Maple code is probably interpreted,
# as opposed to compiled (even programming languages like Python would have the
# function translated to bytecode after the first read so the code is not
# interpreted during every iteration, which adds a bottleneck).


#
# Part 3: estimating gcd probability
#

# Returns probability that two randomly chosen integers between 1 and n are
# coprime by trying the experiment k times.
EstimateProbGCD := proc(n, k) local gen, n1, n2, i, cnt:
    gen := rand(1..n):

    # Number of coprimes sampled
    cnt := 0:

    for i from 1 to k do
        n1 := gen():
        n2 := gen():

        if gcd(n1, n2) = 1 then cnt++ fi:
    od:

    return cnt/n:
end:

# Do experiment 20 times, and scatter plot results

exp_iterations := 20:

prob_gcd_x := [seq(i1, i1=1..exp_iterations)]:
prob_gcd_y := [seq(EstimateProbGCD(10^10, 10^4), i1=1..exp_iterations)]:

ScatterPlot(prob_gcd_x, prob_gcd_y);

# The answers are pretty close, soemthing around 6000/(10^10)

#
# Part 4: Do not give me 5 dollars. I looked it up.
#
# Two integers a and b are coprime if and only if no prime divides both a and b.
# The probability an integer n divides another integer q is 1/n.
#
# So the probability a prime p divides a and b is 1/(p^2)
#
# So the probability a prime does not divide both a and b is 1-(1/(p^2))
#
#
# Since for every prime p two integers are not divisible by it are mutually
# independent events, you can multiply the events.
#
# The following statements are equivalent.
#
prob := Product(1-(1/p^2), p=prime);
prob_eq := (Product(1/(1-p^(-2))), p=prime)^(-1);
prob_zeta := 1/Zeta(6);

# Which is equivalent to 6/(pi^2)

#
# Part 5: MakeRSAkeyG
#

MakeRSAkeyG:=proc(D1, g) local n,d,e,m,S,i1,nprimes:
    nprimes := [seq(nextprime(rand(10^(D1-1)..10^D1-1)()), i1=1..g)]:

    n := mul(nprimes[i1], i1=1..g):
    m := mul(nprimes[i1]-1, i1=1..g):
    S := rand(m/2..m-1)():

    for e from S to m-1 while gcd(e,m)>1 do od:
    d:=e&^(-1) mod m;

    [n,e,d]:
end:

# One possible (maybe?) reason that MakeRSAkeyG(D1, 3) is less secure because there are more primes in the product
# of n, so since there are more primes the probability that you find a prime
# that factors n is higher when searching for such a prime factor.

#
# Part 6: Signatures
#


key := MakeRSAkeyG(5, 2);

n := key[1];
e := key[2]; # public key
d := key[3]; # private key

# Signing a message is easy: just call D(M) = M^d mod n
msgs := [123, 456, 18273, 1239871, 1, 2, 5, 192, 382];
signatures := [seq(msgs[i1]&^d mod n, i1=1..nops(msgs))];

# We'll put the signatures and messages together, in a tuple (M, S)
msgs_with_signatures := [seq([msgs[i1], signatures[i1]], i1=1..nops(msgs))];

# Verifying a signature is easy, just do E(M^d mod n) = M^ed mod n = M. If the
# output message matches the original message, we have a signed message.
for i1 in msgs_with_signatures do
    m := i1[1]:
    s := i1[2]:

    sig_verify := s &^ e mod n:

    if m = sig_verify then
        print("Message " || m || " has verified its signature!"):
    else
        print("Message " || m || " has INVALID signature! The signature after E(S) "
              "is " || sig_verify):
    fi:
od:
