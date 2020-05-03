Ada Pretty Printer Library _(ada-pretty)_
=========================================

[![Build Status](https://github.com/reznikmm/ada-pretty/workflows/Build/badge.svg)](https://github.com/reznikmm/ada-pretty/actions)
[![Download](https://api.bintray.com/packages/reznikmm/matreshka/ada-pretty/images/download.svg) ](https://bintray.com/reznikmm/matreshka/ada-pretty/_latestVersion)
[![reuse compliant](https://img.shields.io/badge/reuse-compliant-green.svg)](https://reuse.software/)

> Pretty printing library for Ada

This project provides an ability to generate nice formated Ada sources
from your program. Instead of plenty of Put_Line statements you just
create desired Ada constructions in form of a tree and then print it in
a file.

## Install

Run
```
make all install PREFIX=/path/to/install
```

### Dependencies
It depends on [Matreshka](https://forge.ada-ru.org/matreshka) library.

## Usage
Add `with "ada_pretty";` in your project file.

Example:

```ada
with Ada.Characters.Wide_Wide_Latin_1;
with Ada.Wide_Wide_Text_IO;

with League.Strings;
with Ada_Pretty;

procedure Test is
   function "+" (Text : Wide_Wide_String)
                 return League.Strings.Universal_String
                 renames League.Strings.To_Universal_String;

   procedure Print_API;
   procedure Print_Core_Spec_And_Body;

   F : aliased Ada_Pretty.Factory;

   Convention : constant Ada_Pretty.Node_Access := F.New_Aspect
     (F.New_Name (+"Convention"),
      F.New_Name (+"C"));

   Import : constant Ada_Pretty.Node_Access := F.New_Aspect
     (F.New_Name (+"Import"),
      F.New_Name (+"True"));

   Name : constant Ada_Pretty.Node_Access :=
     F.New_Selected_Name (+"Qt_Ada.API.Strings");

   Clause : constant Ada_Pretty.Node_Access := F.New_With
     (F.New_Selected_Name (+"System.Storage_Elements"));

   Preelaborate : constant Ada_Pretty.Node_Access := F.New_Pragma
     (F.New_Name (+"Preelaborate"));

   QString : constant Ada_Pretty.Node_Access :=
     F.New_Name (+"QString");

   QString_Type : constant Ada_Pretty.Node_Access := F.New_Type
     (Name       => QString,
      Definition => F.New_Record,
      Aspects    => Convention);

   QString_Access : constant Ada_Pretty.Node_Access := F.New_Type
     (Name       => F.New_Name (+"QString_Access"),
      Definition => F.New_Access (True, QString),
      Aspects    => Convention);

   Link_Name : constant Ada_Pretty.Node_Access := F.New_Aspect
     (F.New_Name (+"Link_Name"),
      F.New_String_Literal (+"__qtada__QString__storage_size"));

   Aspect_List : constant Ada_Pretty.Node_Access :=
     F.New_List
       (F.New_List (Import, Convention),
        Link_Name);

   QString_Storage_Size : constant Ada_Pretty.Node_Access :=
     F.New_Variable
       (Name            => F.New_Name (+"QString_Storage_Size"),
        Type_Definition => F.New_Selected_Name
          (+"System.Storage_Elements.Storage_Offset"),
        Is_Constant     => True,
        Aspects         => Aspect_List);

   Public : constant Ada_Pretty.Node_Access := F.New_List
     ((Preelaborate, QString_Type, QString_Access, QString_Storage_Size));

   Root : constant Ada_Pretty.Node_Access :=
     F.New_Package (Name, Public);

   Unit : constant Ada_Pretty.Node_Access :=
     F.New_Compilation_Unit (Root, Clause);

   LF : constant Wide_Wide_Character := Ada.Characters.Wide_Wide_Latin_1.LF;

begin
   Ada.Wide_Wide_Text_IO.Put_Line
     (F.To_Text (Unit).Join (LF).To_Wide_Wide_String);
end Test;
```

Result:

```ada
with System.Storage_Elements;

package Qt_Ada.API.Strings is

   pragma Preelaborate;

   type QString is null record with Convention => C;

   type QString_Access is access all QString with Convention => C;

   QString_Storage_Size : constant System.Storage_Elements.Storage_Offset
     with Import     => True,
          Convention => C,
          Link_Name  => "__qtada__QString__storage_size";

end Qt_Ada.API.Strings;
```

## Maintainer

[@MaximReznik](https://github.com/reznikmm).

## Contribute

Feel free to dive in!
[Open an issue](https://github.com/reznikmm/ada-pretty/issues/new)
or submit PRs.

## License

[MIT](LICENSE) © Maxim Reznik

