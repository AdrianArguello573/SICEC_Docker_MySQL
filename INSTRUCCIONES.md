# SICEC — Docker + MySQL

Este paquete conserva el diseño de la interfaz original y añade una API Node.js que guarda el estado de la aplicación en MySQL. También sincroniza los datos básicos de pacientes con la tabla `pacientes` de tu SQL original. Agenda, recetas, consultas y estudios se guardan dentro de `sicec_estado` como JSON; **todavía no se han normalizado a tablas clínicas independientes**.

## Requisitos
Docker Desktop encendido, Node.js 20+ y VS Code. No usar Live Server para esta versión: el servidor Express entrega la página.

## Instalación inicial (PowerShell en VS Code)

1. Abrir esta carpeta en VS Code.
2. Crear contenedor exclusivo, puerto 3307 (no modifica otros contenedores):

```powershell
docker run -d --name sicec-mysql --restart unless-stopped -e MYSQL_ROOT_PASSWORD=ClaveRootLocal2026 -e MYSQL_DATABASE=hospital_nom004 -e MYSQL_USER=sicec_app -e MYSQL_PASSWORD=ClaveSicecLocal2026 -p 127.0.0.1:3307:3306 -v sicec_mysql_data:/var/lib/mysql mysql:8.0
```

3. Esperar a que inicie (`docker logs sicec-mysql`). **Solo en una base nueva y vacía**, importar los SQL en orden:

```powershell
Get-Content -Raw -Encoding UTF8 .\database\01_hospital_nom004.sql | docker exec -i sicec-mysql mysql -uroot -pClaveRootLocal2026 hospital_nom004
Get-Content -Raw -Encoding UTF8 .\database\02_sicec.sql | docker exec -i sicec-mysql mysql -uroot -pClaveRootLocal2026 hospital_nom004
```

4. Crear `.env` copiando `.env.example` y colocar `DB_PASSWORD=ClaveSicecLocal2026`.
5. Ejecutar:

```powershell
npm install
npm start
```

6. Abrir http://localhost:3001 y comprobar http://localhost:3001/api/salud.

**No importar nuevamente el SQL original en una base que tenga datos:** el dump contiene `DROP TABLE` y eliminaría tablas existentes. Las contraseñas anteriores son ejemplos para desarrollo local; cámbialas antes de usar datos reales.

## Limitaciones importantes
Esta es una integración funcional de desarrollo, no un sistema clínico listo para producción: faltan inicio de sesión, roles, autorización, bitácora de accesos, protección contra ediciones concurrentes, copias de seguridad y validación clínica. No usar con datos reales de pacientes ni publicar el puerto 3001 en Internet. El botón «restablecer demo» elimina el estado JSON, pero no elimina pacientes de la tabla SQL.
