create table todo_list (
    id serial primary key,
    title varchar(150)
);

create table todo_item (
    id serial primary key,
    title varchar(150) not null,
    checked boolean not null default false,
    list id integer not null,
    foreign key (list_id) reference todo_list(id)
);