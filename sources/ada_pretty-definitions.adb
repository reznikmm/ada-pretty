--  Copyright (c) 2017 Maxim Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
--  License-Filename: LICENSE
-------------------------------------------------------------

package body Ada_Pretty.Definitions is

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Access_Definition;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.Put ("access ");
      case Self.Modifier is
         when Access_All =>
            Result.Put ("all ");
         when Access_Constant =>
            Result.Put ("constant ");
         when Unspecified =>
            null;
      end case;

      Result.Append (Self.Target.Document (Printer, Pad));

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Array_Definition;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      pragma Unreferenced (Pad);
      Indexes : League.Pretty_Printers.Document := Printer.New_Document;
      Result  : League.Pretty_Printers.Document := Printer.New_Document;
      Comp    : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Indexes.New_Line;
      Indexes.Put ("(");
      Indexes.Append (Self.Indexes.Document (Printer, 0).Nest (1));
      Indexes.Put (")");
      Indexes.Nest (2);
      Comp.New_Line;
      Comp.Append (Self.Component.Document (Printer, 0).Nest (2));
      Result.Put ("array");
      Result.Append (Indexes);
      Result.Put (" of");
      Result.Append (Comp);
      Result.Group;

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Derived;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      Result.Put ("new ");
      Result.Append (Self.Parent.Document (Printer, Pad));

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Interface_Type;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      if Self.Is_Limited then
         Result.Put ("limited ");
      end if;

      Result.Put ("interface");

      if Self.Parents /= null then
         Result.Append (Self.Parents.Document (Printer, Pad));
      end if;

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Null_Exclusion;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      if Self.Exclude then
         Result.Put ("not ");
      end if;

      Result.Put ("null ");
      Result.Append (Self.Definition.Document (Printer, Pad));
      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
     (Self    : Private_Record;
      Printer : not null access League.Pretty_Printers.Printer'Class;
      Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      if Self.Parents /= null then
         if Self.Is_Limited then
            Result.Put ("limited ");
         end if;

         Result.Put ("new ");
         Result.Append (Self.Parents.Document (Printer, Pad).Nest (2));
         Result.New_Line;
         Result.Put ("with ");
      else
         if Self.Is_Tagged then
            Result.Put ("tagged ");
         end if;

         if Self.Is_Limited then
            Result.Put ("limited ");
         end if;
      end if;

      Result.Put ("private");
      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
    (Self    : Record_Definition;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document
   is
      Result : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      if Self.Is_Abstract then
         Result.Put ("abstract ");
      end if;

      if Self.Is_Tagged then
         Result.Put ("tagged ");
      end if;

      if Self.Is_Limited then
         Result.Put ("limited ");
      end if;

      if Self.Parent /= null then
         Result.Put ("new ");
         Result.Append (Self.Parent.Document (Printer, 0));
         Result.New_Line;
         Result.Put ("with ");
      end if;

      if Self.Components = null then
         Result.Put ("null record");
      else
         Result.Put ("record");
         Result.Append (Self.Components.Document (Printer, Pad).Nest (3));
         Result.New_Line;
         Result.Put ("end record");
      end if;

      return Result;
   end Document;

   --------------
   -- Document --
   --------------

   overriding function Document
     (Self    : Subprogram;
      Printer : not null access League.Pretty_Printers.Printer'Class;
      Pad     : Natural)
       return League.Pretty_Printers.Document
   is
      Result  : League.Pretty_Printers.Document := Printer.New_Document;
      Profile : League.Pretty_Printers.Document := Printer.New_Document;
      Returns : League.Pretty_Printers.Document := Printer.New_Document;
   begin
      if Self.Is_Overriding = True then
         Result.Put ("overriding ");
      elsif Self.Is_Overriding = False then
         Result.Put ("not overriding ");
      end if;

      if Self.Result = null then
         Result.Put ("procedure ");
      else
         Result.Put ("function ");

         Returns.New_Line;
         Returns.Put ("return ");
         Returns.Append (Self.Result.Document (Printer, Pad).Nest (2));
         Returns.Nest (2);
      end if;

      if Self.Name /= null then
         Result.Append (Self.Name.Document (Printer, Pad));
      end if;

      if Self.Parameters /= null then
         Profile.New_Line;
         Profile.Put ("(");
         Profile.Append (Self.Parameters.Document (Printer, Pad).Nest (1));
         Profile.Put (")");

         if Self.Result /= null then
            Profile.Append (Returns);
         end if;

         Profile.Nest (1);
         Profile.Group;
         Result.Append (Profile);
      else
         Result.Append (Returns.Group);
      end if;

      return Result;
   end Document;

   ----------
   -- Name --
   ----------

   function Name (Self : Subprogram) return Node_Access is
   begin
      return Self.Name;
   end Name;

   ----------------
   -- New_Access --
   ----------------

   function New_Access
     (Modifier : Access_Modifier;
      Target   : not null Node_Access) return Node'Class is
   begin
      return Access_Definition'(Modifier, Target);
   end New_Access;

   ---------------
   -- New_Array --
   ---------------

   function New_Array
     (Indexes   : not null Node_Access;
      Component : not null Node_Access) return Node'Class is
   begin
      return Array_Definition'(Indexes, Component);
   end New_Array;

   -----------------
   -- New_Derived --
   -----------------

   function New_Derived (Parent : not null Node_Access) return Node'Class is
   begin
      return Derived'(Parent => Parent);
   end New_Derived;

   -------------------
   -- New_Interface --
   -------------------

   function New_Interface
     (Is_Limited : Boolean;
      Parents    : Node_Access) return Node'Class is
   begin
      return Interface_Type'(Is_Limited, Parents);
   end New_Interface;

   ------------------------
   -- New_Null_Exclusion --
   ------------------------

   function New_Null_Exclusion
     (Definition : not null Node_Access;
      Exclude    : Boolean) return Node'Class is
   begin
      return Null_Exclusion'(Definition, Exclude);
   end New_Null_Exclusion;

   ------------------------
   -- New_Private_Record --
   ------------------------

   function New_Private_Record
     (Is_Tagged  : Boolean;
      Is_Limited : Boolean;
      Parents    : Node_Access) return Node'Class is
   begin
      return Private_Record'(Is_Tagged, Is_Limited, Parents);
   end New_Private_Record;

   ----------------
   -- New_Record --
   ----------------

   function New_Record
     (Parent      : Node_Access := null;
      Components  : Node_Access;
      Is_Abstract : Boolean;
      Is_Tagged   : Boolean;
      Is_Limited  : Boolean) return Node'Class is
   begin
      return Record_Definition'
        (Parent, Components, Is_Abstract, Is_Tagged, Is_Limited);
   end New_Record;

   --------------------
   -- New_Subprogram --
   --------------------

   function New_Subprogram
     (Is_Overriding : Trilean;
      Name          : Node_Access;
      Parameters    : Node_Access;
      Result        : Node_Access) return Node'Class is
   begin
      return Subprogram'(Is_Overriding, Name, Parameters, Result);
   end New_Subprogram;

end Ada_Pretty.Definitions;
