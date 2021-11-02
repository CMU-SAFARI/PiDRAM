------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                                  P R J                                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2001-2016, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT; see file COPYING3.  If not, go to --
-- http://www.gnu.org/licenses for a complete copy of the license.          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  The following package declares the data types for GNAT project.
--  These data types may be used by GNAT Project-aware tools.

--  Children of these package implements various services on these data types.
--  See in particular Prj.Pars and Prj.Env.

with Casing; use Casing;
with Namet;  use Namet;
with Osint;
with Scans;  use Scans;
with Types;  use Types;

with GNAT.Dynamic_HTables; use GNAT.Dynamic_HTables;
with GNAT.Dynamic_Tables;
with GNAT.OS_Lib;          use GNAT.OS_Lib;

package Prj is

   procedure Add_Restricted_Language (Name : String);
   --  Call by gprbuild for each language specify by switch
   --  --restricted-to-languages=.

   procedure Remove_All_Restricted_Languages;
   --  Call by gprbuild in CodePeer mode to ignore switches
   --  --restricted-to-languages=.

   function Is_Allowed_Language (Name : Name_Id) return Boolean;
   --  Returns True if --restricted-to-languages= is not used or if Name
   --  is one of the restricted languages.

   All_Other_Names : constant Name_Id := Names_High_Bound;
   --  Name used to replace others as an index of an associative array
   --  attribute in situations where this is allowed.

   Subdirs : String_Ptr := null;
   --  The value after the equal sign in switch --subdirs=...
   --  Contains the relative subdirectory.

   Build_Tree_Dir : String_Ptr := null;
   --  A root directory for building out-of-tree projects. All relative object
   --  directories will be rooted at this location.

   Root_Dir : String_Ptr := null;
   --  When using out-of-tree build we need to keep information about the root
   --  directory of artifacts to properly relocate them. Note that the root
   --  directory is not necessarily the directory of the main project.

   type Library_Support is (None, Static_Only, Full);
   --  Support for Library Project File.
   --  - None: Library Project Files are not supported at all
   --  - Static_Only: Library Project Files are only supported for static
   --    libraries.
   --  - Full: Library Project Files are supported for static and dynamic
   --    (shared) libraries.

   type Yes_No_Unknown is (Yes, No, Unknown);
   --  Tri-state to decide if -lgnarl is needed when linking

   type Attribute_Default_Value is
     (Read_Only_Value,     --  For read only attributes (Name, Project_Dir)
      Empty_Value,         --  Empty string or empty string list
      Dot_Value,           --  "." or (".")
      Object_Dir_Value,    --  'Object_Dir
      Target_Value,        --  'Target (special rules)
      Runtime_Value);      --  'Runtime (special rules)
   --  Describe the default values of attributes that are referenced but not
   --  declared.

   pragma Warnings (Off);
   type Project_Qualifier is
     (Unspecified,

      --  The following clash with Standard is OK, and justified by the context
      --  which really wants to use the same set of qualifiers.

      Standard,

      Library,
      Configuration,
      Abstract_Project,
      Aggregate,
      Aggregate_Library);
   pragma Warnings (On);
   --  Qualifiers that can prefix the reserved word "project" in a project
   --  file:
   --    Standard:             standard project ...
   --    Library:              library project is ...
   --    Abstract_Project:     abstract project is
   --    Aggregate:            aggregate project is
   --    Aggregate_Library:    aggregate library project is ...
   --    Configuration:        configuration project is ...

   subtype Aggregate_Project is
     Project_Qualifier range Aggregate .. Aggregate_Library;

   All_Packages : constant String_List_Access;
   --  Default value of parameter Packages of procedures Parse, in Prj.Pars and
   --  Prj.Part, indicating that all packages should be checked.

   type Project_Tree_Data;
   type Project_Tree_Ref is access all Project_Tree_Data;
   --  Reference to a project tree. Several project trees may exist in memory
   --  at the same time.

   No_Project_Tree : constant Project_Tree_Ref;

   procedure Free (Tree : in out Project_Tree_Ref);
   --  Free memory associated with the tree

   Config_Project_File_Extension : String := ".cgpr";
   Project_File_Extension : String := ".gpr";
   --  The standard config and user project file name extensions. They are not
   --  constants, because Canonical_Case_File_Name is called on these variables
   --  in the body of Prj.

   function Empty_File   return File_Name_Type;
   function Empty_String return Name_Id;
   --  Return the id for an empty string ""

   function Dot_String return Name_Id;
   --  Return the id for "."

   type Path_Information is record
      Name         : Path_Name_Type := No_Path;
      Display_Name : Path_Name_Type := No_Path;
   end record;
   --  Directory names always end with a directory separator

   No_Path_Information : constant Path_Information := (No_Path, No_Path);

   type Project_Data;
   type Project_Id is access all Project_Data;
   No_Project : constant Project_Id := null;
   --  Id of a Project File

   type String_List_Id is new Nat;
   Nil_String : constant String_List_Id := 0;
   type String_Element is record
      Value         : Name_Id        := No_Name;
      Index         : Int            := 0;
      Display_Value : Name_Id        := No_Name;
      Location      : Source_Ptr     := No_Location;
      Flag          : Boolean        := False;
      Next          : String_List_Id := Nil_String;
   end record;
   --  To hold values for string list variables and array elements.
   --  Component Flag may be used for various purposes. For source
   --  directories, it indicates if the directory contains Ada source(s).

   package String_Element_Table is new GNAT.Dynamic_Tables
     (Table_Component_Type => String_Element,
      Table_Index_Type     => String_List_Id,
      Table_Low_Bound      => 1,
      Table_Initial        => 200,
      Table_Increment      => 100);
   --  The table for string elements in string lists

   type Variable_Kind is (Undefined, List, Single);
   --  Different kinds of variables

   subtype Defined_Variable_Kind is Variable_Kind range List .. Single;
   --  The defined kinds of variables

   Ignored : constant Variable_Kind;
   --  Used to indicate that a package declaration must be ignored while
   --  processing the project tree (unknown package name).

   type Variable_Value (Kind : Variable_Kind := Undefined) is record
      Project  : Project_Id := No_Project;
      Location : Source_Ptr := No_Location;
      Default  : Boolean    := False;
      case Kind is
         when Undefined =>
            null;
         when List =>
            Values : String_List_Id := Nil_String;
         when Single =>
            Value : Name_Id := No_Name;
            Index : Int     := 0;
      end case;
   end record;
   --  Values for variables and array elements. Default is True if the
   --  current value is the default one for the variable.

   Nil_Variable_Value : constant Variable_Value;
   --  Value of a non existing variable or array element

   type Variable_Id is new Nat;
   No_Variable : constant Variable_Id := 0;
   type Variable is record
      Next  : Variable_Id := No_Variable;
      Name  : Name_Id;
      Value : Variable_Value;
   end record;
   --  To hold the list of variables in a project file and in packages

   package Variable_Element_Table is new GNAT.Dynamic_Tables
     (Table_Component_Type => Variable,
      Table_Index_Type     => Variable_Id,
      Table_Low_Bound      => 1,
      Table_Initial        => 200,
      Table_Increment      => 100);
   --  The table of variable in list of variables

   type Array_Element_Id is new Nat;
   No_Array_Element : constant Array_Element_Id := 0;
   type Array_Element is record
      Index                : Name_Id;
      Restricted           : Boolean          := False;
      Src_Index            : Int              := 0;
      Index_Case_Sensitive : Boolean          := True;
      Value                : Variable_Value;
      Next                 : Array_Element_Id := No_Array_Element;
   end record;
   --  Each Array_Element represents an array element and is linked (Next)
   --  to the next array element, if any, in the array.

   package Array_Element_Table is new GNAT.Dynamic_Tables
     (Table_Component_Type => Array_Element,
      Table_Index_Type     => Array_Element_Id,
      Table_Low_Bound      => 1,
      Table_Initial        => 200,
      Table_Increment      => 100);
   --  The table that contains all array elements

   type Array_Id is new Nat;
   No_Array : constant Array_Id := 0;
   type Array_Data is record
      Name     : Name_Id          := No_Name;
      Location : Source_Ptr       := No_Location;
      Value    : Array_Element_Id := No_Array_Element;
      Next     : Array_Id         := No_Array;
   end record;
   --  Each Array_Data value represents an array.
   --  Value is the id of the first element.
   --  Next is the id of the next array in the project file or package.

   package Array_Table is new GNAT.Dynamic_Tables
     (Table_Component_Type => Array_Data,
      Table_Index_Type     => Array_Id,
      Table_Low_Bound      => 1,
      Table_Initial        => 200,
      Table_Increment      => 100);
   --  The table that contains all arrays

   type Package_Id is new Nat;
   No_Package : constant Package_Id := 0;
   type Declarations is record
      Variables  : Variable_Id := No_Variable;
      Attributes : Variable_Id := No_Variable;
      Arrays     : Array_Id    := No_Array;
      Packages   : Package_Id  := No_Package;
   end record;
   --  Contains the declarations (variables, single and array attributes,
   --  packages) for a project or a package in a project.

   No_Declarations : constant Declarations :=
                       (Variables  => No_Variable,
                        Attributes => No_Variable,
                        Arrays     => No_Array,
                        Packages   => No_Package);
   --  Default value of Declarations: used if there are no declarations

   type Package_Element is record
      Name   : Name_Id      := No_Name;
      Decl   : Declarations := No_Declarations;
      Parent : Package_Id   := No_Package;
      Next   : Package_Id   := No_Package;
   end record;
   --  A package (includes declarations that may include other packages)

   package Package_Table is new GNAT.Dynamic_Tables
     (Table_Component_Type => Package_Element,
      Table_Index_Type     => Package_Id,
      Table_Low_Bound      => 1,
      Table_Initial        => 100,
      Table_Increment      => 100);
   --  The table that contains all packages

   type Language_Data;
   type Language_Ptr is access all Language_Data;
   --  Index of language data

   No_Language_Index : constant Language_Ptr := null;
   --  Constant indicating that there is no language data

   function Get_Language_From_Name
     (Project : Project_Id;
      Name    : String) return Language_Ptr;
   --  Get a language from a project. This might return null if no such
   --  language exists in the project

   Max_Header_Num : constant := 6150;
   type Header_Num is range 0 .. Max_Header_Num;
   --  Size for hash table below. The upper bound is an arbitrary value, the
   --  value here was chosen after testing to determine a good compromise
   --  between speed of access and memory usage.

   function Hash (Name : Name_Id)        return Header_Num;
   function Hash (Name : File_Name_Type) return Header_Num;
   function Hash (Name : Path_Name_Type) return Header_Num;
   function Hash (Project : Project_Id)  return Header_Num;
   --  Used for computing hash values for names put into hash tables

   type Language_Kind is (File_Based, Unit_Based);
   --  Type for the kind of language. All languages are file based, except Ada
   --  which is unit based.

   --  Type of dependency to be checked

   type Dependency_File_Kind is
     (None,
      --  There is no dependency file, the source must always be recompiled

      Makefile,
      --  The dependency file is a Makefile fragment indicating all the files
      --  the source depends on. If the object file or the dependency file is
      --  more recent than any of these files, the source must be recompiled.

      ALI_File,
      --  The dependency file is an ALI file and the source must be recompiled
      --  if the object or ALI file is more recent than any of the sources
      --  listed in the D lines.

      ALI_Closure);
      --  The dependency file is an ALI file and the source must be recompiled
      --  if the object or ALI file is more recent than any source in the full
      --  closure.

   Makefile_Dependency_Suffix : constant String := ".d";
   ALI_Dependency_Suffix      : constant String := ".ali";
   Switches_Dependency_Suffix : constant String := ".cswi";

   Binder_Exchange_Suffix : constant String := ".bexch";
   --  Suffix for binder exchange files

   Library_Exchange_Suffix : constant String := ".lexch";
   --  Suffix for library exchange files

   type Name_List_Index is new Nat;
   No_Name_List : constant Name_List_Index := 0;

   type Name_Node is record
      Name : Name_Id         := No_Name;
      Next : Name_List_Index := No_Name_List;
   end record;

   package Name_List_Table is new GNAT.Dynamic_Tables
     (Table_Component_Type => Name_Node,
      Table_Index_Type     => Name_List_Index,
      Table_Low_Bound      => 1,
      Table_Initial        => 10,
      Table_Increment      => 100);
   --  The table for lists of names

   function Length
     (Table : Name_List_Table.Instance;
      List  : Name_List_Index) return Natural;
   --  Return the number of elements in specified list

   type Number_List_Index is new Nat;
   No_Number_List : constant Number_List_Index := 0;

   type Number_Node is record
      Number : Natural           := 0;
      Next   : Number_List_Index := No_Number_List;
   end record;

   package Number_List_Table is new GNAT.Dynamic_Tables
     (Table_Component_Type => Number_Node,
      Table_Index_Type     => Number_List_Index,
      Table_Low_Bound      => 1,
      Table_Initial        => 10,
      Table_Increment      => 100);
   --  The table for lists of numbers

   package Mapping_Files_Htable is new Simple_HTable
     (Header_Num => Header_Num,
      Element    => Path_Name_Type,
      No_Element => No_Path,
      Key        => Path_Name_Type,
      Hash       => Hash,
      Equal      => "=");
   --  A hash table to store the mapping files that are not used

   --  The following record ???

   type Lang_Naming_Data is record
      Dot_Replacement : File_Name_Type := No_File;
      --  The string to replace '.' in the source file name (for Ada)

      Casing : Casing_Type := All_Lower_Case;
      --  The casing of the source file name (for Ada)

      Separate_Suffix : File_Name_Type := No_File;
      --  String to append to unit name for source file name of an Ada subunit

      Spec_Suffix : File_Name_Type := No_File;
      --  The string to append to the unit name for the
      --  source file name of a spec.

      Body_Suffix : File_Name_Type := No_File;
      --  The string to append to the unit name for the
      --  source file name of a body.
   end record;

   No_Lang_Naming_Data : constant Lang_Naming_Data :=
                           (Dot_Replacement => No_File,
                            Casing          => All_Lower_Case,
                            Separate_Suffix => No_File,
                            Spec_Suffix     => No_File,
                            Body_Suffix     => No_File);

   function Is_Standard_GNAT_Naming (Naming : Lang_Naming_Data) return Boolean;
   --  True if the naming scheme is GNAT's default naming scheme. This
   --  is to take into account shortened names like "Ada." (a-), "System." (s-)
   --  and so on.

   type Source_Data;
   type Source_Id is access all Source_Data;

   function Is_Compilable (Source : Source_Id) return Boolean;
   pragma Inline (Is_Compilable);
   --  Return True if we know how to compile Source (i.e. if a compiler is
   --  defined). This doesn't indicate whether the source should be compiled.

   function Object_To_Global_Archive (Source : Source_Id) return Boolean;
   pragma Inline (Object_To_Global_Archive);
   --  Return True if the object file should be put in the global archive.
   --  This is for Ada, when only the closure of a main needs to be
   --  (re)compiled.

   function Other_Part (Source : Source_Id) return Source_Id;
   pragma Inline (Other_Part);
   --  Source ID for the other part, if any: for a spec, returns its body;
   --  for a body, returns its spec.

   No_Source : constant Source_Id := null;

   type Path_Syntax_Kind is
     (Canonical, -- Unix style
      Host);     -- Host specific syntax

   --  The following record describes the configuration of a language

   type Language_Config is record
      Kind : Language_Kind := File_Based;
      --  Kind of language. Most languages are file based. A few, such as Ada,
      --  are unit based.

      Naming_Data : Lang_Naming_Data;
      --  The naming data for the languages (prefixes, etc.)

      Include_Compatible_Languages : Name_List_Index := No_Name_List;
      --  List of languages that are "include compatible" with this language. A
      --  language B (for example "C") is "include compatible" with a language
      --  A (for example "C++") if it is expected that sources of language A
      --  may "include" header files from language B.

      Compiler_Driver : File_Name_Type := No_File;
      --  The name of the executable for the compiler of the language

      Compiler_Driver_Path : String_Access := null;
      --  The path name of the executable for the compiler of the language

      Compiler_Leading_Required_Switches : Name_List_Index := No_Name_List;
      --  The list of initial switches that are required as a minimum to invoke
      --  the compiler driver.

      Compiler_Trailing_Required_Switches : Name_List_Index := No_Name_List;
      --  The list of final switches that are required as a minimum to invoke
      --  the compiler driver.

      Multi_Unit_Switches : Name_List_Index := No_Name_List;
      --  The switch(es) to indicate the index of a unit in a multi-source file

      Multi_Unit_Object_Separator : Character := ' ';
      --  The string separating the base name of a source from the index of the
      --  unit in a multi-source file, in the object file name.

      Path_Syntax : Path_Syntax_Kind := Host;
      --  Value may be Canonical (Unix style) or Host (host syntax)

      Source_File_Switches : Name_List_Index := No_Name_List;
      --  Optional switches to be put before the source file. The source file
      --  path name is appended to the last switch in the list.
      --  Example: ("-i", "");

      Object_File_Suffix : Name_Id := No_Name;
      --  Optional alternate object file suffix

      Object_File_Switches : Name_List_Index := No_Name_List;
      --  Optional object file switches. When this is defined, the switches
      --  are used to specify the object file. The object file name is appended
      --  to the last switch in the list. Example: ("-o", "").

      Object_Path_Switches : Name_List_Index := No_Name_List;
      --  List of switches to specify to the compiler the path name of a
      --  temporary file containing the list of object directories in the
      --  correct order.

      Compilation_PIC_Option : Name_List_Index := No_Name_List;
      --  The option(s) to compile a source in Position Independent Code for
      --  shared libraries. Specified in the configuration. When not specified,
      --  there is no need for such switch.

      Object_Generated : Boolean := True;
      --  False if no object file is generated

      Objects_Linked : Boolean := True;
      --  False if object files are not use to link executables and build
      --  libraries.

      Runtime_Library_Dir : Name_Id := No_Name;
      --  Path name of the runtime library directory, if any

      Runtime_Source_Dir : Name_Id := No_Name;
      --  Path name of the runtime source directory, if any

      Mapping_File_Switches : Name_List_Index := No_Name_List;
      --  The option(s) to provide a mapping file to the compiler. Specified in
      --  the configuration. When value is No_Name_List, there is no mapping
      --  file.

      Mapping_Spec_Suffix : File_Name_Type := No_File;
      --  Placeholder representing the spec suffix in a mapping file

      Mapping_Body_Suffix : File_Name_Type := No_File;
      --  Placeholder representing the body suffix in a mapping file

      Config_File_Switches : Name_List_Index := No_Name_List;
      --  The option(s) to provide a config file to the compiler. Specified in
      --  the configuration. If value is No_Name_List there is no config file.

      Dependency_Kind : Dependency_File_Kind := None;
      --  The kind of dependency to be checked: none, Makefile fragment or
      --  ALI file (for Ada).

      Dependency_Option : Name_List_Index := No_Name_List;
      --  The option(s) to be used to create the dependency file. When value is
      --  No_Name_List, there is not such option(s).

      Compute_Dependency : Name_List_Index := No_Name_List;
      --  Hold the value of attribute Dependency_Driver, if declared for the
      --  language.

      Include_Option : Name_List_Index := No_Name_List;
      --  Hold the value of attribute Include_Switches, if declared for the
      --  language.

      Include_Path : Name_Id := No_Name;
      --  Name of environment variable declared by attribute Include_Path for
      --  the language.

      Include_Path_File : Name_Id := No_Name;
      --  Name of environment variable declared by attribute Include_Path_File
      --  for the language.

      Objects_Path : Name_Id := No_Name;
      --  Name of environment variable declared by attribute Objects_Path for
      --  the language.

      Objects_Path_File : Name_Id := No_Name;
      --  Name of environment variable declared by attribute Objects_Path_File
      --  for the language.

      Config_Body : Name_Id := No_Name;
      --  The template for a pragma Source_File_Name(_Project) for a specific
      --  file name of a body.

      Config_Body_Index : Name_Id := No_Name;
      --  The template for a pragma Source_File_Name(_Project) for a specific
      --  file name of a body in a multi-source file.

      Config_Body_Pattern : Name_Id := No_Name;
      --  The template for a pragma Source_File_Name(_Project) for a naming
      --  body pattern.

      Config_Spec : Name_Id := No_Name;
      --  The template for a pragma Source_File_Name(_Project) for a specific
      --  file name of a spec.

      Config_Spec_Index : Name_Id := No_Name;
      --  The template for a pragma Source_File_Name(_Project) for a specific
      --  file name of a spec in a multi-source file.

      Config_Spec_Pattern : Name_Id := No_Name;
      --  The template for a pragma Source_File_Name(_Project) for a naming
      --  spec pattern.

      Config_File_Unique : Boolean := False;
      --  True if the config file specified to the compiler needs to be unique.
      --  If it is unique, then all config files are concatenated into a temp
      --  config file.

      Binder_Driver : File_Name_Type := No_File;
      --  The name of the binder driver for the language, if any

      Binder_Driver_Path : Path_Name_Type := No_Path;
      --  The path name of the binder driver

      Binder_Required_Switches : Name_List_Index := No_Name_List;
      --  Hold the value of attribute Binder'Required_Switches for the language

      Binder_Prefix : Name_Id := No_Name;
      --  Hold the value of attribute Binder'Prefix for the language

      Toolchain_Version : Name_Id := No_Name;
      --  Hold the value of attribute Toolchain_Version for the language

      Toolchain_Description : Name_Id := No_Name;
      --  Hold the value of attribute Toolchain_Description for the language

      Clean_Object_Artifacts : Name_List_Index := No_Name_List;
      --  List of object artifact extensions to be deleted by gprclean

      Clean_Source_Artifacts : Name_List_Index := No_Name_List;
      --  List of source artifact extensions to be deleted by gprclean

   end record;

   No_Language_Config : constant Language_Config :=
                          (Kind                         => File_Based,
                           Naming_Data                  => No_Lang_Naming_Data,
                           Include_Compatible_Languages => No_Name_List,
                           Compiler_Driver              => No_File,
                           Compiler_Driver_Path         => null,
                           Compiler_Leading_Required_Switches
                                                        => No_Name_List,
                           Compiler_Trailing_Required_Switches
                                                        => No_Name_List,
                           Multi_Unit_Switches          => No_Name_List,
                           Multi_Unit_Object_Separator  => ' ',
                           Path_Syntax                  => Canonical,
                           Source_File_Switches         => No_Name_List,
                           Object_File_Suffix           => No_Name,
                           Object_File_Switches         => No_Name_List,
                           Object_Path_Switches         => No_Name_List,
                           Compilation_PIC_Option       => No_Name_List,
                           Object_Generated             => True,
                           Objects_Linked               => True,
                           Runtime_Library_Dir          => No_Name,
                           Runtime_Source_Dir           => No_Name,
                           Mapping_File_Switches        => No_Name_List,
                           Mapping_Spec_Suffix          => No_File,
                           Mapping_Body_Suffix          => No_File,
                           Config_File_Switches         => No_Name_List,
                           Dependency_Kind              => None,
                           Dependency_Option            => No_Name_List,
                           Compute_Dependency           => No_Name_List,
                           Include_Option               => No_Name_List,
                           Include_Path                 => No_Name,
                           Include_Path_File            => No_Name,
                           Objects_Path                 => No_Name,
                           Objects_Path_File            => No_Name,
                           Config_Body                  => No_Name,
                           Config_Body_Index            => No_Name,
                           Config_Body_Pattern          => No_Name,
                           Config_Spec                  => No_Name,
                           Config_Spec_Index            => No_Name,
                           Config_Spec_Pattern          => No_Name,
                           Config_File_Unique           => False,
                           Binder_Driver                => No_File,
                           Binder_Driver_Path           => No_Path,
                           Binder_Required_Switches     => No_Name_List,
                           Binder_Prefix                => No_Name,
                           Toolchain_Version            => No_Name,
                           Toolchain_Description        => No_Name,
                           Clean_Object_Artifacts       => No_Name_List,
                           Clean_Source_Artifacts       => No_Name_List);

   type Language_Data is record
      Name : Name_Id := No_Name;
      --  The name of the language in lower case

      Display_Name : Name_Id := No_Name;
      --  The name of the language, as found in attribute Languages

      Config : Language_Config := No_Language_Config;
      --  Configuration of the language

      First_Source : Source_Id := No_Source;
      --  Head of the list of sources of the language in the project

      Mapping_Files : Mapping_Files_Htable.Instance :=
                        Mapping_Files_Htable.Nil;
      --  Hash table containing the mapping of the sources to their path names

      Next : Language_Ptr := No_Language_Index;
      --  Next language of the project

   end record;

   No_Language_Data : constant Language_Data :=
                        (Name          => No_Name,
                         Display_Name  => No_Name,
                         Config        => No_Language_Config,
                         First_Source  => No_Source,
                         Mapping_Files => Mapping_Files_Htable.Nil,
                         Next          => No_Language_Index);

   type Language_List_Element;
   type Language_List is access all Language_List_Element;
   type Language_List_Element is record
      Language : Language_Ptr := No_Language_Index;
      Next     : Language_List;
   end record;

   type Source_Kind is (Spec, Impl, Sep);
   subtype Spec_Or_Body is Source_Kind range Spec .. Impl;

   --  The following declarations declare a structure used to store the Name
   --  and File and Path names of a unit, with a reference to its GNAT Project
   --  File(s). Some units might have neither Spec nor Impl when they were
   --  created for a "separate".

   type File_Names_Data is array (Spec_Or_Body) of Source_Id;

   type Unit_Data is record
      Name       : Name_Id := No_Name;
      File_Names : File_Names_Data;
   end record;

   type Unit_Index is access all Unit_Data;

   No_Unit_Index : constant Unit_Index := null;
   --  Used to indicate a null entry for no unit

   type Source_Roots;
   type Roots_Access is access Source_Roots;
   type Source_Roots is record
      Root : Source_Id;
      Next : Roots_Access;
   end record;
   --  A list to store the roots associated with a main unit. These are the
   --  files that need to linked along with the main (for instance a C file
   --  corresponding to an Ada file). In general, these are dependencies that
   --  cannot be computed automatically by the builder.

   type Naming_Exception_Type is (No, Yes, Inherited);

   --  Structure to define source data

   type Source_Data is record
      Initialized : Boolean := False;
      --  Set to True when Source_Data is completely initialized

      Project : Project_Id := No_Project;
      --  Project of the source

      Location : Source_Ptr := No_Location;
      --  Location in the project file of the declaration of the source in
      --  package Naming.

      Source_Dir_Rank : Natural := 0;
      --  The rank of the source directory in list declared with attribute
      --  Source_Dirs. Two source files with the same name cannot appears in
      --  different directory with the same rank. That can happen when the
      --  recursive notation <dir>/** is used in attribute Source_Dirs.

      Language : Language_Ptr := No_Language_Index;
      --  Language of the source

      In_Interfaces : Boolean := True;
      --  False when the source is not included in interfaces, when attribute
      --  Interfaces is declared.

      Declared_In_Interfaces : Boolean := False;
      --  True when source is declared in attribute Interfaces

      Alternate_Languages : Language_List := null;
      --  List of languages a header file may also be, in addition of language
      --  Language_Name.

      Kind : Source_Kind := Spec;
      --  Kind of the source: spec, body or subunit

      Unit : Unit_Index := No_Unit_Index;
      --  Name of the unit, if language is unit based. This is only set for
      --  those files that are part of the compilation set (for instance a
      --  file in an extended project that is overridden will not have this
      --  field set).

      Index : Int := 0;
      --  Index of the source in a multi unit source file (the same Source_Data
      --  is duplicated several times when there are several units in the same
      --  file). Index is 0 if there is either no unit or a single one, and
      --  starts at 1 when there are multiple units

      Compilable : Yes_No_Unknown := Unknown;
      --  Updated at the first call to Is_Compilable. Yes if source file is
      --  compilable.

      In_The_Queue : Boolean := False;
      --  True if the source has been put in the queue

      Locally_Removed : Boolean := False;
      --  True if the source has been "excluded"

      Suppressed : Boolean := False;
      --  True if the source is a locally removed direct source of the project.
      --  These sources should not be put in the mapping file.

      Replaced_By : Source_Id := No_Source;
      --  Source in an extending project that replaces the current source

      File : File_Name_Type := No_File;
      --  Canonical file name of the source

      Display_File : File_Name_Type := No_File;
      --  File name of the source, for display purposes

      Path : Path_Information := No_Path_Information;
      --  Path name of the source

      Source_TS : Time_Stamp_Type := Empty_Time_Stamp;
      --  Time stamp of the source file

      Object_Project : Project_Id := No_Project;
      --  Project where the object file is. This might be different from
      --  Project when using extending project files.

      Object : File_Name_Type := No_File;
      --  File name of the object file

      Current_Object_Path : Path_Name_Type := No_Path;
      --  Object path of an existing object file

      Object_Path : Path_Name_Type := No_Path;
      --  Object path of the real object file

      Object_TS : Time_Stamp_Type := Empty_Time_Stamp;
      --  Object file time stamp

      Dep_Name : File_Name_Type := No_File;
      --  Dependency file simple name

      Current_Dep_Path : Path_Name_Type := No_Path;
      --  Path name of an existing dependency file

      Dep_Path : Path_Name_Type := No_Path;
      --  Path name of the real dependency file

      Dep_TS : aliased Osint.File_Attributes := Osint.Unknown_Attributes;
      --  Dependency file time stamp

      Switches : File_Name_Type := No_File;
      --  File name of the switches file. For all languages, this is a file
      --  that ends with the .cswi extension.

      Switches_Path : Path_Name_Type := No_Path;
      --  Path name of the switches file

      Switches_TS : Time_Stamp_Type := Empty_Time_Stamp;
      --  Switches file time stamp

      Naming_Exception : Naming_Exception_Type := No;
      --  True if the source has an exceptional name

      Duplicate_Unit : Boolean := False;
      --  True when a duplicate unit has been reported for this source

      Next_In_Lang : Source_Id := No_Source;
      --  Link to another source of the same language in the same project

      Next_With_File_Name : Source_Id := No_Source;
      --  Link to another source with the same base file name

      Roots : Roots_Access := null;
      --  The roots for a main unit

   end record;

   No_Source_Data : constant Source_Data :=
                      (Initialized            => False,
                       Project                => No_Project,
                       Location               => No_Location,
                       Source_Dir_Rank        => 0,
                       Language               => No_Language_Index,
                       In_Interfaces          => True,
                       Declared_In_Interfaces => False,
                       Alternate_Languages    => null,
                       Kind                   => Spec,
                       Unit                   => No_Unit_Index,
                       Index                  => 0,
                       Locally_Removed        => False,
                       Suppressed             => False,
                       Compilable             => Unknown,
                       In_The_Queue           => False,
                       Replaced_By            => No_Source,
                       File                   => No_File,
                       Display_File           => No_File,
                       Path                   => No_Path_Information,
                       Source_TS              => Empty_Time_Stamp,
                       Object_Project         => No_Project,
                       Object                 => No_File,
                       Current_Object_Path    => No_Path,
                       Object_Path            => No_Path,
                       Object_TS              => Empty_Time_Stamp,
                       Dep_Name               => No_File,
                       Current_Dep_Path       => No_Path,
                       Dep_Path               => No_Path,
                       Dep_TS                 => Osint.Unknown_Attributes,
                       Switches               => No_File,
                       Switches_Path          => No_Path,
                       Switches_TS            => Empty_Time_Stamp,
                       Naming_Exception       => No,
                       Duplicate_Unit         => False,
                       Next_In_Lang           => No_Source,
                       Next_With_File_Name    => No_Source,
                       Roots                  => null);

   package Source_Files_Htable is new Simple_HTable
     (Header_Num => Header_Num,
      Element    => Source_Id,
      No_Element => No_Source,
      Key        => File_Name_Type,
      Hash       => Hash,
      Equal      => "=");
   --  Mapping of source file names to source ids

   package Source_Paths_Htable is new Simple_HTable
     (Header_Num => Header_Num,
      Element    => Source_Id,
      No_Element => No_Source,
      Key        => Path_Name_Type,
      Hash       => Hash,
      Equal      => "=");
   --  Mapping of source paths to source ids

   type Lib_Kind is (Static, Dynamic, Relocatable);

   type Policy is (Autonomous, Compliant, Controlled, Restricted, Direct);
   --  Type to specify the symbol policy, when symbol control is supported.
   --  See full explanation about this type in package Symbols.
   --    Autonomous: Create a symbol file without considering any reference
   --    Compliant:  Try to be as compatible as possible with an existing ref
   --    Controlled: Fail if symbols are not the same as those in the reference
   --    Restricted: Restrict the symbols to those in the symbol file
   --    Direct:     The symbol file is used as is

   type Symbol_Record is record
      Symbol_File   : Path_Name_Type := No_Path;
      Reference     : Path_Name_Type := No_Path;
      Symbol_Policy : Policy  := Autonomous;
   end record;
   --  Type to keep the symbol data to be used when building a shared library

   No_Symbols : constant Symbol_Record :=
     (Symbol_File   => No_Path,
      Reference     => No_Path,
      Symbol_Policy => Autonomous);
   --  The default value of the symbol data

   function Image (The_Casing : Casing_Type) return String;
   --  Similar to 'Image (but avoid use of this attribute in compiler)

   function Value (Image : String) return Casing_Type;
   --  Similar to 'Value (but avoid use of this attribute in compiler)
   --  Raises Constraint_Error if not a Casing_Type image.

   --  The following record contains data for a naming scheme

   function Get_Object_Directory
     (Project             : Project_Id;
      Including_Libraries : Boolean;
      Only_If_Ada         : Boolean := False) return Path_Name_Type;
   --  Return the object directory to use for the project. This depends on
   --  whether we have a library project or a standard project. This function
   --  might return No_Name when no directory applies. If the project is a
   --  library project file and Including_Libraries is True then the library
   --  ALI dir is returned instead of the object dir, except when there is no
   --  ALI files in the Library ALI dir and the object directory exists. If
   --  Only_If_Ada is True, then No_Name is returned when the project doesn't
   --  include any Ada source.

   procedure Compute_All_Imported_Projects
     (Root_Project : Project_Id;
      Tree         : Project_Tree_Ref);
   --  For all projects in the tree, compute the list of the projects imported
   --  directly or indirectly by project Root_Project. The result is stored in
   --  Project.All_Imported_Projects for each project

   function Ultimate_Extending_Project_Of
     (Proj : Project_Id) return Project_Id;
   --  Returns the ultimate extending project of project Proj. If project Proj
   --  is not extended, returns Proj.

   type Project_List_Element;
   type Project_List is access all Project_List_Element;
   type Project_List_Element is record
      Project               : Project_Id   := No_Project;
      From_Encapsulated_Lib : Boolean      := False;
      Next                  : Project_List := null;
   end record;
   --  A list of projects

   procedure Free_List
     (List         : in out Project_List;
      Free_Project : Boolean);
   --  Free the list of projects, if Free_Project, each project is also freed

   type Response_File_Format is
     (None,
      GNU,
      Object_List,
      Option_List,
      GCC,
      GCC_GNU,
      GCC_Object_List,
      GCC_Option_List);
   --  The format of the different response files

   type Project_Configuration is record
      Target : Name_Id := No_Name;
      --  The target of the configuration, when specified

      Run_Path_Option : Name_List_Index := No_Name_List;
      --  The option to use when linking to specify the path where to look for
      --  libraries.

      Run_Path_Origin : Name_Id := No_Name;
      --  Specify the string (such as "$ORIGIN") to indicate paths relative to
      --  the directory of the executable in the run path option.

      Library_Install_Name_Option : Name_Id := No_Name;
      --  When this is not an empty list, this option, followed by the single
      --  name of the shared library file is used when linking a shared
      --  library.

      Separate_Run_Path_Options : Boolean := False;
      --  True if each directory needs to be specified in a separate run path
      --  option.

      Executable_Suffix : Name_Id := No_Name;
      --  The suffix of executables, when specified in the configuration or in
      --  package Builder of the main project. When this is not specified, the
      --  executable suffix is the default for the platform.

      --  Linking

      Linker : Path_Name_Type := No_Path;
      --  Path name of the linker driver. Specified in the configuration or in
      --  the package Builder of the main project.

      Map_File_Option : Name_Id := No_Name;
      --  Option to use when invoking the linker to build a map file

      Trailing_Linker_Required_Switches : Name_List_Index := No_Name_List;
      --  The minimum options for the linker driver. Specified in the
      --  configuration.

      Linker_Executable_Option : Name_List_Index := No_Name_List;
      --  The option(s) to indicate the name of the executable in the linker
      --  command. Specified in the configuration. When not specified, default
      --  to -o <executable name>.

      Linker_Lib_Dir_Option : Name_Id := No_Name;
      --  The option to specify where to find a library for linking. Specified
      --  in the configuration. When not specified, defaults to "-L".

      Linker_Lib_Name_Option : Name_Id := No_Name;
      --  The option to specify the name of a library for linking. Specified in
      --  the configuration. When not specified, defaults to "-l".

      Max_Command_Line_Length : Natural := 0;
      --  When positive and when Resp_File_Format (see below) is not None,
      --  if the command line for the invocation of the linker would be greater
      --  than this value, a response file is used to invoke the linker.

      Resp_File_Format : Response_File_Format := None;
      --  The format of a response file, when linking with a response file is
      --  supported.

      Resp_File_Options : Name_List_Index := No_Name_List;
      --  The switches, if any, that precede the path name of the response
      --  file in the invocation of the linker.

      --  Libraries

      Library_Builder : Path_Name_Type  := No_Path;
      --  The executable to build library (specified in the configuration)

      Lib_Support : Library_Support := None;
      --  The level of library support. Specified in the configuration. Support
      --  is none, static libraries only or both static and shared libraries.

      Lib_Encapsulated_Supported : Boolean := False;
      --  True when building fully standalone libraries supported on the target

      Archive_Builder : Name_List_Index := No_Name_List;
      --  The name of the executable to build archives, with the minimum
      --  switches. Specified in the configuration.

      Archive_Builder_Append_Option : Name_List_Index := No_Name_List;
      --  The options to append object files to an archive

      Archive_Indexer : Name_List_Index := No_Name_List;
      --  The name of the executable to index archives, with the minimum
      --  switches. Specified in the configuration.

      Archive_Suffix : File_Name_Type := No_File;
      --  The suffix of archives. Specified in the configuration. When not
      --  specified, defaults to ".a".

      Lib_Partial_Linker : Name_List_Index := No_Name_List;

      --  Shared libraries

      Shared_Lib_Driver : File_Name_Type := No_File;
      --  The driver to link shared libraries. Set with attribute Library_GCC.
      --  Default to gcc.

      Shared_Lib_Prefix : File_Name_Type := No_File;
      --  Part of a shared library file name that precedes the name of the
      --  library. Specified in the configuration. When not specified, defaults
      --  to "lib".

      Shared_Lib_Suffix : File_Name_Type := No_File;
      --  Suffix of shared libraries, after the library name in the shared
      --  library name. Specified in the configuration. When not specified,
      --  default to ".so".

      Shared_Lib_Min_Options : Name_List_Index := No_Name_List;
      --  The minimum options to use when building a shared library

      Lib_Version_Options : Name_List_Index := No_Name_List;
      --  The options to use to specify a library version

      Symbolic_Link_Supported : Boolean := False;
      --  True if the platform supports symbolic link files

      Lib_Maj_Min_Id_Supported : Boolean := False;
      --  True if platform supports library major and minor options, such as
      --  libname.so -> libname.so.2 -> libname.so.2.4

      Auto_Init_Supported : Boolean := False;
      --  True if automatic initialisation is supported for shared stand-alone
      --  libraries.

      --  Cleaning

      Artifacts_In_Exec_Dir : Name_List_Index := No_Name_List;
      --  List of regexp file names to be cleaned in the exec directory of the
      --  main project.

      Artifacts_In_Object_Dir : Name_List_Index := No_Name_List;
      --  List of regexp file names to be cleaned in the object directory of
      --  all projects.

   end record;

   Default_Project_Config : constant Project_Configuration :=
                              (Target                         => No_Name,
                               Run_Path_Option                => No_Name_List,
                               Run_Path_Origin                => No_Name,
                               Library_Install_Name_Option    => No_Name,
                               Separate_Run_Path_Options      => False,
                               Executable_Suffix              => No_Name,
                               Linker                         => No_Path,
                               Map_File_Option                => No_Name,
                               Trailing_Linker_Required_Switches =>
                                 No_Name_List,
                               Linker_Executable_Option       => No_Name_List,
                               Linker_Lib_Dir_Option          => No_Name,
                               Linker_Lib_Name_Option         => No_Name,
                               Library_Builder                => No_Path,
                               Max_Command_Line_Length        => 0,
                               Resp_File_Format               => None,
                               Resp_File_Options              => No_Name_List,
                               Lib_Support                    => None,
                               Lib_Encapsulated_Supported     => False,
                               Archive_Builder                => No_Name_List,
                               Archive_Builder_Append_Option  => No_Name_List,
                               Archive_Indexer                => No_Name_List,
                               Archive_Suffix                 => No_File,
                               Lib_Partial_Linker             => No_Name_List,
                               Shared_Lib_Driver              => No_File,
                               Shared_Lib_Prefix              => No_File,
                               Shared_Lib_Suffix              => No_File,
                               Shared_Lib_Min_Options         => No_Name_List,
                               Lib_Version_Options            => No_Name_List,
                               Symbolic_Link_Supported        => False,
                               Lib_Maj_Min_Id_Supported       => False,
                               Auto_Init_Supported            => False,
                               Artifacts_In_Exec_Dir          => No_Name_List,
                               Artifacts_In_Object_Dir        => No_Name_List);

   -------------------------
   -- Aggregated projects --
   -------------------------

   type Aggregated_Project;
   type Aggregated_Project_List is access all Aggregated_Project;
   type Aggregated_Project is record
      Path    : Path_Name_Type;
      Tree    : Project_Tree_Ref;
      Project : Project_Id;
      Next    : Aggregated_Project_List;
   end record;

   procedure Free (List : in out Aggregated_Project_List);
   --  Free the memory used for List

   procedure Add_Aggregated_Project
     (Project : Project_Id;
      Path    : Path_Name_Type);
   --  Add a new aggregated project in Project.
   --  The aggregated project has not been processed yet. This procedure should
   --  the called while processing the aggregate project, and as a result
   --  Prj.Proc.Process will then automatically process the aggregated projects

   ------------------
   -- Project_Data --
   ------------------

   --  The following record describes a project file representation

   pragma Warnings (Off);
   type Standalone is
     (No,

      --  The following clash with Standard is OK, and justified by the context
      --  which really wants to use the same set of qualifiers.

      Standard,

      Encapsulated);
   pragma Warnings (On);

   type Project_Data (Qualifier : Project_Qualifier := Unspecified) is record

      -------------
      -- General --
      -------------

      Name : Name_Id := No_Name;
      --  The name of the project

      Display_Name : Name_Id := No_Name;
      --  The name of the project with the spelling of its declaration

      Externally_Built : Boolean := False;
      --  True if the project is externally built. In such case, the Project
      --  Manager will not modify anything in this project.

      Config : Project_Configuration;

      Path : Path_Information := No_Path_Information;
      --  The path name of the project file. This include base name of the
      --  project file.

      Virtual : Boolean := False;
      --  True for virtual extending projects

      Location : Source_Ptr := No_Location;
      --  The location in the project file source of the project name that
      --  immediately follows the reserved word "project".

      ---------------
      -- Languages --
      ---------------

      Languages : Language_Ptr := No_Language_Index;
      --  First index of the language data in the project. Traversing the list
      --  gives access to all the languages supported by the project.

      --------------
      -- Projects --
      --------------

      Mains : String_List_Id := Nil_String;
      --  List of mains specified by attribute Main

      Extends : Project_Id := No_Project;
      --  The reference of the project file, if any, that this project file
      --  extends.

      Extended_By : Project_Id := No_Project;
      --  The reference of the project file, if any, that extends this project
      --  file.

      Decl : Declarations := No_Declarations;
      --  The declarations (variables, attributes and packages) of this project
      --  file.

      Imported_Projects : Project_List := null;
      --  The list of all directly imported projects, if any

      All_Imported_Projects : Project_List := null;
      --  The list of all projects imported directly or indirectly, if any.
      --  This does not include the project itself.

      -----------------
      -- Directories --
      -----------------

      Directory : Path_Information := No_Path_Information;
      --  Path name of the directory where the project file resides

      Object_Directory : Path_Information := No_Path_Information;
      --  The path name of the object directory of this project file

      Exec_Directory : Path_Information := No_Path_Information;
      --  The path name of the exec directory of this project file. Default is
      --  equal to Object_Directory.

      Object_Path_File : Path_Name_Type := No_Path;
      --  Store the name of the temporary file that contains the list of object
      --  directories, when attribute Object_Path_Switches is declared.

      -------------
      -- Library --
      -------------

      Library : Boolean := False;
      --  True if this is a library project

      Library_Name : Name_Id := No_Name;
      --  If a library project, name of the library

      Library_Kind : Lib_Kind := Static;
      --  If a library project, kind of library

      Library_Dir : Path_Information := No_Path_Information;
      --  If a library project, path name of the directory where the library
      --  resides.

      Library_TS : Time_Stamp_Type := Empty_Time_Stamp;
      --  The timestamp of a library file in a library project

      Library_Src_Dir : Path_Information := No_Path_Information;
      --  If a Stand-Alone Library project, path name of the directory where
      --  the sources of the interfaces of the library are copied. By default,
      --  if attribute Library_Src_Dir is not specified, sources of the
      --  interfaces are not copied anywhere.

      Library_ALI_Dir : Path_Information := No_Path_Information;
      --  In a library project, path name of the directory where the ALI files
      --  are copied. If attribute Library_ALI_Dir is not specified, ALI files
      --  are copied in the Library_Dir.

      Lib_Internal_Name : Name_Id := No_Name;
      --  If a library project, internal name store inside the library

      Standalone_Library : Standalone := No;
      --  Indicate that this is a Standalone Library Project File

      Lib_Interface_ALIs : String_List_Id := Nil_String;
      --  For Standalone Library Project Files, list of Interface ALI files

      Other_Interfaces : String_List_Id := Nil_String;
      --  List of non unit based sources in attribute Interfaces

      Lib_Auto_Init : Boolean := False;
      --  For non static Stand-Alone Library Project Files, True if the library
      --  initialisation should be automatic.

      Symbol_Data : Symbol_Record := No_Symbols;
      --  Symbol file name, reference symbol file name, symbol policy

      Need_To_Build_Lib : Boolean := False;
      --  True if the library of a Library Project needs to be built or rebuilt

      -------------
      -- Sources --
      -------------
      --  The sources for all languages including Ada are accessible through
      --  the Source_Iterator type

      Interfaces_Defined : Boolean := False;
      --  True if attribute Interfaces is declared for the project or any
      --  project it extends.

      Include_Path_File : Path_Name_Type := No_Path;
      --  The path name of the of the source search directory file.
      --  This is only used by gnatmake

      Source_Dirs : String_List_Id := Nil_String;
      --  The list of all the source directories

      Source_Dir_Ranks : Number_List_Index := No_Number_List;

      Ada_Include_Path : String_Access := null;
      --  The cached value of source search path for this project file. Set by
      --  the first call to Prj.Env.Ada_Include_Path for the project. Do not
      --  use this field directly outside of the project manager, use
      --  Prj.Env.Ada_Include_Path instead.

      Has_Multi_Unit_Sources : Boolean := False;
      --  Whether there is at least one source file containing multiple units

      -------------------
      -- Miscellaneous --
      -------------------

      Ada_Objects_Path : String_Access := null;
      --  The cached value of ADA_OBJECTS_PATH for this project file, with
      --  library ALI directories for library projects instead of object
      --  directories. Do not use this field directly outside of the
      --  compiler, use Prj.Env.Ada_Objects_Path instead.

      Ada_Objects_Path_No_Libs : String_Access := null;
      --  The cached value of ADA_OBJECTS_PATH for this project file with all
      --  object directories (no library ALI dir for library projects).

      Libgnarl_Needed : Yes_No_Unknown := Unknown;
      --  Set to True when libgnarl is needed to link

      Objects_Path : String_Access := null;
      --  The cached value of the object dir path, used during the binding
      --  phase of gprbuild.

      Objects_Path_File_With_Libs : Path_Name_Type := No_Path;
      --  The cached value of the object path temp file (including library
      --  dirs) for this project file.

      Objects_Path_File_Without_Libs : Path_Name_Type := No_Path;
      --  The cached value of the object path temp file (excluding library
      --  dirs) for this project file.

      Config_File_Name : Path_Name_Type := No_Path;
      --  The path name of the configuration pragmas file, if any

      Config_File_Temp : Boolean := False;
      --  True if the configuration pragmas file is a temporary file that must
      --  be deleted at the end.

      Config_Checked : Boolean := False;
      --  A flag to avoid checking repetitively the configuration pragmas file

      Depth : Natural := 0;
      --  The maximum depth of a project in the project graph. Depth of main
      --  project is 0.

      Unkept_Comments : Boolean := False;
      --  True if there are comments in the project sources that cannot be kept
      --  in the project tree.

      -----------------------------
      -- Qualifier-Specific data --
      -----------------------------

      --  The following fields are only valid for specific types of projects

      case Qualifier is
         when Aggregate | Aggregate_Library =>
            Aggregated_Projects : Aggregated_Project_List := null;
            --  List of aggregated projects (which could themselves be
            --  aggregate projects).

         when others =>
            null;
      end case;
   end record;

   function Empty_Project (Qualifier : Project_Qualifier) return  Project_Data;
   --  Return the representation of an empty project

   function Is_Extending
     (Extending : Project_Id;
      Extended  : Project_Id) return Boolean;
   --  Return True if Extending is extending the Extended project

   function Is_Ext
     (Extending : Project_Id;
      Extended  : Project_Id) return Boolean renames Is_Extending;

   function Has_Ada_Sources (Data : Project_Id) return Boolean;
   --  Return True if the project has Ada sources

   Project_Error : exception;
   --  Raised by some subprograms in Prj.Attr

   package Units_Htable is new Simple_HTable
     (Header_Num => Header_Num,
      Element    => Unit_Index,
      No_Element => No_Unit_Index,
      Key        => Name_Id,
      Hash       => Hash,
      Equal      => "=");
   --  Mapping of unit names to indexes in the Units table

   ---------------------
   -- Source_Iterator --
   ---------------------

   type Source_Iterator is private;

   function For_Each_Source
     (In_Tree           : Project_Tree_Ref;
      Project           : Project_Id := No_Project;
      Language          : Name_Id    := No_Name;
      Encapsulated_Libs : Boolean    := True;
      Locally_Removed   : Boolean    := True) return Source_Iterator;
   --  Returns an iterator for all the sources of a project tree, or a specific
   --  project, or a specific language. Include sources from aggregated libs if
   --  Aggregated_Libs is True. If Locally_Removed is set to False the
   --  Locally_Removed files won't be reported.

   function Element (Iter : Source_Iterator) return Source_Id;
   --  Return the current source (or No_Source if there are no more sources)

   procedure Next (Iter : in out Source_Iterator);
   --  Move on to the next source

   function Find_Source
     (In_Tree          : Project_Tree_Ref;
      Project          : Project_Id;
      In_Imported_Only : Boolean := False;
      In_Extended_Only : Boolean := False;
      Base_Name        : File_Name_Type;
      Index            : Int := 0) return Source_Id;
   --  Find the first source file with the given name.
   --  If In_Extended_Only is True, it will search in project and the project
   --     it extends, but not in the imported projects.
   --  Elsif In_Imported_Only is True, it will search in project and the
   --     projects it imports, but not in the others or in aggregated projects.
   --  Else it searches in the whole tree.
   --  If Index is specified, this only search for a source with that index.

   type Source_Ids is array (Positive range <>) of Source_Id;
   No_Sources : constant Source_Ids := (1 .. 0 => No_Source);

   function Find_All_Sources
     (In_Tree          : Project_Tree_Ref;
      Project          : Project_Id;
      In_Imported_Only : Boolean := False;
      In_Extended_Only : Boolean := False;
      Base_Name        : File_Name_Type;
      Index            : Int     := 0) return Source_Ids;
   --  Find all source files with the given name:
   --
   --    If In_Extended_Only is True, it will search in project and the project
   --    it extends, but not in the imported projects.
   --
   --    If Extended_Only is False, and In_Imported_Only is True, it will
   --    search in project and the projects it imports, but not in the others
   --    or in aggregated projects.
   --
   --    If both Extended_Only and In_Imported_Only are False (the default)
   --    then it searches the whole tree.
   --
   --  If Index is specified, this only search for sources with that index.

   -----------------------
   -- Project_Tree_Data --
   -----------------------

   package Replaced_Source_HTable is new Simple_HTable
     (Header_Num => Header_Num,
      Element    => File_Name_Type,
      No_Element => No_File,
      Key        => File_Name_Type,
      Hash       => Hash,
      Equal      => "=");

   type Private_Project_Tree_Data is private;
   --  Data for a project tree that is used only by the Project Manager

   type Shared_Project_Tree_Data is record
      Name_Lists        : Name_List_Table.Instance;
      Number_Lists      : Number_List_Table.Instance;
      String_Elements   : String_Element_Table.Instance;
      Variable_Elements : Variable_Element_Table.Instance;
      Array_Elements    : Array_Element_Table.Instance;
      Arrays            : Array_Table.Instance;
      Packages          : Package_Table.Instance;
      Private_Part      : Private_Project_Tree_Data;
      Dot_String_List   : String_List_Id := Nil_String;
   end record;
   type Shared_Project_Tree_Data_Access is access all Shared_Project_Tree_Data;
   --  The data that is shared among multiple trees, when these trees are
   --  loaded through the same aggregate project.
   --  To avoid ambiguities, limit the number of parameters to the
   --  subprograms (we would have to parse the "root project tree" since this
   --  is where the configuration file was loaded, in addition to the project's
   --  own tree) and make the comparison of projects easier, all trees store
   --  the lists in the same tables.

   type Project_Tree_Appdata is tagged null record;
   type Project_Tree_Appdata_Access is access all Project_Tree_Appdata'Class;
   --  Application-specific data that can be associated with a project tree.
   --  We do not make the Project_Tree_Data itself tagged for several reasons:
   --    - it couldn't have a default value for its discriminant
   --    - it would require a "factory" to allocate such data, because trees
   --      are created automatically when parsing aggregate projects.

   procedure Free (Tree : in out Project_Tree_Appdata);
   --  Should be overridden if your derive your own data

   type Project_Tree_Data (Is_Root_Tree : Boolean := True) is record
      --  The root tree is the one loaded by the user from the command line.
      --  Is_Root_Tree is only false for projects aggregated within a root
      --  aggregate project.

      Projects : Project_List;
      --  List of projects in this tree

      Replaced_Sources : Replaced_Source_HTable.Instance;
      --  The list of sources that have been replaced by sources with
      --  different file names.

      Replaced_Source_Number : Natural := 0;
      --  The number of entries in Replaced_Sources

      Units_HT : Units_Htable.Instance;
      --  Unit name to Unit_Index (and from there to Source_Id)

      Source_Files_HT : Source_Files_Htable.Instance;
      --  Base source file names to Source_Id list

      Source_Paths_HT : Source_Paths_Htable.Instance;
      --  Full path to Source_Id
      --  ??? What is behavior for multi-unit source files, where there are
      --  several source_id per file ?

      Source_Info_File_Name : String_Access := null;
      --  The name of the source info file, if specified by the builder

      Source_Info_File_Exists : Boolean := False;
      --  True when a source info file has been successfully read

      Shared : Shared_Project_Tree_Data_Access;
      --  The shared data for this tree and all aggregated trees

      Appdata : Project_Tree_Appdata_Access;
      --  Application-specific data for this tree

      case Is_Root_Tree is
         when True =>
            Shared_Data : aliased Shared_Project_Tree_Data;
            --  Do not access directly, only through Shared

         when False =>
            null;
      end case;
   end record;
   --  Data for a project tree

   function Debug_Name (Tree : Project_Tree_Ref) return Name_Id;
   --  If debug traces are activated, return an identitier for the project
   --  tree. This modifies Name_Buffer.

   procedure Expect (The_Token : Token_Type; Token_Image : String);
   --  Check that the current token is The_Token. If it is not, then output
   --  an error message.

   procedure Initialize (Tree : Project_Tree_Ref);
   --  This procedure must be called before using any services from the Prj
   --  hierarchy. Namet.Initialize must be called before Prj.Initialize.

   procedure Reset (Tree : Project_Tree_Ref);
   --  This procedure resets all the tables that are used when processing a
   --  project file tree. Initialize must be called before the call to Reset.

   package Project_Boolean_Htable is new Simple_HTable
     (Header_Num => Header_Num,
      Element    => Boolean,
      No_Element => False,
      Key        => Project_Id,
      Hash       => Hash,
      Equal      => "=");
   --  A table that associates a project to a boolean. This is used to detect
   --  whether a project was already processed for instance.

   generic
      with procedure Action (Project : Project_Id; Tree : Project_Tree_Ref);
   procedure For_Project_And_Aggregated
     (Root_Project : Project_Id;
      Root_Tree    : Project_Tree_Ref);
   --  Execute Action for Root_Project and all its aggregated projects
   --  recursively.

   generic
      type State is limited private;
      with procedure Action
        (Project    : Project_Id;
         Tree       : Project_Tree_Ref;
         With_State : in out State);
   procedure For_Every_Project_Imported
     (By                 : Project_Id;
      Tree               : Project_Tree_Ref;
      With_State         : in out State;
      Include_Aggregated : Boolean := True;
      Imported_First     : Boolean := False);
   --  Call Action for each project imported directly or indirectly by project
   --  By, as well as extended projects.
   --
   --  The order of processing depends on Imported_First:
   --
   --    If False, Action is called according to the order of importation: if A
   --    imports B, directly or indirectly, Action will be called for A before
   --    it is called for B. If two projects import each other directly or
   --    indirectly (using at least one "limited with"), it is not specified
   --    for which of these two projects Action will be called first.
   --
   --    The order is reversed if Imported_First is True
   --
   --  With_State may be used by Action to choose a behavior or to report some
   --  global result.
   --
   --  If Include_Aggregated is True, then an aggregate project will recurse
   --  into the projects it aggregates. Otherwise, the latter are never
   --  returned.
   --
   --  In_Aggregate_Lib is True if the project is in an aggregate library
   --
   --  The Tree argument passed to the callback is required in the case of
   --  aggregated projects, since they might not be using the same tree as 'By'

   type Project_Context is record
      In_Aggregate_Lib : Boolean;
      --  True if the project is part of an aggregate library

      From_Encapsulated_Lib : Boolean;
      --  True if the project is imported from an encapsulated library
   end record;

   generic
      type State is limited private;
      with procedure Action
        (Project    : Project_Id;
         Tree       : Project_Tree_Ref;
         Context    : Project_Context;
         With_State : in out State);
   procedure For_Every_Project_Imported_Context
     (By                 : Project_Id;
      Tree               : Project_Tree_Ref;
      With_State         : in out State;
      Include_Aggregated : Boolean := True;
      Imported_First     : Boolean := False);
   --  As for For_Every_Project_Imported but with an associated context

   generic
      with procedure Action
        (Project : Project_Id;
         Tree    : Project_Tree_Ref;
         Context : Project_Context);
   procedure For_Project_And_Aggregated_Context
     (Root_Project : Project_Id;
      Root_Tree    : Project_Tree_Ref);
   --  As for For_Project_And_Aggregated but with an associated context

   function Extend_Name
     (File        : File_Name_Type;
      With_Suffix : String) return File_Name_Type;
   --  Replace the extension of File with With_Suffix

   function Object_Name
     (Source_File_Name   : File_Name_Type;
      Object_File_Suffix : Name_Id := No_Name) return File_Name_Type;
   --  Returns the object file name corresponding to a source file name

   function Object_Name
     (Source_File_Name   : File_Name_Type;
      Source_Index       : Int;
      Index_Separator    : Character;
      Object_File_Suffix : Name_Id := No_Name) return File_Name_Type;
   --  Returns the object file name corresponding to a unit in a multi-source
   --  file.

   function Dependency_Name
     (Source_File_Name : File_Name_Type;
      Dependency       : Dependency_File_Kind) return File_Name_Type;
   --  Returns the dependency file name corresponding to a source file name

   function Switches_Name
     (Source_File_Name : File_Name_Type) return File_Name_Type;
   --  Returns the switches file name corresponding to a source file name

   procedure Set_Path_File_Var (Name : String; Value : String);
   --  Call Setenv, after calling To_Host_File_Spec

   function Current_Source_Path_File_Of
     (Shared : Shared_Project_Tree_Data_Access) return Path_Name_Type;
   --  Get the current include path file name

   procedure Set_Current_Source_Path_File_Of
     (Shared : Shared_Project_Tree_Data_Access;
      To     : Path_Name_Type);
   --  Record the current include path file name

   function Current_Object_Path_File_Of
     (Shared : Shared_Project_Tree_Data_Access) return Path_Name_Type;
   --  Get the current object path file name

   procedure Set_Current_Object_Path_File_Of
     (Shared : Shared_Project_Tree_Data_Access;
      To     : Path_Name_Type);
   --  Record the current object path file name

   -----------
   -- Flags --
   -----------

   type Processing_Flags is private;
   --  Flags used while parsing and processing a project tree to configure the
   --  behavior of the parser, and indicate how to report error messages. This
   --  structure does not allocate memory and never needs to be freed

   type Error_Warning is (Silent, Warning, Error);
   --  Severity of some situations, such as: no Ada sources in a project where
   --  Ada is one of the language.
   --
   --  When the situation occurs, the behavior depends on the setting:
   --
   --    - Silent:  no action
   --    - Warning: issue a warning, does not cause the tool to fail
   --    - Error:   issue an error, causes the tool to fail

   type Error_Handler is access procedure
     (Project    : Project_Id;
      Is_Warning : Boolean);
   --  This warns when an error was found when parsing a project. The error
   --  itself is handled through Prj.Err (and Prj.Err.Finalize should be called
   --  to actually print the error). This ensures that duplicate error messages
   --  are always correctly removed, that errors msgs are sorted, and that all
   --  tools will report the same error to the user.

   function Create_Flags
     (Report_Error               : Error_Handler;
      When_No_Sources            : Error_Warning;
      Require_Sources_Other_Lang : Boolean       := True;
      Allow_Duplicate_Basenames  : Boolean       := True;
      Compiler_Driver_Mandatory  : Boolean       := False;
      Error_On_Unknown_Language  : Boolean       := True;
      Require_Obj_Dirs           : Error_Warning := Error;
      Allow_Invalid_External     : Error_Warning := Error;
      Missing_Source_Files       : Error_Warning := Error;
      Ignore_Missing_With        : Boolean       := False)
      return Processing_Flags;
   --  Function used to create Processing_Flags structure
   --
   --  If Allow_Duplicate_Basenames, then files with the same base names are
   --  authorized within a project for source-based languages (never for unit
   --  based languages).
   --
   --  If Compiler_Driver_Mandatory is true, then a Compiler.Driver attribute
   --  for each language must be defined, or we will not look for its source
   --  files.
   --
   --  When_No_Sources indicates what should be done when no sources of a
   --  language are found in a project where this language is declared.
   --  If Require_Sources_Other_Lang is true, then all languages must have at
   --  least one source file, or an error is reported via When_No_Sources. If
   --  it is false, this is only required for Ada (and only if it is a language
   --  of the project). When this parameter is set to False, we do not check
   --  that a proper naming scheme is defined for languages other than Ada.
   --
   --  If Report_Error is null, use the standard error reporting mechanism
   --  (Errout). Otherwise, report errors using Report_Error.
   --
   --  If Error_On_Unknown_Language is true, an error is displayed if some of
   --  the source files listed in the project do not match any naming scheme
   --
   --  If Require_Obj_Dirs is true, then all object directories must exist
   --  (possibly after they have been created automatically if the appropriate
   --  switches were specified), or an error is raised.
   --
   --  If Allow_Invalid_External is Silent, then no error is reported when an
   --  invalid value is used for an external variable (and it doesn't match its
   --  type). Instead, the first possible value is used.
   --
   --  Missing_Source_Files indicates whether it is an error or a warning that
   --  a source file mentioned in the Source_Files attributes is not actually
   --  found in the source directories. This also impacts errors for missing
   --  source directories.
   --
   --  If Ignore_Missing_With is True, then a "with" statement that cannot be
   --  resolved will simply be ignored. However, in such a case, the flag
   --  Incomplete_With in the project tree will be set to True.
   --  This is meant for use by tools so that they can properly set the
   --  project path in such a case:
   --       * no "gnatls" found (so no default project path)
   --       * user project sets Project.IDE'gnatls attribute to a cross gnatls
   --       * user project also includes a "with" that can only be resolved
   --         once we have found the gnatls

   procedure Set_Ignore_Missing_With
     (Flags : in out Processing_Flags;
      Value : Boolean);
   --  Set the value of component Ignore_Missing_With in Flags to Value

   Gprbuild_Flags   : constant Processing_Flags;
   Gprinstall_Flags : constant Processing_Flags;
   Gprclean_Flags   : constant Processing_Flags;
   Gprexec_Flags    : constant Processing_Flags;
   Gnatmake_Flags   : constant Processing_Flags;
   --  Flags used by the various tools. They all display the error messages
   --  through Prj.Err.

   ----------------
   -- Temp Files --
   ----------------

   procedure Record_Temp_File
     (Shared : Shared_Project_Tree_Data_Access;
      Path   : Path_Name_Type);
   --  Record the path of a newly created temporary file, so that it can be
   --  deleted later.

   procedure Delete_All_Temp_Files
     (Shared : Shared_Project_Tree_Data_Access);
   --  Delete all recorded temporary files.
   --  Does nothing if Debug.Debug_Flag_N is set

   procedure Delete_Temp_Config_Files (Project_Tree : Project_Tree_Ref);
   --  Delete all temporary config files. Does nothing if Debug.Debug_Flag_N is
   --  set or if Project_Tree is null. This initially came from gnatmake
   --  ??? Should this be combined with Delete_All_Temp_Files above

   procedure Delete_Temporary_File
     (Shared : Shared_Project_Tree_Data_Access := null;
      Path   : Path_Name_Type);
   --  Delete a temporary file from the disk. The file is also removed from the
   --  list of temporary files to delete at the end of the program, in case
   --  another program running on the same machine has recreated it. Does
   --  nothing if Debug.Debug_Flag_N is set

   Virtual_Prefix : constant String := "v$";
   --  The prefix for virtual extending projects. Because of the '$', which is
   --  normally forbidden for project names, there cannot be any name clash.

   -----------
   -- Debug --
   -----------

   type Verbosity is (Default, Medium, High);
   pragma Ordered (Verbosity);
   --  Verbosity when parsing GNAT Project Files
   --    Default is default (very quiet, if no errors).
   --    Medium is more verbose.
   --    High is extremely verbose.

   Current_Verbosity : Verbosity := Default;
   --  The current value of the verbosity the project files are parsed with

   procedure Debug_Indent;
   --  Inserts a series of blanks depending on the current indentation level

   procedure Debug_Output (Str : String);
   procedure Debug_Output (Str : String; Str2 : Name_Id);
   --  If Current_Verbosity is not Default, outputs Str.
   --  This indents Str based on the current indentation level for traces
   --  Debug_Error is intended to be used to report an error in the traces.

   procedure Debug_Increase_Indent
     (Str : String := ""; Str2 : Name_Id := No_Name);
   procedure Debug_Decrease_Indent (Str : String := "");
   --  Increase or decrease the indentation level for debug traces. This
   --  indentation level only affects output done through Debug_Output.

private
   All_Packages : constant String_List_Access := null;

   No_Project_Tree : constant Project_Tree_Ref := null;

   Ignored : constant Variable_Kind := Single;

   Nil_Variable_Value : constant Variable_Value :=
                          (Project  => No_Project,
                           Kind     => Undefined,
                           Location => No_Location,
                           Default  => False);

   type Source_Iterator is record
      In_Tree : Project_Tree_Ref;

      Project      : Project_List;
      All_Projects : Boolean;
      --  Current project and whether we should move on to the next

      Language : Language_Ptr;
      --  Current language processed

      Language_Name : Name_Id;
      --  Only sources of this language will be returned (or all if No_Name)

      Current : Source_Id;

      Encapsulated_Libs : Boolean;
      --  True if we want to include the sources from encapsulated libs

      Locally_Removed : Boolean;
   end record;

   procedure Add_To_Buffer
     (S    : String;
      To   : in out String_Access;
      Last : in out Natural);
   --  Append a String to the Buffer

   --  Table used to store the path name of all the created temporary files, so
   --  that they can be deleted at the end, or when the program is interrupted.

   package Temp_Files_Table is new GNAT.Dynamic_Tables
     (Table_Component_Type => Path_Name_Type,
      Table_Index_Type     => Integer,
      Table_Low_Bound      => 1,
      Table_Initial        => 10,
      Table_Increment      => 10);

   --  The following type is used to represent the part of a project tree which
   --  is private to the Project Manager.

   type Private_Project_Tree_Data is record
      Temp_Files   : Temp_Files_Table.Instance;
      --  Temporary files created as part of running tools (pragma files,
      --  mapping files,...)

      Current_Source_Path_File : Path_Name_Type := No_Path;
      --  Current value of project source path file env var. Used to avoid
      --  setting the env var to the same value. When different from No_Path,
      --  this indicates that environment variables were created and should be
      --  deassigned to avoid polluting the environment. For gnatmake only.

      Current_Object_Path_File : Path_Name_Type := No_Path;
      --  Current value of project object path file env var. Used to avoid
      --  setting the env var to the same value.
      --  gnatmake only
   end record;

   --  The following type is used to hold processing flags which show what
   --  functions are required for the various tools that are handled.

   type Processing_Flags is record
      Require_Sources_Other_Lang : Boolean;
      Report_Error               : Error_Handler;
      When_No_Sources            : Error_Warning;
      Allow_Duplicate_Basenames  : Boolean;
      Compiler_Driver_Mandatory  : Boolean;
      Error_On_Unknown_Language  : Boolean;
      Require_Obj_Dirs           : Error_Warning;
      Allow_Invalid_External     : Error_Warning;
      Missing_Source_Files       : Error_Warning;
      Ignore_Missing_With        : Boolean;

      Incomplete_Withs : Boolean := False;
      --  This flag is set to True when the projects are parsed while ignoring
      --  missing withed project and some withed projects are not found.

   end record;

   Gprbuild_Flags   : constant Processing_Flags :=
                        (Report_Error               => null,
                         When_No_Sources            => Warning,
                         Require_Sources_Other_Lang => True,
                         Allow_Duplicate_Basenames  => False,
                         Compiler_Driver_Mandatory  => True,
                         Error_On_Unknown_Language  => True,
                         Require_Obj_Dirs           => Error,
                         Allow_Invalid_External     => Error,
                         Missing_Source_Files       => Error,
                         Ignore_Missing_With        => False,
                         Incomplete_Withs           => False);

   Gprinstall_Flags : constant Processing_Flags :=
                        (Report_Error               => null,
                         When_No_Sources            => Warning,
                         Require_Sources_Other_Lang => True,
                         Allow_Duplicate_Basenames  => False,
                         Compiler_Driver_Mandatory  => True,
                         Error_On_Unknown_Language  => True,
                         Require_Obj_Dirs           => Silent,
                         Allow_Invalid_External     => Error,
                         Missing_Source_Files       => Error,
                         Ignore_Missing_With        => False,
                         Incomplete_Withs           => False);

   Gprclean_Flags   : constant Processing_Flags :=
                        (Report_Error               => null,
                         When_No_Sources            => Warning,
                         Require_Sources_Other_Lang => True,
                         Allow_Duplicate_Basenames  => False,
                         Compiler_Driver_Mandatory  => True,
                         Error_On_Unknown_Language  => True,
                         Require_Obj_Dirs           => Warning,
                         Allow_Invalid_External     => Error,
                         Missing_Source_Files       => Error,
                         Ignore_Missing_With        => False,
                         Incomplete_Withs           => False);

   Gprexec_Flags    : constant Processing_Flags :=
                        (Report_Error               => null,
                         When_No_Sources            => Silent,
                         Require_Sources_Other_Lang => False,
                         Allow_Duplicate_Basenames  => False,
                         Compiler_Driver_Mandatory  => False,
                         Error_On_Unknown_Language  => True,
                         Require_Obj_Dirs           => Silent,
                         Allow_Invalid_External     => Error,
                         Missing_Source_Files       => Silent,
                         Ignore_Missing_With        => False,
                         Incomplete_Withs           => False);

   Gnatmake_Flags   : constant Processing_Flags :=
                        (Report_Error               => null,
                         When_No_Sources            => Error,
                         Require_Sources_Other_Lang => False,
                         Allow_Duplicate_Basenames  => False,
                         Compiler_Driver_Mandatory  => False,
                         Error_On_Unknown_Language  => False,
                         Require_Obj_Dirs           => Error,
                         Allow_Invalid_External     => Error,
                         Missing_Source_Files       => Error,
                         Ignore_Missing_With        => False,
                         Incomplete_Withs           => False);

end Prj;
