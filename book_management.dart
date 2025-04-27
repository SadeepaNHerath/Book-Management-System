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
      throw ArgumentError('Invalid ISBN format. ISBN must be 10 or 13 digits.');
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
      throw ArgumentError('Invalid ISBN format. ISBN must be 10 or 13 digits.');
    }
  }

  BookStatus get getStatus => status;
  set setStatus(BookStatus status) => this.status = status;

  bool isValidISBN(String isbn) {
    // Improved ISBN validation - checks if it's only digits and correct length
    final RegExp isbnRegex = RegExp(r'^\d{10}$|^\d{13}$');
    return isbnRegex.hasMatch(isbn);
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
    // Check for duplicate ISBN
    if (books.any((existingBook) => existingBook.getIsbn == book.getIsbn)) {
      throw ArgumentError('A book with ISBN ${book.getIsbn} already exists');
    }
    books.add(book);
    print('📚 "${book.getTitle}" added to the library');
  }

  void removeBook(String isbn) {
    if (books.isEmpty) {
      print('❌ The library is empty. No books to remove.');
      return;
    }

    // Find the book first to get its details for the confirmation message
    Book? bookToRemove;
    for (var book in books) {
      if (book.getIsbn == isbn) {
        bookToRemove = book;
        break;
      }
    }

    if (bookToRemove != null) {
      books.removeWhere((book) => book.getIsbn == isbn);
      print(
          '✅ Book "${bookToRemove.getTitle}" with ISBN $isbn has been removed from the library.');
    } else {
      print('❌ No book found with ISBN $isbn. Please check and try again.');
    }
  }

  void updateBookStatus(String isbn, BookStatus newStatus) {
    for (Book book in books) {
      if (book.getIsbn == isbn) {
        book.updateStatus(newStatus);
        print('✅ Status of "${book.getTitle}" updated to ${newStatus.name}');
        return;
      }
    }
    print('❌ No book found with ISBN $isbn');
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
    return books
        .where((book) => book.title.toLowerCase().contains(title.toLowerCase()))
        .toList();
  }

  List<Book> searchByAuthor(String author) {
    return books
        .where(
            (book) => book.author.toLowerCase().contains(author.toLowerCase()))
        .toList();
  }

  void displayBooks() {
    if (books.isEmpty) {
      print('📚 The library is empty');
      return;
    }
    print('📚 Library contains ${books.length} book(s):');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    for (Book book in books) {
      displayBookDetails(book);
    }
  }

  void displayBookDetails(Book book) {
    print('📕 Title: ${book.title}');
    print('✍️ Author: ${book.author}');
    print('🔢 ISBN: ${book.isbn}');
    print(
        '📋 Status: ${book.status == BookStatus.available ? "Available ✅" : "Borrowed 📤"}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}

void clearConsole() {
  print('\x1B[2J\x1B[0;0H');
  print('╔═════════════════════════════════════╗');
  print('║         📚 BOOK MANAGEMENT 📚       ║');
  print('║               SYSTEM                ║');
  print('╚═════════════════════════════════════╝\n');
}

String getNonEmptyInput(String prompt) {
  String? input;
  while (input == null || input.trim().isEmpty) {
    stdout.write(prompt);
    input = stdin.readLineSync()?.trim();
    if (input == null || input.isEmpty) {
      print('❌ This field cannot be empty. Please try again.');
    }
  }
  return input;
}

void main() {
  BookManagementSystem library = BookManagementSystem();

  // Add some sample books for demo purposes
  try {
    library
        .addBook(Book('The Great Gatsby', 'F. Scott Fitzgerald', '1234567890'));
    library.addBook(Book('To Kill a Mockingbird', 'Harper Lee', '9876543210'));
    library.addBook(Book('1984', 'George Orwell', '1122334455'));
  } catch (e) {
    // Silently ignore exceptions during sample data setup
  }

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
      print('❌ Invalid input. Please enter a number.');
      waitForEnter();
      continue;
    }

    switch (choice) {
      case 1:
        while (true) {
          clearConsole();
          print('━━━━━━━━━━━ 📕 Add Book 📕 ━━━━━━━━━━━');

          String title = getNonEmptyInput('Enter title: ');
          String author = getNonEmptyInput('Enter author: ');
          String isbn = getNonEmptyInput('Enter ISBN (10 or 13 digits): ');

          try {
            library.addBook(Book(title, author, isbn));
            print('✅ Book added successfully.');
          } catch (e) {
            print('❌ Error adding book: $e');
          }

          stdout.write('\nDo you want to add another book? (yes/no): ');
          String? again = stdin.readLineSync();
          if (again?.toLowerCase() != 'yes') {
            break;
          }
        }
        break;

      case 2:
        while (true) {
          clearConsole();
          print('━━━━━━━━━━━ 🗑️ Remove Book 🗑️ ━━━━━━━━━━━');
          String isbnToRemove =
              getNonEmptyInput('Enter ISBN of the book to remove: ');
          library.removeBook(isbnToRemove);

          stdout.write('\nDo you want to remove another book? (yes/no): ');
          String? again = stdin.readLineSync();
          if (again?.toLowerCase() != 'yes') {
            break;
          }
        }
        break;

      case 3:
        while (true) {
          clearConsole();
          print('━━━━━━━━━━━ 🔄 Update Book Status 🔄 ━━━━━━━━━━━');
          String isbnToUpdate =
              getNonEmptyInput('Enter ISBN of the book to update status: ');

          print('\nSelect new status:');
          print('1. Available');
          print('2. Borrowed');
          stdout.write('Enter choice (1 or 2): ');

          String statusChoice = stdin.readLineSync() ?? '1';
          BookStatus newStatus =
              statusChoice == '2' ? BookStatus.borrowed : BookStatus.available;

          library.updateBookStatus(isbnToUpdate, newStatus);

          stdout
              .write('\nDo you want to update another book status? (yes/no): ');
          String? again = stdin.readLineSync();
          if (again?.toLowerCase() != 'yes') {
            break;
          }
        }
        break;

      case 4:
        clearConsole();
        print('━━━━━━━━━━━ 🔍 Search by Title 🔍 ━━━━━━━━━━━');
        try {
          String titleToSearch = getNonEmptyInput('Enter title to search: ');
          List<Book> searchResultsByTitle =
              library.searchByTitle(titleToSearch);
          print('\n📋 Search Results by Title:');
          if (searchResultsByTitle.isEmpty) {
            print('❌ No books found with the title "$titleToSearch".');
          } else {
            print(
                'Found ${searchResultsByTitle.length} book(s) matching "$titleToSearch":');
            print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            for (Book book in searchResultsByTitle) {
              library.displayBookDetails(book);
            }
          }
        } catch (e) {
          print('❌ An error occurred during search: $e');
        }
        waitForEnter();
        break;

      case 5:
        clearConsole();
        print('━━━━━━━━━━━ 🔍 Search by Author 🔍 ━━━━━━━━━━━');
        try {
          String authorToSearch = getNonEmptyInput('Enter author to search: ');
          List<Book> searchResultsByAuthor =
              library.searchByAuthor(authorToSearch);
          print('\n📋 Search Results by Author:');
          if (searchResultsByAuthor.isEmpty) {
            print('❌ No books found by the author "$authorToSearch".');
          } else {
            print(
                'Found ${searchResultsByAuthor.length} book(s) by "$authorToSearch":');
            print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
            for (Book book in searchResultsByAuthor) {
              library.displayBookDetails(book);
            }
          }
        } catch (e) {
          print('❌ An error occurred during search: $e');
        }
        waitForEnter();
        break;

      case 6:
        clearConsole();
        print('━━━━━━━━━━━ 📚 All Books 📚 ━━━━━━━━━━━');
        library.displayBooks();
        waitForEnter();
        break;

      case 7:
        clearConsole();
        print('Thank you for using the Book Management System.');
        print('Exiting the program. Goodbye! 👋');
        return;

      default:
        print('❌ Invalid option. Please try again.');
        waitForEnter();
    }
  }
}

// Helper function to wait for user to press Enter
void waitForEnter() {
  try {
    stdout.write('Press Enter to continue...');
    stdin.readLineSync();
  } catch (e) {
    // Handle potential stdin errors
    print('\nContinuing...');
    sleep(Duration(seconds: 1));
  }
}
