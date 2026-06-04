import 'package:fit_life_app_/models/exercise.dart';
import 'package:fit_life_app_/models/split_template.dart';
import 'package:fit_life_app_/screens/exercises/workout_detail_screen.dart';
import 'package:fit_life_app_/services/exercise_service.dart';
import 'package:fit_life_app_/services/split_service.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplitTemplateDetailScreen extends StatefulWidget {
  const SplitTemplateDetailScreen({required this.template, super.key});

  final SplitTemplate template;

  @override
  State<SplitTemplateDetailScreen> createState() =>
      _SplitTemplateDetailScreenState();
}

class _SplitTemplateDetailScreenState extends State<SplitTemplateDetailScreen> {
  late Future<SplitTemplate> _detail;
  String? _detailWarning;
  bool _isApplying = false;
  bool _isOpeningExercise = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _detail = _fetchDetail();
  }

  void _reloadDetail() {
    setState(() {
      _detailWarning = null;
      _detail = _fetchDetail();
    });
  }

  Future<SplitTemplate> _fetchDetail() async {
    try {
      return await SplitService.getTemplate(widget.template.slug);
    } catch (error) {
      if (widget.template.week.isEmpty) rethrow;

      if (mounted) {
        setState(() {
          _detailWarning =
              'Showing the weekly plan returned with the template list.';
        });
      }
      return await SplitService.mergeLocalTemplateChanges(widget.template);
    }
  }

  Future<void> _applyTemplate() async {
    if (_isApplying) return;
    setState(() => _isApplying = true);

    try {
      await SplitService.applyTemplate(widget.template.slug);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.widgetBG,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  Future<void> _openExercise(SplitPlanExercise exercise) async {
    if (_isOpeningExercise) return;
    setState(() => _isOpeningExercise = true);

    try {
      final details = await SplitService.getPlannedExerciseDetails(exercise);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutDetailScreen(exercise: details),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.widgetBG,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isOpeningExercise = false);
    }
  }

  Future<void> _addExerciseToTemplateDay(
    SplitPlanDay day,
    ExercisesClass exercise,
    int sets,
    String reps,
    String rest,
  ) async {
    final template = await _detail;
    final newExercise = SplitPlanExercise(
      id: exercise.id ?? '',
      name: exercise.name ?? '',
      bodyPart: exercise.bodyPart ?? '',
      sets: sets,
      reps: reps,
      rest: rest,
      imageUrl: exercise.imageUrl?.isNotEmpty == true ? exercise.imageUrl!.first : null,
      videoUrl: exercise.videoUrl,
      details: exercise,
    );

    final updatedExercises = List<SplitPlanExercise>.from(day.exercises)..add(newExercise);
    await SplitService.saveTemplateDayExercises(
      template.slug,
      day.day,
      updatedExercises,
    );
    _reloadDetail();
  }

  Future<void> _removeExerciseFromTemplateDay(
    SplitPlanDay day,
    SplitPlanExercise exercise,
  ) async {
    final template = await _detail;
    final updatedExercises = List<SplitPlanExercise>.from(day.exercises)
      ..removeWhere((e) => e.id == exercise.id && e.name == exercise.name);

    await SplitService.saveTemplateDayExercises(
      template.slug,
      day.day,
      updatedExercises,
    );
    _reloadDetail();
  }

  Future<void> _showExercisePicker(BuildContext context, SplitPlanDay day) async {
    final exercises = await ExerciseService.getAllExercises().catchError((_) => <ExercisesClass>[]);
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return _ExercisePickerSheet(
          exercises: exercises,
          onSelect: (exercise, sets, reps, rest) {
            _addExerciseToTemplateDay(day, exercise, sets, reps, rest);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<SplitTemplate>(
          future: _detail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingView();
            }

            if (snapshot.hasError) {
              return _buildErrorView(snapshot.error.toString());
            }

            final template = snapshot.data ?? widget.template;

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHero(template)),
                    if (_detailWarning != null)
                      SliverToBoxAdapter(child: _buildDetailWarning()),
                    SliverToBoxAdapter(child: _buildOverview(template)),
                    SliverToBoxAdapter(child: _buildWeekTitle()),
                    if (template.week.isEmpty)
                      SliverToBoxAdapter(child: _buildEmptySchedule())
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 104),
                        sliver: SliverList.separated(
                          itemCount: template.week.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final day = template.week[index];
                            return _DayCard(
                              day: day,
                              onExerciseTap: _openExercise,
                              isEditing: _isEditing,
                              onAddExercise: () => _showExercisePicker(context, day),
                              onRemoveExercise: (ex) => _removeExerciseFromTemplateDay(day, ex),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildApplyButton(),
                ),
                if (_isOpeningExercise)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black38,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.logoColor,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Column(
      children: [
        _buildHero(widget.template),
        const Expanded(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.logoColor),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(String error) {
    return Column(
      children: [
        _buildHero(widget.template),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.widgetBG,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.logoColor,
                      size: 36,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Unable to load this split',
                      style: GoogleFonts.poppins(
                        color: AppColors.titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _detailErrorMessage(error),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.subtitleColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: _reloadDetail,
                      child: const Text('TRY AGAIN'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _detailErrorMessage(String error) {
    final cleaned = error.replaceFirst('Exception: ', '');
    if (cleaned.toLowerCase().contains('route not found')) {
      return 'The deployed API does not currently expose the template detail endpoint. Redeploy the backend route GET /api/splits/templates/:slug.';
    }
    return cleaned;
  }

  Widget _buildHero(SplitTemplate template) {
    return SizedBox(
      height: 270,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/slider_img/split.jpeg', fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  AppColors.background,
                ],
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: 10,
            child: IconButton.filled(
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.45),
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              color: Colors.white,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.level.toUpperCase(),
                  style: GoogleFonts.montserrat(
                    color: AppColors.logoColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  template.title,
                  style: GoogleFonts.poppins(
                    color: AppColors.titleColor,
                    fontSize: 29,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(SplitTemplate template) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 27),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.description,
            style: GoogleFonts.poppins(
              color: AppColors.subtitleColor,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatTile(
                value: '${template.days}',
                label: 'DAYS',
                icon: Icons.calendar_today_rounded,
              ),
              const SizedBox(width: 10),
              _StatTile(
                value: '${template.estimatedDuration}',
                label: 'MIN',
                icon: Icons.timer_outlined,
              ),
              const SizedBox(width: 10),
              _StatTile(
                value: '${template.exerciseCount}',
                label: 'MOVES',
                icon: Icons.fitness_center_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailWarning() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.logoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _detailWarning!,
        style: GoogleFonts.poppins(
          color: AppColors.titleColor,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildWeekTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Weekly Blueprint',
            style: GoogleFonts.poppins(
              color: AppColors.titleColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            icon: Icon(
              _isEditing ? Icons.check_circle_outline_rounded : Icons.edit_note_rounded,
              color: AppColors.logoColor,
              size: 18,
            ),
            label: Text(
              _isEditing ? 'DONE' : 'CUSTOMIZE',
              style: GoogleFonts.poppins(
                color: AppColors.logoColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySchedule() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 104),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.widgetBG,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(Icons.calendar_view_week_outlined,
              color: AppColors.logoColor),
          const SizedBox(height: 10),
          Text(
            'No weekly schedule returned for this template.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.subtitleColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0),
            AppColors.background,
          ],
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isApplying ? null : _applyTemplate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.logoColor,
            foregroundColor: AppColors.titleColor,
            disabledBackgroundColor: AppColors.logoColor.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: _isApplying
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'APPLY THIS SPLIT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.widgetBG,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 17, color: AppColors.logoColor),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: AppColors.titleColor,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: AppColors.subtitleColor,
                fontWeight: FontWeight.w700,
                fontSize: 9,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.onExerciseTap,
    required this.isEditing,
    required this.onAddExercise,
    required this.onRemoveExercise,
  });

  final SplitPlanDay day;
  final ValueChanged<SplitPlanExercise> onExerciseTap;
  final bool isEditing;
  final VoidCallback onAddExercise;
  final ValueChanged<SplitPlanExercise> onRemoveExercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.widgetBG,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: day.isRestDay
              ? Colors.white10
              : AppColors.logoColor.withValues(alpha: 0.2),
        ),
      ),
      child: ExpansionTile(
        enabled: isEditing || (!day.isRestDay && day.exercises.isNotEmpty),
        initiallyExpanded: !day.isRestDay && day.exercises.isNotEmpty,
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppColors.logoColor,
        collapsedIconColor: AppColors.subtitleColor,
        tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 14),
        leading: Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: day.isRestDay
                ? AppColors.registerTxtField
                : AppColors.logoColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _shortDay(day.day),
            style: GoogleFonts.montserrat(
              color:
                  day.isRestDay ? AppColors.subtitleColor : AppColors.logoColor,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
        title: Text(
          day.title,
          style: GoogleFonts.poppins(
            color: AppColors.titleColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          day.isRestDay
              ? 'Recovery'
              : '${day.focus}  |  ${day.estimatedDuration} min  |  ${day.exerciseCount} exercises',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: AppColors.subtitleColor,
            fontSize: 10,
          ),
        ),
        children: [
          for (final exercise in day.exercises)
            _ExercisePlanRow(
              exercise: exercise,
              onTap: () => onExerciseTap(exercise),
              isEditing: isEditing,
              onRemove: () => onRemoveExercise(exercise),
            ),
          if (isEditing) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onAddExercise,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('ADD EXERCISE'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.logoColor,
                  side: const BorderSide(color: AppColors.logoColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _shortDay(String name) {
    if (name.length <= 3) return name.toUpperCase();
    return name.substring(0, 3).toUpperCase();
  }
}

class _ExercisePlanRow extends StatelessWidget {
  const _ExercisePlanRow({
    required this.exercise,
    required this.onTap,
    required this.isEditing,
    required this.onRemove,
  });

  final SplitPlanExercise exercise;
  final VoidCallback onTap;
  final bool isEditing;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.registerTxtField,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  size: 16,
                  color: AppColors.logoColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.titleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${exercise.sets} sets  |  ${exercise.reps} reps  |  ${exercise.rest} rest',
                      style: const TextStyle(
                        color: AppColors.subtitleColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              if (isEditing)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: Colors.redAccent,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 20,
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.subtitleColor,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExercisePickerSheet extends StatefulWidget {
  const _ExercisePickerSheet({
    required this.exercises,
    required this.onSelect,
  });

  final List<ExercisesClass> exercises;
  final void Function(ExercisesClass exercise, int sets, String reps, String rest) onSelect;

  @override
  State<_ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<_ExercisePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'ALL';

  final List<String> _categories = [
    'ALL',
    'CHEST',
    'BACK',
    'LEGS',
    'SHOULDERS',
    'TRICEPS',
    'BICEPS',
    'CORE',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ExercisesClass> get _filteredExercises {
    return widget.exercises.where((exercise) {
      final name = (exercise.name ?? '').toLowerCase();
      final bodyPart = (exercise.bodyPart ?? '').toLowerCase();
      final matchesSearch = name.contains(_searchQuery) || bodyPart.contains(_searchQuery);
      
      final matchesCategory = _selectedCategory == 'ALL' ||
          bodyPart.contains(_selectedCategory.toLowerCase());

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showPresetsDialog(BuildContext context, ExercisesClass exercise) {
    int sets = 3;
    final repsController = TextEditingController(text: '10-12');
    final restController = TextEditingController(text: '60s');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.widgetBG,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.logoColor.withValues(alpha: 0.2)),
              ),
              title: Text(
                exercise.name ?? 'Exercise Prescription',
                style: GoogleFonts.poppins(
                  color: AppColors.titleColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sets',
                      style: GoogleFonts.poppins(
                        color: AppColors.subtitleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton.filled(
                          onPressed: sets > 1
                              ? () => setDialogState(() => sets--)
                              : null,
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$sets',
                            style: GoogleFonts.poppins(
                              color: AppColors.titleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton.filled(
                          onPressed: () => setDialogState(() => sets++),
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Reps Target',
                      style: GoogleFonts.poppins(
                        color: AppColors.subtitleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: repsController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'e.g. 10-12 or 8',
                        hintStyle: const TextStyle(color: Colors.white30),
                        filled: true,
                        fillColor: AppColors.registerTxtField,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Rest Time',
                      style: GoogleFonts.poppins(
                        color: AppColors.subtitleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: restController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'e.g. 60s or 2 min',
                        hintStyle: const TextStyle(color: Colors.white30),
                        filled: true,
                        fillColor: AppColors.registerTxtField,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: AppColors.subtitleColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onSelect(
                      exercise,
                      sets,
                      repsController.text.trim().isEmpty ? '10-12' : repsController.text.trim(),
                      restController.text.trim().isEmpty ? '60s' : restController.text.trim(),
                    );
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close bottom sheet
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.logoColor,
                    foregroundColor: AppColors.titleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('ADD TO SPLIT'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredExercises;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.8,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Exercise Library',
            style: GoogleFonts.poppins(
              color: AppColors.titleColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true,
              fillColor: AppColors.widgetBG,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCategory = category);
                    }
                  },
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.titleColor : Colors.white70,
                  ),
                  backgroundColor: AppColors.widgetBG,
                  selectedColor: AppColors.logoColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No exercises found.',
                      style: TextStyle(color: AppColors.subtitleColor),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final imageUrl = item.imageUrl?.isNotEmpty == true ? item.imageUrl!.first : null;
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.widgetBG,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.registerTxtField,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.fitness_center,
                                          color: AppColors.logoColor,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.fitness_center,
                                      color: AppColors.logoColor,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name ?? 'Exercise',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.titleColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    (item.bodyPart ?? 'Strength').toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                      color: AppColors.logoColor,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _showPresetsDialog(context, item),
                              icon: const Icon(Icons.add),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.registerTxtField,
                                foregroundColor: AppColors.logoColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
