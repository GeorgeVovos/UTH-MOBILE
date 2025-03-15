void main() {
  Library library = Library();

  library.addBook(Book("The Lord of the Rings", ["J.R.R. Tolkien"], "Fantasy", "2233445566"));
  library.addBook(Book("Harry Potter and the Philosopher's Stone", ["J.K. Rowling"], "Fantasy", "978-0-7475-3269-9"));
  library.addBook(Book("A Song of Ice and Fire", ["George R.R. Martin"], "Fantasy", "4455667788"));
  library.addBook(Book("Good Omens", ["Terry Pratchett", "Neil Gaiman"], "Comedy", "0-575-04800-X"));

  print("Available books:");
  library.displayBooks();

  print("\nSearching for book with ISBN 123456789:");
  print(library.findBookByISBN("123456789") ?? "Book not found");

  print("\nSearching for book with ISBN 2233445566:");
  print(library.findBookByISBN("2233445566") ?? "Book not found");

  print("\nSearching for books with title containing 'and':");
  library.findBooksByTitle("and").forEach(print);

  print("\nSearching for Comedy books:");
  library.findBooksByGenre("Comedy").forEach(print);
}

class Book {
  String title;
  List<String> authors;
  String genre;
  String ISBN;

  Book(this.title, this.authors, this.genre, this.ISBN);

  @override
  String toString() {
    return 'Title: $title, Authors: ${authors.join(", ")}, Genre: $genre, ISBN: $ISBN';
  }
}

class Library {
  List<Book> books = [];

  void addBook(Book book) {
    books.add(book);
  }

  void displayBooks() {
    for (var book in books) {
      print(book);
    }
  }

  Book? findBookByISBN(String isbn) {
    return books.cast<Book?>().firstWhere((book) => book?.ISBN == isbn, orElse: () => null);
  }

  List<Book> findBooksByTitle(String title) {
    return books.where((book) => book.title.toLowerCase().contains(title.toLowerCase())).toList();
  }

  List<Book> findBooksByGenre(String genre) {
    return books.where((book) => book.genre.toLowerCase() == genre.toLowerCase()).toList();
  }
}
