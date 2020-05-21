--  Copyright (c) 2017 Maxim Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
--  License-Filename: LICENSE
-------------------------------------------------------------

with Ada_Pretty.Definitions;

package body Ada_Pretty.Declarations is

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Package_Body;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
      Content : League.Pretty_Printers.Document := Printer.New_Document;
      Name : constant League.Pretty_Printers.Document :=
        Self.Name.Document (Printer, Pad);
   begin
      Result.New_Line;
      Result.Put ("package body ");
      Result.Append (Name);
      Result.Put (" is");

      if Self.List /= null then
         Content := Printer.New_Document;
         Content.New_Line;
         Content.Append (Self.List.Document (Printer, Pad));
         Content.Nest (3);

         Result.Append (Content);
      end if;

      Result.New_Line;
      Result.New_Line;
      Result.Put ("end ");
      Result.Append (Name);
      Result.Put (";");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Package_Instantiation;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
     return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
      Definition : League.Pretty_Printers.Document := Printer.New_Document;
      Actual_Part : League.Pretty_Printers.Document := Printer.New_Document;
      Name : constant League.Pretty_Printers.Document :=
        Self.Name.Document (Printer, Pad);
   begin
      Actual_Part.New_Line;
      Actual_Part.Put ("(");
      Actual_Part.Append (Self.Actual_Part.Document (Printer, 0).Nest (1));
      Actual_Part.Put (");");
      Actual_Part.Nest (2);
      Actual_Part.Group;

      Definition.New_Line;
      Definition.Put ("new ");
      Definition.Append (Self.Template.Document (Printer, 0).Nest (2));
      Definition.Append (Actual_Part);
      Definition.Nest (2);
      Definition.Group;

      Result.New_Line;
      Result.Put ("package ");
      Result.Append (Name);
      Result.Put (" is");
      Result.Append (Definition);

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Package_Spec;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
      Content : League.Pretty_Printers.Document := Printer.New_Document;
      Name : constant League.Pretty_Printers.Document :=
        Self.Name.Document (Printer, Pad);
   begin
      Result.New_Line;
      Result.Put ("package ");
      Result.Append (Name);
      Result.Put (" is");

      if not Self.Comment.Is_Empty or Self.Public_Part /= null then
         Content := Printer.New_Document;
         Content.New_Line;

         if not Self.Comment.Is_Empty then
            Content.Put ("--  ");
            Content.Put (Self.Comment);
         end if;

         if Self.Public_Part /= null then
            Content.Append (Self.Public_Part.Document (Printer, Pad));
         end if;

         Content.Nest (3);

         Result.Append (Content);
      end if;

      if Self.Private_Part /= null then
         Content := Printer.New_Document;
         Content.Append (Self.Private_Part.Document (Printer, Pad));
         Content.Nest (3);

         Result.New_Line;
         Result.Put_Line ("private");
         Result.Append (Content);
      end if;

      Result.New_Line;
      Result.New_Line;
      Result.Put ("end ");
      Result.Append (Name);
      Result.Put (";");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
     (Self    : Parameter;
      Printer : not null access League.Pretty_Printers.Printer'Class;
      Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.Append (Self.Name.Document (Printer, Pad));
      Result.Put (" :");

      if Self.Is_Aliased then
         Result.Put (" aliased");
      end if;

      if Self.Is_In then
         Result.Put (" in");
      end if;

      if Self.Is_Out then
         Result.Put (" out");
      end if;

      Result.Put (" ");
      Result.Append (Self.Type_Definition.Document (Printer, 0).Nest (2));

      if Self.Initialization /= null then
         Result.Put (" := ");
         Result.Append (Self.Initialization.Document (Printer, 0));
      end if;

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Subprogram_Body;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      pragma Unreferenced (Pad);
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Append (Self.Specification.Document (Printer, 0));
      Result.Put (" is");

      if Self.Declarations /= null then
         Result.Append (Self.Declarations.Document (Printer, 0).Nest (3));
      end if;

      Result.New_Line;
      Result.Put ("begin");

      if Self.Statements /= null then
         Result.Append (Self.Statements.Document (Printer, 0).Nest (3));
      end if;

      if Self.Exceptions /= null then
         Result.Put ("exception");
         Result.Append (Self.Exceptions.Document (Printer, 0).Nest (3));
      end if;

      Result.New_Line;
      Result.Put ("end ");
      Result.Append
        (Ada_Pretty.Definitions.Subprogram
           (Self.Specification.all).Name.Document (Printer, 0));
      Result.Put (";");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Subprogram_Declaration;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
     return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Append (Self.Specification.Document (Printer, Pad));

      if Self.Is_Abstract or Self.Is_Null then
         declare
            Tail : League.Pretty_Printers.Document := Printer.New_Document;
         begin
            Tail.New_Line;

            if Self.Is_Abstract then
               Tail.Put ("is abstract");
            else
               Tail.Put ("is null");
            end if;

            Tail.Nest (2);
            Tail.Group;
            Result.Append (Tail);
         end;
      elsif Self.Expression /= null then
         declare
            Tail : League.Pretty_Printers.Document := Printer.New_Document;
            Expr : League.Pretty_Printers.Document := Printer.New_Document;
         begin
            Expr.Put ("is (");
            Expr.Append (Self.Expression.Document (Printer, Pad).Nest (4));
            Expr.Put (")");
            Tail.New_Line;
            Tail.Append (Expr);
            Tail.Nest (2);
            Tail.Group;
            Result.Append (Tail);
         end;
      elsif Self.Renamed /= null then
         declare
            Tail : League.Pretty_Printers.Document := Printer.New_Document;
            Expr : League.Pretty_Printers.Document := Printer.New_Document;
         begin
            Expr.Put ("renames ");
            Expr.Append (Self.Renamed.Document (Printer, Pad).Nest (2));
            Tail.New_Line;
            Tail.Append (Expr);
            Tail.Nest (2);
            Tail.Group;
            Result.Append (Tail);
         end;
      end if;

      if Self.Aspects /= null then
         Result.Append (Print_Aspect (Self.Aspects, Printer));
      end if;

      Result.Put (";");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Type_Declaration;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      pragma Unreferenced (Pad);
      Result : League.Pretty_Printers.Document := Printer.New_Document;
      Params : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Put ("type ");
      Result.Append (Self.Name.Document (Printer, 0));

      if Self.Discriminants /= null then
         Params.New_Line;
         Params.Put (" (");
         Params.Append (Self.Discriminants.Document (Printer, 0).Nest (1));
         Params.Put (")");
         Params.Nest (1);
         Params.Group;
         Result.Append (Params);
      end if;

      if Self.Definition /= null then
         declare
            Def : League.Pretty_Printers.Document := Printer.New_Document;
         begin
            Def.New_Line;
            Def.Append (Self.Definition.Document (Printer, 0));
            Def.Nest (2);
            Def.Group;
            Result.Put (" is");
            Result.Append (Def);
         end;
      end if;

      Result.Append (Print_Aspect (Self.Aspects, Printer));
      Result.Put (";");

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Variable;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.New_Line;
      Result.Append (Self.Name.Document (Printer, Pad));
      Result.Put (" :");

      if Self.Is_Aliased then
         Result.Put (" aliased");
      end if;

      if Self.Is_Constant then
         Result.Put (" constant");
      end if;

      if Self.Type_Definition /= null then
         Result.Put (" ");
         Result.Append (Self.Type_Definition.Document (Printer, 0));
      end if;

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
      elsif Self.Rename /= null then
         declare
            Init : League.Pretty_Printers.Document := Printer.New_Document;
         begin
            Init.New_Line;
            Init.Append (Self.Rename.Document (Printer, 0));
            Init.Nest (2);
            Init.Group;
            Result.Put (" renames");
            Result.Append (Init);
         end;
      end if;

      Result.Append (Print_Aspect (Self.Aspects, Printer));
      Result.Put (";");

      return Result;
   end Document;

   ----------
   -- Join --
   ----------

   overriding function Join
    (Self    : Parameter;
     List    : Node_Access_Array;
     Pad     : Natural;
     Printer : not null access League.Pretty_Printers.Printer'Class)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.Append (Self.Document (Printer, Pad));

      for J in List'Range loop
         Result.Put (";");
         Result.New_Line;
         Result.Append (List (J).Document (Printer, Pad));
      end loop;

      return Result;
   end Join;

   -----------------
   -- New_Package --
   -----------------

   function New_Package
     (Name         : not null Node_Access;
      Public_Part  : Node_Access;
      Private_Part : Node_Access;
      Comment      : League.Strings.Universal_String)
      return Node'Class is
   begin
      return Package_Spec'(Name, Public_Part, Private_Part, Comment);
   end New_Package;

   ----------------------
   -- New_Package_Body --
   ----------------------

   function New_Package_Body
     (Name : not null Node_Access;
      List : Node_Access) return Node'Class is
   begin
      return Package_Body'(Name, List);
   end New_Package_Body;

   -------------------------------
   -- New_Package_Instantiation --
   -------------------------------

   function New_Package_Instantiation
     (Name        : not null Node_Access;
      Template    : not null Node_Access;
      Actual_Part : Node_Access;
      Comment     : League.Strings.Universal_String) return Node'Class is
   begin
      return Package_Instantiation'(Name, Template, Actual_Part, Comment);
   end New_Package_Instantiation;

   -------------------
   -- New_Parameter --
   -------------------

   function New_Parameter
     (Name            : not null Node_Access;
      Type_Definition : Node_Access;
      Initialization  : Node_Access;
      Is_In           : Boolean;
      Is_Out          : Boolean;
      Is_Aliased      : Boolean;
      Comment         : League.Strings.Universal_String) return Node'Class is
   begin
      return Parameter'(Name,
                        Type_Definition,
                        Initialization,
                        Is_In,
                        Is_Out,
                        Is_Aliased,
                        Comment);
   end New_Parameter;

   -------------------------
   -- New_Subprogram_Body --
   -------------------------

   function New_Subprogram_Body
     (Specification : not null Node_Access;
      Declarations  : Node_Access;
      Statements    : Node_Access;
      Exceptions    : Node_Access) return Node'Class is
   begin
      return Subprogram_Body'
        (Specification, Declarations, Statements, Exceptions);
   end New_Subprogram_Body;

   --------------------------------
   -- New_Subprogram_Declaration --
   --------------------------------

   function New_Subprogram_Declaration
     (Specification : not null Node_Access;
      Aspects       : Node_Access := null;
      Is_Abstract   : Boolean;
      Is_Null       : Boolean;
      Expression    : Node_Access;
      Renamed       : Node_Access;
      Comment       : League.Strings.Universal_String) return Node'Class is
   begin
      return Subprogram_Declaration'
        (Specification, Aspects,
         Is_Abstract, Is_Null,
         Expression, Renamed, Comment);
   end New_Subprogram_Declaration;

   --------------
   -- New_Type --
   --------------

   function New_Type
     (Name          : not null Node_Access;
      Discriminants : Node_Access;
      Definition    : Node_Access;
      Aspects       : Node_Access;
      Comment       : League.Strings.Universal_String)
      return Node'Class
   is
   begin
      return Type_Declaration'
        (Name,
         Discriminants,
         Definition,
         Aspects,
         Comment);
   end New_Type;

   ------------------
   -- New_Variable --
   ------------------

   function New_Variable
     (Name            : not null Node_Access;
      Type_Definition : Node_Access;
      Initialization  : Node_Access;
      Rename          : Node_Access;
      Is_Constant     : Boolean;
      Is_Aliased      : Boolean;
      Aspects         : Node_Access;
      Comment         : League.Strings.Universal_String) return Node'Class is
   begin
      return Variable'
        (Name,
         Type_Definition,
         Initialization,
         Rename,
         Is_Constant,
         Is_Aliased,
         Aspects,
         Comment);
   end New_Variable;

end Ada_Pretty.Declarations;
