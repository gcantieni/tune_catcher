import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tune_catcher/model/accessors/set_tune_dao.dart';

class SetTuneCard extends StatefulWidget {
  const SetTuneCard({
    required this.entry,
    required this.index,
    required this.onDelete,
    super.key,
  });

  final SetTuneEntry entry;
  final int index;
  final VoidCallback onDelete;

  @override
  State<SetTuneCard> createState() => _SetTuneCardState();
}

class _SetTuneCardState extends State<SetTuneCard>
    with SingleTickerProviderStateMixin {
  static const _actionWidth = 80.0;

  late final AnimationController _controller;
  double _dragStartDx = 0;
  double _valueAtDragStart = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isOpen => _controller.value > 0.5;

  void _onHorizontalDragStart(DragStartDetails d) {
    _controller.stop();
    _dragStartDx = d.globalPosition.dx;
    _valueAtDragStart = _controller.value;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails d) {
    final delta = d.globalPosition.dx - _dragStartDx;
    _controller.value = (_valueAtDragStart - delta / _actionWidth).clamp(
      0.0,
      1.0,
    );
  }

  void _onHorizontalDragEnd(DragEndDetails d) {
    final v = d.primaryVelocity ?? 0;
    if (v < -300) {
      _controller.animateTo(1.0);
    } else if (v > 300) {
      _controller.animateTo(0.0);
    } else if (_controller.value >= 0.5) {
      _controller.animateTo(1.0);
    } else {
      _controller.animateTo(0.0);
    }
  }

  void _close() => _controller.animateTo(0.0);

  @override
  Widget build(BuildContext context) {
    final tuneKey = widget.entry.tune.key;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ReorderableDelayedDragStartListener(
          index: widget.index,
          child: GestureDetector(
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: ClipRect(
              child: Stack(
                children: [
                  // Delete action behind the card
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: _actionWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Material(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: widget.onDelete,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Card slides left to reveal the action
                  Transform.translate(
                    offset: Offset(-_controller.value * _actionWidth, 0),
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.dehaze),
                        title: Text(widget.entry.tune.name),
                        subtitle: tuneKey != null && tuneKey.isNotEmpty
                            ? Text(tuneKey)
                            : null,
                        onTap: _isOpen
                            ? _close
                            : () => context.push(
                                '/tune_list/${widget.entry.tune.id}',
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
