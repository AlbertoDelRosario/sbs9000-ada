with Ada.Integer_Text_IO,
     Ada.Text_IO,
     VectorArrays;
use Ada.Integer_Text_IO,
    Ada.Text_IO,
    VectorArrays;

package body FileIO is

   function ReadFile(fileName : String) return Positive is
      Integer_File : File_Type;
      Index        : Integer;
      Weight : Positive;
   begin
      Open(Integer_File, In_File, fileName);
      if not End_Of_File(Integer_File) then
	 Get(Integer_File, Index);
	 VectorSize := Index;
      end if;
      if not End_Of_File(Integer_File) then
	 Get(Integer_File, Index);
	 Weight := Index;
      end if;
      Close(Integer_File);
      return Weight;
   end ReadFile;
   
   function InitializeVector(fileName : String) return VectorArray is 
      Integer_File : File_Type;
      Index        : Integer;
   begin
      Open(Integer_File, In_File, fileName);
      if not End_Of_File(Integer_File) then 
	 Get(Integer_File, Index);
	 Get(Integer_File, Index);
      end if;
      return V : VectorArray(VectorSize) do
	 for i in 1..VectorSize loop
	    Get(Integer_File, Index);
	    VectorArrays.AddNum(V,Index);
	 end loop;
	 Close(Integer_File);
      end return;
   end InitializeVector;

end FileIO;
