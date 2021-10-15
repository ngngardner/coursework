/*
    Assignment 1
    File: problem_19.cpp
    Author: Noah Gardner
    Date: 1/22/2020
    Description: 
        The purpose of this file is to implement the problem 19 page 62
*/

#include <string>
#include <cassert>
#include <iostream>
using namespace std;

/*
    The class MyClock functions as a clock - can be initialized with a time,
    can be updated with a new time, and can print the time in the HH:MM A.M/P.M.
    format. It keeps track of the time using the cur_time variable, which stores
    the current time in minutes. Since it doesn't keep track of days, cur_time
    will not go above 1439 (where 0 = 1440 == 12:00 A.M.).
*/
class MyClock
{
    public:
        // CONSTRUCTORS

        // default constructor - time = 12:00 A.M.
        MyClock(); 
        // constructor where beginning minutes can be specified
        MyClock(int min); 
        // constructor where beginning hours and minutes can be specified
        MyClock(int hr, int min);

        // MEMBER FUNCTIONS

        // print the current time in HH:MM A.M./P.M. format
        void time();
        // this function is called after cur_time changes to ensure it does
        // not go above 1440
        void update_time();

        // assign a hour and minute time to the clock
        void assign_time(int hr, int min); 
        // advance the time of the clock by 'min' minutes
        void advance_time(int min);
        // find the current hour with cur_time
        int current_hour();
        // find the current minutes with cur_time
        int current_minute();
        // find if the cur_time is before noon
        bool is_before_noon() const;
        
    private:
        int cur_time; // store the current time in minutes (0-1440)
        int minute; // store the current time in minutes for HH:MM (0-59)
        int hour; // store the current time in hours for  HH:MM (1-12)
};

MyClock::MyClock()
{
    cur_time = 0;
}

// Pre-conditions - min >= 0
MyClock::MyClock(int min)
{
    assert (min >= 0);

    MyClock();
    assign_time(0, min);
}

// Pre-conditions - hr, min >= 0
MyClock::MyClock(int hr, int min)
{
    assert (hr >= 0);
    assert (min >= 0);

    MyClock();
    assign_time(hr, min);
}

void MyClock::time()
{
    // print time in HH:MM A.M/P.M.
    cout << current_hour();
    cout << ":";
    if (current_minute() < 10)
    {
        // add leading 0 for MM < 10
        cout << "0";
        cout << current_minute();
        cout << " ";
    }
    else
    {
        cout << current_minute();
        cout << " ";
    }

    if (is_before_noon())
    {
        cout << "A.M." << endl;
    }
    else
    {
        cout << "P.M." << endl;
    }
}

void MyClock::update_time()
{
    // cur_time should not exceed 1440
    while (cur_time >= 1440)
    {
        cur_time = cur_time - 1440;
    }
}

// Pre-conditions - hr, min >= 0
void MyClock::assign_time(int hr, int min)
{
    assert (hr >= 0);
    assert (min >= 0);

    if (hr == 0)
    {
        cur_time = min;
    }
    else
    {
        cur_time = hr*60 + min;
    }

    update_time();
}

// Pre-conditions - min >= 0
void MyClock::advance_time(int min)
{
    assert (min >= 0);

    cur_time = cur_time + min;

    update_time();
}

int MyClock::current_hour()
{
    // find the current hour
    hour = (cur_time-current_minute())/60;
    if (is_before_noon())
    {
        if (hour == 0)
        {
            hour = 12; // change hour to 12 for the 12 A.M. case
        }
    }
    else
    {
        if (hour != 12)
        {
            hour = hour - 12; // change hour to the 12 hour format version
        }
    }

    return hour;
}

int MyClock::current_minute()
{
    minute = cur_time % 60;
    return minute;
}

bool MyClock::is_before_noon() const
{
    if (cur_time < 720)
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
    MyClock clock_1;
    MyClock clock_2(50);
    MyClock clock_3(3, 50);

    clock_1.time();
    clock_2.time();
    clock_3.time();

    MyClock clock_4;
    int input;
    while(true)
    {
        clock_4.time();
        cout << "Advance time by __ minutes: ";
        cin >> input;

        // error catching
        while(cin.fail())
        {
            cout << "Error." << endl;
            cin.clear();
            cin.ignore(256, '\n');
            cin >> input;
        }
        
        clock_4.advance_time(input);
    }

    return 0;
}