--  Copyright (c) 2017 Maxim Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
--  License-Filename: LICENSE
-------------------------------------------------------------

private package Ada_Pretty.Units is

   type Compilation_Unit is new Node with private;

   function New_Compilation_Unit
     (Root    : not null Node_Access;
      Clauses : Node_Access := null;
      License : League.Strings.Universal_String) return Node'Class;

   function New_Subunit
     (Parent_Name : not null Node_Access;
      Proper_Body : not null Node_Access) return Node'Class;

private

   type Compilation_Unit is new Node with record
      Root    : not null Node_Access;
      Clauses : Node_Access;
      License : League.Strings.Universal_String;
   end record;

   overriding function Document
    (Self    : Compilation_Unit;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Subunit is new Node with record
      Parent_Name : not null Node_Access;
      Proper_Body : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Subunit;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

end Ada_Pretty.Units;
