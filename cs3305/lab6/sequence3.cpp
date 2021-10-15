/*
    File: sequence2.cpp
    Author: Noah Gardner
    Date: 2/20/2020
    Description: 
        The purpose of this file is to implement the
        sequence described in lab 6. It functions as a linked
        list and it's functions can be tested using sequence_exam3.cpp.
*/
#include "node1.cpp"
#include "node1.h"
#include "sequence3.h"

#include <iostream>
#include <cstdlib>
#include <cassert>

using namespace std;
using namespace main_savitch_5;

sequence::sequence()
{   
    // set all pointers to null and the size to 0
    head_ptr = NULL;
    tail_ptr = NULL;
    many_nodes = 0;
    cursor = NULL;
    precursor = NULL;   
}

sequence::sequence(const sequence& source)
{
    // copy from the source
    list_copy(source.head_ptr, head_ptr, tail_ptr);
    many_nodes = source.size();
    precursor = NULL;
    
    // line up the cursors
    cursor = head_ptr;
    node* moving_pointer = source.head_ptr;
    while(moving_pointer != NULL && moving_pointer != source.cursor)
    {
        moving_pointer = moving_pointer -> link();
        precursor = cursor;
        cursor = cursor -> link();
    }
}

sequence::~sequence()
{
    list_clear(head_ptr);
}

void  sequence::start()
{
    cursor = head_ptr;
    precursor = NULL;
}

void  sequence::advance()
{
    precursor = cursor;
    cursor = cursor->link();
}

void  sequence::insert(const value_type& entry)
{
    // add a new item before the current item
    if(is_item())
    {
        if(cursor == head_ptr)
        {
            list_head_insert(head_ptr, entry);
            cursor = head_ptr;
            precursor = NULL;
        }
        else
        {
            list_insert(precursor, entry);
            cursor = precursor->link();
        }
    }
    else
    {
        list_head_insert(head_ptr, entry);
        precursor = NULL;
        cursor = head_ptr;
    }
    many_nodes ++;
}

void  sequence::attach(const value_type& entry)
{
    // add a new item after the current item
    if(is_item())
    {
        list_insert(cursor, entry);
        precursor = cursor;
        cursor = cursor->link();
    }
    else
    {
        if(precursor == NULL)
        {
            list_head_insert(head_ptr, entry);
            cursor = head_ptr;
            precursor = NULL;                        
        }
        else
        {
            cursor = list_locate(head_ptr, list_length(head_ptr));
            list_insert(cursor, entry);
            cursor = precursor->link();
        }
    }
    many_nodes++;
}

void  sequence::operator =(const sequence& source)
{
    node *tail_ptr;

    if(this == &source)
        return;
    list_clear(head_ptr);
    list_copy(source.head_ptr, head_ptr, tail_ptr);
    many_nodes = source.size();
    precursor = NULL;

    // line up the cursors
    cursor = head_ptr;
    node* detect_cur_item = source.head_ptr;
    while (detect_cur_item != NULL && detect_cur_item != source.cursor)
    {
        detect_cur_item = detect_cur_item->link();
        precursor = cursor;
        cursor = cursor->link();
    }
}

void  sequence::remove_current()
{
    if(cursor == head_ptr)
    {   
        // drop the head pointer and shift the cursor
        list_head_remove(head_ptr);
        cursor = head_ptr;
        precursor = NULL;
    }
    else
    {
        cursor = cursor->link();
        list_remove(precursor);
    }
    many_nodes--;
}

sequence::value_type  sequence::current() const
{
    value_type returnValue;
    returnValue = cursor->data();
    return returnValue;
}