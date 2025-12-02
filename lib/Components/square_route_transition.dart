import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Transición personalizada de navegación que crea un efecto de expansión cuadrada
/// La nueva pantalla aparece expandiéndose desde un rectángulo inicial (startRect)
/// Similar al efecto de Instagram Stories o algunas apps modernas
class SquareRouteTransition extends PageRoute {
  /// Widget que se mostrará en la nueva pantalla (destino de la navegación)
  final Widget child;
  
  /// Rectángulo inicial desde donde comenzará la animación de expansión
  /// Generalmente es la posición y tamaño del elemento que se tocó (ej: avatar, imagen)
  final Rect startRect;

  SquareRouteTransition({
    required this.child,
    required this.startRect,
  });

  /// Color del fondo durante la transición (barrier = barrera/overlay)
  @override
  Color? get barrierColor => Colors.black;

  /// Etiqueta de accesibilidad para la barrera (null = sin etiqueta)
  @override
  String? get barrierLabel => null;

  /// Construye la página de destino (el widget hijo)
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  /// Mantiene el estado de la página anterior durante la transición
  /// true = mantiene el estado, útil para animaciones suaves
  @override
  bool get maintainState => true;

  /// Duración de la animación de transición hacia adelante (navegación normal)
  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  /// Duración de la animación de transición inversa (al volver atrás)
  /// Más rápida que la transición hacia adelante para mejor UX
  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  /// Construye la animación de transición visual
  /// Aquí es donde se aplica el efecto de expansión cuadrada
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

/// Widget privado que implementa la animación visual de expansión cuadrada
/// Maneja todos los cálculos matemáticos para crear el efecto de zoom desde un punto
class _SquareTransition extends StatelessWidget {
  /// Animación que controla el progreso de la transición (0.0 a 1.0)
  final Animation<double> animation;
  
  /// Rectángulo inicial desde donde comienza la expansión
  final Rect startRect;
  
  /// Widget hijo que se mostrará dentro del cuadrado expandido
  final Widget child;

  const _SquareTransition({
    required this.animation,
    required this.startRect,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla completa
    final screenSize = MediaQuery.of(context).size;
    
    // AnimatedBuilder reconstruye el widget cada vez que la animación cambia
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Aplicar curva de animación suave (easeInOutCubic) para movimiento natural
        // Transforma el valor lineal (0.0-1.0) en una curva suave
        final curvedAnimation = Curves.easeInOutCubic.transform(animation.value);
        
        // CALCULAR EL TAMAÑO DEL CUADRADO DURANTE LA ANIMACIÓN
        // Usar el lado más grande de la pantalla para mantener forma cuadrada
        // Esto asegura que el cuadrado cubra toda la pantalla sin importar la orientación
        final maxDimension = screenSize.width > screenSize.height
            ? screenSize.width
            : screenSize.height;
        
        // Tamaño inicial del cuadrado (el lado más grande del rectángulo inicial)
        final startSize = startRect.width > startRect.height
            ? startRect.width
            : startRect.height;
        
        // Tamaño actual del cuadrado durante la animación
        // Interpola entre el tamaño inicial y el tamaño máximo según el progreso
        final currentSize = startSize + (maxDimension - startSize) * curvedAnimation;
        
        // CALCULAR LA POSICIÓN DEL CUADRADO DURANTE LA ANIMACIÓN
        // El cuadrado se expande desde su centro, manteniendo el punto inicial como centro
        final centerX = startRect.left + startRect.width / 2; // Centro X del rectángulo inicial
        final centerY = startRect.top + startRect.height / 2; // Centro Y del rectángulo inicial
        final left = centerX - currentSize / 2; // Posición izquierda para centrar el cuadrado
        final top = centerY - currentSize / 2; // Posición superior para centrar el cuadrado

        // Opacidad que aumenta gradualmente con la animación
        // Empieza en 0 (transparente) y termina en 1 (opaco)
        final opacity = curvedAnimation;

        // Stack permite superponer el fondo y el contenido
        return Stack(
          children: [
            // FONDO NEGRO CON OPACIDAD CRECIENTE
            // Crea el efecto de fade-in del fondo oscuro
            Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.black.withOpacity(opacity),
            ),
            // CONTENIDO DEL CUADRADO EXPANDIÉNDOSE
            Positioned(
              left: left,
              top: top,
              width: currentSize,
              height: currentSize,
              child: Opacity(
                opacity: opacity, // El contenido también aparece gradualmente
                child: ClipRect(
                  // ClipRect recorta el contenido al tamaño del cuadrado
                  child: SizedBox(
                    width: currentSize,
                    height: currentSize,
                    child: OverflowBox(
                      // OverflowBox permite que el contenido se expanda más allá del tamaño del cuadrado
                      maxWidth: screenSize.width,
                      maxHeight: screenSize.height,
                      child: FittedBox(
                        // FittedBox ajusta el contenido para llenar el espacio disponible
                        fit: BoxFit.cover, // Cubre todo el espacio manteniendo proporción
                        alignment: Alignment.center, // Centra el contenido
                        child: SizedBox(
                          width: screenSize.width,
                          height: screenSize.height,
                          child: this.child, // El widget de la nueva pantalla
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

