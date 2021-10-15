/*
    Assignment 1
    File: example_17.cpp
    Author: Noah Gardner
    Date: 1/22/2020
    Description: 
        The purpose of this file is to implement the example 17 page 95
*/

#include <string>
#include <cassert>
#include <iostream>
#include <cmath>

using namespace std;

// array to map month integers to string names
string months[12] = {
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
};

// the last day of each month
int days_per_month[12] = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
};

/*
    The class date uses integers to represent the date's month, day and year
    It has a member function to increment to the next day, and has friend
    functions to display the date in number and word format.
*/
class date
{
    public:
        int month;
        int day;
        int year;

        // CONSTRUCTORS
        // default constructor - 1/1/2000
        date();
        // constructor where starting month, day, and year can be set
        date(int m, int d, int y);

        // MEMBER FUNCTIONS
        // set the date
        void set_date(int m, int d, int y);
        // advance to the next day
        void next_day();
        // true if it is the last day of the month
        bool is_last_day_month();
        // true if it is the last day of the year
        bool is_last_day_year();
        // true if the current year is a leap year
        bool is_leap_year();

        // FRIEND FUNCTIONS
        // display date in number format
        friend void display_date_num();
        // display date in word format
        friend void display_date_word();
};

date::date()
{
    // default constructor - 1/1/2000
    month = 1;
    day = 1;
    year = 2000;
}

date::date(int m, int d, int y)
{
    set_date(m, d, y);
}

/*
    Preconditons
        *month is between 1 and 12
        *year is greater or equal to 0
        *day is a valid day for that month and year
*/
void date::set_date(int m, int d, int y)
{
    assert(1 <= m <= 12);
    month = m;

    assert(y >= 0);
    year = y;

    if (is_leap_year() and month == 1)
    {
        assert(1 <= d <= 29);
    }
    else
    {
        assert(1 <= d <= days_per_month[month+1]);
    }

    day = d;
}

void date::next_day()
{
    if (is_last_day_year())
    {
        // reset month and day to January 1st, and increment year
        month = 1;
        day = 1;
        year = year + 1;
    }
    else if (is_last_day_month())
    {
        // reset day to the 1st and increment the month
        month = month + 1;
        day = 1;
    }
    else
    {
        // increment the day
        day = day + 1;
    }
}

void display_date_num(date d)
{
    cout << d.month;
    cout << "/";
    cout << d.day;
    cout << "/";
    cout << d.year << endl;
}

void display_date_word(date d)
{
    cout << months[d.month-1];
    cout << " ";
    cout << d.day;
    cout << ",";
    cout << d.year << endl;
}

bool date::is_last_day_month()
{
    if (is_leap_year())
    {
        // if it is leap year and februrary 28th, 
        // then it is not the last day of the month
        if (month == 2 and day == days_per_month[month-1])
        {
            return false;
        }
        // if it is leap year and februrary 29th, 
        // then it is the last day of the month
        else if (month == 2 and day == days_per_month[month-1]+1)
        {
            return true;
        }
    }
    if (day == days_per_month[month-1])
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool date::is_last_day_year()
{
    // last day of the year is the last day of December
    if (month == 12 and day == days_per_month[month-1])
    {
        return true;
    }
    else
    {
        return false;
    }
    
}

bool date::is_leap_year()
{
    // the year is leap year if it is divisible by 4
    if (year % 4 == 0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

int main()
{
    date test_1, test_2(2, 29, 2004);

    display_date_num(test_1);
    display_date_word(test_1);

    int input;

    while(true)
    {
        display_date_num(test_2);
        display_date_word(test_2);

        cout << "Advance date by __ days: ";
        cin >> input;

        // error catching
        while(cin.fail())
        {
            cout << "Error." << endl;
            cin.clear();
            cin.ignore(256, '\n');
            cin >> input;
        }

        while (input > 0)
        {
            test_2.next_day();
            input--;
        }
    }

    return 0;
}