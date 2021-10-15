/*
    Assignment 1
    File: problem_11.cpp
    Author: Noah Gardner
    Date: 1/22/2020
    Description: 
        The purpose of this file is to implement the problem 11 page 25
*/

#include <string>
#include <cassert>
#include <iostream>
#include <cmath>
using namespace std;

class BigO
{
    public:
        BigO(int num);

        void number(int num);
        // number of digits in 2n
        int part_f();
        // number of times n can be divided by 10 before dropping below 1.0
        int part_g();

    private:
        int n;
};

BigO::BigO(int num)
{
    number(num);
}

void BigO::number(int num)
{
    n = num;
}

int BigO::part_f()
{
    int digits = 0;     // 1
    int num = 2*n;      // 1
    while (num != 0)    //(1*2n)/10
    {
        num = num / 10; //(1*2n)/10
        digits++;       //(1*2n)/10
    }

    return digits;      // 1
}

int BigO::part_g()
{
    int digits = 0;     // 1
    int num = n;        // 1
    // divide n by 10 until it drops below 1.0
    while (num > 1)     //(1*2n)/10 - 1
    {
        num = num / 10; //(1*2n)/10 - 1
        digits++;       //(1*2n)/10 - 1
    }

    return digits;      // 1
}

int main()
{
    int test_1_num = 5566;
    int test_2_num = 1000001;
    BigO test_1(test_1_num), test_2(test_2_num);

    cout << "Test 1: n = "; 
    cout << test_1_num << endl;
    cout << "Part F" << endl;
    cout << test_1.part_f() << endl;
    cout << "Part G" << endl;
    cout << test_1.part_g() << endl;

    cout << "Test 2: n = "; 
    cout << test_2_num << endl;
    cout << "Part F" << endl;
    cout << test_2.part_f() << endl;
    cout << "Part G" << endl;
    cout << test_2.part_g() << endl;

    return 0;
}