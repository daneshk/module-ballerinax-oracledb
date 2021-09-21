// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerinax/oracledb;
import ballerina/sql;

configurable string USER = "balUser";
configurable string PASSWORD = "balpass";
configurable string HOST = "localhost";
configurable int PORT = 1521;
configurable string DATABASE = "ORCLCDB.localdomain";

final oracledb:Client dbClient = check new(host = HOST, user = USER, password = PASSWORD, port = PORT,
    database = DATABASE, connectionPool = {maxOpenConnections: 3, minIdleConnections: 1});
listener http:Listener onlineShopListener = new (9090);

service /onlineshop on onlineShopListener {
    resource function get employees() returns Employee[]|error? {
        Employee[] employees = [];
         stream<Employee, error?> resultStream = dbClient->query(`SELECT * FROM EMPLOYEES`);
         _ = check resultStream.forEach(function(Employee employee) {
            employees.push(employee);
         });
         check resultStream.close();
         return employees;
    }

    resource function get employees/[int id]() returns Employee|error? {
        return check dbClient->queryRow(`SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = ${id}`, Employee);
    }

    resource function get employees/count() returns int|error? {
        return check dbClient->queryRow(`SELECT COUNT(*) FROM EMPLOYEES`, int);
    }

    resource function get products() returns Product[]|error? {
        Product[] products = [];
        stream<Product, error?> resultStream = dbClient->query(`SELECT * FROM PRODUCTS`);
        _ = check resultStream.forEach(function(Product product) {
           products.push(product);
        });
        check resultStream.close();
        return products;
    }

    resource function get products/[int id]() returns Product|error? {
        return check dbClient->queryRow(`SELECT * FROM PRODUCTS WHERE PRODUCT_ID = ${id}`, Product);
    }

    resource function get customers() returns Customer[]|error? {
        Customer[] customers = [];
        stream<Customer, error?> resultStream = dbClient->query(`SELECT * FROM CUSTOMERS`);
        _ = check resultStream.forEach(function(Customer customer) {
           customers.push(customer);
        });
        check resultStream.close();
        return customers;
    }

    resource function get customers/[int id]() returns Customer|error? {
        return check dbClient->queryRow(`SELECT * FROM CUSTOMERS WHERE CUSTOMER_ID = ${id}`, Customer);
    }

    resource function post customers(@http:Payload CustomerInput customer) returns string|error? {
        sql:ParameterizedQuery query = `INSERT INTO CUSTOMERS (NAME,ADDRESS,CREDIT_LIMIT,WEBSITE) VALUES
        (${customer.name}, ${customer.address}, ${customer.credit_limit}, ${customer.website})`;
        sql:ExecutionResult result = check dbClient->execute(query);
        return result.lastInsertId.toString();
    }

    resource function delete customers/[int id]() returns string|error? {
        sql:ExecutionResult result = check dbClient->execute(`DELETE FROM CUSTOMERS WHERE CUSTOMER_ID = ${id}`);
        return result.affectedRowCount.toString();
    }

    resource function update customers(@http:Payload Customer customer) returns string|error? {
        sql:ParameterizedQuery query = `UPDATE CUSTOMERS SET NAME = ${customer.name}, ADDRESS = ${customer.address},
        CREDIT_LIMIT = ${customer.credit_limit},WEBSITE = ${customer.website} where CUSTOMER_ID = ${customer.customer_id}`;
        sql:ExecutionResult result = check dbClient->execute(query);
        return result.lastInsertId.toString();
    }

    resource function get orders() returns Order[]|error? {
        Order[] orders = [];
        stream<Order, error?> resultStream = dbClient->query(`SELECT * FROM ORDERS`);
        _ = check resultStream.forEach(function(Order order) {
           orders.push(order);
        });
        check resultStream.close();
        return orders;
    }

    resource function get orders/[int id]() returns Order|error? {
        return check dbClient->queryRow(`SELECT * FROM ORDERS WHERE ORDER_ID = ${id}`, Order);
    }

    resource function get orderitems() returns OrderItem[]|error? {
        OrderItem[] orderItems = [];
        stream<OrderItem, error?> resultStream = dbClient->query(`SELECT * FROM ORDER_ITEMS`);
        _ = check resultStream.forEach(function(OrderItem orderItem) {
           orderItems.push(orderItem);
        });
        check resultStream.close();
        return orderItems;
    }

    resource function get orders/[int id]/items() returns OrderItem[]|error? {
        OrderItem[] orderItems = [];
        stream<OrderItem, error?> resultStream = dbClient->query(`SELECT * FROM ORDER_ITEMS WHERE ORDER_ID = ${id}`);
        _ = check resultStream.forEach(function(OrderItem orderItem) {
           orderItems.push(orderItem);
        });
        check resultStream.close();
        return orderItems;
    }

    resource function get contacts() returns Contact[]|error? {
        Contact[] contacts = [];
        stream<Contact, error?> resultStream = dbClient->query(`SELECT * FROM CONTACTS`);
        _ = check resultStream.forEach(function(Contact contact) {
           contacts.push(contact);
        });
        check resultStream.close();
        return contacts;
    }

    resource function get customers/[int id]/contacts() returns Contact[]|error? {
        Contact[] contacts = [];
        stream<Contact, error?> resultStream = dbClient->query(`SELECT * FROM CONTACTS WHERE CUSTOMER_ID = ${id}`);
        _ = check resultStream.forEach(function(Contact contact) {
           contacts.push(contact);
        });
        check resultStream.close();
        return contacts;
    }

    resource function get contacts/[int id]() returns Contact|error? {
        return check dbClient->queryRow(`SELECT * FROM CONTACTS WHERE CONTACT_ID = ${id}`, Contact);
    }
}
