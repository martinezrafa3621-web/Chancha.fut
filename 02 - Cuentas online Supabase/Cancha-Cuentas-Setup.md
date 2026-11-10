# Cancha.fut · cuentas online (borrador de conexión)

La interfaz de cuenta y sincronización está preparada en los HTML. Esta app usa Supabase Auth para correo/contraseña y una tabla con políticas RLS para guardar solo las preferencias del usuario autenticado.

## Falta conectar el proyecto

1. Crear un proyecto en Supabase.
2. En SQL Editor, ejecutar el archivo cancha-user-preferences.sql.
3. En Authentication → URL Configuration, añadir el dominio HTTPS publicado de Cancha como Site URL y Redirect URL.
4. En Authentication → Providers → Email, mantener confirmación por correo activada y configurar el correo de envío.
5. Copiar Project URL y Publishable key (prefijo sb_publishable_) a cancha-account-config.js; completar también siteUrl y actualizar termsVersion cuando se aprueben los términos.
6. Configurar secrets de Edge Function: CANCHA_SITE_URL (el dominio exacto, sin barra final), SUPABASE_PUBLISHABLE_KEY y SUPABASE_SECRET_KEY. Desplegar outputs/supabase/functions/delete-account con Supabase CLI. La clave secret solo va en Edge Function secrets.
7. Publicar los HTML, cancha-account-config.js, el logo y los sonidos en un hosting HTTPS.

La clave publishable puede estar en el navegador porque la tabla aplica RLS. Nunca pongas la clave sb_secret_ o service_role en el HTML ni la compartas por chat. La política de base de datos asegura que cada usuario solo lee y escribe su fila.

## Comportamiento preparado

- Alta, inicio y cierre de sesión con correo y contraseña.
- Confirmación de correo y recuperación de contraseña (requieren configurar URLs y correo en Supabase).
- Sincronización de ligas, equipos, datos de esos equipos y partidos favoritos.
- Migración de favoritos locales al crear la primera fila de la cuenta.
- Sesión renovable para mantener el acceso al volver a abrir la web.
- Aceptación registrada con versión y fecha.

## Pendiente antes de abrir registros al público

Reemplazar los campos entre corchetes de los documentos de privacidad y términos con la identidad y correo de contacto del responsable, validar condiciones de Supabase y hosting, desplegar y validar la función de borrado de cuentas y revisar los textos legalmente. La app muestra un aviso si el backend no está configurado; no afirma que las cuentas estén activas.
