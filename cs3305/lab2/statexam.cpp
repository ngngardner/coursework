// FILE: statexam.cpp
// Written by Michael Main (main@colorado.edu)
// This program calls three test functions to test the statisitician class.
// Maximum number of points from this program is 69.

#include <iostream>
#include <cstdlib>
#include <cmath>
#include <string.h>    // Provides memcpy function
#include "stats.h"
#include "stats.cpp"

using namespace std;

bool close(double a, double b)
{
    const double EPSILON = 1e-5;
    return (fabs(a-b) < EPSILON);
}

int test1( )
{
    // Test program for basic statistician functions.
    // Returns 62 if everything goes okay; otherwise returns 0.

    statistician s, t;
    int i;
    double r = 0;

    if (s.length( ) || t.length( )) return 0;
    if (s.sum( ) || t.sum( )) return 0;

    for (i = 1; i <= 10000; i++)
    {
	s.next(i);
	r += i;
    };

    if (t.length( ) || t.sum( )) return 0;
    if (s.length( ) != 10000) return 0;
    if (!close(s.sum( ), r)) return 0;
    if (!close(s.mean( ), r/10000)) return 0;
    
    // Reset and then retest everything
    s.reset( );
    t.reset( );
    r = 0;
    
    if (s.length( ) || t.length( )) return 0;
    if (s.sum( ) || t.sum( )) return 0;

    for (i = 1; i <= 10000; i++)
    {
	s.next(i);
	r += i;
    };

    if (t.length( ) || t.sum( )) return 0;
    if (s.length( ) != 10000) return 0;
    if (!close(s.sum( ), r)) return 0;
    if (!close(s.mean( ), r/10000)) return 0;

    return 62;
}

int test2( )
{
    // Test program for minimum/maximum statistician functions.
    // Returns 7 if everything goes okay; otherwise returns 0.

    statistician s, t, u;
    double r = 1000;
    char n[15] = "10000000000000";

    if (s.length( ) || t.length( )) return 0;
    if (s.sum( ) || t.sum( )) return 0;

    memcpy(&r, n, sizeof(double));
    r = 1/r;
    s.next(r);
    if ((s.minimum( ) != r) || (s.maximum( ) != r)) return 0;
    r *= -1;
    t.next(r);
    if ((t.minimum( ) != r) || (t.maximum( ) != r)) return 0;

    u.next(100); u.next(-1); u.next(101); u.next(3);
    if ((u.minimum( ) != -1) || (u.maximum( ) != 101)) return 0;

    return 7;
}

int main( )
{
    int value = 0;
    int result;
    
    cerr << "Running statistician tests:" << endl;
 
    cerr << "TEST 1:" << endl;
    cerr << "Testing next, reset, length, sum, and mean (62 points).\n";
    result = test1( );
    value += result;
    if (result > 0) cerr << "Test 1 passed." << endl << endl;
    else cerr << "Test 1 failed." << endl << endl; 
 
    cerr << "\nTEST 2:" << endl;
    cerr << "Testing minimum and maximum member functions (7 points).\n";
    result = test2( );
    value += result;
    if (result > 0) cerr << "Test 2 passed." << endl << endl;
    else cerr << "Test 2 failed." << endl << endl; 
 
   
    cerr << "If you submit the statistician to Dora now, this part of the\n";
    cerr << "grade will be " << value << " points out of 69.\n";
    
    return EXIT_SUCCESS;

}











