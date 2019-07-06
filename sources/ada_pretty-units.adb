--  Copyright (c) 2017 Maxim Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
--  License-Filename: LICENSE
-------------------------------------------------------------

package body Ada_Pretty.Units is

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Compilation_Unit;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      if not Self.License.Is_Empty then
         Result.New_Line;
         Result.Put (Self.License);
      end if;

      if Self.Clauses /= null then
         Result.Append (Self.Clauses.Document (Printer, Pad));
         Result.New_Line;
      end if;

      Result.Append (Self.Root.Document (Printer, Pad));

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Subunit;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Put ("separate (");
      Result.Append (Self.Parent_Name.Document (Printer, Pad));
      Result.Put (")");
      Result.Append (Self.Proper_Body.Document (Printer, Pad));

      return Result;
   end Document;

   --------------------------
   -- New_Compilation_Unit --
   --------------------------

   function New_Compilation_Unit
     (Root    : not null Node_Access;
      Clauses : Node_Access := null;
      License : League.Strings.Universal_String)
      return Node'Class is
   begin
      return Compilation_Unit'(Root, Clauses, License);
   end New_Compilation_Unit;

   -----------------
   -- New_Subunit --
   -----------------

   function New_Subunit
     (Parent_Name : not null Node_Access;
      Proper_Body : not null Node_Access) return Node'Class is
   begin
      return Subunit'(Parent_Name, Proper_Body);
   end New_Subunit;

end Ada_Pretty.Units;
