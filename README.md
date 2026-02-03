# ⚔️ Ils Veulent Tous Ma POO

Welcome to this project created as part of **The Hacking Project (THP)** bootcamp.
The goal is to master the advanced concepts of Object-Oriented Programming (OOP) in Ruby, including class inheritance, object composition, and building a robust game engine.

## Prerequisites

* Ruby (version 3.0 or higher recommended)
* Bundler

## Installation

1.  **Clone the repository**:
    ```bash
    git clone <your-github-link>
    cd mini_jeu_POO
    ```

2.  **Install the gems**:
    ```bash
    bundle install
    ```
    *This project uses `pry` for debugging and `bundler` for gem management.*

---

## Usage

The project is divided into 3 versions representing the evolution of the game's complexity.

### 1. Basic Battle (V1.0)
A simple automated duel between two computer-controlled players (José vs Josiane).
* **Technique:** Implements basic class attributes, methods, and a simple `while` loop to manage the combat until one player dies.
* **Command:**
    ```bash
    ruby app.rb
    ```

### 2. Interactive Human Player (V2.0)
You take control of a `HumanPlayer` against two bots.
* **Technique:** * **Inheritance:** The `HumanPlayer` class inherits from `Player` but adds specific features like weapon searching and health pack collection.
    * **User Interface:** Uses `gets.chomp` and `case/when` to create an interactive menu.
* **Command:**
    ```bash
    ruby app_2.rb
    ```

### 3. The Ultimate Arena (V3.0)
The final version where all the logic is refactored into a `Game` class.
* **Technique:**
    * **Robustness:** Implements input validation (names cannot be empty, only valid menu choices are accepted).
    * **Dynamic Management:** Enemies appear randomly and are automatically removed from the "in sight" list when defeated.
    * **UX:** Uses `system("clear")` and visual health bars for a smoother terminal experience.
* **Command:**
    ```bash
    ruby app_3.rb
    ```

---

## Core OOP Concepts

* **Inheritance:** Using `<` to share behavior between a base class and a specialized one.
* **Composition:** Storing and manipulating objects inside arrays and other classes.
* **Encapsulation:** Managing state (like `@life_points`) through dedicated methods rather than direct attribute manipulation.

## Error Handling

* **Input Sanitization:** The game blocks empty usernames and ignores invalid menu inputs (letters instead of numbers) to prevent script crashes.
* **Dead Men Tell No Tales:** Added logic to ensure a defeated player cannot perform a final "ghost" attack before being removed from the game.

## Author

*Valentin Chéron*

*The Hacking Project 2026*