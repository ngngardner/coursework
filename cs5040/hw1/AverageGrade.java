
/**
 * Author: Noah Gardner
 * Date: 1/28/2021
 * File: AverageGrade.java
 * Class: CS 5040
 * Instructor: Dr. Seokjun Lee
 * Program Number: Assignment 1 Programming 3
 * IDE: VS Code
 */

import java.util.Arrays;
import java.util.Scanner;

public class AverageGrade {

  /**
   *
   * @param args
   *
   *             The purpose of this class is to calculate the average in a user
   *             input array of class grades.
   */
  public static void main(String[] args) {
    System.out.println(
        "Enter class grades to calculate the average (0 to exit).");
    Scanner s = new Scanner(System.in);

    while (true) {
      // scanner input for number of rows to print in pattern
      System.out.print("Class size:       ");
      Integer size = s.nextInt();
      s.nextLine();

      if (size == 0) {
        break;
      }

      Integer[] grades = new Integer[size];

      System.out.print("Entered grades: ");

      for (int i = 0; i < size; i++)
        grades[i] = s.nextInt();
      s.nextLine();

      Double avg = average(grades, size);

      System.out.print("Class average:      ");
      System.out.printf("%.2f", avg);
      System.out.println();
      System.out.println();
    }

    s.close();
  }

  /**
   *
   * @param g
   * @param l
   * @return
   *
   *         Recursively calculates the average of array @g of length @l. In the
   *         base case, if @l=1, then return the first value of the array @g.
   *         Otherwise, return the last value of the array @g plus @l-1
   * multiplied by the recursive call of the subarray excluding the last element
   * of the array all divided by @l.
   */
  public static double average(Integer[] g, Integer l) {
    if (l > 1) {
      return (g[l - 1] +
              (l - 1) * average(Arrays.copyOfRange(g, 0, l - 1), l - 1)) /
          l;
    } else {
      return g[0];
    }
  }
}
