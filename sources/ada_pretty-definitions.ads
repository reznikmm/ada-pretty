--  Copyright (c) 2017 Maxim Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
--  License-Filename: LICENSE
-------------------------------------------------------------

private package Ada_Pretty.Definitions is

   type Access_Definition is new Node with private;

   function New_Access
     (Modifier : Access_Modifier;
      Target   : not null Node_Access) return Node'Class;

   type Derived is new Node with private;

   function New_Derived (Parent : not null Node_Access) return Node'Class;

   type Null_Exclusion is new Node with private;

   function New_Null_Exclusion
     (Definition : not null Node_Access;
      Exclude    : Boolean) return Node'Class;

   type Interface_Type is new Node with private;

   function New_Interface
     (Is_Limited : Boolean;
      Parents    : Node_Access) return Node'Class;

   type Private_Record is new Node with private;

   function New_Private_Record
     (Is_Tagged  : Boolean;
      Is_Limited : Boolean;
      Parents    : Node_Access) return Node'Class;

   type Record_Definition is new Node with private;

   function New_Record
     (Parent      : Node_Access := null;
      Components  : Node_Access;
      Is_Abstract : Boolean;
      Is_Tagged   : Boolean;
      Is_Limited  : Boolean) return Node'Class;

   type Array_Definition is new Node with private;

   function New_Array
     (Indexes   : not null Node_Access;
      Component : not null Node_Access) return Node'Class;

   type Subprogram is new Node with private;

   function Name (Self : Subprogram) return Node_Access;

   function New_Subprogram
     (Is_Overriding : Trilean;
      Name          : Node_Access;
      Parameters    : Node_Access;
      Result        : Node_Access) return Node'Class;

private

   type Access_Definition is new Node with record
      Modifier : Access_Modifier;
      Target   : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Access_Definition;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Derived is new Node with record
      Parent : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Derived;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Null_Exclusion is new Node with record
      Definition : not null Node_Access;
      Exclude    : Boolean;
   end record;

   overriding function Document
    (Self    : Null_Exclusion;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Interface_Type is new Node with record
      Is_Limited : Boolean;
      Parents    : Node_Access;
   end record;

   overriding function Document
    (Self    : Interface_Type;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Private_Record is new Node with record
      Is_Tagged  : Boolean;
      Is_Limited : Boolean;
      Parents    : Node_Access := null;
   end record;

   overriding function Document
    (Self    : Private_Record;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Record_Definition is new Node with record
      Parent      : Node_Access;
      Components  : Node_Access;
      Is_Abstract : Boolean;
      Is_Tagged   : Boolean;
      Is_Limited  : Boolean;
   end record;

   overriding function Document
    (Self    : Record_Definition;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Array_Definition is new Node with record
      Indexes   : not null Node_Access;
      Component : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Array_Definition;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Subprogram is new Node with record
      Is_Overriding : Trilean;
      Name          : Node_Access;
      Parameters    : Node_Access;
      Result        : Node_Access;
   end record;

   overriding function Document
    (Self    : Subprogram;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

end Ada_Pretty.Definitions;
