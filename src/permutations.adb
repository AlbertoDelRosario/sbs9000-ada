with Ada.Text_IO,
     Ada.Command_Line,
     Ada.Calendar,
     FileIO,
     VectorArrays;
use Ada.Text_IO,
    Ada.Command_Line,
    Ada.Calendar,
    FileIO,
    VectorArrays;
procedure Permutations is

   Start_Time : Time := Clock;
   Finish_Time : Time;
   DIn : Boolean := False;
   DOut : Boolean := False;
   DComp: Boolean := False;
   DTime : Boolean := False;
   FileArgument : Integer;
   MaxWeight : Positive;

   procedure print(arr : Integer_Array) is
      begin
      for i in arr'Range loop
         Put(arr(i)'Image);
      end loop;
      --Put_Line("");
   end print;

   procedure Read(file : String) is
   begin
      MaxWeight := ReadFile(file);
      --Put_Line(FileIO.VectorSize'Image);
      --Put_Line(FileIO.MaxWeight'Image);
   end read;

   procedure doPermutations (file : String)is
      vect : VectorArray(FileIO.VectorSize);
      AuxInt : Integer;
      BestCount : Integer := FileIO.VectorSize;
      BestOrder : Integer_Array(1..FileIO.VectorSize);
      Permutations : Integer := 0;

      function countTravels(arr : Integer_Array) return Integer is
	 w : Integer := 0;
	 count : Natural := 0;
      begin
	 for i in arr'Range loop
	    w := w + arr(i);
	    if w >= MaxWeight then
	       count := count + 1;
	       if w > MaxWeight then
		  w := arr(i);
	       else
		  w := 0;
	       end if;
	    end if;
	 end loop;
	 if w /= 0 then count := count + 1; end if;
	 return count;
      end countTravels;

   begin
      vect := FileIO.InitializeVector(file);
      --Do in debug input------------------------------------------------
      if DIn = True then
	 Put_Line("***Input");
	 for i in 1..VectorSize loop
	    Put_Line(i'Image & " =>" & VectorArrays.Element(vect, i)'Image);
	 end loop;
	 Put_Line("------------Max_Weight =" & MaxWeight'Image);
      end if;
      -------------------------------------------------------------------
      for C in VectorArrays.Iterate (vect) loop
	 Permutations := Permutations + 1;
	 AuxInt := countTravels(Element(C));
	 if AuxInt < BestCount then
	    BestCount := AuxInt;
	    BestOrder := Element(C);
	    --Do in debugg comp------------------------------------------
	    if DComp = True then
	       print(Element(C));
	       Put_Line(" => Travels:" & BestCount'Image);
	    end if;
	    -------------------------------------------------------------
	 end if;
	 --print(Element(C));--Print all arrays
      end loop;
      --Do in debug output-----------------------------------------------
      if DOut = True then
	 Put_Line("---------------------------");
	 Put_Line("Permutations proved:" & Permutations'Image);
	 Put(" Best order:");
	 print(BestOrder);
	 Put_Line("  Travels:" & BestCount'Image);
      end if;
      -------------------------------------------------------------------
   end doPermutations;

begin
   for arg in 1..Argument_Count loop
      --Put_Line(Argument(arg) & "");
      if Argument(arg) & "" = "-di" then
	 DIn := True;
      end if;
      if Argument(arg) & "" = "-do" then
	 DOut := True;
      end if;
      if Argument(arg) & "" = "-dc" then
	 DComp := True;
      end if;
      if Argument(arg) & "" = "-dt" then
	 DTime := True;
      end if;
      if Argument(arg) & "" = "-f" then
	 Read(Argument(arg + 1) & "");
	 FileArgument := arg + 1;
      end if;
      if Argument(arg) & "" = "-n" then
	 MaxWeight := Integer'Value(Argument(arg + 1) & "");

      end if;
   end loop;
   --read;
   doPermutations(Argument(FileArgument));
   Finish_Time := Clock;
   --Do in debug time---------------------------------------------------
   if DTime = True then
      Put_Line("   Time:" &
		 Duration'Image(Finish_Time - Start_Time) & " seconds");
   end if;
   ---------------------------------------------------------------------
   exception
	 when Constraint_Error
	    => Put_Line ("*** Error: Parametros incorrectos");
end Permutations;
