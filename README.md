 Snackbar Widget Demo

A simple Flutter app that demonstrates the SnackBar widget to show a short confirmation message after the user saves their profile.

---

 1. Widget overview

The **SnackBar** is a Material Design widget that briefly displays a message at the bottom of the screen, usually in response to a user action.  
It appears above the app’s content and then automatically disappears after a short time, without blocking the user from continuing to use the app.

In this demo:

- The user taps a **“Save changes”** button on a profile screen.
- A green SnackBar shows the message **“Profile saved successfully”** with an **UNDO** action.
- This simulates confirming that some data (like profile details) were saved.

---
 2. Real-world use case

Typical use cases for a SnackBar include:

- Showing “Message sent” after sending a chat message.
- Showing “Item added to cart” in a shopping app.
- Showing “Profile saved successfully” after the user edits their details.

In this project, we use the **profile saved** scenario to show how a SnackBar confirms that the user’s action worked and optionally lets them undo it.

---

3. How the demo works

When the user taps the **Save changes** button:

1. We create a `SnackBar` object with:
   - A text message (`content`),
   - A duration (`duration`),
   - A background color (`backgroundColor`),
   - An optional `SnackBarAction` for UNDO.
2. We call `ScaffoldMessenger.of(context).showSnackBar(snackBar)` to display it at the bottom of the screen.
3. The SnackBar appears for a few seconds and then automatically disappears.

---
 4. Main code (lib/main.dart)

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snackbar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final snackBar = SnackBar(
              content: const Text('Profile saved successfully'),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'UNDO',
                textColor: Colors.white,
                onPressed: () {
                  // Undo logic could go here
                },
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Text('Save changes'),
        ),
      ),
    );
  }
}
