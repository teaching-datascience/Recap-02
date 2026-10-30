# Second recap session

Code from the optional recap session (30 October 2026) of the 
[implementation lab](https://researchmethodology-fall26.netlify.app/)
Three questions structured the session:

1. How does `here` help with reading data files?
2. When do we need `pivot_wider()` and when do we need `pivot_longer()`?
3. What do we gain from writing in Quarto?

## Getting started

1. Download or clone this repository and open `Recap-02.Rproj` in RStudio.
2. Install the packages once:

   ```r
   install.packages(c("here", "tidyverse", "flextable", "gapminder"))
   ```

3. To render to PDF, you also need LaTeX. Run this once in the terminal:
   `quarto install tinytex`.

```
Recap-02/
├── Recap-02.Rproj           # marks the project root
├── data/raw/airquality.csv  # the data we read in
├── R/
│   ├── import_data_expls.R  # question 1: reading data with here
│   └── data_wrangling.R     # question 2: pivot_wider() and pivot_longer()
└── text/
    ├── quarto_test.qmd      # question 3: the document we wrote in the session
    ├── references.bib       # the bibliography
    ├── apa.csl              # citation style: APA 7th edition
    └── WordTemplate.docx    # template for the Word output
```

## 1. Reading data with `here`

A relative path such as `"data/raw/airquality.csv"` is read starting from the
*current working directory*. That directory changes, depending on how you run the
code. In particular, Quarto runs the code in a document from the document's own
folder (`text/`), where there is no `data/` folder. So the same line that works in
the console fails when you render.

`here` solves this:

```r
here::i_am("text/quarto_test.qmd")  # where this file lives within the project
library(here)
air_data <- read_csv(here("data/raw/airquality.csv"))
```

From `i_am()`, `here` works out the project root (the folder with the `.Rproj`
file). `here()` then builds every path from that root, on every computer and from
every folder. Put the `i_am()` line at the top of each script and each Quarto
document.

## 2. `pivot_wider()` vs. `pivot_longer()`

- **Long (tidy) format:** every variable is a column, every observation a row.
  This is what ggplot2 and most tidyverse functions expect.
- **Wide format:** the values of one variable (e.g. years or countries) are
  spread over several columns. This is handy for tables that people read, and it
  is common in downloaded data (one column per year).

| You have… | You want… | Use |
|---|---|---|
| long data | a table for people to read, or one column per group | `pivot_wider(names_from = , values_from = )` |
| wide data (e.g. as downloaded) | data for ggplot2, `summarise()` etc. | `pivot_longer(cols = , names_to = , values_to = )` |

`R/data_wrangling.R` goes through both directions with the `airquality` and
`gapminder` data. The final example shows that `names_from` decides which
variable becomes the columns.

**Hint:** I would suggest that before you write any code you write down - on 
paper or in the computer - the table structure you want to get in the end. 
This makes it much easier to plan your steps.

**Hint II:** Make your task as easy for you as possible and eliminate 
distractions. If only some rows are relevant, filter them in the beginning. 
The smaller the data set, the less distraction you face.

## 3. Why write in Quarto?

`text/quarto_test.qmd` shows the main benefits:

- **One source, several formats.** The same file renders to HTML, Word and PDF
  (see `format:` in the YAML header).
- **Results that are never out of date.** Tables, figures and numbers come from
  the code. Compare the hard-coded mean temperature in the text with the inline
  code `` `r round(mean(air_data$Temp), 2)` `` below it. The hard-coded value
  (77.88) is the mean of *all* months. Once we filtered the data to June onwards,
  it was simply wrong (81.02), while the inline code kept up.
- **Cross-references.** Give a chunk a label starting with `tbl-` or `fig-`, then
  refer to it with `@tbl-data` or `@fig-airplot`. Numbering happens
  automatically. For sections, add `{#sec-name}` to a heading and write
  `@sec-name`. Set `number-sections: true`, so that readers can find
  "Section 2".
- **Citations.** Write `@chambers1983` for a narrative citation and
  `[@chambers1983]` for a parenthetical one. Quarto takes the entries from
  `references.bib` and adds the reference list at the end. You can export the
  `.bib` file from Zotero or copy entries from Google Scholar.

### Getting APA citations

By default, Quarto uses the Chicago author-date style. A different style is a
`.csl` file (Citation Style Language), which you reference in the YAML header:

```yaml
bibliography: references.bib
csl: apa.csl
```

In `quarto_test.qmd`, just uncomment the `csl:` line. The file `apa.csl` comes from
the [official CSL style repository](https://github.com/citation-style-language/styles).
The [Zotero Style Repository](https://www.zotero.org/styles) gives you a
searchable list of more than 10,000 styles, including the styles of many
journals. Download the `.csl` file, put it next to your `.qmd`, and reference it
as above.

### Writing your own citation style

A `.csl` file is a plain-text (XML) file. You rarely write one from scratch.
Instead, adapt the existing style that comes closest to what you need:

- **With the [Visual CSL Editor](https://editor.citationstyles.org/):** search
  for a style by name, or by an example of how a citation should look. Then click
  through its elements, change them, and save the result as a `.csl` file.
- **By hand:** copy an existing `.csl` file, change `<title>` and `<id>` in its
  `<info>` block so it does not clash with the original, then edit the rules. The
  [CSL specification](https://docs.citationstyles.org/en/stable/specification.html)
  describes all elements.

**Hint:** To be honest, another useful option, when you get specific guidelines
on how citations should look like: give these guidelines to an AI and ask it
to write you the corresponding `.csl` file.

### Styling the Word output

`reference-doc: WordTemplate.docx` makes Quarto take the fonts, headings and
margins from that file. To create your own template, start from Quarto's
default:

```bash
quarto pandoc -o WordTemplate.docx --print-default-data-file reference.docx
```

Open the file in Word and change the *styles* (e.g. "Heading 1", "Body Text"),
not just the formatting of the sample text.
