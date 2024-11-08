CREATE TABLE IF NOT EXISTS Library_information(
		Library_id TEXT PRIMARY KEY,
		Library_name VARCHAR NOT NULL,
		Library_address VARCHAR NOT NULL
);

COPY
	Library_information
FROM
	'F:\Bootcamp_Pacmann\[4] Fundamental SQL\Exercise Mentoring\Library_information.csv'
DELIMITER ','
CSV
HEADER;


--------------------------------------------
CREATE TABLE IF NOT EXISTS Book_information(
		Book_id TEXT PRIMARY KEY,
		Book_title VARCHAR NOT NULL,
		Book_authors VARCHAR NOT NULL
);

COPY
	Book_information
FROM
	'F:\Bootcamp_Pacmann\[4] Fundamental SQL\Exercise Mentoring\Book_information.csv'
DELIMITER ','
CSV
HEADER;


--------------------------------------------
CREATE TABLE IF NOT EXISTS Library_book(
		Library_order_id SERIAL PRIMARY KEY,
		Library_id TEXT NOT NULL,
		Book_id TEXT NOT NULL,
		Available_quantity INT NOT NULL CHECK(Available_quantity >= 0),
		FOREIGN KEY (Library_id) REFERENCES Library_information(Library_id),
		FOREIGN KEY (Book_id) REFERENCES Book_information(Book_id)
);

COPY
	Library_book
FROM
	'F:\Bootcamp_Pacmann\[4] Fundamental SQL\Exercise Mentoring\Library_Book.csv'
DELIMITER ','
CSV
HEADER;


--------------------------------------------
CREATE TABLE IF NOT EXISTS Category_name(
		Category_id INT PRIMARY KEY,
		Category_name VARCHAR NOT NULL UNIQUE
);

COPY
	Category_name
FROM
	'F:\Bootcamp_Pacmann\[4] Fundamental SQL\Exercise Mentoring\Category_name.csv'
DELIMITER ','
CSV
HEADER;


--------------------------------------------
CREATE TABLE IF NOT EXISTS Book_category(
		Book_id TEXT,
		Category_id INT,
		PRIMARY KEY (Book_id, Category_id),
		FOREIGN KEY (Book_id) REFERENCES Book_information(Book_id),
		FOREIGN KEY (Category_id) REFERENCES Category_name(Category_id)
);

COPY
	Book_category
FROM
	'F:\Bootcamp_Pacmann\[4] Fundamental SQL\Exercise Mentoring\Book_Category.csv'
DELIMITER ','
CSV
HEADER;


--------------------------------------------
CREATE TABLE IF NOT EXISTS User_information(
		User_id INT PRIMARY KEY,
		User_name VARCHAR NOT NULL UNIQUE,
		User_email VARCHAR NOT NULL UNIQUE,
		User_password TEXT NOT NULL,
		Register_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COPY
	User_information
FROM
	'F:\Bootcamp_Pacmann\[4] Fundamental SQL\Exercise Mentoring\User_information.csv'
DELIMITER ','
CSV
HEADER;


--------------------------------------------
CREATE TABLE IF NOT EXISTS Loan_information(
		Loan_id SERIAL PRIMARY KEY,
		User_id INT NOT NULL,
		Book_id TEXT NOT NULL,
		Library_id TEXT NOT NULL,
		Loan_date DATE NOT NULL,
		Due_date DATE NOT NULL,
		Return_date DATE,
		FOREIGN KEY (User_id) REFERENCES User_information(User_id),
		FOREIGN KEY (Book_id) REFERENCES Book_information(Book_id),
		FOREIGN KEY (Library_id) REFERENCES Library_information(Library_id)
);

COPY
	Loan_information
FROM
	'F:\Bootcamp_Pacmann\[4] Fundamental SQL\Exercise Mentoring\Loan_information.csv'
DELIMITER ','
CSV
HEADER;


--------------------------------------------
CREATE TABLE IF NOT EXISTS Hold_information(
		Hold_id SERIAL PRIMARY KEY,
		User_id INT NOT NULL,
		Book_id TEXT NOT NULL,
		Library_id TEXT NOT NULL,
		Hold_date DATE NOT NULL,
		Expiry_date DATE NOT NULL,
		Borrow_status VARCHAR NOT NULL,
		FOREIGN KEY (User_id) REFERENCES User_information(User_id),
		FOREIGN KEY (Book_id) REFERENCES Book_information(Book_id),
		FOREIGN KEY (Library_id) REFERENCES Library_information(Library_id)
);

COPY
	Hold_information
FROM
	'F:\Bootcamp_Pacmann\[4] Fundamental SQL\Exercise Mentoring\Hold_information.csv'
DELIMITER ','
CSV
HEADER;

--------------------------------------------
SELECT * FROM library_information li; 
SELECT * FROM book_information bi; 
SELECT * FROM library_book lb; 
SELECT * FROM category_name cn; 
SELECT * FROM book_category bc; 
SELECT * FROM user_information ui; 
SELECT * FROM loan_information li; 
SELECT * FROM hold_information hi 
--------------------------------------------

-- Question 1
CREATE OR REPLACE VIEW borrowed_book AS
SELECT 	bi.book_title AS title,
		li2.library_name,
		cn.category_name 
FROM loan_information li
JOIN book_information bi USING(book_id)
JOIN library_information li2 USING(library_id)
JOIN book_category bc USING(book_id)
JOIN category_name cn USING(category_id);

SELECT 	bb.category_name,
		COUNT(bb.category_name) AS total_borrowed
FROM borrowed_book bb
GROUP BY bb.category_name
ORDER BY total_borrowed DESC;

-- Question 2
SELECT 	bb.title,
		COUNT(bb.title) AS total_borrowed
FROM borrowed_book bb
WHERE bb.category_name = 'Political'
GROUP BY bb.title
ORDER BY total_borrowed DESC;

-- Question 3
SELECT DISTINCT li.user_id,
		ui.user_name 
FROM loan_information li 
JOIN user_information ui USING(user_id)
WHERE li.return_date IS NULL
ORDER BY li.user_id ASC;

-- Question 4
SELECT 	li.user_id,
		ui.user_name,
		COUNT(ui.user_name) AS count_borrowing
FROM loan_information li 
JOIN user_information ui USING(user_id)
GROUP BY li.user_id, ui.user_name 
ORDER BY count_borrowing DESC, ui.user_name ASC;

-- Question 5
SELECT 	li.library_id,
		li2.library_name, 
		COUNT(li.library_id) AS count_library 
FROM loan_information li
JOIN library_information li2 USING(library_id)
GROUP BY li.library_id, li2.library_name 
ORDER BY count_library ASC, li2.library_name ASC;
