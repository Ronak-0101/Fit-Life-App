import 'package:fit_life_app_/models/exercise.dart';
import 'package:fit_life_app_/models/split_template.dart';
import 'package:fit_life_app_/screens/Splits/split_template_detail_screen.dart';
import 'package:fit_life_app_/screens/exercises/workout_detail_screen.dart';
import 'package:fit_life_app_/services/exercise_service.dart';
import 'package:fit_life_app_/services/split_service.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateSplits extends StatefulWidget {
  const CreateSplits({super.key});

  @override
  State<CreateSplits> createState() => _CreateSplitsState();
}

class _CreateSplitsState extends State<CreateSplits> {
  final Color _bgColor = const Color(0xFF141414);
  final Color _cardColor = const Color(0xFF1F1E1E);
  final Color _chipColor = const Color(0xFF2A2A2A);
  final TextEditingController _searchController = TextEditingController();

  late Future<List<SplitTemplate>> _templatesFuture;
  int _selectedDayIndex = 0;
  bool _isLoading = true;
  bool _isMutating = false;
  String _searchQuery = '';
  String _selectedCategory = 'ALL';
  String? _loadWarning;
  SplitTemplate? _activePlan;
  List<ExercisesClass> _selectedExercises = [];
  List<ExercisesClass> _availableExercises = [];

  final List<_SplitDay> _days = const [
    _SplitDay(label: 'MON', value: 'monday', date: '01'),
    _SplitDay(label: 'TUE', value: 'tuesday', date: '02'),
    _SplitDay(label: 'WED', value: 'wednesday', date: '03'),
    _SplitDay(label: 'THU', value: 'thursday', date: '04'),
    _SplitDay(label: 'FRI', value: 'friday', date: '05'),
    _SplitDay(label: 'SAT', value: 'saturday', date: '06'),
    _SplitDay(label: 'SUN', value: 'sunday', date: '07'),
  ];

  @override
  void initState() {
    super.initState();
    _templatesFuture = SplitService.getTemplates();
    _loadActivePlan();
    _loadDayData();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _selectedDay => _days[_selectedDayIndex].value;

  SplitPlanDay? get _selectedPlanDay {
    for (final day in _activePlan?.week ?? const <SplitPlanDay>[]) {
      if (day.day.toLowerCase() == _selectedDay) return day;
    }
    return null;
  }

  List<ExercisesClass> get _filteredAvailableExercises {
    final query = _searchQuery.toLowerCase();

    return _availableExercises.where((exercise) {
      final searchableText = [
        exercise.name,
        exercise.bodyPart,
        exercise.type,
        exercise.difficulty,
        ...(exercise.muscleGroup ?? []),
      ].whereType<String>().join(' ').toLowerCase();

      final matchesCategory = _selectedCategory == 'ALL' ||
          (exercise.bodyPart ?? '').toUpperCase().contains(_selectedCategory);

      return matchesCategory &&
          (query.isEmpty || searchableText.contains(query));
    }).toList();
  }

  Future<void> _loadDayData() async {
    setState(() {
      _isLoading = true;
      _loadWarning = null;
    });

    try {
      var selectedExercises = <ExercisesClass>[];
      var availableExercises = <ExercisesClass>[];
      final warnings = <String>[];

      try {
        selectedExercises = await SplitService.getDayExercises(_selectedDay);
      } catch (error) {
        warnings.add('Selected day: $error');
      }

      try {
        availableExercises =
            await SplitService.getAvailableExercises(_selectedDay);
      } catch (error) {
        warnings.add('Available exercises: $error');
        availableExercises = await ExerciseService.getAllExercises();
      }

      final selectedIds = selectedExercises
          .map((exercise) => exercise.id)
          .whereType<String>()
          .toSet();
      availableExercises = availableExercises
          .where((exercise) => !selectedIds.contains(exercise.id))
          .toList();

      if (!mounted) return;

      setState(() {
        _selectedExercises = selectedExercises;
        _availableExercises = availableExercises;
        _loadWarning = warnings.isEmpty ? null : warnings.join('\n');
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loadWarning = error.toString();
        _selectedExercises = [];
        _availableExercises = [];
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadActivePlan() async {
    try {
      final activePlan = await SplitService.getActiveSplit();
      if (!mounted) return;
      setState(() => _activePlan = activePlan);
    } catch (_) {
      // Editing a local split remains available before a plan is applied.
    }
  }

  Future<void> _refreshScreen() async {
    setState(() => _templatesFuture = SplitService.getTemplates());
    await Future.wait([
      _loadDayData(),
      _loadActivePlan(),
    ]);
  }

  Future<void> _openTemplate(SplitTemplate template) async {
    final applied = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => SplitTemplateDetailScreen(template: template),
      ),
    );

    if (applied == true && mounted) {
      await _refreshScreen();
      _showSnackBar('${template.title} is now your active split');
    }
  }

  Future<void> _addExercise(ExercisesClass exercise) async {
    final exerciseId = exercise.id;

    if (exerciseId == null || exerciseId.isEmpty || _isMutating) {
      return;
    }

    setState(() => _isMutating = true);

    try {
      await SplitService.addExerciseToDay(
        day: _selectedDay,
        exerciseId: exerciseId,
      );
      await _loadDayData();
      _showSnackBar('${exercise.name ?? 'Exercise'} added');
    } catch (error) {
      _showSnackBar(error.toString());
    } finally {
      if (mounted) {
        setState(() => _isMutating = false);
      }
    }
  }

  Future<void> _removeExercise(ExercisesClass exercise) async {
    final exerciseId = exercise.id;

    if (exerciseId == null || exerciseId.isEmpty || _isMutating) {
      return;
    }

    setState(() => _isMutating = true);

    try {
      await SplitService.removeExerciseFromDay(
        day: _selectedDay,
        exerciseId: exerciseId,
      );
      await _loadDayData();
      _showSnackBar('${exercise.name ?? 'Exercise'} removed');
    } catch (error) {
      _showSnackBar(error.toString());
    } finally {
      if (mounted) {
        setState(() => _isMutating = false);
      }
    }
  }

  void _openExerciseDetails(ExercisesClass exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutDetailScreen(exercise: exercise),
      ),
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _cardColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.logoColor,
              backgroundColor: _cardColor,
              onRefresh: _refreshScreen,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 22),
                    _buildTitleSection(),
                    const SizedBox(height: 28),
                    _buildTemplatePicker(),
                    const SizedBox(height: 42),
                    _buildWeeklyBlueprint(),
                    const SizedBox(height: 24),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.logoColor,
                          ),
                        ),
                      )
                    else ...[
                      if (_loadWarning != null) ...[
                        _buildWarningBanner(),
                        const SizedBox(height: 18),
                      ],
                      _buildSelectedDayExercises(),
                      const SizedBox(height: 16),
                      _buildDropZone(),
                      const SizedBox(height: 32),
                      _buildExerciseLibrary(),
                    ],
                  ],
                ),
              ),
            ),
            if (_isMutating)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.25),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.logoColor,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _bgColor.withValues(alpha: 0.0),
                      _bgColor,
                    ],
                    stops: const [0.0, 0.4],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => _showSnackBar('Split is already synced'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SAVE MY SPLIT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD5C4),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 19,
              color: Color(0xFF9A6E63),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'FIT LIFE',
            style: GoogleFonts.oswald(
              fontSize: 26,
              color: AppColors.logoColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontStyle: FontStyle.italic,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded, size: 21),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PERFORMANCE ARCHITECTURE',
            style: TextStyle(
              color: Colors.red.shade200,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Workout Splits',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Design your kinetic monolith. Select a pre-built architecture or engineer a custom split.',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatePicker() {
    return SizedBox(
      height: 218,
      child: FutureBuilder<List<SplitTemplate>>(
        future: _templatesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.logoColor),
            );
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildEmptyCard('Unable to load split templates.'),
            );
          }

          final templates = snapshot.data ?? const <SplitTemplate>[];
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: templates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _SplitTemplatePreview(
              template: templates[index],
              index: index,
              onTap: () => _openTemplate(templates[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyBlueprint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Weekly\nBlueprint',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              Row(
                children: [
                  _buildStatusChip('ACTIVE', true),
                  const SizedBox(width: 8),
                  _buildStatusChip('REST', false),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 72,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _days.length,
            itemBuilder: (context, index) {
              final day = _days[index];
              final isSelected = _selectedDayIndex == index;
              final planDay = _planDay(day.value);

              return GestureDetector(
                onTap: () {
                  if (_selectedDayIndex == index) return;

                  setState(() {
                    _selectedDayIndex = index;
                    _searchController.clear();
                    _selectedCategory = 'ALL';
                  });
                  _loadDayData();
                },
                child: Container(
                  width: 43,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.transparent
                        : planDay?.isRestDay == true
                            ? const Color(0xFF171717)
                            : _cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: AppColors.primary, width: 2)
                        : Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.label,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.9)
                              : Colors.grey.shade500,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        day.date,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _chipColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.grey.shade600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade400,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayExercises() {
    final dayName = _selectedDay[0].toUpperCase() + _selectedDay.substring(1);
    final title = _selectedPlanDay?.title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  title == null ? dayName : '$dayName: $title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${_selectedPlanDay?.exerciseCount ?? _selectedExercises.length} EXERCISES',
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedExercises.isEmpty)
            _buildEmptyCard('No exercises selected for this day yet.')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _selectedExercises.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final exercise = _selectedExercises[index];

                return _ExerciseRow(
                  exercise: exercise,
                  onTap: () => _openExerciseDetails(exercise),
                  icon: Icons.fitness_center_rounded,
                  trailing: IconButton(
                    onPressed: () => _removeExercise(exercise),
                    icon: const Icon(Icons.remove_rounded),
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  cardColor: _cardColor,
                  chipColor: Colors.black,
                );
              },
            ),
        ],
      ),
    );
  }

  SplitPlanDay? _planDay(String dayName) {
    for (final day in _activePlan?.week ?? const <SplitPlanDay>[]) {
      if (day.day.toLowerCase() == dayName) return day;
    }
    return null;
  }

  Widget _buildDropZone() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DragTarget<ExercisesClass>(
        onAcceptWithDetails: (details) => _addExercise(details.data),
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty;

          return CustomPaint(
            painter: DashedBorderPainter(
              color: isHovering ? AppColors.logoColor : Colors.grey.shade800,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: isHovering
                    ? AppColors.logoColor.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_task,
                      color: isHovering ? AppColors.logoColor : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isHovering ? 'RELEASE TO ADD' : 'DRAG EXERCISE HERE',
                      style: TextStyle(
                        color: isHovering ? AppColors.logoColor : Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_availableExercises.length} available for ${_days[_selectedDayIndex].label}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableLibraryExercise(ExercisesClass exercise) {
    return LongPressDraggable<ExercisesClass>(
      data: exercise,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width - 40,
          child: _ExerciseRow(
            exercise: exercise,
            icon: Icons.drag_indicator_rounded,
            trailing: const Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
            cardColor: _cardColor,
            chipColor: _chipColor,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: _ExerciseRow(
          exercise: exercise,
          icon: Icons.add_rounded,
          trailing: IconButton(
            onPressed: () => _addExercise(exercise),
            icon: const Icon(Icons.add_rounded),
            color: Colors.white,
            style: IconButton.styleFrom(backgroundColor: _chipColor),
          ),
          cardColor: Colors.transparent,
          chipColor: _chipColor,
        ),
      ),
      child: _ExerciseRow(
        exercise: exercise,
        onTap: () => _openExerciseDetails(exercise),
        icon: Icons.drag_indicator_rounded,
        trailing: IconButton(
          onPressed: () => _addExercise(exercise),
          icon: const Icon(Icons.add_rounded),
          color: Colors.white,
          style: IconButton.styleFrom(backgroundColor: _chipColor),
        ),
        cardColor: Colors.transparent,
        chipColor: _chipColor,
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.logoColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.logoColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.logoColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Showing your exercise library. Some split data could not be loaded yet.',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseLibrary() {
    final exercises = _filteredAvailableExercises;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                icon: const Icon(Icons.search, color: Colors.grey, size: 20),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _searchController.clear,
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.grey,
                      ),
                hintText: 'Search kinetics database...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return _buildCategoryChip(_categories[index]);
              },
            ),
          ),
          const SizedBox(height: 24),
          if (exercises.isEmpty)
            _buildEmptyCard('No available exercises for this day.')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exercises.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildDraggableLibraryExercise(exercises[index]);
              },
            ),
        ],
      ),
    );
  }

  static const List<String> _categories = [
    'ALL',
    'CHEST',
    'TRICEPS',
    'SHOULDERS',
    'BACK',
    'LEGS',
  ];

  Widget _buildCategoryChip(String category) {
    final selected = category == _selectedCategory;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = category),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.logoColor : _chipColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey.shade300,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SplitTemplatePreview extends StatelessWidget {
  const _SplitTemplatePreview({
    required this.template,
    required this.index,
    required this.onTap,
  });

  final SplitTemplate template;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 164,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF202020),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(_imagePath, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.06),
                    Colors.black.withValues(alpha: 0.78),
                  ],
                  stops: const [0.35, 1],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 10,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _badge,
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFFFB9AD),
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    template.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 17,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _badge {
    final level = template.level.toUpperCase();
    if (level != 'ALL LEVELS') return level;
    return index == 0 ? 'STANDARD' : 'PROGRAM';
  }

  String get _imagePath {
    final slug = template.slug.toLowerCase();
    if (slug.contains('lower') || slug.contains('leg')) {
      return 'assets/images/workout_cate/Leg.png';
    }
    if (slug.contains('body') || slug.contains('full')) {
      return 'assets/images/slider_img/all_workout.jpeg';
    }
    if (slug.contains('power')) {
      return 'assets/images/workout_cate/Shoulder.png';
    }
    return 'assets/images/slider_img/split.jpeg';
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.exercise,
    required this.icon,
    required this.trailing,
    required this.cardColor,
    required this.chipColor,
    this.onTap,
  });

  final ExercisesClass exercise;
  final IconData icon;
  final Widget trailing;
  final Color cardColor;
  final Color chipColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  _imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(icon, color: Colors.red.shade300, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (exercise.name ?? 'Unknown Exercise').toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  String get _subtitle {
    final prescription = exercise.prescription;
    if (prescription != null &&
        (prescription.sets != null || prescription.reps != null)) {
      return '${prescription.sets ?? '-'} SETS - ${prescription.reps ?? '-'} REPS';
    }

    final details = [
      exercise.bodyPart,
      exercise.type,
      exercise.difficulty,
    ].whereType<String>().where((value) => value.isNotEmpty).toList();

    if (details.isEmpty) {
      return '${exercise.duration ?? 0} MIN';
    }

    return details.join(' - ').toUpperCase();
  }

  String get _imagePath {
    final bodyPart = (exercise.bodyPart ?? '').toLowerCase();
    if (bodyPart.contains('back')) return 'assets/images/workout_cate/Back.png';
    if (bodyPart.contains('leg')) return 'assets/images/workout_cate/Leg.png';
    if (bodyPart.contains('shoulder')) {
      return 'assets/images/workout_cate/Shoulder.png';
    }
    if (bodyPart.contains('core')) return 'assets/images/workout_cate/Core.png';
    if (bodyPart.contains('tricep')) {
      return 'assets/images/workout_cate/Tricep.png';
    }
    if (bodyPart.contains('bicep')) {
      return 'assets/images/workout_cate/Bicep.png';
    }
    return 'assets/images/workout_cate/Chest.png';
  }
}

class _SplitDay {
  const _SplitDay({
    required this.label,
    required this.value,
    required this.date,
  });

  final String label;
  final String value;
  final String date;
}

class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 5.0;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }

    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
