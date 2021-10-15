
/**
 * Author: Noah Gardner
 * Date: 1/28/2021
 * File: Vowels.java
 * Class: CS 5040
 * Instructor: Dr. Seokjun Lee
 * Program Number: Assignment 1 Programming 2
 * IDE: VS Code
 */

import java.util.Scanner;

public class Vowels {

  /**
   *
   * @param args
   *
   *             The purpose of this class is to count the number of vowels in a
   *             user input string recursively.
   */
  public static void main(String[] args) {
    System.out.println(
        "Enter a string to count the number of vowels (0 to exit).");
    Scanner s = new Scanner(System.in);

    while (true) {
      // scanner input for string to count number of vowels
      System.out.print("Entered string: ");
      String in = s.nextLine();

      if (in.equals("0")) {
        break;
      }

      Integer res = vowels(in, in.length());

      System.out.print("Number of vowels:     ");
      System.out.println(res);
      System.out.println();
    }

    s.close();
  }

  /**
   *
   * @param str
   * @param l
   * @return
   *
   *         Recursively counts the number of vowels in the input string @str
   *         based on the length of the string remaining @l. In the base case
   *         where @l=0, this function returns 0. For @l>0, if the first
   * character in @str is a value, return 1 + recursive call with a substring of
   * @str starting from index 1 and @l-1. Otherwise, return the recursive call.
   */
  public static int vowels(String str, Integer l) {
    if (l > 0) {
      char c = str.charAt(0);
      if (isVowel(c)) {
        return 1 + vowels(str.substring(1), l - 1);
      } else {
        return vowels(str.substring(1), l - 1);
      }
    } else {
      return 0;
    }
  }

  /**
   *
   * @param c
   * @return
   *
   *         Evaluates to true if @c is a vowel (a, e, i, o, u), otherwise
   *         evaluates to false.
   */
  public static boolean isVowel(Character c) {
    char ch = Character.toLowerCase(c);

    if (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u') {
      return true;
    }

    return false;
  }
}
