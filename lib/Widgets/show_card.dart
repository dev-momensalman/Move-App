import 'package:flutter/material.dart';
import '../Model/ShowModel.dart';
import '../Screens/detail_screen.dart';

class ShowCard extends StatelessWidget {
  final ShowModel show;
  const ShowCard({super.key, required this.show});

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
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(show: show)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster section
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.85),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                      child: show.imageUrl != null
                          ? Image.network(
                              show.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                          : _placeholder(),
                    ),
                    // Status badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _statusColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _statusColor().withOpacity(0.6)),
                        ),
                        child: Text(
                          show.status == 'To Be Determined' ? 'TBD' : show.status,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: _statusColor(),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    // Rating badge
                    if (show.rating != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFf59e0b), size: 11),
                              const SizedBox(width: 2),
                              Text(
                                show.rating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFf59e0b),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Genres at bottom
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Wrap(
                        spacing: 4,
                        children: show.genres.take(2).map((g) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366f1).withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF6366f1).withOpacity(0.4)),
                          ),
                          child: Text(
                            g,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFa5b4fc),
                              letterSpacing: 0.3,
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              // Info section
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      show.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFf0f4ff),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 10, color: Color(0xFFf59e0b)),
                        const SizedBox(width: 3),
                        Text(
                          show.rating != null ? show.rating!.toStringAsFixed(1) : '—',
                          style: const TextStyle(fontSize: 10, color: Color(0xFFf59e0b), fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          show.displayYear,
                          style: const TextStyle(fontSize: 9, color: Color(0xFF64748b)),
                        ),
                      ],
                    ),
                    if (show.networkName != null)
                      Text(
                        show.networkName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 9, color: Color(0xFF94a3b8)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFF0e1220),
      child: const Center(
        child: Icon(Icons.movie_filter_rounded, color: Color(0xFF1e293b), size: 48),
      ),
    );
  }
}
