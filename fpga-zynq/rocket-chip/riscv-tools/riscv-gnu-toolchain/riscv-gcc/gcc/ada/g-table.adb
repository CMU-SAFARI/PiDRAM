------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                            G N A T . T A B L E                           --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                     Copyright (C) 1998-2014, AdaCore                     --
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
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

with GNAT.Heap_Sort_G;

with System;        use System;
with System.Memory; use System.Memory;

with Ada.Unchecked_Conversion;

package body GNAT.Table is

   Min : constant Integer := Integer (Table_Low_Bound);
   --  Subscript of the minimum entry in the currently allocated table

   Max : Integer;
   --  Subscript of the maximum entry in the currently allocated table

   Length : Integer := 0;
   --  Number of entries in currently allocated table. The value of zero
   --  ensures that we initially allocate the table.

   Last_Val : Integer;
   --  Current value of Last

   -----------------------
   -- Local Subprograms --
   -----------------------

   procedure Reallocate;
   --  Reallocate the existing table according to the current value stored
   --  in Max. Works correctly to do an initial allocation if the table
   --  is currently null.

   pragma Warnings (Off);
   --  Turn off warnings. The following unchecked conversions are only used
   --  internally in this package, and cannot never result in any instances
   --  of improperly aliased pointers for the client of the package.

   function To_Address is new Ada.Unchecked_Conversion (Table_Ptr, Address);
   function To_Pointer is new Ada.Unchecked_Conversion (Address, Table_Ptr);

   pragma Warnings (On);

   --------------
   -- Allocate --
   --------------

   function Allocate (Num : Integer := 1) return Table_Index_Type is
      Old_Last : constant Integer := Last_Val;

   begin
      Last_Val := Last_Val + Num;

      if Last_Val > Max then
         Reallocate;
      end if;

      return Table_Index_Type (Old_Last + 1);
   end Allocate;

   ------------
   -- Append --
   ------------

   procedure Append (New_Val : Table_Component_Type) is
   begin
      Set_Item (Table_Index_Type (Last_Val + 1), New_Val);
   end Append;

   ----------------
   -- Append_All --
   ----------------

   procedure Append_All (New_Vals : Table_Type) is
   begin
      for J in New_Vals'Range loop
         Append (New_Vals (J));
      end loop;
   end Append_All;

   --------------------
   -- Decrement_Last --
   --------------------

   procedure Decrement_Last is
   begin
      Last_Val := Last_Val - 1;
   end Decrement_Last;

   --------------
   -- For_Each --
   --------------

   procedure For_Each is
      Quit : Boolean := False;
   begin
      for Index in Table_Low_Bound .. Table_Index_Type (Last_Val) loop
         Action (Index, Table (Index), Quit);
         exit when Quit;
      end loop;
   end For_Each;

   ----------
   -- Free --
   ----------

   procedure Free is
   begin
      Free (To_Address (Table));
      Table := null;
      Length := 0;
   end Free;

   --------------------
   -- Increment_Last --
   --------------------

   procedure Increment_Last is
   begin
      Last_Val := Last_Val + 1;

      if Last_Val > Max then
         Reallocate;
      end if;
   end Increment_Last;

   ----------
   -- Init --
   ----------

   procedure Init is
      Old_Length : constant Integer := Length;

   begin
      Last_Val := Min - 1;
      Max      := Min + Table_Initial - 1;
      Length   := Max - Min + 1;

      --  If table is same size as before (happens when table is never
      --  expanded which is a common case), then simply reuse it. Note
      --  that this also means that an explicit Init call right after
      --  the implicit one in the package body is harmless.

      if Old_Length = Length then
         return;

      --  Otherwise we can use Reallocate to get a table of the right size.
      --  Note that Reallocate works fine to allocate a table of the right
      --  initial size when it is first allocated.

      else
         Reallocate;
      end if;
   end Init;

   ----------
   -- Last --
   ----------

   function Last return Table_Index_Type is
   begin
      return Table_Index_Type (Last_Val);
   end Last;

   ----------------
   -- Reallocate --
   ----------------

   procedure Reallocate is
      New_Size   : size_t;
      New_Length : Long_Long_Integer;

   begin
      if Max < Last_Val then
         pragma Assert (not Locked);

         --  Now increment table length until it is sufficiently large. Use
         --  the increment value or 10, which ever is larger (the reason
         --  for the use of 10 here is to ensure that the table does really
         --  increase in size (which would not be the case for a table of
         --  length 10 increased by 3% for instance). Do the intermediate
         --  calculation in Long_Long_Integer to avoid overflow.

         while Max < Last_Val loop
            New_Length :=
              Long_Long_Integer (Length) *
                (100 + Long_Long_Integer (Table_Increment)) / 100;
            Length := Integer'Max (Integer (New_Length), Length + 10);
            Max := Min + Length - 1;
         end loop;
      end if;

      New_Size :=
        size_t ((Max - Min + 1) *
                (Table_Type'Component_Size / Storage_Unit));

      if Table = null then
         Table := To_Pointer (Alloc (New_Size));

      elsif New_Size > 0 then
         Table :=
           To_Pointer (Realloc (Ptr  => To_Address (Table),
                                Size => New_Size));
      end if;

      if Length /= 0 and then Table = null then
         raise Storage_Error;
      end if;

   end Reallocate;

   -------------
   -- Release --
   -------------

   procedure Release is
   begin
      Length := Last_Val - Integer (Table_Low_Bound) + 1;
      Max    := Last_Val;
      Reallocate;
   end Release;

   --------------
   -- Set_Item --
   --------------

   procedure Set_Item
      (Index : Table_Index_Type;
       Item  : Table_Component_Type)
   is
      --  If Item is a value within the current allocation, and we are going to
      --  reallocate, then we must preserve an intermediate copy here before
      --  calling Increment_Last. Otherwise, if Table_Component_Type is passed
      --  by reference, we are going to end up copying from storage that might
      --  have been deallocated from Increment_Last calling Reallocate.

      subtype Allocated_Table_T is
        Table_Type (Table'First .. Table_Index_Type (Max + 1));
      --  A constrained table subtype one element larger than the currently
      --  allocated table.

      Allocated_Table_Address : constant System.Address :=
                                  Table.all'Address;
      --  Used for address clause below (we can't use non-static expression
      --  Table.all'Address directly in the clause because some older versions
      --  of the compiler do not allow it).

      Allocated_Table : Allocated_Table_T;
      pragma Import (Ada, Allocated_Table);
      pragma Suppress (Range_Check, On => Allocated_Table);
      for Allocated_Table'Address use Allocated_Table_Address;
      --  Allocated_Table represents the currently allocated array, plus one
      --  element (the supplementary element is used to have a convenient
      --  way of computing the address just past the end of the current
      --  allocation). Range checks are suppressed because this unit uses
      --  direct calls to System.Memory for allocation, and this can yield
      --  misaligned storage (and we cannot rely on the bootstrap compiler
      --  supporting specifically disabling alignment checks, so we need to
      --  suppress all range checks). It is safe to suppress this check here
      --  because we know that a (possibly misaligned) object of that type
      --  does actually exist at that address. ??? We should really improve
      --  the allocation circuitry here to
      --  guarantee proper alignment.

      Need_Realloc : constant Boolean := Integer (Index) > Max;
      --  True if this operation requires storage reallocation (which may
      --  involve moving table contents around).

   begin
      --  If we're going to reallocate, check whether Item references an
      --  element of the currently allocated table.

      if Need_Realloc
        and then Allocated_Table'Address <= Item'Address
        and then Item'Address <
                   Allocated_Table (Table_Index_Type (Max + 1))'Address
      then
         --  If so, save a copy on the stack because Increment_Last will
         --  reallocate storage and might deallocate the current table.

         declare
            Item_Copy : constant Table_Component_Type := Item;
         begin
            Set_Last (Index);
            Table (Index) := Item_Copy;
         end;

      else
         --  Here we know that either we won't reallocate (case of Index < Max)
         --  or that Item is not in the currently allocated table.

         if Integer (Index) > Last_Val then
            Set_Last (Index);
         end if;

         Table (Index) := Item;
      end if;
   end Set_Item;

   --------------
   -- Set_Last --
   --------------

   procedure Set_Last (New_Val : Table_Index_Type) is
   begin
      if Integer (New_Val) < Last_Val then
         Last_Val := Integer (New_Val);
      else
         Last_Val := Integer (New_Val);

         if Last_Val > Max then
            Reallocate;
         end if;
      end if;
   end Set_Last;

   ----------------
   -- Sort_Table --
   ----------------

   procedure Sort_Table is

      Temp : Table_Component_Type;
      --  A temporary position to simulate index 0

      --  Local subprograms

      function Index_Of (Idx : Natural) return Table_Index_Type;
      --  Return index of Idx'th element of table

      function Lower_Than (Op1, Op2 : Natural) return Boolean;
      --  Compare two components

      procedure Move (From : Natural; To : Natural);
      --  Move one component

      package Heap_Sort is new GNAT.Heap_Sort_G (Move, Lower_Than);

      --------------
      -- Index_Of --
      --------------

      function Index_Of (Idx : Natural) return Table_Index_Type is
         J : constant Integer'Base := Table_Index_Type'Pos (First) + Idx - 1;
      begin
         return Table_Index_Type'Val (J);
      end Index_Of;

      ----------
      -- Move --
      ----------

      procedure Move (From : Natural; To : Natural) is
      begin
         if From = 0 then
            Table (Index_Of (To)) := Temp;
         elsif To = 0 then
            Temp := Table (Index_Of (From));
         else
            Table (Index_Of (To)) := Table (Index_Of (From));
         end if;
      end Move;

      ----------------
      -- Lower_Than --
      ----------------

      function Lower_Than (Op1, Op2 : Natural) return Boolean is
      begin
         if Op1 = 0 then
            return Lt (Temp, Table (Index_Of (Op2)));
         elsif Op2 = 0 then
            return Lt (Table (Index_Of (Op1)), Temp);
         else
            return Lt (Table (Index_Of (Op1)), Table (Index_Of (Op2)));
         end if;
      end Lower_Than;

   --  Start of processing for Sort_Table

   begin
      Heap_Sort.Sort (Natural (Last - First) + 1);
   end Sort_Table;

begin
   Init;
end GNAT.Table;
