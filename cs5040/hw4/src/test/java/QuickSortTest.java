
import static org.junit.jupiter.api.Assertions.*;

import java.util.Random;
import org.junit.jupiter.api.Test;

class QuickSortTest {

  boolean isSorted(int[] arr) {
    for (int i = 0; i < arr.length - 2; i++) {
      if (arr[i] > arr[i + 1]) {
        return false;
      }
    }

    return true;
  }

  @Test
  void testSortA() {
    int[] toSort = {3, 2, 5, 6, 1};

    int[] sorted = QuickSort.quicksort(toSort, 0, toSort.length - 1);
    assertTrue(isSorted(sorted));
    assertEquals(toSort.length, sorted.length);
  }

  @Test
  void testSortB() {
    int[] toSort = {213, 3465, 7, 29, 541, 45};

    int[] sorted = QuickSort.quicksort(toSort, 0, toSort.length - 1);
    assertTrue(isSorted(sorted));
    assertEquals(toSort.length, sorted.length);
  }

  @Test
  void testSortRandom() {
    Random rd = new Random();
    int[] toSort = new int[100];

    for (int i = 0; i < toSort.length; i++) {
      toSort[i] = rd.nextInt();
    }

    int[] sorted = QuickSort.quicksort(toSort, 0, toSort.length - 1);
    assertTrue(isSorted(sorted));
    assertEquals(toSort.length, sorted.length);
  }
}