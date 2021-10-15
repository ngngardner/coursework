/*
    File: stats.cpp
    Author: Noah Gardner
    Date: 1/16/2020
    Description: 
        The purpose of this file is to implement the exercise for lab 2.
        This file defines the member functions of the statician class,
        which keeps track of statistics of numbers given to it through the
        next() function.
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
    if (total > 0)
    {
        return total/count;
    }
}

double statistician::minimum() const
{
    if (total > 0)
    {
        return tinyest;
    }
}

double statistician::maximum() const
{
    if (total > 0)
    {
        return largest;
    }
}