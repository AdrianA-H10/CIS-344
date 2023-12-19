import mysql.connector
from mysql.connector import Error

class Database():
    def __init__(self,
                 host="localhost",
                 port="3306",
                 database="hospital_portal",
                 user='root',
                 password=''):

        self.host = host
        self.port = port
        self.database = database
        self.user = user
        self.password = password
        self.connection = None
        self.cursor = None
        self.connect()

    def connect(self):
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                port=self.port,
                database=self.database,
                user=self.user,
                password=self.password)
            
            if self.connection.is_connected():
                return
        except Error as e:
            print("Error while connecting to MySQL", e)

    def addPatient(self, patient_name, age, admission_date, discharge_date):
        ''' Method to insert a new patient into the patients table '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "INSERT INTO patients (patient_name, age, admission_date, discharge_date) VALUES (%s, %s, %s, %s)"
            self.cursor.execute(query, (patient_name, age, admission_date, discharge_date))
            self.connection.commit()
            return

    def getAllPatients(self):
        ''' Method to get all patients from the patients table '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "SELECT * FROM patients"
            self.cursor.execute(query)
            records = self.cursor.fetchall()
            return records

    def scheduleAppointment(self, patient_id, doctor_id, appointment_date, appointment_time):
        ''' Method to schedule an appointment '''
        # Implement the functionality
        if self.connection.is_connected():
            self.cursor= self.connection.cursor()
            args = (patient_id, doctor_id, appointment_date, appointment_time)
            query = "Call `AppointmentSchedule`(%s, %s, %s, %s)"
            self.cursor.execute(query, args)
            self.connection.commit()
            return

    def viewAppointments(self):
        ''' Method to view all appointments '''
        # Implement the functionality
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "SELECT * FROM appointments"
            self.cursor.execute(query)
            records = self.cursor.fetchall()
            return records

    def dischargePatient(self, patient_id):
        ''' Method to discharge a patient '''
        # Implement the functionality
        if self.connection.is_connected():
            self.cursor= self.connection.cursor()
            args = (patient_id)
            query = "Call `DischargePatient`(%s)"
            self.cursor.execute(query, (args,))
            self.connection.commit()
            return

    def getAllDoctors(self):
        ''' Method to get all doctors from the doctors table '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "SELECT * FROM doctors"
            self.cursor.execute(query)
            records = self.cursor.fetchall()
            return records

    # Add more methods as needed for hospital operations

