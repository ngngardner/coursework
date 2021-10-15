
/*
    File: lab8.cpp
    Author: Noah Gardner
    Date: 3/5/2020
    Description: 
        The purpose of this file is to implement the
        main function described in lab 8. This main function
        tests the bag<Item>::print_value_range and the 
        bag<Item>::remove_repetitions functions described
        in the lab 8 assignment. I implemented these functions
        in the bag5.h file with inline member functions.
*/
#include <cstdlib>
#include <iostream>
#include "bag5.h"

using namespace std;

int main()
{
    bag<int> b1;

    int items1_size = 7;
    int items1[items1_size] = {1,2,3,4,5,6,7};
    for (int i=items1_size-1; i>=0; --i)
    {
        b1.insert(items1[i]);
    }

    // expected output: 2 3 4 
    b1.print_value_range(2, 5);
    // expected output: 2 3 4 5 6 7 
    b1.print_value_range(2, 78);
    // expected output: 2 3 4 5 6 7 
    b1.print_value_range(2, 1);
    // expected output: 
    b1.print_value_range(8, 5);

    bag<int> b2;

    int items2_size = 10;
    int items2[items2_size] = {1,2,2,2,5,5,7,8,9,10};
    for (int i=items2_size; i>=0; --i)
    {
        b2.insert(items2[i]);
    }
    // expected output: 1 2 2 2 5 5 7 8 9 
    b2.print_value_range(1,10);
    b2.remove_repetitions();
    // expected output: 1 2 5 7 8 9
    b2.print_value_range(1,10);

    return 0;
}