/*
    File: main.cpp
    Author: Noah Gardner
    Date: 2/27/2020
    Description: 
        The purpose of this file is to implement the
        main function described in lab 7. The lab is meant
        to help the programmer explore the available functions
        in the linked list tool kit.
*/
#include "check_lists.cpp"
#include "check_lists.h"
#include "node1.h"
#include "node1.cpp"

using namespace main_savitch_5;

void list_print(node *head_ptr)
{
    node *temp = head_ptr;
    while (temp != NULL)
    {
        cout << temp->data() << ", ";
        temp = temp->link();
    }
    cout << "\n";
}

int main(){
    // test 1
    node *l1 = new node(23.5);
    list_head_insert(l1, 45.6);
    list_head_insert(l1, 67.7);
    list_head_insert(l1, 89.8);
    list_head_insert(l1, 12.9);
    list_print(l1);
    check_list1(l1);

    // test 2
    node *l2_tail_ptr = new node();
    node *l2 = new node(23.5, l2_tail_ptr);
    *l2_tail_ptr = 45.6;
    list_insert(l2_tail_ptr, 67.7);
    l2_tail_ptr = l2_tail_ptr->link();
    list_insert(l2_tail_ptr, -123.5);
    l2_tail_ptr = l2_tail_ptr->link();
    list_insert(l2_tail_ptr, 89.8);
    l2_tail_ptr = l2_tail_ptr->link();
    list_insert(l2_tail_ptr, 12.9);
    l2_tail_ptr = l2_tail_ptr->link();
    list_print(l2);
    check_list2(l2);

    // test 3
    node *l3_tail_ptr = new node();
    node *l3 = new node(0, l3_tail_ptr);
    list_copy(l1, l3, l3_tail_ptr);
    list_print(l3);
    check_list1(l3);
    list_print(l3_tail_ptr);

    // test 4
    list_head_remove(l2);
    list_print(l2);
    check_list2B(l2);

    // test 5
    list_remove(list_locate(l2, 2));
    list_print(l2);
    check_list2C(l2);

    return 0;
}