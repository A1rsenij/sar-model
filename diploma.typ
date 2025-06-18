#let diploma(doc) = {
  set page(
    paper: "a4", 
    margin: ("left": 30mm, "right": 15mm, "top": 20mm, "bottom": 20mm),
    footer-descent: 50%,
    numbering: "1"
  )
  set text(
    size: 14pt, 
    font: "Times New Roman",
    lang: "ru"
  )
  set par(
    first-line-indent: (
      amount: 12.5mm,
      all: true
    ),
    justify: true,
  )
  set math.equation(numbering: "(1)")

  set heading(
    numbering: (..nums) => {
      if nums.pos().len() > 1 {nums.pos().map(str).join(".")}
      else if nums.pos() != (0,) {"Глава " + nums.pos().map(str).join("") + "."}
      else {""}
    }
  )

  show heading.where(
    level: 1
  ): it => pad(left: 0mm)[
    #set align(center)
    #set text(14pt)
    #let num = counter(heading).display()
    #num #it.body
  ]

  show heading.where(
    level: 2
  ): it => pad(left: 0mm)[
    #set align(center)
    #set text(14pt)
    #let num = counter(heading).display(it.numbering)
    #num #it.body
  ]

  show heading.where(
    level: 3
  ): it => pad(left: 12.5mm)[
    #set align(left)
    #set text(14pt)
    #let num = counter(heading).display(it.numbering)
    #it.body
  ]
  let tab_counter = counter("tab_counter")
  tab_counter.update(1)
  let image_counter = counter("image_counter")
  image_counter.update(1)

  let getSupplement(it) = {
     // see in "View Example": https://typst.app/docs/reference/meta/ref/#parameters-supplement
     if it.func() == table {
         [Таблица]
     } else if it.func() == image {
         [Рисунок]
     } else { // keep original
         ""
     }
   }

  set figure(supplement: getSupplement)
  
  let isFig(it) = {
    true
  }

  show figure.where(
    kind: table
  ): set figure.caption(position: top)

  set figure.caption(separator: [ --- ])
  
  show ref: it => {
    let eq = math.equation
    let fig = figure
    let tab = table
    let img = image
    let sec = heading
    let el = it.element
    if el != none and el.func() == eq {
      // Override equation references.
      numbering(
        el.numbering,
        ..counter(eq).at(el.location())
      )
    } 
    else if el != none and el.func() == sec {
      numbering(
        el.numbering,
        ..counter(sec).at(el.location())
      )
    }
    else if el != none and el.func() == fig and el.kind == image {
      numbering(it.element.numbering, ..it.element.counter.at(it.target))
    }
    else if el != none and el.func() == fig and el.kind == table {
      numbering(it.element.numbering, ..it.element.counter.at(it.target))
    }
    else {
      it 
    }
  }
  doc
}