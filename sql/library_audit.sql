BEGIN EXECUTE IMMEDIATE 'DROP TABLE borrowings CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE books CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE members CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE members (
    member_id NUMBER(10) PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    email_address VARCHAR2(100),
    join_date DATE DEFAULT SYSDATE,
    last_login_date DATE,
    account_status VARCHAR2(20) DEFAULT 'Active'
);

CREATE TABLE books (
    book_id NUMBER(10) PRIMARY KEY,
    book_title VARCHAR2(200) NOT NULL,
    category VARCHAR2(50),
    total_copies NUMBER(5)
);

CREATE TABLE borrowings (
    borrow_id NUMBER(10) PRIMARY KEY,
    member_id NUMBER(10) REFERENCES members(member_id) ON DELETE CASCADE,
    book_id NUMBER(10) REFERENCES books(book_id) ON DELETE CASCADE,
    checkout_date DATE NOT NULL,
    due_date DATE NOT NULL,
    returned_on DATE
);

INSERT INTO members (member_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (1, 'Rahul Sharma', 'rahul.s@email.com', TO_DATE('2023-01-15', 'YYYY-MM-DD'), TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'Active');
INSERT INTO members (member_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (2, 'Sneha Patel', 'sneha.p@email.com', TO_DATE('2021-06-20', 'YYYY-MM-DD'), TO_DATE('2022-01-05', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO members (member_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (3, 'Amit Kumar', 'amit.k@email.com', TO_DATE('2023-11-05', 'YYYY-MM-DD'), TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'Active');
INSERT INTO members (member_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (4, 'Priya Singh', 'priya.s@email.com', TO_DATE('2019-03-10', 'YYYY-MM-DD'), TO_DATE('2020-08-14', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO members (member_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (5, 'Vikram Verma', 'vik.v@email.com', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-04-11', 'YYYY-MM-DD'), 'Active');

INSERT INTO books (book_id, book_title, category, total_copies) VALUES (101, 'Python Crash Course', 'Tech', 5);
INSERT INTO books (book_id, book_title, category, total_copies) VALUES (102, 'Rich Dad Poor Dad', 'Finance', 3);
INSERT INTO books (book_id, book_title, category, total_copies) VALUES (103, 'Clean Code', 'Tech', 8);
INSERT INTO books (book_id, book_title, category, total_copies) VALUES (104, 'The Alchemist', 'Fiction', 10);

INSERT INTO borrowings (borrow_id, member_id, book_id, checkout_date, due_date, returned_on) VALUES (1001, 1, 101, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_DATE('2024-03-24', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO borrowings (borrow_id, member_id, book_id, checkout_date, due_date, returned_on) VALUES (1002, 3, 103, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_DATE('2024-03-29', 'YYYY-MM-DD'), NULL); 
INSERT INTO borrowings (borrow_id, member_id, book_id, checkout_date, due_date, returned_on) VALUES (1003, 5, 104, TO_DATE('2024-04-05', 'YYYY-MM-DD'), TO_DATE('2024-04-19', 'YYYY-MM-DD'), NULL); 
INSERT INTO borrowings (borrow_id, member_id, book_id, checkout_date, due_date, returned_on) VALUES (1004, 2, 102, TO_DATE('2021-12-01', 'YYYY-MM-DD'), TO_DATE('2021-12-15', 'YYYY-MM-DD'), TO_DATE('2021-12-10', 'YYYY-MM-DD'));
INSERT INTO borrowings (borrow_id, member_id, book_id, checkout_date, due_date, returned_on) VALUES (1005, 3, 101, TO_DATE('2023-11-10', 'YYYY-MM-DD'), TO_DATE('2023-11-24', 'YYYY-MM-DD'), TO_DATE('2023-11-20', 'YYYY-MM-DD'));

COMMIT;


-- overdue penalty query (5 rupees flat rate per day)
SELECT 
    m.full_name,
    b.book_title,
    br.due_date,
    TRUNC(SYSDATE) - br.due_date AS days_late,
    (TRUNC(SYSDATE) - br.due_date) * 5 AS penalty_rupees
FROM borrowings br
JOIN members m ON br.member_id = m.member_id
JOIN books b ON br.book_id = b.book_id
WHERE br.returned_on IS NULL
AND br.due_date < TRUNC(SYSDATE);


-- popularity analysis check
SELECT 
    b.book_title,
    b.category,
    COUNT(br.borrow_id) AS times_borrowed
FROM books b
LEFT JOIN borrowings br ON b.book_id = br.book_id
GROUP BY b.book_title, b.category
ORDER BY times_borrowed DESC;


-- deleting inactive accounts untouched since 2023
DELETE FROM members
WHERE account_status = 'Inactive' 
AND last_login_date < TO_DATE('2023-01-01', 'YYYY-MM-DD');

COMMIT;

-- final check
SELECT member_id, full_name, account_status FROM members;

EXIT;
