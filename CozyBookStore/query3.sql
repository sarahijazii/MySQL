UPDATE products
SET price = price * 1.15
WHERE product_id IN (
    SELECT b.product_id
    FROM books b
    JOIN book_info bi ON b.isbn = bi.isbn
    JOIN fiction_books fb ON bi.isbn = fb.isbn
    JOIN new_york_times_best_seller ny ON bi.isbn = ny.isbn
    WHERE fb.genre LIKE '%fantasy%'
);
