
// Author: Noah Gardner
// Date: 4/2/2021
// File: RadixSort.java
// Class: CS 5040
// Instructor: Dr. Seokjun Lee
// Program Number: Assignment 4
// IDE: VS Code

import java.util.*;

public class RadixSort {
  public static int[] radixsort(int[] arr) {
    int num = arr.length;

    // one bucket for each digit
    Queue<Integer> q0 = new Queue<>();
    Queue<Integer> q1 = new Queue<>();
    Queue<Integer> q2 = new Queue<>();
    Queue<Integer> q3 = new Queue<>();
    Queue<Integer> q4 = new Queue<>();
    Queue<Integer> q5 = new Queue<>();
    Queue<Integer> q6 = new Queue<>();
    Queue<Integer> q7 = new Queue<>();
    Queue<Integer> q8 = new Queue<>();
    Queue<Integer> q9 = new Queue<>();

    // sort array into buckets
    int radix = 1;
    while (true) {
      for (int i = 0; i < arr.length; i++) {
        int digit = extractDigit(arr[i], radix);
        switch (digit) {
        case 0:
          q0.enqueue(arr[i]);
          break;
        case 1:
          q1.enqueue(arr[i]);
          break;
        case 2:
          q2.enqueue(arr[i]);
          break;
        case 3:
          q3.enqueue(arr[i]);
          break;
        case 4:
          q4.enqueue(arr[i]);
          break;
        case 5:
          q5.enqueue(arr[i]);
          break;
        case 6:
          q6.enqueue(arr[i]);
          break;
        case 7:
          q7.enqueue(arr[i]);
          break;
        case 8:
          q8.enqueue(arr[i]);
          break;
        case 9:
          q9.enqueue(arr[i]);
          break;
        default:
          break;
        }
      }

      // break when bucket 0 has all of the values
      if (q0.Size() == num) {
        break;
      }

      // fill array back with buckets
      int idx = 0;
      idx = fillArray(arr, idx, q0);
      idx = fillArray(arr, idx, q1);
      idx = fillArray(arr, idx, q2);
      idx = fillArray(arr, idx, q3);
      idx = fillArray(arr, idx, q4);
      idx = fillArray(arr, idx, q5);
      idx = fillArray(arr, idx, q6);
      idx = fillArray(arr, idx, q7);
      idx = fillArray(arr, idx, q8);
      idx = fillArray(arr, idx, q9);

      // increment radix
      radix += 1;
    }

    // all the values are in q0, so refill array
    fillArray(arr, 0, q0);

    return arr;
  }

  // fill every value from arr[start] to arr[q.Size() -1], return index
  // where it left off
  public static int fillArray(int[] arr, int start, Queue<Integer> q) {
    int temp = start;
    while (q.Size() > 0) {
      arr[temp] = q.front();
      q.dequeue();
      temp += 1;
    }

    return temp;
  }

  // get the ith place digit from a
  public static int extractDigit(int a, int i) {
    if (a < Math.pow(10, (i - 1))) {
      return 0;
    }

    if (i == 1) {
      return a % 10;
    }

    int temp = a;

    for (int j = 0; j < i - 1; j++) {
      temp = temp - (temp % 10);
      temp = temp / 10;
    }

    return temp % 10;
  }

  public static boolean isSorted(int[] arr) {
    for (int i = 0; i < arr.length - 2; i++) {
      if (arr[i] > arr[i + 1]) {
        return false;
      }
    }

    return true;
  }

  public static void ui(Scanner s) {
    // user entry for numbers to sort
    System.out.print("How many integer numbers do you have?: ");
    int len = Integer.parseInt(s.nextLine());

    // user entry for array to sort
    System.out.print("Enter " + len + " integer numbers: ");
    String[] inputs = s.nextLine().split(" ");
    if (inputs.length < len) {
      throw new java.lang.Error("Not enough values.");
    }

    // parse result into array
    int[] arr = new int[len];
    for (int i = 0; i < len; i++) {
      arr[i] = Integer.parseInt(inputs[i]);
    }

    // sort and show output
    String presort = Arrays.toString(arr);
    int[] sorted = radixsort(arr);
    System.out.println(
        "------------------------------------------------------");
    System.out.print("Inputs array before sorting (radix): ");
    System.out.println(presort);
    System.out.print("Inputs array after sorting (radix): ");
    System.out.println(Arrays.toString(sorted));
  }

  public static void main(String[] args) {
    Scanner s = new Scanner(System.in);

    // user entry
    ui(s);

    while (true) {
      System.out.println(
          "Do you want to re-run code with different inputs (Y/N)?");
      String in = s.nextLine();
      if (in.equals("N")) {
        System.out.println("Exiting program.");
        break;
      } else if (in.equals("Y")) {
        ui(s);
      } else {
        System.out.println("Invalid command.");
      }
    }
    s.close();
  }
}