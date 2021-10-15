
/*
    File: problem_1.cpp
    Author: Noah Gardner
    Date: 3/1/2020
    Description: 
        The purpose of this file is to implement project 8 page 288 in the text
*/

#include <cstdlib>
#include <string>
#include <vector>
#include <fstream>
#include <iostream>

using namespace std;

class course
{
    public:
        course(){};
        course(string s_name, string c_name, int credits, double grade);
        string lowercase(string input);
        void output();

        string student(){return student_name;};
        string name(){return course_name;};
        int credits(){return course_credits;};
        double grade(){return course_grade;};
    private:
        string student_name;
        string course_name;
        int course_credits;
        double course_grade;
};
class node
{
    public:
        node(course input)
        {
            this->data = input;
            next = NULL;
        };

        course data;
        node* next;
};
class interface
{
    public:
        interface(bool load);

        void exit();

        double student_gpa(string s_name);

        void print_student();
        void print_student(string s_name);

        void add_student();
        void add_student(string s_name);

        void remove_student();
        bool remove_student(string s_name);

        void add_course();
        void add_course(string s_name);
        void add_course(string s_name, string c_name, int c_credits, double c_grade);

        void remove_course();
        bool remove_course(string s_name, string c_name);

        int get_menu_choice();
        void menu();
    private:
        node* head_ptr;
};

// return the lowercase form of an input string
string course::lowercase(string input)
{
    locale loc;
    string output = input;
    for (string::size_type i=0; i<input.length(); i++)
        output[i] = tolower(input[i], loc);
    return output;
}

// course constructor
course::course(string s_name, string c_name, int credits, double grade)
{
    student_name = lowercase(s_name);
    course_name = lowercase(c_name);
    course_credits = credits;
    course_grade = grade;
}

// print course info
void course::output()
{
    cout << "NAME: " << course_name << " | ";
    cout << "CREDITS: " << course_credits << " | ";
    cout << "GRADE: " << course_grade << " \n";
}

// constructor - if load is true, it will attempt to load student
// records from students.txt
interface::interface(bool load)
{
    head_ptr = NULL;
    if (load)
    {
        ifstream input;
        input.open("students.txt");
        for (string line; getline(input, line); )
        {
            string s_name, c_name;
            int credits;
            double grade;

            input >> s_name >> c_name >> credits >> grade;
            add_course(s_name, c_name, credits, grade);
        }
        input.close();
    }
}

// exit the interface and write the data to a file
void interface::exit()
{
    cout << "Writing data to the file... " << "\n";
    ofstream output;
    output.open("students.txt");
    output << "\n";

    // write every course to the file in the form:
    // s_name c_name credits grade
    node *temp = head_ptr;
    while (temp->next != NULL)
    {
        output << temp->data.student() << " ";
        output << temp->data.name() << " ";
        output << temp->data.credits() << " ";
        output << temp->data.grade() << "\n";
        temp = temp->next;
    }

    // last course outside of the while loop
    // no newline character at the end of the file
    output << temp->data.student() << " ";
    output << temp->data.name() << " ";
    output << temp->data.credits() << " ";
    output << temp->data.grade();

    output.close();
}

// calculate the student's gpa
double interface::student_gpa(string s_name)
{
    node *temp = head_ptr;
    double sum = 0;
    int val = 0;

    while (temp != NULL)
    {
        if (temp->data.student() == s_name)
        {
            sum += ((temp->data.grade()/100)*temp->data.credits());
            val += temp->data.credits();
        }
        temp = temp->next;
    }

    if (sum == 0 and val == 0)
    {
        return -1; // no student records
    }

    // gpa is on a 4 scale
    return 4*(sum/val);
}

// print the records of the student by prompting the user for the name
void interface::print_student()
{
    string name;
    cout << "Please enter the name of student: ";
    cin >> name;

    print_student(name);
}

// print the records of the student
void interface::print_student(string s_name)
{
    cout << "NAME: " << s_name << "\n";

    double gpa = student_gpa(s_name);
    if (gpa == -1)
    {
        cout << "Error: student does not exist" << "\n";
        return;
    }
    else
    {
        cout << "GPA: " << student_gpa(s_name) << "\n";
    }

    cout << "COURSES: " << "\n";

    node *temp = head_ptr;
    while (temp != NULL)
    {
        if (temp->data.student() == s_name)
        {
            temp->data.output();
        }
        temp = temp->next;
    }

    cout << "\n";
}

// add a student to the records by prompting the user for the student name
void interface::add_student()
{
    string name;
    cout << "Enter the name of the student to add: ";
    cin >> name;

    add_student(name);
}

// add a student that doesn't exist in the records
void interface::add_student(string s_name)
{
    node *temp = head_ptr;

    // see if student already exists; students are unique based on name
    while (temp != NULL)
    {
        if (temp->data.student() == s_name)
        {
            cout << "Error: student exists.";
            return;
        }
        temp = temp->next;
    }

    // students must be added with a course, and student info alone is not
    // enough info to insert a course
    add_course(s_name);
}

// remove a student after prompting the user for the student name
void interface::remove_student()
{
    string name;
    cout << "Enter the name of the student to add: ";
    cin >> name;

    bool flag = remove_student(name);

    if (flag == true)
    {
        cout << "Student removed.";
    }
    else
    {
        cout << "Error: student not found.";
    }
}

// remove every course associated with a student by their name
bool interface::remove_student(string s_name)
{
    bool flag = false;

    // while the head_ptr points to a course associated with the
    // student, remove it
    while(head_ptr->data.student() == s_name)
    {
        flag = true;
        head_ptr = head_ptr->next;

        // handles the case where every course is associated with the student
        if (head_ptr == NULL)
        {
            return flag;
        }
    }

    node *temp = head_ptr;
    node *prev = NULL;

    while (temp->next != NULL)
    {
        prev = temp;
        temp = temp->next;
        if (temp->data.student() == s_name)
        {
            flag = true;
            prev->next = temp->next;  
        }
    }

    return flag;
}

// add a course by prompting the user for the student name, course name, 
// credits, and grade
void interface::add_course()
{
    string student_name;
    cout << "Enter the name of the student: ";
    cin >> student_name;

    string course_name;
    int course_credits;
    double course_grade;
    
    cout << "Enter the course name: ";
    cin >> course_name;
    cout << "Enter the number of units: ";
    cin >> course_credits;
    cout << "Enter the grade: ";
    cin >> course_grade;

    add_course(student_name, course_name, course_credits, course_grade);
}

// add a course with the student name, 
// and prompt the user for the course name, credits, and grade
void interface::add_course(string s_name)
{
    string course_name;
    int course_credits;
    double course_grade;
    
    cout << "Enter the course name: ";
    cin >> course_name;
    cout << "Enter the number of units: ";
    cin >> course_credits;
    cout << "Enter the grade: ";
    cin >> course_grade;

    add_course(s_name, course_name, course_credits, course_grade);
}

// add a course with the student name, course name, credits, and grade
void interface::add_course(string s_name, string c_name, int c_credits, double c_grade)
{
    node *temp = new node(course(s_name, c_name, c_credits, c_grade));
    temp->next = head_ptr;
    this->head_ptr = temp;
}

// removes a course by prompting the user for the student name and course name
void interface::remove_course()
{
    string student_name;
    cout << "Enter the name of the student: ";
    cin >> student_name;

    string course_name;
    cout << "Enter the course name: ";
    cin >> course_name;

    bool flag = remove_course(student_name, course_name);

    if (flag == true)
    {
        cout << "Course removed.";
    }
    else
    {
        cout << "Error: course not found.";
    }
}

// given the student name and the course name, removes the course
bool interface::remove_course(string s_name, string c_name)
{
    // handles the case where the first course is the course to be removed
    if (head_ptr->data.student() == s_name)
    {
        head_ptr = head_ptr->next;
        return true;
    }

    node *temp = head_ptr;
    node *prev = NULL;

    // find the course to be removed
    while (temp->next != NULL)
    {
        prev = temp;
        temp = temp->next;
        if (temp->data.student() == s_name && temp->data.name() == c_name)
        {
            prev->next = temp->next;
            return true;
        }
    }

    return false;
}

// prompt the user for the menu choice
int interface::get_menu_choice()
{
    int choice;

    cout << "1. Add student " << "\n";
    cout << "2. Remove student " << "\n";
    cout << "3. Add course " << "\n";
    cout << "4. Remove course" << "\n";
    cout << "5. Display student's information " << "\n";
    cout << "6. Exit " << "\n";

    while(true)
    {
        cout << "Enter choice: ";
        cin >> choice;
        if (choice<1 || choice>6)
        {
            cout << "Invalid choice." << "\n";
        }
        else
            return choice;
    }
    return choice;
}

// case statement to handle the menu
void interface::menu()
{
    int choice;
    while (true)
    {
        choice = get_menu_choice();
        switch(choice)
        {
            case 1:
                add_student();
                break;
            case 2:
                remove_student();
                break;
            case 3:
                add_course();
                break;
            case 4:
                remove_course();
                break;
            case 5:
                print_student();
                break;
            case 6:
                exit();
                return;
        }
        cout << "\n\n";
    }
}

int main()
{
    interface i(false);

    cout << "Adding student bob and his courses.." << "\n";
    i.add_course("BOB", "math", 4, 100); // combinations of upper- and lower-case work
    i.add_course("bob", "english", 3, 85);
    i.add_course("bob", "science", 4, 75);
    i.print_student("bob");

    cout << "Adding student jane and her courses.." << "\n";
    i.add_course("jane", "math", 4, 70);
    i.add_course("jane", "english", 3, 90);
    i.print_student("jane");

    cout << "Removing bob's math course..." << "\n";
    bool flag = i.remove_course("bob", "math");
    if (flag == true)
    {
        cout << "Course removed." << "\n";
    }
    else
    {
        cout << "Error: course not found." << "\n";
    }
    i.print_student("bob");

    cout << "Removing student jane..." << "\n";
    flag = i.remove_student("jane");
    if (flag == true)
    {
        cout << "Student removed." << "\n";
    }
    else
    {
        cout << "Error: student not found." << "\n";
    }
    i.print_student("jane");

    cout << "Exiting the interface..." << "\n";
    i.exit();

    cout << "Creating a new interface which will load the data..." << "\n\n";
    interface i2(true);

    cout << "Interact with the new interface using the menu: " << "\n";
    i2.menu();
    return 0;
}