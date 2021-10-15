
/**
 * Author: Noah Gardner
 * Date: 1/29/2021
 * File: StarPattern.java
 * Class: CS 5040
 * Instructor: Dr. Seokjun Lee
 * Program Number: Assignment 1 Programming 1
 * IDE: VS Code
 */

import java.util.Scanner;

public class StarPattern {

  /**
   *
   * @param args
   *
   *             The purpose of this class is to create a pyramid pattern of
   * stars based on the number of rows input by the user.
   */
  public static void main(String[] args) {
    // scanner input for number of rows to print in pattern
    Scanner s = new Scanner(System.in);
    System.out.print("Enter Number Of Rows : ");
    Integer rows = s.nextInt();
    s.close();

    printStars(rows, 0);
  }

  /**
   *
   * @param k
   * @param j
   *
   *          In the base case where @k=1, print stars equal to 2*(@j+1)-1.
   *          Otherwise, print 2*(@k-1) spaces and 2*(@j+1)-1 stars. Then,
   *          recursively call the function with @k-1 and @j+1 until base case
   * is met.
   */
  public static void printStars(Integer k, Integer j) {
    if (k > 1) {
      printSymbols(" ", 2 * (k - 1));
      printSymbols(" *", 2 * (j + 1) - 1);
      System.out.println();
      printStars(k - 1, j + 1);
    } else {
      printSymbols(" *", 2 * (j + 1) - 1);
      System.out.println();
    }
  }

  /**
   *
   * @param p
   * @param n
   *
   *          Print string @p @n times recursively. Base case @n=0, do nothing.
   */
  public static void printSymbols(String p, Integer n) {
    if (n > 0) {
      System.out.print(p);
      printSymbols(p, n - 1);
    }
  }
}
