import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:todo/service/supabase_service.dart';
import 'package:todo/shared/shared.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final SupabaseService supabaseService = SupabaseService();
  late Future<List<Map<String, dynamic>>> todayItems;
  late Future<List<Map<String, dynamic>>> somedayItems;

  @override
  void initState() {
    super.initState();
    todayItems = supabaseService.fetchTodayItems();
    somedayItems = supabaseService.fetchSomedayItems();
  }

  Future<void> _refreshData() async {
    setState(() {
      todayItems = supabaseService.fetchTodayItems();
      somedayItems = supabaseService.fetchSomedayItems();
    });
  }

  final textController = TextEditingController();

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Insert Todo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {});
              textController.clear(); // Hapus teks di TextField
              Navigator.pop(context); // Tutup dialog
            },
            child: Text('Back', style: smallTextStyle),
          ),
          TextButton(
            onPressed: () async {
              String noteText = textController.text.trim();

              await supabaseService.addNote(noteText);
              textController.clear();
              _refreshData();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: smallTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  void editNote(int id, String currentNote) {
    // Set the current note into the TextField
    textController.text = currentNote;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Data'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: currentNote, // hint text set to current note
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Ambil teks yang dimasukkan
              String updatedNote = textController.text.trim();

              await supabaseService.editNote(id, updatedNote);

              Navigator.pop(context);
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(gradient: gradient),
              ),
              ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                children: [
                  Column(
                    children: [
                      const Gap(12),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/calendar-todo-line.svg',
                              width: 24,
                              height: 24,
                            ),
                            const Gap(12),
                            Text(
                              'Today',
                              style: normalTextStyle,
                            ),
                            const Gap(12),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future:
                                  todayItems, // Menggunakan 'todayItems' yang sudah di-fetch
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  // Menampilkan jumlah data yang diterima
                                  int itemCount = snapshot.data?.length ??
                                      0; // Menghitung jumlah item
                                  return Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: darkColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$itemCount', // Menampilkan jumlah item
                                        style: smallTextStyle,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Text('No items found.');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      TodayItemsWidget(
                          todayItemsFuture: todayItems,
                          supabaseService: supabaseService,
                          onUpdate: _refreshData),
                      const Gap(24),
                      //someday
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/calendar-event-line.svg',
                              width: 24,
                              height: 24,
                            ),
                            const Gap(12),
                            Text(
                              'Someday',
                              style: normalTextStyle,
                            ),
                            const Gap(12),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future:
                                  somedayItems, // Menggunakan 'todayItems' yang sudah di-fetch
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  // Menampilkan jumlah data yang diterima
                                  int itemCount = snapshot.data?.length ??
                                      0; // Menghitung jumlah item
                                  return Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: darkColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$itemCount', // Menampilkan jumlah item
                                        style: smallTextStyle,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Text('No items found.');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      SomedayItemsWidget(
                          somedayItemsFuture: somedayItems,
                          supabaseService: supabaseService,
                          onUpdate: _refreshData),
                    ],
                  ),
                ],
              ),
            ],
          )),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: another,
          child: SizedBox(
            height: 12,
            child: Center(
              child: GestureDetector(
                // Gunakan GestureDetector untuk menambahkan event onTap
                onTap: () {
                  addNewNote(); // Panggil fungsi yang ingin dijalankan, misalnya addNewNote
                },
                child: Container(
                  width: 60,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          )),
    );
  }
}

//today item
class TodayItemsWidget extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> todayItemsFuture;
  final SupabaseService supabaseService;
  final Future<void> Function() onUpdate;

  TodayItemsWidget({
    super.key,
    required this.todayItemsFuture,
    required this.supabaseService,
    required this.onUpdate,
  });

  @override
  _TodayItemsWidgetState createState() => _TodayItemsWidgetState();
}

class _TodayItemsWidgetState extends State<TodayItemsWidget> {
  final textController = TextEditingController();

  void editNote(int id, String currentNote) {
    // Set the current note into the TextField
    textController.text = currentNote;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Edit Data'),
            GestureDetector(
              onTap: () async {
                // Delete the note from the database
                await widget.supabaseService.deleteNote(id);

                // Close the dialog
                Navigator.pop(context);

                // Trigger re-fetch of data
                widget.onUpdate();
              },
              child: SvgPicture.asset(
                'assets/svg/delete-bin-7-line.svg', // Path to your SVG icon
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: currentNote, // hint text set to current note
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Ambil teks yang dimasukkan
              String updatedNote = textController.text.trim();

              await widget.supabaseService.editNote(id, updatedNote);

              Navigator.pop(context);
              widget.onUpdate(); // Trigger the re-fetch of data
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: primaryColor, // Main color for this widget
        borderRadius: BorderRadius.circular(20),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.todayItemsFuture, // Use the future passed from NotePage
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(fontColor),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final todayItems = snapshot.data!;
             if (todayItems.isEmpty) {
            return const Center(child: Text('No data available'));
            }
            return ListView.builder(
              itemCount: todayItems.length,
              itemBuilder: (context, index) {
                final item = todayItems[index];
                bool isDone = item['status_job'] == 'done';
                bool isSomeday = item['status'] == 'someday';

                return item.isEmpty
                    ? const Center(child: Text('No data available'))
                    : GestureDetector(
                        onTap: () {
                          // Panggil editNote dengan ID dan teks yang ingin diubah
                          editNote(item['id'], item['text']);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Rounded corners for Card
                          ),
                          color: column,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isDone
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: isDone ? fontColor : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    String newStatus =
                                        isDone ? 'pending' : 'done';

                                    final response = await widget
                                        .supabaseService
                                        .updateStatusJob(
                                      item['id'],
                                      newStatus,
                                    );

                                    if (response) {
                                      widget
                                          .onUpdate(); // Trigger re-fetch of data
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Failed to update status')),
                                      );
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    item['text'] ?? 'No Text',
                                    style: normalTextStyle.copyWith(
                                      color: isDone ? Colors.grey : fontColor,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    String status =
                                        isSomeday ? 'today' : 'someday';
                                    final response = await widget
                                        .supabaseService
                                        .updateStatus(
                                      item['id'],
                                      status,
                                    );

                                    if (response) {
                                      widget
                                          .onUpdate(); // Trigger re-fetch of data
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Failed to update status')),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: SvgPicture.asset(
                                        'assets/svg/arrow-turn-back-line.svg'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            );
          } else {
            return const Center(child: Text('No items found.'));
          }
        },
      ),
    );
  }
}

//Someday item
class SomedayItemsWidget extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> somedayItemsFuture;
  final SupabaseService supabaseService;
  final Future<void> Function() onUpdate;

  const SomedayItemsWidget({
    super.key,
    required this.somedayItemsFuture,
    required this.supabaseService,
    required this.onUpdate,
  });

  @override
  _SomedayItemsWidgetState createState() => _SomedayItemsWidgetState();
}

class _SomedayItemsWidgetState extends State<SomedayItemsWidget> {
  final textController = TextEditingController();

  // Function to handle editing a note
  void editNote(int id, String currentNote) {
    textController.text = currentNote;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Edit Data'),
            GestureDetector(
              onTap: () async {
                // Delete the note from the database
                await widget.supabaseService.deleteNote(id);

                // Close the dialog
                Navigator.pop(context);

                // Trigger re-fetch of data
                widget.onUpdate();
              },
              child: SvgPicture.asset(
                'assets/svg/delete-bin-7-line.svg', // Path to your SVG icon
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: currentNote, // Set current note as hint
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String updatedNote = textController.text.trim();

              await widget.supabaseService.editNote(id, updatedNote);

              Navigator.pop(context); // Close the dialog
              widget.onUpdate(); // Trigger re-fetch of data
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: primaryColor, // Main color for this widget
        borderRadius: BorderRadius.circular(20),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future:
            widget.somedayItemsFuture, // Use the future passed from NotePage
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(fontColor),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final somedayItems = snapshot.data!;
            if (somedayItems.isEmpty) {
            return const Center(child: Text('No data available'));
            }
            return ListView.builder(
              itemCount: somedayItems.length,
              itemBuilder: (context, index) {
                final item = somedayItems[index];
                bool isDone = item['status_job'] == 'done';
                bool isSomeday = item['status'] == 'someday';

                return item.isEmpty
                    ? const Center(child: Text('No data available'))
                    : GestureDetector(
                        onTap: () {
                          // Panggil editNote dengan ID dan teks yang ingin diubah
                          editNote(item['id'], item['text']);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: column,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isDone
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: isDone ? fontColor : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    String newStatus =
                                        isDone ? 'pending' : 'done';

                                    final response = await widget
                                        .supabaseService
                                        .updateStatusJob(
                                      item['id'],
                                      newStatus,
                                    );

                                    if (response) {
                                      widget
                                          .onUpdate(); // Trigger re-fetch of data
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Failed to update status')),
                                      );
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    item['text'] ?? 'No Text',
                                    style: normalTextStyle.copyWith(
                                      color: isDone ? Colors.grey : fontColor,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    String status =
                                        isSomeday ? 'today' : 'someday';

                                    final response = await widget
                                        .supabaseService
                                        .updateStatus(
                                      item['id'],
                                      status,
                                    );

                                    if (response) {
                                      widget
                                          .onUpdate(); // Trigger re-fetch of data
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Failed to update status')),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: SvgPicture.asset(
                                        'assets/svg/arrow-turn-forward-line.svg'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
              },
            );
          } else {
            return const Center(child: Text('No items found.'));
          }
        },
      ),
    );
  }
}
