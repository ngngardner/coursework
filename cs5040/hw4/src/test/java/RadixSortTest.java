
import static org.junit.jupiter.api.Assertions.*;

import java.util.Random;
import org.junit.jupiter.api.Test;

public class RadixSortTest {

  boolean isSorted(int[] arr) {
    for (int i = 0; i < arr.length - 2; i++) {
      if (arr[i] > arr[i + 1]) {
        return false;
      }
    }

    return true;
  }

  @Test
  void testExtractDigit() {
    assertEquals(5, RadixSort.extractDigit(5, 1));
    assertEquals(0, RadixSort.extractDigit(5, 2));
    assertEquals(0, RadixSort.extractDigit(5, 3));

    assertEquals(3, RadixSort.extractDigit(193, 1));
    assertEquals(9, RadixSort.extractDigit(193, 2));
    assertEquals(1, RadixSort.extractDigit(193, 3));
  }

  @Test
  void testSortA() {
    int[] toSort = {3, 2, 5, 6, 1};

    int[] sorted = RadixSort.radixsort(toSort);
    assertTrue(isSorted(sorted));
    assertEquals(toSort.length, sorted.length);
  }

  @Test
  void testSortRandom() {
    Random rd = new Random();
    int[] toSort = new int[100];

    for (int i = 0; i < toSort.length; i++) {
      toSort[i] = Math.abs(rd.nextInt());
    }

    int[] sorted = RadixSort.radixsort(toSort);
    System.out.println(sorted.toString());
    assertTrue(isSorted(sorted));
    assertEquals(toSort.length, sorted.length);
  }
}
