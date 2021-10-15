
/*
    File: lab10.cpp
    Author: Noah Gardner
    Date: 3/19/2020
    Description: 
        The purpose of this file is to implement the
        projects described in lab 10. The first project
        is a recursive function that will create am output
        'pyramid' based on an input integer. The second project
        will compute the sum of the reciprocals of every digit up
        to the input digit.
*/

#include <iostream>
using namespace std;


void recursion(int count, int last)
{
    if (count <= last)
    {
        for(int i=0; i <count-1; i ++)
        {
            cout << " ";
        }
        cout << "This was written by call number " << count << "." << "\n";
        recursion(count+1, last);
        for(int i=count-1; i>1; i--)
        {
            cout << " ";
        }
        cout << "This was ALSO written by call number " << count << "." << "\n";
    }
}

double sum_over(double last)
{
    if(last>0)
    {
        last = (1/(last))+sum_over(last-1); 
    }
    return last;
}

int main(){
    int input;
    int start = 1;
    cout << "Enter the digit to end the recursive function on: ";
    cin >> input;
    recursion(start, input);

    cout << "\n";
    cout << "Enter a digit for sumover: ";
    cin >> input;
    cout << "sumover = " << sum_over(input) << "\n";
    return 0;
}