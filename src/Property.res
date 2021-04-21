type t<'a> = {generate: Random.state => ('a, Random.state), run: 'a => bool}

let property = (arb: Arbitrary.t<'a>, predicate) => {
  generate: rng => arb.generate(rng),
  run: value => predicate(value),
}

let asserts = property => {
  for seed in 0 to 100 {
    let rng = Random.make(seed)
    let (value, _) = property.generate(rng)

    if !property.run(value) {
      let value = Js.Json.stringifyAny(value)->Belt.Option.getWithDefault("{}")
      Js.Exn.raiseError(`Property failed after ${string_of_int(seed + 1)} runs with value ${value}`)
    }
  }
}
