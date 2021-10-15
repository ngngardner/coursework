#include <string>
#include "bst.h"
using namespace std;

int rnd()
{
    return rand() % 100;
}

template <class T>
class node
{
    public:
        T data;
        node* head_ptr = NULL;

        void insert(T input)
        {
            node* temp = new node();
            temp->data = input;
            temp->head_ptr = head_ptr;
            head_ptr = temp;
        }

        void load_inorder(binary_tree_node<T> *root)
        {
            if (root != NULL)
            {
                load_inorder(root->left());
                insert(root->data());
                load_inorder(root->right());
            }
        }

        void output()
        {
            node* temp = head_ptr;
            while(temp != NULL)
            {
                cout << temp->data << " ";
                temp = temp->head_ptr;
            }
            cout << "\n";
        }
};


int main()
{
    // cout << "Creating BST... \n";
    // binary_search_tree<int> bst;
    // for (int i=0; i<10; ++i)
    // {
    //     bst.insert(rnd());
    // }
    // cout << bst << "\n";

    // cout << "Creating linked list from BST... \n";
    // node<int> *root;
    // root->load_inorder(bst.get_root());
    // root->output();

    node<int> *root;
    root->insert(5);
    root->insert(3);
    root->output();
}