------------------------------------------------------------------------------
--                                                                          --
--                         GNAT LIBRARY COMPONENTS                          --
--                                                                          --
--    A D A . C O N T A I N E R S . F O R M A L _ H A S H E D _ S E T S     --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2004-2015, Free Software Foundation, Inc.         --
--                                                                          --
-- This specification is derived from the Ada Reference Manual for use with --
-- GNAT. The copyright notice above, and the license provisions that follow --
-- apply solely to the  contents of the part following the private keyword. --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
------------------------------------------------------------------------------

--  This spec is derived from package Ada.Containers.Bounded_Hashed_Sets in the
--  Ada 2012 RM. The modifications are meant to facilitate formal proofs by
--  making it easier to express properties, and by making the specification of
--  this unit compatible with SPARK 2014. Note that the API of this unit may be
--  subject to incompatible changes as SPARK 2014 evolves.

--  The modifications are:

--    A parameter for the container is added to every function reading the
--    content of a container: Element, Next, Query_Element, Has_Element, Key,
--    Iterate, Equivalent_Elements. This change is motivated by the need to
--    have cursors which are valid on different containers (typically a
--    container C and its previous version C'Old) for expressing properties,
--    which is not possible if cursors encapsulate an access to the underlying
--    container.

--    There are three new functions:

--      function Strict_Equal (Left, Right : Set) return Boolean;
--      function First_To_Previous  (Container : Set; Current : Cursor)
--         return Set;
--      function Current_To_Last (Container : Set; Current : Cursor)
--         return Set;

--    See detailed specifications for these subprograms

private with Ada.Containers.Hash_Tables;

generic
   type Element_Type is private;

   with function Hash (Element : Element_Type) return Hash_Type;

   with function Equivalent_Elements (Left, Right : Element_Type)
                                      return Boolean;

   with function "=" (Left, Right : Element_Type) return Boolean is <>;

package Ada.Containers.Formal_Hashed_Sets with
  Pure,
  SPARK_Mode
is
   pragma Annotate (GNATprove, External_Axiomatization);
   pragma Annotate (CodePeer, Skip_Analysis);

   type Set (Capacity : Count_Type; Modulus : Hash_Type) is private with
     Iterable => (First       => First,
                  Next        => Next,
                  Has_Element => Has_Element,
                  Element     => Element),
     Default_Initial_Condition => Is_Empty (Set);
   pragma Preelaborable_Initialization (Set);

   type Cursor is private;
   pragma Preelaborable_Initialization (Cursor);

   Empty_Set : constant Set;

   No_Element : constant Cursor;

   function "=" (Left, Right : Set) return Boolean with
     Global => null;

   function Equivalent_Sets (Left, Right : Set) return Boolean with
     Global => null;

   function To_Set (New_Item : Element_Type) return Set with
     Global => null;

   function Capacity (Container : Set) return Count_Type with
     Global => null;

   procedure Reserve_Capacity
     (Container : in out Set;
      Capacity  : Count_Type)
   with
     Global => null,
     Pre    => Capacity <= Container.Capacity;

   function Length (Container : Set) return Count_Type with
     Global => null;

   function Is_Empty (Container : Set) return Boolean with
     Global => null;

   procedure Clear (Container : in out Set) with
     Global => null;

   procedure Assign (Target : in out Set; Source : Set) with
     Global => null,
     Pre    => Target.Capacity >= Length (Source);

   function Copy
     (Source   : Set;
      Capacity : Count_Type := 0) return Set
   with
     Global => null,
     Pre    => Capacity = 0 or else Capacity >= Source.Capacity;

   function Element
     (Container : Set;
      Position  : Cursor) return Element_Type
   with
     Global => null,
     Pre    => Has_Element (Container, Position);

   procedure Replace_Element
     (Container : in out Set;
      Position  : Cursor;
      New_Item  : Element_Type)
   with
     Global => null,
     Pre    => Has_Element (Container, Position);

   procedure Move (Target : in out Set; Source : in out Set) with
     Global => null,
     Pre    => Target.Capacity >= Length (Source);

   procedure Insert
     (Container : in out Set;
      New_Item  : Element_Type;
      Position  : out Cursor;
      Inserted  : out Boolean)
   with
     Global => null,
     Pre    => Length (Container) < Container.Capacity;

   procedure Insert  (Container : in out Set; New_Item : Element_Type) with
     Global => null,
     Pre    => Length (Container) < Container.Capacity
                 and then (not Contains (Container, New_Item));

   procedure Include (Container : in out Set; New_Item : Element_Type) with
     Global => null,
     Pre    => Length (Container) < Container.Capacity;

   procedure Replace (Container : in out Set; New_Item : Element_Type) with
     Global => null,
     Pre    => Contains (Container, New_Item);

   procedure Exclude (Container : in out Set; Item     : Element_Type) with
     Global => null;

   procedure Delete  (Container : in out Set; Item     : Element_Type) with
     Global => null,
     Pre    => Contains (Container, Item);

   procedure Delete (Container : in out Set; Position  : in out Cursor) with
     Global => null,
     Pre    => Has_Element (Container, Position);

   procedure Union (Target : in out Set; Source : Set) with
     Global => null,
     Pre    => Length (Target) + Length (Source) -
                 Length (Intersection (Target, Source)) <= Target.Capacity;

   function Union (Left, Right : Set) return Set with
     Global => null,
     Pre    => Length (Left) + Length (Right) -
                 Length (Intersection (Left, Right)) <= Count_Type'Last;

   function "or" (Left, Right : Set) return Set renames Union;

   procedure Intersection (Target : in out Set; Source : Set) with
     Global => null;

   function Intersection (Left, Right : Set) return Set with
     Global => null;

   function "and" (Left, Right : Set) return Set renames Intersection;

   procedure Difference (Target : in out Set; Source : Set) with
     Global => null;

   function Difference (Left, Right : Set) return Set with
     Global => null;

   function "-" (Left, Right : Set) return Set renames Difference;

   procedure Symmetric_Difference (Target : in out Set; Source : Set) with
     Global => null,
     Pre    => Length (Target) + Length (Source) -
                 2 * Length (Intersection (Target, Source)) <= Target.Capacity;

   function Symmetric_Difference (Left, Right : Set) return Set with
     Global => null,
     Pre    => Length (Left) + Length (Right) -
                 2 * Length (Intersection (Left, Right)) <= Count_Type'Last;

   function "xor" (Left, Right : Set) return Set
     renames Symmetric_Difference;

   function Overlap (Left, Right : Set) return Boolean with
     Global => null;

   function Is_Subset (Subset : Set; Of_Set : Set) return Boolean with
     Global => null;

   function First (Container : Set) return Cursor with
     Global => null;

   function Next (Container : Set; Position : Cursor) return Cursor with
     Global => null,
     Pre    => Has_Element (Container, Position) or else Position = No_Element;

   procedure Next (Container : Set; Position : in out Cursor) with
     Global => null,
     Pre    => Has_Element (Container, Position) or else Position = No_Element;

   function Find
     (Container : Set;
      Item      : Element_Type) return Cursor
   with
     Global => null;

   function Contains (Container : Set; Item : Element_Type) return Boolean with
     Global => null;

   function Has_Element (Container : Set; Position : Cursor) return Boolean
   with
     Global => null;

   function Equivalent_Elements (Left  : Set; CLeft : Cursor;
                                 Right : Set; CRight : Cursor) return Boolean
   with
     Global => null;

   function Equivalent_Elements
     (Left  : Set; CLeft : Cursor;
      Right : Element_Type) return Boolean
   with
     Global => null;

   function Equivalent_Elements
     (Left  : Element_Type;
      Right : Set; CRight : Cursor) return Boolean
   with
     Global => null;

   function Default_Modulus (Capacity : Count_Type) return Hash_Type with
     Global => null;

   generic
      type Key_Type (<>) is private;

      with function Key (Element : Element_Type) return Key_Type;

      with function Hash (Key : Key_Type) return Hash_Type;

      with function Equivalent_Keys (Left, Right : Key_Type) return Boolean;

   package Generic_Keys with SPARK_Mode is

      function Key (Container : Set; Position : Cursor) return Key_Type with
        Global => null;

      function Element (Container : Set; Key : Key_Type) return Element_Type
      with
          Global => null;

      procedure Replace
        (Container : in out Set;
         Key       : Key_Type;
         New_Item  : Element_Type)
      with
          Global => null;

      procedure Exclude (Container : in out Set; Key : Key_Type) with
        Global => null;

      procedure Delete (Container : in out Set; Key : Key_Type) with
        Global => null;

      function Find (Container : Set; Key : Key_Type) return Cursor with
        Global => null;

      function Contains (Container : Set; Key : Key_Type) return Boolean with
        Global => null;

   end Generic_Keys;

   function Strict_Equal (Left, Right : Set) return Boolean with
     Ghost,
     Global => null;
   --  Strict_Equal returns True if the containers are physically equal, i.e.
   --  they are structurally equal (function "=" returns True) and that they
   --  have the same set of cursors.

   function First_To_Previous  (Container : Set; Current : Cursor) return Set
   with
     Ghost,
     Global => null,
     Pre    => Has_Element (Container, Current) or else Current = No_Element;

   function Current_To_Last (Container : Set; Current : Cursor) return Set
   with
     Ghost,
     Global => null,
     Pre    => Has_Element (Container, Current) or else Current = No_Element;
   --  First_To_Previous returns a container containing all elements preceding
   --  Current (excluded) in Container. Current_To_Last returns a container
   --  containing all elements following Current (included) in Container.
   --  These two new functions can be used to express invariant properties in
   --  loops which iterate over containers. First_To_Previous returns the part
   --  of the container already scanned and Current_To_Last the part not
   --  scanned yet.

private
   pragma SPARK_Mode (Off);

   pragma Inline (Next);

   type Node_Type is
      record
         Element     : Element_Type;
         Next        : Count_Type;
         Has_Element : Boolean := False;
      end record;

   package HT_Types is new
     Ada.Containers.Hash_Tables.Generic_Bounded_Hash_Table_Types (Node_Type);

   type Set (Capacity : Count_Type; Modulus : Hash_Type) is
     new HT_Types.Hash_Table_Type (Capacity, Modulus) with null record;

   use HT_Types;

   type Cursor is record
      Node : Count_Type;
   end record;

   No_Element : constant Cursor := (Node => 0);

   Empty_Set : constant Set := (Capacity => 0, Modulus => 0, others => <>);

end Ada.Containers.Formal_Hashed_Sets;
