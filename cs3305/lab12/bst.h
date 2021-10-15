#ifndef BST_H
#define BST_H

#include "bintree.h"
#include <iostream>


template <class T>
class binary_search_tree {

public:
    binary_search_tree() {
        root = NULL;
    }

    /**
     * Search for the key in this binary search tree.
     * Return a node containing the key, if found.
     * Return null if not found.
     */
    binary_tree_node<T> *search(const T &key) const;

    /**
     * Add the item to this binary search tree as long as it
     * is not already present.
     * Return false if item is already  in the tree.
     * Return true if item is actually added to the tree.
     */
    bool insert(const T &item);


    /**
     * Remove the item from the tree.
     * Return true if the item was actually removed.
     * Return false if the item was not in the tree to begin with.
     */
    bool remove(const T &item);



    ~binary_search_tree();


    /**
     * return the depth of the tree if the tree is balanced.
     * Return -2 if not.
     */
    int is_balanced();

    template <class S>
    friend std::ostream &operator<<(std::ostream &out, const binary_search_tree<S> &tree);

    binary_tree_node<T> *get_root() { return root; }


private:
    binary_tree_node<T> *root;
};


template <class T>
std::ostream &operator<<(std::ostream &out, const binary_tree_node<T> *root);

/**
 * return the depth of the tree rooted at root if the tree is balanced.
 * Return -2 if not.
 */
template <class T>
int check_balanced(binary_tree_node<T> *root);


template <class Item>
bool bst_remove(
        binary_tree_node<Item>*& root_ptr,
        const Item& target
);
// Precondition: root_ptr is a root pointer of a binary search tree (or may
// be NULL for the empty tree).
// Postcondition: If target was in the tree, then one copy of target has been
// removed, root_ptr now points to the root of the new (smaller) binary
// search tree, and the function returns true. Otherwise, if target was not
// in the tree, then the tree is unchanged, and the function returns false.

template <class Item>
void bst_remove_max(
        binary_tree_node<Item>*& root_ptr,
        Item& removed
);
// Precondition: root_ptr is a root pointer of a non-empty binary search
// tree.
// Postcondition: The largest item in the binary search tree has been
// removed, and root_ptr now points to the root of the new (smaller) binary
// search tree. The reference parameter, removed, has been set to a copy
// of the removed item.



#include "bst.template"


#endif // BST_H
