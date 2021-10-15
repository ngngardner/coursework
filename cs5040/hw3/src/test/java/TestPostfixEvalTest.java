
import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

class TestPostfixEvalTest {
  @Test
  void testPostfix() {
    PostfixEval tester = new PostfixEval();

    List<String> tests = new ArrayList<>();
    tests.add("562^2-*");
    tests.add("532*+1+");

    List<Integer> results = new ArrayList<>();
    results.add(170);
    results.add(12);

    for (int i = 0; i < tests.size(); i++) {
      assertEquals(results.get(i), tester.evaluate(tests.get(i)));
    }
  }

  @Test
  void testPostfixError() {
    PostfixEval tester = new PostfixEval();

    List<String> tests = new ArrayList<>();
    tests.add("562^2-");
    tests.add("532*+1");

    for (int i = 0; i < tests.size(); i++) {
      Throwable e = null;

      try {
        tester.evaluate(tests.get(i));
      } catch (Throwable ex) {
        e = ex;
      }

      assertEquals(java.lang.Error.class, e.getClass());
    }
  }
}
