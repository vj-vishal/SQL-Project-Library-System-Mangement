/*   CRUD Operations
Create: Inserted sample records into the books table.
Read: Retrieved and displayed data from various tables.
Update: Updated records in the employees table.
Delete: Removed records from the members table as needed. */


-- Project Question
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
select * from books;
insert into books
values 
('978-1-60129-456-2' , 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
set sql_safe_updates=0;

-- Task 2: Update an Existing Member's Address
update members 
set member_address = '649 PV St'
where member_id = 'C110';

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table
delete from issued_status
where issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select issued_book_name from issued_status
where issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_member_id, count(issued_book_name) from issued_status
group by issued_member_id 
having count(issued_book_name)>1;

-- CTAS (Create Table As Select)

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

select * from book_issued_cnt;

-- Data Analysis & Findings
-- The following SQL queries were used to address specific questions:

-- Task 7. Retrieve All Books in a Specific Category:
select * from books 
where category = 'Classic';

-- Task 8: Find Total Rental Income by Category:
select category, sum(rental_price), count(*) FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY category;

-- Task 9: List Members Who Registered in the Last 180 Days:
select * from members
where reg_date >= current_date() - interval 180 day;

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
select e.*, b.branch_id, e1.emp_name as manager_name from
employees as e
inner join branch as b 
on e.branch_id = b.branch_id
inner join 
employees as e1
on b.manager_id = e1.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table books_above_cost_7 as
select * from books
where rental_price > 7;

-- Task 12: Retrieve the List of Books Not Yet Returned
select distinct iss.issued_book_name  from 
issued_status as iss
left join 
return_status as rs
on iss.issued_id = rs.issued_id
where rs.return_id is null;



