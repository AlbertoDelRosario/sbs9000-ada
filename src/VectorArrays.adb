with System.Address_To_Access_Conversions;
package body VectorArrays is
   
   procedure Shuffle_Sort (X : in out Integer_Array) is
        Position : Positive;
        Value : Integer;
    begin
        for I in X'First+1 .. X'Last loop
            if X(I) < X(I-1) then
                -- Misplaced item found: copy it
                Value := X(I);
                -- Scan backwards until correct position found
                for J in reverse X'First .. I-1 loop
                    exit when X(J) < Value;
                    Position := J;
                end loop;
                -- Move intervening values along
                X(Position+1 .. I) := X(Position .. I-1);
                -- Put saved copy of item in correct position
                X(Position) := Value;
            end if;
        end loop;
   end Shuffle_Sort;
   
   procedure Swap(arr : in out Integer_Array; i : Integer; j : Integer) is
      auxVal : Integer := arr(i);
   begin
      arr(i) := arr(j);
      arr(j) := auxVal;
   end Swap;
   
   procedure AddNum(To : in out VectorArray; Item : Integer) is
   begin
      To.Ind := To.Ind + 1;
      To.List (To.Ind) := Item;
   end AddNum;
   
   function Element (V : VectorArray; Index : Positive) return Integer is 
   begin
      return V.List(Index);
   end Element;
   
   package Address_Conversions
   is new System.Address_To_Access_Conversions (VectorArray);
   
   function Has_Element (Pos : Cursor) return Boolean is
      V : VectorArray renames Address_Conversions.To_Pointer (Pos.The_Vector).all;
   begin
      return Pos.has_E;
   end Has_Element;
   
   function Element (C : Cursor) return Integer_Array is
      V : VectorArray renames Address_Conversions.To_Pointer (C.The_Vector).all;
      aux : Integer_Array(V.List'Range);
      index : Positive;
   begin
      for i in aux'Range loop
	 index := C.Indexes(i);
	 aux(i) := V.List(index);
      end loop;
	 return aux;
      --modificar salida para devolver vector.
   end Element;
   
   type Iterator is new VectorArray_Iterators.Forward_Iterator with record
      The_Vector : System.Address;
   end record;
   
   overriding function First (Object : Iterator) return Cursor;
   
   overriding function Next (Object : Iterator; Pos : Cursor) return Cursor;

   function Iterate (V : VectorArray)
                    return VectorArray_Iterators.Forward_Iterator'Class is                   --'
   begin
      return It : Iterator do
         It.The_Vector := V'Address;                                                     --'
      end return;                                                                   --'
   end Iterate;

   function First (Object : Iterator) return Cursor is
      V : VectorArray renames Address_Conversions.To_Pointer (Object.The_Vector).all;
      auxVect : Integer_Array(V.List'Range);
      auxInd : Integer;
      auxVal : Integer;
   begin
      --Arrange the initial indexes array
      for i in auxVect'Range loop
	 auxInd := i;
	 for j in V.List'Range loop
	    auxVal := V.List(i);
	    if auxVal = V.List(j) then
	       auxInd := j;
	       exit;
	    end if;
	 end loop;
	 auxVect(i) := auxInd;
      end loop;
      Shuffle_Sort(auxVect);
      return C : Cursor(V.List'Length) do
         C.The_Vector := Object.The_Vector;
	 C.List_Index := 1;
	 C.Has_E := True;
	 C.Indexes := auxVect;
      end return;
   end First;

   function Next (Object : Iterator; Pos : Cursor) return Cursor is
      pragma Unreferenced (Object);
      V : VectorArray renames Address_Conversions.To_Pointer (Pos.The_Vector).all;
      auxVect : Integer_Array(V.List'Range):= Pos.Indexes;
      --auxInd : Integer;
      auxVal : Integer;
      auxHas_N : Boolean;
      auxI : Integer;
      auxJ : Integer;
   begin
      --Arrange the new indexes array
      auxHas_N := False;
      for tail in reverse 2..auxVect'Length loop
	 if auxVect(tail-1) < auxVect(tail) then
	    auxVal := auxVect'Length;
	    while auxVect(tail-1) >= auxVect(auxVal) loop
	       auxVal := auxVal - 1;
	    end loop;
	    
	    Swap(auxVect, (tail-1), auxVal);
	    auxI := tail;
	    auxJ := auxVect'Length;
	    while auxI < auxJ loop
	       Swap(auxVect, auxI, auxJ);
	       auxI := auxI + 1;
	       auxJ := auxJ - 1;
	    end loop;
	    auxHas_N := True;
	    exit;
	 end if;
      end loop;
      return C : Cursor(V.List'Length) do
         C.The_Vector := Pos.The_Vector;
	 C.List_Index := Pos.List_Index + 1;
	 C.Has_E := auxHas_N;
	 C.Indexes := auxVect;
      end return;
   end Next;
   
end VectorArrays;
