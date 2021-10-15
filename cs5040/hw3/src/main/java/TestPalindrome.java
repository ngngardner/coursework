
// Author: Noah Gardner
// Date: 2/26/2021
// File: TestPalindrome.java
// Class: CS 5040
// Instructor: Dr. Seokjun Lee
// Program Number: Assignment 3
// IDE: VS Code

import java.util.Scanner;
import java.util.regex.Pattern;

public class TestPalindrome {

  public boolean isPalindrome(String s) {
    Stack<Character> stack = new Stack<>();
    StringBuilder str = new StringBuilder();

    // append each char in the input string to str as lowercase
    // and push to stack (ignore spaces and punctuation using regex)
    for (int i = 0; i < s.length(); i++) {
      char c = s.charAt(i);
      if (!Pattern.matches("[[\\s][\\p{Punct}]]", Character.toString(c))) {
        c = Character.toLowerCase(c);
        stack.push(c);
        str.append(c);
      }
    }

    String temp = str.toString();

    if (temp.length() != stack.size()) {
      throw new java.lang.Error("Error while checking palindrome.");
    }

    // compare the popped value (starts from end of string)
    // to the value in the string (starts from beginning)
    for (int i = 0; i < temp.length(); i++) {
      char c = temp.charAt(i);
      if (c != stack.pop()) {
        // not palindrome
        return false;
      }
    }

    // is palindrome
    return true;
  }

  public static void main(String[] args) {
    TestPalindrome t = new TestPalindrome();
    Scanner s = new Scanner(System.in);

    while (true) {
      // user entry
      System.out.println("Enter a string (-1 to exit): ");
      String in = s.nextLine();

      // break sequence
      if (in.equals("-1")) {
        System.out.println("Exiting program.");
        break;
      }

      // print input
      System.out.print("Input string: \t");
      System.out.println(in);

      // is palindrome
      System.out.print("Judgement: \t");
      if (t.isPalindrome(in)) {
        System.out.println("Palindrome");
      } else {
        System.out.println("Not Palindrome");
      }
      System.out.println();
    }
    s.close();
  }
}
