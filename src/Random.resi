type state
let make: int => state
let next: state => (int, state)
let min: state => int
let max: state => int
let uniformIntDistribution: (state, int, int) => (int, state)
