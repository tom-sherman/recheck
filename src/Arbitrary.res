type t<'a> = {generate: Random.state => ('a, Random.state)}

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

let int = (~min=-Js.Int.min, ~max=Js.Int.max, ()) => {
  generate: rng => rng->Random.uniformIntDistribution(min, max),
}

let nat = (~max=Js.Int.max, ()) => int(~min=0, ~max, ())

let bool = () => nat(~max=1, ())->map(n => n == 0)

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
      let (size, next) = nat(~max=10, ()).generate(rng)
      generate(size, arb, next)
    },
  }
}

let character = () => nat(~max=25, ())->map(n => Js.String.fromCharCode(97 + n))

let string = () => array(character())->map(characters => characters->Js.Array2.joinWith(""))

let option = a =>
  tuple2(a, bool())->map(((a, b)) =>
    switch b {
    | true => Some(a)
    | false => None
    }
  )

let rec generateN = (arb, n, rng) =>
  if n == 0 {
    []
  } else {
    let (value, next) = arb.generate(rng)

    generateN(arb, n - 1, next)->Js.Array2.concat([value])
  }
