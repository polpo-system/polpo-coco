(* Coco - Coco/R for the desktop (loksh System.Init).

   Coco.Compile ~          the marked text
   Coco.Compile ^          the selected text (until the end of the selection)
   Coco.Compile @          the selected text (to the end of the selection)
   Coco.Compile name.atg   a file
   Coco.Compile name.atg /X   with a cross reference list of all syntax symbols (/x)
   Coco.Compile name.atg /S   with the start symbols and followers (/s)

   The scanner and the parser of the grammar are stored next to it, as <name>S.Mod and
   <name>P.Mod, and a driver module is generated when a <name>Driver.FRM or a Driver.FRM
   is in the current directory. The log of the run is in the System.Log viewer. *)

MODULE Coco;  (** portable *)

IMPORT Oberon, Texts, CRD;

PROCEDURE Compile*;
  VAR s: Texts.Scanner; src, t: Texts.Text;
    pos, beg, end, time: LONGINT;
  BEGIN
    Texts.OpenScanner(s, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(s);
    src := NIL; pos := 0; beg := 0; end := 0; time := -1;
    IF (s.class = Texts.Char) & (s.c = "^") THEN
      Oberon.GetSelection(t, beg, end, time);
      IF time >= 0 THEN Texts.OpenScanner(s, t, beg); Texts.Scan(s) END
    END ;
    IF s.class = Texts.Name THEN
      NEW(src); Texts.Open(src, s.s)
    ELSIF (s.class = Texts.Char) & (s.c = "*") THEN
      src := Oberon.MarkedText()
    ELSIF (s.class = Texts.Char) & (s.c = "@") THEN
      Oberon.GetSelection(t, beg, end, time);
      IF time >= 0 THEN src := t; pos := beg; s.s := " " END
    END ;
    IF src # NIL THEN
      IF s.nextCh = Oberon.OptionChar THEN Texts.Scan(s); Texts.Scan(s) END;
      IF s.class = Texts.Name THEN CRD.Run(src, pos, s.s) ELSE CRD.Run(src, pos, "") END
    END
  END Compile;

END Coco.
