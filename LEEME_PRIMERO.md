# SICEC — Tres páginas independientes

## Importante
Esta es una versión local de demostración, **no lista para expedientes reales**. Usa datos ficticios. Las sesiones se guardan en memoria; faltan medidas de producción (HTTPS, cuentas individuales, auditoría de accesos, validación clínica, permisos por médico y resguardo de datos).

## Conservar tu base de datos anterior
**No elimines contenedores ni volúmenes.** Usa tu contenedor `sicec-mysql` ya creado, puerto 3307. No vuelvas a importar archivos SQL si ya importaste ambos.

## Abrir
1. Descomprime el ZIP y abre `SICEC_Docker_MySQL` en VS Code.
2. Copia tu `.env` del proyecto anterior a esta carpeta. Agrega `ADMIN_PASSWORD`, `DOCTOR_PASSWORD`, `PATIENT_PASSWORD` y `PATIENT_DEMO_ID=4` siguiendo `.env.example`. No publiques `.env`.
3. Detén el Node anterior en el puerto 3001 (Ctrl+C), sin tocar Docker.
4. Ejecuta `npm install` y `npm start`.
5. Abre http://localhost:3001/login.html e ingresa con la contraseña según rol.

## Archivos
- `public/administrador.html` + `public/css/administrador.css` + `public/js/administrador.js`
- `public/medico.html` + `public/css/medico.css` + `public/js/app.js` y `public/js/medico.js`
- `public/paciente.html` + `public/css/paciente.css` + `public/js/paciente.js`
- `public/login.html` + `public/css/login.css` + `public/js/login.js`
- `server.js` API conectada a la tabla real `pacientes`, `encuentros` y estado JSON existente.

## Borrar pacientes
El botón **Dar de baja** pone `activo=0`. No elimina físicamente el registro ni el historial. El administrador puede reactivar pacientes. El panel médico también puede dar de baja. El paciente solo puede consultar el expediente definido en `PATIENT_DEMO_ID`.

## Limitaciones
La interfaz médica original sigue almacenando recetas, notas, agenda y algunos campos clínicos en la tabla `sicec_estado` como JSON, no en tablas clínicas independientes. El botón de consulta crea un encuentro en MySQL con el médico 1 y servicio 1 de la demostración. **La página del médico contiene funciones de prototipo**, y aún requiere completar el flujo integral antes de producción.
