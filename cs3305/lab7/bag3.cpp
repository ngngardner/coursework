/*
    File: bag3.cpp
    Author: Noah Gardner
    Date: 2/27/2020
    Description: 
        The purpose of this file is to implement the
        bag function described in lab 7. The file 
        implements the -= operator as a memeber function
        and the - operator as a non-member function.
*/
#include "bag3.h"
#include "node1.cpp"
#include <cassert>
#include <cstdlib>

using namespace std;
namespace main_savitch_5
{
    bag::bag( )
    {
        head_ptr = NULL;
        many_nodes = 0;
    }

    bag::bag(const bag& source)
    {
        node *tail_ptr;
        list_copy(source.head_ptr, head_ptr, tail_ptr);
        many_nodes = source.many_nodes;
    }

    bag::~bag( )
    {
        list_clear(head_ptr);
        many_nodes = 0;
    }

    bag::size_type bag::erase(const value_type& target)
    {
        size_type answer = 0;
        node *target_ptr;

        target_ptr = list_search(head_ptr, target);
        while (target_ptr != NULL)
        {
            target_ptr->set_data(head_ptr->data());
            target_ptr = target_ptr->link();
            target_ptr = list_search(target_ptr, target);
            list_head_remove(head_ptr);
            many_nodes--;
            answer++;
        }
    }

    bool bag::erase_one(const value_type& target)
    {
        node *target_ptr;

        target_ptr = list_search(head_ptr, target);
        if (target_ptr == NULL)
        {
            return false;
        }

        target_ptr->set_data(head_ptr->data());
        list_head_remove(head_ptr);
        many_nodes--;
        return true;
    }

    void bag::insert(const value_type& entry)
    {
        list_head_insert(head_ptr, entry);
        many_nodes++;
    }

    void bag::operator +=(const bag& addend)
    {
        node *head_ptr_copy;
        node *tail_ptr_copy;

        if (many_nodes > 0)
        {
            list_copy(addend.head_ptr, head_ptr_copy, tail_ptr_copy);
            tail_ptr_copy->set_link(head_ptr);
            many_nodes += addend.many_nodes;
        }
    }

    void bag::operator =(const bag& source)
    {
        node *tail_ptr;

        if (this == &source)
        {
            return;
        }

        list_clear(head_ptr);
        many_nodes = 0;
        list_copy(source.head_ptr, head_ptr, tail_ptr);
        many_nodes = source.many_nodes;
    }

    void bag::operator -=(const bag &subtrahend)
    {
        bag temp;
        int val;

        temp = subtrahend;
        while (temp.size() > 0)
        {
            val = temp.grab();
            erase_one(val);
            temp.erase_one(val);
        }
    }

    bag::size_type bag::count(const value_type& target) const
    {
        size_type answer;
        const node *cursor;

        answer = 0;
        cursor = list_search(head_ptr, target);
        while (cursor != NULL)
        {
            answer++;
            cursor = cursor->link();
            cursor = list_search(cursor, target);
        }
        return answer;
    }

    bag::value_type bag::grab( ) const
    {
        size_type i;
        const node *cursor;

        assert(size()>0);
        i = (rand() % size())+1;
        cursor = list_locate(head_ptr, i);
        return cursor->data();
    }

    bag operator +(const bag& b1, const bag& b2)
    {
        bag res;

        res += b1;
        res += b2;

        return res;
    }

    bag operator -(const bag& b1, const bag& b2)
    {
        bag res;

        res = b1;
        res -= b2;

        return res;
    }
}
