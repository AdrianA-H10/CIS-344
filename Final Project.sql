create table patients (
	patient_id int not null unique auto_increment primary key,
    patient_name varchar(45) not null,
    age int not null,
    admission_date date,
    discharge_date date
);

create table doctors (
	doctor_id int not null unique auto_increment primary key,
    doctor_name varchar(45) not null,
    email varchar(45) not null,
    phone_num varchar(12),
    specialty varchar(45)
);

create table appointments (
	appointments_id int not null unique auto_increment primary key,
    Fpatient_id int not null,
    Fdoctor_id int not null,
    appointment_date date not null,
    appointment_time decimal (10,2) not null,
    foreign key (Fpatient_id) references patients(patient_id),
    foreign key (Fdoctor_id) references doctors(doctor_id)
);

/* these first two lines simply change the auto increment starting point, creating the illusion of proper IDs */
/* like the kind you'd see in ID cards */
alter table patients auto_increment=174002;
alter table doctors auto_increment=238014;

insert into patients (patient_name, age, admission_date, discharge_date)
values ("Tom Jones", 83, '2023-02-03', '2023-02-07'),
("Kyle Raft", 22, '2023-01-12', '2023-01-14'),
("Garry Pierce", 39, '2023-09-30', '2023-10-08'),
("Johanna Karlson", 19, '2023-11-23', '2023-11-30'),
("Maria Suarez", 42, '2023-07-04', '2023-07-08');

insert into doctors (doctor_name, email, phone_num, specialty)
values ("Josh Dominic", "DominicJones@email.com", "3409021344", "Orthopedics"),
("Penelope Rodrigez", "PenelopeR@email.com", "8285429122", "General Physician"),
("Carla Page", "Carla-Page301@email.com", "9243222390", "Neurology"),
("Maxwell Cannon", "Cannon-B-Maxwell@email.com", "6572788822", "Pediatrics"),
("Louie Marshall", "MarshLou@email.com", "4873614503", "Dermatology");

delimiter $
CREATE PROCEDURE `AppointmentSchedule`(in p_id int, in d_id int, in apt_date date, in apt_time decimal(10, 2))
BEGIN
insert into appointments(Fpatient_id, Fdoctor_id, appointment_date, appointment_time)
values(p_id, d_id, apt_date, apt_time);
update patients set admission_date = apt_date where patient_id = p_id;
END
$
delimiter ;

delimiter $
CREATE PROCEDURE `Discharge Patient`(in p_id int)
BEGIN
delete from appointments where patient_fid=p_id;
update patients set discharge_date = curdate() where patient_id = p_id;
END
$
delimiter ;

create view RecordView as
select * from appointments as a
left join doctors as d
on d.doctor_id = a.Fdoctor_id
left join patients as p
on p.patient_id = a.Fpatient_id;

/* lines to view the data in the tables */
select * from patients;
select * from doctors;
select * from appointments;

/* lines to test the stored procedures and view */
update patients set admission_date = '2023-02-03' where patient_id = 174002;
update patients set discharge_date = '2023-02-07' where patient_id = 174002;
alter table appointments auto_increment=1;

call `AppointmentSchedule`(174002, 238018, '2023-12-16', 17.22);

call `DischargePatient` (174002);

select * from recordview;
/* end of testing lines /*