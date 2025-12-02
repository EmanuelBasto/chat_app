# Guía: Cómo Acceder a Firebase Emulator Suite

## 📋 Paso 1: Iniciar los Emuladores

Abre una terminal en la raíz de tu proyecto y ejecuta:

```bash
firebase emulators:start
```

Este comando iniciará todos los emuladores configurados (Auth, Firestore, etc.)

## 🌐 Paso 2: Acceder a la Interfaz Web

Una vez que los emuladores estén corriendo, verás un mensaje que dice algo como:

```
✔  All emulators ready! It is now safe to connect.
✔  Emulator UI logging to http://127.0.0.1:4000
```

## 🔍 Paso 3: Abrir en el Navegador

1. **Abre tu navegador** (Chrome, Edge, Firefox, etc.)

2. **Ve a la siguiente dirección:**
   ```
   http://127.0.0.1:4000
   ```
   O también puedes usar:
   ```
   http://localhost:4000
   ```

3. **Verás la interfaz del Firebase Emulator Suite** con estas pestañas:
   - Overview
   - Authentication
   - Extensions
   - **Firestore** ← Esta es la que quieres ver
   - Realtime Database
   - Storage
   - Logs

## 📊 Paso 4: Ver Firestore (como en la imagen)

1. **Haz clic en la pestaña "Firestore"** en la parte superior

2. **Verás dos sub-pestañas:**
   - **Data** ← Esta muestra las colecciones y documentos (como en tu imagen)
   - Requests

3. **En la vista "Data":**
   - **Lado izquierdo:** Verás las colecciones (como "chats", "users")
   - **Lado derecho:** Al seleccionar un documento, verás sus campos y valores

## 🎯 Paso 5: Ver tus Datos

- Cuando tu app cree documentos en Firestore, aparecerán aquí
- Puedes hacer clic en cualquier colección para ver sus documentos
- Puedes editar datos directamente desde esta interfaz

## 🔑 Características Importantes

- **Los datos están en tu computadora** (no en la nube)
- **Se borran cuando cierras los emuladores** (a menos que uses persistencia)
- **Perfecto para desarrollo y pruebas**

## 🛑 Para Detener los Emuladores

Presiona `Ctrl + C` en la terminal donde están corriendo.


