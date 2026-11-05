
(* coco - Coco/R for the console (loksh).

   coco.Compile [-x] [-s] grammar.atg
     -x  a cross reference list of all syntax symbols
     -s  a list of all terminal start symbols and successors of nonterminal symbols

   The scanner and the parser of the grammar are stored next to it, as <name>S.Mod and
   <name>P.Mod. A driver module is generated too, when a <name>Driver.FRM or a Driver.FRM
   is in the current directory.

   Coco/R writes its messages into the log; coco shows them in the terminal (logs.Show). *)

MODULE coco;

IMPORT Texts, Oberon0, Out, logs, CRD;

CONST usage = "coco.Compile [-x] [-s] grammar.atg";

PROCEDURE Compile*;
VAR
  A: Texts.Reader; arg, file, opts: ARRAY 256 OF CHAR;
  src: Texts.Text;
  i: INTEGER; pos: LONGINT;
BEGIN
  file := ""; opts := "";
  Texts.OpenArgs(A);
  WHILE Texts.Arg(A, arg) DO
    IF arg[0] = "-" THEN
      i := 1; WHILE (arg[i] # 0X) & (i < LEN(opts)) DO opts[i-1] := arg[i]; INC(i) END;
      opts[i-1] := 0X
    ELSIF file = "" THEN COPY(arg, file)
    END
  END;
  IF file = "" THEN Out.String(usage); Out.Ln; RETURN END;
  NEW(src); Texts.Open(src, file);
  IF src.len = 0 THEN
    Out.String("coco: cannot read "); Out.String(file); Out.Ln; RETURN
  END;
  pos := Oberon0.Log.len;
  CRD.Run(src, 0, opts);
  logs.Show(pos)
END Compile;
END coco.
