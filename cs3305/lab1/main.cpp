/*
    File: main.cpp
    Author: Noah Gardner
    Date: 1/7/2020
    Description: 
        The purpose of this file is to implement the three exercises for lab 1.
        The first exercise will print some personal information.
        The second exercise implements a simple algorithm.
        The third exercise uses a nested loop to copy a specified output.
*/
#include<iostream>
using namespace std;

/*
    Exercise 1, which displays some personal information
*/
void f1()
{
    cout << "Name: Noah Gardner\n";
    cout << "Phone: xx\n";
    cout << "Email: ngardn10@students.kennesaw.edu\n";
    cout << "Hometown: Lawrenceville, GA\n";
    cout << "Major: Computer Engineering\n";
    cout << "High School: Gwinnett School of Math, Science, and Technology\n";
    cout << "Maths: Algebra through Calculus 3, Probability and Statistics,\n";
    cout << "Numerical Methods, Differential Equations\n";
    cout << "CS: C++ for Engineers, Machine Learning (audit)\n";
    cout << "My last CS course was Machine Learning CS7267 with Dr. Hung.\n";
}

/*
    Exercise 2, accepts a positive integer n, 
    displays the sum of the n integers starting from 1
    and incrementing by 1
*/
int f2(int n)
{
    int sum = 0;   
    // loop through each
    for (int i=1; i<=n; i++)
    {
        sum = sum + i;
    }
    return sum;
}

void f3()
{
    for (int i=8; i>=0; i-=2)
    {
        for (int j=i; j>=0; j-=2)
        {
            cout << j;
            cout << " ";
        }
        cout << "\n";
    }
}

int main()
{   
    // exercise 1, introduction
    cout << "Exercise 1 \n";
    f1();
    cout << "\n\n";

    // exercise 2, sum of n integers
    int n; // integer to hold input
    cout << "Exercise 2 \n";
    cout << "Enter a positive integer: ";
    cin >> n; // store user input

    // n must be positive integer
    if (n > 0)
    {
        cout << "The sum is ";
        cout << f2(n);
        cout << "\n";
    }
    else
    {
        cout << "Error";
    }
    cout << "\n\n";
    
    // exercise 3
    cout << "Exercise 3 \n";
    f3();
    return 0;
}
