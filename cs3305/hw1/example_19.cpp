/*
    Assignment 1
    File: example_19.cpp
    Author: Noah Gardner
    Date: 1/22/2020
    Description: 
        The purpose of this file is to implement the example 19 page 95
*/

#include <string>
#include <cassert>
#include <iostream>
#include <cmath>

using namespace std;

/*
    The class complex uses integers to store the real and imaginary parts of
    a complex number in the form a+bi. It can output it's values, and compute
    sums and products with other complex numbers
*/
class Complex
{
    public:
        int real;
        int imaginary;

        // CONSTRUCTORS
        Complex(int a, int b);
        
        // MEMBER FUNCTIONS
        // update the real and imaginary parts
        void update(int a, int b);
        // update real part
        void update_real(int a);
        // update imaginary part
        void update_imaginary(int b);
        // output the complex number
        void output();
        // calculate the sum of this and another complex number 
        // and store it in this complex number
        void sum(Complex c1);
        // calculate the product of this and another complex number 
        // and store it in this complex number
        void mult(Complex c1);  
};

Complex::Complex(int a, int b)
{
    real = a;
    imaginary = b;
}

void Complex::update(int a, int b)
{
    update_real(a);
    update_imaginary(b);
}

void Complex::update_real(int a)
{
    real = a;
}

void Complex::update_imaginary(int b)
{
    imaginary = b;
}

void Complex::output()
{
    if (real < 0)
    {
        cout << "-" << real;
    }
    else
    {
        cout << real;
    }

    if (imaginary > 0)
    {
        cout << "+" << imaginary << "i" << endl;
    }
    else
    {
        cout << imaginary << "i" << endl;
    }
}

void Complex::sum(Complex c1)
{
    real = real + c1.real;
    imaginary = imaginary + c1.imaginary;
}

void Complex::mult(Complex c1)
{
    real = real*c1.real;
    imaginary = imaginary*c1.imaginary;
}

int main()
{
    Complex test_1(3, -5), test_2(4, 7), test_3(2, 2);

    test_1.output();
    test_2.output();

    test_1.sum(test_2);
    test_1.output();

    test_3.output();
    test_3.mult(test_1);
    test_3.output();
    return 0;
}