/* 
    Auto-increment : https://sqlite.org/autoinc.html 
    https://www.tutorialspoint.com/sqlite/sqlite_pragma.htm 
 */
DROP TABLE IF EXISTS truc;
CREATE TABLE truc(
   id INTEGER PRIMARY KEY     AUTOINCREMENT,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);
