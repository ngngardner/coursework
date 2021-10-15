
/**
 * Author: Noah Gardner
 * Date: 2/12/2021
 * File: LinkedList.java
 * Class: CS 5040
 * Instructor: Dr. Seokjun Lee
 * Program Number: Assignment 2
 * IDE: VS Code
 */

import java.util.Scanner;

public class LinkedList<E> {
  private Node head = null;
  private Node tail = null;

  public class Node {
    E data;
    Node next;

    public Node(E element) {
      data = element;
      next = null;
    }

    // convert node value to string
    public String toString() { return String.valueOf(this.data); }
  }

  public static void main(String[] args) {
    LinkedListGardner<String> l = new LinkedListGardner<>();
    System.out.println("__-Linked List Program-__\n");
    Scanner s = new Scanner(System.in);

    while (true) {
      System.out.println("Enter a command:");
      System.out.println("0: Exit the program.");
      System.out.println("1: Add a value at a specified index.");
      System.out.println("2: Add a value to the front of the list.");
      System.out.println("3: Add a value to the end of the list.");
      System.out.println("4: Remove the value at a specified index.");
      System.out.println("5: Remove the value from the front of the list.");
      System.out.println("6: Remove the value from the end of the list.");
      System.out.println("7: Display list size.");
      String in = s.nextLine();

      System.out.println("\nStatus before operation:");
      System.out.println(l.toString() + "\n");

      if (in.equals("0")) {
        break;
      } else if (in.equals("1")) {
        // add at index
        System.out.println("Testing method add().");
        System.out.print("Enter value to add: ");
        String v = s.nextLine();

        System.out.print("Enter index to insert at: ");
        int i = s.nextInt();

        l.add(i, v);
      } else if (in.equals("2")) {
        // add first
        System.out.println("Testing method addFirst().");
        System.out.print("Enter value to add: ");
        String v = s.nextLine();

        l.addFirst(v);
      } else if (in.equals("3")) {
        // add last
        System.out.println("Testing method addLast().");
        System.out.print("Enter value to add: ");
        String v = s.nextLine();

        l.addLast(v);
      } else if (in.equals("4")) {
        // remove at
        if (l.size() == 0) {
          System.out.println("List is empty.");
        } else {
          System.out.println("Testing method remove().");
          System.out.print("Enter index to remove: ");
          int r = s.nextInt();
          l.remove(r);
          System.out.println("Removed.");
        }
      } else if (in.equals("5")) {
        // remove first
        if (l.size() == 0) {
          System.out.println("List is empty.");
        } else {
          System.out.println("Testing method removeFirst().");
          System.out.print("Removed: ");
          System.out.println(l.removeFirst());
        }
      } else if (in.equals("6")) {
        // remove last
        if (l.size() == 0) {
          System.out.println("List is empty.");
        } else {
          System.out.println("Testing method removeLast().");
          System.out.print("Removed: ");
          System.out.println(l.removeLast());
        }
      } else if (in.equals("7")) {
        // size
        System.out.println("Testing method size().");
        System.out.print("Size: ");
        System.out.println(l.size());
      }

      System.out.println("\nStatus after operation:");
      System.out.println(l.toString() + "\n");
    }
    s.close();
  }

  public void add(int index, E element) {
    // add a value at a specified index
    int s = size();
    if (index == 0) {
      addFirst(element);
      return;
    } else if (index == s) {
      addLast(element);
      return;
    } else if (index > s - 1) {
      throw new ArrayIndexOutOfBoundsException();
    }

    Node temp = head;
    int i = 1;
    while (temp.next != null) {
      if (i == index) {
        break;
      }
      temp = temp.next;
      i += 1;
    }

    // place node n between temp and temp.next
    Node n = new Node(element);
    n.next = temp.next;
    temp.next = n;

    if (tail == null) {
      // sets the last element in the linked list as the tail
      Node t = head;
      while (t.next != null) {
        t = t.next;
      }
      tail = t;
    }
  }

  public void addFirst(E element) {
    // add a value at the front of the list
    Node n = new Node(element);
    n.next = head;
    head = n;

    if (tail == null) {
      // sets the last element in the linked list as the tail
      Node t = head;
      while (t.next != null) {
        t = t.next;
      }
      tail = t;
    }
  }

  public void addLast(E element) {
    // add a value at the end of the list
    Node temp = head;
    Node n = new Node(element);
    while (temp.next != null) {
      temp = temp.next;
    }
    temp.next = n;
    tail = n;
  }

  public E getFirst() {
    // return the value of first node
    return head.data;
  }

  public E getLast() {
    // return the value of last node
    return tail.data;
  }

  public void remove(int index) {
    // remove the value at a specified index
    int s = size();
    if (s == 0) {
      // do nothing
    } else if (index == 0) {
      removeFirst();
      return;
    } else if (index == s - 1) {
      removeLast();
      return;
    } else if (index > s - 1) {
      throw new ArrayIndexOutOfBoundsException();
    }

    Node temp = head;
    Node prev = temp;
    int i = 0;
    while (temp.next != null) {
      if (i == index) {
        break;
      }
      prev = temp;
      temp = temp.next;
      i += 1;
    }

    prev.next = temp.next;
  }

  public E removeFirst() {
    // removes the value at the front of the list
    // and returns that value
    if (head == null) {
      return null;
    }

    E res = head.data;
    head = head.next;
    return res;
  }

  public E removeLast() {
    // removes the value at the end of the list
    // and returns that value
    if (head == null) {
      return null;
    }

    Node temp = head;
    if (head == tail) {
      return removeFirst();
    }

    while (temp.next != tail) {
      temp = temp.next;
    }

    E res = tail.data;
    temp.next = null;
    tail = temp;

    return res;
  }

  public int size() {
    // return number of elements stored in the linked list
    if (head == null) {
      return 0;
    }

    Node temp = head;
    int s = 1;
    while (temp.next != null) {
      s += 1;
      temp = temp.next;
    }
    return s;
  }

  public String toString() {
    // function for printing the values in the linked list
    Node temp = head;
    String str = "[";
    if (size() > 0) {
      while (temp.next != null) {
        str = str + temp.data + ", ";
        temp = temp.next;
      }
      str = str + temp.data;
    }
    return str + "]";
  }
}
