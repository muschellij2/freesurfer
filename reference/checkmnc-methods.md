# Force object to filename with .mnc extension

Ensures the output to be a character filename (or vector) from an input
image or `nifti` to have `.mnc` extension and be converted to MNC when
necessary

## Usage

``` r
checkmnc(file, ...)

# S4 method for class 'nifti'
checkmnc(file, ...)

# S4 method for class 'character'
checkmnc(file, ...)

# S4 method for class 'list'
checkmnc(file, ...)

checkmnc(file, ...)
```

## Arguments

- file:

  character or `nifti` object

- ...:

  options passed to
  [`checkimg`](https://rdrr.io/pkg/neurobase/man/checkimg-methods.html)

## Value

Character filename of mnc image

## Author

John Muschelli <muschellij2@gmail.com>
