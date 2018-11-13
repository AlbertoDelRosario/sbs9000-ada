with Ada.Iterator_Interfaces;
private with System;
package VectorArrays is
   
   SizeOfVector : Positive;
   
   type Integer_Array is array (Positive range <>) of Integer;

   type VectorArray (num : Positive) is private;
   
   procedure AddNum (To : in out VectorArray; Item : Integer);
   
   function Element (V : VectorArray; Index : Positive) return Integer;
   
   type Cursor(num : Positive) is private;
   function Has_Element (Pos : Cursor) return Boolean;
   function Element (C : Cursor) return Integer_Array;
   
   package VectorArray_Iterators
   is new Ada.Iterator_Interfaces (Cursor, Has_Element);
   
   function Iterate (V : VectorArray) 
		     return VectorArray_Iterators.Forward_Iterator'Class;

private
   
   type VectorArray(num : Positive) is record
      List : Integer_Array(1..num);
      Ind : Natural := 0;
   end record;
   
   type Cursor(num : Positive) is record
      The_Vector : System.Address;
      List_Index : Positive := 1;
      has_E : Boolean := True;
      Indexes : Integer_Array(1..num);
   end record;
   
end VectorArrays;
