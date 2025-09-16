#let brick(
  kind,
  counter: none,
  numbering: "1.1",
  suffix: none,
  titlefmt: title => title,
  bodyfmt: body => body,
  ..global_block_args,
) = {
  let prefix = if counter == none {
    _ => [*#kind*]
  } else {
    number => if number != none [*#kind #number*] else [*#kind*]
  }

  if counter != none and type(counter) != dictionary {
    counter = (
      step: (..args) => { counter.step(..args) },
      get: (..args) => { counter.get(..args) },
      at: (..args) => { counter.at(..args) },
      display: (..args) => { counter.display(..args) },
    )
  }

  return (
    title: none,
    number: auto,
    body,
    ..local_block_args,
  ) => {
    figure(
      kind: "touvlo:brick",
      supplement: if title != none [#title] else [#kind],
      outlined: false,
    )[#block(
        width: 100%,
        ..global_block_args.named(),
        ..local_block_args.named(),
      )[
        #if counter != none [
          #if number != auto [
            #metadata({
              if title != none [#title] else if (
                number != none
              ) [#kind #number] else [#kind]
            })
            #label("touvlo:ref")
          ] else [
            #(counter.step)()
            #(number = context (counter.display)(numbering))
            #context (
              [
                #metadata(if title != none [#title] else [#kind #(
                    counter.display
                  )(numbering)])
                #label("touvlo:ref")
              ]
            )
          ]
        ] else [
          #metadata(_ => {
            if title != none [#title] else [#kind]
          })
          #label("touvlo:ref")
        ]


        #box[
          #titlefmt([
            #if (
              title != none
            ) [#prefix(number) (#title)*.*] else [#prefix(number)*.*]
          ])
        ]
        #bodyfmt(body)
        #suffix
        #parbreak()
      ]]
  }
}

#let proofbrick(
  prefix,
  suffix: $square$,
  titlefmt: title => title,
  bodyfmt: body => body,
  ..global_block_args,
) = {
  return (
    of: none,
    body,
    ..local_block_args,
  ) => {
    let prefix = titlefmt(if of != none [_#prefix #of._] else [_#prefix._])
    let body = body + h(1fr) + sym.wj + sym.space.nobreak + suffix + parbreak()
    figure(
      kind: "touvlo:brick",
      supplement: prefix,
      outlined: false,
    )[#block(
        width: 100%,
        ..global_block_args.named(),
        ..local_block_args.named(),
      )[
        #metadata(prefix)
        #label("touvlo:ref")

        #box(prefix)
        #bodyfmt(body)
      ]]
  }
}

#let touvlo-init(body) = {
  show figure.where(kind: "touvlo:brick"): set align(start)
  show figure.where(kind: "touvlo:brick"): set block(breakable: true)
  show figure.where(kind: "touvlo:brick"): fig => fig.body

  show ref: it => {
    if (
      it.element != none
        and it.element.func() == figure
        and it.element.kind == "touvlo:brick"
    ) {
      let supplement = if it.citation.supplement != none {
        it.citation.supplement
      } else {
        let ref = query(selector(label("touvlo:ref")).after(it.target)).first()
        [#ref.value]
      }

      link(it.target, supplement)
    } else {
      it
    }
  }

  body
}


