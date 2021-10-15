
// Author: Noah Gardner
// Date: 4/2/2021
// File: QuickSort.java
// Class: CS 5040
// Instructor: Dr. Seokjun Lee
// Program Number: Assignment 4
// IDE: VS Code

import java.util.*;

public class QuickSort {
  public static int[] quicksort(int[] arr, int low, int high) {
    if (low < high) {
      int idx = partition(arr, low, high);

      quicksort(arr, low, idx - 1);
      quicksort(arr, idx + 1, high);
    }
    return arr;
  }

  public static int partition(int[] arr, int low, int high) {
    // set first value in partition as pivot
    int pivot = arr[low];

    // select left index
    int left = low + 1;

    // end loop when high is to the left of @left
    while (left <= high) {
      if (arr[high] < arr[left]) {
        // swap the values in left and high
        int temp = arr[high];
        arr[high] = arr[left];
        arr[left] = temp;
      } else if (arr[left] <= pivot) {
        // move left one space to the right
        left += 1;
      } else if (arr[high] > pivot) {
        // move high one space to the left
        high -= 1;
      }
    }

    // swap the values of pivot and high, pivot is in the correct space
    int temp = arr[high];
    arr[high] = pivot;
    arr[low] = temp;

    return high;
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
    int[] sorted = quicksort(arr, 0, len - 1);
    System.out.println(
        "------------------------------------------------------");
    System.out.print("Inputs array before sorting (quick): ");
    System.out.println(presort);
    System.out.print("Inputs array after sorting (quick): ");
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