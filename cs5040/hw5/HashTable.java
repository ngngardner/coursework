
// Author: Noah Gardner
// Date: 4/24/2021
// File: HashTable.java
// Class: CS 5040
// Instructor: Dr. Seokjun Lee
// Program Number: Assignment 5
// IDE: VS Code

import java.util.*;

public class HashTable {
  private int[][] table = new int[50][2];

  public void HF1(int[] keys) {
    // Implements linear probing hash function

    for (int e = 0; e < 50; e++) {
      int key = keys[e];

      // initial index from hash
      int d = key % 50;

      // linear probe counter
      int i = 0;
      int h = d;

      while (true) {
        // found available spot, works for base case (no collision)
        if (table[h][0] == 0) {
          break;
        }

        // linear probe
        i += 1;
        h = d + i;

        if (h >= 50) {
          // circular array for index >= 50 (since array starts from 0)
          h = h % 50;
        }
      }

      // store value in table
      table[h][0] = key;

      // save probe for retrieval
      table[h][1] = i;
    }
  }

  public void HF2(int[] keys) {
    // Implements Quadratic probing hash function

    for (int e = 0; e < 50; e++) {
      int key = keys[e];

      // initial index from hash
      int d = key % 50;

      // quadratic probe counter
      int i = 0;
      int h = d;

      while (true) {
        // found available spot, works for base case (no collision)
        if (table[h][0] == 0) {
          break;
        }

        // quadratic probe
        i += 1;
        h = d + (i * i);

        if (h >= 50) {
          // circular array for index >= 50 (since array starts from 0)
          h = h % 50;
        }
      }

      // store value in table
      table[h][0] = key;

      // save probe for retrieval
      table[h][1] = i;
    }
  }

  public void HF3(int[] keys) {
    // Implements double hash function

    for (int e = 0; e < 50; e++) {
      int key = keys[e];

      // initial index from hash
      int d = key % 50;

      // double hash probe counter
      int i = 0;
      int h = d;

      while (true) {
        // found available spot, works for base case (no collision)
        if (table[h][0] == 0) {
          break;
        }

        // double hash
        i += 1;
        h = d + (i * (30 - d % 25));

        if (h >= 50) {
          // circular array for index >= 50 (since array starts from 0)
          h = h % 50;
        }

        // unable to determine empty index
        if (i >= 50) {
          System.out.print("Unable to store key " + key);
          System.out.println(" to the table.");
          break;
        }
      }

      if (i < 50) {
        // store value in table
        table[h][0] = key;

        // save probe for retrieval
        table[h][1] = i;
      }
    }
  }

  public void HF4(int[] keys) {
    // Implements custom hash function. My idea is to add the nth digit of
    // pi on each probe. However, there are only 15 digits in Math.PI, so
    // if n is greater than 15, then we find user linear probing
    // equal to d+n instead instead.

    for (int e = 0; e < 50; e++) {
      int key = keys[e];

      // initial index from hash
      int d = key % 50;

      // nth pi digit probe counter
      int i = 0;
      int h = d;

      while (true) {
        // found available spot, works for base case (no collision)
        if (table[h][0] == 0) {
          break;
        }

        // nth pi digit probe
        i += 1;
        h = d + nthDigit(i - 1);

        if (h >= 50) {
          // circular array for index >= 50 (since array starts from 0)
          h = h % 50;
        }
      }

      // store value in table
      table[h][0] = key;

      // save probe for retrieval
      table[h][1] = i;
    }
  }

  public int nthDigit(int i) {
    // ref:
    // https://stackoverflow.com/questions/52110905/how-to-calculate-only-nth-digit-of-pi/52118639

    String pi = String.valueOf(Math.PI).replace(".", "");

    // java double only has 15 digits
    if (i > 15) {
      return i;
    }

    char digit = pi.charAt(i);
    return digit;
  }

  public void resetTable() {
    // ref:
    // https://stackoverflow.com/questions/7118178/arrays-fill-with-multidimensional-array-in-java
    for (int[] row : table)
      Arrays.fill(row, 0);
  }

  public void printTable() {
    System.out.println("Index\t Key\t Probes\t");
    System.out.println("-----------------------");

    for (int e = 0; e < 50; e++) {
      System.out.print(e + "\t");
      System.out.print(table[e][0] + "\t");
      System.out.println(table[e][1] + "\t");
    }

    System.out.print("Sum of probe values = ");
    System.out.println(sumProbes() + " probes.");

    // fails wasn't part of the assignment but nice to have count next to probe
    // info
    System.out.println("Failed to insert " + sumFails() + " values.");
  }

  public int sumProbes() {
    int sum = 0;
    for (int e = 0; e < 50; e++) {
      sum += table[e][1];
    }
    return sum;
  }

  public int sumFails() {
    int fails = 0;
    for (int e = 0; e < 50; e++) {
      if (table[e][0] == 0) {
        fails += 1;
      }
    }
    return fails;
  }

  public static void main(String[] args) {
    Scanner s = new Scanner(System.in);
    HashTable h = new HashTable();

    int[] keys = {1234, 8234, 7867, 1009, 5438, 4312, 3420, 9487, 5418, 5299,
                  5078, 8239, 1208, 5098, 5195, 5329, 4543, 3344, 7698, 5412,
                  5567, 5672, 7934, 1254, 6091, 8732, 3095, 1975, 3843, 5589,
                  5439, 8907, 4097, 3096, 4310, 5298, 9156, 3895, 6673, 7871,
                  5787, 9289, 4553, 7822, 8755, 3398, 6774, 8289, 7665, 5523};

    while (true) {
      System.out.println("-----MAIN MENU-----");
      System.out.println("0 - Exit Program");
      System.out.println("1 – Run HF1 (Division with Linear Probing)");
      System.out.println("2 – Run HF2 (Division with Quadratic Probing)");
      System.out.println("3 – Run HF3 (Division with Double Hashing)");
      System.out.println("4 – Run HF4 (Student-Designed Function)");
      h.resetTable();

      String in = s.nextLine();
      if (in.equals("0")) {
        // exit
        System.out.println("Exiting program.");
        break;
      } else if (in.equals("1")) {
        // linear probe
        System.out.println("Hash table resulted from HF1:\n");
        h.HF1(keys);
        h.printTable();
      } else if (in.equals("2")) {
        // quadratic probe
        System.out.println("Hash table resulted from HF2:\n");
        h.HF2(keys);
        h.printTable();
      } else if (in.equals("3")) {
        // double hashing
        System.out.println("Hash table resulted from HF3:\n");
        h.HF3(keys);
        h.printTable();
      } else if (in.equals("4")) {
        // custom function
        System.out.println("Hash table resulted from HF4:\n");
        h.HF4(keys);
        h.printTable();
      } else {
        System.out.println("Invalid command.");
      }
    }
    s.close();
  }
}
