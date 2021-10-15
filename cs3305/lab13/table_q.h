#ifndef TABLE_Q_H
#define TABLE_Q_H

#include <cassert>  // Provides assert
#include <cstdlib>  // Provides size_t
#include <cmath>

namespace main_savitch_12A
{
    template <class RecordType>
    class table_q
    {
        public:
            // MEMBER CONSTANT -- See Appendix E if this fails to compile.
            static const std::size_t CAPACITY = 1024;
            // CONSTRUCTOR
            table_q( );
            // MODIFICATION MEMBER FUNCTIONS
            void insert(const RecordType& entry);
            void remove(int key);
            // CONSTANT MEMBER FUNCTIONS
            bool is_present(int key) const;
            void find(int key, bool& found, RecordType& result) const;
            std::size_t size( ) const { return used; }
        protected:
            // MEMBER CONSTANTS -- These are used in the key field of special records.
            static const int NEVER_USED = -1;
            static const int PREVIOUSLY_USED = -2;
            // MEMBER VARIABLES
            RecordType data[CAPACITY];
            std::size_t used;
            // HELPER FUNCTIONS
            std::size_t hash(int key) const;
            std::size_t next_index(int count, std::size_t index) const;
            void find_index(int key, bool& found, std::size_t& index) const;
            bool never_used(std::size_t index) const;
            bool is_vacant(std::size_t index) const;
    };
}
#include "table_q.template" // Include the implementation.

#endif // TABLE_Q_H