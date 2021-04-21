type t<'a> = {generate: Random.state => ('a, Random.state)}

let int = (~min=-Js.Int.min, ~max=Js.Int.max, ()) => {
  generate: rng => rng->Random.uniformIntDistribution(min, max),
}

let map = (arb, mapper) => {
  generate: rng => {
    let (value, next) = arb.generate(rng)
    (mapper(value), next)
  },
}

let mapWithRandom = (arb, mapper) => {
  generate: rng => {
    let (value, next) = arb.generate(rng)
    mapper(value, next)
  },
}

let bool = () => int(~min=0, ~max=1, ())->map(n => n == 0)

let tuple2 = (a, b) => {
  generate: rng => {
    let (aResult, next) = a.generate(rng)
    let (bResult, next) = b.generate(next)

    ((aResult, bResult), next)
  },
}

let tuple3 = (a, b, c) => {
  generate: rng => {
    let ((aResult, bResult), next) = tuple2(a, b).generate(rng)
    let (cResult, next) = c.generate(next)

    ((aResult, bResult, cResult), next)
  },
}

let array = arb => {
  let rec generate = (size, arb, rng) =>
    if size == 0 {
      ([], rng)
    } else {
      let (value, next) = arb.generate(rng)

      let (values, next) = generate(size - 1, arb, next)

      (values->Js.Array2.concat([value]), next)
    }

  {
    generate: rng => {
      let (size, next) = int(~min=0, ~max=10, ()).generate(rng)
      generate(size, arb, next)
    },
  }
}

let character = () => int(~min=0, ~max=25, ())->map(n => Js.String.fromCharCode(97 + n))

let string = () => array(character())->map(characters => characters->Js.Array2.joinWith(""))

let rec generateN = (arb, n, rng) =>
  if n == 0 {
    []
  } else {
    let (value, next) = arb.generate(rng)

    generateN(arb, n - 1, next)->Js.Array2.concat([value])
  }
