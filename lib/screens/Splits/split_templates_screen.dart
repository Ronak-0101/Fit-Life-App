import 'package:fit_life_app_/models/split_template.dart';
import 'package:fit_life_app_/screens/Splits/create_splits.dart';
import 'package:fit_life_app_/screens/Splits/split_template_detail_screen.dart';
import 'package:fit_life_app_/services/split_service.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplitTemplatesScreen extends StatefulWidget {
  const SplitTemplatesScreen({super.key});

  @override
  State<SplitTemplatesScreen> createState() => _SplitTemplatesScreenState();
}

class _SplitTemplatesScreenState extends State<SplitTemplatesScreen> {
  late Future<List<SplitTemplate>> _templates;
  late Future<SplitTemplate?> _activeSplit;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _templates = SplitService.getTemplates();
    _activeSplit = SplitService.getActiveSplit().catchError((_) => null);
  }

  Future<void> _refresh() async {
    setState(_reload);
    await _templates;
  }

  void _openTemplate(SplitTemplate template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SplitTemplateDetailScreen(template: template),
      ),
    ).then((_) {
      if (mounted) setState(_reload);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.logoColor,
          backgroundColor: AppColors.widgetBG,
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildHero()),
              SliverToBoxAdapter(child: _buildActivePlan()),
              SliverToBoxAdapter(child: _buildSectionTitle()),
              FutureBuilder<List<SplitTemplate>>(
                future: _templates,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.logoColor,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: _MessageCard(
                        icon: Icons.cloud_off_rounded,
                        title: 'Could not load plans',
                        subtitle: snapshot.error.toString(),
                        onRetry: () => setState(_reload),
                      ),
                    );
                  }

                  final templates = snapshot.data ?? const <SplitTemplate>[];
                  if (templates.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: _MessageCard(
                        icon: Icons.view_week_outlined,
                        title: 'No split templates yet',
                        subtitle: 'Your workout plans will appear here.',
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                    sliver: SliverList.separated(
                      itemCount: templates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) => _TemplateCard(
                        template: templates[index],
                        onTap: () => _openTemplate(templates[index]),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          Text(
            'FIT LIFE',
            style: GoogleFonts.oswald(
              fontSize: 26,
              color: AppColors.logoColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => setState(_reload),
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.titleColor,
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 204,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/slider_img/split.jpeg',
                fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.92),
                    Colors.black.withValues(alpha: 0.22),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'TRAIN WITH PURPOSE',
                    style: GoogleFonts.montserrat(
                      color: AppColors.logoColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Workout Splits',
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Choose a seven-day blueprint and make it yours.',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
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

  Widget _buildActivePlan() {
    return FutureBuilder<SplitTemplate?>(
      future: _activeSplit,
      builder: (context, snapshot) {
        final active = snapshot.data;
        if (active == null) return const SizedBox(height: 26);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateSplits()),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.logoColor.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.logoColor.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: AppColors.logoColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACTIVE PLAN',
                          style: GoogleFonts.montserrat(
                            color: AppColors.logoColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          active.title,
                          style: GoogleFonts.poppins(
                            color: AppColors.titleColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'EDIT',
                    style: TextStyle(
                      color: AppColors.titleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.titleColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Explore Plans',
            style: GoogleFonts.poppins(
              color: AppColors.titleColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '5 TEMPLATES',
            style: GoogleFonts.montserrat(
              color: AppColors.subtitleColor,
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.onTap});

  final SplitTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.widgetBG,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 86,
              decoration: BoxDecoration(
                color: AppColors.registerTxtField,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.fitness_center_rounded,
                color: AppColors.logoColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.subtitleColor,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: [
                      _PlanMeta(
                        icon: Icons.calendar_today_rounded,
                        label: '${template.days} days',
                      ),
                      _PlanMeta(
                        icon: Icons.timer_outlined,
                        label: '${template.estimatedDuration} min',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.subtitleColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanMeta extends StatelessWidget {
  const _PlanMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.logoColor, size: 13),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.widgetBG,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.logoColor, size: 38),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: AppColors.titleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.subtitleColor,
                fontSize: 12,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onRetry,
                child: const Text('TRY AGAIN'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
