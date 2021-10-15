
import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class StackTest {

  @Test
  void testToStringS() {
    Stack<String> tester = new Stack<>();

    tester.push("a");
    tester.push("b");
    tester.push("c");
    tester.push("d");

    assertEquals("[d, c, b, a]", tester.toString());
  }

  @Test
  void testToStringI() {
    Stack<Integer> tester = new Stack<>();

    tester.push(1);
    tester.push(2);
    tester.push(3);
    tester.push(4);

    assertEquals("[4, 3, 2, 1]", tester.toString());
  }

  @Test
  void testEmpty() {
    Stack<String> tester = new Stack<>();

    assertTrue(tester.isEmpty());

    tester.push("a");

    assertFalse(tester.isEmpty());
  }

  @Test
  void testPopEmpty() {
    Stack<String> tester = new Stack<>();
    Throwable e = null;

    try {
      tester.pop();
    } catch (Throwable ex) {
      e = ex;
    }

    assertEquals(java.lang.Error.class, e.getClass());
  }

  @Test
  void testPopS() {
    Stack<String> tester = new Stack<>();

    tester.push("a");

    assertEquals("a", tester.pop());
    assertTrue(tester.isEmpty());
  }

  @Test
  void testPopI() {
    Stack<Integer> tester = new Stack<>();

    tester.push(1);

    assertEquals(1, tester.pop());
    assertTrue(tester.isEmpty());
  }

  @Test
  void testPeekEmpty() {
    Stack<String> tester = new Stack<>();
    Throwable e = null;

    try {
      tester.peek();
    } catch (Throwable ex) {
      e = ex;
    }

    assertEquals(java.lang.Error.class, e.getClass());
  }

  @Test
  void testPeekS() {
    Stack<String> tester = new Stack<>();

    tester.push("a");

    assertEquals("a", tester.peek());
    assertFalse(tester.isEmpty());
  }

  @Test
  void testPeekI() {
    Stack<Integer> tester = new Stack<>();

    tester.push(1);

    assertEquals(1, tester.peek());
    assertFalse(tester.isEmpty());
  }

  @Test
  void testSearchP() {
    Stack<String> tester = new Stack<>();

    tester.push("a");
    assertEquals(0, tester.search("a"));

    tester.push("b");
    assertEquals(0, tester.search("b"));
    assertEquals(1, tester.search("a"));
  }

  @Test
  void testSearchI() {
    Stack<Integer> tester = new Stack<>();

    tester.push(1);
    assertEquals(0, tester.search(1));

    tester.push(2);
    assertEquals(0, tester.search(2));
    assertEquals(1, tester.search(1));
  }

  @Test
  void testSearchEmpty() {
    Stack<String> tester = new Stack<>();
    Throwable e = null;

    try {
      tester.search("a");
    } catch (Throwable ex) {
      e = ex;
    }

    assertEquals(java.lang.Error.class, e.getClass());
  }
}
