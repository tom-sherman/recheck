const prand = require('pure-rand');

module.exports.mersenneMake = seed => prand.mersenne(seed)

module.exports.max = rng => rng.max()
module.exports.min = rng => rng.min()
module.exports.next = rng => rng.next()

prand.uniformIntDistribution