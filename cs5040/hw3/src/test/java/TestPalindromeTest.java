
import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

class TestPalindromeTest {
  @Test
  void testIsPalindrome() {
    TestPalindrome tester = new TestPalindrome();

    List<String> tests = new ArrayList<>();
    tests.add("Race car");
    tests.add("E");
    tests.add("Red rum, sir, is murder");
    tests.add("Eva, can I see bees in a cave?");
    tests.add("No lemon, no melon");

    for (int i = 0; i < tests.size(); i++) {
      assertTrue(tester.isPalindrome(tests.get(i)));
    }
  }

  @Test
  void testNotPalindrome() {
    TestPalindrome tester = new TestPalindrome();

    List<String> tests = new ArrayList<>();
    tests.add("Race care");
    tests.add("Hello world!");
    tests.add("Testing");
    tests.add("Not a palindrome...");

    for (int i = 0; i < tests.size(); i++) {
      assertFalse(tester.isPalindrome(tests.get(i)));
    }
  }
}
