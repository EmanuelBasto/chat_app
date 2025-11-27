import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SquareRouteTransition extends PageRoute {
  final Widget child;
  final Rect startRect;

  SquareRouteTransition({
    required this.child,
    required this.startRect,
  });

  @override
  Color? get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return _SquareTransition(
      animation: animation,
      startRect: startRect,
      child: child,
    );
  }
}

class _SquareTransition extends StatelessWidget {
  final Animation<double> animation;
  final Rect startRect;
  final Widget child;

  const _SquareTransition({
    required this.animation,
    required this.startRect,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final curvedAnimation = Curves.easeInOutCubic.transform(animation.value);
        
        // Calcular el tamaño del cuadrado durante la animación
        // Usar el lado más grande de la pantalla para mantener forma cuadrada
        final maxDimension = screenSize.width > screenSize.height
            ? screenSize.width
            : screenSize.height;
        
        final startSize = startRect.width > startRect.height
            ? startRect.width
            : startRect.height;
        
        final currentSize = startSize + (maxDimension - startSize) * curvedAnimation;
        
        // Calcular la posición del cuadrado durante la animación (centrado desde el punto inicial)
        final centerX = startRect.left + startRect.width / 2;
        final centerY = startRect.top + startRect.height / 2;
        final left = centerX - currentSize / 2;
        final top = centerY - currentSize / 2;

        // Opacidad que aumenta con la animación
        final opacity = curvedAnimation;

        // Crear el clip que simula el cuadrado expandiéndose
        return Stack(
          children: [
            // Fondo negro con opacidad
            Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.black.withOpacity(opacity),
            ),
            // Contenido del cuadrado expandiéndose
            Positioned(
              left: left,
              top: top,
              width: currentSize,
              height: currentSize,
              child: Opacity(
                opacity: opacity,
                child: ClipRect(
                  child: SizedBox(
                    width: currentSize,
                    height: currentSize,
                    child: OverflowBox(
                      maxWidth: screenSize.width,
                      maxHeight: screenSize.height,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: screenSize.width,
                          height: screenSize.height,
                          child: this.child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }
}

