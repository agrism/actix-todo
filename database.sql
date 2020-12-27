drop table if exists todo_items;
drop table if exists todo_list;

create table todo_list(
    id serial primary key,
    title varchar(150)
)

create table todo_list(
    id serial primary key,
    title varchar(150) not null,
    checked boolean not null, default false,
    list_id integer not null,
    foreign key (list_id) reference todo_list(id))
)

insert into todo_list (title) values ("list 1"), ("list 2");
insert into todo_items (tile, list_id) values ("connect to db", 1), ("do queries",1);
