import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudyApp());
}

class StudyApp extends StatelessWidget {
  const StudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptive Focus Studio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff7f7fb),
      ),
      home: const HomePage(),
    );
  }
}

class StudyPlan {
  int id;
  String title;
  String category;
  int minutes;

  StudyPlan({
    required this.id,
    required this.title,
    required this.category,
    required this.minutes,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  int nextId = 1;

  List<StudyPlan> plans = [];

  Future<void> openPlanForm([StudyPlan? oldPlan]) async {
    final result = await Navigator.push<StudyPlan>(
      context,
      MaterialPageRoute(builder: (context) => PlanFormPage(plan: oldPlan)),
    );

    if (result == null || !mounted) return;

    setState(() {
      if (oldPlan == null) {
        plans.add(
          StudyPlan(
            id: nextId++,
            title: result.title,
            category: result.category,
            minutes: result.minutes,
          ),
        );
      } else {
        int index = plans.indexWhere((p) => p.id == oldPlan.id);

        if (index != -1) {
          plans[index] = StudyPlan(
            id: oldPlan.id,
            title: result.title,
            category: result.category,
            minutes: result.minutes,
          );
        }
      }
    });
  }

  Future<void> deletePlan(StudyPlan plan) async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Study Plan'),
          content: Text('Do you want to delete ${plan.title}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (answer == true && mounted) {
      setState(() {
        plans.removeWhere((p) => p.id == plan.id);
      });
    }
  }

  void openTimer(StudyPlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FocusTimerPage(plan: plan)),
    );
  }

  Widget plansPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Adaptive Focus Studio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Make your study plan and stay focused.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Study Plans',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              '${plans.length} Plans',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (plans.isEmpty)
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.menu_book, size: 55, color: Colors.indigo),
                SizedBox(height: 12),
                Text('No study plans yet', style: TextStyle(fontSize: 17)),
                SizedBox(height: 8),
                Text(
                  'Add a plan to start studying.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        for (final plan in plans)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Category: ${plan.category}'),
                  Text('Focus Time: ${plan.minutes} minutes'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () => openTimer(plan),
                        child: const Text('Start Focus'),
                      ),
                      OutlinedButton(
                        onPressed: () => openPlanForm(plan),
                        child: const Text('Edit'),
                      ),
                      IconButton(
                        onPressed: () => deletePlan(plan),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => openPlanForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Study Plan'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ),
      ],
    );
  }

  Widget historyPage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 65, color: Colors.indigo),
            SizedBox(height: 15),
            Text(
              'Study History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Session history and study statistics will be added here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsPage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 65, color: Colors.indigo),
            SizedBox(height: 15),
            Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Default focus time and notification settings will be added here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive Focus Studio'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: pageIndex == 0
            ? plansPage()
            : pageIndex == 1
            ? historyPage()
            : settingsPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        selectedItemColor: Colors.indigo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Study Plans'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class PlanFormPage extends StatefulWidget {
  final StudyPlan? plan;

  const PlanFormPage({super.key, this.plan});

  @override
  State<PlanFormPage> createState() => _PlanFormPageState();
}

class _PlanFormPageState extends State<PlanFormPage> {
  late TextEditingController titleController;
  late String category;
  late int minutes;

  final categories = [
    'General',
    'Homework',
    'Exam',
    'Reading',
    'Project',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.plan?.title ?? '');

    category = widget.plan?.category ?? 'General';
    minutes = widget.plan?.minutes ?? 25;
  }

  void savePlan() {
    String name = titleController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a study plan name.')),
      );
      return;
    }

    if (minutes < 10 || minutes > 90) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Focus time must be 10 to 90 minutes.')),
      );
      return;
    }

    Navigator.pop(
      context,
      StudyPlan(
        id: widget.plan?.id ?? 0,
        title: name,
        category: category,
        minutes: minutes,
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool editing = widget.plan != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit Study Plan' : 'New Study Plan'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Subject Name', style: TextStyle(fontSize: 17)),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Example: Computer Science',
                ),
              ),
              const SizedBox(height: 15),
              const Text('Category', style: TextStyle(fontSize: 17)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: categories.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 25),
              Text(
                'Focus Duration: $minutes minutes',
                style: const TextStyle(fontSize: 17),
              ),
              Slider(
                min: 10,
                max: 90,
                divisions: 16,
                value: minutes.toDouble(),
                label: '$minutes min',
                onChanged: (value) {
                  setState(() {
                    minutes = value.round();
                  });
                },
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('10 min'), Text('90 min')],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: savePlan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(editing ? 'Update Plan' : 'Save Plan'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FocusTimerPage extends StatefulWidget {
  final StudyPlan plan;

  const FocusTimerPage({super.key, required this.plan});

  @override
  State<FocusTimerPage> createState() => _FocusTimerPageState();
}

class _FocusTimerPageState extends State<FocusTimerPage> {
  Timer? timer;
  final Stopwatch watch = Stopwatch();

  bool started = false;
  bool running = false;
  bool finished = false;
  bool timeUp = false;

  int get totalSeconds => widget.plan.minutes * 60;

  int get remainingSeconds {
    int left = totalSeconds - watch.elapsed.inSeconds;
    return left > 0 ? left : 0;
  }

  String get timerText {
    int time = remainingSeconds;
    int min = time ~/ 60;
    int sec = time % 60;

    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  String get status {
    if (finished) return 'Finished';
    if (timeUp) return 'Time is up';
    if (!started) return 'Not Started';
    if (running) return 'Running';
    return 'Paused';
  }

  void startTimer() {
    if (finished) {
      watch.reset();
      finished = false;
      timeUp = false;
    }

    watch.start();

    timer?.cancel();

    timer = Timer.periodic(const Duration(milliseconds: 250), (t) {
      if (!mounted) return;

      if (remainingSeconds <= 0) {
        watch.stop();
        t.cancel();

        setState(() {
          running = false;
          timeUp = true;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Focus time is up!')));
      } else {
        setState(() {});
      }
    });

    setState(() {
      started = true;
      running = true;
    });
  }

  void pauseTimer() {
    watch.stop();
    timer?.cancel();

    setState(() {
      running = false;
    });
  }

  void finishTimer() {
    watch.stop();
    timer?.cancel();

    int secondsStudied = watch.elapsed.inSeconds;

    if (secondsStudied > totalSeconds) {
      secondsStudied = totalSeconds;
    }

    setState(() {
      running = false;
      finished = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Session finished: $secondsStudied seconds. History saving is not connected yet.',
        ),
      ),
    );
  }

  Future<void> resetTimer() async {
    if (started && !finished) {
      final answer = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reset Timer'),
            content: const Text('Are you sure you want to reset this session?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Reset'),
              ),
            ],
          );
        },
      );

      if (answer != true || !mounted) return;
    }

    timer?.cancel();
    watch.stop();
    watch.reset();

    setState(() {
      started = false;
      running = false;
      finished = false;
      timeUp = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    watch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (remainingSeconds / totalSeconds);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Timer'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.plan.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${widget.plan.category} - ${widget.plan.minutes} minutes',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 35),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 245,
                      height: 245,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.indigo.shade100,
                        color: Colors.indigo,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          timerText,
                          style: const TextStyle(
                            fontSize: 53,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          status,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: (!started || finished) ? startTimer : null,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(finished ? 'Start Again' : 'Start'),
                    ),
                    ElevatedButton.icon(
                      onPressed: started && !finished && !timeUp
                          ? (running ? pauseTimer : startTimer)
                          : null,
                      icon: Icon(running ? Icons.pause : Icons.play_arrow),
                      label: Text(running ? 'Pause' : 'Resume'),
                    ),
                    ElevatedButton.icon(
                      onPressed: started && !finished ? finishTimer : null,
                      icon: const Icon(Icons.check),
                      label: const Text('Finish'),
                    ),
                    OutlinedButton.icon(
                      onPressed: resetTimer,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.indigo),
                            SizedBox(width: 8),
                            Text(
                              'Session Scout',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Personalized focus time suggestions will be available here.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current focus time: ${widget.plan.minutes} minutes',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
