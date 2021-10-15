#include "stack_pair.h"
#include <iostream>

template<class T>
stack_pair<T> test1(stack_pair<T> testStack){
    stack_pair<T> returnStack = testStack;

    return returnStack;
}

template<class T>
stack_pair<T> test2(stack_pair<T> testStack){
    stack_pair<T> returnStack = testStack;
    cout<<"Capacity = "<<stack_pair<int>::CAPACITY<<"\n";
    cout<<"Pushing 15 Items onto stack A\n";
    int i = 0;
    while( i < 15){
        returnStack.push_a(i);
        i++;
    }
    cout<<"Size of A = "<<returnStack.size_a()<<"\n";


    cout<<"Pushing 15 Items onto stack B\n";
    while( i < 30){
        returnStack.push_b(i);
        i++;
    }
    cout<<"Size of B = "<<returnStack.size_b()<<"\n";

    returnStack.print_stack_pair();

    int c = 14;
    while( c >= 10){
        int popped = returnStack.pop_a();
        if(popped == c){
            cout<<"Popped Value "<<popped<<" is Correct\n";
        }
        else{
            cout<<"Popped value isn't correct\n";
        }
        c--;
    }
    cout<<"\n";
    returnStack.print_stack_pair();
    int d = 29;
    while( d >= 24){
        int popped = returnStack.pop_b();
        if(popped == d){
            cout<<"Popped Value "<<popped<<" is Correct\n";
        }
        else{
            cout<<"Popped value isn't correct\n";
        }
        d--;
    }
    returnStack.print_stack_pair();
    return returnStack;
}

template<class T>
stack_pair<T> test3(stack_pair<T> testStack){
    stack_pair<T> returnStack = testStack;
    cout<<"Test3\n";
    returnStack.print_stack_pair();
    int stackAVal = 0;
    while(!returnStack.is_full_a()){
        returnStack.push_a(stackAVal);
        stackAVal++;
    }
    int stackBVal = 0;
    while(!returnStack.is_full_b()){
        returnStack.push_b(stackBVal);
        stackBVal++;
    }
    returnStack.print_stack_pair();
    return returnStack;
}

void test4(){

}



int main(){
    //test1
    cout<<"Test 1: \n";
    stack_pair<int> stackP;
    cout<<"stack_pair has been created. \nFront End is A & Back End is B \n";
    cout<<"Is A empty? "<<stackP.is_empty_a()<<"\n";
    cout<<"Is B empty? "<<stackP.is_empty_b()<<"\n";
    cout<<"Print stack_pair: \n";
    stackP.print_stack_pair();
    cout<<"\n";

    //test2
    cout<<"Test 2: \n";
    // stack_pair<int> stackP2 = test1(stackP);
    cout<<"Capacity = "<<stack_pair<int>::CAPACITY<<"\n";
    cout<<"Pushing 15 Items onto stack A\n";
    int i = 0;
    while( i < 15){
        stackP.push_a(i);
        i++;
    }
    cout<<"Size of A = "<<stackP.size_a()<<"\n";


    cout<<"Pushing 15 Items onto stack B\n";
    while( i < 30){
        stackP.push_b(i);
        i++;
    }
    cout<<"Size of B = "<<stackP.size_b()<<"\n";

    stackP.print_stack_pair();

    int c = 14;
    while( c >= 10){
        int popped = stackP.pop_a();
        if(popped == c){
            cout<<"Popped Value "<<popped<<" is Correct\n";
        }
        else{
            cout<<"Popped value isn't correct\n";
        }
        c--;
    }
    cout<<"\n";
    stackP.print_stack_pair();
    int d = 29;
    while( d >= 24){
        int popped = stackP.pop_b();
        if(popped == d){
            cout<<"Popped Value "<<popped<<" is Correct\n";
        }
        else{
            cout<<"Popped value isn't correct\n";
        }
        d--;
    }
    stackP.print_stack_pair();
    //test3
    cout<<"Test 3: \n";
    stackP.print_stack_pair();
    int stackAVal = 100;
    while(!stackP.is_full_a()){
        stackP.push_a(stackAVal);
        stackAVal++;
    }

    int stackBVal = 0;
    while(!stackP.is_full_b()){
        stackP.push_b(stackBVal);
        stackBVal++;
    }
    cout<<"Is A Full? "<<stackP.is_full_a()<<"\n";
    cout<<"Is B Full? "<<stackP.is_full_b()<<"\n";
    stackP.print_stack_pair();

    //Test 4
    cout<<"Test 4: \n";
    cout<<"Pushing 1 more value to test if stack is full.\n";
    stackP.push_a(9000);

    stack_pair<int> stackP4;
    stackP4.print_stack_pair();
    stackP4.pop_a();



    return 0;
}