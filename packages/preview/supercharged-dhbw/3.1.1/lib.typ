#import "@preview/codelst:2.0.1": *
#import "acronym-lib.typ": init-acronyms, print-acronyms, acr, acrpl, acrs, acrspl, acrl, acrlpl, acrf, acrfpl
#import "glossary-lib.typ": init-glossary, print-glossary, gls
#import "locale.typ": TABLE_OF_CONTENTS, LIST_OF_FIGURES, LIST_OF_TABLES, CODE_SNIPPETS, APPENDIX, REFERENCES
#import "titlepage.typ": *
#import "confidentiality-statement.typ": *
#import "declaration-of-authorship.typ": *
#import "check-attributes.typ": *

// Workaround for the lack of an `std` scope.
#let std-bibliography = bibliography

#let supercharged-dhbw(
  title: none,
  authors: (:),
  language: none,
  at-university: none,
  confidentiality-marker: (display: false),
  type-of-thesis: none,
  type-of-degree: none,
  show-confidentiality-statement: true,
  show-declaration-of-authorship: true,
  show-table-of-contents: true,
  show-acronyms: true,
  show-list-of-figures: true,
  show-list-of-tables: true,
  show-code-snippets: true,
  show-appendix: false,
  show-abstract: true,
  numbering-alignment: center,
  toc-depth: 3,
  acronym-spacing: 5em,
  glossary-spacing: 1.5em,
  abstract: none,
  appendix: none,
  acronyms: none,
  glossary: none,
  header: none,
  confidentiality-statement-content: none,
  declaration-of-authorship-content: none,
  titlepage-content: none,
  university: none,
  university-location: none,
  university-short: none,
  city: none,
  supervisor: (:),
  date: none,
  date-format: "[day].[month].[year]",
  bibliography: none,
  bib-style: "ieee",
  heading-numbering: "1.1",
  math-numbering: "(1)",
  logo-left: image("dhbw.svg"),
  logo-right: none,
  logo-size-ratio: "1:1",
  body,
) = {
  // check required attributes
  check-attributes(
    title,
    authors,
    language,
    at-university,
    confidentiality-marker,
    type-of-thesis,
    type-of-degree,
    show-confidentiality-statement,
    show-declaration-of-authorship,
    show-table-of-contents,
    show-acronyms,
    show-list-of-figures,
    show-list-of-tables,
    show-code-snippets,
    show-appendix,
    show-abstract,
    header,
    numbering-alignment,
    toc-depth,
    acronym-spacing,
    glossary-spacing,
    abstract,
    appendix,
    acronyms,
    university,
    university-location,
    supervisor,
    date,
    city,
    bibliography,
    bib-style,
    logo-left,
    logo-right,
    logo-size-ratio,
    university-short,
    heading-numbering,
    math-numbering,
  )

  // set the document's basic properties
  set document(title: title, author: authors.map(author => author.name))
  let many-authors = authors.len() > 3

  init-acronyms(acronyms)
  init-glossary(glossary)

  // define logo size with given ration
  let left-logo-height = 2.4cm // left logo is always 2.4cm high
  let right-logo-height = 2.4cm // right logo defaults to 1.2cm but is adjusted below
  let logo-ratio = logo-size-ratio.split(":")
  if (logo-ratio.len() == 2) {
    right-logo-height = right-logo-height * (float(logo-ratio.at(1)) / float(logo-ratio.at(0)))
  }

  // save heading and body font families in variables
  let body-font = "Open Sans"
  let heading-font = "Montserrat"

  // customize look of figure
  set figure.caption(separator: [ --- ], position: bottom)

  // set body font family
  set text(font: body-font, lang: language, 12pt)
  show heading: set text(weight: "semibold", font: heading-font)

  // heading numbering
  set heading(numbering: heading-numbering)

  // math numbering
  set math.equation(numbering: math-numbering)

  // set link style for links that are not acronyms
  let acronym-keys = if (acronyms != none) {
    acronyms.keys().map(acr => ("acronyms-" + acr))
  } else {
    ()
  }
  let glossary-keys = if (glossary != none) {
    glossary.keys().map(gls => ("glossary-" + gls))
  } else {
    ()
  }
  show link: it => if (str(it.dest) not in (acronym-keys + glossary-keys)) {
    text(fill: blue, it)
  } else {
    it
  }

  show heading.where(level: 1): it => {
    pagebreak()
    v(2em) + it + v(1em)
  }
  show heading.where(level: 2): it => v(1em) + it + v(0.5em)
  show heading.where(level: 3): it => v(0.5em) + it + v(0.25em)

  if (titlepage-content != none) {
    titlepage-content
  } else {
    titlepage(
      authors,
      date,
      heading-font,
      language,
      left-logo-height,
      logo-left,
      logo-right,
      many-authors,
      right-logo-height,
      supervisor,
      title,
      type-of-degree,
      type-of-thesis,
      university,
      university-location,
      at-university,
      date-format,
      show-confidentiality-statement,
      confidentiality-marker,
      university-short,
    )
  }

  // set header properties
  let display-header = if (header != none and ("display" in header)) {
    header.display
  } else {
    true
  }

  let header-content = if (header != none and ("content" in header)) {
    header.content
  } else {
    none
  }

  let show-header-title = if (header != none and ("show-title" in header)) {
    header.show-title
  } else {
    true
  }

  let show-header-left-logo = if (header != none and ("show-left-logo" in header)) {
    header.show-left-logo
  } else {
    true
  }

  let show-header-right-logo = if (header != none and ("show-right-logo" in header)) {
    header.show-right-logo
  } else {
    true
  }

  let show-header-divider = if (header != none and ("show-divider" in header)) {
    header.show-divider
  } else {
    true
  }

  set page(
    margin: (top: 8em, bottom: 8em),
    header: {
      if (display-header) {
        if (header-content != none) {
          header.content
        } else {
          grid(
            columns: (1fr, auto),
            align: (left, right),
            gutter: 2em,
            if (show-header-title) {
              emph(align(center + horizon, text(size: 10pt, title)))
            },
            stack(
              dir: ltr,
              spacing: 1em,
              if (show-header-left-logo and logo-left != none) {
                set image(height: left-logo-height / 2)
                logo-left
              },
              if (show-header-right-logo and logo-right != none) {
                set image(height: right-logo-height / 2)
                logo-right
              },
            ),
          )
          v(-0.75em)
          if (show-header-divider) {
            line(length: 100%)
          }
        }
      }
    },
  )

  // set page numbering to roman numbering
  set page(
    numbering: "I",
    number-align: numbering-alignment,
  )
  counter(page).update(1)

  if (not at-university and show-confidentiality-statement) {
    pagebreak()
    confidentiality-statement(
      authors,
      title,
      confidentiality-statement-content,
      university,
      university-location,
      date,
      language,
      many-authors,
      date-format,
    )
  }

  if (show-declaration-of-authorship) {
    pagebreak()
    declaration-of-authorship(
      authors,
      title,
      declaration-of-authorship-content,
      date,
      language,
      many-authors,
      at-university,
      city,
      date-format,
    )
  }

  show outline.entry.where(level: 1): it => {
    v(18pt, weak: true)
    strong(it)
  }

  set par(justify: true, leading: 1em)

  if (show-abstract and abstract != none) {
    align(center + horizon, heading(level: 1, numbering: none, outlined: false)[Abstract])
    text(abstract)
  }

  set par(leading: 0.65em)

  if (show-table-of-contents) {
    outline(
      title: TABLE_OF_CONTENTS.at(language),
      indent: auto,
      depth: toc-depth,
    )
  }

  context {
    let elems = query(figure.where(kind: image), here())
    let count = elems.len()

    if (show-list-of-figures and count > 0) {
      outline(
        title: [#heading(level: 3)[#LIST_OF_FIGURES.at(language)]],
        target: figure.where(kind: image),
      )
    }
  }

  context {
    let elems = query(figure.where(kind: table), here())
    let count = elems.len()

    if (show-list-of-tables and count > 0) {
      outline(
        title: [#heading(level: 3)[#LIST_OF_TABLES.at(language)]],
        target: figure.where(kind: table),
      )
    }
  }

  context {
    let elems = query(figure.where(kind: raw), here())
    let count = elems.len()

    if (show-code-snippets and count > 0) {
      outline(
        title: [#heading(level: 3)[#CODE_SNIPPETS.at(language)]],
        target: figure.where(kind: raw),
      )
    }
  }

  if (show-acronyms and acronyms != none and acronyms.len() > 0) {
    print-acronyms(language, acronym-spacing)
  }

  if (glossary != none and glossary.len() > 0) {
    print-glossary(language, glossary-spacing)
  }

  set par(leading: 1em)
  set block(spacing: 2em)

  // reset page numbering and set to arabic numbering
  set page(
    numbering: "1",
    footer: context align(
      numbering-alignment,
      numbering(
        "1 / 1",
        ..counter(page).get(),
        ..counter(page).at(<end>),
      ),
    ),
  )
  counter(page).update(1)

  body

  [#metadata(none)<end>]
  // reset page numbering and set to alphabetic numbering
  set page(
    numbering: "a",
    footer: context align(
      numbering-alignment,
      numbering(
        "a",
        ..counter(page).get(),
      ),
    ),
  )
  counter(page).update(1)

  // Display bibliography.
  if bibliography != none {
    set std-bibliography(
      title: REFERENCES.at(language),
      style: bib-style,
    )
    bibliography
  }

  if (show-appendix and appendix != none) {
    heading(level: 1, numbering: none)[#APPENDIX.at(language)]
    appendix
  }

}