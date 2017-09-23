package body Ada_Side.Outputs.Statements is

   --------------
   -- Document --
   --------------

   overriding function Document
     (Self    : Statement;
      Printer : not null access League.Pretty_Printers.Printer'Class;
      Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;

      if Self.Expression /= null then
         Result.Append (Self.Expression.Document (Printer, Pad));
      end if;

      Result.Put (";");
      return Result;
   end Document;

   -------------------
   -- New_Statement --
   -------------------

   function New_Statement (Expression : Node_Access) return Node'Class is
   begin
      return Statement'(Expression => Expression);
   end New_Statement;

end Ada_Side.Outputs.Statements;