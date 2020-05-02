--  Copyright (c) 2017 Maxim Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
--  License-Filename: LICENSE
-------------------------------------------------------------

private package Ada_Pretty.Statements is

   type Assignment is new Node with private;

   function New_Assignment
     (Left  : not null Node_Access;
      Right : not null Node_Access) return Node'Class;

   type Case_Statement is new Node with private;

   function New_Case
     (Expression : not null Node_Access;
      List       : not null Node_Access) return Node'Class;

   type Case_Path is new Node with private;

   function New_Case_Path
     (Choice : not null Node_Access;
      List   : not null Node_Access) return Node'Class;

   type Elsif_Statement is new Node with private;

   function New_Elsif
     (Condition  : not null Node_Access;
      List       : not null Node_Access) return Node'Class;

   type If_Statement is new Node with private;

   function New_If
     (Condition  : not null Node_Access;
      Then_Path  : not null Node_Access;
      Elsif_List : Node_Access;
      Else_Path  : Node_Access) return Node'Class;

   type For_Statement is new Node with private;

   function New_For
     (Name       : not null Node_Access;
      Iterator   : not null Node_Access;
      Statements : not null Node_Access) return Node'Class;

   type Loop_Statement is new Node with private;

   function New_Loop
     (Condition  : Node_Access;
      Statements : not null Node_Access) return Node'Class;

   type Return_Statement is new Node with private;

   function New_Return
     (Expression : Node_Access) return Node'Class;

   type Extended_Return_Statement is new Node with private;

   function New_Extended_Return
     (Name            : not null Node_Access;
      Type_Definition : not null Node_Access;
      Initialization  : Node_Access;
      Statements      : not null Node_Access) return Node'Class;

   type Statement is new Node with private;

   function New_Statement
     (Expression : Node_Access) return Node'Class;

   type Block_Statement is new Node with private;

   function New_Block_Statement
     (Declarations : Node_Access;
      Statements   : Node_Access;
      Exceptions   : Node_Access) return Node'Class;

private

   type Assignment is new Node with record
      Left  : not null Node_Access;
      Right : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Assignment;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Case_Statement is new Node with record
      Expression : not null Node_Access;
      List       : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Case_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Case_Path is new Node with record
      Choice : not null Node_Access;
      List   : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Case_Path;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Elsif_Statement is new Node with record
      Condition : not null Node_Access;
      List      : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Elsif_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type If_Statement is new Node with record
      Condition  : not null Node_Access;
      Then_Path  : not null Node_Access;
      Elsif_List : Node_Access;
      Else_Path  : Node_Access;
   end record;

   overriding function Document
    (Self    : If_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type For_Statement is new Node with record
      Name       : not null Node_Access;
      Iterator   : not null Node_Access;
      Statements : not null Node_Access;
   end record;

   overriding function Document
    (Self    : For_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Loop_Statement is new Node with record
      Condition  : Node_Access;
      Statements : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Loop_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Return_Statement is new Node with record
      Expression : Node_Access;
   end record;

   overriding function Document
    (Self    : Return_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Extended_Return_Statement is new Node with record
      Name            : not null Node_Access;
      Type_Definition : not null Node_Access;
      Initialization  : Node_Access;
      Statements      : not null Node_Access;
   end record;

   overriding function Document
    (Self    : Extended_Return_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Statement is new Node with record
      Expression : Node_Access;
   end record;

   overriding function Document
    (Self    : Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

   type Block_Statement is new Node with record
      Declarations : Node_Access;
      Statements   : Node_Access;
      Exceptions   : Node_Access;
   end record;

   overriding function Document
    (Self    : Block_Statement;
     Printer : not null access League.Pretty_Printers.Printer'Class;
     Pad     : Natural)
      return League.Pretty_Printers.Document;

end Ada_Pretty.Statements;
