CREATE DATABASE CozyBookStore;
USE CozyBookStore;

CREATE TABLE employees (
employee_id INT PRIMARY KEY,
NAME VARCHAR(100) NOT NULL,
employment_type VARCHAR(20) NOT NULL, 
trainer_id INT,
FOREIGN KEY (trainer_id) REFERENCES employees(employee_id),
CHECK(employment_type IN('f','p')));

CREATE TABLE customer_info(
phone_number BIGINT PRIMARY KEY,
NAME VARCHAR(100) NOT NULL);
CREATE TABLE customers(
customer_id INT PRIMARY KEY,
phone_number BIGINT,
FOREIGN KEY (phone_number) REFERENCES customer_info(phone_number));

CREATE TABLE subscribed_customers(
customer_id INT PRIMARY KEY,
discount_percentage DECIMAL(2,2) NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id));

CREATE TABLE products(
product_id INT PRIMARY KEY,
price DECIMAL(5,2) NOT NULL,
stock_quantity INT NOT NULL DEFAULT 0,
category VARCHAR(50) NOT NULL,
CHECK (category IN("toy","stationery","vinyl","cds","books")));

CREATE TABLE sales(
sale_id INT PRIMARY KEY,
customer_id INT,
employee_id INT,
sale_date DATE NOT null,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (employee_id) REFERENCES employees(employee_id));

CREATE TABLE sales_products(
sale_id INT,
product_id INT,
quantity INT NOT NULL,
PRIMARY KEY(sale_id,product_id),
FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
FOREIGN KEY (product_id) REFERENCES products(product_id));

CREATE TABLE full_time_employee(
employee_id INT PRIMARY KEY,
salary BIGINT NOT NULL,
FOREIGN KEY (employee_id) REFERENCES employees(employee_id));

CREATE TABLE part_time_employee(
employee_id INT PRIMARY KEY,
hourly_rate INT NOT NULL,
FOREIGN KEY(employee_id) REFERENCES employees(employee_id));

CREATE TABLE toys(
product_id int PRIMARY KEY,
toy_type VARCHAR(20),
CHECK (toy_type IN ("b","l")),
FOREIGN KEY(product_id) REFERENCES products(product_id));

CREATE TABLE language_games(
product_id INT PRIMARY KEY,
LANGUAGE VARCHAR(20) NOT NULL,
FOREIGN KEY(product_id) REFERENCES toys(product_id));

CREATE TABLE board_games(
product_id INT PRIMARY KEY,
age_recommendation VARCHAR(20) NOT NULL,
FOREIGN KEY (product_id) REFERENCES toys(product_id),
CHECK (age_recommendation IN ('3+', '5+', '7+', '10+', '12+', '16+', '18+', '7-12', '10-14')));

CREATE TABLE stationery(
product_id INT PRIMARY KEY,
stationery_type VARCHAR(20),
FOREIGN KEY (product_id) REFERENCES products(product_id),
CHECK (stationery_type IN("s","a")));

CREATE TABLE school_stationery(
product_id INT PRIMARY KEY,
item_type VARCHAR(100) NOT NULL, 
FOREIGN KEY (product_id) REFERENCES stationery(product_id));

CREATE TABLE art_supplies(
product_id INT PRIMARY KEY,
material VARCHAR(100) NOT NULL,
FOREIGN KEY (product_id) REFERENCES stationery(product_id));

CREATE TABLE vinyl(
product_id INT PRIMARY KEY,
artist VARCHAR(100) NOT NULL,
album_name VARCHAR(100) NOT NULL,
genre VARCHAR(50) NOT NULL,
FOREIGN KEY (product_id) REFERENCES products(product_id));

CREATE TABLE cds(
product_id INT PRIMARY KEY,
artist VARCHAR(100) NOT NULL,
album_name VARCHAR(100) NOT NULL,
genre VARCHAR(50) NOT NULL,
FOREIGN KEY (product_id) REFERENCES products(product_id));

CREATE TABLE book_info(
isbn CHAR(13) PRIMARY KEY,
title VARCHAR(100) NOT NULL,
publisher VARCHAR(100) NOT NULL,
book_type VARCHAR(20) NOT NULL,
nobel_prize_winner VARCHAR(20) NOT NULL,
new_york_times_best_seller VARCHAR(20) NOT NULL,
CHECK (book_type IN("f","n","t")),
CHECK (nobel_prize_winner IN("y","n")),
CHECK (new_york_times_best_seller IN ("y","n")));

CREATE TABLE author_awards(
author_award_id INT PRIMARY KEY,
author_award_name VARCHAR(100) NOT NULL,
author_year_won YEAR NOT NULL);

CREATE TABLE authors(
author_id INT PRIMARY KEY,
author_name VARCHAR(100) NOT NULL,
author_nationality VARCHAR(100) NOT NULL,
author_birth_year YEAR NOT NULL,
author_award_id INT,
FOREIGN KEY (author_award_id) REFERENCES author_awards(author_award_id));

CREATE TABLE books(
product_id int PRIMARY KEY,
isbn CHAR(13),
author_id INT, 
FOREIGN KEY (product_id) REFERENCES products(product_id),
FOREIGN KEY (isbn) REFERENCES book_info(isbn),
FOREIGN KEY (author_id) REFERENCES authors(author_id));

CREATE TABLE textbooks(
isbn CHAR(13) PRIMARY KEY,
SUBJECT VARCHAR(20) NOT NULL,
grade_level VARCHAR(20) NOT NULL,
FOREIGN KEY (isbn) REFERENCES book_info(isbn));

CREATE TABLE non_fiction_books(
isbn CHAR(13) PRIMARY KEY,
dewey_category VARCHAR(10) NOT NULL,
FOREIGN KEY (isbn) REFERENCES book_info(isbn));

CREATE TABLE fiction_books(
isbn CHAR(13) PRIMARY KEY,
genre VARCHAR(50) NOT NULL,
FOREIGN KEY (isbn) REFERENCES book_info(isbn));

CREATE TABLE nobel_prize_winner(
isbn CHAR(13) PRIMARY KEY,
year_won YEAR NOT NULL,
FOREIGN KEY (isbn) REFERENCES book_info(isbn));

CREATE TABLE new_york_times_best_seller(
isbn CHAR(13) PRIMARY KEY,
best_seller_rank INT NOT NULL,
year_won YEAR NOT NULL,
FOREIGN KEY (isbn) REFERENCES book_info(isbn));

DELIMITER //

CREATE TRIGGER reduce_stock_quantity
BEFORE INSERT ON sales_products
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock_quantity = stock_quantity - NEW.quantity
  WHERE product_id = NEW.product_id;
END;
//

DELIMITER ;


INSERT INTO employees (employee_id, name, employment_type, trainer_id)
VALUES 
(1, 'Alice Johnson', 'f', NULL),
(2, 'Bob Smith', 'p', 1),
(3, 'Clara Lee', 'f', 1),
(4, 'John Carter', 'p', NULL);
  
INSERT INTO customer_info (phone_number, name)
VALUES 
(9876543210, 'Emily Brown'),
(8765432190, 'David Green'),
(2004522801, 'Juliette Dubois'),
(7467920283, 'Sophie Boucher');

INSERT INTO customers (customer_id, phone_number)
VALUES 
(101, 9876543210),
(102, 8765432190),
(103, 2004522801),
(104, 7467920283);

INSERT INTO subscribed_customers (customer_id, discount_percentage)
VALUES 
(101, 0.15),
(102, 0.10);

INSERT INTO products (product_id, price, stock_quantity, category) VALUES
(101, 14.99, 50, 'toy'),  
(102, 12.49, 60, 'toy'),   
(201, 3.99, 100, 'stationery'), 
(202, 7.99, 80, 'stationery'),  
(301, 22.99, 25, 'vinyl'),
(302, 24.50, 20, 'vinyl'),
(303, 21.75, 18, 'vinyl'),
(304, 23.00, 15, 'vinyl'),
(305, 25.00, 12, 'vinyl'),
(311, 11.99, 30, 'cds'),
(312, 12.49, 35, 'cds'),
(313, 13.99, 40, 'cds'),
(314, 14.50, 28, 'cds'),
(315, 12.00, 33, 'cds'),
(401, 15.99, 45, 'books'),
(402, 16.99, 40, 'books'),
(403, 18.50, 35, 'books'),
(404, 19.99, 30, 'books'),
(405, 13.75, 25, 'books'),
(406, 12.50, 38, 'books'),
(407, 17.25, 32, 'books'),
(408, 14.99, 34, 'books'),
(409, 21.00, 28, 'books'),
(410, 15.49, 36, 'books');

INSERT INTO sales (sale_id, customer_id, employee_id, sale_date)
VALUES 
(301, 101, 2, '2025-04-10'),
(302, 102, 3, '2025-04-12');

INSERT INTO sales_products (sale_id, product_id, quantity)
VALUES 
(301, 201, 2), 
(301, 202, 1); 

INSERT INTO full_time_employee (employee_id, salary)
VALUES 
(1, 70000),
(3, 68000);

INSERT INTO part_time_employee (employee_id, hourly_rate)
VALUES 
(2, 20),
(4, 30);

INSERT INTO toys (product_id, toy_type) VALUES 
(101, 'b'),
(102, 'l');

INSERT INTO language_games (product_id, language)
VALUES 
(102, 'French');

INSERT INTO board_games (product_id, age_recommendation)
VALUES 
(101, '7+');

INSERT INTO stationery (product_id, stationery_type) VALUES 
(201, 's'),
(202, 'a');

INSERT INTO school_stationery (product_id, item_type) VALUES (201, 'Notebook');

INSERT INTO art_supplies (product_id, material) VALUES (202, 'Watercolors');

INSERT INTO vinyl (product_id, artist, album_name, genre) VALUES
(301, 'The Beatles', 'Abbey Road', 'Rock'),
(302, 'Pink Floyd', 'The Dark Side of the Moon', 'Progressive Rock'),
(303, 'Fleetwood Mac', 'Rumours', 'Pop Rock'),
(304, 'Nirvana', 'Nevermind', 'Grunge'),
(305, 'David Bowie', 'The Rise and Fall of Ziggy Stardust', 'Glam Rock');

INSERT INTO cds (product_id, artist, album_name, genre) VALUES
(311, 'Adele', '21', 'Pop'),
(312, 'Taylor Swift', '1989', 'Pop'),
(313, 'Ed Sheeran', 'Divide', 'Pop'),
(314, 'Imagine Dragons', 'Evolve', 'Alternative Rock'),
(315, 'Bruno Mars', '24K Magic', 'R&B');

INSERT INTO book_info (isbn, title, publisher, book_type, nobel_prize_winner, new_york_times_best_seller) VALUES
('9780141182636', '1984', 'Penguin Classics', 'f', 'n', 'y'),
('9780439139601', 'Harry Potter and the Goblet of Fire', 'Scholastic', 'f', 'n', 'y'),
('9780062316097', 'Sapiens: A Brief History of Humankind', 'Harper', 'n', 'n', 'y'),
('9780131103627', 'The C Programming Language', 'Prentice Hall', 't', 'n', 'n'),
('9780385490818', 'The Alchemist', 'HarperOne', 'f', 'n', 'y'),
('9780143039433', 'The Diary of a Young Girl', 'Penguin Books', 'n', 'y', 'y'),
('9780525555370', 'Becoming', 'Crown Publishing Group', 'n', 'n', 'y'),
('9780747532743', 'Harry Potter and the Philosopher\'s Stone', 'Bloomsbury', 'f', 'n', 'y'),
('9780262033848', 'Introduction to Algorithms', 'MIT Press', 't', 'n', 'n'),
('9780307279460', 'The Omnivore\'s Dilemma', 'Penguin Press', 'n', 'n', 'y');

INSERT INTO author_awards (author_award_id, author_award_name, author_year_won) VALUES
(1, 'Pulitzer Prize', 1994),
(2, 'Man Booker Prize', 2005),
(3, 'Hugo Award', 1984),
(4, 'National Book Award', 2018),
(5, 'Nobel Prize in Literature', 1949);

INSERT INTO authors (author_id, author_name, author_nationality, author_birth_year, author_award_id) VALUES
(1, 'George Orwell', 'British', 1903, 5),
(2, 'J.K. Rowling', 'British', 1965, 2),
(3, 'Yuval Noah Harari', 'Palestinian', 1976, NULL),
(4, 'Brian Kernighan', 'Canadian', 1942, 1),
(5, 'Paulo Coelho', 'Brazilian', 1947, NULL),
(6, 'Anne Frank', 'German-Dutch', 1929, NULL),
(7, 'Michelle Obama', 'American', 1964, 4),
(8, 'Thomas H. Cormen', 'American', 1956, NULL),
(9, 'Michael Pollan', 'American', 1955, NULL);

INSERT INTO books (product_id, isbn, author_id) VALUES
(401, '9780141182636', 1),
(402, '9780439139601', 2),
(403, '9780062316097', 3),
(404, '9780131103627', 4),
(405, '9780385490818', 5),
(406, '9780143039433', 6),
(407, '9780525555370', 7),
(408, '9780747532743', 2),
(409, '9780262033848', 8),
(410, '9780307279460', 9);

INSERT INTO textbooks (isbn, subject, grade_level) VALUES
('9780131103627', 'Computer Science', 'University'),
('9780262033848', 'Algorithms', 'University');

INSERT INTO non_fiction_books (isbn, dewey_category) VALUES
('9780062316097', '909'),
('9780143039433', '940.53'),
('9780525555370', '921'),
('9780307279460', '394');

INSERT INTO fiction_books (isbn, genre) VALUES
('9780141182636', 'Dystopian'),
('9780439139601', 'Fantasy'),
('9780385490818', 'Philosophical Fiction'),
('9780747532743', 'Fantasy');

INSERT INTO nobel_prize_winner (isbn, year_won) VALUES
('9780143039433', 1947);

INSERT INTO new_york_times_best_seller (isbn, best_seller_rank, year_won) VALUES
('9780141182636', 4, 1950),
('9780439139601', 1, 2000),
('9780062316097', 3, 2015),
('9780385490818', 2, 2001),
('9780143039433', 5, 1952),
('9780525555370', 1, 2018),
('9780747532743', 1, 1997),
('9780307279460', 6, 2006);
