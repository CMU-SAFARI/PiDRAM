------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--  A D A . E X C E P T I O N S . E X C E P T I O N _ P R O P A G A T I O N --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1992-2016, Free Software Foundation, Inc.         --
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

--  This is the version using the GCC EH mechanism

with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;

with System.Storage_Elements;   use System.Storage_Elements;
with System.Exceptions.Machine; use System.Exceptions.Machine;

separate (Ada.Exceptions)
package body Exception_Propagation is

   use Exception_Traces;

   Foreign_Exception : aliased System.Standard_Library.Exception_Data;
   pragma Import (Ada, Foreign_Exception,
                  "system__exceptions__foreign_exception");
   --  Id for foreign exceptions

   --------------------------------------------------------------
   -- GNAT Specific Entities To Deal With The GCC EH Circuitry --
   --------------------------------------------------------------

   procedure GNAT_GCC_Exception_Cleanup
     (Reason : Unwind_Reason_Code;
      Excep  : not null GNAT_GCC_Exception_Access);
   pragma Convention (C, GNAT_GCC_Exception_Cleanup);
   --  Procedure called when a GNAT GCC exception is free.

   procedure Propagate_GCC_Exception
     (GCC_Exception : not null GCC_Exception_Access);
   pragma No_Return (Propagate_GCC_Exception);
   --  Propagate a GCC exception

   procedure Reraise_GCC_Exception
     (GCC_Exception : not null GCC_Exception_Access);
   pragma No_Return (Reraise_GCC_Exception);
   pragma Export (C, Reraise_GCC_Exception, "__gnat_reraise_zcx");
   --  Called to implement raise without exception, ie reraise. Called
   --  directly from gigi.

   function Setup_Current_Excep
     (GCC_Exception : not null GCC_Exception_Access) return EOA;
   pragma Export (C, Setup_Current_Excep, "__gnat_setup_current_excep");
   --  Write Get_Current_Excep.all from GCC_Exception. Called by the
   --  personality routine.

   procedure Unhandled_Except_Handler
     (GCC_Exception : not null GCC_Exception_Access);
   pragma No_Return (Unhandled_Except_Handler);
   pragma Export (C, Unhandled_Except_Handler,
                  "__gnat_unhandled_except_handler");
   --  Called for handle unhandled exceptions, ie the last chance handler
   --  on platforms (such as SEH) that never returns after throwing an
   --  exception. Called directly by gigi.

   function CleanupUnwind_Handler
     (UW_Version   : Integer;
      UW_Phases    : Unwind_Action;
      UW_Eclass    : Exception_Class;
      UW_Exception : not null GCC_Exception_Access;
      UW_Context   : System.Address;
      UW_Argument  : System.Address) return Unwind_Reason_Code;
   pragma Import (C, CleanupUnwind_Handler,
                  "__gnat_cleanupunwind_handler");
   --  Hook called at each step of the forced unwinding we perform to trigger
   --  cleanups found during the propagation of an unhandled exception.

   --  GCC runtime functions used. These are C non-void functions, actually,
   --  but we ignore the return values. See raise.c as to why we are using
   --  __gnat stubs for these.

   procedure Unwind_RaiseException
     (UW_Exception : not null GCC_Exception_Access);
   pragma Import (C, Unwind_RaiseException, "__gnat_Unwind_RaiseException");

   procedure Unwind_ForcedUnwind
     (UW_Exception : not null GCC_Exception_Access;
      UW_Handler   : System.Address;
      UW_Argument  : System.Address);
   pragma Import (C, Unwind_ForcedUnwind, "__gnat_Unwind_ForcedUnwind");

   procedure Set_Exception_Parameter
     (Excep         : EOA;
      GCC_Exception : not null GCC_Exception_Access);
   pragma Export
     (C, Set_Exception_Parameter, "__gnat_set_exception_parameter");
   --  Called inserted by gigi to set the exception choice parameter from the
   --  gcc occurrence.

   procedure Set_Foreign_Occurrence (Excep : EOA; Mo : System.Address);
   --  Utility routine to initialize occurrence Excep from a foreign exception
   --  whose machine occurrence is Mo. The message is empty, the backtrace
   --  is empty too and the exception identity is Foreign_Exception.

   --  Hooks called when entering/leaving an exception handler for a given
   --  occurrence, aimed at handling the stack of active occurrences. The
   --  calls are generated by gigi in tree_transform/N_Exception_Handler.

   procedure Begin_Handler (GCC_Exception : not null GCC_Exception_Access);
   pragma Export (C, Begin_Handler, "__gnat_begin_handler");

   procedure End_Handler (GCC_Exception : GCC_Exception_Access);
   pragma Export (C, End_Handler, "__gnat_end_handler");

   --------------------------------------------------------------------
   -- Accessors to Basic Components of a GNAT Exception Data Pointer --
   --------------------------------------------------------------------

   --  As of today, these are only used by the C implementation of the GCC
   --  propagation personality routine to avoid having to rely on a C
   --  counterpart of the whole exception_data structure, which is both
   --  painful and error prone. These subprograms could be moved to a more
   --  widely visible location if need be.

   function Is_Handled_By_Others (E : Exception_Data_Ptr) return Boolean;
   pragma Export (C, Is_Handled_By_Others, "__gnat_is_handled_by_others");
   pragma Warnings (Off, Is_Handled_By_Others);

   function Language_For (E : Exception_Data_Ptr) return Character;
   pragma Export (C, Language_For, "__gnat_language_for");

   function Foreign_Data_For (E : Exception_Data_Ptr) return Address;
   pragma Export (C, Foreign_Data_For, "__gnat_foreign_data_for");

   function EID_For (GNAT_Exception : not null GNAT_GCC_Exception_Access)
     return Exception_Id;
   pragma Export (C, EID_For, "__gnat_eid_for");

   ---------------------------------------------------------------------------
   -- Objects to materialize "others" and "all others" in the GCC EH tables --
   ---------------------------------------------------------------------------

   --  Currently, these only have their address taken and compared so there is
   --  no real point having whole exception data blocks allocated. Note that
   --  there are corresponding declarations in gigi (trans.c) which must be
   --  kept properly synchronized.

   Others_Value : constant Character := 'O';
   pragma Export (C, Others_Value, "__gnat_others_value");

   All_Others_Value : constant Character := 'A';
   pragma Export (C, All_Others_Value, "__gnat_all_others_value");

   Unhandled_Others_Value : constant Character := 'U';
   pragma Export (C, Unhandled_Others_Value, "__gnat_unhandled_others_value");
   --  Special choice (emitted by gigi) to catch and notify unhandled
   --  exceptions on targets which always handle exceptions (such as SEH).
   --  The handler will simply call Unhandled_Except_Handler.

   -------------------------
   -- Allocate_Occurrence --
   -------------------------

   function Allocate_Occurrence return EOA is
      Res : GNAT_GCC_Exception_Access;

   begin
      Res := New_Occurrence;
      Res.Header.Cleanup := GNAT_GCC_Exception_Cleanup'Address;
      Res.Occurrence.Machine_Occurrence := Res.all'Address;

      return Res.Occurrence'Access;
   end Allocate_Occurrence;

   --------------------------------
   -- GNAT_GCC_Exception_Cleanup --
   --------------------------------

   procedure GNAT_GCC_Exception_Cleanup
     (Reason : Unwind_Reason_Code;
      Excep  : not null GNAT_GCC_Exception_Access)
   is
      pragma Unreferenced (Reason);

      procedure Free is new Unchecked_Deallocation
        (GNAT_GCC_Exception, GNAT_GCC_Exception_Access);

      Copy : GNAT_GCC_Exception_Access := Excep;

   begin
      --  Simply free the memory

      Free (Copy);
   end GNAT_GCC_Exception_Cleanup;

   ----------------------------
   -- Set_Foreign_Occurrence --
   ----------------------------

   procedure Set_Foreign_Occurrence (Excep : EOA; Mo : System.Address) is
   begin
      Excep.all := (
        Id                 => Foreign_Exception'Access,
        Machine_Occurrence => Mo,
        Msg                => <>,
        Msg_Length         => 0,
        Exception_Raised   => True,
        Pid                => Local_Partition_ID,
        Num_Tracebacks     => 0,
        Tracebacks         => <>);
   end Set_Foreign_Occurrence;

   -------------------------
   -- Setup_Current_Excep --
   -------------------------

   function Setup_Current_Excep
     (GCC_Exception : not null GCC_Exception_Access) return EOA
   is
      Excep : constant EOA := Get_Current_Excep.all;

   begin
      --  Setup the exception occurrence

      if GCC_Exception.Class = GNAT_Exception_Class then

         --  From the GCC exception

         declare
            GNAT_Occurrence : constant GNAT_GCC_Exception_Access :=
                                To_GNAT_GCC_Exception (GCC_Exception);
         begin
            Excep.all := GNAT_Occurrence.Occurrence;
            return GNAT_Occurrence.Occurrence'Access;
         end;

      else
         --  A default one

         Set_Foreign_Occurrence (Excep, GCC_Exception.all'Address);

         return Excep;
      end if;
   end Setup_Current_Excep;

   -------------------
   -- Begin_Handler --
   -------------------

   procedure Begin_Handler (GCC_Exception : not null GCC_Exception_Access) is
      pragma Unreferenced (GCC_Exception);
   begin
      null;
   end Begin_Handler;

   -----------------
   -- End_Handler --
   -----------------

   procedure End_Handler (GCC_Exception : GCC_Exception_Access) is
   begin
      if GCC_Exception /= null then

         --  The exception might have been reraised, in this case the cleanup
         --  mustn't be called.

         Unwind_DeleteException (GCC_Exception);
      end if;
   end End_Handler;

   -----------------------------
   -- Reraise_GCC_Exception --
   -----------------------------

   procedure Reraise_GCC_Exception
     (GCC_Exception : not null GCC_Exception_Access)
   is
   begin
      --  Simply propagate it

      Propagate_GCC_Exception (GCC_Exception);
   end Reraise_GCC_Exception;

   -----------------------------
   -- Propagate_GCC_Exception --
   -----------------------------

   --  Call Unwind_RaiseException to actually throw, taking care of handling
   --  the two phase scheme it implements.

   procedure Propagate_GCC_Exception
     (GCC_Exception : not null GCC_Exception_Access)
   is
      Excep : EOA;

   begin
      --  Perform a standard raise first. If a regular handler is found, it
      --  will be entered after all the intermediate cleanups have run. If
      --  there is no regular handler, it will return.

      Unwind_RaiseException (GCC_Exception);

      --  If we get here we know the exception is not handled, as otherwise
      --  Unwind_RaiseException arranges for the handler to be entered. Take
      --  the necessary steps to enable the debugger to gain control while the
      --  stack is still intact.

      Excep := Setup_Current_Excep (GCC_Exception);
      Notify_Unhandled_Exception (Excep);

      --  Now, un a forced unwind to trigger cleanups. Control should not
      --  resume there, if there are cleanups and in any cases as the
      --  unwinding hook calls Unhandled_Exception_Terminate when end of
      --  stack is reached.

      Unwind_ForcedUnwind
        (GCC_Exception,
         CleanupUnwind_Handler'Address,
         System.Null_Address);

      --  We get here in case of error. The debugger has been notified before
      --  the second step above.

      Unhandled_Except_Handler (GCC_Exception);
   end Propagate_GCC_Exception;

   -------------------------
   -- Propagate_Exception --
   -------------------------

   procedure Propagate_Exception (Excep : EOA) is
   begin
      Propagate_GCC_Exception (To_GCC_Exception (Excep.Machine_Occurrence));
   end Propagate_Exception;

   -----------------------------
   -- Set_Exception_Parameter --
   -----------------------------

   procedure Set_Exception_Parameter
     (Excep         : EOA;
      GCC_Exception : not null GCC_Exception_Access)
   is
   begin
      --  Setup the exception occurrence

      if GCC_Exception.Class = GNAT_Exception_Class then

         --  From the GCC exception

         declare
            GNAT_Occurrence : constant GNAT_GCC_Exception_Access :=
                                To_GNAT_GCC_Exception (GCC_Exception);
         begin
            Save_Occurrence (Excep.all, GNAT_Occurrence.Occurrence);
         end;

      else
         --  A default one

         Set_Foreign_Occurrence (Excep, GCC_Exception.all'Address);
      end if;
   end Set_Exception_Parameter;

   ------------------------------
   -- Unhandled_Except_Handler --
   ------------------------------

   procedure Unhandled_Except_Handler
     (GCC_Exception : not null GCC_Exception_Access)
   is
      Excep : EOA;
   begin
      Excep := Setup_Current_Excep (GCC_Exception);
      Unhandled_Exception_Terminate (Excep);
   end Unhandled_Except_Handler;

   -------------
   -- EID_For --
   -------------

   function EID_For
     (GNAT_Exception : not null GNAT_GCC_Exception_Access) return Exception_Id
   is
   begin
      return GNAT_Exception.Occurrence.Id;
   end EID_For;

   ----------------------
   -- Foreign_Data_For --
   ----------------------

   function Foreign_Data_For
     (E : SSL.Exception_Data_Ptr) return Address
   is
   begin
      return E.Foreign_Data;
   end Foreign_Data_For;

   --------------------------
   -- Is_Handled_By_Others --
   --------------------------

   function Is_Handled_By_Others (E : SSL.Exception_Data_Ptr) return Boolean is
   begin
      return not E.all.Not_Handled_By_Others;
   end Is_Handled_By_Others;

   ------------------
   -- Language_For --
   ------------------

   function Language_For (E : SSL.Exception_Data_Ptr) return Character is
   begin
      return E.all.Lang;
   end Language_For;

end Exception_Propagation;
