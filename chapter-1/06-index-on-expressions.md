!SLIDE
# Indexing on Expressions

!SLIDE
# Frequent Query
## Case-insensitive login
    @@@ sql
            SELECT * FROM users 
            WHERE lower(login) = 'nick';

!SLIDE
# Index on Expression
    @@@ sql
        CREATE INDEX users_login_lower_idx
        ON users (lower(login));

!SLIDE bullets
# ANY Expression
* String Manipulation
* Math
* Dates

!SLIDE
# Unique + Expression
## Email address verification






