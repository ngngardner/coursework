/*
    Assignment 1
    File: problem_16.cpp
    Author: Noah Gardner
    Date: 1/22/2020
    Description: 
        The purpose of this file is to implement the problem 16 page 26
*/

#include <string>
#include <cassert>
#include <iostream>
#include <cmath>
using namespace std;

class SumToN
{
    public:
        SumToN();

        int compute(int n);
};

SumToN::SumToN()
{}

int SumToN::compute(int n)
{
    int sum = 0;                // 1
    for (int i=1; i<=n; i++)    // 2(n-1) + 2
    {
        sum += i;               // (n-1)
    }
    return sum;                 // 1

    // time analysis
    // 3n+1
}

int main()
{
    SumToN test_1;

    cout << "Sum to 5" << endl;
    cout << test_1.compute(5) << endl;
    cout << "Sum to 9" << endl;
    cout << test_1.compute(9) << endl; 

    return 0;
}