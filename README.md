# Coco/R for polpo

Coco/R is a compiler generator: it reads a grammar, an *attributed grammar* (`NAME.ATG`),
and writes the scanner and the parser of the language described, and optionally a driver
module. Coco/R is the work of H. Moessenboeck (ETH Zurich, then Linz); this is the
Coco/R of Native Oberon with the improvements of A. V. Shiryaev (aixp), version 2012.01,
adapted to polpo.

## What is here

    CR.ATG          the grammar of Coco/R itself: Coco compiles its own grammar
    Parser.FRM      the frame of the generated parser module
    Scanner.FRM     the frame of the generated scanner module
    Driver.FRM      the frame of the generated driver module (the console)
    examples/       a small grammar, A.ATG, and a text for it, A.ob
    src/common/     the modules both front ends share:
                      Sets    sets of symbols (from Native Oberon)
                      CRS     symbol table and scanner
                      CRT     the tables of the compiler
                      CRA     the scanner generator
                      CRX     the parser and driver generator
                      CRP     the generator, and the Coco/R parser (self-generated)
                      CRD     Error, Options and Run, shared by the two front ends
    src/cli/        coco.Mod       the console front end: a command of the shell
    src/ui/         Coco.Mod       the desktop front end: a command of the desktop

## Using it

Installed with portia (`portia.Install coco`), the frames `Parser.FRM` and `Scanner.FRM`
are in `share/`, where they are found from any directory; `Driver.FRM`, `CR.ATG` and the
examples are in `src/pkg/coco/`. A `Parser.FRM` or `Scanner.FRM` in the current directory
is used instead of the installed one; copy `Driver.FRM` there to have a driver generated.
In the shell of polpo:

    coco.Compile CR.ATG
    coco.Compile -x CR.ATG        a cross reference list of all syntax symbols
    coco.Compile -s CR.ATG        the start symbols and the followers of the nonterminals

`coco.Compile` writes `CR`+`S``.Mod` (the scanner) and `CR`+`P``.Mod` (the parser) in the
current directory, and the driver `CR`+`Compile.Mod` too, when a `CRDriver.FRM` or a
`Driver.FRM` is in the current directory. The generated modules are plain ASCII, with LF
line ends, so they can be kept in a repository.

The generated scanner and parser are the two modules of a grammar of its own; compile them
with the compiler of polpo (`compiler.Compile /s <module>.Mod`, or `acompiler.Compile`,
`rvcompiler.Compile`, `mcompiler.Compile`, `a7compiler.Compile` for the other
architectures) and run the driver of the frame.

On the desktop, `Coco.Compile` takes a file name, the marked text (`*`), or the selected
text (`@`, `^`); the log of the run is in `System.Log`.

## The example

    coco.Compile A.ATG
    compiler.Compile /s AS.Mod
    compiler.Compile /s AP.Mod
    compiler.Compile /s ACompile.Mod
    ACompile.Do A.ob

`A.ob` is `AAA B`. The grammar of the example uses the `IF(...)` resolver and literals that
are not tokens; see `examples/A.ATG`.

## Regenerating CRS.Mod and CRP.Mod

`src/common/CRS.Mod` and `src/common/CRP.Mod` are what Coco generates for `CR.ATG`:

    cp CR.ATG Parser.FRM Scanner.FRM .   (in an empty directory)
    coco.Compile CR.ATG
    cp CRS.Mod CRP.Mod ../src/common/

The result is the same byte for byte, so the scanner and the parser in this repository can
always be checked against a new run.

## Changes for polpo

  * `Texts.Close` of Native Oberon has no counterpart in polpo: `CRT.StoreFile*` writes
    the generated module as ASCII with LF line ends with `Files` instead.
  * `Oberon` and `Texts` of the frame files are bound to `Oberon0` and `Texts0`, the
    modules shared by the console and the desktop, so that the common modules and the
    generated modules are the same in both.
  * `Driver.FRM` is a console driver for the shell of polpo; it takes the file to parse
    as its argument and shows the log of the run on the terminal.
  * `MatchLiteral` of `CR.ATG` takes a `VAR` parameter: polpo has no `CONST` parameters.
  * The diagnostics of `CR.ATG` are in `CRD`, so that the two front ends do not have two
    copies of them.

## What version 2012.01 has that the version from Native Oberon has not

  * `IF(...)` in a production: an LL(1) resolver, checked by `CRT.TestResolvers`, with the
    conditions parsed by `CRP.Condition`.
  * Literal handling: `CRT.NewLit` and `CRT.FindLit`, so a literal and a token of the same
    string can be told apart; a token string may be declared directly.
  * Better messages for LL(1) conflicts.
  * Errors 227 (a token string declared twice) and 228 (an undefined string in a
    production).
  * The driver module is generated as well, from `Driver.FRM`; `CRX.GenTokens`,
    `CRX.Append1`, `CRX.IsLetter`, `CRX.Overlaps` and `CRX.UseCase` are new.
  * `CRA.Backup` is fixed.

## Origin and license

`https://github.com/norayr/cocor_voc` (directory `new`) is a port of this version to
Vishap Oberon Compiler, of the Coco/R of Native Oberon 2.3.6 and of H. Moessenboeck's
original. The license is GPL-3 (`LICENSE`); the code comes from ETH Oberon, whose license (`LICENSE.ETH`)
asks to keep its copyright notice and conditions, which `LICENSE.ETH` does.
