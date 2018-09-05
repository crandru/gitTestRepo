-- Name: Chris Rand
-- Date: February 16, 2018
-- Course: ITEC 320 Procedural Analysis and Design

-- Purpose: This program reads series of strings and determines palindromes.
-- Input: A series of strings listed on separate lines in a text file
-- Output: Prints text stating if the string is or can be a palindrome
-- Example: Text file input with following strings
-- adam
-- eve
-- race,car
-- Printed output below
-- String: "adam"
-- String: Not a palindrome

-- String: "eve"
-- String: Palindrome as entered

-- String: "race,car"
-- String: Palindrome when non-letters are removed
-- Characters removed: 1

-- Help received: Material from 320 Course page and Ada 2005 Textbook,
-- no outside help.

with ada.text_io; use ada.text_io;
with Ada.Strings.Maps.Constants;
with Ada.Strings.Fixed;
with ada.Characters.Handling; use ada.Characters.Handling;

procedure pal_finder is
   ----------------------------------------------------------
   -- Purpose: Reverses a given string
   -- Parameters: s: string to reverse, len: length, t: reversed string
   -- Precondition: s and t are the same size (72)
   -- Postcondition: Outputs reversed s in t parameter
   ----------------------------------------------------------
   procedure reverseWord (s: String; len: Natural; t: out String) is
   begin
      for i in 1 .. len loop
         t(i) := s(len - i + 1);
      end loop;
   end;

   ----------------------------------------------------------
   -- Purpose: Converts a string to uppercase letters
   -- Parameters: s: string to uppercase, len: length
   -- Precondition: noncharacters have been stripped via stripStr
   -- Postcondition: returns string from s in all uppercase
   ----------------------------------------------------------
   function upperCase(s: String; len: Natural) return String is
      -- Contains uppercase string from s to return
      sUpper: String(1 .. len);
   begin
       sUpper := Ada.Strings.Fixed.Translate(s,
         Ada.Strings.Maps.Constants.Upper_Case_Map);
       return sUpper;
   end;

   ----------------------------------------------------------
   -- Purpose: Checks if string is a palindrome
   -- Parameters: s: initial string, len: length, t: reversed string
   -- Precondition: s and t are the same length
   -- Postcondition: Returns boolean with palindrome status
   ----------------------------------------------------------
   function isPalindrome(s: String; t: String; len: Natural) return Boolean is
      -- Holds truth value of s being a palindrome
      palindrome: Boolean;
   begin
      if s(s'First .. len) = t(s'First .. len) then
         palindrome := true;
      else
         palindrome := false;
      end if;
      return palindrome;
   end;

   ----------------------------------------------------------
   -- Purpose: Strips noncharacters from a string and counts removed
   -- Parameters: s: string to strip, len: length, count: # removed
   -- Precondition: count is 0
   -- Postcondition: Outputs cleaned string, updated length, and # removed
   -- Note: Use of is_letter instead of enumerated type of valid characters
   ----------------------------------------------------------
   procedure stripStr(s: in out String; len: in out Natural;
      count: out Integer) is
      -- sClean holds only valid letters from s for end assignment
      sClean: String(1 .. 72);
      -- pos keeps track of cleaned string position
      pos: Integer := 1;
      begin
         count := 0;
         for i in 1 .. len loop
            if Is_Letter(s(i)) then
               sClean(pos) := s(i);
               pos := pos + 1;
            else
               count := count + 1;
            end if;
         end loop;
         len := len - count;
         s := sClean;
      end;

begin
   while not end_of_file loop
   declare
      -- stringIn: String from input, stringRev: holder for reversed string
      -- len: length of in string
      stringIn, stringRev: String(1 .. 72); len: Natural;
      -- Count of noncharacters removed from stripStr procedure
      stripCount: Integer;
   begin
      get_line(stringIn, len);
      put_line("String: " & """" & stringIn(1 .. len) & """");
      reverseWord(stringIn(1 .. len), len, stringRev(1 .. len));

      if isPalindrome(stringIn, stringRev, len) then
         put_line("Status: Palindrome as entered");
      elsif isPalindrome(upperCase(stringIn(1 .. len), len),
         upperCase(stringRev(1 .. len), len), len) then
         put_line("Status: Palindrome when converted to upper case");
      else
         stripStr(stringIn, len, stripCount);
         -- calls reverseWord again to update stringRev without nonletters
         reverseWord(stringIn(1 .. len), len, stringRev(1 .. len));

         if isPalindrome(stringIn, stringRev, len) then
            put_line("Status: Palindrome when non-letters are removed");
            put_line("Characters removed:" & stripCount'img);
         elsif isPalindrome(upperCase(stringIn(1 .. len), len),
            upperCase(stringRev(1 .. len), len), len) then
            put_line("Status: Palindrome when non-letters are removed " &
               "and converted to upper case");
            put_line("Characters removed:" & stripCount'img);
         else
            put_line("Status: Not a palindrome");
         end if;

      end if;
      put_line("");
   end;
   end loop;
end pal_finder;


