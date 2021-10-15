
// Author: Noah Gardner
// Date: 2/26/2021
// File: PostfixEval.java
// Class: CS 5040
// Instructor: Dr. Seokjun Lee
// Program Number: Assignment 3
// IDE: VS Code

import java.util.Scanner;
import java.util.regex.Pattern;

public class PostfixEval {
  public int evaluate(String s) {
    Stack<Integer> stack = new Stack<>();

    for (int i = 0; i < s.length(); i++) {
      char c = s.charAt(i);
      if (Pattern.matches("[0-9]", Character.toString(c))) {
        // c is integer, so push to stack
        int p = Integer.parseInt(Character.toString(c));
        stack.push(p);
      } else if (Pattern.matches("[\\*\\+\\x2D\\/\\^]",
                                 Character.toString(c))) {
        // c is operation, so attempt operation
        int b = stack.pop();
        int a = stack.pop();

        if (c == '^') {
          stack.push((int)Math.pow(a, b));
        } else if (c == '+') {
          stack.push(a + b);
        } else if (c == '-') {
          stack.push(a - b);
        } else if (c == '*') {
          stack.push(a * b);
        } else if (c == '/') {
          stack.push(a / b);
        }
      } else {
        // unrecognized character
        throw new java.lang.Error("Invalid operation.");
      }
    }

    if (stack.size() != 1) {
      throw new java.lang.Error("Invalid postfix notation.");
    }

    return stack.pop();
  }

  public static void main(String[] args) {
    PostfixEval t = new PostfixEval();
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

      // evaluate
      System.out.print("Result value: ");
      try {
        System.out.println(t.evaluate(in));
      } catch (Throwable e) {
        System.out.println("The input Postfix expression is not valid.");
      }
      System.out.println();
    }
    s.close();
  }
}
