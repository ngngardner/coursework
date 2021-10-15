
/*
    File: main.cpp
    Author: Noah Gardner
    Date: 3/26/2020
    Description: 
        The purpose of this file is to implement the
        projects described in lab 11. The first part of
        the project implements the depth and max functions,
        which will give the depth and max of an input 
        binary tree. The second part of the project 
        implements the tree_sum, tree_average, and 
        tree_is_balanced functions.
*/

#include "bintree.h"
#include "build_tree.cpp"
#include <iostream>
using namespace std;

template <class T>
void printItem(T item)
{
    cout<<item<<" ";
}

template <class T>
int depth(binary_tree_node<T> *root)
{
    if (root == NULL)
    {
        return -1;
    }
    else
    {
        return std::max(depth(root->left()), depth(root->right())) + 1; 
    }
}

template <class T>
T max(binary_tree_node<T> *root)
{
    assert(root != NULL);

    T left_max = 0;
    T right_max = 0;

    // find max of left subtree
    if (root->left() != NULL)
    {
        left_max = max(root->left());
    }
    // find max of right subtree
    if (root->right() != NULL)
    {
        right_max = max(root->right());
    }

    if (left_max > right_max && left_max > root->data())
    {
        return left_max;
    }
    else if (right_max > left_max && right_max > root->data())
    {
        return right_max;
    }
    else
    {
        return root->data();
    }   
}

double tree_sum(binary_tree_node<double> *root)
{
    if (root == NULL)
    {
        return 0;
    }
    else
    {
        return (tree_sum(root->left()) + tree_sum(root->right()) + root->data());
    }
}

double tree_average(binary_tree_node<double> *root)
{
    return tree_sum(root)/tree_size(root);
}

template <class T>
bool tree_is_balanced(binary_tree_node<T> *root)
{
    if (root == NULL)
    {
        return 1;
    }
    else if (!tree_is_balanced(root->left()) || !tree_is_balanced(root->right()))
    {
        return 0;
    }
    else if (abs(depth(root->left()) - depth(root->right()) > 1))
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

int main()
{
    cout << "Part 1: \n";
    binary_tree_node<int> *s1 = sample1();
    cout << "size of s1: " << tree_size(s1) << "\n";
    cout << "depth of s1: " << depth(s1) << "\n";
    cout << "max of s1: " << max(s1) << "\n";
      
    binary_tree_node<int> *s2 = sample2();
    cout << "size of s2: " << tree_size(s2) << "\n";
    cout << "depth of s2: " << depth(s2) << "\n";
    cout << "max of s2: " << max(s2) << "\n";
    
    binary_tree_node<double> *s3 = sample3();
    cout << "size of s3: " << tree_size(s3) << "\n";
    cout << "depth of s3: " << depth(s3) << "\n";
    cout << "max of s3: " << max(s3) << "\n";

    cout << "\nPart 2: \n";
    cout << "sum of s3: " << tree_sum(s3) << "\n";
    cout << "average of s3: " << tree_average(s3) << "\n";
    cout << "size of s3: " << tree_size(s3) << "\n";
    
    binary_tree_node<double> *b1 = sample_bal1();
    cout << "sum of b1: " << tree_sum(b1) << "\n";
    cout << "average of b1: " << tree_average(b1) << "\n";
    cout << "size of b1: " << tree_size(b1) << "\n";

    binary_tree_node<double> *b2 = sample_bal2();
    cout << "sum of b2: " << tree_sum(b2) << "\n";
    cout << "average of b2: " << tree_average(b2) << "\n";
    cout << "size of b2: " << tree_size(b2) << "\n";

    binary_tree_node<double> *s4 =sample4();
    binary_tree_node<string> *s5 = sample5();

    cout << "s1 is balanced? " << tree_is_balanced(s1) << "\n";
    cout << "s2 is balanced? " << tree_is_balanced(s2) << "\n";
    cout << "s3 is balanced? " << tree_is_balanced(s3) << "\n";
    cout << "s4 is balanced? " << tree_is_balanced(s4) << "\n";
    cout << "s5 is balanced? " << tree_is_balanced(s5) << "\n";
    cout << "b1 is balanced? " << tree_is_balanced(b1) << "\n";
    cout << "b2 is balanced? " << tree_is_balanced(b2) << "\n";
}
