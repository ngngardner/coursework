
// Author: Noah Gardner
// Date: 2/26/2021
// File: Stack.java
// Class: CS 5040
// Instructor: Dr. Seokjun Lee
// Program Number: Assignment 3
// IDE: VS Code

public class Stack<E> {
  private Integer size = 0;
  private Node top = null;

  public class Node {
    E data;
    Node next;

    public Node(E element) {
      data = element;
      next = null;
    }

    public String toString() { return String.valueOf(this.data); }
  }

  public boolean isEmpty() { return (size == 0 || top == null); }

  public int size() { return size; }

  public E peek() {
    if (isEmpty()) {
      throw new java.lang.Error("Cannot peek empty stack.");
    }

    return top.data;
  }

  public E pop() {
    if (isEmpty()) {
      throw new java.lang.Error("Cannot pop from empty stack.");
    }

    Node temp = top;
    top = top.next;
    size = size - 1;
    return temp.data;
  }

  public E push(E element) {
    Node n = new Node(element);
    n.next = top;
    top = n;
    size = size + 1;
    return n.data;
  }

  public int search(E element) {
    if (isEmpty()) {
      throw new java.lang.Error("Cannot search empty stack.");
    }

    Node temp = top;
    if (temp.data == element) {
      return 0;
    }

    Integer i = 0;
    while (temp.next != null) {
      i = i + 1;
      temp = temp.next;
      if (temp.data == element) {
        return i;
      }
    }

    // failed to find
    return -1;
  }

  public String toString() {
    if (isEmpty()) {
      return "[]";
    }

    Node temp = top;
    StringBuilder str = new StringBuilder();
    str.append("[");
    while (temp.next != null) {
      str.append(temp.data);
      str.append(", ");
      temp = temp.next;
    }
    str.append(temp.data);
    str.append("]");
    return str.toString();
  }
}
