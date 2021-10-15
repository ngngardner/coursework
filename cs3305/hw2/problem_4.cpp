
/*
    File: problem_4.cpp
    Author: Noah Gardner
    Date: 3/1/2020
    Description: 
        The purpose of this file is to implement project 12 page 390 in the text
*/
#include <iostream>
#include <cstdlib>
#include <string.h>
#include <stdio.h>

using namespace std;

class my_stack
{
    public:
        my_stack(int size);
        void push(int input);
        int pop();
        int peek();

        bool is_empty();
        bool is_full();
        bool is_digit(char input);
        void evaluate(string input);
        void output();
        
        friend void top_to_bottom(my_stack input);
        friend void bottom_to_top(my_stack input);

    private:
        int *arr;
        int top;
        int capacity;
        string equation;
};

my_stack::my_stack(int size)
{
    top = -1;
    capacity = size;
    arr = new int[size];
}

void my_stack::push(int input)
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

int my_stack::pop()
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

int my_stack::peek()
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

bool my_stack::is_empty()
{
    return (top == -1);
}

bool my_stack::is_full()
{
    return (top == capacity-1);
}

bool my_stack::is_digit(char input)
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

void my_stack::evaluate(string input)
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
    }
}

void my_stack::output()
{
    cout << "Answer = " << peek() << "\n";
}

void top_to_bottom(my_stack input)
{
    if (!input.is_empty())
    {
        cout << "Stack - Top to bottom" << "\n";
        for (int i=0; i<=input.top; i++)
        {
            cout << " " << input.arr[i] << "\n";
        }
        cout << "\n";
    }
}

void bottom_to_top(my_stack input)
{
    if (!input.is_empty())
    {
        cout << "Stack - Bottom to top" << "\n";
        for (int i=input.top; i>=0; i--)
        {
            cout << " " << input.arr[i] << "\n";
        }
        cout << "\n";
    }
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
        my_stack t1(s.length());
        t1.evaluate(s);
        top_to_bottom(t1);
        bottom_to_top(t1);
    }
    return 0;
}