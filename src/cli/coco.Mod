
(* coco - Coco/R for the console (loksh).

   coco.Compile [-x] [-s] grammar.atg
     -x  a cross reference list of all syntax symbols
     -s  a list of all terminal start symbols and successors of nonterminal symbols

   The scanner and the parser of the grammar are stored next to it, as <name>S.Mod and
   <name>P.Mod. A driver module is generated too, when a <name>Driver.FRM or a Driver.FRM
   is in the current directory.

   The log of the console is not a text of its own: coco takes the log of the run and writes
   it to the terminal. *)

MODULE coco;

IMPORT Texts := texts, Oberon0, out, CRD;

CONST usage = "coco.Compile [-x] [-s] grammar.atg";

PROCEDURE ShowLog(log: Texts.Text);
VAR R: Texts.Reader; ch: CHAR;
BEGIN
  Texts.OpenReader(R, log, 0); Texts.Read(R, ch);
  WHILE ~R.eot DO out.Char(ch); Texts.Read(R, ch) END
END ShowLog;

PROCEDURE Compile*;
VAR
  A: Texts.Reader; arg, file, opts: ARRAY 256 OF CHAR;
  src, log, saved: Texts.Text;
  i: INTEGER;
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
  IF file = "" THEN out.String(usage); out.Ln; RETURN END;
  NEW(src); Texts.Open(src, file);
  IF src.len = 0 THEN
    out.String("coco: cannot read "); out.String(file); out.Ln; RETURN
  END;
  (* the log of the console is empty: give the run a text of its own and show it *)
  saved := Oberon0.Log; NEW(log); Texts.Open(log, ""); Oberon0.SetLog(log);
  CRD.Run(src, 0, opts);
  Oberon0.SetLog(saved);
  ShowLog(log)
END Compile;
END coco.
