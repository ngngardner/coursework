
/*
    File: problem_3.cpp
    Author: Noah Gardner
    Date: 3/1/2020
    Description: 
        The purpose of this file is to implement project 8 page 390 in the text
*/
#include <iostream>
#include <cstdlib>
#include <string.h>
#include <stdio.h>
#include <bits/stdc++.h>

using namespace std;

class stack_postfix
{
    public:
        stack_postfix(int size);
        void push(int input);
        int pop();
        int peek();

        bool is_empty();
        bool is_full();
        bool is_operation(char input);
        bool is_digit(char input);
        void evaluate(string input);
        void output();

    private:
        int *arr;
        int top;
        int capacity;
        string equation;
};

stack_postfix::stack_postfix(int size)
{
    top = -1;
    capacity = size;
    arr = new int[size];
}

void stack_postfix::push(int input)
{
    if (!is_full())
    {
        cout << "Inserting: " << input << "\n";
        arr[++top] = input;
    }
    else
    {
        cout << "Error: overflow." << "\n";
        exit(EXIT_FAILURE);
    }
}

int stack_postfix::pop()
{
    if(!is_empty())
    {
        cout << "Removing: " << peek() << "\n";
        return arr[top--];
    }
    else
    {
        cout << "Error: underflow," << "\n";
    }
}

int stack_postfix::peek()
{
    if(!is_empty())
    {
        return arr[top];
    }
    else
    {
        return -1;
    }
}

bool stack_postfix::is_empty()
{
    return (top == -1);
}

bool stack_postfix::is_full()
{
    return (top == capacity-1);
}

bool stack_postfix::is_operation(char input)
{
    if(input == '+' || input == '-' || input == '*' || input == '/' )
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool stack_postfix::is_digit(char input)
{
    if (input >= '0' && input <= '9')
    {
        return true;
    }
    else
    {
        return false;
    }
}

void stack_postfix::evaluate(string input)
{
    int a, b, y;
    equation = input;

    for (int i=0; input[i]; i++)
    {
        if (input[i] == ' ')
            continue;
        else if (is_digit(input[i]))
        {
            int to_postfix = 0;
            while (i < capacity && is_digit(input[i]))
            {
                to_postfix = (to_postfix*10) + (input[i] - '0');
                i++;
            }
            i--;
            push(to_postfix);
        }
        else if (is_operation(input[i]))
        {
            b = pop();
            a = pop();
            switch(input[i])
            {
                case('+'):
                    y = a + b;
                    push(y);
                    break;
                case('-'):
                    y = a - b;
                    push(y);
                    break;
                case('*'):
                    y = a * b;
                    push(y);
                    break;
                case('/'):
                    y = a / b;
                    push(y);
                    break;
            }
        }
    }
}

void stack_postfix::output()
{
    cout << "Answer = " << peek() << "\n";
}

string get_input()
{
    string input;
    cout << "Enter values separated by spaces:" << "\n";
    cout << "To quit, type q:" << "\n";
    getline(cin, input);
    return input;
}

int main()
{
    string s;
    while (s != "q")
    {
        s = get_input();
        stack_postfix t1(s.length());
        t1.evaluate(s);
        t1.output();
    }
    return 0;
}