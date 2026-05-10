SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS Livestream_DB;
CREATE DATABASE Livestream_DB;
USE Livestream_DB;

-- TẠO CÁC BẢNG

CREATE TABLE Creator (
    creator_id       VARCHAR(5)   PRIMARY KEY,
    creator_name     VARCHAR(100) NOT NULL,
    creator_email    VARCHAR(100),
    creator_phone    VARCHAR(15),
    creator_platform VARCHAR(50)
);

CREATE TABLE Studio (
    studio_id       VARCHAR(5)    PRIMARY KEY,
    studio_name     VARCHAR(100)  NOT NULL,
    studio_location VARCHAR(100)  NOT NULL,
    hourly_price    DECIMAL(10,2) NOT NULL,
    studio_status   VARCHAR(20)   NOT NULL
);

CREATE TABLE LiveSession (
    session_id     INT          PRIMARY KEY AUTO_INCREMENT,
    creator_id     VARCHAR(5)   NOT NULL,
    studio_id      VARCHAR(5)   NOT NULL,
    session_date   DATE         NOT NULL,
    duration_hours INT          NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES Creator(creator_id),
    FOREIGN KEY (studio_id) REFERENCES Studio(studio_id)
);

CREATE TABLE Payment (
    payment_id     INT          PRIMARY KEY AUTO_INCREMENT,
    session_id     INT          NOT NULL,
    payment_method VARCHAR(50)  NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date   DATE         NOT NULL,
    FOREIGN KEY (session_id) REFERENCES LiveSession(session_id)
);

-- CHÈN DỮ LIỆU

INSERT INTO Creator VALUES
('CR01', 'Nguyen Van A', 'a@live.com', '0901111111', 'Tiktok'),
('CR02', 'Tran Thi B', 'b@live.com', '0902222222', 'Youtube'),
('CR03', 'Le Minh C', 'c@live.com', '0903333333', 'Facebook'),
('CR04', 'Pham Thi D', 'd@live.com', '0904444444', 'Tiktok'),
('CR05', 'Vu Hoang E', 'e@live.com', '0905555555', 'Shopee live');

INSERT INTO Studio VALUES
('ST01', 'Studio A', 'Ha Noi', 20.00, 'Available'),
('ST02', 'Studio B', 'HCM', 25.00, 'Available'),
('ST03', 'Studio C', 'Danang', 30.00, 'Booked'),
('ST04', 'Studio D', 'Ha Noi', 22.00, 'Available'),
('ST05', 'Studio E', 'Can Tho', 18.00, 'Maintenance');

INSERT INTO LiveSession VALUES
(1, 'CR01', 'ST01', '2025-05-01', 3),
(2, 'CR02', 'ST02', '2025-05-02', 4),
(3, 'CR03', 'ST03', '2025-05-03', 2),
(4, 'CR01', 'ST04', '2025-05-04', 5),
(5, 'CR05', 'ST02', '2025-05-05', 1);

INSERT INTO Payment VALUES
(1, 1, 'Cash', 60.00, '2025-05-01'),
(2, 2, 'Credit Card', 100.00, '2025-05-02'),
(3, 3, 'Bank Transfer', 60.00, '2025-05-03'),
(4, 4, 'Credit Card', 110.00, '2025-05-04'),
(5, 5, 'Cash', 25.00, '2025-05-05');

-- CẬP NHẬT DỮ LIỆU

UPDATE Creator 
SET creator_platform = 'YouTube' 
WHERE creator_id = 'CR03';

UPDATE Studio 
SET studio_status = 'Available', 
    hourly_price = hourly_price * 0.9
WHERE studio_id = 'ST05';

-- XÓA DỮ LIỆU

DELETE FROM Payment 
WHERE payment_method = 'Cash' 
  AND payment_date < '2025-05-03';

-- TRUY VẤN CƠ BẢN

SELECT * FROM Studio 
WHERE studio_status = 'Available' AND hourly_price > 20;

SELECT creator_name, creator_phone 
FROM Creator 
WHERE creator_platform = 'Tiktok';

SELECT studio_id, studio_name, hourly_price 
FROM Studio 
ORDER BY hourly_price DESC;

SELECT * FROM Payment 
WHERE payment_method = 'Credit Card' 
LIMIT 3;

SELECT creator_id, creator_name 
FROM Creator 
LIMIT 2 OFFSET 2;

-- TRUY VẤN NÂNG CAO

SELECT 
    ls.session_id,
    c.creator_name,
    s.studio_name,
    ls.duration_hours,
    p.payment_amount
FROM LiveSession ls
JOIN Creator c ON ls.creator_id = c.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
LEFT JOIN Payment p ON ls.session_id = p.session_id;

SELECT 
    s.studio_id, 
    s.studio_name, 
    COUNT(ls.session_id) AS so_lan_su_dung
FROM Studio s 
LEFT JOIN LiveSession ls ON s.studio_id = ls.studio_id
GROUP BY s.studio_id, s.studio_name;

SELECT 
    payment_method, 
    SUM(payment_amount) AS tong_doanh_thu
FROM Payment 
GROUP BY payment_method;

SELECT 
    c.creator_name, 
    COUNT(ls.session_id) AS so_session
FROM Creator c 
JOIN LiveSession ls ON c.creator_id = ls.creator_id
GROUP BY c.creator_name
HAVING so_session >= 2;

SELECT * FROM Studio 
WHERE hourly_price > (SELECT AVG(hourly_price) FROM Studio);

