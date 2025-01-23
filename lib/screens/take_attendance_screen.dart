import 'package:flutter/material.dart';

class Student {
  final String id;
  final String name;
  final String rollNumber;
  String attendanceStatus;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    this.attendanceStatus = 'absent',
  });
}

class TakeAttendanceScreen extends StatefulWidget {
  final String lectureTitle;
  final DateTime lectureDate;

  const TakeAttendanceScreen({
    Key? key,
    required this.lectureTitle,
    required this.lectureDate,
  }) : super(key: key);

  @override
  _TakeAttendanceScreenState createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Student> students = [
    Student(id: '1', name: 'Alice Johnson', rollNumber: '101'),
    Student(id: '2', name: 'Bob Smith', rollNumber: '102'),
    Student(id: '3', name: 'Charlie Brown', rollNumber: '103'),
    Student(id: '4', name: 'Diana Wilson', rollNumber: '104'),
  ];

  bool _showSearch = false;
  String _searchQuery = '';
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Student> get filteredStudents {
    if (_searchQuery.isEmpty) return students;
    return students.where((student) {
      return student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.rollNumber.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(child: _buildHeader()),
              _buildStudentsList(),
            ],
          ),
        ),
        floatingActionButton: _buildSaveButton(),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar.medium(
      expandedHeight: 120,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: _showSearch
          ? _buildSearchField()
          : Text(
              widget.lectureTitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            _showSearch ? Icons.close : Icons.search,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          onPressed: () {
            setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) _searchQuery = '';
            });
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            _buildMenuItem(
                'markAllPresent', 'Mark All Present', Icons.check_circle),
            _buildMenuItem('markAllAbsent', 'Mark All Absent', Icons.cancel),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      decoration: InputDecoration(
        hintText: 'Search students...',
        hintStyle: TextStyle(
          color:
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
        ),
        border: InputBorder.none,
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      onChanged: (value) => setState(() => _searchQuery = value),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDateCard(),
          const SizedBox(height: 16),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildDateCard() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lectureDate.toString().split(' ')[0],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  '${students.length} Students',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    int present = students.where((s) => s.attendanceStatus == 'present').length;
    int late = students.where((s) => s.attendanceStatus == 'late').length;
    int absent = students.where((s) => s.attendanceStatus == 'absent').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Present', present, Colors.green),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard('Late', late, Colors.orange),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard('Absent', absent, Colors.red),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, int count, Color baseColor) {
    final color = baseColor == Colors.green
        ? const Color(0xFF00C853) // Bright Green
        : baseColor == Colors.orange
            ? const Color(0xFFFF9100) // Bright Orange
            : const Color(0xFFFF1744); // Bright Red

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.2),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final student = filteredStudents[index];
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    (index / filteredStudents.length) * 0.5,
                    ((index + 1) / filteredStudents.length) * 0.5,
                    curve: Curves.easeOutQuart,
                  ),
                ),
              ),
              child: _buildStudentCard(student),
            );
          },
          childCount: filteredStudents.length,
        ),
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Text(
            student.name[0],
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Roll No: ${student.rollNumber}',
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        trailing: _buildAttendanceButtons(student),
      ),
    );
  }

  Widget _buildAttendanceButtons(Student student) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusButton(
            student,
            'present',
            Icons.check_circle,
            const Color(0xFF00C853), // Bright Green
          ),
          _buildStatusButton(
            student,
            'late',
            Icons.access_time,
            const Color(0xFFFF9100), // Bright Orange
          ),
          _buildStatusButton(
            student,
            'absent',
            Icons.cancel,
            const Color(0xFFFF1744), // Bright Red
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
      Student student, String status, IconData icon, Color color) {
    final isSelected = student.attendanceStatus == status;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          setState(() {
            student.attendanceStatus = status;
            _hasUnsavedChanges = true;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isSelected ? color : Colors.transparent,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 28,
            color: isSelected ? Colors.white : color.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, String text, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    if (!_hasUnsavedChanges) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: _saveAttendance,
      icon: const Icon(Icons.save),
      label: const Text('Save'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  void _handleMenuSelection(String value) {
    setState(() {
      final newStatus = value == 'markAllPresent' ? 'present' : 'absent';
      for (var student in students) {
        student.attendanceStatus = newStatus;
      }
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _saveAttendance() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Saving attendance...'),
              ],
            ),
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Attendance saved successfully'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );

    setState(() => _hasUnsavedChanges = false);
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }
}
