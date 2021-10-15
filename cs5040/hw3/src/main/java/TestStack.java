
// Author: Noah Gardner
// Date: 2/26/2021
// File: TestStack.java
// Class: CS 5040
// Instructor: Dr. Seokjun Lee
// Program Number: Assignment 3
// IDE: VS Code

import java.util.Scanner;

public class TestStack {

  public static void main(String[] args) {
    Stack<Integer> stack = new Stack<>();
    System.out.println("__-Stack Program-__\n");
    Scanner s = new Scanner(System.in);

    while (true) {
      System.out.println("-----MAIN MENU-----");
      System.out.println("0 - Exit Program");
      System.out.println("1 - Push");
      System.out.println("2 - Pop");
      System.out.println("3 – Peek (Top)");
      System.out.println("4 - Size");
      System.out.println("5 – Is Empty?");
      System.out.println("6 - Print Stack");
      System.out.println("7 - Search");
      Integer in = s.nextInt();

      if (in.equals(0)) {
        System.out.println("Exiting program.");
        break;
      } else if (in.equals(6)) {
        // print stack
        System.out.println("Printing stack:");
        System.out.println(stack.toString() + "\n");
      } else {
        System.out.println("\nStatus before operation:");
        System.out.println(stack.toString() + "\n");
        if (in.equals(1)) {
          // push
          System.out.println("Testing method push().");
          System.out.print("Enter integer to push: ");

          Integer v = s.nextInt();

          stack.push(v);
        } else if (in.equals(2)) {
          // pop
          System.out.println("Testing method pop().");

          Integer v = stack.pop();

          System.out.print("Value popped: ");
          System.out.println(v);
        } else if (in.equals(3)) {
          // peek
          System.out.println("Testing method peek().");

          Integer v = stack.peek();

          System.out.print("Value peeked: ");
          System.out.println(v);
        } else if (in.equals(4)) {
          // size
          System.out.println("Testing method size().");

          Integer v = stack.size();

          System.out.print("Size of the stack: ");
          System.out.println(v);
        } else if (in.equals(5)) {
          // is empty
          System.out.println("Testing method isEmpty().");

          if (stack.isEmpty()) {
            System.out.println("Stack is empty.");
          } else {
            System.out.println("Stack is not empty.");
          }

        } else if (in.equals(7)) {
          // search stack
          System.out.print("Enter integer to search for: ");

          Integer v = s.nextInt();

          int res = stack.search(v);
          if (res == -1) {
            System.out.println("Failed to find value.");
          } else {
            System.out.print("Value found at index ");
            System.out.println(res + ".");
          }
        }

        System.out.println("\nStatus after operation:");
        System.out.println(stack.toString() + "\n");
      }
    }
    s.close();
  }
}
