MyIfactor := proc(n): local next_prime:
    if n = 1 then
        return []:
    fi:

    next_prime := 2:
    while irem(n,next_prime) <> 0 do
        next_prime := nextprime(next_prime);
    od:

    return [next_prime, seq(MyIfactor(n/next_prime))]:
end:
