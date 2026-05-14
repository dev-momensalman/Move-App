import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/ShowModel.dart';

class DetailScreen extends StatelessWidget {
  final ShowModel show;
  const DetailScreen({super.key, required this.show});

  Color _statusColor() {
    switch (show.status) {
      case 'Running':
        return const Color(0xFF22c55e);
      case 'Ended':
        return const Color(0xFF64748b);
      default:
        return const Color(0xFFf59e0b);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080b14),
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ──
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: const Color(0xFF080b14),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Poster
                  show.imageUrl != null
                      ? Image.network(
                          show.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _posterPlaceholder(),
                        )
                      : _posterPlaceholder(),
                  // Gradient
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.5),
                          const Color(0xFF080b14),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                  // Bottom info overlay
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Genres
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: show.genres.map((g) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366f1).withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF6366f1).withOpacity(0.5)),
                            ),
                            child: Text(
                              g,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFa5b4fc),
                              ),
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 10),
                        // Title
                        Text(
                          show.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Quick Stats Row ──
                  Row(
                    children: [
                      if (show.rating != null) ...[
                        _StatCard(
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFf59e0b),
                          label: 'Rating',
                          value: '${show.rating!.toStringAsFixed(1)} / 10',
                        ),
                        const SizedBox(width: 10),
                      ],
                      _StatCard(
                        icon: Icons.circle,
                        iconColor: _statusColor(),
                        label: 'Status',
                        value: show.status == 'To Be Determined' ? 'TBD' : show.status,
                        valueColor: _statusColor(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.tv_rounded,
                        iconColor: const Color(0xFF6366f1),
                        label: 'Network',
                        value: show.networkName ?? '—',
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        icon: Icons.access_time_rounded,
                        iconColor: const Color(0xFF3b82f6),
                        label: 'Runtime',
                        value: show.displayRuntime,
                      ),
                    ],
                  ),

                  // ── Dates ──
                  const SizedBox(height: 20),
                  _SectionTitle(title: '📅 Air Dates'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.07)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _DateInfo(
                            label: 'Premiered',
                            value: show.premiered ?? '—',
                            icon: Icons.play_circle_outline_rounded,
                            color: const Color(0xFF22c55e),
                          ),
                        ),
                        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.08)),
                        Expanded(
                          child: _DateInfo(
                            label: show.status == 'Running' ? 'Ongoing' : 'Ended',
                            value: show.ended ?? 'Present',
                            icon: show.status == 'Running'
                                ? Icons.radio_button_checked_rounded
                                : Icons.stop_circle_outlined,
                            color: show.status == 'Running'
                                ? const Color(0xFF22c55e)
                                : const Color(0xFF64748b),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Details ──
                  const SizedBox(height: 20),
                  _SectionTitle(title: '🎬 Details'),
                  const SizedBox(height: 10),
                  _DetailRow(label: 'Type', value: show.type),
                  _DetailRow(label: 'Language', value: show.language),
                  _DetailRow(
                    label: 'Popularity',
                    value: '${show.weight}/100',
                    trailing: _PopularityBar(value: show.weight),
                  ),

                  // ── Synopsis ──
                  if (show.strippedSummary.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle(title: '📖 Synopsis'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.07)),
                      ),
                      child: Text(
                        show.strippedSummary,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF94a3b8),
                          height: 1.8,
                        ),
                      ),
                    ),
                  ],

                  // ── Open on TVMaze ──
                  if (show.url != null) ...[
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Open: ${show.url}'),
                              backgroundColor: const Color(0xFF6366f1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: const Text(
                          'View on TVMaze',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366f1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _posterPlaceholder() => Container(
    color: const Color(0xFF0e1220),
    child: const Center(
      child: Icon(Icons.movie_filter_rounded, color: Color(0xFF1e293b), size: 80),
    ),
  );
}

// ─── Helper Widgets ───

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748b))),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: valueColor ?? const Color(0xFFf0f4ff),
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
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Color(0xFFf0f4ff),
      ),
    );
  }
}

class _DateInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DateInfo({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748b))),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFf0f4ff)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _DetailRow({required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748b)),
            ),
          ),
          Expanded(
            child: trailing ??
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFf0f4ff),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _PopularityBar extends StatelessWidget {
  final int value;
  const _PopularityBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$value/100',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFFf0f4ff),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF6366f1)),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }
}
