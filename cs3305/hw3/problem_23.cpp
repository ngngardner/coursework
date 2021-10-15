
/*
    File: problem_23.cpp
    Author: Noah Gardner
    Date: 3/30/2020
    Description: 
        The purpose of this file is to implement problem 23 page 531 in the text.
*/

#include <iostream>
#include <cstdlib>
using namespace std;

template<class T>
struct node
{
    T data;
    node<T>* left;
    node<T>* right;
};

template<class T>
class bst
{
    public:
        node<T>* insert(T data, node<T>* n);
        void insert(T data);
        void output(node<T>* n);
        void output();
        node<T>* find(T data, node<T>* n);
        void find(T data);
    private:
        node<T>* root = NULL;
};

// PRECONDITIONS: 
//      1. data is a variable of type T that matches the BST
//      2. n is a node in the BST
// POSTCONDITONS: data will be inserted to the BST
template<class T>
node<T>* bst<T>::insert(T data, node<T>* n)
{
    if (n==NULL)
    {
        n = new node<T>;
        n->data = data;
        n->left = NULL;
        n->right = NULL;
    }
    else if (data < n->data)
    {
        n->left = insert(data, n->left);
    }
    else if (data > n->data)
    {
        n->right = insert(data, n->right);
    }
    return n;
}

// PRECONDITIONS: data is a variable of type T that matches the BST
// POSTCONDITONS: data will be inserted to the BST
template<class T>
void bst<T>::insert(T data)
{
    root = insert(data, root);
}

// PRECONDITIONS: 
//      1. data is a variable of type T that matches the BST
//      2. n is a node in the BST
// POSTCONDITIONS: Output to the terminal 
//      1. if data is in the tree
//      2. how many steps it took to find it
template<class T>
node<T>* bst<T>::find(T data, node<T>* n)
{
    // if steps is 1, the data was found on the first node
    int steps = 1;
    while (n != NULL)
    {
        if (data == n->data)
        {
            cout << "Steps to find " << data << ": " << steps << "\n";
            return n;
        }
        else if (data < n->data)
        {
            steps++;
            n = n->left;
        }
        else if (data > n->data)
        {
            steps++;
            n = n->right;
        }
    }
    cout << "Error: " << data << " not found " << "\n";
    node<T>* err = NULL;
    return err;
}

// PRECONDITIONS: data is a variable of type T that matches the BST
// POSTCONDITIONS: Output to the terminal 
//      1. if data is in the tree
//      2. how many steps it took to find it
template<class T>
void bst<T>::find(T data)
{
    find(data, root);
}

// PRECONDITIONS: n is a pointer to a node inside the BST
// POSTCONDITIONS: Ouput BST starting from node n to the terminal
template<class T>
void bst<T>::output(node<T>* n)
{
    if (n==NULL)
    {
        return;
    }
    output(n->left);
    cout << n->data << " ";
    output(n->right);
}

// PRECONDITIONS: None
// POSTCONDITIONS: Ouput entire BST
template<class T>
void bst<T>::output()
{
    output(root);
}

int main()
{
    cout << "Testing string BST" << "\n";
    bst<string> bst1;
    bst1.insert("blueberry");
    bst1.insert("peach");
    bst1.insert("apricot");
    bst1.insert("pear");
    bst1.insert("cherry");
    bst1.insert("mango");
    bst1.insert("papaya");
    bst1.output();
    cout << "\n";

    bst1.find("pear");
    bst1.find("orange");
    bst1.find("blueberry");

    cout << "\n" << "Testing int BST" << "\n";
    bst<int> bst2;
    bst2.insert(52);
    bst2.insert(25);
    bst2.insert(31);
    bst2.insert(17);
    bst2.insert(68);
    bst2.output();
    cout << "\n";

    bst2.find(25);
    bst2.find(44);
    bst2.find(17);
    return 0;
}