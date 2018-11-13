with Ada.Integer_Text_IO,
     VectorArrays;
use Ada.Integer_Text_IO,
    VectorArrays;

package FileIO is

   --MaxWeight : Integer;
   
   VectorSize : Positive;
   
   function ReadFile(fileName : String) return Positive;
   
   function InitializeVector(fileName : String) return VectorArray;
   
end FileIO;
