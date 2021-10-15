// This class defines a Queue

public class Queue<E> {
   public Node head, tail;

   // constructor method to create a list of object with head, tail, and size.
   public Queue() {
      head = null;
      tail = null;
   }

   // method add node to end of list
   public void addLastNode(E data) {
      if (tail == null)
         head = tail = new Node(data); // empty list
      else {
         tail.next = new Node(data); // link new node as last node
         tail = tail.next; // make tail pointer points to last node
      }
   }

   // Method for enqueue (same as addlast for linked list)
   public void enqueue(E data) {
      int size = Size();
      Node NewNode;
      NewNode = new Node(data);
      if (tail == null) // case for if our Queue is empty
         head = tail = new Node(data);
      else {
         tail.next = new Node(data);
         tail = tail.next;
      }
      size++;
   }

   // Method for dequeue (same as removefirst for linked list)
   public void dequeue() {
      int size = Size();
      Node temp;

      if (size == 0) {
         System.out.println("ERROR QUEUE IS EMPTY!!!!");
      }

      else if (size == 1) // if our stack only has one element
      {
         temp = head;
         head = tail = null;
         size = 0;
      } else {
         Node C; // Create new node
         C = head; // Link Node C point to head
         head = head.next; // Make the head point to the 2nd node
      }
   }

   // Method for size, counts and gives us the number of elements (nodes) in our
   // Queue
   public int Size() {
      Node Current3;
      int size = 0; // Create int variable to store the number of nodes
      Current3 = head; // Set current node to the head
      while (Current3 != null) // While the Current node doesn't equal null move forward node by node counting
                               // each node as you pass them by
      {
         size = size + 1;
         Current3 = Current3.next;
      }
      return size; // Return the number of elements (leave method useful for when we want to
                   // remove/add at an index >= Count)
   }

   // Method for front, looks at the 1st element of the Queue and returns that
   // element
   public E front() {
      E X;
      if (isEmpty() == false)
         X = (E) head.data;
      else
         X = null;
      return X; // return the element that is at the head

   }

   // Method for isEmpty(), checks to see if the list is empty
   public boolean isEmpty() {
      int size = Size();
      if (size == 0)
         return true;
      else
         return false;
   }

   // ============end of methods=============================

   // method to print out the Queue
   public void printQueue() {
      Node temp;
      temp = head;
      while (temp != null) {
         System.out.print(temp.data + "   ");
         temp = temp.next;
      }
   }

   // class to create nodes as objects
   private class Node<E> {
      private E data; // data field
      private Node next; // link field

      public Node(E item) // constructor method
      {
         data = item;
         next = null;
      }
   }
}
