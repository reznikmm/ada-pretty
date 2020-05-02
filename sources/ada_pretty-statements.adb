--  Copyright (c) 2017 Maxim Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
--  License-Filename: LICENSE
-------------------------------------------------------------

package body Ada_Pretty.Statements is

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Block_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      pragma Unreferenced (Pad);
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      if Self.Declarations /= null then
         Result.New_Line;
         Result.Put ("declare");
         Result.Append (Self.Declarations.Document (Printer, 0).Nest (3));
      end if;

      Result.New_Line;
      Result.Put ("begin");

      if Self.Statements = null then
         declare
            Nil : League.Pretty_Printers.Document := Printer.New_Document;
         begin
            Nil.New_Line;
            Nil.Put ("null;");
            Nil.Nest (3);
            Result.Append (Nil);
         end;
      else
         Result.Append (Self.Statements.Document (Printer, 0).Nest (3));
      end if;

      if Self.Exceptions /= null then
         Result.New_Line;
         Result.Put ("exception");
         Result.Append (Self.Exceptions.Document (Printer, 0).Nest (3));
      end if;

      Result.New_Line;
      Result.Put ("end;");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Case_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Put ("case ");
      Result.Append (Self.Expression.Document (Printer, Pad));
      Result.Put (" is");

      Result.Append (Self.List.Document (Printer, Pad).Nest (3));

      Result.New_Line;
      Result.Put ("end case;");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Case_Path;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Put ("when ");
      Result.Append (Self.Choice.Document (Printer, Pad));
      Result.Put (" =>");

      Result.Append (Self.List.Document (Printer, Pad).Nest (3));

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Elsif_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.New_Line;
      Result.Put ("elsif ");
      Result.Append (Self.Condition.Document (Printer, Pad));
      Result.Put (" then");

      Result.Append (Self.List.Document (Printer, Pad).Nest (3));

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Extended_Return_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Put ("return ");
      Result.Append (Self.Name.Document (Printer, Pad));
      Result.Put (" : ");
      Result.Append (Self.Type_Definition.Document (Printer, Pad).Nest (2));

      if Self.Initialization /= null then
         declare
            Init : League.Pretty_Printers.Document := Printer.New_Document;
         begin
            Init.New_Line;
            Init.Append (Self.Initialization.Document (Printer, 0));
            Init.Nest (2);
            Init.Group;
            Result.Put (" :=");
            Result.Append (Init);
         end;
      end if;

      Result.New_Line;
      Result.Put ("do");

      Result.Append (Self.Statements.Document (Printer, 0).Nest (3));

      Result.New_Line;
      Result.Put ("end return;");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : For_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Put ("for ");
      Result.Append (Self.Name.Document (Printer, Pad));

      declare
         Init : League.Pretty_Printers.Document := Printer.New_Document;
      begin
         Init.Put (" in ");
         Init.Append (Self.Iterator.Document (Printer, 0).Nest (2));
         Init.New_Line;
         Init.Put ("loop");
         Init.Group;
         Result.Append (Init);
      end;

      Result.Append (Self.Statements.Document (Printer, 0).Nest (3));

      Result.New_Line;
      Result.Put ("end loop;");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Loop_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
      Init   : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;

      if Self.Condition = null then
         Result.Put ("loop");
      else
         Init.Put ("while ");
         Init.Append (Self.Condition.Document (Printer, Pad).Nest (2));
         Init.New_Line;
         Init.Put ("loop");
         Init.Group;
         Result.Append (Init);
      end if;

      Result.Append (Self.Statements.Document (Printer, 0).Nest (3));

      Result.New_Line;
      Result.Put ("end loop;");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : If_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Put ("if ");
      Result.Append (Self.Condition.Document (Printer, Pad));
      Result.Put (" then");

      Result.Append (Self.Then_Path.Document (Printer, Pad).Nest (3));

      if Self.Elsif_List /= null then
         Result.Append (Self.Elsif_List.Document (Printer, Pad));
      end if;

      if Self.Else_Path /= null then
         Result.Append (Self.Else_Path.Document (Printer, Pad).Nest (3));
      end if;

      Result.New_Line;
      Result.Put ("end if;");
      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Return_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Put ("return");

      if Self.Expression /= null then
         Result.Put (" ");
         Result.Append (Self.Expression.Document (Printer, Pad));
      end if;

      Result.Put (";");
      return Result;
   end Document;

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

      if Self.Expression = null then
         Result.Put ("null");
      else
         Result.Append (Self.Expression.Document (Printer, Pad));
      end if;

      Result.Put (";");
      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Assignment;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
      Right  : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Append (Self.Left.Document (Printer, Pad));
      Result.Put (" :=");

      Right.New_Line;
      Right.Append (Self.Right.Document (Printer, Pad));
      Right.Nest (2);
      Right.Group;
      Result.Append (Right);

      Result.Put (";");
      return Result;
   end Document;

   --------------------
   -- New_Assignment --
   --------------------

   function New_Assignment
     (Left  : not null Node_Access;
      Right : not null Node_Access) return Node'Class is
   begin
      return Assignment'(Left, Right);
   end New_Assignment;

   -------------------------
   -- New_Block_Statement --
   -------------------------

   function New_Block_Statement
     (Declarations : Node_Access;
      Statements   : Node_Access;
      Exceptions   : Node_Access) return Node'Class is
   begin
      return Block_Statement'(Declarations, Statements, Exceptions);
   end New_Block_Statement;

   --------------
   -- New_Case --
   --------------

   function New_Case
     (Expression : not null Node_Access;
      List       : not null Node_Access) return Node'Class is
   begin
      return Case_Statement'(Expression, List);
   end New_Case;

   -------------------
   -- New_Case_Path --
   -------------------

   function New_Case_Path
     (Choice : not null Node_Access;
      List   : not null Node_Access) return Node'Class is
   begin
      return Case_Path'(Choice, List);
   end New_Case_Path;

   ---------------
   -- New_Elsif --
   ---------------

   function New_Elsif
     (Condition  : not null Node_Access;
      List       : not null Node_Access) return Node'Class is
   begin
      return Elsif_Statement'(Condition, List);
   end New_Elsif;

   -------------------------
   -- New_Extended_Return --
   -------------------------

   function New_Extended_Return
     (Name            : not null Node_Access;
      Type_Definition : not null Node_Access;
      Initialization  : Node_Access;
      Statements      : not null Node_Access) return Node'Class is
   begin
      return Extended_Return_Statement'
        (Name, Type_Definition, Initialization, Statements);
   end New_Extended_Return;

   -------------
   -- New_For --
   -------------

   function New_For
     (Name       : not null Node_Access;
      Iterator   : not null Node_Access;
      Statements : not null Node_Access) return Node'Class is
   begin
      return For_Statement'(Name, Iterator, Statements);
   end New_For;

   ------------
   -- New_If --
   ------------

   function New_If
     (Condition  : not null Node_Access;
      Then_Path  : not null Node_Access;
      Elsif_List : Node_Access;
      Else_Path  : Node_Access) return Node'Class is
   begin
      return If_Statement'(Condition, Then_Path, Elsif_List, Else_Path);
   end New_If;

   --------------
   -- New_Loop --
   --------------

   function New_Loop
     (Condition  : Node_Access;
      Statements : not null Node_Access) return Node'Class is
   begin
      return Loop_Statement'(Condition, Statements);
   end New_Loop;

   ----------------
   -- New_Return --
   ----------------

   function New_Return
     (Expression : Node_Access) return Node'Class is
   begin
      return Return_Statement'(Expression => Expression);
   end New_Return;

   -------------------
   -- New_Statement --
   -------------------

   function New_Statement (Expression : Node_Access) return Node'Class is
   begin
      return Statement'(Expression => Expression);
   end New_Statement;

end Ada_Pretty.Statements;
