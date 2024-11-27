import 'dart:io';

enum BookStatus { available, borrowed }

class Book {
  String title;
  String author;
  String isbn;
  BookStatus status;

  Book(this.title, this.author, this.isbn,
      {this.status = BookStatus.available}) {
    if (!isValidISBN(isbn)) {
      throw new ArgumentError('Invalid ISBN format');
    }
  }

  String get getTitle => title;
  set setTitle(String title) => this.title = title;

  String get getAuthor => author;
  set setAuthor(String author) => this.author = author;

  String get getIsbn => isbn;
  set setIsbn(String isbn) {
    if (isValidISBN(isbn)) {
      this.isbn = isbn;
    } else {
      throw new ArgumentError('Invalid ISBN format');
    }
  }

  BookStatus get getStatus => status;
  set setStatus(BookStatus status) => this.status = status;

  bool isValidISBN(String isbn) {
    return (isbn.length == 10 || isbn.length == 13);
  }

  void updateStatus(BookStatus newStatus) {
    this.status = newStatus;
  }
}

class TextBook extends Book {
  String subject;
  String grade;

  TextBook(String title, String author, String isbn, this.subject, this.grade)
      : super(title, author, isbn);

  String get getSubject => subject;
  set setSubject(String subject) => this.subject = subject;

  String get getGrade => grade;
  set setGrade(String grade) => this.grade = grade;
}

class BookManagementSystem {
  List<Book> books = [];

  void addBook(Book book) {
    books.add(book);
    print('${book.getTitle} added to the library');
  }

  void removeBook(String isbn) {
    books.removeWhere((book) => book.getIsbn == isbn);
    print('Book with ISBN $isbn removed from the library');
  }

  void updateBookStatus(String isbn, BookStatus newStatus) {
    for (Book book in books) {
      if (book.getIsbn == isbn) {
        book.updateStatus(newStatus);
        print('Status of ${book.getTitle} updated to ${newStatus.name}');
        return;
      }
    }
    print('No book found with ISBN $isbn');
  }

  List<Book> getAvailableBooks() {
    return books
        .where((book) => book.getStatus == BookStatus.available)
        .toList();
  }

  List<Book> getBorrowedBooks() {
    return books
        .where((book) => book.getStatus == BookStatus.borrowed)
        .toList();
  }

  List<Book> searchByTitle(String title) {
    return books.where((book) => book.title.toLowerCase().contains(title.toLowerCase())).toList();
  }

  List<Book> searchByAuthor(String author) {
    return books.where((book) => book.author.toLowerCase().contains(author.toLowerCase())).toList();
  }

  void displayBooks() {
    if (books.isEmpty) {
      print('No books in the library');
      return;
    }
    for (Book book in books) {
      displayBookDetails(book);
    }
  }

  void displayBookDetails(Book book) {
    print('Title: ${book.title}');
    print('Author: ${book.author}');
    print('ISBN: ${book.isbn}');
    print(
        'Status: ${book.status == BookStatus.available ? "Available" : "Borrowed"}');
    print('-----------------------------');
  }
}

void clearConsole() {
  print('\x1B[2J\x1B[0;0H');
  print('╔═════════════════════════════════════╗');
  print('║         📚 BOOK MANAGEMENT 📚       ║');
  print('║               SYSTEM                ║');
  print('╚═════════════════════════════════════╝\n');
}

void main() {
  BookManagementSystem library = BookManagementSystem();

  while (true) {
    clearConsole();
    print('1️⃣  Add Book');
    print('2️⃣  Remove Book');
    print('3️⃣  Update Book Status');
    print('4️⃣  Search by Title');
    print('5️⃣  Search by Author');
    print('6️⃣  Display All Books');
    print('7️⃣  Exit\n');
    stdout.write('👉 Choose an option: ');

    String? input = stdin.readLineSync();
    int choice;
    try {
      choice = int.parse(input ?? '0');
    } catch (e) {
      print('Invalid input. Please enter a number.');
      continue;
    }

    switch (choice) {
      case 1:
        while (true) {
          clearConsole();
          print('--- Add Book ---');
          stdout.write('Enter title: ');
          String? title = stdin.readLineSync();
          stdout.write('Enter author: ');
          String? author = stdin.readLineSync();
          stdout.write('Enter ISBN: ');
          String? isbn = stdin.readLineSync();

          if (title != null && author != null && isbn != null) {
            try {
              library.addBook(Book(title, author, isbn));
              print('Book added successfully.');
            } catch (e) {
              print('Error adding book: $e');
            }
          } else {
            print('Error: Title, author, and ISBN are required.');
          }

          stdout.write('Do you want to add another book? (yes/no): ');
          String? again = stdin.readLineSync();
          if (again?.toLowerCase() != 'yes') {
            break;
          }
        }
        break;

      case 2:
        while (true) {
          clearConsole();
          print('--- Remove Book ---');
          stdout.write('Enter ISBN of the book to remove: ');
          String? isbnToRemove = stdin.readLineSync();
          library.removeBook(isbnToRemove!);
          print('Book removed successfully.');

          stdout.write('Do you want to remove another book? (yes/no): ');
          String? again = stdin.readLineSync();
          if (again?.toLowerCase() != 'yes') {
            break;
          }
        }
        break;

      case 3:
        while (true) {
          clearConsole();
          print('--- Update Book Status ---');
          stdout.write('Enter ISBN of the book to update status: ');
          String isbnToUpdate = stdin.readLineSync()!;
          stdout.write('Enter new status (available/borrowed): ');
          String statusInput = stdin.readLineSync()!;
          BookStatus newStatus = statusInput.toLowerCase() == 'available'
              ? BookStatus.available
              : BookStatus.borrowed;
          library.updateBookStatus(isbnToUpdate, newStatus);
          print('Status updated successfully.');

          stdout.write('Do you want to update another book status? (yes/no): ');
          String? again = stdin.readLineSync();
          if (again?.toLowerCase() != 'yes') {
            break;
          }
        }
        break;

      case 4:
        clearConsole();
        stdout.write('Enter title to search: ');
        String titleToSearch = stdin.readLineSync()!;
        List<Book> searchResultsByTitle = library.searchByTitle(titleToSearch);
        print('Search Results by Title:');
        if (searchResultsByTitle.isEmpty) {
          print('No books found with the title "$titleToSearch".');
        } else {
          for (Book book in searchResultsByTitle) {
            library.displayBookDetails(book);
          }
        }
        stdout.write('Press Enter to continue...');
        stdin.readLineSync();
        break;

      case 5:
        clearConsole();
        stdout.write('Enter author to search: ');
        String authorToSearch = stdin.readLineSync()!;
        List<Book> searchResultsByAuthor = library.searchByAuthor(authorToSearch);
        print('Search Results by Author:');
        if (searchResultsByAuthor.isEmpty) {
          print('No books found by the author "$authorToSearch".');
        } else {
          for (Book book in searchResultsByAuthor) {
            library.displayBookDetails(book);
          }
        }
        stdout.write('Press Enter to continue...');
        stdin.readLineSync();
        break;

      case 6:
        clearConsole();
        library.displayBooks();
        stdout.write('Press Enter to continue...');
        stdin.readLineSync();
        break;

      case 7:
        print('Exiting the program.');
        return;

      default:
        print('Invalid option. Please try again.');
    }
  }
}