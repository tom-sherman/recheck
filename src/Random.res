type state

@module("./PureRand") external make: int => state = "mersenneMake"
@module("./PureRand") external max: state => int = "max"
@module("./PureRand") external min: state => int = "min"
@module("./PureRand") external next: state => (int, state) = "next"

@module("pure-rand")
external _uniformIntDistribution: (int, int, state) => (int, state) = "uniformIntDistribution"

let uniformIntDistribution = (rng, from, too) => _uniformIntDistribution(from, too, rng)
