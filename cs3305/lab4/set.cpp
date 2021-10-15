/*
    File: set.cpp
    Author: Noah Gardner
    Date: 2/6/2020
    Description: 
        The purpose of this file is to implement the set described in lab 4.
        The set is a dynamic array that has several functions, and is tested
        using test_set.cpp.
*/

#include <iostream>
#include <cstdlib>

using namespace std;

// postcondition: empty set with initial_capacity has been created
set::set(size_type initial_capacity)
{
    data = new value_type[initial_capacity];
    used = 0;
    capacity = initial_capacity;
}

// postcondition: all dynamically allocated memory has been deallocated
set::~set()
{
    delete [] data;
}

// copy of s has been created;
set::set(const set& s)
{
    data = new value_type[s.capacity];
    capacity = s.capacity;
    used = s.used;
    copy(s.data, s.data + used, data);
}

// postcondition: exact copy of s has been assigned to the current set object
set& set::operator= (const set& s)
{
    value_type *new_data;

    if(this == &s)
    {
        return *this;
    }
    if(capacity != s.capacity)
    {
        new_data = new value_type[s.capacity];
        delete[] data;
        data = new_data;
        capacity = s.capacity;
    }
    used = s.used;
    copy(s.data, s.data + used, data);
    return *this;
}

// postcondition: returned true if target was removed from set ow false if target was not in the set
bool set::erase(const value_type& target)
{
    size_type index = 0;
    size_type many_removed = 0;
    while(index < used)
    {
        if(data[index] == target)
        {
            --used;
            data[index] = data[used];
            ++many_removed;
        }
        else
        {
            ++index;
        }
    }
    return many_removed;
}

// postcondition: if entry was not in the set, then entry has been added - ow nothing was done
bool set::insert(const value_type& entry)
{
    if(used == capacity)
    {
        reserve(used + 1);
    }
    data[used] = entry;
    ++used;
    return true;
}

// postcondition: non-duplicating elements from addend have been added to the set
void set::operator+=(const set& addend)
{
    if((used + addend.used) > capacity)
    {
        reserve(used + addend.used);
    }
    copy(addend.data, addend.data + addend.used, data + used);
    used += addend.used;
}

// postcondition: number of elements in the set has been returned
set::size_type set::size() const
{
    return used;
}

// postcondition: returned whether target is in the set
bool set::contains(const value_type& target) const
{
    for(int i = 0; i < used; i++)
    {
        if(data[i] == target)
        {
            return true;
        }
    }
    return false;
}

std::ostream& operator<<(std::ostream& output, const set& s)
{
    for (set::size_type i=0; i<s.used; i++)
    {
        output << " " << s.data[i];
    }
    return output;
}

// precondition: size() <= new_capacity
// postcondition: capacity is new_capacity
void set::reserve (size_type new_capacity)
{
    value_type *a;

    if (new_capacity == capacity)
    {
        return;
    }

    if (new_capacity < used)
    {
        new_capacity = used;
    }

    a = new value_type[new_capacity];
    copy(data, data+used, a);
    delete [] data;
    data = a;
    capacity = new_capacity;
}