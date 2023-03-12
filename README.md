## Задание

Напишите класс/модуль для реализации транзакций в perl в конкурентной среде из нескольких процессов,
например, чтобы можно было откатить изменения сделанные несколькими функциями или сохранить
эти изменения пачкой, учитывая одновременный доступ из нескольких процессов.
Задача не про БД а про атомарные операции

## Решение

### DDL

```
CREATE TABLE `user` (
    `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    `status` BOOLEAN,
    PRIMARY KEY `mid`(`id`)
);
```

```
CREATE TABLE `log` (
    `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` MEDIUMINT UNSIGNED NOT NULL,
    `updated` TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY `mid` (`id`),
    KEY `uid` (`user_id`)
);
```