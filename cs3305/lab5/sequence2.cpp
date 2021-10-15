/*
    File: sequence2.cpp
    Author: Noah Gardner
    Date: 2/6/2020
    Description: 
        The purpose of this file is to implement the set described in lab 5.
        The set is a dynamic sequence that has several functions, and is tested
        using sequence_exam2.cpp.
*/

#include <iostream>
#include <cstdlib>
#include <cassert>
#include "sequence2.h"
using namespace std;
using namespace main_savitch_4;

sequence::sequence(size_type initial_capacity)
{
    capacity = initial_capacity;
    used = 0;
    data = new value_type[capacity];
    current_index = 0;
}

sequence::sequence(const sequence& source)
{
	capacity = source.capacity;
	used = source.used;
	current_index = source.current_index;

    // copy data
	data = new value_type[capacity];
	for(int i = 0; i < used; i++)
	{ 
		data[i] = source.data[i];
	}
}

sequence::~sequence( ){
    delete [] data;
}

void sequence::resize(size_type new_capacity)
{
    value_type *larger_array;
    if(capacity < new_capacity)
    {
        larger_array = new value_type[new_capacity];
        for(int i = 0; i < used; i++)
        {
            larger_array[i] = data[i];
        }
        copy(data, data + used, larger_array);
        delete [] data;
        data = larger_array;
        capacity = new_capacity;
    }
}
void sequence::start( )
{            
    current_index = 0;
}

void sequence::advance( )
{
    if(is_item()){
        current_index++;
    }
}

void sequence::insert(const value_type& entry)
{
    if(size() == capacity)
    {
        resize(capacity + DEFAULT_CAPACITY);
    }
    if(!is_item())
    {
        current_index = 0;
    }
    for(size_type i = used; i > current_index; --i)
    {
        data[i] = data[i-1];
    }
    data[current_index] = entry;
    ++used;
}
    
void sequence::attach(const value_type& entry)
{
    if(size() == capacity)
    {
        resize(capacity + DEFAULT_CAPACITY);
    }
    if(!is_item())
    {
        current_index = used - 1;
    }
    ++current_index;
    for(size_type i = used; i > current_index; --i)
    {
        data[i] = data[i-1];
    }
    data[current_index] = entry;
    ++used;
}
void sequence::remove_current( )
{
    assert(is_item());
    if(is_item())
    {
        for(size_type i = current_index; i < used; ++i)
        {
            data[i] = data[i + 1];
        }
    }
    --used;
}
void sequence::operator =(const sequence& source)
{
    if(this == &source)
        return;
    value_type *new_data = new value_type [source.capacity];
    copy(source.data, source.data+source.used, new_data);
    delete [] data;
    data = new_data;
    used = source.used;
    capacity = source.capacity;
    if(source.is_item())
        current_index = source.current_index;
    else
        current_index = used;
}

sequence::size_type sequence::size( ) const
{
    return used;            
}

bool sequence::is_item( ) const
{
    if (current_index < used)
        return true;
    else
        return false;
}
sequence::value_type sequence::current( ) const
{
    assert(is_item());
    return data[current_index];   
}