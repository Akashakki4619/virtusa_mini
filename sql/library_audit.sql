-- Format SQL*Plus output for better readability
SET LINESIZE 150;
SET PAGESIZE 100;
COLUMN full_name FORMAT A20;
COLUMN email_address FORMAT A30;
COLUMN book_title FORMAT A30;
COLUMN category FORMAT A15;
COLUMN account_status FORMAT A15;

BEGIN EXECUTE IMMEDIATE 'DROP TABLE issuedbooks CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE books CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE students CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE students (
    student_id NUMBER(10) PRIMARY KEY,
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

CREATE TABLE issuedbooks (
    borrow_id NUMBER(10) PRIMARY KEY,
    student_id NUMBER(10) REFERENCES students(student_id) ON DELETE CASCADE,
    book_id NUMBER(10) REFERENCES books(book_id) ON DELETE CASCADE,
    issue_date DATE NOT NULL,
    return_date DATE
);

INSERT INTO students (student_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (1, 'Rahul Sharma', 'rahul.s@email.com', TO_DATE('2023-01-15', 'YYYY-MM-DD'), TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'Active');
INSERT INTO students (student_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (2, 'Sneha Patel', 'sneha.p@email.com', TO_DATE('2021-06-20', 'YYYY-MM-DD'), TO_DATE('2022-01-05', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO students (student_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (3, 'Amit Kumar', 'amit.k@email.com', TO_DATE('2023-11-05', 'YYYY-MM-DD'), TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'Active');
INSERT INTO students (student_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (4, 'Priya Singh', 'priya.s@email.com', TO_DATE('2019-03-10', 'YYYY-MM-DD'), TO_DATE('2020-08-14', 'YYYY-MM-DD'), 'Inactive');
INSERT INTO students (student_id, full_name, email_address, join_date, last_login_date, account_status) VALUES (5, 'Vikram Verma', 'vik.v@email.com', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-04-11', 'YYYY-MM-DD'), 'Active');

INSERT INTO books (book_id, book_title, category, total_copies) VALUES (101, 'Python Crash Course', 'Tech', 5);
INSERT INTO books (book_id, book_title, category, total_copies) VALUES (102, 'Rich Dad Poor Dad', 'Finance', 3);
INSERT INTO books (book_id, book_title, category, total_copies) VALUES (103, 'Clean Code', 'Tech', 8);
INSERT INTO books (book_id, book_title, category, total_copies) VALUES (104, 'The Alchemist', 'Fiction', 10);

INSERT INTO issuedbooks (borrow_id, student_id, book_id, issue_date, return_date) VALUES (1001, 1, 101, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO issuedbooks (borrow_id, student_id, book_id, issue_date, return_date) VALUES (1002, 3, 103, TO_DATE('2024-03-15', 'YYYY-MM-DD'), NULL); 
INSERT INTO issuedbooks (borrow_id, student_id, book_id, issue_date, return_date) VALUES (1003, 5, 104, TO_DATE('2024-04-05', 'YYYY-MM-DD'), NULL); 
INSERT INTO issuedbooks (borrow_id, student_id, book_id, issue_date, return_date) VALUES (1004, 2, 102, TO_DATE('2021-12-01', 'YYYY-MM-DD'), TO_DATE('2021-12-10', 'YYYY-MM-DD'));
INSERT INTO issuedbooks (borrow_id, student_id, book_id, issue_date, return_date) VALUES (1005, 3, 101, TO_DATE('2023-11-10', 'YYYY-MM-DD'), TO_DATE('2023-11-20', 'YYYY-MM-DD'));

COMMIT;


-- overdue penalty query (5 rupees flat rate per day)
SELECT 
    s.full_name,
    b.book_title,
    br.issue_date,
    GREATEST(TRUNC(SYSDATE) - (br.issue_date + 14), 0) AS days_late,
    GREATEST(TRUNC(SYSDATE) - (br.issue_date + 14), 0) * 5 AS penalty_rupees
FROM issuedbooks br
JOIN students s ON br.student_id = s.student_id
JOIN books b ON br.book_id = b.book_id
WHERE br.return_date IS NULL
AND br.issue_date < TRUNC(SYSDATE) - 14
ORDER BY penalty_rupees DESC;


-- popularity analysis check (by category)
SELECT 
    b.category,
    COUNT(br.borrow_id) AS times_borrowed
FROM books b
JOIN issuedbooks br ON b.book_id = br.book_id
GROUP BY b.category
ORDER BY times_borrowed DESC;


-- deleting inactive accounts (not borrowed in 3 years)
DELETE FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM issuedbooks ib
    WHERE ib.student_id = s.student_id
    AND ib.issue_date >= ADD_MONTHS(SYSDATE, -36)
);

COMMIT;

-- final check
SELECT student_id, full_name, account_status FROM students;
