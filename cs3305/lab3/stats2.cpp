/*
    File: stats2.cpp
    Author: Noah Gardner
    Date: 1/23/2020
    Description: 
        The purpose of this file is to implement the exercise for lab 3.
        This file defines the member functions of the statician class,
        which keeps track of statistics of numbers given to it through the
        next() function. It also has some overloaded operators to allow
        for comparison and operations on staticians.
*/

statistician::statistician()
{
    reset();
}

void statistician::next(double r)
{
    // upon the first number being received, the statistics must be set
    if (not initialized)
    {
        tinyest = r;
        largest = r;
        initialized = true;
    }

    // increment count
    count = count + 1;

    // update total
    total = total + r;

    // assess if new num is smaller than tinyest
    if (tinyest > r)
    {
        tinyest = r;
    }
    
    // assess if new num is larger than largest
    if (largest < r)
    {
        largest = r;
    }
}

void statistician::reset()
{
    count = 0;
    total = 0;
    tinyest = 0;
    largest = 0;
    initialized = false;
}

int statistician::length() const
{
    return count;
}

double statistician::sum() const
{
    return total;
}

double statistician::mean() const
{
    if (initialized == true)
    {
        return total/count;
    }
}

double statistician::minimum() const
{
    if (initialized == true)
    {
        return tinyest;
    }
}

double statistician::maximum() const
{
    if (initialized == true)
    {
        return largest;
    }
}

bool close(double a, double b);

statistician operator + (const statistician& s1, const statistician& s2)
{
    // temp statistician to return
    statistician temp;

    // add count and total to new stat
    temp.count = s1.count + s2.count;
    temp.total = s1.total + s2.total;

    // if neither operand has been initialized, then neither should the new one
    if (s1.initialized == false and s2.initialized == false)
    {
        temp.tinyest = 0;
        temp.largest = 0;
        temp.initialized = false;
        return temp;
    }
    // if only one has been initialized, it should reflect the initialized stat
    else if (s1.initialized == true and s2.initialized == false)
    {
        temp.tinyest = s1.tinyest;
        temp.largest = s1.largest;
        temp.initialized = true;
        return temp;
    }
    else if (s1.initialized == false and s2.initialized == true)
    {
        temp.tinyest = s2.tinyest;
        temp.largest = s2.largest;
        temp.initialized = true;
        return temp;
    }
    // if both have been intialized, then compare their stats
    else
    {
        if (s1.tinyest < s2.tinyest)
        {
            temp.tinyest = s1.tinyest;
        } 
        else
        {
            temp.tinyest = s2.tinyest;
        }
        if (s1.largest > s2.largest)
        {
            temp.largest = s1.largest;
        } 
        else if (s2.initialized == true)
        {
            temp.largest = s2.largest; 
        }
        temp.initialized = true;
    }
    return temp;
}

statistician operator * (double scale, const statistician& s)
{
    // temp statistician to return
    statistician temp;
    if (s.initialized == true)
    {
        temp.count = s.count;
        temp.total = scale*s.total;
        // if scale is positive, then tinyest and largest will match
        if (scale > 0)
        {
            temp.tinyest = scale*s.tinyest;
            temp.largest = scale*s.largest;
        }
        // if scale is negative, tinyest and largest will flip
        else
        {
            temp.tinyest = scale*s.largest;
            temp.largest = scale*s.tinyest;
            
            // fix if there is a -0 error
            if (temp.largest == -0)
            {
                temp.largest = 0;
            }
            if (temp.tinyest == -0)
            {
                temp.tinyest = 0;
            }
        }
        temp.initialized = true;
    }
    return temp;
}

bool operator ==(const statistician& s1, const statistician& s2)
{
    // return true if either stats have not seen any numbers
    if (s1.length() == 0 and s2.length() == 0)
    {
        return true;
    }
    // otherwise, if all statistics are equal, then the staticians are equal
    else if (close(s1.length(), s2.length()) 
    and (close(s1.mean(), s2.mean()))
    and (close(s1.minimum(), s2.minimum()))
    and (close(s1.maximum(), s2.maximum()))
    and (close(s1.sum(), s2.sum())))
    {
        return true;
    }
    else
    {
        return false;
    }
}